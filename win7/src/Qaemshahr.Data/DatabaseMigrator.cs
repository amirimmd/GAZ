using System;
using System.Collections.Generic;
using Qaemshahr.Core;

namespace Qaemshahr.Data
{
    public static class DatabaseMigrator
    {
        public static void Upgrade(AppDatabase db, int from, int to)
        {
            for (var v = from + 1; v <= to; v++)
                Apply(db, v);
            db.SetUserVersion(to);
        }

        static void Apply(AppDatabase db, int version)
        {
            if (version == 2)
                EnsureGroupPermissions(db);
            if (version == 3)
                EnsurePerformanceTables(db);
            if (version == 4)
                EnsureAttendance(db);
            if (version == 5)
                EnsureOfficialJobFields(db);
            if (version == 6)
                EnsureFieldSuggestions(db);
            if (version == 7)
                EnsureSampleTitles(db);
            if (version == 8)
                EnsurePersonType(db);
            if (version == 9)
                EnsureSampleIntroductions(db);
            if (version == 10)
                EnsureRetirementFields(db);
            if (version == 11)
                EnsureGroupActivities(db);
            if (version == 12)
                EnsureGroupPhoto(db);
            if (version == 13)
                EnsureEmployeeExtraFieldsAndDropAttendance(db);
            if (version == 14)
                EnsureSampleReports(db);
        }

        static void EnsureSampleReports(AppDatabase db)
        {
            db.Execute(@"
CREATE TABLE IF NOT EXISTS employee_sample_reports (
  id TEXT PRIMARY KEY,
  sample_title_id TEXT NOT NULL REFERENCES employee_sample_titles(id) ON DELETE CASCADE,
  body TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  created_by TEXT NULL
)");
            db.Execute("CREATE INDEX IF NOT EXISTS idx_sample_reports_title ON employee_sample_reports(sample_title_id)");
            // انتقال یادداشت قدیمی عنوان نمونه به گزارش
            using (var r = db.Query(
                @"SELECT id, note, created_at, created_by FROM employee_sample_titles
                  WHERE note IS NOT NULL AND TRIM(note)<>''"))
            {
                while (r.Read())
                {
                    var tid = Sql.Str(r["id"]);
                    var note = (Sql.Str(r["note"]) ?? "").Trim();
                    if (string.IsNullOrEmpty(tid) || note.Length == 0)
                        continue;
                    var exists = Sql.Int(db.Scalar(
                        "SELECT COUNT(*) FROM employee_sample_reports WHERE sample_title_id=@s",
                        Sql.P("@s", tid)));
                    if (exists > 0)
                        continue;
                    db.Execute(
                        @"INSERT INTO employee_sample_reports (id, sample_title_id, body, created_at, created_by)
                          VALUES (@id,@s,@b,@c,@by)",
                        Sql.P("@id", Sql.NewId()),
                        Sql.P("@s", tid),
                        Sql.P("@b", note),
                        Sql.P("@c", Sql.Long(r["created_at"])),
                        Sql.P("@by", Sql.Str(r["created_by"])));
                }
            }
        }

        static void EnsureGroupPhoto(AppDatabase db)
        {
            EnsureColumn(db, "employee_groups", "photo_path", "TEXT NULL");
        }

        static void EnsureEmployeeExtraFieldsAndDropAttendance(AppDatabase db)
        {
            EnsureColumn(db, "employees", "id_booklet_number", "TEXT NULL");
            EnsureColumn(db, "employees", "service_city", "TEXT NULL");
            EnsureColumn(db, "employees", "veteran_status", "TEXT NULL");
            EnsureColumn(db, "employees", "iban1", "TEXT NULL");
            EnsureColumn(db, "employees", "iban2", "TEXT NULL");

            try { db.Execute("DROP TABLE IF EXISTS attendance_records"); }
            catch { }

            try
            {
                db.Execute("DELETE FROM role_permissions WHERE permission_id IN (SELECT id FROM permissions WHERE code IN ('attendance.view','attendance.edit'))");
                db.Execute("DELETE FROM permissions WHERE code IN ('attendance.view','attendance.edit')");
            }
            catch { }
        }

        static void EnsureGroupActivities(AppDatabase db)
        {
            db.Execute(@"
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
)");
            db.Execute("CREATE INDEX IF NOT EXISTS idx_group_activities_group ON employee_group_activities(group_id, created_at DESC)");
        }

        static void EnsureRetirementFields(AppDatabase db)
        {
            EnsureColumn(db, "employees", "retirement_date", "TEXT NULL");
            EnsureColumn(db, "employees", "inactive_reason", "TEXT NULL");
        }

        static void EnsureSampleIntroductions(AppDatabase db)
        {
            db.Execute(@"
CREATE TABLE IF NOT EXISTS employee_sample_introductions (
  id TEXT NOT NULL PRIMARY KEY,
  sample_title_id TEXT NOT NULL REFERENCES employee_sample_titles(id) ON DELETE CASCADE,
  organization TEXT NOT NULL,
  note TEXT NULL,
  created_at INTEGER NOT NULL,
  created_by TEXT NULL
)");
            db.Execute("CREATE INDEX IF NOT EXISTS idx_sample_intros_title ON employee_sample_introductions(sample_title_id)");

            // مهاجرت عنوان قدیمی extra_org → معرفی فراسازمانی روی عنوان نمونه
            using (var r = db.Query(
                "SELECT id, employee_id, year, note, created_at, created_by FROM employee_sample_titles WHERE kind='extra_org'"))
            {
                var rows = new List<Dictionary<string, object>>();
                while (r.Read())
                {
                    rows.Add(new Dictionary<string, object>
                    {
                        ["id"] = Sql.Str(r["id"]),
                        ["employee_id"] = Sql.Str(r["employee_id"]),
                        ["year"] = Sql.Int(r["year"]),
                        ["note"] = Sql.Str(r["note"]),
                        ["created_at"] = Sql.Long(r["created_at"]),
                        ["created_by"] = Sql.Str(r["created_by"])
                    });
                }
                foreach (var row in rows)
                {
                    var eid = Convert.ToString(row["employee_id"]);
                    var year = Convert.ToInt32(row["year"]);
                    var note = Convert.ToString(row["note"]);
                    var createdBy = Convert.ToString(row["created_by"]);
                    var createdAt = Convert.ToInt64(row["created_at"]);
                    var oldId = Convert.ToString(row["id"]);

                    string sampleId = null;
                    using (var s = db.Query(
                        @"SELECT id FROM employee_sample_titles
                          WHERE employee_id=@e AND year=@y AND kind IN ('staff_sample','worker_sample')
                          ORDER BY CASE kind WHEN 'staff_sample' THEN 0 ELSE 1 END LIMIT 1",
                        Sql.P("@e", eid), Sql.P("@y", year)))
                    {
                        if (s.Read())
                            sampleId = Sql.Str(s["id"]);
                    }
                    if (string.IsNullOrEmpty(sampleId))
                    {
                        var personType = "staff";
                        using (var p = db.Query("SELECT person_type FROM employees WHERE id=@id", Sql.P("@id", eid)))
                        {
                            if (p.Read())
                                personType = HrLookups.NormalizePersonType(Sql.Str(p["person_type"]));
                        }
                        var kind = personType == HrLookups.PersonWorker ? "worker_sample" : "staff_sample";
                        sampleId = Sql.NewId();
                        var now = Sql.Now();
                        db.Execute(@"INSERT INTO employee_sample_titles
                            (id, employee_id, year, kind, note, created_at, updated_at, created_by)
                            VALUES (@id,@e,@y,@k,NULL,@c,@u,@by)",
                            Sql.P("@id", sampleId), Sql.P("@e", eid), Sql.P("@y", year), Sql.P("@k", kind),
                            Sql.P("@c", createdAt > 0 ? createdAt : now),
                            Sql.P("@u", now), Sql.P("@by", createdBy));
                    }

                    var org = string.IsNullOrWhiteSpace(note) ? "سازمان بالاتر" : note.Trim();
                    if (org.Length > 120)
                        org = org.Substring(0, 120);
                    db.Execute(@"INSERT INTO employee_sample_introductions
                        (id, sample_title_id, organization, note, created_at, created_by)
                        VALUES (@id,@sid,@org,@n,@c,@by)",
                        Sql.P("@id", Sql.NewId()),
                        Sql.P("@sid", sampleId),
                        Sql.P("@org", org),
                        Sql.P("@n", string.IsNullOrWhiteSpace(note) ? null : note),
                        Sql.P("@c", createdAt > 0 ? createdAt : Sql.Now()),
                        Sql.P("@by", createdBy));

                    db.Execute("DELETE FROM employee_sample_titles WHERE id=@id", Sql.P("@id", oldId));
                }
            }
        }

        static void EnsurePersonType(AppDatabase db)
        {
            EnsureColumn(db, "employees", "person_type", "TEXT NOT NULL DEFAULT 'staff'");
            db.Execute("UPDATE employees SET person_type='staff' WHERE person_type IS NULL OR TRIM(person_type)=''");
        }

        static void EnsureSampleTitles(AppDatabase db)
        {
            db.Execute(@"
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
)");
            db.Execute("CREATE INDEX IF NOT EXISTS idx_sample_titles_year ON employee_sample_titles(year, kind)");
        }

        static void EnsureFieldSuggestions(AppDatabase db)
        {
            db.Execute(@"
CREATE TABLE IF NOT EXISTS field_suggestions (
  category TEXT NOT NULL,
  value TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  PRIMARY KEY (category, value)
)");
            db.Execute("CREATE INDEX IF NOT EXISTS idx_field_suggestions_cat ON field_suggestions(category)");
            new FieldSuggestionRepository(db).SeedFromEmployeesIfEmpty();
        }

        static void EnsureOfficialJobFields(AppDatabase db)
        {
            EnsureColumn(db, "employees", "job_group", "TEXT NULL");
            EnsureColumn(db, "employees", "position_base", "REAL NULL");
            EnsureColumn(db, "employees", "personal_base", "REAL NULL");
        }

        static void EnsureColumn(AppDatabase db, string table, string column, string decl)
        {
            var exists = false;
            using (var r = db.Query("PRAGMA table_info(" + table + ")"))
            {
                while (r.Read())
                {
                    if (string.Equals(Sql.Str(r["name"]), column, StringComparison.OrdinalIgnoreCase))
                    {
                        exists = true;
                        break;
                    }
                }
            }
            if (!exists)
                db.Execute("ALTER TABLE " + table + " ADD COLUMN " + column + " " + decl);
        }

        static void EnsurePerformanceTables(AppDatabase db)
        {
            db.Execute(@"
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
)");
            db.Execute(@"
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
)");
            db.Execute("CREATE INDEX IF NOT EXISTS idx_perf_emp_status ON employee_performance_reviews(employee_id, status, year DESC, season DESC)");
        }

        static void EnsureAttendance(AppDatabase db)
        {
            db.Execute(@"
CREATE TABLE IF NOT EXISTS attendance_records (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  work_date TEXT NOT NULL,
  status TEXT NOT NULL,
  check_in TEXT NULL,
  check_out TEXT NULL,
  hours REAL NULL,
  note TEXT NULL,
  created_by TEXT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE (employee_id, work_date)
)");
            db.Execute("CREATE INDEX IF NOT EXISTS idx_att_date ON attendance_records(work_date)");
            db.Execute("CREATE INDEX IF NOT EXISTS idx_att_emp ON attendance_records(employee_id, work_date)");

            // فقط برای ارتقای پایگاه‌های قدیمی؛ در نسخه ۱۳ حذف می‌شود.
            var codes = new[] { "attendance.view", "attendance.edit" };
            foreach (var code in codes)
            {
                var exists = db.Scalar(
                    "SELECT id FROM permissions WHERE code = @c",
                    new System.Data.SQLite.SQLiteParameter("@c", code));
                if (exists != null && exists != DBNull.Value)
                    continue;
                var id = Guid.NewGuid().ToString();
                db.Execute(
                    "INSERT INTO permissions (id, code, module, name_fa, name_en) VALUES (@id,@c,'attendance',@c,@c)",
                    new System.Data.SQLite.SQLiteParameter("@id", id),
                    new System.Data.SQLite.SQLiteParameter("@c", code));
            }

            GrantAllToRole(db, "administrator", PermissionCodes.All);
            GrantAllToRole(db, "hr_manager", codes);
            GrantAllToRole(db, "operator", codes);
            GrantAllToRole(db, "viewer", new[] { "attendance.view" });
        }

        static void EnsureGroupPermissions(AppDatabase db)
        {
            var codes = new[]
            {
                PermissionCodes.GroupsView,
                PermissionCodes.GroupsCreate,
                PermissionCodes.GroupsEdit,
                PermissionCodes.GroupsDelete,
                PermissionCodes.GroupsExport
            };
            foreach (var code in codes)
            {
                var exists = db.Scalar(
                    "SELECT id FROM permissions WHERE code = @c",
                    new System.Data.SQLite.SQLiteParameter("@c", code));
                if (exists != null && exists != DBNull.Value)
                    continue;
                var id = Guid.NewGuid().ToString();
                db.Execute(
                    "INSERT INTO permissions (id, code, module, name_fa, name_en) VALUES (@id,@c,'groups',@c,@c)",
                    new System.Data.SQLite.SQLiteParameter("@id", id),
                    new System.Data.SQLite.SQLiteParameter("@c", code));
            }

            GrantAllToRole(db, "administrator", PermissionCodes.All);
            GrantAllToRole(db, "hr_manager", codes);
        }

        static void GrantAllToRole(AppDatabase db, string roleCode, IReadOnlyList<string> codes)
        {
            var roleId = db.Scalar("SELECT id FROM roles WHERE code = @c",
                new System.Data.SQLite.SQLiteParameter("@c", roleCode));
            if (roleId == null || roleId == DBNull.Value)
                return;
            foreach (var code in codes)
            {
                var pid = db.Scalar("SELECT id FROM permissions WHERE code = @c",
                    new System.Data.SQLite.SQLiteParameter("@c", code));
                if (pid == null || pid == DBNull.Value)
                    continue;
                db.Execute(
                    "INSERT OR IGNORE INTO role_permissions (role_id, permission_id) VALUES (@r,@p)",
                    new System.Data.SQLite.SQLiteParameter("@r", roleId.ToString()),
                    new System.Data.SQLite.SQLiteParameter("@p", pid.ToString()));
            }
        }
    }
}
