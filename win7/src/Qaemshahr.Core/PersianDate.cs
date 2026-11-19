using System;
using System.Globalization;
using System.Text;

namespace Qaemshahr.Core
{
    public static class PersianDate
    {
        static readonly PersianCalendar Calendar = new PersianCalendar();

        public static readonly string[] MonthNames =
        {
            "فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور",
            "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"
        };

        public static int CurrentYear()
        {
            return Calendar.GetYear(DateTime.Now);
        }

        public static int CurrentMonth()
        {
            return Calendar.GetMonth(DateTime.Now);
        }

        public static int CurrentDay()
        {
            return Calendar.GetDayOfMonth(DateTime.Now);
        }

        /// <summary>سال کامل از تاریخ شمسی تا امروز (سن یا سابقه).</summary>
        public static int? CompleteYears(string shamsi)
        {
            int y, m, d;
            if (!TryGetParts(shamsi, out y, out m, out d))
                return null;
            var years = CurrentYear() - y;
            if (CurrentMonth() < m || (CurrentMonth() == m && CurrentDay() < d))
                years--;
            if (years < 0)
                return null;
            return years;
        }

        public static bool TryGetYearMonth(string shamsi, out int year, out int month)
        {
            int d;
            return TryGetParts(shamsi, out year, out month, out d);
        }

        public static int DaysInMonth(int year, int month)
        {
            try
            {
                return Calendar.GetDaysInMonth(year, month);
            }
            catch
            {
                return 30;
            }
        }

        public static bool IsValid(int year, int month, int day)
        {
            try
            {
                Calendar.ToDateTime(year, month, day, 0, 0, 0, 0);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static string FormatParts(int year, int month, int day)
        {
            return string.Format("{0:0000}/{1:00}/{2:00}", year, month, day);
        }

        public static bool TryGetParts(string text, out int year, out int month, out int day)
        {
            year = 0;
            month = 0;
            day = 0;
            if (string.IsNullOrWhiteSpace(text))
                return false;
            var parts = text.Trim().Replace('-', '/').Replace('.', '/').Split('/');
            if (parts.Length != 3)
                return false;
            if (!int.TryParse(parts[0], out year) || !int.TryParse(parts[1], out month) || !int.TryParse(parts[2], out day))
                return false;
            return IsValid(year, month, day);
        }

        public static string Normalize(string text)
        {
            int y, m, d;
            return TryGetParts(text, out y, out m, out d) ? FormatParts(y, m, d) : null;
        }

        public static string Format(DateTime? utcOrLocal)
        {
            if (utcOrLocal == null)
                return string.Empty;
            var d = utcOrLocal.Value;
            if (d.Kind == DateTimeKind.Utc)
                d = d.ToLocalTime();
            return string.Format("{0:0000}/{1:00}/{2:00}",
                Calendar.GetYear(d), Calendar.GetMonth(d), Calendar.GetDayOfMonth(d));
        }

        public static string Today()
        {
            return Format(DateTime.Now);
        }

        /// <summary>مقایسه تاریخ شمسی با امروز؛ منفی = قبل/امروز گذشته، صفر = امروز، مثبت = آینده. نامعتبر = null.</summary>
        public static int? CompareToToday(string shamsi)
        {
            var n = Normalize(shamsi);
            if (n == null)
                return null;
            return string.CompareOrdinal(n, Today());
        }

        /// <summary>آیا تاریخ بازنشستگی فرا رسیده یا گذشته است.</summary>
        public static bool IsOnOrBeforeToday(string shamsi)
        {
            var c = CompareToToday(shamsi);
            return c != null && c.Value <= 0;
        }

        public static string NowDateTime()
        {
            var d = DateTime.Now;
            return string.Format("{0} {1:00}:{2:00}", Format(d), d.Hour, d.Minute);
        }

        /// <summary>ارقام لاتین → فارسی تا در متن RTL برعکس نشوند.</summary>
        public static string DigitsFa(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text ?? string.Empty;
            var sb = new StringBuilder(text.Length);
            foreach (var ch in text)
            {
                if (ch >= '0' && ch <= '9')
                    sb.Append((char)('\u06F0' + (ch - '0')));
                else if (ch >= '\u0660' && ch <= '\u0669')
                    sb.Append((char)('\u06F0' + (ch - '\u0660')));
                else
                    sb.Append(ch);
            }
            return sb.ToString();
        }

        /// <summary>ارقام فارسی/عربی → لاتین برای Parse عددی.</summary>
        public static string DigitsEn(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text ?? string.Empty;
            var sb = new StringBuilder(text.Length);
            foreach (var ch in text)
            {
                if (ch >= '\u06F0' && ch <= '\u06F9')
                    sb.Append((char)('0' + (ch - '\u06F0')));
                else if (ch >= '\u0660' && ch <= '\u0669')
                    sb.Append((char)('0' + (ch - '\u0660')));
                else
                    sb.Append(ch);
            }
            return sb.ToString();
        }

        /// <summary>ایزوله LTR برای تاریخ/ساعت در خروجی PDF تا ترتیب سال/ماه/روز حفظ شود (روز سمت راست).</summary>
        public static string LtrIsolate(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text ?? string.Empty;
            return "\u202A" + text + "\u202C";
        }

        /// <summary>تاریخ ذخیره‌شده (سال/ماه/روز) برای نمایش در گزارش فارسی.</summary>
        public static string ReportDate(string storedYmd)
        {
            var n = Normalize(storedYmd);
            if (string.IsNullOrEmpty(n))
                n = (storedYmd ?? string.Empty).Trim();
            if (string.IsNullOrEmpty(n))
                return string.Empty;
            return LtrIsolate(DigitsFa(n));
        }

        /// <summary>تاریخ و ساعت فعلی برای سربرگ/پاورقی گزارش.</summary>
        public static string ReportNowDateTime()
        {
            return LtrIsolate(DigitsFa(NowDateTime()));
        }

        /// <summary>فقط تاریخ شمسی برای سربرگ گزارش.</summary>
        public static string ReportDateOnly(string shamsiOrNull)
        {
            var n = Normalize(string.IsNullOrWhiteSpace(shamsiOrNull) ? Today() : shamsiOrNull.Trim());
            if (string.IsNullOrEmpty(n))
                n = Today();
            return LtrIsolate(DigitsFa(n));
        }

        /// <summary>متن گزارش با ارقام فارسی (جلوگیری از برعکس‌شدن ارقام لاتین در RTL).</summary>
        public static string ReportText(string text)
        {
            return DigitsFa(text ?? string.Empty);
        }

        public static DateTime? Parse(string text)
        {
            int y, m, d;
            if (!TryGetParts(text, out y, out m, out d))
                return null;
            try
            {
                return Calendar.ToDateTime(y, m, d, 0, 0, 0, 0);
            }
            catch
            {
                return null;
            }
        }

        public static long? ToEpochMs(string shamsi)
        {
            var dt = Parse(shamsi);
            if (dt == null)
                return null;
            return new DateTimeOffset(DateTime.SpecifyKind(dt.Value, DateTimeKind.Local)).ToUnixTimeMilliseconds();
        }

        public static string FromEpochMs(long? ms)
        {
            if (ms == null)
                return string.Empty;
            var dt = DateTimeOffset.FromUnixTimeMilliseconds(ms.Value).LocalDateTime;
            return Format(dt);
        }

        /// <summary>تاریخ و ساعت شمسی با دقیقه (مثلاً ۱۴۰۴/۰۶/۲۱ — ۱۴:۳۵).</summary>
        public static string FromEpochMsDateTime(long? ms)
        {
            if (ms == null)
                return string.Empty;
            var dt = DateTimeOffset.FromUnixTimeMilliseconds(ms.Value).LocalDateTime;
            return string.Format("{0} — {1:00}:{2:00}", Format(dt), dt.Hour, dt.Minute);
        }

        public static string FromEpochMsTime(long? ms)
        {
            if (ms == null)
                return string.Empty;
            var dt = DateTimeOffset.FromUnixTimeMilliseconds(ms.Value).LocalDateTime;
            return string.Format("{0:00}:{1:00}", dt.Hour, dt.Minute);
        }
    }
}
