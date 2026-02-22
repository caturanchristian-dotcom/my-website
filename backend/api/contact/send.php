<?php
/**
 * Contact Form API
 * POST /api/contact/send.php
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
if (empty($data->name) || empty($data->email) || empty($data->subject) || empty($data->message)) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Name, email, subject, and message are required."
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

$database = new Database();
$db = $database->getConnection();

try {
    $query = "INSERT INTO contact_messages (name, email, phone, subject, message, status, ip_address, user_agent, created_at) 
              VALUES (:name, :email, :phone, :subject, :message, 'unread', :ip, :ua, NOW())";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(":name", $data->name);
    $stmt->bindParam(":email", $data->email);
    $phone = $data->phone ?? null;
    $stmt->bindParam(":phone", $phone);
    $stmt->bindParam(":subject", $data->subject);
    $stmt->bindParam(":message", $data->message);
    $stmt->bindParam(":ip", $_SERVER['REMOTE_ADDR']);
    $stmt->bindParam(":ua", $_SERVER['HTTP_USER_AGENT']);
    $stmt->execute();

    $messageId = $db->lastInsertId();

    // Create notification for admin
    $notifQuery = "INSERT INTO notifications (user_id, type, title, message, data, created_at) 
                   SELECT id, 'contact_message', 'New Contact Message', :notif_message, :notif_data, NOW()
                   FROM users WHERE role = 'admin' LIMIT 1";
    $notifStmt = $db->prepare($notifQuery);
    $notifMessage = "New message from {$data->name}: {$data->subject}";
    $notifStmt->bindParam(":notif_message", $notifMessage);
    $notifData = json_encode(["message_id" => $messageId]);
    $notifStmt->bindParam(":notif_data", $notifData);
    $notifStmt->execute();

    http_response_code(201);
    echo json_encode([
        "success" => true,
        "message" => "Thank you! Your message has been sent successfully. We will get back to you soon.",
        "data" => [
            "id" => (int)$messageId
        ]
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Failed to send message. Please try again later.",
        "error" => $e->getMessage()
    ]);
}
?>
