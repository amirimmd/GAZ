using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using Newtonsoft.Json;
using Qaemshahr.Core;

namespace Qaemshahr.Data
{
    public static class KeyStore
    {
        static byte[] _master;
        static byte[] _dbKey;
        static byte[] _docKey;
        static byte[] _sigKey;

        public static byte[] DocumentKey
        {
            get
            {
                if (_docKey == null)
                    throw new InvalidOperationException("KeyStore not initialized");
                return _docKey;
            }
        }

        public static Dictionary<string, byte[]> ExportKeys()
        {
            Initialize();
            return new Dictionary<string, byte[]>
            {
                { "db", (byte[])_dbKey.Clone() },
                { "doc", (byte[])_docKey.Clone() },
                { "sig", (byte[])_sigKey.Clone() }
            };
        }

        public static void ImportKeys(Dictionary<string, byte[]> map)
        {
            if (map == null)
                return;
            Initialize();
            byte[] v;
            if (map.TryGetValue("db", out v) && v != null) _dbKey = v;
            if (map.TryGetValue("doc", out v) && v != null) _docKey = v;
            if (map.TryGetValue("sig", out v) && v != null) _sigKey = v;
            Persist(new Dictionary<string, byte[]>
            {
                { "db", _dbKey },
                { "doc", _docKey },
                { "sig", _sigKey }
            });
        }

        public static void Initialize()
        {
            AppPaths.EnsureDataDirectories();
            _master = LoadOrCreateMaster();
            var map = LoadKeyMap();
            _dbKey = GetOrCreate(map, "db");
            _docKey = GetOrCreate(map, "doc");
            _sigKey = GetOrCreate(map, "sig");
            Persist(new Dictionary<string, byte[]>
            {
                { "db", _dbKey },
                { "doc", _docKey },
                { "sig", _sigKey }
            });
        }

        static byte[] GetOrCreate(Dictionary<string, byte[]> map, string key)
        {
            byte[] existing;
            if (map != null && map.TryGetValue(key, out existing) && existing != null)
                return existing;
            return RandomBytes(AppConstants.AesKeyLength);
        }

        static byte[] LoadOrCreateMaster()
        {
            if (!File.Exists(AppPaths.InstallSecretFile))
            {
                var secret = RandomBytes(32);
                File.WriteAllBytes(AppPaths.InstallSecretFile, secret);
                return secret;
            }
            return File.ReadAllBytes(AppPaths.InstallSecretFile);
        }

        static Dictionary<string, byte[]> LoadKeyMap()
        {
            try
            {
                if (!File.Exists(AppPaths.KeystoreFile) || _master == null)
                    return new Dictionary<string, byte[]>();
                var payload = File.ReadAllBytes(AppPaths.KeystoreFile);
                var plain = AesGcmService.Decrypt(_master, payload);
                var json = Encoding.UTF8.GetString(plain);
                var raw = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
                var map = new Dictionary<string, byte[]>();
                if (raw == null)
                    return map;
                foreach (var e in raw)
                    map[e.Key] = FromBase64Url(e.Value);
                return map;
            }
            catch (Exception ex)
            {
                AppLog.Error("Keystore load failed; generating new keys", ex);
                return new Dictionary<string, byte[]>();
            }
        }

        static void Persist(Dictionary<string, byte[]> map)
        {
            var jsonMap = new Dictionary<string, string>();
            foreach (var e in map)
                jsonMap[e.Key] = ToBase64Url(e.Value);
            var plain = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(jsonMap));
            var encrypted = AesGcmService.Encrypt(_master, plain);
            File.WriteAllBytes(AppPaths.KeystoreFile, encrypted);
        }

        static byte[] RandomBytes(int n)
        {
            var b = new byte[n];
            using (var rng = RandomNumberGenerator.Create())
                rng.GetBytes(b);
            return b;
        }

        static string ToBase64Url(byte[] data)
        {
            return Convert.ToBase64String(data).TrimEnd('=').Replace('+', '-').Replace('/', '_');
        }

        static byte[] FromBase64Url(string input)
        {
            var s = input.Replace('-', '+').Replace('_', '/');
            var pad = (4 - s.Length % 4) % 4;
            if (pad > 0)
                s = s + new string('=', pad);
            return Convert.FromBase64String(s);
        }
    }
}
