using System;
using System.Security.Cryptography;
using System.Text.RegularExpressions;

namespace Qaemshahr.Core
{
    public static class PasswordPolicy
    {
        const string Upper = "ABCDEFGHJKLMNPQRSTUVWXYZ";
        const string Lower = "abcdefghijkmnopqrstuvwxyz";
        const string Digits = "23456789";
        const string Alphabet = Upper + Lower + Digits;

        public static string ValidateNewPassword(string newPassword, string username = null)
        {
            if (string.IsNullOrEmpty(newPassword) || newPassword.Length < 10)
                return "رمز عبور باید حداقل ۱۰ کاراکتر باشد";
            if (newPassword.Length > PasswordHasher.MaxPasswordLength)
                return "رمز عبور بیش از حد طولانی است";
            if (TextUtil.ContainsPersianOrArabic(newPassword))
                return "رمز عبور را با صفحه کلید انگلیسی وارد کنید";
            if (!Regex.IsMatch(newPassword, "[A-Z]")
                || !Regex.IsMatch(newPassword, "[a-z]")
                || !Regex.IsMatch(newPassword, "[0-9]"))
            {
                return "رمز عبور باید شامل حروف بزرگ، کوچک و عدد باشد";
            }
            if (!string.IsNullOrEmpty(username)
                && newPassword.IndexOf(username, StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return "رمز عبور نباید شامل نام کاربری باشد";
            }
            if (string.Equals(newPassword, AppConstants.DefaultAdminPassword, StringComparison.Ordinal))
                return "این رمز پیش‌فرض است؛ رمز دیگری انتخاب کنید";
            return null;
        }

        /// <summary>رمز یک‌بارمصرف برای ریست توسط مدیر؛ کاربر در ورود بعدی باید عوض کند.</summary>
        public static string GenerateTemporaryPassword(int length = 12)
        {
            if (length < 10)
                length = 10;

            var chars = new char[length];
            chars[0] = Upper[NextIndex(Upper.Length)];
            chars[1] = Lower[NextIndex(Lower.Length)];
            chars[2] = Digits[NextIndex(Digits.Length)];
            for (var i = 3; i < length; i++)
                chars[i] = Alphabet[NextIndex(Alphabet.Length)];

            // shuffle
            for (var i = length - 1; i > 0; i--)
            {
                var j = NextIndex(i + 1);
                var tmp = chars[i];
                chars[i] = chars[j];
                chars[j] = tmp;
            }
            return new string(chars);
        }

        static int NextIndex(int maxExclusive)
        {
            if (maxExclusive <= 0)
                throw new ArgumentOutOfRangeException("maxExclusive");
            var bytes = new byte[4];
            using (var rng = RandomNumberGenerator.Create())
            {
                uint value;
                do
                {
                    rng.GetBytes(bytes);
                    value = BitConverter.ToUInt32(bytes, 0);
                } while (value >= uint.MaxValue - (uint.MaxValue % (uint)maxExclusive));
                return (int)(value % (uint)maxExclusive);
            }
        }
    }
}
