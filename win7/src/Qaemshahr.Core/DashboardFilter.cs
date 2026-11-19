namespace Qaemshahr.Core

{

    public static class DashboardFilter

    {

        public const string Active = "active";

        public const string Inactive = "inactive";

        public const string Incomplete = "incomplete";

        public const string Contact = "contact";

        public const string Exemplary = "exemplary";

        public const string ExtraOrg = "extraorg";

        public const string Type = "type";

        public const string PersonType = "person-type";

        public const string PersonStaff = "person-staff";

        public const string PersonWorker = "person-worker";

        public const string MissingPhoto = "missing-photo";

        public const string MissingBirth = "missing-birth";

        public const string MissingNational = "missing-national";

        public const string Gender = "gender";

        public const string Marital = "marital";

        public const string Group = "group";

        public const string InGroup = "in-group";

        public const string NotInGroup = "not-in-group";



        // سازگاری با فیلترهای قدیمی ارزیابی (در صورت کلیک از نسخه‌های قبل)

        public const string Gray = "gray";

        public const string Red = "red";

        public const string Orange = "orange";

        public const string Yellow = "yellow";

        public const string Green = "green";

        public const string SeasonOpen = "season-open";



        public static string TitleFa(string key, string value = null)

        {

            switch (key)

            {

                case Active: return "نیروی فعال";

                case Inactive: return "نیروی غیرفعال";

                case Incomplete: return "پرونده ناقص";

                case Contact: return "بدون تلفن یا سمت";

                case Exemplary: return "نمونه";

                case ExtraOrg: return "معرفی فراسازمانی";

                case Type:

                    return string.IsNullOrWhiteSpace(value) ? "نوع استخدام: نامشخص" : "نوع استخدام: " + value;

                case PersonType:

                    return string.IsNullOrWhiteSpace(value) ? "نوع پرسنل" : "نوع پرسنل: " + value;

                case PersonStaff: return "کارمند";

                case PersonWorker: return "کارگر";

                case MissingPhoto: return "بدون عکس ۴×۳";

                case MissingBirth: return "بدون شناسنامه";

                case MissingNational: return "بدون کارت ملی";

                case Gender:

                    return string.IsNullOrWhiteSpace(value) ? "جنسیت: نامشخص" : "جنسیت: " + value;

                case Marital:

                    return string.IsNullOrWhiteSpace(value) ? "وضعیت تأهل: نامشخص" : "وضعیت تأهل: " + value;

                case Group:

                    return string.IsNullOrWhiteSpace(value) ? "اعضای گروه" : "اعضای گروه";

                case InGroup: return "عضو حداقل یک گروه";

                case NotInGroup: return "بدون عضویت در گروه";

                case Gray: return "بدون ارزیابی تأییدشده";

                case Red: return "نیازمند اقدام (قرمز)";

                case Orange: return "ضعیف تا متوسط (نارنجی)";

                case Yellow: return "قابل قبول (زرد)";

                case Green: return "شایسته تقدیر (سبز)";

                case SeasonOpen: return "بدون ارزیابی فصل جاری";

                default: return "فیلتر داشبورد";

            }

        }

    }

}


