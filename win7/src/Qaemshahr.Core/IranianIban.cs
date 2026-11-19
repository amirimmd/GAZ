using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace Qaemshahr.Core
{
    /// <summary>تشخیص و قالب‌بندی شبا (IR) و بانک صادرکننده.</summary>
    public static class IranianIban
    {
        static readonly Dictionary<string, BankInfo> Banks = BuildBanks();

        public sealed class BankInfo
        {
            public string Code { get; set; }
            public string NameFa { get; set; }
            public string ShortFa { get; set; }
            public byte R { get; set; }
            public byte G { get; set; }
            public byte B { get; set; }
        }

        public static string Normalize(string raw)
        {
            if (string.IsNullOrWhiteSpace(raw))
                return null;
            var sb = new StringBuilder(32);
            foreach (var ch in PersianDate.DigitsEn(raw.Trim()))
            {
                if (ch == ' ' || ch == '-' || ch == '_')
                    continue;
                if ((ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z'))
                    sb.Append(char.ToUpperInvariant(ch));
            }
            var s = sb.ToString();
            if (s.Length == 0)
                return null;
            if (s.StartsWith("IR", StringComparison.Ordinal))
                return s;
            if (Regex.IsMatch(s, @"^\d{24}$"))
                return "IR" + s;
            return s;
        }

        public static string FormatDisplay(string raw)
        {
            var n = Normalize(raw);
            if (string.IsNullOrEmpty(n))
                return string.Empty;
            if (n.Length != 26 || !n.StartsWith("IR", StringComparison.Ordinal))
                return n;
            var sb = new StringBuilder(32);
            sb.Append(n.Substring(0, 4));
            for (var i = 4; i < n.Length; i += 4)
            {
                sb.Append(' ');
                sb.Append(n.Substring(i, Math.Min(4, n.Length - i)));
            }
            return sb.ToString();
        }

        public static bool TryDetectBank(string raw, out BankInfo bank)
        {
            bank = null;
            var n = Normalize(raw);
            if (string.IsNullOrEmpty(n) || n.Length < 7 || !n.StartsWith("IR", StringComparison.Ordinal))
                return false;
            var code = n.Substring(4, 3);
            return Banks.TryGetValue(code, out bank);
        }

        public static string ValidateOptional(string raw)
        {
            if (string.IsNullOrWhiteSpace(raw))
                return null;
            var n = Normalize(raw);
            if (n == null || n.Length != 26 || !n.StartsWith("IR", StringComparison.Ordinal))
                return "شماره شبا باید با IR و ۲۴ رقم باشد";
            if (!Regex.IsMatch(n, @"^IR\d{24}$"))
                return "شماره شبا فقط باید رقم باشد";
            return null;
        }

        static Dictionary<string, BankInfo> BuildBanks()
        {
            var d = new Dictionary<string, BankInfo>(StringComparer.Ordinal);
            Add(d, "010", "بانک مرکزی", "مرکزی", 0x1B, 0x3A, 0x4B);
            Add(d, "011", "صنعت و معدن", "صنعت", 0x0B, 0x6E, 0x4F);
            Add(d, "012", "ملت", "ملت", 0xC8, 0x10, 0x2E);
            Add(d, "013", "رفاه کارگران", "رفاه", 0x00, 0x55, 0xA5);
            Add(d, "014", "مسکن", "مسکن", 0xE8, 0x77, 0x22);
            Add(d, "015", "سپه", "سپه", 0x00, 0x6B, 0x3F);
            Add(d, "016", "کشاورزی", "کشاورزی", 0x2E, 0x7D, 0x32);
            Add(d, "017", "ملی ایران", "ملی", 0xF7, 0xC9, 0x48);
            Add(d, "018", "تجارت", "تجارت", 0x00, 0x33, 0xA0);
            Add(d, "019", "صادرات", "صادرات", 0xC8, 0x10, 0x2E);
            Add(d, "020", "توسعه صادرات", "توسعه صادرات", 0x0D, 0x47, 0xA1);
            Add(d, "021", "پست بانک", "پست", 0xF9, 0xA8, 0x25);
            Add(d, "022", "توسعه تعاون", "تعاون", 0x00, 0x79, 0x6B);
            Add(d, "051", "مؤسسه اعتباری توسعه", "توسعه", 0x45, 0x5A, 0x64);
            Add(d, "052", "قوامین", "قوامین", 0x1B, 0x5E, 0x20);
            Add(d, "053", "کارآفرین", "کارآفرین", 0x6A, 0x1B, 0x9A);
            Add(d, "054", "پارسیان", "پارسیان", 0xC9, 0xA2, 0x27);
            Add(d, "055", "اقتصاد نوین", "اقتصاد نوین", 0x7B, 0x1F, 0xA2);
            Add(d, "056", "سامان", "سامان", 0x00, 0xA3, 0xE0);
            Add(d, "057", "پاسارگاد", "پاسارگاد", 0x8B, 0x1A, 0x1A);
            Add(d, "058", "سرمایه", "سرمایه", 0x37, 0x47, 0x4F);
            Add(d, "059", "سینا", "سینا", 0x02, 0x77, 0xBD);
            Add(d, "060", "قرض‌الحسنه مهر ایران", "مهر", 0x00, 0x69, 0x5C);
            Add(d, "061", "شهر", "شهر", 0xD3, 0x2F, 0x2F);
            Add(d, "062", "آینده", "آینده", 0x15, 0x65, 0xC0);
            Add(d, "063", "گردشگری", "گردشگری", 0xEF, 0x6C, 0x00);
            Add(d, "064", "حکمت ایرانیان", "حکمت", 0x5D, 0x40, 0x37);
            Add(d, "065", "دی", "دی", 0x00, 0x83, 0x8F);
            Add(d, "066", "ایران زمین", "ایران‌زمین", 0x2E, 0x7D, 0x32);
            Add(d, "069", "ایران و اروپا", "ایران‌اروپا", 0x28, 0x35, 0x93);
            Add(d, "070", "قرض‌الحسنه رسالت", "رسالت", 0x00, 0x69, 0x5C);
            Add(d, "073", "کوثر", "کوثر", 0x00, 0x69, 0x5C);
            Add(d, "075", "مهر اقتصاد", "مهر اقتصاد", 0x1B, 0x5E, 0x20);
            Add(d, "078", "خاورمیانه", "خاورمیانه", 0x0D, 0x47, 0xA1);
            Add(d, "080", "نوین", "نوین", 0x6A, 0x1B, 0x9A);
            return d;
        }

        static void Add(Dictionary<string, BankInfo> d, string code, string name, string shortName, byte r, byte g, byte b)
        {
            d[code] = new BankInfo
            {
                Code = code,
                NameFa = name,
                ShortFa = shortName,
                R = r,
                G = g,
                B = b
            };
        }
    }
}
