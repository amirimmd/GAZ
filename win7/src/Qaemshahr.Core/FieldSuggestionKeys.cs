using System;
using System.Collections.Generic;

namespace Qaemshahr.Core
{
    public static class FieldSuggestionKeys
    {
        public const string BirthPlace = "birthPlace";
        public const string CurrentPosition = "currentPosition";
        public const string PreviousPosition = "previousPosition";
        public const string DesiredPosition = "desiredPosition";
        public const string EducationLevel = "educationLevel";
        public const string Major = "major";
        public const string University = "university";
        public const string SkillName = "skillName";
        public const string SkillLevel = "skillLevel";
        public const string InsuranceType = "insuranceType";
        public const string SampleOrganization = "sampleOrganization";
        public const string GroupPurpose = "groupPurpose";
        public const string ServiceCity = "serviceCity";
        public const string VeteranStatus = "veteranStatus";

        public static readonly string[] All =
        {
            BirthPlace,
            CurrentPosition,
            PreviousPosition,
            DesiredPosition,
            EducationLevel,
            Major,
            University,
            SkillName,
            SkillLevel,
            InsuranceType,
            SampleOrganization,
            GroupPurpose,
            ServiceCity,
            VeteranStatus
        };

        public static bool IsSupported(string key)
        {
            if (string.IsNullOrWhiteSpace(key))
                return false;
            foreach (var k in All)
            {
                if (string.Equals(k, key, StringComparison.Ordinal))
                    return true;
            }
            return false;
        }

        public static string CategoryForReportColumn(string columnKey)
        {
            if (string.IsNullOrWhiteSpace(columnKey))
                return null;
            switch (columnKey)
            {
                case "position":
                    return CurrentPosition;
                case "birthPlace":
                case "previousPosition":
                case "desiredPosition":
                case "educationLevel":
                case "major":
                case "university":
                case "skillName":
                case "skillLevel":
                case "insuranceType":
                case "serviceCity":
                case "veteranStatus":
                    return columnKey;
                default:
                    return IsSupported(columnKey) ? columnKey : null;
            }
        }

        public static string TitleFa(string key)
        {
            switch (key)
            {
                case BirthPlace: return "محل تولد";
                case CurrentPosition: return "سمت فعلی";
                case PreviousPosition: return "سمت قبلی";
                case DesiredPosition: return "سمت حین خدمت";
                case EducationLevel: return "مقطع تحصیلی";
                case Major: return "رشته";
                case University: return "دانشگاه";
                case SkillName: return "مهارت";
                case SkillLevel: return "سطح مهارت";
                case InsuranceType: return "نوع بیمه";
                case SampleOrganization: return "سازمان معرفی نمونه";
                case GroupPurpose: return "نوع گروه (سایر)";
                case ServiceCity: return "شهر محل خدمت";
                case VeteranStatus: return "وضعیت ایثارگری";
                default: return key;
            }
        }

        public static List<string> Merge(IEnumerable<string> stored, string current)
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
    }
}
