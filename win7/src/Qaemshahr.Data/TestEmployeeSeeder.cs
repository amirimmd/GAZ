using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    /// <summary>پر کردن پایگاه با پرسنل ساختگی ولی واقعی‌نما برای تست.</summary>
    public static class TestEmployeeSeeder
    {
        public sealed class Result
        {
            public int Requested { get; set; }
            public int Inserted { get; set; }
            public int Cleared { get; set; }
            public int Failed { get; set; }
            public List<string> Errors { get; set; }

            public Result()
            {
                Errors = new List<string>();
            }
        }

        static readonly string[] MaleFirst =
        {
            "علی","محمد","حسین","رضا","مهدی","امیر","حسن","سعید","احمد","محسن",
            "جواد","حامد","پیمان","فرهاد","کاظم","ناصر","مجید","بهرام","داریوش","سینا",
            "پارسا","آرش","کیان","نیما","یاسر","مسعود","بهروز","فرید","وحید","ایمان",
            "مرتضی","عباس","اکبر","هادی","رامین","شهاب","پویا","عرفان","سامان","آرمان"
        };

        static readonly string[] FemaleFirst =
        {
            "زهرا","فاطمه","مریم","سارا","نرگس","الهام","مینا","لیلا","نازنین","سمیرا",
            "مهسا","نگین","آیدا","هانیه","پریسا","مینا","شیما","یاسمن","فرشته","زینب",
            "حدیث","سپیده","نیلوفر","شیرین","گلناز","مهتاب","آتنا","کتایون","رویا","هستی",
            "سحر","مهناز","فرناز","پگاه","آرزو","مهری","سودابه","طاهره","منیره","راضیه"
        };

        static readonly string[] LastNames =
        {
            "محمدی","حسینی","رضایی","کریمی","موسوی","جعفری","احمدی","حیدری","نوری","صادقی",
            "کاظمی","اکبری","مرادی","باقری","طاهری","نجفی","شریفی","رحیمی","قاسمی","عباسی",
            "یوسفی","نظری","سلطانی","جعفرزاده","امینی","فرهادی","پناهی","اسدی","حبیبی","رستمی",
            "میرزایی","مهدوی","کامران","طالبی","سادات","اله‌یاری","نیک‌خواه","رادمنش","کیانی","بهشتی",
            "قاسم‌زاده","محمودی","اسماعیلی","علیزاده","هاشمی","زمانی","شکری","داودی","جواهری","صامتی"
        };

        static readonly string[] Cities =
        {
            "قائم‌شهر","ساری","بابل","آمل","بهشهر","نکا","جویبار","سوادکوه","بابلسر","چالوس",
            "تنکابن","رامسر","گلوگاه","فریدونکنار","محمودآباد","عباس‌آباد","کلاردشت","پل‌سفید"
        };

        static readonly string[] Streets =
        {
            "خیابان امام خمینی","خیابان ولیعصر","خیابان شهید بهشتی","بلوار معلم","خیابان فرهنگ",
            "خیابان آزادی","خیابان انقلاب","کوچه گلستان","خیابان شریعتی","بلوار کشاورز",
            "خیابان پاسداران","خیابان جمهوری","خیابان طالقانی","خیابان فردوسی","خیابان سعدی"
        };

        static readonly string[] Positions =
        {
            "کارشناس منابع انسانی","کارشناس اداری","کارشناس مالی","حسابدار","منشی اداری",
            "کارشناس فناوری اطلاعات","برنامه‌نویس","کارشناس شبکه","مسئول بایگانی","کارشناس حقوقی",
            "کارشناس آموزش","کارشناس برنامه‌ریزی","کارشناس پشتیبانی","مسئول انبار","راننده",
            "نگهبان","کارگر خدمات","تکنسین تأسیسات","کارشناس ایمنی","کارشناس قراردادها",
            "کارشناس آمار","کارشناس روابط عمومی","کارشناس خرید","مسئول نقلیه","سرپرست واحد"
        };

        static readonly string[] EduLevels =
        {
            "دیپلم","فوق‌دیپلم","کارشناسی","کارشناسی ارشد","دکتری"
        };

        static readonly string[] Majors =
        {
            "مدیریت دولتی","مدیریت بازرگانی","حسابداری","حقوق","مهندسی کامپیوتر",
            "مهندسی صنایع","مهندسی عمران","علوم تربیتی","روانشناسی","اقتصاد",
            "مهندسی برق","فناوری اطلاعات","زبان انگلیسی","ادبیات فارسی","آمار"
        };

        static readonly string[] Universities =
        {
            "دانشگاه تهران","دانشگاه مازندران","دانشگاه آزاد قائم‌شهر","دانشگاه پیام‌نور ساری",
            "دانشگاه صنعتی نوشیروانی بابل","دانشگاه علم و صنعت","دانشگاه علامه طباطبایی",
            "دانشگاه شهید بهشتی","دانشگاه آزاد ساری","دانشگاه فنی‌حرفه‌ای مازندران"
        };

        static readonly string[] Skills =
        {
            "Excel پیشرفته","نامه‌نگاری اداری","SQL","پشتیبانی کاربران","آرشیو اسناد",
            "حسابداری مالی","اتوکد","برنامه‌نویسی C#","مذاکره","گزارش‌نویسی",
            "مدیریت زمان","کار تیمی","نرم‌افزار انبار","ایمنی کار","رانندگی پایه دو"
        };

        static readonly string[] SkillLevels = { "مبتدی", "متوسط", "خوب", "عالی" };

        static readonly string[] InsuranceTypes =
        {
            "تأمین اجتماعی","خدمات درمانی","بیمه ایران","بیمه آسیا","بیمه دانا","بیمه البرز"
        };

        static readonly string[] VeteranStatuses =
        {
            "عادی","فرزند شهید","جانباز ۲۵٪","جانباز ۵۰٪","آزاده","رزمنده","ایثارگر"
        };

        static readonly string[] BloodGroups =
        {
            "A+","A-","B+","B-","AB+","AB-","O+","O-"
        };

        static readonly string[] MaleMilitary =
        {
            "پایان خدمت","معاف","معافیت تحصیلی","در حال خدمت","مشمول"
        };

        static readonly string[] BankCodes =
        {
            "012","013","015","016","017","018","019","054","056","057","061","062","070"
        };

        static readonly string[] InactiveReasons =
        {
            "استعفا","انتقال","اخراج","پایان قرارداد","مرخصی بدون حقوق طولانی"
        };

        static readonly string[] JobGroups =
        {
            "گروه ۱","گروه ۲","گروه ۳","گروه ۴","گروه ۵",
            "خدمات","فنی","اداری","حراست","پشتیبانی"
        };

        static readonly string[] StrengthLines =
        {
            "دقت بالا در انجام امور اداری","همکاری مؤثر با همکاران","پاسخگویی مناسب به مراجعین",
            "رعایت نظم و انضباط","توانایی حل مسئله","انگیزه یادگیری"
        };

        static readonly string[] WeakLines =
        {
            "نیاز به تقویت مهارت گزارش‌نویسی","تسلط بیشتر بر نرم‌افزار تخصصی",
            "مدیریت بهتر زمان در پروژه‌های موازی","نیاز به آموزش نرم‌افزار اداری"
        };

        public static Result Seed(AppDatabase db, int count, bool clearExisting)
        {
            return Seed(db, count, 0, clearExisting);
        }

        public static Result Seed(AppDatabase db, int activeCount, int inactiveCount, bool clearExisting)
        {
            if (db == null)
                throw new ArgumentNullException("db");
            if (activeCount < 0)
                activeCount = 0;
            if (inactiveCount < 0)
                inactiveCount = 0;
            var total = activeCount + inactiveCount;
            if (total < 1)
                total = 1;
            if (total > 5000)
            {
                activeCount = Math.Min(activeCount, 5000);
                inactiveCount = Math.Max(0, 5000 - activeCount);
                total = activeCount + inactiveCount;
            }

            var result = new Result { Requested = total };
            var repo = new EmployeeRepository(db);
            var suggestions = new FieldSuggestionRepository(db);
            var rng = new Random(14030420);

            if (clearExisting)
            {
                var now = Sql.Now();
                result.Cleared = db.Execute(
                    "UPDATE employees SET deleted_at=@n, updated_at=@n WHERE deleted_at IS NULL",
                    Sql.P("@n", now));
            }

            var usedNids = new HashSet<string>(StringComparer.Ordinal);
            using (var r = db.Query("SELECT national_id FROM employees WHERE deleted_at IS NULL"))
            {
                while (r.Read())
                {
                    var n = Sql.Str(r["national_id"]);
                    if (!string.IsNullOrEmpty(n))
                        usedNids.Add(n);
                }
            }

            db.RunInTransaction(() =>
            {
                for (var i = 0; i < total; i++)
                {
                    var forceActive = i < activeCount;
                    var emp = BuildOne(rng, i + 1, usedNids, forceActive ? "active" : "inactive");
                    var err = repo.Save(emp, true);
                    if (err != null)
                    {
                        result.Failed++;
                        if (result.Errors.Count < 20)
                            result.Errors.Add((i + 1) + ": " + err);
                        continue;
                    }
                    suggestions.RememberFromEmployee(emp);
                    result.Inserted++;
                }
            });

            return result;
        }

        internal static Employee BuildOne(Random rng, int index, HashSet<string> usedNids, string forceStatus = null)
        {
            var female = rng.NextDouble() < 0.42;
            var first = Pick(rng, female ? FemaleFirst : MaleFirst);
            var last = Pick(rng, LastNames);
            var father = Pick(rng, MaleFirst);
            var birthCity = Pick(rng, Cities);
            var serviceCity = rng.NextDouble() < 0.55 ? "قائم‌شهر" : Pick(rng, Cities);
            var married = rng.NextDouble() < 0.62;
            var children = married ? rng.Next(0, 5) : 0;
            if (!married && rng.NextDouble() < 0.05)
                children = 1;

            var birthYear = rng.Next(1342, 1383);
            var birthMonth = rng.Next(1, 13);
            var birthDay = rng.Next(1, Math.Min(28, PersianDate.DaysInMonth(birthYear, birthMonth)) + 1);
            var birthDate = PersianDate.FormatParts(birthYear, birthMonth, birthDay);

            var hireAge = rng.Next(20, 36);
            var hireYear = Math.Min(PersianDate.CurrentYear() - 1, birthYear + hireAge);
            if (hireYear <= birthYear + 18)
                hireYear = birthYear + 19;
            var hireMonth = rng.Next(1, 13);
            var hireDay = rng.Next(1, Math.Min(28, PersianDate.DaysInMonth(hireYear, hireMonth)) + 1);
            var hireDate = PersianDate.FormatParts(hireYear, hireMonth, hireDay);

            var empTypeRoll = rng.NextDouble();
            string empType;
            if (empTypeRoll < 0.38)
                empType = HrLookups.EmploymentOfficial;
            else if (empTypeRoll < 0.62)
                empType = "قراردادی";
            else if (empTypeRoll < 0.82)
                empType = HrLookups.EmploymentThirdPillar;
            else
                empType = "خارج پرتال";

            // برای همهٔ پرسنل تستی: گروه شغلی + پایه‌ها
            var jobGroup = Pick(rng, JobGroups);
            var posBase = (double)rng.Next(6, 21);
            var perBase = posBase - 1;

            var isWorker = rng.NextDouble() < 0.28;
            var position = Pick(rng, Positions);
            var prev = Pick(rng, Positions);
            while (prev == position)
                prev = Pick(rng, Positions);
            var desired = rng.NextDouble() < 0.7 ? Pick(rng, Positions) : position;

            string status;
            string inactiveReason = null;
            string retirement;
            if (string.Equals(forceStatus, "inactive", StringComparison.Ordinal))
            {
                status = "inactive";
                if (rng.NextDouble() < 0.45)
                {
                    var retYear = Math.Min(PersianDate.CurrentYear(), hireYear + rng.Next(25, 35));
                    retirement = PersianDate.FormatParts(retYear, rng.Next(1, 7), rng.Next(1, 28));
                    inactiveReason = HrLookups.InactiveReasonRetirement;
                }
                else
                {
                    inactiveReason = Pick(rng, InactiveReasons);
                    retirement = PersianDate.FormatParts(
                        Math.Min(PersianDate.CurrentYear() + rng.Next(8, 20), hireYear + 40),
                        rng.Next(1, 13),
                        rng.Next(1, 28));
                }
            }
            else
            {
                status = "active";
                retirement = PersianDate.FormatParts(
                    Math.Min(1450, hireYear + rng.Next(28, 38)),
                    rng.Next(1, 13),
                    rng.Next(1, 28));
                // تاریخ بازنشستگی آینده — Save آن را inactive نکند
                if (PersianDate.IsOnOrBeforeToday(retirement))
                {
                    retirement = PersianDate.FormatParts(
                        PersianDate.CurrentYear() + rng.Next(5, 18),
                        rng.Next(1, 13),
                        rng.Next(1, 28));
                }
            }

            var edu = Pick(rng, EduLevels);
            if (isWorker && rng.NextDouble() < 0.45)
                edu = rng.NextDouble() < 0.6 ? "دیپلم" : "فوق‌دیپلم";

            var phone1 = Mobile(rng);
            var phone2 = Mobile(rng);
            while (phone2 == phone1)
                phone2 = Mobile(rng);
            var phone3 = Mobile(rng);

            var empNo = (10000 + index).ToString(CultureInfo.InvariantCulture);
            var subNo = (200000 + index).ToString(CultureInfo.InvariantCulture);
            var nid = NextNationalId(rng, usedNids);
            var booklet = (rng.Next(10000, 999999)).ToString(CultureInfo.InvariantCulture);

            var score = Math.Round(45 + rng.NextDouble() * 50, 1);
            var bank1 = Pick(rng, BankCodes);
            var bank2 = Pick(rng, BankCodes);

            var streetNo = rng.Next(1, 180);
            var unit = rng.Next(1, 24);
            var address = string.Format(
                CultureInfo.InvariantCulture,
                "استان مازندران، شهرستان {0}، {1}، پلاک {2}، واحد {3}",
                birthCity, Pick(rng, Streets), streetNo, unit);

            var latinUser = "p" + empNo;
            var veteran = Pick(rng, VeteranStatuses);
            if (rng.NextDouble() < 0.72)
                veteran = "عادی";

            return new Employee
            {
                FirstName = first,
                LastName = last,
                FatherName = father,
                NationalId = nid,
                IdBookletNumber = booklet,
                BirthDate = birthDate,
                BirthPlace = birthCity,
                ServiceCity = serviceCity,
                VeteranStatus = veteran,
                Iban1 = MakeIban(rng, bank1),
                Iban2 = MakeIban(rng, bank2),
                Gender = female ? HrLookups.GenderFemaleFa : HrLookups.GenderMaleFa,
                MaritalStatus = married ? "متأهل" : "مجرد",
                ChildrenCount = children,
                BloodGroup = Pick(rng, BloodGroups),
                MilitaryStatus = female ? "مشمول نیست" : Pick(rng, MaleMilitary),
                PersonalDescription = string.Format(
                    "پرونده تستی شماره {0} — {1} {2}، محل خدمت {3}.",
                    index, first, last, serviceCity),
                EmployeeNumber = empNo,
                SubscriptionNumber = subNo,
                CurrentPosition = position,
                PreviousPosition = prev,
                DesiredPosition = desired,
                EmploymentType = empType,
                EmploymentDate = hireDate,
                EmploymentStatus = status,
                PersonType = isWorker ? HrLookups.PersonWorker : HrLookups.PersonStaff,
                RetirementDate = retirement,
                InactiveReason = inactiveReason,
                JobGroup = jobGroup,
                PositionBase = posBase,
                PersonalBase = perBase,
                PrimaryPhone = phone1,
                SecondaryPhone = phone2,
                EmergencyPhone = phone3,
                Email = latinUser + "@gaz-qaemshahr.ir",
                HomeAddress = address,
                PostalCode = (rng.Next(100000000, 999999999)).ToString(CultureInfo.InvariantCulture)
                    + rng.Next(0, 10).ToString(CultureInfo.InvariantCulture),
                Telegram = "@" + latinUser,
                Whatsapp = phone1,
                Instagram = latinUser + "_hr",
                Linkedin = "linkedin.com/in/" + latinUser,
                EducationLevel = edu,
                Major = Pick(rng, Majors),
                University = Pick(rng, Universities),
                SkillName = Pick(rng, Skills),
                SkillLevel = Pick(rng, SkillLevels),
                InsuranceNumber = (rng.Next(10000000, 99999999)).ToString(CultureInfo.InvariantCulture),
                InsuranceType = Pick(rng, InsuranceTypes),
                EvaluationScore = score.ToString("0.#", CultureInfo.InvariantCulture),
                Evaluator = Pick(rng, MaleFirst) + " " + Pick(rng, LastNames),
                Strengths = Pick(rng, StrengthLines),
                Weaknesses = Pick(rng, WeakLines)
            };
        }

        static string NextNationalId(Random rng, HashSet<string> used)
        {
            for (var attempt = 0; attempt < 5000; attempt++)
            {
                var digits = new char[10];
                // پیش‌شماره متنوع شبیه کدهای واقعی
                var prefix = rng.Next(1, 90);
                digits[0] = (char)('0' + (prefix / 10));
                digits[1] = (char)('0' + (prefix % 10));
                for (var i = 2; i < 9; i++)
                    digits[i] = (char)('0' + rng.Next(0, 10));

                var sum = 0;
                for (var i = 0; i < 9; i++)
                    sum += (digits[i] - '0') * (10 - i);
                var rem = sum % 11;
                var check = rem < 2 ? rem : 11 - rem;
                digits[9] = (char)('0' + check);
                var code = new string(digits);
                if (!IranianNationalId.IsValid(code))
                    continue;
                if (used.Add(code))
                    return code;
            }
            throw new InvalidOperationException("تولید کد ملی یکتا ممکن نشد.");
        }

        static string MakeIban(Random rng, string bankCode)
        {
            var sb = new StringBuilder(26);
            sb.Append("IR");
            sb.Append(rng.Next(10, 99).ToString(CultureInfo.InvariantCulture));
            sb.Append(bankCode);
            for (var i = 0; i < 19; i++)
                sb.Append(rng.Next(0, 10));
            return sb.ToString();
        }

        static string Mobile(Random rng)
        {
            var prefixes = new[] { "0911", "0912", "0913", "0935", "0936", "0939", "0901", "0902", "0990" };
            return Pick(rng, prefixes) + rng.Next(1000000, 9999999).ToString(CultureInfo.InvariantCulture);
        }

        static string Pick(Random rng, string[] items)
        {
            return items[rng.Next(0, items.Length)];
        }
    }
}
