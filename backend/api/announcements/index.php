<?php
/**
 * Announcements API
 * GET /api/announcements/ - Get all published announcements
 * GET /api/announcements/?id=1 - Get single announcement
 * GET /api/announcements/?category=news - Filter by category
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    // Get single announcement
    if (isset($_GET['id'])) {
        $id = (int)$_GET['id'];
        
        $query = "SELECT a.*, CONCAT(up.first_name, ' ', up.last_name) as author_name
                  FROM announcements a
                  LEFT JOIN users u ON a.author_id = u.id
                  LEFT JOIN user_profiles up ON u.id = up.user_id
                  WHERE a.id = :id AND a.is_published = TRUE";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->execute();
        
        if ($stmt->rowCount() > 0) {
            $announcement = $stmt->fetch(PDO::FETCH_ASSOC);
            
            // Increment view count
            $updateQuery = "UPDATE announcements SET views = views + 1 WHERE id = :id";
            $updateStmt = $db->prepare($updateQuery);
            $updateStmt->bindParam(":id", $id);
            $updateStmt->execute();
            
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "data" => [
                    "id" => (int)$announcement['id'],
                    "title" => $announcement['title'],
                    "slug" => $announcement['slug'],
                    "content" => $announcement['content'],
                    "excerpt" => $announcement['excerpt'],
                    "category" => $announcement['category'],
                    "image" => $announcement['image'],
                    "eventDate" => $announcement['event_date'],
                    "eventTime" => $announcement['event_time'],
                    "eventLocation" => $announcement['event_location'],
                    "isFeatured" => (bool)$announcement['is_featured'],
                    "views" => (int)$announcement['views'] + 1,
                    "author" => $announcement['author_name'],
                    "publishedAt" => $announcement['published_at'],
                    "date" => date('Y-m-d', strtotime($announcement['created_at']))
                ]
            ]);
        } else {
            http_response_code(404);
            echo json_encode([
                "success" => false,
                "message" => "Announcement not found."
            ]);
        }
    }
    // Get all announcements
    else {
        $category = $_GET['category'] ?? null;
        $featured = isset($_GET['featured']) ? (bool)$_GET['featured'] : null;
        $search = $_GET['search'] ?? null;
        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 10;
        $offset = ($page - 1) * $limit;
        
        $whereConditions = ["a.is_published = TRUE"];
        $params = [];
        
        if ($category && $category !== 'all') {
            $whereConditions[] = "a.category = :category";
            $params[":category"] = $category;
        }
        
        if ($featured !== null) {
            $whereConditions[] = "a.is_featured = :featured";
            $params[":featured"] = $featured ? 1 : 0;
        }
        
        if ($search) {
            $whereConditions[] = "(a.title LIKE :search OR a.content LIKE :search)";
            $params[":search"] = "%{$search}%";
        }
        
        $whereClause = implode(" AND ", $whereConditions);
        
        $query = "SELECT a.id, a.title, a.slug, a.excerpt, a.content, a.category, a.image,
                  a.event_date, a.event_location, a.is_featured, a.views, a.published_at, a.created_at
                  FROM announcements a
                  WHERE {$whereClause}
                  ORDER BY a.is_featured DESC, a.published_at DESC
                  LIMIT :limit OFFSET :offset";
        
        $stmt = $db->prepare($query);
        foreach ($params as $key => $value) {
            $stmt->bindValue($key, $value);
        }
        $stmt->bindParam(":limit", $limit, PDO::PARAM_INT);
        $stmt->bindParam(":offset", $offset, PDO::PARAM_INT);
        $stmt->execute();
        
        $announcements = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $announcements[] = [
                "id" => (int)$row['id'],
                "title" => $row['title'],
                "slug" => $row['slug'],
                "excerpt" => $row['excerpt'] ?? substr(strip_tags($row['content']), 0, 150) . '...',
                "content" => $row['content'],
                "category" => $row['category'],
                "image" => $row['image'],
                "eventDate" => $row['event_date'],
                "eventLocation" => $row['event_location'],
                "isFeatured" => (bool)$row['is_featured'],
                "views" => (int)$row['views'],
                "date" => date('Y-m-d', strtotime($row['published_at'] ?? $row['created_at']))
            ];
        }
        
        // Get total count
        $countQuery = "SELECT COUNT(*) as total FROM announcements a WHERE {$whereClause}";
        $countStmt = $db->prepare($countQuery);
        foreach ($params as $key => $value) {
            $countStmt->bindValue($key, $value);
        }
        $countStmt->execute();
        $total = $countStmt->fetch(PDO::FETCH_ASSOC)['total'];
        
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "data" => $announcements,
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
