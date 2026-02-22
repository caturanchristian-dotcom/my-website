<?php
/**
 * Service Requests API
 * GET /api/requests/ - Get all requests (admin)
 * GET /api/requests/?user_id=1 - Get user's requests
 * GET /api/requests/?id=1 - Get single request
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    // Get single request
    if (isset($_GET['id'])) {
        $requestId = (int)$_GET['id'];
        
        $query = "SELECT sr.*, s.name as service_name, s.fee, s.processing_time,
                  CONCAT(up.first_name, ' ', up.last_name) as user_name,
                  u.email as user_email, up.phone as user_phone
                  FROM service_requests sr
                  JOIN services s ON sr.service_id = s.id
                  JOIN users u ON sr.user_id = u.id
                  JOIN user_profiles up ON u.id = up.user_id
                  WHERE sr.id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $requestId);
        $stmt->execute();
        
        if ($stmt->rowCount() > 0) {
            $request = $stmt->fetch(PDO::FETCH_ASSOC);
            
            // Get tracking history
            $trackQuery = "SELECT status, remarks, created_at FROM request_tracking 
                          WHERE request_id = :id ORDER BY created_at DESC";
            $trackStmt = $db->prepare($trackQuery);
            $trackStmt->bindParam(":id", $requestId);
            $trackStmt->execute();
            $tracking = $trackStmt->fetchAll(PDO::FETCH_ASSOC);
            
            $request['tracking'] = $tracking;
            
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "data" => $request
            ]);
        } else {
            http_response_code(404);
            echo json_encode([
                "success" => false,
                "message" => "Request not found."
            ]);
        }
    }
    // Get user's requests
    else if (isset($_GET['user_id'])) {
        $userId = (int)$_GET['user_id'];
        
        $query = "SELECT sr.id, sr.request_number, sr.purpose, sr.status, sr.priority,
                  sr.payment_status, sr.scheduled_date, sr.created_at,
                  s.name as service_name, s.fee
                  FROM service_requests sr
                  JOIN services s ON sr.service_id = s.id
                  WHERE sr.user_id = :user_id
                  ORDER BY sr.created_at DESC";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":user_id", $userId);
        $stmt->execute();
        
        $requests = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $requests[] = [
                "id" => (int)$row['id'],
                "requestNumber" => $row['request_number'],
                "serviceName" => $row['service_name'],
                "purpose" => $row['purpose'],
                "status" => $row['status'],
                "priority" => $row['priority'],
                "paymentStatus" => $row['payment_status'],
                "fee" => (float)$row['fee'],
                "scheduledDate" => $row['scheduled_date'],
                "date" => date('Y-m-d', strtotime($row['created_at']))
            ];
        }
        
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "data" => $requests,
            "total" => count($requests)
        ]);
    }
    // Get all requests (admin)
    else {
        $status = $_GET['status'] ?? null;
        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 20;
        $offset = ($page - 1) * $limit;
        
        $whereClause = "";
        if ($status && $status !== 'all') {
            $whereClause = "WHERE sr.status = :status";
        }
        
        $query = "SELECT sr.id, sr.request_number, sr.purpose, sr.status, sr.priority,
                  sr.payment_status, sr.scheduled_date, sr.notes, sr.created_at,
                  s.name as service_name, s.fee,
                  CONCAT(up.first_name, ' ', up.last_name) as user_name,
                  u.email as user_email
                  FROM service_requests sr
                  JOIN services s ON sr.service_id = s.id
                  JOIN users u ON sr.user_id = u.id
                  JOIN user_profiles up ON u.id = up.user_id
                  {$whereClause}
                  ORDER BY sr.created_at DESC
                  LIMIT :limit OFFSET :offset";
        
        $stmt = $db->prepare($query);
        if ($status && $status !== 'all') {
            $stmt->bindParam(":status", $status);
        }
        $stmt->bindParam(":limit", $limit, PDO::PARAM_INT);
        $stmt->bindParam(":offset", $offset, PDO::PARAM_INT);
        $stmt->execute();
        
        $requests = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $requests[] = [
                "id" => (int)$row['id'],
                "requestNumber" => $row['request_number'],
                "serviceName" => $row['service_name'],
                "userName" => $row['user_name'],
                "userEmail" => $row['user_email'],
                "purpose" => $row['purpose'],
                "status" => $row['status'],
                "priority" => $row['priority'],
                "paymentStatus" => $row['payment_status'],
                "fee" => (float)$row['fee'],
                "notes" => $row['notes'],
                "scheduledDate" => $row['scheduled_date'],
                "date" => date('Y-m-d', strtotime($row['created_at']))
            ];
        }
        
        // Get total count
        $countQuery = "SELECT COUNT(*) as total FROM service_requests sr {$whereClause}";
        $countStmt = $db->prepare($countQuery);
        if ($status && $status !== 'all') {
            $countStmt->bindParam(":status", $status);
        }
        $countStmt->execute();
        $total = $countStmt->fetch(PDO::FETCH_ASSOC)['total'];
        
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "data" => $requests,
            "pagination" => [
                "page" => $page,
                "limit" => $limit,
                "total" => (int)$total,
                "pages" => ceil($total / $limit)
            ]
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
