using System.Text.RegularExpressions;

namespace Qaemshahr.Core
{
    public static class IranianNationalId
    {
        public static bool IsValid(string raw)
        {
            if (raw == null)
                return false;
            var code = raw.Trim();
            if (!Regex.IsMatch(code, @"^\d{10}$"))
                return false;
            if (Regex.IsMatch(code, @"^(\d)\1{9}$"))
                return false;
            var sum = 0;
            for (var i = 0; i < 9; i++)
                sum += (code[i] - '0') * (10 - i);
            var r = sum % 11;
            var check = code[9] - '0';
            return (r < 2 && check == r) || (r >= 2 && check == 11 - r);
        }
    }
}
