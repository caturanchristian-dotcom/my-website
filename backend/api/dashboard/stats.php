<?php
/**
 * Dashboard Statistics API (Admin)
 * GET /api/dashboard/stats.php
 */

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $stats = [];
    
    // Request statistics
    $requestStats = $db->query("
        SELECT 
            COUNT(*) as total,
            SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending,
            SUM(CASE WHEN status = 'processing' THEN 1 ELSE 0 END) as processing,
            SUM(CASE WHEN status = 'for_pickup' THEN 1 ELSE 0 END) as for_pickup,
            SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed,
            SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) as rejected
        FROM service_requests
    ")->fetch(PDO::FETCH_ASSOC);
    
    $stats['requests'] = [
        'total' => (int)$requestStats['total'],
        'pending' => (int)$requestStats['pending'],
        'processing' => (int)$requestStats['processing'],
        'forPickup' => (int)$requestStats['for_pickup'],
        'completed' => (int)$requestStats['completed'],
        'rejected' => (int)$requestStats['rejected']
    ];
    
    // Today's requests
    $todayRequests = $db->query("
        SELECT COUNT(*) as count FROM service_requests WHERE DATE(created_at) = CURDATE()
    ")->fetch(PDO::FETCH_ASSOC);
    $stats['requests']['today'] = (int)$todayRequests['count'];
    
    // This month's requests
    $monthRequests = $db->query("
        SELECT COUNT(*) as count FROM service_requests 
        WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())
    ")->fetch(PDO::FETCH_ASSOC);
    $stats['requests']['thisMonth'] = (int)$monthRequests['count'];
    
    // User statistics
    $userStats = $db->query("
        SELECT 
            COUNT(*) as total,
            SUM(CASE WHEN role = 'admin' THEN 1 ELSE 0 END) as admins,
            SUM(CASE WHEN role = 'staff' THEN 1 ELSE 0 END) as staff,
            SUM(CASE WHEN role = 'user' THEN 1 ELSE 0 END) as residents,
            SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active,
            SUM(CASE WHEN DATE(created_at) = CURDATE() THEN 1 ELSE 0 END) as new_today
        FROM users
    ")->fetch(PDO::FETCH_ASSOC);
    
    $stats['users'] = [
        'total' => (int)$userStats['total'],
        'admins' => (int)$userStats['admins'],
        'staff' => (int)$userStats['staff'],
        'residents' => (int)$userStats['residents'],
        'active' => (int)$userStats['active'],
        'newToday' => (int)$userStats['new_today']
    ];
    
    // Announcement statistics
    $announcementStats = $db->query("
        SELECT 
            COUNT(*) as total,
            SUM(CASE WHEN is_published = TRUE THEN 1 ELSE 0 END) as published,
            SUM(CASE WHEN is_featured = TRUE THEN 1 ELSE 0 END) as featured
        FROM announcements
    ")->fetch(PDO::FETCH_ASSOC);
    
    $stats['announcements'] = [
        'total' => (int)$announcementStats['total'],
        'published' => (int)$announcementStats['published'],
        'featured' => (int)$announcementStats['featured']
    ];
    
    // Blotter statistics
    $blotterStats = $db->query("
        SELECT 
            COUNT(*) as total,
            SUM(CASE WHEN status IN ('filed', 'under_investigation', 'for_mediation') THEN 1 ELSE 0 END) as active,
            SUM(CASE WHEN status IN ('settled', 'closed') THEN 1 ELSE 0 END) as resolved
        FROM blotters
    ")->fetch(PDO::FETCH_ASSOC);
    
    $stats['blotters'] = [
        'total' => (int)$blotterStats['total'],
        'active' => (int)$blotterStats['active'],
        'resolved' => (int)$blotterStats['resolved']
    ];
    
    // Contact messages
    $messageStats = $db->query("
        SELECT 
            COUNT(*) as total,
            SUM(CASE WHEN status = 'unread' THEN 1 ELSE 0 END) as unread
        FROM contact_messages
    ")->fetch(PDO::FETCH_ASSOC);
    
    $stats['messages'] = [
        'total' => (int)$messageStats['total'],
        'unread' => (int)$messageStats['unread']
    ];
    
    // Revenue statistics (this month)
    $revenueStats = $db->query("
        SELECT 
            COALESCE(SUM(amount), 0) as total_revenue,
            COUNT(*) as total_payments
        FROM payments 
        WHERE is_void = FALSE 
        AND YEAR(payment_date) = YEAR(CURDATE()) 
        AND MONTH(payment_date) = MONTH(CURDATE())
    ")->fetch(PDO::FETCH_ASSOC);
    
    $stats['revenue'] = [
        'thisMonth' => (float)$revenueStats['total_revenue'],
        'transactions' => (int)$revenueStats['total_payments']
    ];
    
    // Recent requests (last 5)
    $recentRequests = $db->query("
        SELECT sr.id, sr.request_number, sr.status, sr.created_at,
               s.name as service_name,
               CONCAT(up.first_name, ' ', up.last_name) as user_name
        FROM service_requests sr
        JOIN services s ON sr.service_id = s.id
        JOIN users u ON sr.user_id = u.id
        JOIN user_profiles up ON u.id = up.user_id
        ORDER BY sr.created_at DESC
        LIMIT 5
    ")->fetchAll(PDO::FETCH_ASSOC);
    
    $stats['recentRequests'] = array_map(function($row) {
        return [
            'id' => (int)$row['id'],
            'requestNumber' => $row['request_number'],
            'serviceName' => $row['service_name'],
            'userName' => $row['user_name'],
            'status' => $row['status'],
            'date' => date('Y-m-d H:i', strtotime($row['created_at']))
        ];
    }, $recentRequests);
    
    // Request trends (last 7 days)
    $trends = $db->query("
        SELECT DATE(created_at) as date, COUNT(*) as count
        FROM service_requests
        WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
        GROUP BY DATE(created_at)
        ORDER BY date
    ")->fetchAll(PDO::FETCH_ASSOC);
    
    $stats['trends'] = array_map(function($row) {
        return [
            'date' => $row['date'],
            'count' => (int)$row['count']
        ];
    }, $trends);
    
    // Top services
    $topServices = $db->query("
        SELECT s.name, COUNT(sr.id) as count
        FROM service_requests sr
        JOIN services s ON sr.service_id = s.id
        WHERE sr.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
        GROUP BY sr.service_id, s.name
        ORDER BY count DESC
        LIMIT 5
    ")->fetchAll(PDO::FETCH_ASSOC);
    
    $stats['topServices'] = array_map(function($row) {
        return [
            'name' => $row['name'],
            'count' => (int)$row['count']
        ];
    }, $topServices);
    
    http_response_code(200);
    echo json_encode([
        "success" => true,
        "data" => $stats,
        "generatedAt" => date('Y-m-d H:i:s')
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Server error. Please try again later.",
        "error" => $e->getMessage()
    ]);
}
?>
