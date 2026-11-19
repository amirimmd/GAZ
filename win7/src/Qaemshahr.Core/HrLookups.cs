using System;
using System.Collections.Generic;

namespace Qaemshahr.Core
{
    public static class HrLookups
    {
        public const string EmploymentOfficial = "رسمی";
        public const string EmploymentThirdPillar = "ارکان ثالث";
        /// <summary>املای اشتباه قدیمی؛ هنگام خواندن/ذخیره به ارکان ثالث نرمال می‌شود.</summary>
        public const string EmploymentThirdPillarLegacy = "ارگان ثالث";

        public const string PersonStaff = "staff";
        public const string PersonWorker = "worker";
        public const string InactiveReasonRetirement = "بازنشستگی";

        public const string GenderMaleFa = "آقا";
        public const string GenderFemaleFa = "خانم";

        /// <summary>مقادیر قدیمی (مرد/زن/male/female) را به آقا/خانم یکدست می‌کند.</summary>
        public static string NormalizeGender(string gender)
        {
            var g = (gender ?? string.Empty).Trim();
            if (g.Length == 0)
                return null;
            switch (g.ToLowerInvariant())
            {
                case "آقا":
                case "مرد":
                case "male":
                case "m":
                case "آقای":
                    return GenderMaleFa;
                case "خانم":
                case "زن":
                case "female":
                case "f":
                case "بانو":
                    return GenderFemaleFa;
                default:
                    return g;
            }
        }

        public static bool IsFemaleGender(string gender)
        {
            return string.Equals(NormalizeGender(gender), GenderFemaleFa, StringComparison.Ordinal);
        }

        public static bool IsMaleGender(string gender)
        {
            return string.Equals(NormalizeGender(gender), GenderMaleFa, StringComparison.Ordinal);
        }

        public static string NormalizePersonType(string personType)
        {
            var t = (personType ?? string.Empty).Trim();
            if (t.Length == 0)
                return PersonStaff;
            switch (t.ToLowerInvariant())
            {
                case PersonWorker:
                case "کارگر":
                    return PersonWorker;
                default:
                    return PersonStaff;
            }
        }

        public static string PersonTypeFa(string personType)
        {
            return NormalizePersonType(personType) == PersonWorker ? "کارگر" : "کارمند";
        }

        public static bool IsWorker(string personType)
        {
            return NormalizePersonType(personType) == PersonWorker;
        }

        public static bool IsOfficialEmployment(string employmentType)
        {
            return string.Equals((employmentType ?? string.Empty).Trim(), EmploymentOfficial, StringComparison.Ordinal);
        }

        public static bool IsThirdPillarEmployment(string employmentType)
        {
            var t = (employmentType ?? string.Empty).Trim();
            return string.Equals(t, EmploymentThirdPillar, StringComparison.Ordinal)
                || string.Equals(t, EmploymentThirdPillarLegacy, StringComparison.Ordinal);
        }

        public static string NormalizeEmploymentType(string employmentType)
        {
            var t = (employmentType ?? string.Empty).Trim();
            if (t.Length == 0)
                return null;
            if (string.Equals(t, EmploymentThirdPillarLegacy, StringComparison.Ordinal))
                return EmploymentThirdPillar;
            return t;
        }

        /// <summary>
        /// پیشنهادهای گروه شغلی از مقادیر ذخیره‌شده (بدون فهرست ثابت گروه ۱…۲۰).
        /// ورودی دستی هم مجاز است و پس از ذخیره در پیشنهادها می‌آید.
        /// </summary>
        public static List<string> MergeJobGroupSuggestions(IEnumerable<string> stored, string current)
        {
            var set = new SortedSet<string>(StringComparer.CurrentCultureIgnoreCase);
            if (stored != null)
            {
                foreach (var g in stored)
                {
                    var t = (g ?? string.Empty).Trim();
                    if (t.Length > 0)
                        set.Add(t);
                }
            }
            var cur = (current ?? string.Empty).Trim();
            if (cur.Length > 0)
                set.Add(cur);
            return new List<string>(set);
        }

        public static string ValidateOfficialBases(string employmentType, double? positionBase, double? personalBase)
        {
            if (!IsOfficialEmployment(employmentType))
                return null;
            if (positionBase == null)
                return "برای استخدام رسمی، پایه شماره سمت الزامی است";
            if (personalBase == null)
                return "برای استخدام رسمی، پایه شخصی الزامی است";
            if (positionBase.Value < 0 || personalBase.Value < 0)
                return "مقادیر پایه نمی‌تواند منفی باشد";
            if (personalBase.Value > positionBase.Value)
                return "پایه شخصی نمی‌تواند از پایه شماره سمت بیشتر باشد";
            return null;
        }

        public static string ValidateThirdPillarJobGroup(string employmentType, string jobGroup)
        {
            if (!IsThirdPillarEmployment(employmentType))
                return null;
            if (string.IsNullOrWhiteSpace(jobGroup))
                return "برای ارکان ثالث، گروه شغلی الزامی است";
            return null;
        }

        public static string MilitaryFa(string raw)
        {
            if (string.IsNullOrWhiteSpace(raw))
                return string.Empty;
            switch (raw.Trim())
            {
                case "done":
                    return "پایان خدمت";
                case "exempt":
                    return "معاف";
                case "serving":
                    return "در حال خدمت";
                case "not_applicable":
                    return "مشمول نیست";
                default:
                    return raw.Trim();
            }
        }
    }
}
