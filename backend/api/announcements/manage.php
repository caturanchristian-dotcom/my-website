<?php
/**
 * Manage Announcements API (Admin)
 * POST - Create announcement
 * PUT - Update announcement
 * DELETE - Delete announcement
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents("php://input"));

try {
    switch ($method) {
        // CREATE
        case 'POST':
            if (empty($data->title) || empty($data->content)) {
                http_response_code(400);
                echo json_encode([
                    "success" => false,
                    "message" => "Title and content are required."
                ]);
                exit();
            }

            // Generate slug
            $slug = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $data->title)));
            $slug = $slug . '-' . time();

            $query = "INSERT INTO announcements 
                      (title, slug, content, excerpt, category, image, event_date, event_time, 
                       event_location, is_featured, is_published, published_at, author_id, created_at) 
                      VALUES (:title, :slug, :content, :excerpt, :category, :image, :event_date, 
                              :event_time, :event_location, :is_featured, :is_published, 
                              :published_at, :author_id, NOW())";
            
            $stmt = $db->prepare($query);
            $stmt->bindParam(":title", $data->title);
            $stmt->bindParam(":slug", $slug);
            $stmt->bindParam(":content", $data->content);
            $excerpt = $data->excerpt ?? substr(strip_tags($data->content), 0, 150);
            $stmt->bindParam(":excerpt", $excerpt);
            $category = $data->category ?? 'news';
            $stmt->bindParam(":category", $category);
            $image = $data->image ?? null;
            $stmt->bindParam(":image", $image);
            $eventDate = $data->event_date ?? null;
            $stmt->bindParam(":event_date", $eventDate);
            $eventTime = $data->event_time ?? null;
            $stmt->bindParam(":event_time", $eventTime);
            $eventLocation = $data->event_location ?? null;
            $stmt->bindParam(":event_location", $eventLocation);
            $isFeatured = $data->is_featured ?? false;
            $stmt->bindParam(":is_featured", $isFeatured, PDO::PARAM_BOOL);
            $isPublished = $data->is_published ?? true;
            $stmt->bindParam(":is_published", $isPublished, PDO::PARAM_BOOL);
            $publishedAt = $isPublished ? date('Y-m-d H:i:s') : null;
            $stmt->bindParam(":published_at", $publishedAt);
            $authorId = $data->author_id ?? null;
            $stmt->bindParam(":author_id", $authorId);
            $stmt->execute();

            $announcementId = $db->lastInsertId();

            http_response_code(201);
            echo json_encode([
                "success" => true,
                "message" => "Announcement created successfully.",
                "data" => [
                    "id" => (int)$announcementId,
                    "slug" => $slug
                ]
            ]);
            break;

        // UPDATE
        case 'PUT':
            if (empty($data->id)) {
                http_response_code(400);
                echo json_encode([
                    "success" => false,
                    "message" => "Announcement ID is required."
                ]);
                exit();
            }

            $updates = [];
            $params = [":id" => $data->id];

            if (isset($data->title)) {
                $updates[] = "title = :title";
                $params[":title"] = $data->title;
            }
            if (isset($data->content)) {
                $updates[] = "content = :content";
                $params[":content"] = $data->content;
            }
            if (isset($data->excerpt)) {
                $updates[] = "excerpt = :excerpt";
                $params[":excerpt"] = $data->excerpt;
            }
            if (isset($data->category)) {
                $updates[] = "category = :category";
                $params[":category"] = $data->category;
            }
            if (isset($data->image)) {
                $updates[] = "image = :image";
                $params[":image"] = $data->image;
            }
            if (isset($data->event_date)) {
                $updates[] = "event_date = :event_date";
                $params[":event_date"] = $data->event_date;
            }
            if (isset($data->event_location)) {
                $updates[] = "event_location = :event_location";
                $params[":event_location"] = $data->event_location;
            }
            if (isset($data->is_featured)) {
                $updates[] = "is_featured = :is_featured";
                $params[":is_featured"] = $data->is_featured ? 1 : 0;
            }
            if (isset($data->is_published)) {
                $updates[] = "is_published = :is_published";
                $params[":is_published"] = $data->is_published ? 1 : 0;
                if ($data->is_published) {
                    $updates[] = "published_at = COALESCE(published_at, NOW())";
                }
            }

            $updates[] = "updated_at = NOW()";

            $query = "UPDATE announcements SET " . implode(", ", $updates) . " WHERE id = :id";
            $stmt = $db->prepare($query);
            foreach ($params as $key => $value) {
                $stmt->bindValue($key, $value);
            }
            $stmt->execute();

            if ($stmt->rowCount() > 0) {
                http_response_code(200);
                echo json_encode([
                    "success" => true,
                    "message" => "Announcement updated successfully."
                ]);
            } else {
                http_response_code(404);
                echo json_encode([
                    "success" => false,
                    "message" => "Announcement not found or no changes made."
                ]);
            }
            break;

        // DELETE
        case 'DELETE':
            $id = $_GET['id'] ?? $data->id ?? null;
            
            if (empty($id)) {
                http_response_code(400);
                echo json_encode([
                    "success" => false,
                    "message" => "Announcement ID is required."
                ]);
                exit();
            }

            $query = "DELETE FROM announcements WHERE id = :id";
            $stmt = $db->prepare($query);
            $stmt->bindParam(":id", $id);
            $stmt->execute();

            if ($stmt->rowCount() > 0) {
                http_response_code(200);
                echo json_encode([
                    "success" => true,
                    "message" => "Announcement deleted successfully."
                ]);
            } else {
                http_response_code(404);
                echo json_encode([
                    "success" => false,
                    "message" => "Announcement not found."
                ]);
            }
            break;

        // GET (for admin - includes unpublished)
        case 'GET':
            $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
            $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 20;
            $offset = ($page - 1) * $limit;

            $query = "SELECT * FROM announcements ORDER BY created_at DESC LIMIT :limit OFFSET :offset";
            $stmt = $db->prepare($query);
            $stmt->bindParam(":limit", $limit, PDO::PARAM_INT);
            $stmt->bindParam(":offset", $offset, PDO::PARAM_INT);
            $stmt->execute();

            $announcements = $stmt->fetchAll(PDO::FETCH_ASSOC);

            $countStmt = $db->query("SELECT COUNT(*) as total FROM announcements");
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
            break;

        default:
            http_response_code(405);
            echo json_encode([
                "success" => false,
                "message" => "Method not allowed."
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
