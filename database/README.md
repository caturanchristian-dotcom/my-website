# Barangay Portal Database Schema

## Overview

This document describes the complete database schema for the Barangay Portal system. The database is designed to support all features of a modern barangay management system including resident management, service requests, document issuance, blotter records, and more.

## Database Tables Summary

| # | Table Name | Description |
|---|------------|-------------|
| 1 | `users` | User accounts (residents, admins, staff) |
| 2 | `user_profiles` | Detailed user information |
| 3 | `households` | Household information |
| 4 | `household_members` | Links users to households |
| 5 | `officials` | Barangay officials |
| 6 | `services` | Available barangay services |
| 7 | `service_requirements` | Requirements for each service |
| 8 | `service_requests` | Document/service requests |
| 9 | `request_tracking` | Status tracking for requests |
| 10 | `announcements` | News, events, advisories |
| 11 | `blotters` | Incident/complaint records |
| 12 | `blotter_hearings` | Hearing schedules for cases |
| 13 | `projects` | Barangay projects and programs |
| 14 | `project_updates` | Progress updates for projects |
| 15 | `contact_messages` | Contact form submissions |
| 16 | `puroks` | Purok/zone information |
| 17 | `settings` | System configuration |
| 18 | `certificates_issued` | Issued certificates tracking |
| 19 | `payments` | Revenue/payment records |
| 20 | `activity_logs` | System activity logs |
| 21 | `notifications` | User notifications |
| 22 | `password_resets` | Password reset tokens |
| 23 | `sessions` | User sessions |
| 24 | `file_uploads` | Uploaded files tracking |
| 25 | `business_permits` | Business permit applications |
| 26 | `newsletter_subscribers` | Newsletter subscriptions |
| 27 | `faqs` | Frequently asked questions |
| 28 | `gallery` | Photo gallery |
| 29 | `emergency_hotlines` | Emergency contact numbers |
| 30 | `population_statistics` | Demographic data |

## Entity Relationship Diagram

```
                                    ┌─────────────────┐
                                    │     users       │
                                    │─────────────────│
                                    │ id (PK)         │
                                    │ email           │
                                    │ password        │
                                    │ role            │
                                    │ status          │
                                    └────────┬────────┘
                                             │
              ┌──────────────────────────────┼──────────────────────────────┐
              │                              │                              │
              ▼                              ▼                              ▼
    ┌─────────────────┐           ┌─────────────────┐           ┌─────────────────┐
    │  user_profiles  │           │service_requests │           │    blotters     │
    │─────────────────│           │─────────────────│           │─────────────────│
    │ user_id (FK)    │           │ user_id (FK)    │           │ complainant_id  │
    │ first_name      │           │ service_id (FK) │           │ (FK)            │
    │ last_name       │           │ status          │           │ incident_type   │
    │ gender          │           │ purpose         │           │ status          │
    │ birthdate       │           └────────┬────────┘           └─────────────────┘
    │ address_*       │                    │
    └─────────────────┘                    ▼
                                ┌─────────────────┐
                                │    services     │
                                │─────────────────│
                                │ id (PK)         │
                                │ name            │
                                │ fee             │
                                │ category        │
                                └────────┬────────┘
                                         │
                                         ▼
                              ┌─────────────────────┐
                              │service_requirements │
                              │─────────────────────│
                              │ service_id (FK)     │
                              │ requirement         │
                              │ is_mandatory        │
                              └─────────────────────┘
```

## Table Details

### 1. Users Table (`users`)

Stores all user accounts including residents, administrators, and staff.

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| email | VARCHAR(255) | Unique email address |
| password | VARCHAR(255) | Hashed password |
| role | ENUM | 'admin', 'user', 'staff' |
| status | ENUM | 'active', 'inactive', 'suspended', 'pending' |
| email_verified_at | TIMESTAMP | Email verification timestamp |
| remember_token | VARCHAR(100) | Remember me token |

### 2. User Profiles Table (`user_profiles`)

Stores detailed personal information for each user.

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| user_id | INT | Foreign key to users |
| first_name | VARCHAR(100) | First name |
| middle_name | VARCHAR(100) | Middle name |
| last_name | VARCHAR(100) | Last name |
| suffix | VARCHAR(20) | Name suffix (Jr., Sr., etc.) |
| gender | ENUM | 'male', 'female', 'other' |
| birthdate | DATE | Date of birth |
| birthplace | VARCHAR(255) | Place of birth |
| civil_status | ENUM | Marital status |
| nationality | VARCHAR(100) | Nationality |
| religion | VARCHAR(100) | Religion |
| occupation | VARCHAR(255) | Current occupation |
| monthly_income | DECIMAL | Monthly income |
| phone | VARCHAR(20) | Landline phone |
| mobile | VARCHAR(20) | Mobile number |
| address_* | VARCHAR | Address components |
| voter_status | ENUM | Voter registration status |
| blood_type | ENUM | Blood type |
| emergency_contact_* | VARCHAR | Emergency contact info |
| profile_photo | VARCHAR(255) | Profile photo path |
| valid_id_* | VARCHAR | Valid ID information |

### 3. Services Table (`services`)

Defines all available barangay services.

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| name | VARCHAR(255) | Service name |
| slug | VARCHAR(255) | URL-friendly identifier |
| description | TEXT | Service description |
| requirements | TEXT | Legacy requirements field |
| processing_time | VARCHAR(100) | Estimated processing time |
| fee | DECIMAL | Service fee |
| validity_period | VARCHAR(100) | Document validity |
| icon | VARCHAR(100) | Icon identifier |
| category | ENUM | Service category |
| is_online_available | BOOLEAN | Available for online request |

### 4. Service Requests Table (`service_requests`)

Tracks all service/document requests from residents.

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| request_number | VARCHAR(50) | Unique request number |
| user_id | INT | Requesting user |
| service_id | INT | Requested service |
| purpose | VARCHAR(500) | Purpose of request |
| status | ENUM | Current status |
| priority | ENUM | 'normal', 'urgent' |
| scheduled_date | DATE | Pickup/processing date |
| payment_status | ENUM | Payment status |
| processed_by | INT | Staff who processed |
| approved_by | INT | Official who approved |

### 5. Blotters Table (`blotters`)

Records all incidents and complaints filed with the barangay.

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| blotter_number | VARCHAR(50) | Unique blotter number |
| incident_type | ENUM | Type of incident |
| incident_date | DATE | Date of incident |
| incident_time | TIME | Time of incident |
| incident_location | VARCHAR(255) | Location |
| narrative | TEXT | Incident description |
| complainant_* | VARCHAR | Complainant information |
| respondent_* | VARCHAR | Respondent information |
| status | ENUM | Case status |
| action_taken | TEXT | Actions taken |
| settlement_details | TEXT | Settlement information |
| hearing_schedule | DATETIME | Next hearing date |

### 6. Announcements Table (`announcements`)

Stores news, events, and advisories.

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| title | VARCHAR(500) | Announcement title |
| slug | VARCHAR(500) | URL-friendly identifier |
| content | TEXT | Full content |
| excerpt | VARCHAR(500) | Short excerpt |
| category | ENUM | Category type |
| image | VARCHAR(255) | Featured image |
| event_date | DATE | Event date (for events) |
| event_location | VARCHAR(255) | Event location |
| is_featured | BOOLEAN | Featured flag |
| is_published | BOOLEAN | Published status |
| views | INT | View count |

### 7. Projects Table (`projects`)

Tracks barangay projects and programs.

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| title | VARCHAR(500) | Project title |
| description | TEXT | Project description |
| category | ENUM | Project category |
| status | ENUM | Current status |
| budget | DECIMAL | Allocated budget |
| actual_cost | DECIMAL | Actual expenditure |
| funding_source | VARCHAR(255) | Source of funds |
| location | VARCHAR(255) | Project location |
| beneficiaries | VARCHAR(255) | Target beneficiaries |
| start_date | DATE | Start date |
| target_completion | DATE | Target completion |
| progress_percentage | INT | Completion percentage |

## Installation

### 1. Create the Database

```bash
mysql -u root -p
```

```sql
CREATE DATABASE barangay_portal;
USE barangay_portal;
```

### 2. Run the Schema

```bash
mysql -u root -p barangay_portal < database/schema.sql
```

### 3. Insert Seed Data

```bash
mysql -u root -p barangay_portal < database/seed.sql
```

## Default Credentials

After running the seed data, you can use these credentials:

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@barangay.gov.ph | password |
| Staff | staff@barangay.gov.ph | password |
| User | user@example.com | password |

> **Note:** The seed data uses bcrypt hash for "password". In production, change these immediately.

## Indexing Strategy

The schema includes indexes on:
- Primary keys (automatic)
- Foreign keys for JOIN operations
- Frequently searched columns (email, status, date fields)
- Columns used in WHERE clauses

## Backup and Maintenance

### Create Backup

```bash
mysqldump -u root -p barangay_portal > backup_$(date +%Y%m%d).sql
```

### Restore Backup

```bash
mysql -u root -p barangay_portal < backup_20240115.sql
```

## Security Considerations

1. **Password Hashing**: Always use bcrypt or Argon2 for password hashing
2. **SQL Injection**: Use prepared statements in PHP
3. **Access Control**: Implement proper role-based access
4. **Audit Logging**: Activity logs table tracks all changes
5. **Data Encryption**: Consider encrypting sensitive fields

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2024-01-15 | Initial schema release |

## Support

For questions or issues, contact the development team.
