<?php
/**
 * Update Service Request API (Admin)
 * PUT /api/requests/update.php
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: PUT, POST");
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
if (empty($data->id)) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Request ID is required."
    ]);
    exit();
}

$database = new Database();
$db = $database->getConnection();

try {
    // Check if request exists
    $checkQuery = "SELECT sr.*, s.name as service_name, u.email as user_email 
                   FROM service_requests sr 
                   JOIN services s ON sr.service_id = s.id
                   JOIN users u ON sr.user_id = u.id
                   WHERE sr.id = :id";
    $checkStmt = $db->prepare($checkQuery);
    $checkStmt->bindParam(":id", $data->id);
    $checkStmt->execute();
    
    if ($checkStmt->rowCount() === 0) {
        http_response_code(404);
        echo json_encode([
            "success" => false,
            "message" => "Request not found."
        ]);
        exit();
    }
    
    $request = $checkStmt->fetch(PDO::FETCH_ASSOC);
    $oldStatus = $request['status'];

    // Begin transaction
    $db->beginTransaction();

    // Build update query dynamically
    $updates = [];
    $params = [":id" => $data->id];

    if (isset($data->status)) {
        $updates[] = "status = :status";
        $params[":status"] = $data->status;
    }
    if (isset($data->notes)) {
        $updates[] = "notes = :notes";
        $params[":notes"] = $data->notes;
    }
    if (isset($data->scheduled_date)) {
        $updates[] = "scheduled_date = :scheduled_date";
        $params[":scheduled_date"] = $data->scheduled_date;
    }
    if (isset($data->payment_status)) {
        $updates[] = "payment_status = :payment_status";
        $params[":payment_status"] = $data->payment_status;
        if ($data->payment_status === 'paid') {
            $updates[] = "payment_date = NOW()";
        }
    }
    if (isset($data->processed_by)) {
        $updates[] = "processed_by = :processed_by";
        $params[":processed_by"] = $data->processed_by;
    }
    if (isset($data->rejection_reason)) {
        $updates[] = "rejection_reason = :rejection_reason";
        $params[":rejection_reason"] = $data->rejection_reason;
    }

    // Check if status is being changed to completed
    if (isset($data->status) && $data->status === 'completed') {
        $updates[] = "completed_date = CURDATE()";
    }

    $updates[] = "updated_at = NOW()";

    $updateQuery = "UPDATE service_requests SET " . implode(", ", $updates) . " WHERE id = :id";
    $updateStmt = $db->prepare($updateQuery);
    
    foreach ($params as $key => $value) {
        $updateStmt->bindValue($key, $value);
    }
    $updateStmt->execute();

    // Add tracking entry if status changed
    if (isset($data->status) && $data->status !== $oldStatus) {
        $remarks = $data->notes ?? "Status updated to " . ucfirst($data->status);
        $trackQuery = "INSERT INTO request_tracking (request_id, status, remarks, updated_by, created_at) 
                       VALUES (:request_id, :status, :remarks, :updated_by, NOW())";
        $trackStmt = $db->prepare($trackQuery);
        $trackStmt->bindParam(":request_id", $data->id);
        $trackStmt->bindParam(":status", $data->status);
        $trackStmt->bindParam(":remarks", $remarks);
        $updatedBy = $data->updated_by ?? null;
        $trackStmt->bindParam(":updated_by", $updatedBy);
        $trackStmt->execute();

        // Create notification for user
        $statusMessages = [
            'processing' => "Your request for {$request['service_name']} is now being processed.",
            'for_pickup' => "Your {$request['service_name']} is ready for pickup at the Barangay Hall.",
            'completed' => "Your request for {$request['service_name']} has been completed.",
            'rejected' => "Your request for {$request['service_name']} has been rejected. Reason: " . ($data->rejection_reason ?? 'N/A')
        ];

        if (isset($statusMessages[$data->status])) {
            $notifQuery = "INSERT INTO notifications (user_id, type, title, message, data, created_at) 
                           VALUES (:user_id, :type, :title, :message, :data, NOW())";
            $notifStmt = $db->prepare($notifQuery);
            $notifStmt->bindParam(":user_id", $request['user_id']);
            $notifType = "request_" . $data->status;
            $notifStmt->bindParam(":type", $notifType);
            $notifTitle = "Request " . ucfirst($data->status);
            $notifStmt->bindParam(":title", $notifTitle);
            $notifStmt->bindParam(":message", $statusMessages[$data->status]);
            $notifData = json_encode(["request_id" => $data->id, "request_number" => $request['request_number']]);
            $notifStmt->bindParam(":data", $notifData);
            $notifStmt->execute();
        }
    }

    // Log activity
    $logQuery = "INSERT INTO activity_logs (user_id, action, module, record_id, record_type, old_values, new_values, created_at) 
                VALUES (:user_id, 'update_request', 'service_requests', :record_id, 'service_request', :old_values, :new_values, NOW())";
    $logStmt = $db->prepare($logQuery);
    $logStmt->bindValue(":user_id", $data->updated_by ?? null);
    $logStmt->bindParam(":record_id", $data->id);
    $oldValues = json_encode(["status" => $oldStatus]);
    $logStmt->bindParam(":old_values", $oldValues);
    $newValues = json_encode(["status" => $data->status ?? $oldStatus]);
    $logStmt->bindParam(":new_values", $newValues);
    $logStmt->execute();

    // Commit transaction
    $db->commit();

    http_response_code(200);
    echo json_encode([
        "success" => true,
        "message" => "Request updated successfully."
    ]);

} catch (PDOException $e) {
    $db->rollBack();
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Failed to update request. Please try again later.",
        "error" => $e->getMessage()
    ]);
}
?>
