using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Qaemshahr.Core
{
    /// <summary>
    /// ذخیرهٔ محافظت‌شدهٔ نام کاربری و رمز ورود یادآوری‌شده.
    /// پرتابل: AES-GCM با کلید نصب در AppData.
    /// نصب عادی: AES-GCM به‌همراه DPAPI (CurrentUser).
    /// </summary>
    public static class SecureStore
    {
        static readonly byte[] Entropy = Encoding.UTF8.GetBytes(AppConstants.AppId + "|dpapi");
        static readonly byte[] Magic = Encoding.ASCII.GetBytes("GZRM1");
        static readonly byte[] Aad = Encoding.UTF8.GetBytes(AppConstants.AppId + "|remember.v1");

        public static void WriteProtected(string path, string plaintext)
        {
            var dir = Path.GetDirectoryName(path);
            if (!string.IsNullOrEmpty(dir))
                Directory.CreateDirectory(dir);

            try
            {
                var plain = Encoding.UTF8.GetBytes(plaintext ?? string.Empty);
                var key = GetVaultKey();
                var encrypted = AesGcmService.Encrypt(key, plain, Aad);
                byte[] body;
                if (AppPaths.IsPortable)
                {
                    body = encrypted;
                }
                else
                {
                    body = ProtectedData.Protect(encrypted, Entropy, DataProtectionScope.CurrentUser);
                }

                var payload = new byte[Magic.Length + body.Length];
                Buffer.BlockCopy(Magic, 0, payload, 0, Magic.Length);
                Buffer.BlockCopy(body, 0, payload, Magic.Length, body.Length);
                File.WriteAllBytes(path, payload);
                AppLog.Info("SecureStore wrote " + Path.GetFileName(path));
            }
            catch (Exception ex)
            {
                AppLog.Error("SecureStore write failed: " + path, ex);
                throw;
            }
        }

        public static string ReadProtected(string path)
        {
            if (!File.Exists(path))
                return null;
            try
            {
                var raw = File.ReadAllBytes(path);
                if (raw.Length == 0)
                    return null;

                if (HasMagic(raw))
                {
                    var body = new byte[raw.Length - Magic.Length];
                    Buffer.BlockCopy(raw, Magic.Length, body, 0, body.Length);
                    byte[] encrypted;
                    if (AppPaths.IsPortable)
                    {
                        encrypted = body;
                    }
                    else
                    {
                        encrypted = ProtectedData.Unprotect(body, Entropy, DataProtectionScope.CurrentUser);
                    }
                    var plain = AesGcmService.Decrypt(GetVaultKey(), encrypted, Aad);
                    return Encoding.UTF8.GetString(plain);
                }

                // مهاجرت از قالب قدیمی (متن ساده / فقط DPAPI)
                string legacy = null;
                if (LooksLikePlainText(raw))
                {
                    legacy = Encoding.UTF8.GetString(raw).Trim().TrimStart('\uFEFF');
                }
                else if (!AppPaths.IsPortable)
                {
                    try
                    {
                        var bytes = ProtectedData.Unprotect(raw, Entropy, DataProtectionScope.CurrentUser);
                        legacy = Encoding.UTF8.GetString(bytes);
                    }
                    catch
                    {
                        legacy = null;
                    }
                }

                if (string.IsNullOrEmpty(legacy))
                {
                    AppLog.Error("SecureStore: unreadable credential file deleted: " + Path.GetFileName(path));
                    try { File.Delete(path); } catch { }
                    return null;
                }

                try { WriteProtected(path, legacy); }
                catch (Exception ex) { AppLog.Error("SecureStore migrate failed", ex); }
                return legacy;
            }
            catch (Exception ex)
            {
                AppLog.Error("SecureStore read failed", ex);
                try { File.Delete(path); } catch { }
                return null;
            }
        }

        public static void Delete(string path)
        {
            if (string.IsNullOrEmpty(path) || !File.Exists(path))
                return;
            try { File.Delete(path); } catch { }
        }

        static bool HasMagic(byte[] raw)
        {
            if (raw == null || raw.Length < Magic.Length + 16)
                return false;
            for (var i = 0; i < Magic.Length; i++)
            {
                if (raw[i] != Magic[i])
                    return false;
            }
            return true;
        }

        static byte[] GetVaultKey()
        {
            AppPaths.EnsureDataDirectories();
            byte[] secret;
            if (!File.Exists(AppPaths.InstallSecretFile))
            {
                secret = new byte[32];
                using (var rng = RandomNumberGenerator.Create())
                    rng.GetBytes(secret);
                File.WriteAllBytes(AppPaths.InstallSecretFile, secret);
            }
            else
            {
                secret = File.ReadAllBytes(AppPaths.InstallSecretFile);
            }

            if (secret == null || secret.Length < 16)
                throw new CryptographicException("کلید نصب نامعتبر است");

            // کلید جدا برای remember تا با کلید اسناد قاطی نشود
            using (var sha = SHA256.Create())
            {
                var domain = Encoding.UTF8.GetBytes(AppConstants.AppId + "|remember-vault|v1");
                var buf = new byte[secret.Length + domain.Length];
                Buffer.BlockCopy(secret, 0, buf, 0, secret.Length);
                Buffer.BlockCopy(domain, 0, buf, secret.Length, domain.Length);
                return sha.ComputeHash(buf);
            }
        }

        static bool LooksLikePlainText(byte[] raw)
        {
            if (raw == null || raw.Length == 0 || raw.Length > 512)
                return false;
            foreach (var b in raw)
            {
                if (b < 32 && b != 9 && b != 10 && b != 13)
                    return false;
            }
            return true;
        }
    }
}
