-- =============================================
-- BARANGAY PORTAL SEED DATA
-- Initial data for the database
-- =============================================

USE barangay_portal;

-- =============================================
-- 1. INSERT DEFAULT ADMIN USER
-- Password: admin123 (hashed with bcrypt)
-- =============================================
INSERT INTO users (email, password, role, status, email_verified_at) VALUES
('admin@barangay.gov.ph', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', NOW()),
('staff@barangay.gov.ph', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'staff', 'active', NOW()),
('user@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', NOW()),
('juan.delacruz@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', NOW()),
('maria.santos@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', NOW());

-- =============================================
-- 2. INSERT USER PROFILES
-- =============================================
INSERT INTO user_profiles (user_id, first_name, middle_name, last_name, gender, birthdate, civil_status, phone, address_street, address_purok, address_barangay, address_city, address_province) VALUES
(1, 'Barangay', NULL, 'Admin', 'male', '1980-01-01', 'married', '09123456789', 'Barangay Hall', 'Centro', 'Sample Barangay', 'Sample City', 'Sample Province'),
(2, 'Staff', NULL, 'Member', 'female', '1990-05-15', 'single', '09234567890', '123 Staff Street', 'Purok 1', 'Sample Barangay', 'Sample City', 'Sample Province'),
(3, 'Test', NULL, 'User', 'male', '1995-08-20', 'single', '09345678901', '456 User Avenue', 'Purok 2', 'Sample Barangay', 'Sample City', 'Sample Province'),
(4, 'Juan', 'Santos', 'Dela Cruz', 'male', '1985-03-10', 'married', '09456789012', '789 Main Street', 'Purok 3', 'Sample Barangay', 'Sample City', 'Sample Province'),
(5, 'Maria', 'Garcia', 'Santos', 'female', '1992-11-25', 'single', '09567890123', '321 Side Street', 'Purok 1', 'Sample Barangay', 'Sample City', 'Sample Province');

-- =============================================
-- 3. INSERT PUROKS
-- =============================================
INSERT INTO puroks (name, description, total_households, total_population) VALUES
('Purok 1 - Centro', 'Central area near the barangay hall', 150, 750),
('Purok 2 - Riverside', 'Area along the river', 120, 600),
('Purok 3 - Hillside', 'Elevated area on the hill', 100, 500),
('Purok 4 - Seaside', 'Coastal area', 80, 400),
('Purok 5 - Farmland', 'Agricultural area', 60, 300),
('Purok 6 - New Settlement', 'Newly developed residential area', 90, 450);

-- =============================================
-- 4. INSERT BARANGAY OFFICIALS
-- =============================================
INSERT INTO officials (user_id, name, position, position_order, committee, term_start, term_end, contact_number, email, photo, is_active) VALUES
(1, 'Hon. Roberto M. Santos', 'Punong Barangay', 1, NULL, '2022-06-30', '2025-06-30', '09123456789', 'captain@barangay.gov.ph', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300', TRUE),
(NULL, 'Maria C. Garcia', 'Barangay Secretary', 2, NULL, '2022-06-30', '2025-06-30', '09234567890', 'secretary@barangay.gov.ph', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300', TRUE),
(NULL, 'Jose R. Reyes', 'Barangay Treasurer', 3, NULL, '2022-06-30', '2025-06-30', '09345678901', 'treasurer@barangay.gov.ph', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300', TRUE),
(NULL, 'Ana L. Martinez', 'Kagawad', 4, 'Peace and Order', '2022-06-30', '2025-06-30', '09456789012', NULL, 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300', TRUE),
(NULL, 'Pedro S. Lopez', 'Kagawad', 5, 'Health and Sanitation', '2022-06-30', '2025-06-30', '09567890123', NULL, 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300', TRUE),
(NULL, 'Elena B. Cruz', 'Kagawad', 6, 'Education', '2022-06-30', '2025-06-30', '09678901234', NULL, 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300', TRUE),
(NULL, 'Miguel A. Fernandez', 'Kagawad', 7, 'Infrastructure', '2022-06-30', '2025-06-30', '09789012345', NULL, 'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=300', TRUE),
(NULL, 'Gloria P. Ramos', 'Kagawad', 8, 'Agriculture', '2022-06-30', '2025-06-30', '09890123456', NULL, 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300', TRUE),
(NULL, 'Carlos D. Villanueva', 'Kagawad', 9, 'Environmental Protection', '2022-06-30', '2025-06-30', '09901234567', NULL, 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300', TRUE),
(NULL, 'Ricardo T. Mendoza', 'Kagawad', 10, 'Social Welfare', '2022-06-30', '2025-06-30', '09012345678', NULL, 'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=300', TRUE),
(NULL, 'Angela Joy S. Dela Rosa', 'SK Chairperson', 11, 'Youth and Sports', '2022-06-30', '2025-06-30', '09123456780', NULL, 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300', TRUE);

-- =============================================
-- 5. INSERT SERVICES
-- =============================================
INSERT INTO services (name, slug, description, processing_time, fee, validity_period, icon, category, is_online_available, display_order) VALUES
('Barangay Clearance', 'barangay-clearance', 'Official document certifying that the applicant is a bona fide resident of the barangay with good moral character. Required for employment, business, and other legal transactions.', '1-2 hours', 50.00, '6 months', 'FileText', 'clearance', TRUE, 1),
('Certificate of Indigency', 'certificate-of-indigency', 'Document certifying that the individual belongs to the indigent sector of the barangay. Used for medical assistance, scholarship applications, and social welfare programs.', '1-2 hours', 0.00, '3 months', 'Heart', 'certificate', TRUE, 2),
('Certificate of Residency', 'certificate-of-residency', 'Official document proving that the applicant is an actual resident of the barangay. Required for various government transactions.', '1-2 hours', 30.00, '6 months', 'Home', 'certificate', TRUE, 3),
('Business Permit Clearance', 'business-permit-clearance', 'Clearance required for obtaining and renewing business permits for establishments within the barangay jurisdiction.', '1-3 days', 200.00, '1 year', 'Briefcase', 'clearance', TRUE, 4),
('Barangay ID', 'barangay-id', 'Official identification card issued to registered residents of the barangay. Valid for identification purposes within the municipality.', '3-5 days', 100.00, '3 years', 'CreditCard', 'id', TRUE, 5),
('Blotter Report', 'blotter-report', 'Official documentation of complaints, incidents, or disputes reported to the barangay. Serves as an official record of the incident.', '30 minutes - 1 hour', 0.00, 'N/A', 'FileWarning', 'other', TRUE, 6),
('Certificate of Good Moral Character', 'good-moral-character', 'Certification attesting to the good moral character and conduct of the applicant based on community standing.', '1-2 hours', 50.00, '6 months', 'Award', 'certificate', TRUE, 7),
('First-Time Job Seeker Certificate', 'first-time-jobseeker', 'Certificate for first-time job seekers exempting them from certain fees as per Republic Act 11261.', '1 hour', 0.00, '1 year', 'Briefcase', 'certificate', TRUE, 8),
('Certificate of Late Registration of Birth', 'late-registration-birth', 'Certificate supporting late registration of birth with the civil registry.', '1-2 days', 50.00, 'One-time', 'FileText', 'certificate', TRUE, 9),
('Solo Parent Certificate', 'solo-parent', 'Certification for solo parents to avail of benefits under the Solo Parents Welfare Act.', '3-5 days', 0.00, '1 year', 'Heart', 'certificate', TRUE, 10);

-- =============================================
-- 6. INSERT SERVICE REQUIREMENTS
-- =============================================
INSERT INTO service_requirements (service_id, requirement, is_mandatory, display_order) VALUES
-- Barangay Clearance
(1, 'Valid Government-issued ID (Original and Photocopy)', TRUE, 1),
(1, 'Proof of Residency (Utility Bill, Rental Contract, or Certificate from Purok Leader)', TRUE, 2),
(1, '2x2 ID Photo (2 copies, white background)', TRUE, 3),
(1, 'Community Tax Certificate (Cedula)', TRUE, 4),
(1, 'Barangay Clearance Fee', TRUE, 5),

-- Certificate of Indigency
(2, 'Valid ID or any proof of identity', TRUE, 1),
(2, 'Proof of Residency', TRUE, 2),
(2, 'Certificate from Purok Leader', TRUE, 3),
(2, 'Barangay Clearance', FALSE, 4),

-- Certificate of Residency
(3, 'Valid Government-issued ID', TRUE, 1),
(3, 'Proof of Residency (Utility Bill - at least 3 months)', TRUE, 2),
(3, 'Barangay Clearance', TRUE, 3),
(3, '1x1 ID Photo', FALSE, 4),

-- Business Permit Clearance
(4, 'Valid Government-issued ID', TRUE, 1),
(4, 'DTI/SEC Registration', TRUE, 2),
(4, 'Proof of Business Address (Contract, Tax Declaration)', TRUE, 3),
(4, 'Community Tax Certificate (Cedula)', TRUE, 4),
(4, 'Previous Business Permit (for renewal)', FALSE, 5),
(4, 'Fire Safety Certificate', TRUE, 6),

-- Barangay ID
(5, 'Birth Certificate (Original and Photocopy)', TRUE, 1),
(5, 'Proof of Residency (Utility Bill or Certification from Purok Leader)', TRUE, 2),
(5, '1x1 ID Photo (3 copies, white background)', TRUE, 3),
(5, 'Barangay ID Fee', TRUE, 4),

-- Blotter Report
(6, 'Valid ID of Complainant', TRUE, 1),
(6, 'Written Statement/Affidavit of Complaint', TRUE, 2),
(6, 'Evidence/Supporting Documents (if any)', FALSE, 3),

-- Good Moral Character
(7, 'Valid Government-issued ID', TRUE, 1),
(7, 'Barangay Clearance', TRUE, 2),
(7, '2x2 ID Photo (2 copies)', TRUE, 3),
(7, 'Character Reference (2 persons)', FALSE, 4),

-- First-Time Job Seeker
(8, 'Valid Government-issued ID', TRUE, 1),
(8, 'Birth Certificate', TRUE, 2),
(8, 'Barangay Certificate', TRUE, 3),
(8, 'Oath of Undertaking (First-Time Job Seeker)', TRUE, 4),

-- Late Registration of Birth
(9, 'Affidavit of Late Registration', TRUE, 1),
(9, 'Baptismal Certificate', FALSE, 2),
(9, 'School Records', FALSE, 3),
(9, 'Valid IDs of Parents', TRUE, 4),
(9, 'Affidavit of Two Disinterested Persons', TRUE, 5),

-- Solo Parent
(10, 'Valid Government-issued ID', TRUE, 1),
(10, 'Birth Certificate of Child/Children', TRUE, 2),
(10, 'Barangay Certificate', TRUE, 3),
(10, 'Death Certificate of Spouse (if widowed)', FALSE, 4),
(10, 'Annulment/Legal Separation documents (if applicable)', FALSE, 5);

-- =============================================
-- 7. INSERT SAMPLE SERVICE REQUESTS
-- =============================================
INSERT INTO service_requests (request_number, user_id, service_id, purpose, status, scheduled_date, notes, created_at) VALUES
('REQ-2024-0001', 3, 1, 'Employment requirement', 'completed', '2024-01-10', 'Ready for pickup', '2024-01-08 09:00:00'),
('REQ-2024-0002', 3, 3, 'Bank account opening', 'processing', '2024-01-15', 'Processing documents', '2024-01-12 10:30:00'),
('REQ-2024-0003', 4, 1, 'Job application', 'completed', '2024-01-11', 'Claimed', '2024-01-09 14:00:00'),
('REQ-2024-0004', 4, 2, 'Medical assistance application', 'completed', '2024-01-12', 'For hospital admission', '2024-01-10 08:30:00'),
('REQ-2024-0005', 5, 1, 'Visa application', 'pending', NULL, 'Awaiting requirements', '2024-01-14 11:00:00'),
('REQ-2024-0006', 5, 4, 'New business registration', 'processing', '2024-01-18', 'For sari-sari store', '2024-01-13 15:30:00');

-- =============================================
-- 8. INSERT ANNOUNCEMENTS
-- =============================================
INSERT INTO announcements (title, slug, content, excerpt, category, image, event_date, event_location, is_featured, is_published, published_at, author_id) VALUES
('COVID-19 Vaccination Schedule for January 2024', 'covid-vaccination-jan-2024', 'Free COVID-19 vaccination will be held at the Barangay Health Center every Monday and Wednesday from 8:00 AM to 5:00 PM. All residents aged 12 and above are encouraged to get vaccinated. Please bring your valid ID and vaccination card. Walk-ins are welcome but priority will be given to those with appointments.', 'Free COVID-19 vaccination at Barangay Health Center every Monday and Wednesday.', 'advisory', 'https://images.unsplash.com/photo-1584036561566-baf8f5f1b144?w=800', NULL, 'Barangay Health Center', TRUE, TRUE, NOW(), 1),

('Barangay Fiesta 2024 - January 25', 'barangay-fiesta-2024', 'Join us in celebrating our annual Barangay Fiesta on January 25, 2024! This year's celebration will feature various activities including sports fest, beauty pageant, cultural shows, and a grand fireworks display. Food stalls and entertainment will be available throughout the day. Let us come together as one community to celebrate our unity and culture.', 'Annual Barangay Fiesta celebration with sports fest, pageant, and cultural shows.', 'event', 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800', '2024-01-25', 'Barangay Covered Court', TRUE, TRUE, NOW(), 1),

('Road Repair and Maintenance Notice', 'road-repair-notice-jan-2024', 'Please be advised that road repair and maintenance activities will be conducted along Main Street from January 20 to January 25, 2024. Motorists and pedestrians are advised to use alternative routes during this period. We apologize for any inconvenience this may cause and appreciate your understanding and cooperation.', 'Road repair along Main Street from January 20-25. Please use alternative routes.', 'advisory', 'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=800', NULL, 'Main Street', FALSE, TRUE, NOW(), 1),

('Free Legal Aid Consultation Every Friday', 'free-legal-aid-consultation', 'The Public Attorney's Office (PAO) in coordination with our barangay will provide FREE legal consultation services every Friday from 9:00 AM to 12:00 PM at the Barangay Hall. This service is available to all residents who need legal advice and assistance. No appointment necessary.', 'Free legal consultation with PAO every Friday at the Barangay Hall.', 'advisory', 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=800', NULL, 'Barangay Hall', FALSE, TRUE, NOW(), 1),

('Senior Citizens Monthly Cash Assistance Distribution', 'senior-citizens-cash-assistance', 'The monthly cash assistance for registered senior citizens will be distributed on January 20, 2024, starting at 8:00 AM at the Barangay Hall. Please bring your Senior Citizen ID and claim stub. For those who cannot personally claim, authorized representatives must bring a valid authorization letter and ID.', 'Monthly cash assistance distribution for senior citizens on January 20.', 'announcement', 'https://images.unsplash.com/photo-1581579438747-1dc8d17bbce4?w=800', '2024-01-20', 'Barangay Hall', FALSE, TRUE, NOW(), 1),

('Cleanup Drive and Tree Planting Activity', 'cleanup-drive-tree-planting-2024', 'In celebration of Earth Month, our barangay will hold a community-wide cleanup drive and tree planting activity on January 28, 2024. All residents are encouraged to participate. Assembly time is 6:00 AM at the Barangay Plaza. Refreshments will be provided. Let us work together for a cleaner and greener community!', 'Community cleanup drive and tree planting on January 28.', 'event', 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800', '2024-01-28', 'Barangay Plaza', FALSE, TRUE, NOW(), 1);

-- =============================================
-- 9. INSERT PROJECTS
-- =============================================
INSERT INTO projects (title, slug, description, category, status, budget, funding_source, location, beneficiaries, start_date, target_completion, progress_percentage, project_head_id) VALUES
('Barangay Road Concreting Project - Phase 2', 'road-concreting-phase-2', 'Continuation of the road concreting project covering the remaining unpaved roads in Purok 3 and Purok 4. This project aims to provide better accessibility and improve transportation for residents in these areas.', 'infrastructure', 'ongoing', 2500000.00, 'Local Government Unit / DPWH', 'Purok 3 and Purok 4', 'Residents of Purok 3 and 4 (approximately 1,100 people)', '2024-01-15', '2024-04-30', 35, 1),

('Barangay Health Center Renovation', 'health-center-renovation', 'Complete renovation of the Barangay Health Center including new medical equipment, expanded consultation rooms, and improved facilities for maternal and child care services.', 'health', 'ongoing', 1500000.00, 'Department of Health / LGU', 'Barangay Health Center', 'All barangay residents', '2024-01-01', '2024-03-31', 60, 1),

('Solar Street Lighting Project', 'solar-street-lighting', 'Installation of solar-powered street lights in all major roads and pathways within the barangay to improve safety and security during nighttime.', 'infrastructure', 'approved', 800000.00, 'Barangay Development Fund', 'All major roads', 'All barangay residents', '2024-02-01', '2024-05-31', 0, 1),

('Livelihood Training Program 2024', 'livelihood-training-2024', 'Skills training program for unemployed residents covering basic entrepreneurship, food processing, dressmaking, and computer literacy. Includes starter kits for graduates.', 'livelihood', 'ongoing', 500000.00, 'TESDA / DOLE', 'Barangay Hall Multi-Purpose Room', 'Unemployed residents (target: 100 participants)', '2024-01-10', '2024-06-30', 25, 1),

('Drainage System Improvement', 'drainage-improvement', 'Construction of new drainage canals and rehabilitation of existing drainage systems to prevent flooding during heavy rains.', 'infrastructure', 'proposed', 3000000.00, 'LGU / DPWH', 'Flood-prone areas', 'Residents in low-lying areas', NULL, NULL, 0, 1);

-- =============================================
-- 10. INSERT BARANGAY SETTINGS
-- =============================================
INSERT INTO settings (setting_key, setting_value, setting_type, description) VALUES
('barangay_name', 'Barangay Sample', 'text', 'Official name of the barangay'),
('barangay_code', 'BRG-001', 'text', 'Barangay code for document numbering'),
('municipality', 'Sample City', 'text', 'Municipality or city name'),
('province', 'Sample Province', 'text', 'Province name'),
('region', 'Region IV-A', 'text', 'Region name'),
('zip_code', '4000', 'text', 'Postal/ZIP code'),
('contact_phone', '(02) 8123-4567', 'text', 'Main contact phone number'),
('contact_mobile', '0912-345-6789', 'text', 'Mobile contact number'),
('contact_email', 'info@barangay.gov.ph', 'text', 'Official email address'),
('emergency_hotline', '0917-123-4567', 'text', '24/7 emergency hotline'),
('office_hours', 'Monday to Friday: 8:00 AM - 5:00 PM, Saturday: 8:00 AM - 12:00 PM', 'text', 'Office hours schedule'),
('address', 'Barangay Hall, Main Street, Sample City, Sample Province 4000', 'text', 'Complete barangay hall address'),
('facebook_url', 'https://facebook.com/barangaysample', 'text', 'Official Facebook page URL'),
('twitter_url', 'https://twitter.com/barangaysample', 'text', 'Official Twitter account URL'),
('youtube_url', '', 'text', 'Official YouTube channel URL'),
('logo_url', '/images/logo.png', 'text', 'Barangay logo image URL'),
('header_image', '/images/header.jpg', 'text', 'Header/banner image URL'),
('welcome_message', 'Welcome to our barangay! We are committed to serving our community with excellence, transparency, and integrity.', 'text', 'Homepage welcome message'),
('vision', 'A progressive, peaceful, and self-reliant barangay where every resident enjoys a high quality of life, with access to essential services, opportunities for growth, and a clean and safe environment for all.', 'text', 'Barangay vision statement'),
('mission', 'To deliver efficient and transparent public services, promote sustainable development, maintain peace and order, and empower our residents to actively participate in community-building and governance.', 'text', 'Barangay mission statement'),
('history', 'Our barangay was established in 1950, starting as a small community of farmers and fishermen. Over the decades, it has grown into a thriving urban barangay with a diverse population.', 'text', 'Brief barangay history'),
('population', '3000', 'number', 'Current estimated population'),
('total_households', '600', 'number', 'Total number of households'),
('land_area', '2.5', 'number', 'Land area in square kilometers'),
('captain_signature', '/images/signatures/captain.png', 'text', 'Punong Barangay signature image'),
('secretary_signature', '/images/signatures/secretary.png', 'text', 'Secretary signature image'),
('document_watermark', '/images/watermark.png', 'text', 'Watermark for official documents'),
('terms_and_conditions', '<p>Terms and conditions content here...</p>', 'html', 'Terms and conditions for portal users'),
('privacy_policy', '<p>Privacy policy content here...</p>', 'html', 'Privacy policy for portal users');

-- =============================================
-- 11. INSERT EMERGENCY HOTLINES
-- =============================================
INSERT INTO emergency_hotlines (name, department, phone_number, is_24_hours, display_order, is_active) VALUES
('Barangay Emergency', 'Barangay Hall', '0917-123-4567', TRUE, 1, TRUE),
('Police Station', 'Philippine National Police', '117', TRUE, 2, TRUE),
('Fire Department', 'Bureau of Fire Protection', '(02) 8426-0219', TRUE, 3, TRUE),
('Hospital', 'Sample City General Hospital', '(02) 8123-0001', TRUE, 4, TRUE),
('Ambulance', 'Emergency Medical Services', '(02) 8117-1111', TRUE, 5, TRUE),
('Disaster Response', 'Municipal DRRMO', '(02) 8123-4568', TRUE, 6, TRUE),
('Electric Utility', 'MERALCO', '16211', FALSE, 7, TRUE),
('Water Utility', 'Maynilad', '1626', FALSE, 8, TRUE);

-- =============================================
-- 12. INSERT FAQs
-- =============================================
INSERT INTO faqs (question, answer, category, display_order, is_active) VALUES
('What are the office hours of the barangay hall?', 'The barangay hall is open Monday to Friday from 8:00 AM to 5:00 PM, and Saturday from 8:00 AM to 12:00 PM. We are closed on Sundays and holidays.', 'General', 1, TRUE),
('How long does it take to process a barangay clearance?', 'Barangay clearance is typically processed within 1-2 hours, provided all requirements are complete. For urgent requests, please inform our staff.', 'Services', 2, TRUE),
('What are the requirements for barangay clearance?', 'You need to bring a valid government-issued ID, proof of residency (utility bill or certification from purok leader), 2x2 ID photos, cedula, and the processing fee of ₱50.00.', 'Services', 3, TRUE),
('Do I need an appointment to visit the barangay hall?', 'Walk-ins are welcome during office hours for most services. However, for special services like legal consultations, we recommend scheduling an appointment.', 'General', 4, TRUE),
('How can I report an emergency?', 'For emergencies, please call our 24/7 hotline at 0917-123-4567. For police emergencies, dial 117. You may also visit the barangay hall immediately.', 'Emergency', 5, TRUE),
('How do I register as a resident?', 'Visit the barangay hall with your valid ID, birth certificate, and proof of address. Our staff will assist you with the resident registration process.', 'Services', 6, TRUE),
('What is a Certificate of Indigency and who can apply?', 'A Certificate of Indigency is issued to residents who belong to the low-income bracket. It is used for medical assistance, scholarship applications, and other social welfare programs. To apply, you need a certification from your purok leader confirming your indigent status.', 'Services', 7, TRUE),
('How can I file a complaint or blotter report?', 'Visit the barangay hall and proceed to the Barangay Justice System desk. Bring your valid ID and a written statement of your complaint. Our Lupon Tagapamayapa will assist you.', 'Services', 8, TRUE),
('How do I apply for a business permit clearance?', 'Bring your valid ID, DTI/SEC registration, proof of business address, cedula, and fire safety certificate. Processing takes 1-3 days. The fee is ₱200.00 for new applications.', 'Services', 9, TRUE),
('Are there any free services offered by the barangay?', 'Yes! We offer free Certificate of Indigency, blotter services, first-time job seeker certificates, and various health services at the Barangay Health Center.', 'Services', 10, TRUE);

-- =============================================
-- 13. INSERT POPULATION STATISTICS
-- =============================================
INSERT INTO population_statistics (year, month, total_population, male_count, female_count, total_households, total_voters, age_0_5, age_6_12, age_13_17, age_18_30, age_31_45, age_46_60, age_60_above, senior_citizens, pwd_count, solo_parent_count, ofw_count, recorded_by) VALUES
(2024, 1, 3000, 1480, 1520, 600, 2100, 250, 350, 280, 750, 680, 450, 240, 240, 45, 85, 120, 1),
(2023, 12, 2980, 1470, 1510, 595, 2080, 245, 345, 275, 745, 675, 445, 250, 250, 43, 82, 118, 1),
(2023, 6, 2950, 1455, 1495, 590, 2050, 240, 340, 270, 740, 670, 440, 250, 250, 42, 80, 115, 1);

-- =============================================
-- 14. INSERT SAMPLE BLOTTER RECORDS
-- =============================================
INSERT INTO blotters (blotter_number, incident_type, incident_date, incident_time, incident_location, narrative, complainant_name, complainant_address, complainant_contact, respondent_name, respondent_address, status, action_taken) VALUES
('BLT-2024-001', 'disturbance', '2024-01-10', '22:30:00', 'Purok 2, Near Sari-sari Store', 'Complainant reported loud karaoke noise from neighboring house causing disturbance to the community.', 'Juan Dela Cruz', 'Purok 2, Sample Barangay', '09123456789', 'Unknown Resident', 'Purok 2, Sample Barangay', 'settled', 'Both parties were summoned. Respondent agreed to lower volume after 10PM.'),
('BLT-2024-002', 'dispute', '2024-01-12', '14:00:00', 'Purok 3, Main Road', 'Verbal altercation between neighbors regarding property boundary.', 'Maria Santos', 'Purok 3, Sample Barangay', '09234567890', 'Pedro Lopez', 'Purok 3, Sample Barangay', 'for_mediation', 'Parties scheduled for mediation on January 20, 2024.'),
('BLT-2024-003', 'theft', '2024-01-14', '03:00:00', 'Purok 1, Residential Area', 'Complainant reported theft of motorcycle parked outside their residence.', 'Carlos Garcia', 'Purok 1, Sample Barangay', '09345678901', 'Unknown', 'Unknown', 'referred', 'Case referred to PNP for investigation due to criminal nature.');

-- =============================================
-- 15. INSERT SAMPLE CERTIFICATES ISSUED
-- =============================================
INSERT INTO certificates_issued (request_id, certificate_number, certificate_type, issued_to, purpose, ctc_number, ctc_date, ctc_place, or_number, amount, valid_from, valid_until, issued_by, created_at) VALUES
(1, 'BC-2024-0001', 'Barangay Clearance', 'Test User', 'Employment requirement', '12345678', '2024-01-08', 'Sample City', 'OR-2024-001', 50.00, '2024-01-10', '2024-07-10', 1, '2024-01-10 10:30:00'),
(3, 'BC-2024-0002', 'Barangay Clearance', 'Juan Santos Dela Cruz', 'Job application', '12345679', '2024-01-09', 'Sample City', 'OR-2024-002', 50.00, '2024-01-11', '2024-07-11', 1, '2024-01-11 11:00:00'),
(4, 'CI-2024-0001', 'Certificate of Indigency', 'Juan Santos Dela Cruz', 'Medical assistance application', '12345680', '2024-01-10', 'Sample City', NULL, 0.00, '2024-01-12', '2024-04-12', 1, '2024-01-12 09:00:00');

-- =============================================
-- 16. INSERT NEWSLETTER SUBSCRIBERS
-- =============================================
INSERT INTO newsletter_subscribers (email, name, is_active) VALUES
('subscriber1@email.com', 'John Doe', TRUE),
('subscriber2@email.com', 'Jane Smith', TRUE),
('subscriber3@email.com', 'Mike Johnson', TRUE),
('subscriber4@email.com', 'Sarah Williams', TRUE),
('subscriber5@email.com', 'David Brown', TRUE);

-- =============================================
-- END OF SEED DATA
-- =============================================
