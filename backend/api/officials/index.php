<?php
/**
 * Barangay Officials API
 * GET /api/officials/ - Get all active officials
 * GET /api/officials/?id=1 - Get single official
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    // Get single official
    if (isset($_GET['id'])) {
        $id = (int)$_GET['id'];
        
        $query = "SELECT * FROM officials WHERE id = :id AND is_active = TRUE";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->execute();
        
        if ($stmt->rowCount() > 0) {
            $official = $stmt->fetch(PDO::FETCH_ASSOC);
            
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "data" => [
                    "id" => (int)$official['id'],
                    "name" => $official['name'],
                    "position" => $official['position'],
                    "committee" => $official['committee'],
                    "termStart" => $official['term_start'],
                    "termEnd" => $official['term_end'],
                    "contact" => $official['contact_number'],
                    "email" => $official['email'],
                    "address" => $official['address'],
                    "photo" => $official['photo'],
                    "bio" => $official['bio']
                ]
            ]);
        } else {
            http_response_code(404);
            echo json_encode([
                "success" => false,
                "message" => "Official not found."
            ]);
        }
    }
    // Get all officials
    else {
        $query = "SELECT * FROM officials WHERE is_active = TRUE ORDER BY position_order, name";
        $stmt = $db->prepare($query);
        $stmt->execute();
        
        $officials = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $officials[] = [
                "id" => (int)$row['id'],
                "name" => $row['name'],
                "position" => $row['position'],
                "committee" => $row['committee'],
                "contact" => $row['contact_number'],
                "email" => $row['email'],
                "image" => $row['photo'],
                "bio" => $row['bio']
            ];
        }
        
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "data" => $officials,
            "total" => count($officials)
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
