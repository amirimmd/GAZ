using System;
using System.Collections.Generic;
using System.Data.SQLite;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public sealed class EmployeeRepository
    {
        readonly AppDatabase _db;

        public EmployeeRepository(AppDatabase db)
        {
            _db = db;
        }

        public List<Employee> Search(ParsedQuery query, string status = null, int limit = 2000)
        {
            return Search(query, status, limit, true);
        }

        public List<Employee> Search(ParsedQuery query, string status, int limit, bool attachPerformance)
        {
            var sql = "SELECT e.*, c.primary_phone, c.secondary_phone, c.emergency_phone, c.email, c.home_address, c.postal_code, " +
                      "s.telegram, s.whatsapp, s.instagram, s.linkedin " +
                      "FROM employees e " +
                      "LEFT JOIN employee_contacts c ON c.employee_id = e.id " +
                      "LEFT JOIN employee_socials s ON s.employee_id = e.id " +
                      "WHERE e.deleted_at IS NULL";
            if (!string.IsNullOrEmpty(status))
                sql += " AND e.employment_status = @st";
            sql += " ORDER BY e.last_name, e.first_name";

            var list = new List<Employee>();
            using (var r = _db.Query(sql, string.IsNullOrEmpty(status) ? new SQLiteParameter[0] : new[] { Sql.P("@st", status) }))
            {
                while (r.Read())
                    list.Add(Map(r));
            }

            if (query != null && query.HasBoolean)
            {
                list = ApplyBoolean(list, query);
            }
            if (limit > 0 && list.Count > limit)
                list = list.GetRange(0, limit);
            HydrateExtras(list);
            if (attachPerformance)
            {
                new PerformanceReviewRepository(_db).AttachLatestApproved(list);
                new SampleTitleRepository(_db).AttachForYear(list, PersianDate.CurrentYear());
            }
            return list;
        }

        /// <summary>فهرست سبک برای انتخاب در فرم‌ها — بدون تماس/شبکه/چراغ.</summary>
        public List<Employee> ListPicker(int limit = 5000)
        {
            var list = new List<Employee>();
            var sql = "SELECT id, first_name, last_name, national_id, current_position, employment_status, person_type, photo_path " +
                      "FROM employees WHERE deleted_at IS NULL ORDER BY last_name, first_name";
            if (limit > 0)
                sql += " LIMIT " + limit;
            using (var r = _db.Query(sql))
            {
                while (r.Read())
                {
                    list.Add(new Employee
                    {
                        Id = Sql.Str(r["id"]),
                        FirstName = Sql.Str(r["first_name"]),
                        LastName = Sql.Str(r["last_name"]),
                        NationalId = Sql.Str(r["national_id"]),
                        CurrentPosition = Sql.Str(r["current_position"]),
                        EmploymentStatus = Sql.Str(r["employment_status"]) ?? "active",
                        PersonType = HasCol(r, "person_type")
                            ? HrLookups.NormalizePersonType(Sql.Str(r["person_type"]))
                            : HrLookups.PersonStaff,
                        PhotoPath = HasCol(r, "photo_path") ? Sql.Str(r["photo_path"]) : null
                    });
                }
            }
            return list;
        }

        public Employee GetById(string id)
        {
            using (var r = _db.Query(
                "SELECT e.*, c.primary_phone, c.secondary_phone, c.emergency_phone, c.email, c.home_address, c.postal_code, " +
                "s.telegram, s.whatsapp, s.instagram, s.linkedin " +
                "FROM employees e " +
                "LEFT JOIN employee_contacts c ON c.employee_id = e.id " +
                "LEFT JOIN employee_socials s ON s.employee_id = e.id " +
                "WHERE e.id=@id AND e.deleted_at IS NULL",
                Sql.P("@id", id)))
            {
                if (!r.Read())
                    return null;
                var e = Map(r);
                HydrateExtras(e);
                return e;
            }
        }

        /// <summary>گروه‌های شغلی یکتا که قبلاً برای پرسنل ذخیره شده‌اند (پیشنهاد ComboBox).</summary>
        public List<string> ListDistinctJobGroups()
        {
            var list = new List<string>();
            using (var r = _db.Query(
                "SELECT DISTINCT TRIM(job_group) AS g FROM employees " +
                "WHERE deleted_at IS NULL AND job_group IS NOT NULL AND TRIM(job_group) <> '' " +
                "ORDER BY g COLLATE NOCASE"))
            {
                while (r.Read())
                {
                    var g = Sql.Str(r["g"]);
                    if (!string.IsNullOrWhiteSpace(g))
                        list.Add(g.Trim());
                }
            }
            return list;
        }

        public string Save(Employee e, bool isNew)
        {
            if (e == null)
                return "داده نامعتبر است";
            if (string.IsNullOrWhiteSpace(e.FirstName) || string.IsNullOrWhiteSpace(e.LastName))
                return "نام و نام خانوادگی الزامی است";
            if (!IranianNationalId.IsValid(e.NationalId ?? string.Empty))
                return "کد ملی نامعتبر است";
            if (!string.IsNullOrWhiteSpace(e.BirthDate))
            {
                var birth = PersianDate.Normalize(e.BirthDate);
                if (birth == null)
                    return "تاریخ تولد نامعتبر است";
                e.BirthDate = birth;
            }
            else
                e.BirthDate = null;
            if (!string.IsNullOrWhiteSpace(e.EmploymentDate))
            {
                var hired = PersianDate.Normalize(e.EmploymentDate);
                if (hired == null)
                    return "تاریخ استخدام نامعتبر است";
                e.EmploymentDate = hired;
            }
            else
                e.EmploymentDate = null;

            if (!string.IsNullOrWhiteSpace(e.RetirementDate))
            {
                var retired = PersianDate.Normalize(e.RetirementDate);
                if (retired == null)
                    return "تاریخ بازنشستگی نامعتبر است";
                e.RetirementDate = retired;
            }
            else
                e.RetirementDate = null;

            var dup = _db.Scalar(
                "SELECT id FROM employees WHERE national_id=@n AND deleted_at IS NULL AND id<>@id",
                Sql.P("@n", e.NationalId.Trim()),
                Sql.P("@id", e.Id ?? string.Empty));
            if (dup != null && dup != DBNull.Value)
                return "این کد ملی قبلاً ثبت شده است";

            var now = Sql.Now();
            if (isNew || string.IsNullOrEmpty(e.Id))
                e.Id = Sql.NewId();
            if (string.IsNullOrEmpty(e.EmploymentStatus))
                e.EmploymentStatus = "active";

            // تاریخ بازنشستگی گذشته → غیرفعال با دلیل بازنشستگی
            if (PersianDate.IsOnOrBeforeToday(e.RetirementDate))
            {
                e.EmploymentStatus = "inactive";
                if (string.IsNullOrWhiteSpace(e.InactiveReason))
                    e.InactiveReason = HrLookups.InactiveReasonRetirement;
            }

            if (e.EmploymentStatus == "inactive")
            {
                var reason = (e.InactiveReason ?? "").Trim();
                var retired = PersianDate.IsOnOrBeforeToday(e.RetirementDate);
                if (!retired && reason.Length == 0)
                    return "برای غیرفعال‌سازی غیر از بازنشستگی، دلیل را وارد کنید";
                if (retired && reason.Length == 0)
                    reason = HrLookups.InactiveReasonRetirement;
                e.InactiveReason = reason.Length == 0 ? null : reason;
            }
            else
                e.InactiveReason = null;

            e.EmploymentType = HrLookups.NormalizeEmploymentType(e.EmploymentType) ?? e.EmploymentType;

            if (HrLookups.IsOfficialEmployment(e.EmploymentType))
            {
                var baseErr = HrLookups.ValidateOfficialBases(e.EmploymentType, e.PositionBase, e.PersonalBase);
                if (baseErr != null)
                    return baseErr;
            }
            if (HrLookups.IsThirdPillarEmployment(e.EmploymentType))
            {
                var jgErr = HrLookups.ValidateThirdPillarJobGroup(e.EmploymentType, e.JobGroup);
                if (jgErr != null)
                    return jgErr;
            }

            if (isNew)
            {
                _db.Execute(
                    @"INSERT INTO employees (id, first_name, last_name, father_name, national_id, id_booklet_number,
                      birth_date, birth_place, service_city, veteran_status, iban1, iban2,
                      gender, marital_status, children_count, blood_group, military_status, personal_description, photo_path,
                      employee_number, subscription_number, current_position, previous_position, desired_position,
                      employment_type, employment_date, employment_status, person_type, retirement_date, inactive_reason,
                      job_group, position_base, personal_base,
                      created_at, updated_at)
                      VALUES (@id,@fn,@ln,@fa,@nid,@ibn,@bd,@bp,@sc,@vs,@ib1,@ib2,@g,@ms,@cc,@bg,@mil,@pd,@ph,@en,@sn,@cp,@pp,@dp,@et,@ed,@es,@pt,@rd,@ir,@jg,@pb,@psb,@now,@now)",
                    EmpParams(e, now));
            }
            else
            {
                _db.Execute(
                    @"UPDATE employees SET first_name=@fn, last_name=@ln, father_name=@fa, national_id=@nid, id_booklet_number=@ibn,
                      birth_date=@bd, birth_place=@bp, service_city=@sc, veteran_status=@vs, iban1=@ib1, iban2=@ib2,
                      gender=@g, marital_status=@ms, children_count=@cc, blood_group=@bg, military_status=@mil,
                      personal_description=@pd, photo_path=@ph, employee_number=@en, subscription_number=@sn, current_position=@cp,
                      previous_position=@pp, desired_position=@dp, employment_type=@et, employment_date=@ed,
                      employment_status=@es, person_type=@pt, retirement_date=@rd, inactive_reason=@ir,
                      job_group=@jg, position_base=@pb, personal_base=@psb, updated_at=@now WHERE id=@id",
                    EmpParams(e, now));
            }

            _db.Execute("INSERT OR REPLACE INTO employee_contacts (employee_id, primary_phone, secondary_phone, emergency_phone, email, home_address, postal_code) VALUES (@id,@p1,@p2,@p3,@em,@ad,@pc)",
                Sql.P("@id", e.Id), Sql.P("@p1", e.PrimaryPhone), Sql.P("@p2", e.SecondaryPhone), Sql.P("@p3", e.EmergencyPhone),
                Sql.P("@em", e.Email), Sql.P("@ad", e.HomeAddress), Sql.P("@pc", e.PostalCode));
            _db.Execute("INSERT OR REPLACE INTO employee_socials (employee_id, telegram, whatsapp, instagram, linkedin) VALUES (@id,@tg,@wa,@ig,@li)",
                Sql.P("@id", e.Id), Sql.P("@tg", e.Telegram), Sql.P("@wa", e.Whatsapp), Sql.P("@ig", e.Instagram), Sql.P("@li", e.Linkedin));

            SaveFirstChild(e, now);
            return null;
        }

        /// <summary>نیروهایی که تاریخ بازنشستگی‌شان رسیده را غیرفعال می‌کند.</summary>
        public int ApplyDueRetirements()
        {
            var today = PersianDate.Today();
            var now = Sql.Now();
            return _db.Execute(
                @"UPDATE employees
                  SET employment_status='inactive',
                      inactive_reason=CASE
                        WHEN inactive_reason IS NULL OR TRIM(inactive_reason)='' THEN @reason
                        ELSE inactive_reason
                      END,
                      updated_at=@now
                  WHERE deleted_at IS NULL
                    AND employment_status<>'inactive'
                    AND retirement_date IS NOT NULL
                    AND TRIM(retirement_date)<>''
                    AND retirement_date<=@today",
                Sql.P("@reason", HrLookups.InactiveReasonRetirement),
                Sql.P("@now", now),
                Sql.P("@today", today));
        }

        public void SetPhotoPath(string id, string relative)
        {
            _db.Execute("UPDATE employees SET photo_path=@p, updated_at=@n WHERE id=@id",
                Sql.P("@p", relative), Sql.P("@n", Sql.Now()), Sql.P("@id", id));
        }

        static readonly string[] TestJobGroups =
        {
            "گروه ۱", "گروه ۲", "گروه ۳", "گروه ۴", "گروه ۵",
            "خدمات", "فنی", "اداری", "حراست", "پشتیبانی"
        };

        /// <summary>
        /// برای همهٔ پرسنل: پایه سمت ۶…۲۰، پایه شخصی = سمت − ۱، و گروه شغلی.
        /// </summary>
        public int NormalizeOfficialBases(System.Random rng = null)
        {
            return FillTestOrganizationalFields(rng);
        }

        public int FillTestOrganizationalFields(System.Random rng = null)
        {
            if (rng == null)
                rng = new System.Random(1404);
            var ids = new System.Collections.Generic.List<string>();
            using (var r = _db.Query(
                "SELECT id FROM employees WHERE deleted_at IS NULL"))
            {
                while (r.Read())
                {
                    var id = Sql.Str(r["id"]);
                    if (!string.IsNullOrEmpty(id))
                        ids.Add(id);
                }
            }
            var now = Sql.Now();
            var n = 0;
            foreach (var id in ids)
            {
                var pos = rng.Next(6, 21);
                var per = pos - 1;
                var jg = TestJobGroups[rng.Next(0, TestJobGroups.Length)];
                _db.Execute(
                    "UPDATE employees SET position_base=@p, personal_base=@s, job_group=@jg, updated_at=@n WHERE id=@id",
                    Sql.P("@p", (double)pos),
                    Sql.P("@s", (double)per),
                    Sql.P("@jg", jg),
                    Sql.P("@n", now),
                    Sql.P("@id", id));
                n++;
            }
            return n;
        }

        public void SoftDelete(string id)
        {
            _db.Execute("UPDATE employees SET deleted_at=@n, updated_at=@n WHERE id=@id", Sql.P("@n", Sql.Now()), Sql.P("@id", id));
        }

        public int CountActive()
        {
            return Sql.Int(_db.Scalar("SELECT COUNT(*) FROM employees WHERE deleted_at IS NULL AND employment_status='active'"));
        }

        public Dictionary<string, string> MapEducationLevels()
        {
            return MapFirstText("SELECT employee_id, education_level FROM employee_educations", "education_level");
        }

        public Dictionary<string, string> MapSkillNames()
        {
            return MapFirstText("SELECT employee_id, skill_name FROM employee_skills", "skill_name");
        }

        Dictionary<string, string> MapFirstText(string sql, string column)
        {
            var map = new Dictionary<string, string>();
            using (var r = _db.Query(sql))
            {
                while (r.Read())
                {
                    var id = Sql.Str(r["employee_id"]);
                    if (string.IsNullOrEmpty(id) || map.ContainsKey(id))
                        continue;
                    map[id] = Sql.Str(r[column]);
                }
            }
            return map;
        }

        static List<Employee> ApplyBoolean(List<Employee> source, ParsedQuery q)
        {
            var list = new List<Employee>();
            foreach (var e in source)
            {
                // فقط هویت/تماس/سمت — نه محل خدمت و سایر فیلدهای فرعی (جلوگیری از نتیجهٔ کاذب)
                var hay = SearchHaystack(e);
                var ok = true;
                foreach (var t in q.AndTerms)
                {
                    if (!ContainsTerm(hay, t))
                    { ok = false; break; }
                }
                if (!ok) continue;
                if (q.OrTerms.Count > 0)
                {
                    var any = false;
                    foreach (var t in q.OrTerms)
                    {
                        if (ContainsTerm(hay, t))
                        { any = true; break; }
                    }
                    if (!any) continue;
                }
                foreach (var t in q.NotTerms)
                {
                    if (ContainsTerm(hay, t))
                    { ok = false; break; }
                }
                if (ok) list.Add(e);
            }
            return list;
        }

        static string SearchHaystack(Employee e)
        {
            if (e == null)
                return string.Empty;
            return NormalizeSearch(string.Join(" ",
                e.FullName, e.FirstName, e.LastName,
                e.NationalId, e.EmployeeNumber,
                e.PrimaryPhone, e.SecondaryPhone,
                e.CurrentPosition, e.Email));
        }

        static string NormalizeSearch(string raw)
        {
            if (string.IsNullOrEmpty(raw))
                return string.Empty;
            var s = PersianDate.DigitsEn(raw).ToLowerInvariant();
            // ی/ک عربی → فارسی
            return s.Replace('\u064A', '\u06CC').Replace('\u0643', '\u06A9');
        }

        static bool ContainsTerm(string hayNorm, string term)
        {
            var t = NormalizeSearch(term);
            if (t.Length == 0)
                return true;
            return hayNorm.IndexOf(t, StringComparison.Ordinal) >= 0;
        }

        void HydrateExtras(Employee e)
        {
            if (e == null)
                return;
            HydrateExtras(new List<Employee> { e });
        }

        /// <summary>
        /// پر کردن تحصیلات/مهارت/بیمه/ارزیابی از جداول فرعی برای لیست (گزارش، جستجو، …).
        /// فقط اولین ردیف هر کارمند اعمال می‌شود.
        /// </summary>
        public void HydrateExtras(IList<Employee> people)
        {
            if (people == null || people.Count == 0)
                return;

            var byId = new Dictionary<string, Employee>(StringComparer.Ordinal);
            foreach (var e in people)
            {
                if (e == null || string.IsNullOrEmpty(e.Id) || byId.ContainsKey(e.Id))
                    continue;
                byId[e.Id] = e;
            }
            if (byId.Count == 0)
                return;

            var eduDone = new HashSet<string>(StringComparer.Ordinal);
            using (var r = _db.Query("SELECT employee_id, education_level, major, university FROM employee_educations"))
            {
                while (r.Read())
                {
                    var id = Sql.Str(r["employee_id"]);
                    Employee e;
                    if (string.IsNullOrEmpty(id) || !byId.TryGetValue(id, out e) || !eduDone.Add(id))
                        continue;
                    e.EducationLevel = Sql.Str(r["education_level"]);
                    e.Major = Sql.Str(r["major"]);
                    e.University = Sql.Str(r["university"]);
                }
            }

            var skillDone = new HashSet<string>(StringComparer.Ordinal);
            using (var r = _db.Query("SELECT employee_id, skill_name, level FROM employee_skills"))
            {
                while (r.Read())
                {
                    var id = Sql.Str(r["employee_id"]);
                    Employee e;
                    if (string.IsNullOrEmpty(id) || !byId.TryGetValue(id, out e) || !skillDone.Add(id))
                        continue;
                    e.SkillName = Sql.Str(r["skill_name"]);
                    e.SkillLevel = Sql.Str(r["level"]);
                }
            }

            var insDone = new HashSet<string>(StringComparer.Ordinal);
            using (var r = _db.Query("SELECT employee_id, insurance_number, insurance_type FROM employee_insurances"))
            {
                while (r.Read())
                {
                    var id = Sql.Str(r["employee_id"]);
                    Employee e;
                    if (string.IsNullOrEmpty(id) || !byId.TryGetValue(id, out e) || !insDone.Add(id))
                        continue;
                    e.InsuranceNumber = Sql.Str(r["insurance_number"]);
                    e.InsuranceType = Sql.Str(r["insurance_type"]);
                }
            }

            var evalDone = new HashSet<string>(StringComparer.Ordinal);
            using (var r = _db.Query("SELECT employee_id, score, evaluator, strengths, weaknesses FROM employee_evaluations"))
            {
                while (r.Read())
                {
                    var id = Sql.Str(r["employee_id"]);
                    Employee e;
                    if (string.IsNullOrEmpty(id) || !byId.TryGetValue(id, out e) || !evalDone.Add(id))
                        continue;
                    e.EvaluationScore = Sql.Str(r["score"]);
                    e.Evaluator = Sql.Str(r["evaluator"]);
                    e.Strengths = Sql.Str(r["strengths"]);
                    e.Weaknesses = Sql.Str(r["weaknesses"]);
                }
            }
        }

        void SaveFirstChild(Employee e, long now)
        {
            _db.Execute("DELETE FROM employee_educations WHERE employee_id=@id", Sql.P("@id", e.Id));
            if (!string.IsNullOrWhiteSpace(e.EducationLevel) || !string.IsNullOrWhiteSpace(e.Major) || !string.IsNullOrWhiteSpace(e.University))
            {
                _db.Execute("INSERT INTO employee_educations (id, employee_id, education_level, major, university) VALUES (@id,@eid,@lv,@mj,@un)",
                    Sql.P("@id", Sql.NewId()), Sql.P("@eid", e.Id), Sql.P("@lv", e.EducationLevel), Sql.P("@mj", e.Major), Sql.P("@un", e.University));
            }
            _db.Execute("DELETE FROM employee_skills WHERE employee_id=@id", Sql.P("@id", e.Id));
            if (!string.IsNullOrWhiteSpace(e.SkillName))
            {
                _db.Execute("INSERT INTO employee_skills (id, employee_id, skill_name, level) VALUES (@id,@eid,@n,@lv)",
                    Sql.P("@id", Sql.NewId()), Sql.P("@eid", e.Id), Sql.P("@n", e.SkillName), Sql.P("@lv", e.SkillLevel));
            }
            _db.Execute("DELETE FROM employee_insurances WHERE employee_id=@id", Sql.P("@id", e.Id));
            if (!string.IsNullOrWhiteSpace(e.InsuranceNumber) || !string.IsNullOrWhiteSpace(e.InsuranceType))
            {
                _db.Execute("INSERT INTO employee_insurances (id, employee_id, insurance_number, insurance_type, created_at) VALUES (@id,@eid,@n,@t,@now)",
                    Sql.P("@id", Sql.NewId()), Sql.P("@eid", e.Id), Sql.P("@n", e.InsuranceNumber), Sql.P("@t", e.InsuranceType), Sql.P("@now", now));
            }
            _db.Execute("DELETE FROM employee_evaluations WHERE employee_id=@id", Sql.P("@id", e.Id));
            if (!string.IsNullOrWhiteSpace(e.EvaluationScore) || !string.IsNullOrWhiteSpace(e.Evaluator) || !string.IsNullOrWhiteSpace(e.Strengths))
            {
                double score;
                double.TryParse(e.EvaluationScore, out score);
                _db.Execute("INSERT INTO employee_evaluations (id, employee_id, year, score, evaluator, strengths, weaknesses, created_at) VALUES (@id,@eid,@y,@sc,@ev,@st,@wk,@now)",
                    Sql.P("@id", Sql.NewId()), Sql.P("@eid", e.Id), Sql.P("@y", DateTime.Now.Year),
                    Sql.P("@sc", string.IsNullOrWhiteSpace(e.EvaluationScore) ? (object)DBNull.Value : score),
                    Sql.P("@ev", e.Evaluator), Sql.P("@st", e.Strengths), Sql.P("@wk", e.Weaknesses), Sql.P("@now", now));
            }
        }

        static SQLiteParameter[] EmpParams(Employee e, long now)
        {
            return new[]
            {
                Sql.P("@id", e.Id), Sql.P("@fn", e.FirstName.Trim()), Sql.P("@ln", e.LastName.Trim()),
                Sql.P("@fa", e.FatherName), Sql.P("@nid", e.NationalId.Trim()),
                Sql.P("@ibn", e.IdBookletNumber), Sql.P("@bd", e.BirthDate),
                Sql.P("@bp", e.BirthPlace), Sql.P("@sc", e.ServiceCity), Sql.P("@vs", e.VeteranStatus),
                Sql.P("@ib1", e.Iban1), Sql.P("@ib2", e.Iban2),
                Sql.P("@g", HrLookups.NormalizeGender(e.Gender)), Sql.P("@ms", e.MaritalStatus),
                Sql.P("@cc", e.ChildrenCount), Sql.P("@bg", e.BloodGroup), Sql.P("@mil", e.MilitaryStatus),
                Sql.P("@pd", e.PersonalDescription), Sql.P("@ph", e.PhotoPath), Sql.P("@en", e.EmployeeNumber), Sql.P("@sn", e.SubscriptionNumber),
                Sql.P("@cp", e.CurrentPosition), Sql.P("@pp", e.PreviousPosition), Sql.P("@dp", e.DesiredPosition),
                Sql.P("@et", e.EmploymentType), Sql.P("@ed", e.EmploymentDate), Sql.P("@es", e.EmploymentStatus),
                Sql.P("@pt", HrLookups.NormalizePersonType(e.PersonType)),
                Sql.P("@rd", e.RetirementDate),
                Sql.P("@ir", e.InactiveReason),
                Sql.P("@jg", e.JobGroup),
                Sql.P("@pb", e.PositionBase.HasValue ? (object)e.PositionBase.Value : DBNull.Value),
                Sql.P("@psb", e.PersonalBase.HasValue ? (object)e.PersonalBase.Value : DBNull.Value),
                Sql.P("@now", now)
            };
        }

        static Employee Map(System.Data.IDataRecord r)
        {
            return new Employee
            {
                Id = Sql.Str(r["id"]),
                FirstName = Sql.Str(r["first_name"]) ?? string.Empty,
                LastName = Sql.Str(r["last_name"]) ?? string.Empty,
                FatherName = Sql.Str(r["father_name"]),
                NationalId = Sql.Str(r["national_id"]) ?? string.Empty,
                IdBookletNumber = HasCol(r, "id_booklet_number") ? Sql.Str(r["id_booklet_number"]) : null,
                BirthDate = Sql.Str(r["birth_date"]),
                BirthPlace = Sql.Str(r["birth_place"]),
                ServiceCity = HasCol(r, "service_city") ? Sql.Str(r["service_city"]) : null,
                VeteranStatus = HasCol(r, "veteran_status") ? Sql.Str(r["veteran_status"]) : null,
                Iban1 = HasCol(r, "iban1") ? Sql.Str(r["iban1"]) : null,
                Iban2 = HasCol(r, "iban2") ? Sql.Str(r["iban2"]) : null,
                Gender = HrLookups.NormalizeGender(Sql.Str(r["gender"])) ?? Sql.Str(r["gender"]),
                MaritalStatus = Sql.Str(r["marital_status"]),
                ChildrenCount = Sql.Int(r["children_count"]),
                BloodGroup = Sql.Str(r["blood_group"]),
                MilitaryStatus = Sql.Str(r["military_status"]),
                PersonalDescription = Sql.Str(r["personal_description"]),
                PhotoPath = Sql.Str(r["photo_path"]),
                EmployeeNumber = Sql.Str(r["employee_number"]),
                SubscriptionNumber = Sql.Str(r["subscription_number"]),
                CurrentPosition = Sql.Str(r["current_position"]),
                PreviousPosition = Sql.Str(r["previous_position"]),
                DesiredPosition = Sql.Str(r["desired_position"]),
                EmploymentType = HrLookups.NormalizeEmploymentType(Sql.Str(r["employment_type"]))
                    ?? Sql.Str(r["employment_type"]),
                EmploymentDate = Sql.Str(r["employment_date"]),
                EmploymentStatus = Sql.Str(r["employment_status"]) ?? "active",
                PersonType = HasCol(r, "person_type")
                    ? HrLookups.NormalizePersonType(Sql.Str(r["person_type"]))
                    : HrLookups.PersonStaff,
                RetirementDate = HasCol(r, "retirement_date") ? Sql.Str(r["retirement_date"]) : null,
                InactiveReason = HasCol(r, "inactive_reason") ? Sql.Str(r["inactive_reason"]) : null,
                JobGroup = HasCol(r, "job_group") ? Sql.Str(r["job_group"]) : null,
                PositionBase = HasCol(r, "position_base") ? Sql.DblN(r["position_base"]) : null,
                PersonalBase = HasCol(r, "personal_base") ? Sql.DblN(r["personal_base"]) : null,
                PrimaryPhone = Sql.Str(r["primary_phone"]),
                SecondaryPhone = Sql.Str(r["secondary_phone"]),
                EmergencyPhone = Sql.Str(r["emergency_phone"]),
                Email = Sql.Str(r["email"]),
                HomeAddress = Sql.Str(r["home_address"]),
                PostalCode = Sql.Str(r["postal_code"]),
                Telegram = Sql.Str(r["telegram"]),
                Whatsapp = Sql.Str(r["whatsapp"]),
                Instagram = Sql.Str(r["instagram"]),
                Linkedin = Sql.Str(r["linkedin"]),
                CreatedAt = Sql.Long(r["created_at"])
            };
        }

        static bool HasCol(System.Data.IDataRecord r, string name)
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
