using System;
using System.Collections.Generic;
using System.Data.SQLite;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public sealed class SampleTitleRepository
    {
        readonly AppDatabase _db;

        public SampleTitleRepository(AppDatabase db)
        {
            _db = db;
        }

        public List<SampleTitle> List(int year, string kind = null)
        {
            var sql = @"SELECT t.*, e.first_name, e.last_name, e.national_id, e.current_position,
                               e.photo_path, e.gender, e.person_type
                        FROM employee_sample_titles t
                        INNER JOIN employees e ON e.id = t.employee_id
                        WHERE t.year=@y AND e.deleted_at IS NULL
                          AND t.kind IN ('staff_sample','worker_sample')";
            var args = new List<SQLiteParameter> { Sql.P("@y", year) };
            if (!string.IsNullOrWhiteSpace(kind))
            {
                sql += " AND t.kind=@k";
                args.Add(Sql.P("@k", SampleTitleKinds.Normalize(kind)));
            }
            sql += " ORDER BY t.kind, e.last_name, e.first_name";
            var list = new List<SampleTitle>();
            var byId = new Dictionary<string, SampleTitle>(StringComparer.Ordinal);
            using (var r = _db.Query(sql, args.ToArray()))
            {
                while (r.Read())
                {
                    var row = MapTitle(r);
                    list.Add(row);
                    byId[row.Id] = row;
                }
            }
            AttachIntroductions(byId);
            AttachReports(byId);
            return list;
        }

        public List<int> ListYears()
        {
            var years = new List<int>();
            using (var r = _db.Query(
                @"SELECT DISTINCT year FROM employee_sample_titles
                  WHERE kind IN ('staff_sample','worker_sample')
                  ORDER BY year DESC"))
            {
                while (r.Read())
                    years.Add(Sql.Int(r["year"]));
            }
            return years;
        }

        public List<string> ListOrganizations()
        {
            var list = new List<string>();
            using (var r = _db.Query(
                @"SELECT DISTINCT organization FROM employee_sample_introductions
                  WHERE organization IS NOT NULL AND TRIM(organization)<>''
                  ORDER BY organization"))
            {
                while (r.Read())
                    list.Add(Sql.Str(r["organization"]));
            }
            return list;
        }

        public string Upsert(string employeeId, int year, string kind, string note, string createdBy)
        {
            string titleId;
            return Upsert(employeeId, year, kind, note, createdBy, out titleId, true);
        }

        public string Upsert(string employeeId, int year, string kind, string note, string createdBy, out string titleId, bool addReport = true)
        {
            titleId = null;
            if (string.IsNullOrWhiteSpace(employeeId))
                return "کارمند نامعتبر است";
            if (year < 1300 || year > 1600)
                return "سال شمسی نامعتبر است";
            kind = SampleTitleKinds.Normalize(kind);
            note = string.IsNullOrWhiteSpace(note) ? null : note.Trim();
            var now = Sql.Now();
            using (var r = _db.Query(
                "SELECT id FROM employee_sample_titles WHERE employee_id=@e AND year=@y AND kind=@k",
                Sql.P("@e", employeeId), Sql.P("@y", year), Sql.P("@k", kind)))
            {
                if (r.Read())
                {
                    titleId = Sql.Str(r["id"]);
                    _db.Execute(
                        "UPDATE employee_sample_titles SET note=@n, updated_at=@u WHERE id=@id",
                        Sql.P("@n", note), Sql.P("@u", now), Sql.P("@id", titleId));
                    if (addReport && !string.IsNullOrWhiteSpace(note))
                        AddReport(titleId, note, createdBy);
                    return null;
                }
            }
            titleId = Sql.NewId();
            _db.Execute(@"INSERT INTO employee_sample_titles
                (id, employee_id, year, kind, note, created_at, updated_at, created_by)
                VALUES (@id,@e,@y,@k,@n,@c,@u,@by)",
                Sql.P("@id", titleId),
                Sql.P("@e", employeeId),
                Sql.P("@y", year),
                Sql.P("@k", kind),
                Sql.P("@n", note),
                Sql.P("@c", now),
                Sql.P("@u", now),
                Sql.P("@by", createdBy));
            if (addReport)
            {
                AddReport(titleId,
                    string.IsNullOrWhiteSpace(note) ? "ثبت عنوان نمونه" : note,
                    createdBy);
            }
            return null;
        }

        public string AddReport(string sampleTitleId, string body, string createdBy)
        {
            if (string.IsNullOrWhiteSpace(sampleTitleId))
                return "عنوان نمونه نامعتبر است";
            body = (body ?? "").Trim();
            if (body.Length == 0)
                return "متن گزارش را وارد کنید";
            using (var r = _db.Query(
                "SELECT id FROM employee_sample_titles WHERE id=@id",
                Sql.P("@id", sampleTitleId)))
            {
                if (!r.Read())
                    return "عنوان نمونه یافت نشد";
            }
            _db.Execute(
                @"INSERT INTO employee_sample_reports (id, sample_title_id, body, created_at, created_by)
                  VALUES (@id,@s,@b,@c,@by)",
                Sql.P("@id", Sql.NewId()),
                Sql.P("@s", sampleTitleId),
                Sql.P("@b", body),
                Sql.P("@c", Sql.Now()),
                Sql.P("@by", createdBy));
            return null;
        }

        public List<SampleReport> ListReports(string sampleTitleId)
        {
            var list = new List<SampleReport>();
            if (string.IsNullOrWhiteSpace(sampleTitleId))
                return list;
            using (var r = _db.Query(
                @"SELECT id, sample_title_id, body, created_at, created_by
                  FROM employee_sample_reports WHERE sample_title_id=@s
                  ORDER BY created_at DESC",
                Sql.P("@s", sampleTitleId)))
            {
                while (r.Read())
                {
                    list.Add(new SampleReport
                    {
                        Id = Sql.Str(r["id"]),
                        SampleTitleId = Sql.Str(r["sample_title_id"]),
                        Body = Sql.Str(r["body"]),
                        CreatedAt = Sql.Long(r["created_at"]),
                        CreatedBy = Sql.Str(r["created_by"])
                    });
                }
            }
            return list;
        }

        public void DeleteReport(string id)
        {
            if (string.IsNullOrWhiteSpace(id))
                return;
            _db.Execute("DELETE FROM employee_sample_reports WHERE id=@id", Sql.P("@id", id));
        }

        public string AddIntroduction(string sampleTitleId, string organization, string note, string createdBy)
        {
            if (string.IsNullOrWhiteSpace(sampleTitleId))
                return "عنوان نمونه نامعتبر است";
            organization = (organization ?? "").Trim();
            if (organization.Length == 0)
                return "نام سازمان معرفی‌شونده را وارد کنید";
            note = string.IsNullOrWhiteSpace(note) ? null : note.Trim();

            using (var r = _db.Query(
                "SELECT id FROM employee_sample_titles WHERE id=@id AND kind IN ('staff_sample','worker_sample')",
                Sql.P("@id", sampleTitleId)))
            {
                if (!r.Read())
                    return "ابتدا باید فرد به‌عنوان کارمند یا کارگر نمونه ثبت شود";
            }

            using (var r = _db.Query(
                @"SELECT id, organization FROM employee_sample_introductions WHERE sample_title_id=@s",
                Sql.P("@s", sampleTitleId)))
            {
                while (r.Read())
                {
                    var existing = (Sql.Str(r["organization"]) ?? "").Trim();
                    if (string.Equals(existing, organization, StringComparison.CurrentCultureIgnoreCase))
                    {
                        _db.Execute(
                            "UPDATE employee_sample_introductions SET note=@n WHERE id=@id",
                            Sql.P("@n", note), Sql.P("@id", Sql.Str(r["id"])));
                        return null;
                    }
                }
            }

            _db.Execute(@"INSERT INTO employee_sample_introductions
                (id, sample_title_id, organization, note, created_at, created_by)
                VALUES (@id,@s,@o,@n,@c,@by)",
                Sql.P("@id", Sql.NewId()),
                Sql.P("@s", sampleTitleId),
                Sql.P("@o", organization),
                Sql.P("@n", note),
                Sql.P("@c", Sql.Now()),
                Sql.P("@by", createdBy));
            return null;
        }

        public void DeleteIntroduction(string id)
        {
            if (string.IsNullOrWhiteSpace(id))
                return;
            _db.Execute("DELETE FROM employee_sample_introductions WHERE id=@id", Sql.P("@id", id));
        }

        public int CopyYear(int fromYear, int toYear, string createdBy)
        {
            if (fromYear < 1300 || toYear < 1300 || fromYear == toYear)
                return 0;
            var source = List(fromYear, null);
            var added = 0;
            foreach (var row in source)
            {
                using (var r = _db.Query(
                    "SELECT id FROM employee_sample_titles WHERE employee_id=@e AND year=@y AND kind=@k",
                    Sql.P("@e", row.EmployeeId), Sql.P("@y", toYear), Sql.P("@k", row.Kind)))
                {
                    if (r.Read())
                        continue;
                }
                string newId;
                var err = Upsert(row.EmployeeId, toYear, row.Kind, row.Note, createdBy, out newId, false);
                if (err != null)
                    continue;
                added++;
                if (string.IsNullOrEmpty(newId))
                    continue;
                if (row.Introductions != null)
                {
                    foreach (var intro in row.Introductions)
                        AddIntroduction(newId, intro.Organization, intro.Note, createdBy);
                }
                if (row.Reports != null)
                {
                    foreach (var report in row.Reports)
                        AddReport(newId, report.Body, createdBy);
                }
            }
            return added;
        }

        public void Delete(string id)
        {
            if (string.IsNullOrWhiteSpace(id))
                return;
            _db.Execute("DELETE FROM employee_sample_reports WHERE sample_title_id=@id", Sql.P("@id", id));
            _db.Execute("DELETE FROM employee_sample_introductions WHERE sample_title_id=@id", Sql.P("@id", id));
            _db.Execute("DELETE FROM employee_sample_titles WHERE id=@id", Sql.P("@id", id));
        }

        /// <summary>پرچم نمونه و معرفی فراسازمانی سال مشخص + سابقه همه سال‌ها.</summary>
        public void AttachForYear(IList<Employee> people, int year)
        {
            if (people == null || people.Count == 0)
                return;
            var byId = new Dictionary<string, Employee>(StringComparer.Ordinal);
            foreach (var p in people)
            {
                if (p == null || string.IsNullOrEmpty(p.Id))
                    continue;
                p.PerformanceExemplary = false;
                p.ExtraOrgBadge = false;
                p.SampleKind = null;
                p.SampleYear = 0;
                p.SampleHistory = new List<string>();
                p.IntroducedOrganizations = new List<string>();
                byId[p.Id] = p;
            }
            if (byId.Count == 0)
                return;

            var titleIdsForYear = new Dictionary<string, string>(StringComparer.Ordinal);

            using (var r = _db.Query(
                @"SELECT id, employee_id, year, kind FROM employee_sample_titles
                  WHERE kind IN ('staff_sample','worker_sample')
                  ORDER BY year DESC, kind"))
            {
                while (r.Read())
                {
                    var eid = Sql.Str(r["employee_id"]);
                    Employee p;
                    if (string.IsNullOrEmpty(eid) || !byId.TryGetValue(eid, out p))
                        continue;
                    var y = Sql.Int(r["year"]);
                    var kind = SampleTitleKinds.Normalize(Sql.Str(r["kind"]));
                    var tid = Sql.Str(r["id"]);
                    var line = SampleTitleKinds.Fa(kind) + " — " + PersianDate.DigitsFa(y.ToString());
                    if (p.SampleHistory == null)
                        p.SampleHistory = new List<string>();
                    if (!p.SampleHistory.Contains(line))
                        p.SampleHistory.Add(line);

                    if (y != year)
                        continue;
                    titleIdsForYear[tid] = eid;
                    p.SampleYear = year;
                    p.PerformanceExemplary = true;
                    if (kind == SampleTitleKinds.StaffSample)
                        p.SampleKind = SampleTitleKinds.StaffSample;
                    else if (p.SampleKind != SampleTitleKinds.StaffSample)
                        p.SampleKind = SampleTitleKinds.WorkerSample;
                }
            }

            using (var r = _db.Query(
                @"SELECT i.sample_title_id, i.organization, t.employee_id, t.year, t.kind
                  FROM employee_sample_introductions i
                  INNER JOIN employee_sample_titles t ON t.id = i.sample_title_id
                  WHERE t.kind IN ('staff_sample','worker_sample')
                  ORDER BY t.year DESC, i.created_at DESC"))
            {
                while (r.Read())
                {
                    var eid = Sql.Str(r["employee_id"]);
                    Employee p;
                    if (string.IsNullOrEmpty(eid) || !byId.TryGetValue(eid, out p))
                        continue;
                    var y = Sql.Int(r["year"]);
                    var org = (Sql.Str(r["organization"]) ?? "").Trim();
                    if (org.Length == 0)
                        org = "سازمان نامشخص";
                    var line = "معرفی فراسازمانی به " + org + " — " + PersianDate.DigitsFa(y.ToString());
                    if (p.SampleHistory == null)
                        p.SampleHistory = new List<string>();
                    if (!p.SampleHistory.Contains(line))
                        p.SampleHistory.Add(line);

                    if (y != year)
                        continue;
                    p.ExtraOrgBadge = true;
                    if (p.IntroducedOrganizations == null)
                        p.IntroducedOrganizations = new List<string>();
                    if (!p.IntroducedOrganizations.Contains(org))
                        p.IntroducedOrganizations.Add(org);
                }
            }
        }

        void AttachIntroductions(Dictionary<string, SampleTitle> byId)
        {
            if (byId == null || byId.Count == 0)
                return;
            using (var r = _db.Query(
                @"SELECT i.*, t.employee_id, t.year, t.kind, e.first_name, e.last_name
                  FROM employee_sample_introductions i
                  INNER JOIN employee_sample_titles t ON t.id = i.sample_title_id
                  INNER JOIN employees e ON e.id = t.employee_id
                  ORDER BY i.created_at DESC"))
            {
                while (r.Read())
                {
                    var sid = Sql.Str(r["sample_title_id"]);
                    SampleTitle title;
                    if (string.IsNullOrEmpty(sid) || !byId.TryGetValue(sid, out title))
                        continue;
                    if (title.Introductions == null)
                        title.Introductions = new List<SampleIntroduction>();
                    var fn = Sql.Str(r["first_name"]) ?? "";
                    var ln = Sql.Str(r["last_name"]) ?? "";
                    title.Introductions.Add(new SampleIntroduction
                    {
                        Id = Sql.Str(r["id"]),
                        SampleTitleId = sid,
                        EmployeeId = Sql.Str(r["employee_id"]),
                        EmployeeName = (fn + " " + ln).Trim(),
                        Year = Sql.Int(r["year"]),
                        SampleKind = SampleTitleKinds.Normalize(Sql.Str(r["kind"])),
                        Organization = Sql.Str(r["organization"]),
                        Note = Sql.Str(r["note"]),
                        CreatedAt = Sql.Long(r["created_at"]),
                        CreatedBy = Sql.Str(r["created_by"])
                    });
                }
            }
        }

        void AttachReports(Dictionary<string, SampleTitle> byId)
        {
            if (byId == null || byId.Count == 0)
                return;
            using (var r = _db.Query(
                @"SELECT id, sample_title_id, body, created_at, created_by
                  FROM employee_sample_reports
                  ORDER BY created_at DESC"))
            {
                while (r.Read())
                {
                    var sid = Sql.Str(r["sample_title_id"]);
                    SampleTitle title;
                    if (string.IsNullOrEmpty(sid) || !byId.TryGetValue(sid, out title))
                        continue;
                    if (title.Reports == null)
                        title.Reports = new List<SampleReport>();
                    title.Reports.Add(new SampleReport
                    {
                        Id = Sql.Str(r["id"]),
                        SampleTitleId = sid,
                        Body = Sql.Str(r["body"]),
                        CreatedAt = Sql.Long(r["created_at"]),
                        CreatedBy = Sql.Str(r["created_by"])
                    });
                }
            }
        }

        static SampleTitle MapTitle(SQLiteDataReader r)
        {
            var fn = Sql.Str(r["first_name"]) ?? "";
            var ln = Sql.Str(r["last_name"]) ?? "";
            return new SampleTitle
            {
                Id = Sql.Str(r["id"]),
                EmployeeId = Sql.Str(r["employee_id"]),
                EmployeeName = (fn + " " + ln).Trim(),
                NationalId = Sql.Str(r["national_id"]),
                Position = Sql.Str(r["current_position"]),
                PhotoPath = HasCol(r, "photo_path") ? Sql.Str(r["photo_path"]) : null,
                Gender = HasCol(r, "gender") ? HrLookups.NormalizeGender(Sql.Str(r["gender"])) : null,
                PersonType = HasCol(r, "person_type")
                    ? HrLookups.NormalizePersonType(Sql.Str(r["person_type"]))
                    : HrLookups.PersonStaff,
                Year = Sql.Int(r["year"]),
                Kind = SampleTitleKinds.Normalize(Sql.Str(r["kind"])),
                Note = Sql.Str(r["note"]),
                CreatedAt = Sql.Long(r["created_at"]),
                UpdatedAt = Sql.Long(r["updated_at"]),
                CreatedBy = Sql.Str(r["created_by"]),
                Introductions = new List<SampleIntroduction>(),
                Reports = new List<SampleReport>()
            };
        }

        static bool HasCol(SQLiteDataReader r, string name)
        {
            for (var i = 0; i < r.FieldCount; i++)
            {
                if (string.Equals(r.GetName(i), name, StringComparison.OrdinalIgnoreCase))
                    return true;
            }
            return false;
        }
    }
}
