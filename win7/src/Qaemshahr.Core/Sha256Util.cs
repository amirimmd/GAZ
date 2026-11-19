using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Qaemshahr.Core
{
    public static class Sha256Util
    {
        public static string Hex(byte[] data)
        {
            using (var sha = SHA256.Create())
                return ToHex(sha.ComputeHash(data));
        }

        public static string HexFile(string path)
        {
            using (var sha = SHA256.Create())
            using (var fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
                return ToHex(sha.ComputeHash(fs));
        }

        public static string HexUtf8(string text)
        {
            return Hex(Encoding.UTF8.GetBytes(text ?? string.Empty));
        }

        static string ToHex(byte[] hash)
        {
            var sb = new StringBuilder(hash.Length * 2);
            foreach (var b in hash)
                sb.Append(b.ToString("x2"));
            return sb.ToString();
        }
    }
}
