using System.Collections.Generic;
using System.Linq;

namespace Qaemshahr.Core
{
    /// <summary>بخش‌ها و فیلدهای ورود گروهی مطابق تب‌های پرونده کارمند.</summary>
    public static class BulkImportCatalog
    {
        public const string Identity = "identity";
        public const string Org = "org";
        public const string Contact = "contact";
        public const string Education = "education";

        public sealed class Section
        {
            public string Key { get; set; }
            public string TitleFa { get; set; }
            public bool AlwaysOn { get; set; }
            public string HintFa { get; set; }
            public List<Field> Fields { get; set; }
        }

        public sealed class Field
        {
            public string Key { get; set; }
            public string TitleFa { get; set; }
            public bool Required { get; set; }
            public bool Ltr { get; set; }
            public bool Multiline { get; set; }
        }

        public static List<Section> AllSections()
        {
            return new List<Section>
            {
                new Section
                {
                    Key = Identity,
                    TitleFa = "هویت",
                    AlwaysOn = true,
                    HintFa = "حداقل نام، نام خانوادگی و کد ملی لازم است.",
                    Fields = new List<Field>
                    {
                        F("firstName", "نام", true, false),
                        F("lastName", "نام خانوادگی", true, false),
                        F("fatherName", "نام پدر", false, false),
                        F("nationalId", "کد ملی", true, true),
                        F("idBookletNumber", "شماره شناسنامه", false, true),
                        F("birthDate", "تاریخ تولد", false, true),
                        F("birthPlace", "محل تولد", false, false),
                        F("veteranStatus", "وضعیت ایثارگری", false, false),
                        F("gender", "جنسیت", false, false),
                        F("maritalStatus", "وضعیت تأهل", false, false),
                        F("childrenCount", "تعداد فرزندان", false, true),
                        F("bloodGroup", "گروه خونی", false, false),
                        F("militaryStatus", "وضعیت نظام وظیفه", false, false),
                        F("personalDescription", "توضیحات", false, false, true)
                    }
                },
                new Section
                {
                    Key = Org,
                    TitleFa = "سازمانی",
                    Fields = new List<Field>
                    {
                        F("employeeNumber", "شماره پرسنلی", false, true),
                        F("subscriptionNumber", "شماره اشتراک", false, true),
                        F("serviceCity", "شهر محل خدمت", false, false),
                        F("currentPosition", "سمت فعلی", false, false),
                        F("previousPosition", "سمت قبلی", false, false),
                        F("desiredPosition", "سمت حین خدمت (فیزیکی)", false, false),
                        F("personType", "نوع پرسنل", false, false),
                        F("employmentType", "نوع استخدام", false, false),
                        F("jobGroup", "گروه شغلی", false, false),
                        F("positionBase", "پایه شماره سمت", false, true),
                        F("personalBase", "پایه شخصی", false, true),
                        F("employmentDate", "تاریخ استخدام", false, true),
                        F("retirementDate", "تاریخ بازنشستگی", false, true),
                        F("employmentStatus", "وضعیت اشتغال", false, false),
                        F("inactiveReason", "دلیل غیرفعال‌سازی", false, false)
                    }
                },
                new Section
                {
                    Key = Contact,
                    TitleFa = "تماس",
                    Fields = new List<Field>
                    {
                        F("primaryPhone", "تلفن اصلی", false, true),
                        F("secondaryPhone", "تلفن دوم", false, true),
                        F("emergencyPhone", "تلفن اضطراری", false, true),
                        F("email", "ایمیل", false, true),
                        F("homeAddress", "آدرس", false, false, true),
                        F("postalCode", "کد پستی", false, true),
                        F("iban1", "شماره شبا ۱", false, true),
                        F("iban2", "شماره شبا ۲", false, true)
                    }
                },
                new Section
                {
                    Key = Education,
                    TitleFa = "تحصیلات و سوابق",
                    HintFa = "مقطع، رشته، بیمه و شبکه‌های اجتماعی.",
                    Fields = new List<Field>
                    {
                        F("educationLevel", "مقطع تحصیلی", false, false),
                        F("major", "رشته", false, false),
                        F("university", "دانشگاه", false, false),
                        F("skillName", "مهارت", false, false),
                        F("skillLevel", "سطح مهارت", false, false),
                        F("insuranceNumber", "شماره بیمه", false, true),
                        F("insuranceType", "نوع بیمه", false, false),
                        F("telegram", "تلگرام", false, true),
                        F("whatsapp", "واتساپ", false, true),
                        F("instagram", "اینستاگرام", false, true),
                        F("linkedin", "لینکدین", false, true)
                    }
                }
            };
        }

        public static List<Field> FieldsForSections(IEnumerable<string> sectionKeys)
        {
            var set = new HashSet<string>(sectionKeys ?? new string[0]);
            if (!set.Contains(Identity))
                set.Add(Identity);
            var list = new List<Field>();
            foreach (var s in AllSections())
            {
                if (!set.Contains(s.Key))
                    continue;
                list.AddRange(s.Fields);
            }
            return list;
        }

        public static List<Field> FieldsForKeys(IEnumerable<string> fieldKeys)
        {
            var set = new HashSet<string>(fieldKeys ?? new string[0]);
            // فیلدهای الزامی هویت همیشه
            set.Add("firstName");
            set.Add("lastName");
            set.Add("nationalId");
            var list = new List<Field>();
            foreach (var s in AllSections())
            {
                foreach (var f in s.Fields)
                {
                    if (set.Contains(f.Key))
                        list.Add(f);
                }
            }
            return list;
        }

        public static string[] HeadersForSections(IEnumerable<string> sectionKeys)
        {
            return FieldsForSections(sectionKeys).Select(f => f.TitleFa).ToArray();
        }

        public static string[] HeadersForKeys(IEnumerable<string> fieldKeys)
        {
            return FieldsForKeys(fieldKeys).Select(f => f.TitleFa).ToArray();
        }

        public static List<string> DefaultSelectedFieldKeys()
        {
            var list = new List<string>();
            foreach (var s in AllSections())
            {
                foreach (var f in s.Fields)
                {
                    // هویت + سازمانی + تماس + تحصیلات — برای ورود راحت‌تر همه بخش‌ها پیش‌فرض روشن
                    list.Add(f.Key);
                }
            }
            return list;
        }

        public static List<string> RequiredFieldKeys()
        {
            var list = new List<string>();
            foreach (var s in AllSections())
            {
                foreach (var f in s.Fields)
                {
                    if (f.Required)
                        list.Add(f.Key);
                }
            }
            return list;
        }

        public static string[] EnumOptions(string fieldKey)
        {
            switch (fieldKey)
            {
                case "gender": return new[] { HrLookups.GenderMaleFa, HrLookups.GenderFemaleFa };
                case "maritalStatus": return new[] { "مجرد", "متأهل" };
                case "bloodGroup": return new[] { "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-" };
                case "militaryStatus":
                    return new[] { "پایان خدمت", "معاف", "معافیت تحصیلی", "در حال خدمت", "مشمول", "مشمول نیست" };
                case "personType": return new[] { "کارمند", "کارگر" };
                case "employmentType": return new[] { "رسمی", "قراردادی", "ارکان ثالث", "خارج پرتال" };
                case "employmentStatus": return new[] { "فعال", "غیرفعال" };
                default: return null;
            }
        }

        static Field F(string key, string title, bool required, bool ltr, bool multiline = false)
        {
            return new Field
            {
                Key = key,
                TitleFa = title,
                Required = required,
                Ltr = ltr,
                Multiline = multiline
            };
        }
    }
}
