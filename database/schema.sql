-- =============================================
-- BARANGAY PORTAL DATABASE SCHEMA
-- Complete MySQL Database Structure
-- =============================================

-- Create Database
CREATE DATABASE IF NOT EXISTS barangay_portal;
USE barangay_portal;

-- =============================================
-- 1. USERS TABLE
-- Stores all user accounts (residents and admins)
-- =============================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user', 'staff') DEFAULT 'user',
    status ENUM('active', 'inactive', 'suspended', 'pending') DEFAULT 'pending',
    email_verified_at TIMESTAMP NULL,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 2. USER PROFILES TABLE
-- Stores detailed user information
-- =============================================
CREATE TABLE IF NOT EXISTS user_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100) NULL,
    last_name VARCHAR(100) NOT NULL,
    suffix VARCHAR(20) NULL,
    gender ENUM('male', 'female', 'other') NULL,
    birthdate DATE NULL,
    birthplace VARCHAR(255) NULL,
    civil_status ENUM('single', 'married', 'widowed', 'separated', 'divorced') DEFAULT 'single',
    nationality VARCHAR(100) DEFAULT 'Filipino',
    religion VARCHAR(100) NULL,
    occupation VARCHAR(255) NULL,
    monthly_income DECIMAL(12, 2) NULL,
    phone VARCHAR(20) NULL,
    mobile VARCHAR(20) NULL,
    address_street VARCHAR(255) NULL,
    address_purok VARCHAR(100) NULL,
    address_barangay VARCHAR(100) NULL,
    address_city VARCHAR(100) NULL,
    address_province VARCHAR(100) NULL,
    address_zipcode VARCHAR(20) NULL,
    years_of_residency INT NULL,
    voter_status ENUM('registered', 'not_registered') DEFAULT 'not_registered',
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'unknown') DEFAULT 'unknown',
    emergency_contact_name VARCHAR(255) NULL,
    emergency_contact_phone VARCHAR(20) NULL,
    emergency_contact_relationship VARCHAR(100) NULL,
    profile_photo VARCHAR(255) NULL,
    valid_id_type VARCHAR(100) NULL,
    valid_id_number VARCHAR(100) NULL,
    valid_id_photo VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_name (last_name, first_name),
    INDEX idx_purok (address_purok),
    INDEX idx_voter (voter_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 3. HOUSEHOLDS TABLE
-- Stores household information
-- =============================================
CREATE TABLE IF NOT EXISTS households (
    id INT AUTO_INCREMENT PRIMARY KEY,
    household_number VARCHAR(50) NOT NULL UNIQUE,
    household_head_id INT NULL,
    address_street VARCHAR(255) NULL,
    address_purok VARCHAR(100) NULL,
    house_ownership ENUM('owned', 'rented', 'shared', 'informal_settler') DEFAULT 'owned',
    house_type ENUM('concrete', 'semi_concrete', 'wood', 'light_materials', 'mixed') NULL,
    water_source ENUM('piped', 'well', 'pump', 'spring', 'other') NULL,
    toilet_type ENUM('water_sealed', 'pit', 'none', 'shared') NULL,
    electricity BOOLEAN DEFAULT TRUE,
    total_members INT DEFAULT 1,
    total_income DECIMAL(12, 2) NULL,
    is_4ps_beneficiary BOOLEAN DEFAULT FALSE,
    is_indigent BOOLEAN DEFAULT FALSE,
    notes TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (household_head_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_household_number (household_number),
    INDEX idx_purok (address_purok),
    INDEX idx_indigent (is_indigent),
    INDEX idx_4ps (is_4ps_beneficiary)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 4. HOUSEHOLD MEMBERS TABLE
-- Links users to households
-- =============================================
CREATE TABLE IF NOT EXISTS household_members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    household_id INT NOT NULL,
    user_id INT NOT NULL,
    relationship_to_head ENUM('head', 'spouse', 'child', 'parent', 'sibling', 'grandchild', 'grandparent', 'relative', 'helper', 'boarder', 'other') DEFAULT 'other',
    is_dependent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (household_id) REFERENCES households(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_household_member (household_id, user_id),
    INDEX idx_relationship (relationship_to_head)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 5. BARANGAY OFFICIALS TABLE
-- Stores information about barangay officials
-- =============================================
CREATE TABLE IF NOT EXISTS officials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(100) NOT NULL,
    position_order INT DEFAULT 0,
    committee VARCHAR(255) NULL,
    term_start DATE NULL,
    term_end DATE NULL,
    contact_number VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
    address VARCHAR(255) NULL,
    photo VARCHAR(255) NULL,
    bio TEXT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_position (position),
    INDEX idx_active (is_active),
    INDEX idx_order (position_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 6. SERVICES TABLE
-- Stores available barangay services
-- =============================================
CREATE TABLE IF NOT EXISTS services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT NULL,
    requirements TEXT NULL,
    processing_time VARCHAR(100) NULL,
    fee DECIMAL(10, 2) DEFAULT 0.00,
    validity_period VARCHAR(100) NULL,
    icon VARCHAR(100) NULL,
    category ENUM('certificate', 'clearance', 'permit', 'id', 'assistance', 'other') DEFAULT 'certificate',
    is_online_available BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_slug (slug),
    INDEX idx_category (category),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 7. SERVICE REQUIREMENTS TABLE
-- Stores individual requirements for each service
-- =============================================
CREATE TABLE IF NOT EXISTS service_requirements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    service_id INT NOT NULL,
    requirement VARCHAR(255) NOT NULL,
    is_mandatory BOOLEAN DEFAULT TRUE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
    INDEX idx_service (service_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 8. SERVICE REQUESTS TABLE
-- Stores all document/service requests
-- =============================================
CREATE TABLE IF NOT EXISTS service_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_number VARCHAR(50) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    service_id INT NOT NULL,
    purpose VARCHAR(500) NULL,
    status ENUM('pending', 'processing', 'for_pickup', 'completed', 'rejected', 'cancelled') DEFAULT 'pending',
    priority ENUM('normal', 'urgent') DEFAULT 'normal',
    scheduled_date DATE NULL,
    completed_date DATE NULL,
    pickup_date DATE NULL,
    or_number VARCHAR(50) NULL,
    amount_paid DECIMAL(10, 2) NULL,
    payment_status ENUM('unpaid', 'paid', 'waived') DEFAULT 'unpaid',
    payment_date TIMESTAMP NULL,
    processed_by INT NULL,
    approved_by INT NULL,
    rejection_reason TEXT NULL,
    notes TEXT NULL,
    document_file VARCHAR(255) NULL,
    qr_code VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
    FOREIGN KEY (processed_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_request_number (request_number),
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_payment (payment_status),
    INDEX idx_date (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 9. REQUEST TRACKING TABLE
-- Tracks status changes for service requests
-- =============================================
CREATE TABLE IF NOT EXISTS request_tracking (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    status ENUM('pending', 'processing', 'for_pickup', 'completed', 'rejected', 'cancelled') NOT NULL,
    remarks TEXT NULL,
    updated_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES service_requests(id) ON DELETE CASCADE,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_request (request_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 10. ANNOUNCEMENTS TABLE
-- Stores news, events, and advisories
-- =============================================
CREATE TABLE IF NOT EXISTS announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    slug VARCHAR(500) NOT NULL,
    content TEXT NOT NULL,
    excerpt VARCHAR(500) NULL,
    category ENUM('news', 'event', 'advisory', 'announcement', 'update') DEFAULT 'news',
    image VARCHAR(255) NULL,
    gallery JSON NULL,
    event_date DATE NULL,
    event_time TIME NULL,
    event_location VARCHAR(255) NULL,
    is_featured BOOLEAN DEFAULT FALSE,
    is_published BOOLEAN DEFAULT TRUE,
    published_at TIMESTAMP NULL,
    views INT DEFAULT 0,
    author_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_slug (slug),
    INDEX idx_category (category),
    INDEX idx_published (is_published),
    INDEX idx_featured (is_featured),
    INDEX idx_date (published_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 11. BLOTTER RECORDS TABLE
-- Stores incident/complaint records
-- =============================================
CREATE TABLE IF NOT EXISTS blotters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    blotter_number VARCHAR(50) NOT NULL UNIQUE,
    incident_type ENUM('complaint', 'dispute', 'theft', 'assault', 'disturbance', 'property_damage', 'domestic', 'traffic', 'other') NOT NULL,
    incident_date DATE NOT NULL,
    incident_time TIME NULL,
    incident_location VARCHAR(255) NULL,
    narrative TEXT NOT NULL,
    complainant_id INT NULL,
    complainant_name VARCHAR(255) NULL,
    complainant_address VARCHAR(255) NULL,
    complainant_contact VARCHAR(20) NULL,
    respondent_name VARCHAR(255) NULL,
    respondent_address VARCHAR(255) NULL,
    respondent_contact VARCHAR(20) NULL,
    witnesses TEXT NULL,
    status ENUM('filed', 'under_investigation', 'for_mediation', 'mediated', 'settled', 'referred', 'closed', 'dismissed') DEFAULT 'filed',
    action_taken TEXT NULL,
    settlement_details TEXT NULL,
    settlement_date DATE NULL,
    hearing_schedule DATETIME NULL,
    assigned_to INT NULL,
    attachments JSON NULL,
    is_confidential BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (complainant_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_blotter_number (blotter_number),
    INDEX idx_type (incident_type),
    INDEX idx_status (status),
    INDEX idx_date (incident_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 12. BLOTTER HEARING TABLE
-- Stores hearing schedules for blotter cases
-- =============================================
CREATE TABLE IF NOT EXISTS blotter_hearings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    blotter_id INT NOT NULL,
    hearing_date DATETIME NOT NULL,
    venue VARCHAR(255) NULL,
    presiding_officer INT NULL,
    attendees TEXT NULL,
    minutes TEXT NULL,
    outcome ENUM('pending', 'continued', 'settled', 'escalated') DEFAULT 'pending',
    next_hearing_date DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (blotter_id) REFERENCES blotters(id) ON DELETE CASCADE,
    FOREIGN KEY (presiding_officer) REFERENCES officials(id) ON DELETE SET NULL,
    INDEX idx_blotter (blotter_id),
    INDEX idx_date (hearing_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 13. PROJECTS TABLE
-- Stores barangay projects and programs
-- =============================================
CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    slug VARCHAR(500) NOT NULL,
    description TEXT NULL,
    category ENUM('infrastructure', 'health', 'education', 'livelihood', 'environment', 'social_welfare', 'peace_order', 'other') DEFAULT 'other',
    status ENUM('proposed', 'approved', 'ongoing', 'completed', 'suspended', 'cancelled') DEFAULT 'proposed',
    budget DECIMAL(15, 2) NULL,
    actual_cost DECIMAL(15, 2) NULL,
    funding_source VARCHAR(255) NULL,
    location VARCHAR(255) NULL,
    beneficiaries VARCHAR(255) NULL,
    start_date DATE NULL,
    target_completion DATE NULL,
    actual_completion DATE NULL,
    progress_percentage INT DEFAULT 0,
    contractor VARCHAR(255) NULL,
    contact_person VARCHAR(255) NULL,
    image VARCHAR(255) NULL,
    gallery JSON NULL,
    documents JSON NULL,
    project_head_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_head_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_slug (slug),
    INDEX idx_category (category),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 14. PROJECT UPDATES TABLE
-- Stores progress updates for projects
-- =============================================
CREATE TABLE IF NOT EXISTS project_updates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    progress_percentage INT NULL,
    images JSON NULL,
    updated_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_project (project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 15. CONTACT MESSAGES TABLE
-- Stores messages from contact form
-- =============================================
CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NULL,
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('unread', 'read', 'replied', 'archived') DEFAULT 'unread',
    replied_at TIMESTAMP NULL,
    replied_by INT NULL,
    reply_message TEXT NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (replied_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_status (status),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 16. PUROK TABLE
-- Stores purok/zone information
-- =============================================
CREATE TABLE IF NOT EXISTS puroks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    purok_leader_id INT NULL,
    total_households INT DEFAULT 0,
    total_population INT DEFAULT 0,
    area_coverage VARCHAR(255) NULL,
    boundaries TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (purok_leader_id) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE KEY unique_purok_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 17. BARANGAY SETTINGS TABLE
-- Stores general barangay configuration
-- =============================================
CREATE TABLE IF NOT EXISTS settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT NULL,
    setting_type ENUM('text', 'number', 'boolean', 'json', 'html') DEFAULT 'text',
    description VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_key (setting_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 18. CERTIFICATES ISSUED TABLE
-- Tracks all issued certificates/documents
-- =============================================
CREATE TABLE IF NOT EXISTS certificates_issued (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    certificate_number VARCHAR(50) NOT NULL UNIQUE,
    certificate_type VARCHAR(100) NOT NULL,
    issued_to VARCHAR(255) NOT NULL,
    purpose VARCHAR(500) NULL,
    ctc_number VARCHAR(50) NULL,
    ctc_date DATE NULL,
    ctc_place VARCHAR(255) NULL,
    or_number VARCHAR(50) NULL,
    amount DECIMAL(10, 2) DEFAULT 0.00,
    valid_from DATE NULL,
    valid_until DATE NULL,
    issued_by INT NULL,
    verified_by INT NULL,
    qr_code VARCHAR(255) NULL,
    is_void BOOLEAN DEFAULT FALSE,
    void_reason TEXT NULL,
    voided_at TIMESTAMP NULL,
    voided_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES service_requests(id) ON DELETE CASCADE,
    FOREIGN KEY (issued_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (verified_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (voided_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_certificate_number (certificate_number),
    INDEX idx_type (certificate_type),
    INDEX idx_issued_to (issued_to)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 19. REVENUE/PAYMENTS TABLE
-- Tracks all barangay revenue from services
-- =============================================
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    or_number VARCHAR(50) NOT NULL UNIQUE,
    request_id INT NULL,
    payer_name VARCHAR(255) NOT NULL,
    payment_for VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('cash', 'gcash', 'bank_transfer', 'other') DEFAULT 'cash',
    reference_number VARCHAR(100) NULL,
    received_by INT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT NULL,
    is_void BOOLEAN DEFAULT FALSE,
    void_reason TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES service_requests(id) ON DELETE SET NULL,
    FOREIGN KEY (received_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_or (or_number),
    INDEX idx_date (payment_date),
    INDEX idx_payer (payer_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 20. ACTIVITY LOGS TABLE
-- Tracks all system activities
-- =============================================
CREATE TABLE IF NOT EXISTS activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    action VARCHAR(255) NOT NULL,
    module VARCHAR(100) NULL,
    record_id INT NULL,
    record_type VARCHAR(100) NULL,
    old_values JSON NULL,
    new_values JSON NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_action (action),
    INDEX idx_module (module),
    INDEX idx_date (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 21. NOTIFICATIONS TABLE
-- Stores user notifications
-- =============================================
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    data JSON NULL,
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_read (is_read),
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 22. PASSWORD RESETS TABLE
-- Stores password reset tokens
-- =============================================
CREATE TABLE IF NOT EXISTS password_resets (
    email VARCHAR(255) NOT NULL,
    token VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 23. SESSIONS TABLE
-- Stores user sessions
-- =============================================
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(255) PRIMARY KEY,
    user_id INT NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    payload TEXT NOT NULL,
    last_activity INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_activity (last_activity)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 24. FILE UPLOADS TABLE
-- Tracks all uploaded files
-- =============================================
CREATE TABLE IF NOT EXISTS file_uploads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    original_name VARCHAR(255) NOT NULL,
    stored_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(100) NULL,
    file_size INT NULL,
    mime_type VARCHAR(100) NULL,
    related_type VARCHAR(100) NULL,
    related_id INT NULL,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_related (related_type, related_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 25. BUSINESS PERMITS TABLE
-- Stores business permit applications
-- =============================================
CREATE TABLE IF NOT EXISTS business_permits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    permit_number VARCHAR(50) NULL UNIQUE,
    user_id INT NOT NULL,
    business_name VARCHAR(255) NOT NULL,
    business_type VARCHAR(100) NOT NULL,
    business_nature TEXT NULL,
    business_address VARCHAR(500) NOT NULL,
    owner_name VARCHAR(255) NOT NULL,
    owner_address VARCHAR(500) NULL,
    owner_contact VARCHAR(20) NULL,
    dti_registration VARCHAR(100) NULL,
    capital DECIMAL(15, 2) NULL,
    employees_count INT DEFAULT 1,
    floor_area DECIMAL(10, 2) NULL,
    status ENUM('new', 'renewal', 'pending', 'approved', 'rejected', 'expired') DEFAULT 'pending',
    application_date DATE NULL,
    approval_date DATE NULL,
    expiry_date DATE NULL,
    amount_paid DECIMAL(10, 2) NULL,
    or_number VARCHAR(50) NULL,
    processed_by INT NULL,
    approved_by INT NULL,
    remarks TEXT NULL,
    attachments JSON NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (processed_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_permit_number (permit_number),
    INDEX idx_business_name (business_name),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 26. NEWSLETTER SUBSCRIBERS TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS newsletter_subscribers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NULL,
    is_active BOOLEAN DEFAULT TRUE,
    subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    unsubscribed_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 27. FAQ TABLE
-- Stores frequently asked questions
-- =============================================
CREATE TABLE IF NOT EXISTS faqs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(500) NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(100) NULL,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 28. GALLERY TABLE
-- Stores photo gallery items
-- =============================================
CREATE TABLE IF NOT EXISTS gallery (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    image_path VARCHAR(500) NOT NULL,
    thumbnail_path VARCHAR(500) NULL,
    album VARCHAR(100) NULL,
    is_featured BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    uploaded_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_album (album),
    INDEX idx_featured (is_featured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 29. EMERGENCY HOTLINES TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS emergency_hotlines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    department VARCHAR(255) NULL,
    phone_number VARCHAR(50) NOT NULL,
    is_24_hours BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 30. POPULATION STATISTICS TABLE
-- For demographic data and reporting
-- =============================================
CREATE TABLE IF NOT EXISTS population_statistics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL,
    month INT NULL,
    total_population INT DEFAULT 0,
    male_count INT DEFAULT 0,
    female_count INT DEFAULT 0,
    total_households INT DEFAULT 0,
    total_voters INT DEFAULT 0,
    age_0_5 INT DEFAULT 0,
    age_6_12 INT DEFAULT 0,
    age_13_17 INT DEFAULT 0,
    age_18_30 INT DEFAULT 0,
    age_31_45 INT DEFAULT 0,
    age_46_60 INT DEFAULT 0,
    age_60_above INT DEFAULT 0,
    senior_citizens INT DEFAULT 0,
    pwd_count INT DEFAULT 0,
    solo_parent_count INT DEFAULT 0,
    ofw_count INT DEFAULT 0,
    notes TEXT NULL,
    recorded_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recorded_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_year (year),
    UNIQUE KEY unique_year_month (year, month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

