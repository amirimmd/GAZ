using System;
using System.Collections.Generic;
using System.Linq;
using Qaemshahr.Core;

namespace Qaemshahr.Core.Models
{
    /// <summary>تعریف فیلترهای قابل‌انتخاب برای گزارش حرفه‌ای.</summary>
    public static class ReportFilterDefs
    {
        public const int AgeMinDefault = 0;
        public const int AgeMaxDefault = 80;
        public const int TenureMinDefault = 0;
        public const int TenureMaxDefault = 50;
        public const int ChildrenMinDefault = 0;
        public const int ChildrenMaxDefault = 15;
        public const double BaseMinDefault = 0;
        public const double BaseMaxDefault = 99;

        public static readonly string[] StatusLabels = { "فعال", "غیرفعال" };
        public static readonly string[] GenderValues = { HrLookups.GenderMaleFa, HrLookups.GenderFemaleFa };
        public static readonly string[] MaritalValues = { "مجرد", "متأهل" };
        public static readonly string[] EmploymentTypes =
        {
            "رسمی", "قراردادی", "ارکان ثالث", "خارج پرتال"
        };
        public static readonly string[] PersonTypeLabels = { "کارمند", "کارگر" };
        public static readonly string[] MilitaryValues =
        {
            "پایان خدمت", "معاف", "معافیت تحصیلی", "در حال خدمت", "مشمول", "مشمول نیست"
        };
        public static readonly string[] BloodValues =
        {
            "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"
        };

        public static readonly string[] PresenceModes = { "any", "yes", "no" };
        public static readonly string[] PresenceLabels = { "مهم نیست", "دارد", "ندارد" };
        public static readonly string[] OfficialLabels = { "مهم نیست", "فقط رسمی", "غیر از رسمی" };

        public static readonly string[] SortKeys =
        {
            "fullName", "lastName", "nationalId", "employeeNumber", "position",
            "employmentDate", "birthDate", "age", "tenure", "childrenCount", "status"
        };
        public static readonly string[] SortLabels =
        {
            "نام کامل", "نام خانوادگی", "کد ملی", "شماره پرسنلی", "سمت",
            "تاریخ استخدام", "تاریخ تولد", "سن", "سابقه", "تعداد فرزند", "وضعیت"
        };

        public static bool HasValueOptions(string columnKey)
        {
            switch (columnKey)
            {
                case "gender":
                case "maritalStatus":
                case "status":
                case "employmentType":
                case "personType":
                case "militaryStatus":
                case "bloodGroup":
                case "jobGroup":
                    return true;
                default:
                    return false;
            }
        }

        public static string[] ValueOptions(string columnKey)
        {
            switch (columnKey)
            {
                case "gender": return GenderValues;
                case "maritalStatus": return MaritalValues;
                case "status": return StatusLabels;
                case "employmentType": return EmploymentTypes;
                case "personType": return PersonTypeLabels;
                case "militaryStatus": return MilitaryValues;
                case "bloodGroup": return BloodValues;
                default: return new string[0];
            }
        }

        /// <summary>نوع کنترل فیلتر برای سرستون گزارش.</summary>
        public static string FilterKind(string columnKey)
        {
            if (HasValueOptions(columnKey))
                return "enum";
            if (FieldSuggestionKeys.CategoryForReportColumn(columnKey) != null)
                return "suggest";
            switch (columnKey)
            {
                case "birthDate":
                case "employmentDate":
                    return "date";
                case "childrenCount":
                case "positionBase":
                case "personalBase":
                    return "number";
                case "photo":
                case "docBirth":
                case "docNational":
                case "docOther":
                    return "presence";
                default:
                    return "text";
            }
        }
    }

    public sealed class ReportEmployeeFilter
    {
        public string SearchText { get; set; }
        public List<string> Statuses { get; set; }
        public List<string> Genders { get; set; }
        public List<string> Maritals { get; set; }
        public List<string> EmploymentTypes { get; set; }
        public List<string> PersonTypes { get; set; }
        public List<string> Militaries { get; set; }
        public List<string> Bloods { get; set; }
        public List<string> JobGroups { get; set; }

        public int AgeMin { get; set; }
        public int AgeMax { get; set; }
        public bool AgeEnabled { get; set; }
        public int TenureMin { get; set; }
        public int TenureMax { get; set; }
        public bool TenureEnabled { get; set; }
        public int ChildrenMin { get; set; }
        public int ChildrenMax { get; set; }
        public bool ChildrenEnabled { get; set; }
        public double PositionBaseMin { get; set; }
        public double PositionBaseMax { get; set; }
        public bool PositionBaseEnabled { get; set; }
        public double PersonalBaseMin { get; set; }
        public double PersonalBaseMax { get; set; }
        public bool PersonalBaseEnabled { get; set; }

        public string BirthDateFrom { get; set; }
        public string BirthDateTo { get; set; }
        public bool BirthDateEnabled { get; set; }
        public string EmploymentDateFrom { get; set; }
        public string EmploymentDateTo { get; set; }
        public bool EmploymentDateEnabled { get; set; }

        public string BirthPlaceContains { get; set; }
        public string PositionContains { get; set; }
        public string PreviousPositionContains { get; set; }
        public string DesiredPositionContains { get; set; }
        public string EducationContains { get; set; }
        public string MajorContains { get; set; }
        public string UniversityContains { get; set; }
        public string SkillContains { get; set; }
        public string SkillLevelContains { get; set; }
        public string InsuranceTypeContains { get; set; }
        public string InsuranceNumberContains { get; set; }
        public string AddressContains { get; set; }
        public string PostalCodeContains { get; set; }
        public string EmailContains { get; set; }
        public string PhoneContains { get; set; }
        public string FatherNameContains { get; set; }
        public string DescriptionContains { get; set; }
        public string SocialContains { get; set; }

        /// <summary>فیلتر متنی عمومی برای ستون‌هایی مثل نام، کد ملی، شماره پرسنلی.</summary>
        public Dictionary<string, string> ExtraContains { get; set; }

        /// <summary>فیلتر چندانتخابی از پیشنهادهای ذخیره‌شده (کلید = ستون گزارش).</summary>
        public Dictionary<string, List<string>> SuggestionIn { get; set; }

        public string PhotoMode { get; set; }
        public string DocBirthMode { get; set; }
        public string DocNationalMode { get; set; }
        public string DocOtherMode { get; set; }
        public string EmailMode { get; set; }
        public string PhoneMode { get; set; }
        public string AddressMode { get; set; }
        public string EducationMode { get; set; }
        public string OfficialOnly { get; set; }
        public string SortBy { get; set; }
        public bool SortAscending { get; set; }

        public static ReportEmployeeFilter CreateDefault()
        {
            return new ReportEmployeeFilter
            {
                SearchText = "",
                Statuses = new List<string>(ReportFilterDefs.StatusLabels),
                Genders = new List<string>(ReportFilterDefs.GenderValues),
                Maritals = new List<string>(ReportFilterDefs.MaritalValues),
                EmploymentTypes = new List<string>(),
                PersonTypes = new List<string>(),
                Militaries = new List<string>(ReportFilterDefs.MilitaryValues),
                Bloods = new List<string>(ReportFilterDefs.BloodValues),
                JobGroups = new List<string>(),
                AgeMin = ReportFilterDefs.AgeMinDefault,
                AgeMax = ReportFilterDefs.AgeMaxDefault,
                AgeEnabled = false,
                TenureMin = ReportFilterDefs.TenureMinDefault,
                TenureMax = ReportFilterDefs.TenureMaxDefault,
                TenureEnabled = false,
                ChildrenMin = ReportFilterDefs.ChildrenMinDefault,
                ChildrenMax = ReportFilterDefs.ChildrenMaxDefault,
                ChildrenEnabled = false,
                PositionBaseMin = ReportFilterDefs.BaseMinDefault,
                PositionBaseMax = ReportFilterDefs.BaseMaxDefault,
                PositionBaseEnabled = false,
                PersonalBaseMin = ReportFilterDefs.BaseMinDefault,
                PersonalBaseMax = ReportFilterDefs.BaseMaxDefault,
                PersonalBaseEnabled = false,
                BirthDateFrom = "",
                BirthDateTo = "",
                BirthDateEnabled = false,
                EmploymentDateFrom = "",
                EmploymentDateTo = "",
                EmploymentDateEnabled = false,
                BirthPlaceContains = "",
                PositionContains = "",
                PreviousPositionContains = "",
                DesiredPositionContains = "",
                EducationContains = "",
                MajorContains = "",
                UniversityContains = "",
                SkillContains = "",
                SkillLevelContains = "",
                InsuranceTypeContains = "",
                InsuranceNumberContains = "",
                AddressContains = "",
                PostalCodeContains = "",
                EmailContains = "",
                PhoneContains = "",
                FatherNameContains = "",
                DescriptionContains = "",
                SocialContains = "",
                ExtraContains = new Dictionary<string, string>(),
                SuggestionIn = new Dictionary<string, List<string>>(),
                PhotoMode = "any",
                DocBirthMode = "any",
                DocNationalMode = "any",
                DocOtherMode = "any",
                EmailMode = "any",
                PhoneMode = "any",
                AddressMode = "any",
                EducationMode = "any",
                OfficialOnly = "any",
                SortBy = "fullName",
                SortAscending = true
            };
        }

        public List<Employee> Apply(IEnumerable<Employee> source)
        {
            if (source == null)
                return new List<Employee>();
            IEnumerable<Employee> q = source;
            var text = (SearchText ?? "").Trim();
            if (text.Length > 0)
            {
                q = q.Where(e =>
                    Contains(e.FullName, text)
                    || Contains(e.NationalId, text)
                    || Contains(e.EmployeeNumber, text)
                    || Contains(e.CurrentPosition, text)
                    || Contains(e.PrimaryPhone, text)
                    || Contains(e.FatherName, text)
                    || Contains(e.SubscriptionNumber, text));
            }

            if (Statuses != null && Statuses.Count > 0 && Statuses.Count < ReportFilterDefs.StatusLabels.Length)
                q = q.Where(e => Statuses.Contains(NormStatus(e)));

            if (Genders != null && Genders.Count > 0 && Genders.Count < ReportFilterDefs.GenderValues.Length)
                q = q.Where(e => Genders.Contains(NormGender(e.Gender)));

            if (Maritals != null && Maritals.Count > 0 && Maritals.Count < ReportFilterDefs.MaritalValues.Length)
                q = q.Where(e => Maritals.Contains(NormMarital(e.MaritalStatus)));

            if (EmploymentTypes != null && EmploymentTypes.Count > 0)
            {
                var set = new HashSet<string>(StringComparer.Ordinal);
                foreach (var raw in EmploymentTypes)
                {
                    var n = Qaemshahr.Core.HrLookups.NormalizeEmploymentType(raw) ?? (raw ?? "").Trim();
                    if (n.Length > 0)
                        set.Add(n);
                }
                q = q.Where(e =>
                {
                    var t = Qaemshahr.Core.HrLookups.NormalizeEmploymentType(e.EmploymentType) ?? (e.EmploymentType ?? "").Trim();
                    return set.Contains(t);
                });
            }

            if (PersonTypes != null && PersonTypes.Count > 0
                && PersonTypes.Count < ReportFilterDefs.PersonTypeLabels.Length)
            {
                var wantStaff = PersonTypes.Any(x =>
                    string.Equals((x ?? "").Trim(), "کارمند", StringComparison.Ordinal)
                    || string.Equals(Qaemshahr.Core.HrLookups.NormalizePersonType(x),
                        Qaemshahr.Core.HrLookups.PersonStaff, StringComparison.Ordinal));
                var wantWorker = PersonTypes.Any(x =>
                    string.Equals((x ?? "").Trim(), "کارگر", StringComparison.Ordinal)
                    || string.Equals(Qaemshahr.Core.HrLookups.NormalizePersonType(x),
                        Qaemshahr.Core.HrLookups.PersonWorker, StringComparison.Ordinal));
                q = q.Where(e =>
                {
                    var worker = Qaemshahr.Core.HrLookups.IsWorker(e.PersonType);
                    return (worker && wantWorker) || (!worker && wantStaff);
                });
            }

            if (Militaries != null && Militaries.Count > 0 && Militaries.Count < ReportFilterDefs.MilitaryValues.Length)
                q = q.Where(e => Militaries.Contains(NormMilitary(e.MilitaryStatus)));

            if (Bloods != null && Bloods.Count > 0 && Bloods.Count < ReportFilterDefs.BloodValues.Length)
            {
                q = q.Where(e =>
                {
                    var b = (e.BloodGroup ?? "").Trim();
                    foreach (var x in Bloods)
                    {
                        if (string.Equals(x, b, StringComparison.OrdinalIgnoreCase))
                            return true;
                    }
                    return false;
                });
            }

            if (JobGroups != null && JobGroups.Count > 0)
            {
                var set = new HashSet<string>(JobGroups, StringComparer.CurrentCultureIgnoreCase);
                q = q.Where(e => set.Contains((e.JobGroup ?? "").Trim()));
            }

            if (AgeEnabled)
            {
                var amin = Math.Min(AgeMin, AgeMax);
                var amax = Math.Max(AgeMin, AgeMax);
                q = q.Where(e =>
                {
                    var age = Qaemshahr.Core.PersianDate.CompleteYears(e.BirthDate);
                    return age != null && age.Value >= amin && age.Value <= amax;
                });
            }

            if (TenureEnabled)
            {
                var tmin = Math.Min(TenureMin, TenureMax);
                var tmax = Math.Max(TenureMin, TenureMax);
                q = q.Where(e =>
                {
                    var years = Qaemshahr.Core.PersianDate.CompleteYears(e.EmploymentDate);
                    return years != null && years.Value >= tmin && years.Value <= tmax;
                });
            }

            if (ChildrenEnabled)
            {
                var cmin = Math.Min(ChildrenMin, ChildrenMax);
                var cmax = Math.Max(ChildrenMin, ChildrenMax);
                q = q.Where(e => e.ChildrenCount >= cmin && e.ChildrenCount <= cmax);
            }

            if (PositionBaseEnabled)
            {
                var bmin = Math.Min(PositionBaseMin, PositionBaseMax);
                var bmax = Math.Max(PositionBaseMin, PositionBaseMax);
                q = q.Where(e => e.PositionBase != null && e.PositionBase.Value >= bmin && e.PositionBase.Value <= bmax);
            }

            if (PersonalBaseEnabled)
            {
                var bmin = Math.Min(PersonalBaseMin, PersonalBaseMax);
                var bmax = Math.Max(PersonalBaseMin, PersonalBaseMax);
                q = q.Where(e => e.PersonalBase != null && e.PersonalBase.Value >= bmin && e.PersonalBase.Value <= bmax);
            }

            if (BirthDateEnabled)
                q = ApplyDateRange(q, BirthDateFrom, BirthDateTo, e => e.BirthDate);
            if (EmploymentDateEnabled)
                q = ApplyDateRange(q, EmploymentDateFrom, EmploymentDateTo, e => e.EmploymentDate);

            if (!HasSuggestionFilter("birthPlace"))
                q = ApplyContains(q, BirthPlaceContains, e => e.BirthPlace);
            if (!HasSuggestionFilter("position"))
                q = ApplyContains(q, PositionContains, e => e.CurrentPosition);
            if (!HasSuggestionFilter("previousPosition"))
                q = ApplyContains(q, PreviousPositionContains, e => e.PreviousPosition);
            if (!HasSuggestionFilter("desiredPosition"))
                q = ApplyContains(q, DesiredPositionContains, e => e.DesiredPosition);
            if (!HasSuggestionFilter("educationLevel"))
                q = ApplyContains(q, EducationContains, e => e.EducationLevel);
            if (!HasSuggestionFilter("major"))
                q = ApplyContains(q, MajorContains, e => e.Major);
            if (!HasSuggestionFilter("university"))
                q = ApplyContains(q, UniversityContains, e => e.University);
            if (!HasSuggestionFilter("skillName"))
                q = ApplyContains(q, SkillContains, e => e.SkillName);
            if (!HasSuggestionFilter("skillLevel"))
                q = ApplyContains(q, SkillLevelContains, e => e.SkillLevel);
            q = ApplyContains(q, InsuranceNumberContains, e => e.InsuranceNumber);
            if (!HasSuggestionFilter("insuranceType"))
                q = ApplyContains(q, InsuranceTypeContains, e => e.InsuranceType);
            q = ApplyContains(q, AddressContains, e => e.HomeAddress);
            q = ApplyContains(q, PostalCodeContains, e => e.PostalCode);
            q = ApplyContains(q, EmailContains, e => e.Email);
            q = ApplyContains(q, FatherNameContains, e => e.FatherName);
            q = ApplyContains(q, DescriptionContains, e => e.PersonalDescription);
            if (!string.IsNullOrWhiteSpace(PhoneContains))
            {
                var p = PhoneContains.Trim();
                q = q.Where(e =>
                    Contains(e.PrimaryPhone, p)
                    || Contains(e.SecondaryPhone, p)
                    || Contains(e.EmergencyPhone, p));
            }
            if (!string.IsNullOrWhiteSpace(SocialContains))
            {
                var s = SocialContains.Trim();
                q = q.Where(e =>
                    Contains(e.Telegram, s)
                    || Contains(e.Whatsapp, s)
                    || Contains(e.Instagram, s)
                    || Contains(e.Linkedin, s));
            }

            if (ExtraContains != null)
            {
                foreach (var kv in ExtraContains)
                {
                    if (string.IsNullOrWhiteSpace(kv.Value))
                        continue;
                    var key = kv.Key;
                    var needle = kv.Value.Trim();
                    q = q.Where(e => Contains(ExtraField(e, key), needle));
                }
            }

            if (SuggestionIn != null)
            {
                foreach (var kv in SuggestionIn)
                {
                    if (kv.Value == null || kv.Value.Count == 0)
                        continue;
                    var key = kv.Key;
                    var set = new HashSet<string>(
                        kv.Value.Where(x => !string.IsNullOrWhiteSpace(x)).Select(x => x.Trim()),
                        StringComparer.CurrentCultureIgnoreCase);
                    if (set.Count == 0)
                        continue;
                    q = q.Where(e => set.Contains(SuggestionField(e, key)));
                }
            }

            q = ApplyPresence(q, PhotoMode, e => !string.IsNullOrWhiteSpace(e.PhotoPath));
            q = ApplyPresence(q, DocBirthMode, e => DocumentKinds.Of(e, DocumentKinds.Birth).Count > 0);
            q = ApplyPresence(q, DocNationalMode, e => DocumentKinds.Of(e, DocumentKinds.National).Count > 0);
            q = ApplyPresence(q, DocOtherMode, e => DocumentKinds.Of(e, DocumentKinds.Other).Count > 0);
            q = ApplyPresence(q, EmailMode, e => !string.IsNullOrWhiteSpace(e.Email));
            q = ApplyPresence(q, PhoneMode, e => !string.IsNullOrWhiteSpace(e.PrimaryPhone));
            q = ApplyPresence(q, AddressMode, e => !string.IsNullOrWhiteSpace(e.HomeAddress));
            q = ApplyPresence(q, EducationMode, e => !string.IsNullOrWhiteSpace(e.EducationLevel));

            if (string.Equals(OfficialOnly, "yes", StringComparison.OrdinalIgnoreCase))
                q = q.Where(e => string.Equals(
                    Qaemshahr.Core.HrLookups.NormalizeEmploymentType(e.EmploymentType) ?? (e.EmploymentType ?? "").Trim(),
                    "رسمی", StringComparison.Ordinal));
            else if (string.Equals(OfficialOnly, "no", StringComparison.OrdinalIgnoreCase))
                q = q.Where(e => !string.Equals(
                    Qaemshahr.Core.HrLookups.NormalizeEmploymentType(e.EmploymentType) ?? (e.EmploymentType ?? "").Trim(),
                    "رسمی", StringComparison.Ordinal));

            var list = q.ToList();
            list.Sort(CompareEmployees);
            return list;
        }

        bool HasSuggestionFilter(string columnKey)
        {
            if (SuggestionIn == null || string.IsNullOrWhiteSpace(columnKey))
                return false;
            List<string> list;
            if (!SuggestionIn.TryGetValue(columnKey, out list) || list == null)
                return false;
            return list.Any(x => !string.IsNullOrWhiteSpace(x));
        }

        static string ExtraField(Employee e, string key)
        {
            if (e == null)
                return "";
            switch (key)
            {
                case "firstName": return e.FirstName ?? "";
                case "lastName": return e.LastName ?? "";
                case "fullName": return e.FullName ?? "";
                case "nationalId": return e.NationalId ?? "";
                case "idBookletNumber": return e.IdBookletNumber ?? "";
                case "employeeNumber": return e.EmployeeNumber ?? "";
                case "subscriptionNumber": return e.SubscriptionNumber ?? "";
                case "iban1": return IranianIban.FormatDisplay(e.Iban1);
                case "iban2": return IranianIban.FormatDisplay(e.Iban2);
                case "insuranceNumber": return e.InsuranceNumber ?? "";
                case "fatherName": return e.FatherName ?? "";
                case "phone": return e.PrimaryPhone ?? "";
                case "secondaryPhone": return e.SecondaryPhone ?? "";
                case "emergencyPhone": return e.EmergencyPhone ?? "";
                case "email": return e.Email ?? "";
                case "address": return e.HomeAddress ?? "";
                case "postalCode": return e.PostalCode ?? "";
                case "personalDescription": return e.PersonalDescription ?? "";
                case "inactiveReason": return e.InactiveReasonFa ?? e.InactiveReason ?? "";
                case "jobGroup": return e.JobGroup ?? "";
                case "telegram": return e.Telegram ?? "";
                case "whatsapp": return e.Whatsapp ?? "";
                case "instagram": return e.Instagram ?? "";
                case "linkedin": return e.Linkedin ?? "";
                default: return "";
            }
        }

        static string SuggestionField(Employee e, string key)
        {
            if (e == null)
                return "";
            switch (key)
            {
                case "birthPlace": return (e.BirthPlace ?? "").Trim();
                case "serviceCity": return (e.ServiceCity ?? "").Trim();
                case "veteranStatus": return (e.VeteranStatus ?? "").Trim();
                case "position": return (e.CurrentPosition ?? "").Trim();
                case "previousPosition": return (e.PreviousPosition ?? "").Trim();
                case "desiredPosition": return (e.DesiredPosition ?? "").Trim();
                case "educationLevel": return (e.EducationLevel ?? "").Trim();
                case "major": return (e.Major ?? "").Trim();
                case "university": return (e.University ?? "").Trim();
                case "skillName": return (e.SkillName ?? "").Trim();
                case "skillLevel": return (e.SkillLevel ?? "").Trim();
                case "insuranceType": return (e.InsuranceType ?? "").Trim();
                default: return "";
            }
        }

        static IEnumerable<Employee> ApplyDateRange(
            IEnumerable<Employee> q, string fromText, string toText, Func<Employee, string> getter)
        {
            long? fromMs = null;
            long? toMs = null;
            if (!string.IsNullOrWhiteSpace(fromText))
                fromMs = Qaemshahr.Core.PersianDate.ToEpochMs(fromText.Trim());
            if (!string.IsNullOrWhiteSpace(toText))
                toMs = Qaemshahr.Core.PersianDate.ToEpochMs(toText.Trim());
            if (fromMs == null && toMs == null)
                return q;
            return q.Where(e =>
            {
                var ms = Qaemshahr.Core.PersianDate.ToEpochMs(getter(e));
                if (ms == null)
                    return false;
                if (fromMs != null && ms.Value < fromMs.Value)
                    return false;
                if (toMs != null && ms.Value > toMs.Value)
                    return false;
                return true;
            });
        }

        static IEnumerable<Employee> ApplyContains(IEnumerable<Employee> q, string needle, Func<Employee, string> getter)
        {
            if (string.IsNullOrWhiteSpace(needle))
                return q;
            var n = needle.Trim();
            return q.Where(e => Contains(getter(e), n));
        }

        static IEnumerable<Employee> ApplyPresence(IEnumerable<Employee> q, string mode, Func<Employee, bool> has)
        {
            if (string.Equals(mode, "yes", StringComparison.OrdinalIgnoreCase))
                return q.Where(has);
            if (string.Equals(mode, "no", StringComparison.OrdinalIgnoreCase))
                return q.Where(e => !has(e));
            return q;
        }

        int CompareEmployees(Employee a, Employee b)
        {
            var key = string.IsNullOrWhiteSpace(SortBy) ? "fullName" : SortBy;
            int cmp;
            if (key == "age" || key == "tenure" || key == "childrenCount")
            {
                var na = SortNumber(a, key);
                var nb = SortNumber(b, key);
                cmp = na.CompareTo(nb);
            }
            else
            {
                var sa = SortValue(a, key);
                var sb = SortValue(b, key);
                cmp = string.Compare(sa, sb, StringComparison.CurrentCultureIgnoreCase);
            }
            return SortAscending ? cmp : -cmp;
        }

        static double SortNumber(Employee e, string key)
        {
            if (e == null)
                return -1;
            if (key == "childrenCount")
                return e.ChildrenCount;
            if (key == "age")
                return Qaemshahr.Core.PersianDate.CompleteYears(e.BirthDate) ?? -1;
            if (key == "tenure")
                return Qaemshahr.Core.PersianDate.CompleteYears(e.EmploymentDate) ?? -1;
            return -1;
        }

        static string SortValue(Employee e, string key)
        {
            if (e == null)
                return "";
            switch (key)
            {
                case "lastName": return (e.LastName ?? "") + " " + (e.FirstName ?? "");
                case "nationalId": return e.NationalId ?? "";
                case "employeeNumber": return e.EmployeeNumber ?? "";
                case "position": return e.CurrentPosition ?? "";
                case "employmentDate": return e.EmploymentDate ?? "";
                case "birthDate": return e.BirthDate ?? "";
                case "status": return e.StatusFa ?? "";
                default: return e.FullName ?? "";
            }
        }

        static bool Contains(string hay, string needle)
        {
            return (hay ?? "").IndexOf(needle, StringComparison.CurrentCultureIgnoreCase) >= 0;
        }

        static string NormStatus(Employee e)
        {
            return e != null && e.EmploymentStatus == "inactive" ? "غیرفعال" : "فعال";
        }

        static string NormGender(string g)
        {
            return HrLookups.NormalizeGender(g) ?? string.Empty;
        }

        static string NormMarital(string m)
        {
            if (m == "single") return "مجرد";
            if (m == "married") return "متأهل";
            if (m == "divorced") return "مطلقه";
            if (m == "widowed") return "بیوه";
            return (m ?? "").Trim();
        }

        static string NormMilitary(string raw)
        {
            if (string.IsNullOrWhiteSpace(raw))
                return string.Empty;
            switch (raw.Trim())
            {
                case "done": return "پایان خدمت";
                case "exempt": return "معاف";
                case "serving": return "در حال خدمت";
                case "not_applicable": return "مشمول نیست";
                default: return raw.Trim();
            }
        }
    }
}
