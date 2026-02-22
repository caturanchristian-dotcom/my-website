<?php
/**
 * User Login API
 * POST /api/auth/login.php
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
if (empty($data->email) || empty($data->password)) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Email and password are required."
    ]);
    exit();
}

$database = new Database();
$db = $database->getConnection();

try {
    // Get user by email
    $query = "SELECT u.*, up.first_name, up.middle_name, up.last_name, up.phone, up.mobile, 
              CONCAT(up.address_street, ', ', up.address_purok, ', ', up.address_barangay) as address,
              up.profile_photo
              FROM users u
              LEFT JOIN user_profiles up ON u.id = up.user_id
              WHERE u.email = :email AND u.status = 'active'
              LIMIT 1";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(":email", $data->email);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        // Verify password
        if (password_verify($data->password, $user['password'])) {
            // Remove password from response
            unset($user['password']);
            
            // Generate session token (simple implementation)
            $token = bin2hex(random_bytes(32));
            
            // Update last login
            $updateQuery = "UPDATE users SET updated_at = NOW() WHERE id = :id";
            $updateStmt = $db->prepare($updateQuery);
            $updateStmt->bindParam(":id", $user['id']);
            $updateStmt->execute();
            
            // Log activity
            $logQuery = "INSERT INTO activity_logs (user_id, action, module, ip_address, user_agent) 
                        VALUES (:user_id, 'login', 'auth', :ip, :ua)";
            $logStmt = $db->prepare($logQuery);
            $logStmt->bindParam(":user_id", $user['id']);
            $logStmt->bindParam(":ip", $_SERVER['REMOTE_ADDR']);
            $logStmt->bindParam(":ua", $_SERVER['HTTP_USER_AGENT']);
            $logStmt->execute();
            
            // Format user data
            $userData = [
                "id" => (int)$user['id'],
                "email" => $user['email'],
                "name" => trim($user['first_name'] . ' ' . $user['middle_name'] . ' ' . $user['last_name']),
                "role" => $user['role'],
                "phone" => $user['phone'] ?? $user['mobile'],
                "address" => $user['address'],
                "avatar" => $user['profile_photo']
            ];
            
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "message" => "Login successful.",
                "user" => $userData,
                "token" => $token
            ]);
        } else {
            http_response_code(401);
            echo json_encode([
                "success" => false,
                "message" => "Invalid email or password."
            ]);
        }
    } else {
        http_response_code(401);
        echo json_encode([
            "success" => false,
            "message" => "Invalid email or password."
        ]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Server error. Please try again later.",
        "error" => $e->getMessage()
    ]);
}
?>
