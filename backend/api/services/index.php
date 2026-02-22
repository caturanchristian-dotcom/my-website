<?php
/**
 * Services API
 * GET /api/services/ - Get all services
 * GET /api/services/?id=1 - Get single service
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    // Check if specific service ID is requested
    if (isset($_GET['id'])) {
        $serviceId = (int)$_GET['id'];
        
        // Get service details
        $query = "SELECT * FROM services WHERE id = :id AND is_active = TRUE";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $serviceId);
        $stmt->execute();
        
        if ($stmt->rowCount() > 0) {
            $service = $stmt->fetch(PDO::FETCH_ASSOC);
            
            // Get requirements
            $reqQuery = "SELECT requirement, is_mandatory FROM service_requirements 
                        WHERE service_id = :id ORDER BY display_order";
            $reqStmt = $db->prepare($reqQuery);
            $reqStmt->bindParam(":id", $serviceId);
            $reqStmt->execute();
            $requirements = $reqStmt->fetchAll(PDO::FETCH_ASSOC);
            
            $service['requirements'] = $requirements;
            $service['fee'] = (float)$service['fee'];
            
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "data" => $service
            ]);
        } else {
            http_response_code(404);
            echo json_encode([
                "success" => false,
                "message" => "Service not found."
            ]);
        }
    } else {
        // Get all active services
        $query = "SELECT * FROM services WHERE is_active = TRUE ORDER BY display_order, name";
        $stmt = $db->prepare($query);
        $stmt->execute();
        
        $services = [];
        
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            // Get requirements for each service
            $reqQuery = "SELECT requirement FROM service_requirements 
                        WHERE service_id = :id AND is_mandatory = TRUE 
                        ORDER BY display_order";
            $reqStmt = $db->prepare($reqQuery);
            $reqStmt->bindParam(":id", $row['id']);
            $reqStmt->execute();
            $requirements = $reqStmt->fetchAll(PDO::FETCH_COLUMN);
            
            $services[] = [
                "id" => (int)$row['id'],
                "name" => $row['name'],
                "slug" => $row['slug'],
                "description" => $row['description'],
                "requirements" => $requirements,
                "processingTime" => $row['processing_time'],
                "fee" => $row['fee'] == 0 ? "Free" : "₱" . number_format($row['fee'], 2),
                "validity" => $row['validity_period'],
                "icon" => $row['icon'],
                "category" => $row['category'],
                "isOnlineAvailable" => (bool)$row['is_online_available']
            ];
        }
        
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "data" => $services,
            "total" => count($services)
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
