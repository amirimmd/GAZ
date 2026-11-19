namespace Qaemshahr.Core
{
    public static class TextUtil
    {
        public static bool ContainsPersianOrArabic(string text)
        {
            if (string.IsNullOrEmpty(text))
                return false;
            for (var i = 0; i < text.Length; i++)
            {
                var c = text[i];
                if (c >= 0x0600 && c <= 0x06FF)
                    return true;
                if (c >= 0x0750 && c <= 0x077F)
                    return true;
                if (c >= 0x08A0 && c <= 0x08FF)
                    return true;
                if (c >= 0xFB50 && c <= 0xFDFF)
                    return true;
                if (c >= 0xFE70 && c <= 0xFEFF)
                    return true;
            }
            return false;
        }

        public static string NormalizeUsername(string username)
        {
            return (username ?? string.Empty).Trim().ToLowerInvariant();
        }
    }
}
