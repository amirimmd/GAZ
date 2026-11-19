namespace Qaemshahr.Data
{
    /// <summary>دستورات CREATE پایه؛ نسخهٔ نهایی از طریق DatabaseMigrator اعمال می‌شود.</summary>
    public static class SchemaSql
    {
        public const string CreateAll = @"
CREATE TABLE IF NOT EXISTS users (
  id TEXT NOT NULL PRIMARY KEY,
  username TEXT NOT NULL,
  display_name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1,
  failed_attempts INTEGER NOT NULL DEFAULT 0,
  locked_until INTEGER NULL,
  must_change_password INTEGER NOT NULL DEFAULT 0,
  remember_me_enabled INTEGER NOT NULL DEFAULT 0,
  last_login_at INTEGER NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);
CREATE TABLE IF NOT EXISTS roles (
  id TEXT NOT NULL PRIMARY KEY,
  code TEXT NOT NULL,
  name_fa TEXT NOT NULL,
  name_en TEXT NULL,
  is_system INTEGER NOT NULL DEFAULT 0,
  description TEXT NULL
);
CREATE TABLE IF NOT EXISTS permissions (
  id TEXT NOT NULL PRIMARY KEY,
  code TEXT NOT NULL,
  module TEXT NOT NULL,
  name_fa TEXT NOT NULL,
  name_en TEXT NULL
);
CREATE TABLE IF NOT EXISTS user_roles (
  user_id TEXT NOT NULL REFERENCES users(id),
  role_id TEXT NOT NULL REFERENCES roles(id),
  PRIMARY KEY (user_id, role_id)
);
CREATE TABLE IF NOT EXISTS role_permissions (
  role_id TEXT NOT NULL REFERENCES roles(id),
  permission_id TEXT NOT NULL REFERENCES permissions(id),
  PRIMARY KEY (role_id, permission_id)
);
CREATE TABLE IF NOT EXISTS sessions (
  id TEXT NOT NULL PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id),
  token_hash TEXT NOT NULL,
  expires_at INTEGER NOT NULL,
  last_activity_at INTEGER NOT NULL,
  device_info TEXT NULL,
  is_valid INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS departments (
  id TEXT NOT NULL PRIMARY KEY,
  name_fa TEXT NOT NULL,
  name_en TEXT NULL,
  code TEXT NULL,
  is_active INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS units (
  id TEXT NOT NULL PRIMARY KEY,
  department_id TEXT NOT NULL REFERENCES departments(id),
  name_fa TEXT NOT NULL,
  name_en TEXT NULL,
  code TEXT NULL
);
CREATE TABLE IF NOT EXISTS employees (
  id TEXT NOT NULL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  father_name TEXT NULL,
  national_id TEXT NOT NULL,
  id_booklet_number TEXT NULL,
  birth_date TEXT NULL,
  birth_place TEXT NULL,
  service_city TEXT NULL,
  veteran_status TEXT NULL,
  iban1 TEXT NULL,
  iban2 TEXT NULL,
  gender TEXT NULL,
  marital_status TEXT NULL,
  children_count INTEGER NOT NULL DEFAULT 0,
  blood_group TEXT NULL,
  military_status TEXT NULL,
  personal_description TEXT NULL,
  photo_path TEXT NULL,
  employee_number TEXT NULL,
  subscription_number TEXT NULL,
  department_id TEXT NULL REFERENCES departments(id),
  unit_id TEXT NULL REFERENCES units(id),
  current_position TEXT NULL,
  previous_position TEXT NULL,
  desired_position TEXT NULL,
  employment_type TEXT NULL,
  employment_date TEXT NULL,
  supervisor_id TEXT NULL,
  employment_status TEXT NOT NULL DEFAULT 'active',
  person_type TEXT NOT NULL DEFAULT 'staff',
  retirement_date TEXT NULL,
  inactive_reason TEXT NULL,
  job_group TEXT NULL,
  position_base REAL NULL,
  personal_base REAL NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);
CREATE TABLE IF NOT EXISTS employee_contacts (
  employee_id TEXT NOT NULL PRIMARY KEY REFERENCES employees(id),
  primary_phone TEXT NULL,
  secondary_phone TEXT NULL,
  emergency_phone TEXT NULL,
  email TEXT NULL,
  home_address TEXT NULL,
  postal_code TEXT NULL
);
CREATE TABLE IF NOT EXISTS employee_socials (
  employee_id TEXT NOT NULL PRIMARY KEY REFERENCES employees(id),
  telegram TEXT NULL,
  whatsapp TEXT NULL,
  instagram TEXT NULL,
  linkedin TEXT NULL,
  other_links_json TEXT NULL
);
CREATE TABLE IF NOT EXISTS employee_educations (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  education_level TEXT NULL,
  major TEXT NULL,
  university TEXT NULL,
  graduation_date TEXT NULL,
  gpa REAL NULL,
  certificates TEXT NULL
);
CREATE TABLE IF NOT EXISTS employee_skills (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  skill_name TEXT NOT NULL,
  level TEXT NULL,
  certificate TEXT NULL,
  expiry_date TEXT NULL,
  attachment_path TEXT NULL
);
CREATE TABLE IF NOT EXISTS employee_interests (
  employee_id TEXT NOT NULL PRIMARY KEY REFERENCES employees(id),
  career_interests TEXT NULL,
  technical_interests TEXT NULL,
  management_interests TEXT NULL,
  personal_interests TEXT NULL,
  talent_assessment TEXT NULL,
  behavior_assessment TEXT NULL,
  psychological_notes TEXT NULL,
  manager_notes TEXT NULL
);
CREATE TABLE IF NOT EXISTS employee_insurances (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  responsibility TEXT NULL,
  insurance_number TEXT NULL,
  insurance_type TEXT NULL,
  insurance_status TEXT NULL,
  notes TEXT NULL,
  effective_from INTEGER NULL,
  effective_to INTEGER NULL,
  created_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS employee_evaluations (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  year INTEGER NOT NULL,
  score REAL NULL,
  evaluator TEXT NULL,
  evaluation_date TEXT NULL,
  strengths TEXT NULL,
  weaknesses TEXT NULL,
  improvement_plan TEXT NULL,
  attachment_path TEXT NULL,
  created_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS employee_performance_reviews (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  year INTEGER NOT NULL,
  season INTEGER NOT NULL,
  track TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'draft',
  evaluator_name TEXT NULL,
  evaluator_user_id TEXT NULL,
  notes TEXT NULL,
  check_in TEXT NULL,
  check_out TEXT NULL,
  presence_hours REAL NULL,
  duty_hours REAL NULL,
  worksheet_count INTEGER NOT NULL DEFAULT 0,
  worksheet_quota INTEGER NOT NULL DEFAULT 0,
  complaints_filed INTEGER NOT NULL DEFAULT 0,
  complaints_valid INTEGER NOT NULL DEFAULT 0,
  complaints_answered INTEGER NOT NULL DEFAULT 0,
  response_quality INTEGER NOT NULL DEFAULT 5,
  social_participation INTEGER NOT NULL DEFAULT 3,
  extra_effort INTEGER NOT NULL DEFAULT 3,
  extra_human_capital INTEGER NOT NULL DEFAULT 3,
  extra_org_relations INTEGER NOT NULL DEFAULT 3,
  extra_club INTEGER NOT NULL DEFAULT 3,
  extra_evidence TEXT NULL,
  expected_projects INTEGER NOT NULL DEFAULT 0,
  expected_volume REAL NOT NULL DEFAULT 0,
  expected_checklists INTEGER NOT NULL DEFAULT 0,
  main_score REAL NULL,
  extra_score REAL NULL,
  light_code TEXT NULL,
  safety_red_flag INTEGER NOT NULL DEFAULT 0,
  exemplary INTEGER NOT NULL DEFAULT 0,
  extra_org_badge INTEGER NOT NULL DEFAULT 0,
  approved_at INTEGER NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE (employee_id, year, season, track)
);
CREATE TABLE IF NOT EXISTS employee_worker_projects (
  id TEXT NOT NULL PRIMARY KEY,
  review_id TEXT NOT NULL REFERENCES employee_performance_reviews(id),
  title TEXT NOT NULL,
  level INTEGER NOT NULL,
  hours REAL NOT NULL,
  progress_percent REAL NOT NULL,
  checklist_count INTEGER NOT NULL DEFAULT 0,
  incidents_direct INTEGER NOT NULL DEFAULT 0,
  incidents_indirect INTEGER NOT NULL DEFAULT 0,
  severe INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_perf_emp_status ON employee_performance_reviews(employee_id, status, year DESC, season DESC);
CREATE TABLE IF NOT EXISTS employee_documents (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  description TEXT NULL,
  tags_json TEXT NULL,
  file_name TEXT NOT NULL,
  mime_type TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  storage_path TEXT NOT NULL,
  content_hash TEXT NOT NULL,
  version INTEGER NOT NULL DEFAULT 1,
  uploaded_by TEXT NULL,
  uploaded_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);
CREATE TABLE IF NOT EXISTS employee_groups (
  id TEXT NOT NULL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NULL,
  purpose_type TEXT NOT NULL,
  starts_at INTEGER NULL,
  ends_at INTEGER NULL,
  status TEXT NOT NULL DEFAULT 'active',
  photo_path TEXT NULL,
  created_by TEXT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);
CREATE TABLE IF NOT EXISTS employee_group_members (
  id TEXT NOT NULL PRIMARY KEY,
  group_id TEXT NOT NULL REFERENCES employee_groups(id),
  employee_id TEXT NOT NULL REFERENCES employees(id),
  added_at INTEGER NOT NULL,
  added_by TEXT NULL,
  UNIQUE (group_id, employee_id)
);
CREATE TABLE IF NOT EXISTS employee_group_activities (
  id TEXT NOT NULL PRIMARY KEY,
  group_id TEXT NOT NULL REFERENCES employee_groups(id),
  title TEXT NOT NULL,
  note TEXT NULL,
  activity_date TEXT NULL,
  created_by TEXT NULL,
  created_by_name TEXT NULL,
  created_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);
CREATE INDEX IF NOT EXISTS idx_group_activities_group ON employee_group_activities(group_id, created_at DESC);
CREATE TABLE IF NOT EXISTS audit_logs (
  id TEXT NOT NULL PRIMARY KEY,
  actor_user_id TEXT NULL,
  actor_username TEXT NULL,
  action TEXT NOT NULL,
  entity_type TEXT NULL,
  entity_id TEXT NULL,
  details_json TEXT NULL,
  device_info TEXT NULL,
  created_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS app_settings (
  key TEXT NOT NULL PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS field_suggestions (
  category TEXT NOT NULL,
  value TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  PRIMARY KEY (category, value)
);
CREATE INDEX IF NOT EXISTS idx_field_suggestions_cat ON field_suggestions(category);
CREATE TABLE IF NOT EXISTS saved_filters (
  id TEXT NOT NULL PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  query_json TEXT NOT NULL,
  created_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS report_templates (
  id TEXT NOT NULL PRIMARY KEY,
  name TEXT NOT NULL,
  config_json TEXT NOT NULL,
  created_by TEXT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS employee_sample_titles (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  year INTEGER NOT NULL,
  kind TEXT NOT NULL,
  note TEXT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  created_by TEXT NULL,
  UNIQUE (employee_id, year, kind)
);
CREATE INDEX IF NOT EXISTS idx_sample_titles_year ON employee_sample_titles(year, kind);
CREATE TABLE IF NOT EXISTS employee_sample_introductions (
  id TEXT NOT NULL PRIMARY KEY,
  sample_title_id TEXT NOT NULL REFERENCES employee_sample_titles(id) ON DELETE CASCADE,
  organization TEXT NOT NULL,
  note TEXT NULL,
  created_at INTEGER NOT NULL,
  created_by TEXT NULL
);
CREATE INDEX IF NOT EXISTS idx_sample_intros_title ON employee_sample_introductions(sample_title_id);
CREATE TABLE IF NOT EXISTS employee_sample_reports (
  id TEXT NOT NULL PRIMARY KEY,
  sample_title_id TEXT NOT NULL REFERENCES employee_sample_titles(id) ON DELETE CASCADE,
  body TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  created_by TEXT NULL
);
CREATE INDEX IF NOT EXISTS idx_sample_reports_title ON employee_sample_reports(sample_title_id);

CREATE TABLE IF NOT EXISTS backup_jobs (
  id TEXT NOT NULL PRIMARY KEY,
  type TEXT NOT NULL,
  schedule TEXT NULL,
  last_run_at INTEGER NULL,
  status TEXT NULL,
  path TEXT NULL,
  signature TEXT NULL,
  content_hash TEXT NULL,
  created_at INTEGER NOT NULL
);
";
    }
}
