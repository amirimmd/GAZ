using System;
using System.Security.Cryptography;
using System.Text;
using Konscious.Security.Cryptography;

namespace Qaemshahr.Core
{
    /// <summary>
    /// PHC Argon2id: $argon2id$v=19$m=65536,t=3,p=4$salt$hash (base64url or standard).
    /// </summary>
    public static class PasswordHasher
    {
        public const int MaxPasswordLength = 128;

        public static string HashPassword(string password, byte[] salt = null)
        {
            if (salt == null)
            {
                salt = new byte[16];
                using (var rng = RandomNumberGenerator.Create())
                    rng.GetBytes(salt);
            }

            var hash = Derive(
                Encoding.UTF8.GetBytes(password ?? string.Empty),
                salt,
                AppConstants.Argon2MemoryKiB,
                AppConstants.Argon2Iterations,
                AppConstants.Argon2Parallelism);
            return string.Format(
                "$argon2id$v=19$m={0},t={1},p={2}${3}${4}",
                AppConstants.Argon2MemoryKiB,
                AppConstants.Argon2Iterations,
                AppConstants.Argon2Parallelism,
                ToBase64Url(salt),
                ToBase64Url(hash));
        }

        public static bool VerifyPassword(string password, string encoded)
        {
            string error;
            var ok = TryVerify(password, encoded, out error);
            if (!ok && error != null)
                AppLog.Error("Password verify failed: " + error);
            return ok;
        }

        public static void DummyVerify(string password)
        {
            try
            {
                TryVerify(password ?? "x", DummyEncoded, out _);
            }
            catch
            {
            }
        }

        static readonly System.Lazy<string> DummyEncodedLazy =
            new System.Lazy<string>(() => HashPassword("timing-dummy-not-a-real-password"));

        static string DummyEncoded
        {
            get { return DummyEncodedLazy.Value; }
        }

        public static bool TryVerify(string password, string encoded, out string error)
        {
            error = null;
            try
            {
                if (string.IsNullOrEmpty(encoded))
                {
                    error = "empty-hash";
                    return false;
                }

                encoded = encoded.Trim().TrimEnd('\0');
                var parts = encoded.Split('$');
                if (parts.Length < 6 || !string.Equals(parts[1], "argon2id", StringComparison.OrdinalIgnoreCase))
                {
                    error = "bad-phc";
                    return false;
                }

                int memory = AppConstants.Argon2MemoryKiB;
                int iters = AppConstants.Argon2Iterations;
                int parallel = AppConstants.Argon2Parallelism;
                ParseCost(parts[3], ref memory, ref iters, ref parallel);

                var salt = FromBase64Url(parts[4]);
                var expected = FromBase64Url(parts[5]);
                if (salt == null || salt.Length < 8 || expected == null || expected.Length < 16)
                {
                    error = "bad-salt-or-hash";
                    return false;
                }

                var actual = Derive(Encoding.UTF8.GetBytes(password ?? string.Empty), salt, memory, iters, parallel);
                return FixedEquals(actual, expected);
            }
            catch (Exception ex)
            {
                var inner = Flatten(ex);
                error = inner.GetType().Name + ": " + inner.Message;
                return false;
            }
        }

        static Exception Flatten(Exception ex)
        {
            var agg = ex as AggregateException;
            if (agg != null)
            {
                var list = agg.Flatten().InnerExceptions;
                if (list != null && list.Count > 0)
                    return list[0];
            }
            return ex.InnerException ?? ex;
        }

        static void ParseCost(string spec, ref int memory, ref int iters, ref int parallel)
        {
            if (string.IsNullOrEmpty(spec))
                return;
            var bits = spec.Split(',');
            for (var i = 0; i < bits.Length; i++)
            {
                var kv = bits[i].Trim();
                var eq = kv.IndexOf('=');
                if (eq <= 0)
                    continue;
                var key = kv.Substring(0, eq).Trim();
                int value;
                if (!int.TryParse(kv.Substring(eq + 1).Trim(), out value) || value <= 0)
                    continue;
                if (key == "m")
                    memory = value;
                else if (key == "t")
                    iters = value;
                else if (key == "p")
                    parallel = value;
            }
        }

        public static byte[] DeriveKey(string password, byte[] salt)
        {
            return DeriveKey(
                password,
                salt,
                AppConstants.Argon2MemoryKiB,
                AppConstants.Argon2Iterations,
                AppConstants.Argon2Parallelism);
        }

        /// <summary>اشتقاق کلید با هزینهٔ قابل تنظیم (مثلاً پشتیبان روی x86).</summary>
        public static byte[] DeriveKey(string password, byte[] salt, int memoryKiB, int iterations, int parallelism)
        {
            return Derive(
                Encoding.UTF8.GetBytes(password ?? string.Empty),
                salt,
                memoryKiB,
                iterations,
                parallelism);
        }

        static byte[] Derive(byte[] password, byte[] salt, int memoryKiB, int iterations, int parallelism)
        {
            using (var argon2 = new Argon2id(password))
            {
                argon2.Salt = salt;
                argon2.DegreeOfParallelism = Math.Max(1, parallelism);
                argon2.MemorySize = Math.Max(8, memoryKiB);
                argon2.Iterations = Math.Max(1, iterations);
                return argon2.GetBytes(AppConstants.Argon2HashLength);
            }
        }

        static string ToBase64Url(byte[] data)
        {
            return Convert.ToBase64String(data)
                .TrimEnd('=')
                .Replace('+', '-')
                .Replace('/', '_');
        }

        static byte[] FromBase64Url(string input)
        {
            if (string.IsNullOrEmpty(input))
                return null;
            var s = input.Trim().Replace('-', '+').Replace('_', '/');
            var pad = (4 - s.Length % 4) % 4;
            if (pad > 0)
                s = s + new string('=', pad);
            return Convert.FromBase64String(s);
        }

        static bool FixedEquals(byte[] a, byte[] b)
        {
            if (a == null || b == null || a.Length != b.Length)
                return false;
            var diff = 0;
            for (var i = 0; i < a.Length; i++)
                diff |= a[i] ^ b[i];
            return diff == 0;
        }
    }
}
