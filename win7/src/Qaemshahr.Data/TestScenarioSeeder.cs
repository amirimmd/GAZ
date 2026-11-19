using System;
using System.Collections.Generic;
using System.IO;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    /// <summary>سناریوی کامل تست: پرسنل، مدارک، عکس، عناوین نمونه، گروه‌ها.</summary>
    public static class TestScenarioSeeder
    {
        public sealed class Options
        {
            public int ActiveCount { get; set; }
            public int InactiveCount { get; set; }
            public int IncompleteCount { get; set; }
            public int SampleYears { get; set; }
            public int GroupCount { get; set; }
            public bool ClearExisting { get; set; }

            public Options()
            {
                ActiveCount = 300;
                InactiveCount = 60;
                IncompleteCount = 5;
                SampleYears = 10;
                GroupCount = 6;
                ClearExisting = true;
            }
        }

        public sealed class Report
        {
            public int Active { get; set; }
            public int Inactive { get; set; }
            public int WithPhoto { get; set; }
            public int WithBirth { get; set; }
            public int WithNational { get; set; }
            public int WithMilitary { get; set; }
            public int IncompleteActive { get; set; }
            public int SampleTitles { get; set; }
            public int Groups { get; set; }
            public List<string> Errors { get; set; }

            public Report()
            {
                Errors = new List<string>();
            }
        }

        static readonly string[] Orgs =
        {
            "شرکت ملی گاز ایران","منطقه گاز مازندران","شهرداری قائم‌شهر","اداره کل کار مازندران",
            "دانشگاه مازندران","سازمان مدیریت و برنامه‌ریزی","هلال احمر قائم‌شهر","فنی‌حرفه‌ای ساری"
        };

        static readonly string[] GroupNames =
        {
            "گروه مأموریت خط لوله شمال","کمیته آموزش ایمنی","تیم پروژه سامانه‌های اداری",
            "گروه فرهنگی ورزشی","کمیته رفاهی کارکنان","کارگروه بهبود فرآیندها"
        };

        static readonly string[] Purposes =
        {
            "mission","training","committee","project","other","training"
        };

        public static Report SeedAll(AppDatabase db, Options opt)
        {
            if (db == null)
                throw new ArgumentNullException("db");
            if (opt == null)
                opt = new Options();

            var report = new Report();
            AppPaths.EnsureDataDirectories();
            KeyStore.Initialize();

            if (opt.ClearExisting)
                WipeScenarioData(db);

            var peopleResult = TestEmployeeSeeder.Seed(db, opt.ActiveCount, opt.InactiveCount, false);
            foreach (var e in peopleResult.Errors)
                report.Errors.Add(e);

            var repo = new EmployeeRepository(db);
            var docs = new DocumentRepository(db);
            var samples = new SampleTitleRepository(db);
            var groups = new GroupRepository(db);
            var people = repo.Search(null, null, 5000, true) ?? new List<Employee>();
            var rng = new Random(14051110);
            var adminId = FirstUserId(db);

            // ۵ پرونده ناقص فقط از بین فعال‌ها
            var incomplete = new HashSet<string>(StringComparer.Ordinal);
            var active = new List<Employee>();
            foreach (var e in people)
            {
                if (e != null && e.EmploymentStatus != "inactive")
                    active.Add(e);
            }
            Shuffle(active, rng);
            for (var i = 0; i < Math.Min(opt.IncompleteCount, active.Count); i++)
                incomplete.Add(active[i].Id);

            var tempDir = Path.Combine(Path.GetTempPath(), "gaz_seed_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(tempDir);
            try
            {
                var idx = 0;
                foreach (var e in people)
                {
                    if (e == null || string.IsNullOrEmpty(e.Id))
                        continue;
                    idx++;
                    var skipMedia = incomplete.Contains(e.Id);
                    if (!skipMedia)
                    {
                        try
                        {
                            AttachMedia(e, repo, docs, tempDir, idx, adminId);
                            report.WithPhoto++;
                            report.WithBirth++;
                            report.WithNational++;
                            report.WithMilitary++;
                        }
                        catch (Exception ex)
                        {
                            if (report.Errors.Count < 25)
                                report.Errors.Add(e.FullName + ": " + ex.Message);
                        }
                    }
                }
            }
            finally
            {
                try { Directory.Delete(tempDir, true); } catch { }
            }

            report.SampleTitles = SeedSampleTitles(samples, people, rng, opt.SampleYears, adminId);
            report.Groups = SeedGroups(groups, people, rng, opt.GroupCount, adminId);
            repo.NormalizeOfficialBases(rng);

            // آمار نهایی
            people = repo.Search(null, null, 5000, true) ?? new List<Employee>();
            var sets = HrDashboardService.FileSets(people, docs.List());
            foreach (var e in people)
            {
                if (e == null)
                    continue;
                if (e.EmploymentStatus == "inactive")
                    report.Inactive++;
                else
                {
                    report.Active++;
                    if (HrDashboardAnalytics.IsIncomplete(e.Id, sets.Photos, sets.Birth, sets.National))
                        report.IncompleteActive++;
                }
            }
            return report;
        }

        static void WipeScenarioData(AppDatabase db)
        {
            var now = Sql.Now();
            db.Execute("UPDATE employees SET deleted_at=@n, updated_at=@n WHERE deleted_at IS NULL", Sql.P("@n", now));
            db.Execute("UPDATE employee_documents SET deleted_at=@n WHERE deleted_at IS NULL", Sql.P("@n", now));
            db.Execute("UPDATE employee_groups SET deleted_at=@n, updated_at=@n WHERE deleted_at IS NULL", Sql.P("@n", now));
            db.Execute("UPDATE employee_group_activities SET deleted_at=@n WHERE deleted_at IS NULL", Sql.P("@n", now));
            db.Execute("DELETE FROM employee_sample_reports");
            db.Execute("DELETE FROM employee_sample_introductions");
            db.Execute("DELETE FROM employee_sample_titles");

            ClearDir(AppPaths.PhotosDirectory);
            ClearDir(AppPaths.DocumentsDirectory);
            Directory.CreateDirectory(Path.Combine(AppPaths.PhotosDirectory, "groups"));
        }

        static void ClearDir(string dir)
        {
            if (string.IsNullOrEmpty(dir) || !Directory.Exists(dir))
                return;
            try
            {
                foreach (var f in Directory.GetFiles(dir, "*", SearchOption.AllDirectories))
                {
                    try { File.Delete(f); } catch { }
                }
                foreach (var d in Directory.GetDirectories(dir))
                {
                    try { Directory.Delete(d, true); } catch { }
                }
            }
            catch
            {
            }
        }

        static void AttachMedia(Employee e, EmployeeRepository repo, DocumentRepository docs,
            string tempDir, int seed, string uploadedBy)
        {
            var female = HrLookups.IsFemaleGender(e.Gender);
            var portrait = TestImageFactory.Portrait3x4(e.FullName, female, seed);
            // اطمینان از ابعاد ۳×۴ رسمی
            portrait = EmployeePhotoStore.FitFromBytes(portrait);
            var rel = EmployeePhotoStore.SaveJpeg(e.Id, portrait);
            repo.SetPhotoPath(e.Id, rel);

            var birthPath = Path.Combine(tempDir, e.Id + "_birth.jpg");
            File.WriteAllBytes(birthPath, TestImageFactory.BirthCertificate(
                e.FullName, e.NationalId, e.FatherName, e.BirthDate, seed));
            var err = docs.Store(e.Id, "شناسنامه", DocumentKinds.Birth, birthPath, uploadedBy, "shenasnameh.jpg");
            if (err != null)
                throw new InvalidOperationException(err);

            var nationalPath = Path.Combine(tempDir, e.Id + "_national.jpg");
            File.WriteAllBytes(nationalPath, TestImageFactory.NationalCard(
                e.FullName, e.NationalId, e.BirthDate, female, seed + 1));
            err = docs.Store(e.Id, "کارت ملی", DocumentKinds.National, nationalPath, uploadedBy, "kart-melli.jpg");
            if (err != null)
                throw new InvalidOperationException(err);

            var milPath = Path.Combine(tempDir, e.Id + "_military.jpg");
            var milStatus = string.IsNullOrWhiteSpace(e.MilitaryStatus)
                ? (female ? "مشمول نیست" : "پایان خدمت")
                : e.MilitaryStatus;
            File.WriteAllBytes(milPath, TestImageFactory.MilitaryCard(
                e.FullName, e.NationalId, milStatus, seed + 2));
            err = docs.Store(e.Id, female ? "گواهی نظام وظیفه" : "پایان خدمت",
                DocumentKinds.Other, milPath, uploadedBy,
                female ? "nezam-vazife.jpg" : "payan-khedmat.jpg");
            if (err != null)
                throw new InvalidOperationException(err);
        }

        static int SeedSampleTitles(SampleTitleRepository samples, List<Employee> people, Random rng,
            int years, string createdBy)
        {
            var staff = new List<Employee>();
            var workers = new List<Employee>();
            foreach (var e in people)
            {
                if (e == null || e.EmploymentStatus == "inactive")
                    continue;
                if (HrLookups.IsWorker(e.PersonType))
                    workers.Add(e);
                else
                    staff.Add(e);
            }
            if (staff.Count == 0 && workers.Count == 0)
                return 0;

            var current = PersianDate.CurrentYear();
            var total = 0;
            for (var y = 0; y < years; y++)
            {
                var year = current - y;
                var staffPick = PickDistinct(staff, rng, Math.Min(8, Math.Max(3, staff.Count)));
                var workerPick = PickDistinct(workers, rng, Math.Min(5, Math.Max(2, workers.Count)));
                foreach (var e in staffPick)
                {
                    var err = samples.Upsert(e.Id, year, SampleTitleKinds.StaffSample,
                        "عنوان نمونه فرضی سال " + year, createdBy);
                    if (err == null)
                    {
                        total++;
                        MaybeIntroduce(samples, e.Id, year, SampleTitleKinds.StaffSample, rng, createdBy);
                    }
                }
                foreach (var e in workerPick)
                {
                    var err = samples.Upsert(e.Id, year, SampleTitleKinds.WorkerSample,
                        "کارگر نمونه فرضی سال " + year, createdBy);
                    if (err == null)
                    {
                        total++;
                        MaybeIntroduce(samples, e.Id, year, SampleTitleKinds.WorkerSample, rng, createdBy);
                    }
                }
            }
            return total;
        }

        static void MaybeIntroduce(SampleTitleRepository samples, string employeeId, int year, string kind,
            Random rng, string createdBy)
        {
            if (rng.NextDouble() > 0.55)
                return;
            string titleId = null;
            var rows = samples.List(year, kind);
            foreach (var row in rows)
            {
                if (row != null && row.EmployeeId == employeeId)
                {
                    titleId = row.Id;
                    break;
                }
            }
            if (string.IsNullOrEmpty(titleId))
                return;
            var org = Orgs[rng.Next(Orgs.Length)];
            samples.AddIntroduction(titleId, org, "معرفی فراسازمانی تستی", createdBy);
            if (rng.NextDouble() < 0.25)
                samples.AddIntroduction(titleId, Orgs[rng.Next(Orgs.Length)], "معرفی دوم", createdBy);
        }

        static int SeedGroups(GroupRepository groups, List<Employee> people, Random rng, int count, string userId)
        {
            var activeIds = new List<string>();
            foreach (var e in people)
            {
                if (e != null && e.EmploymentStatus != "inactive" && !string.IsNullOrEmpty(e.Id))
                    activeIds.Add(e.Id);
            }
            if (activeIds.Count == 0)
                return 0;

            var created = 0;
            var n = Math.Min(count, GroupNames.Length);
            for (var i = 0; i < n; i++)
            {
                var g = new EmployeeGroup
                {
                    Name = GroupNames[i],
                    Description = "پروفایل کامل گروه اجتماعی تستی — " + GroupNames[i]
                        + ". هدف: همکاری بین‌واحدی و ثبت فعالیت‌های مستمر.",
                    PurposeType = Purposes[i % Purposes.Length],
                    Status = "active",
                    StartsAt = DateTimeOffset.UtcNow.AddMonths(-(8 + i * 2)).ToUnixTimeMilliseconds(),
                    EndsAt = DateTimeOffset.UtcNow.AddMonths(6 + i).ToUnixTimeMilliseconds()
                };
                var members = PickDistinctIds(activeIds, rng, Math.Min(18, Math.Max(6, activeIds.Count / 8)));
                var err = groups.Save(g, members, userId);
                if (err != null)
                    continue;

                var cover = TestImageFactory.GroupCover(g.Name, 900 + i);
                var rel = EmployeePhotoStore.SaveGroupJpeg(g.Id, cover);
                groups.SetPhotoPath(g.Id, rel);

                var acts = new[]
                {
                    new GroupActivity { GroupId = g.Id, Title = "جلسه هماهنگی ماهانه", Note = "بررسی پیشرفت کارها", ActivityDate = PersianDate.Today() },
                    new GroupActivity { GroupId = g.Id, Title = "بازدید میدانی", Note = "بازدید از واحد عملیاتی", ActivityDate = PersianDate.FormatParts(PersianDate.CurrentYear(), Math.Max(1, PersianDate.CurrentMonth() - 1), 12) },
                    new GroupActivity { GroupId = g.Id, Title = "کارگاه آموزشی", Note = "آموزش ایمنی و بهره‌وری", ActivityDate = PersianDate.FormatParts(PersianDate.CurrentYear(), Math.Max(1, PersianDate.CurrentMonth() - 2), 5) }
                };
                foreach (var a in acts)
                    groups.AddActivity(a, userId, "مدیر سیستم");
                created++;
            }
            return created;
        }

        static List<Employee> PickDistinct(List<Employee> source, Random rng, int take)
        {
            var list = new List<Employee>(source);
            Shuffle(list, rng);
            if (take > list.Count)
                take = list.Count;
            return list.GetRange(0, take);
        }

        static List<string> PickDistinctIds(List<string> source, Random rng, int take)
        {
            var list = new List<string>(source);
            Shuffle(list, rng);
            if (take > list.Count)
                take = list.Count;
            return list.GetRange(0, take);
        }

        static void Shuffle<T>(IList<T> list, Random rng)
        {
            for (var i = list.Count - 1; i > 0; i--)
            {
                var j = rng.Next(i + 1);
                var tmp = list[i];
                list[i] = list[j];
                list[j] = tmp;
            }
        }

        static string FirstUserId(AppDatabase db)
        {
            var id = db.Scalar("SELECT id FROM users ORDER BY created_at LIMIT 1");
            return id == null || id == DBNull.Value ? null : id.ToString();
        }
    }
}
