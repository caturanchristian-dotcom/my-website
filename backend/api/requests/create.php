<?php
/**
 * Create Service Request API
 * POST /api/requests/create.php
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
if (empty($data->user_id) || empty($data->service_id)) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "User ID and Service ID are required."
    ]);
    exit();
}

$database = new Database();
$db = $database->getConnection();

try {
    // Verify user exists
    $userQuery = "SELECT u.id, up.first_name, up.last_name FROM users u 
                  JOIN user_profiles up ON u.id = up.user_id 
                  WHERE u.id = :id AND u.status = 'active'";
    $userStmt = $db->prepare($userQuery);
    $userStmt->bindParam(":id", $data->user_id);
    $userStmt->execute();
    
    if ($userStmt->rowCount() === 0) {
        http_response_code(404);
        echo json_encode([
            "success" => false,
            "message" => "User not found."
        ]);
        exit();
    }
    $user = $userStmt->fetch(PDO::FETCH_ASSOC);

    // Verify service exists
    $serviceQuery = "SELECT id, name, fee FROM services WHERE id = :id AND is_active = TRUE";
    $serviceStmt = $db->prepare($serviceQuery);
    $serviceStmt->bindParam(":id", $data->service_id);
    $serviceStmt->execute();
    
    if ($serviceStmt->rowCount() === 0) {
        http_response_code(404);
        echo json_encode([
            "success" => false,
            "message" => "Service not found."
        ]);
        exit();
    }
    $service = $serviceStmt->fetch(PDO::FETCH_ASSOC);

    // Generate request number
    $year = date('Y');
    $countQuery = "SELECT COUNT(*) + 1 as next_num FROM service_requests WHERE YEAR(created_at) = :year";
    $countStmt = $db->prepare($countQuery);
    $countStmt->bindParam(":year", $year);
    $countStmt->execute();
    $countResult = $countStmt->fetch(PDO::FETCH_ASSOC);
    $requestNumber = "REQ-{$year}-" . str_pad($countResult['next_num'], 4, '0', STR_PAD_LEFT);

    // Begin transaction
    $db->beginTransaction();

    // Insert service request
    $insertQuery = "INSERT INTO service_requests 
                    (request_number, user_id, service_id, purpose, status, priority, payment_status, created_at) 
                    VALUES (:request_number, :user_id, :service_id, :purpose, 'pending', :priority, 'unpaid', NOW())";
    $insertStmt = $db->prepare($insertQuery);
    $insertStmt->bindParam(":request_number", $requestNumber);
    $insertStmt->bindParam(":user_id", $data->user_id);
    $insertStmt->bindParam(":service_id", $data->service_id);
    $purpose = $data->purpose ?? null;
    $insertStmt->bindParam(":purpose", $purpose);
    $priority = $data->priority ?? 'normal';
    $insertStmt->bindParam(":priority", $priority);
    $insertStmt->execute();

    $requestId = $db->lastInsertId();

    // Add tracking entry
    $trackQuery = "INSERT INTO request_tracking (request_id, status, remarks, created_at) 
                   VALUES (:request_id, 'pending', 'Request submitted', NOW())";
    $trackStmt = $db->prepare($trackQuery);
    $trackStmt->bindParam(":request_id", $requestId);
    $trackStmt->execute();

    // Create notification for user
    $notifMessage = "Your request for {$service['name']} has been submitted. Request Number: {$requestNumber}";
    $notifQuery = "INSERT INTO notifications (user_id, type, title, message, data, created_at) 
                   VALUES (:user_id, 'request_submitted', 'Request Submitted', :message, :data, NOW())";
    $notifStmt = $db->prepare($notifQuery);
    $notifStmt->bindParam(":user_id", $data->user_id);
    $notifStmt->bindParam(":message", $notifMessage);
    $notifData = json_encode(["request_id" => $requestId, "request_number" => $requestNumber]);
    $notifStmt->bindParam(":data", $notifData);
    $notifStmt->execute();

    // Log activity
    $logQuery = "INSERT INTO activity_logs (user_id, action, module, record_id, record_type, created_at) 
                VALUES (:user_id, 'create_request', 'service_requests', :record_id, 'service_request', NOW())";
    $logStmt = $db->prepare($logQuery);
    $logStmt->bindParam(":user_id", $data->user_id);
    $logStmt->bindParam(":record_id", $requestId);
    $logStmt->execute();

    // Commit transaction
    $db->commit();

    http_response_code(201);
    echo json_encode([
        "success" => true,
        "message" => "Service request submitted successfully.",
        "data" => [
            "id" => (int)$requestId,
            "request_number" => $requestNumber,
            "service_name" => $service['name'],
            "fee" => (float)$service['fee'],
            "status" => "pending",
            "created_at" => date('Y-m-d H:i:s')
        ]
    ]);

} catch (PDOException $e) {
    $db->rollBack();
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Failed to submit request. Please try again later.",
        "error" => $e->getMessage()
    ]);
}
?>
