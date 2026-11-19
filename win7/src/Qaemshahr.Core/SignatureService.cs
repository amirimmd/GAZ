using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Qaemshahr.Core
{
    public static class SignatureService
    {
        public static string Sign(byte[] data, byte[] key)
        {
            using (var hmac = new HMACSHA256(key))
                return ToBase64Url(hmac.ComputeHash(data));
        }

        public static string SignFile(string path, byte[] key)
        {
            using (var hmac = new HMACSHA256(key))
            using (var fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
                return ToBase64Url(hmac.ComputeHash(fs));
        }

        public static bool Verify(byte[] data, byte[] key, string signature)
        {
            return FixedEquals(Sign(data, key), signature);
        }

        public static bool VerifyFile(string path, byte[] key, string signature)
        {
            return FixedEquals(SignFile(path, key), signature);
        }

        static bool FixedEquals(string a, string b)
        {
            a = a ?? string.Empty;
            b = b ?? string.Empty;
            if (a.Length != b.Length)
                return false;
            var diff = 0;
            for (var i = 0; i < a.Length; i++)
                diff |= a[i] ^ b[i];
            return diff == 0;
        }

        public static string ToBase64Url(byte[] data)
        {
            return Convert.ToBase64String(data).TrimEnd('=').Replace('+', '-').Replace('/', '_');
        }

        public static byte[] FromBase64Url(string input)
        {
            var s = (input ?? string.Empty).Replace('-', '+').Replace('_', '/');
            var pad = (4 - s.Length % 4) % 4;
            if (pad > 0)
                s = s + new string('=', pad);
            return Convert.FromBase64String(s);
        }
    }
}
