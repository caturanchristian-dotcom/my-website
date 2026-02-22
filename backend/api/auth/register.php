<?php
/**
 * User Registration API
 * POST /api/auth/register.php
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Validate input
if (empty($data->email) || empty($data->password) || empty($data->name)) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Name, email, and password are required."
    ]);
    exit();
}

// Validate email format
if (!filter_var($data->email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Invalid email format."
    ]);
    exit();
}

// Validate password length
if (strlen($data->password) < 6) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Password must be at least 6 characters."
    ]);
    exit();
}

$database = new Database();
$db = $database->getConnection();

try {
    // Check if email already exists
    $checkQuery = "SELECT id FROM users WHERE email = :email";
    $checkStmt = $db->prepare($checkQuery);
    $checkStmt->bindParam(":email", $data->email);
    $checkStmt->execute();

    if ($checkStmt->rowCount() > 0) {
        http_response_code(409);
        echo json_encode([
            "success" => false,
            "message" => "Email already exists. Please use a different email."
        ]);
        exit();
    }

    // Parse name
    $nameParts = explode(' ', trim($data->name));
    $firstName = $nameParts[0];
    $middleName = count($nameParts) > 2 ? $nameParts[1] : null;
    $lastName = count($nameParts) > 1 ? end($nameParts) : '';

    // Hash password
    $hashedPassword = password_hash($data->password, PASSWORD_BCRYPT);

    // Begin transaction
    $db->beginTransaction();

    // Insert user
    $userQuery = "INSERT INTO users (email, password, role, status, created_at) 
                  VALUES (:email, :password, 'user', 'active', NOW())";
    $userStmt = $db->prepare($userQuery);
    $userStmt->bindParam(":email", $data->email);
    $userStmt->bindParam(":password", $hashedPassword);
    $userStmt->execute();

    $userId = $db->lastInsertId();

    // Insert user profile
    $profileQuery = "INSERT INTO user_profiles (user_id, first_name, middle_name, last_name, phone, address_street, created_at) 
                     VALUES (:user_id, :first_name, :middle_name, :last_name, :phone, :address, NOW())";
    $profileStmt = $db->prepare($profileQuery);
    $profileStmt->bindParam(":user_id", $userId);
    $profileStmt->bindParam(":first_name", $firstName);
    $profileStmt->bindParam(":middle_name", $middleName);
    $profileStmt->bindParam(":last_name", $lastName);
    $phone = $data->phone ?? null;
    $profileStmt->bindParam(":phone", $phone);
    $address = $data->address ?? null;
    $profileStmt->bindParam(":address", $address);
    $profileStmt->execute();

    // Create welcome notification
    $notifQuery = "INSERT INTO notifications (user_id, type, title, message, created_at) 
                   VALUES (:user_id, 'welcome', 'Welcome to Barangay Portal!', 
                   'Thank you for registering. You can now request services and track your transactions online.', NOW())";
    $notifStmt = $db->prepare($notifQuery);
    $notifStmt->bindParam(":user_id", $userId);
    $notifStmt->execute();

    // Log activity
    $logQuery = "INSERT INTO activity_logs (user_id, action, module, ip_address, user_agent, created_at) 
                VALUES (:user_id, 'register', 'auth', :ip, :ua, NOW())";
    $logStmt = $db->prepare($logQuery);
    $logStmt->bindParam(":user_id", $userId);
    $logStmt->bindParam(":ip", $_SERVER['REMOTE_ADDR']);
    $logStmt->bindParam(":ua", $_SERVER['HTTP_USER_AGENT']);
    $logStmt->execute();

    // Commit transaction
    $db->commit();

    // Generate token
    $token = bin2hex(random_bytes(32));

    // Return user data
    $userData = [
        "id" => (int)$userId,
        "email" => $data->email,
        "name" => trim($data->name),
        "role" => "user",
        "phone" => $phone,
        "address" => $address
    ];

    http_response_code(201);
    echo json_encode([
        "success" => true,
        "message" => "Registration successful.",
        "user" => $userData,
        "token" => $token
    ]);

} catch (PDOException $e) {
    $db->rollBack();
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Registration failed. Please try again later.",
        "error" => $e->getMessage()
    ]);
}
?>
