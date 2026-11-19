# Phase 3 — Database Design

## 3.1 Engine

- SQLite via **Drift ORM**
- Encryption via **SQLCipher** (`sqlcipher_flutter_libs`)
- WAL mode enabled for concurrency
- Foreign keys ON
- Soft deletes where audit retention requires history

## 3.2 Naming Conventions

- Tables: `snake_case` plural (`employees`)
- PKs: `id` (TEXT UUID v4) unless noted
- Timestamps: UTC ISO-8601 TEXT or INTEGER epoch ms
- Booleans: INTEGER 0/1
- Money/scores: REAL or INTEGER (scores ×100)

## 3.3 ER Overview

```
users ──< user_roles >── roles ──< role_permissions >── permissions
users ──< sessions
users ──< audit_logs
users ──< saved_filters

employees ──< employee_contacts (1:1 preferred)
employees ──< employee_socials (1:1)
employees ──< employee_organization (1:1)
employees ──< employee_education (1:N)
employees ──< employee_skills (1:N)
employees ──< employee_interests (1:1)
employees ──< employee_insurance (1:N history)
employees ──< employee_evaluations (1:N)
employees ──< employee_documents (1:N)
employees ──< employee_photos (1:1)

departments ──< units
employees.department_id → departments
employees.unit_id → units
employees.supervisor_id → employees

settings (key-value)
backup_jobs
report_templates
```

## 3.4 Core Tables

### users
| Column | Type | Constraints |
|--------|------|-------------|
| id | TEXT | PK |
| username | TEXT | UNIQUE NOT NULL |
| display_name | TEXT | NOT NULL |
| password_hash | TEXT | NOT NULL (Argon2id encoded) |
| password_salt | TEXT | NOT NULL |
| is_active | INTEGER | NOT NULL DEFAULT 1 |
| failed_attempts | INTEGER | NOT NULL DEFAULT 0 |
| locked_until | INTEGER | NULL |
| must_change_password | INTEGER | DEFAULT 0 |
| last_login_at | INTEGER | NULL |
| created_at | INTEGER | NOT NULL |
| updated_at | INTEGER | NOT NULL |
| deleted_at | INTEGER | NULL |

### roles
| Column | Type | Constraints |
|--------|------|-------------|
| id | TEXT | PK |
| code | TEXT | UNIQUE NOT NULL |
| name_fa | TEXT | NOT NULL |
| name_en | TEXT | NULL |
| is_system | INTEGER | NOT NULL DEFAULT 0 |
| description | TEXT | NULL |

### permissions
| Column | Type | Constraints |
|--------|------|-------------|
| id | TEXT | PK |
| code | TEXT | UNIQUE NOT NULL |
| module | TEXT | NOT NULL |
| name_fa | TEXT | NOT NULL |
| name_en | TEXT | NULL |

### role_permissions / user_roles
Junction tables with composite uniqueness.

### employees
| Column | Type | Constraints |
|--------|------|-------------|
| id | TEXT | PK |
| first_name | TEXT | NOT NULL |
| last_name | TEXT | NOT NULL |
| father_name | TEXT | NULL |
| national_id | TEXT | UNIQUE NOT NULL |
| birth_date | TEXT | NULL (YYYY-MM-DD) |
| birth_place | TEXT | NULL |
| gender | TEXT | CHECK |
| marital_status | TEXT | NULL |
| children_count | INTEGER | DEFAULT 0 |
| blood_group | TEXT | NULL |
| military_status | TEXT | NULL |
| personal_description | TEXT | NULL |
| employee_number | TEXT | UNIQUE NULL |
| subscription_number | TEXT | NULL |
| department_id | TEXT | FK |
| unit_id | TEXT | FK |
| current_position | TEXT | NULL |
| previous_position | TEXT | NULL |
| desired_position | TEXT | NULL |
| employment_type | TEXT | NULL |
| employment_date | TEXT | NULL |
| supervisor_id | TEXT | FK self |
| employment_status | TEXT | NOT NULL DEFAULT 'active' |
| created_at / updated_at / deleted_at | INTEGER | |

### employee_contacts / employee_socials / employee_organization
Normalized 1:1 extension tables (organization fields may live on employees for query speed — dual strategy: hot fields on `employees`, extensible JSON reserved).

### employee_education, employee_skills, employee_evaluations
1:N with employee_id FK CASCADE soft-aware.

### employee_documents
| Column | Type | Constraints |
|--------|------|-------------|
| id | TEXT | PK |
| employee_id | TEXT | FK NOT NULL |
| title | TEXT | NOT NULL |
| category | TEXT | NOT NULL |
| description | TEXT | NULL |
| tags | TEXT | NULL (JSON array) |
| file_name | TEXT | NOT NULL |
| mime_type | TEXT | NOT NULL |
| file_size | INTEGER | NOT NULL |
| storage_path | TEXT | NOT NULL (encrypted blob path) |
| content_hash | TEXT | NOT NULL (SHA-256) |
| version | INTEGER | NOT NULL DEFAULT 1 |
| uploaded_by | TEXT | FK users |
| uploaded_at | INTEGER | NOT NULL |

### audit_logs
Append-only. No UPDATE/DELETE from app layer.

| Column | Type |
|--------|------|
| id | TEXT PK |
| actor_user_id | TEXT |
| action | TEXT |
| entity_type | TEXT |
| entity_id | TEXT |
| details_json | TEXT |
| ip_or_device | TEXT |
| created_at | INTEGER |

### settings
key TEXT PK, value TEXT, updated_at INTEGER

### backup_jobs
id, type, schedule, last_run, status, path, signature, created_at

### saved_filters
id, user_id, name, query_json, created_at

### report_templates
id, name, config_json, created_by, created_at

## 3.5 Indexes

```sql
CREATE UNIQUE INDEX idx_employees_national_id ON employees(national_id) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX idx_employees_emp_no ON employees(employee_number) WHERE deleted_at IS NULL;
CREATE INDEX idx_employees_name ON employees(last_name, first_name);
CREATE INDEX idx_employees_dept ON employees(department_id);
CREATE INDEX idx_employees_status ON employees(employment_status);
CREATE INDEX idx_audit_created ON audit_logs(created_at);
CREATE INDEX idx_audit_actor ON audit_logs(actor_user_id);
CREATE INDEX idx_docs_employee ON employee_documents(employee_id);
CREATE INDEX idx_docs_category ON employee_documents(category);
CREATE INDEX idx_users_username ON users(username);
```

## 3.6 Migration Strategy

1. Drift `schemaVersion` integer, incremental migrations in `migration.onUpgrade`
2. Never drop columns in production without dual-write period
3. Seed system roles/permissions in `onCreate`
4. Backup DB file before each schema upgrade (automatic)
5. Migration tests against fixture DBs

## 3.7 Seed Data

- Roles: administrator, hr_manager, operator, viewer
- Full permission catalog (~60 codes)
- Default admin user (force password change on first login)
- Default organization settings (Gas Company Qaemshahr)
- Document categories enum table or const seed

## 3.8 Data Retention

- Soft delete employees/users/documents
- Hard purge only via privileged admin + dual confirmation + audit
- Audit logs retained indefinitely (export/archive tool later)
