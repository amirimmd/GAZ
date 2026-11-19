using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Security.Cryptography;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Qaemshahr.Core;

namespace Qaemshahr.Data
{
    public static class BackupService
    {
        public const string FormatV2 = "gazbak.v2";
        public const string FormatV3 = "gazbak.v3";
        const string MagicV3 = "GAZBKv3\n";

        // هزینهٔ سبک‌تر برای پشتیبان روی x86 تا با حجم اسناد/عکس OOM نشود
        const int BackupKdfMemoryKiB = 16384;
        const int BackupKdfIterations = 3;
        const int BackupKdfParallelism = 2;

        public static string Create(string password, string outputPath)
        {
            return Create(null, password, outputPath);
        }

        public static string Create(AppDatabase db, string password, string outputPath)
        {
            if (string.IsNullOrEmpty(password) || password.Length < 6)
                return "رمز پشتیبان حداقل ۶ کاراکتر باشد";
            if (!File.Exists(AppPaths.DatabaseFile) && db == null)
                return "فایل پایگاه داده یافت نشد";

            var workDir = Path.Combine(Path.GetTempPath(), "gaz_bak_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(workDir);
            var zipPath = Path.Combine(workDir, "payload.zip");
            var encPath = Path.Combine(workDir, "payload.bin");
            try
            {
                var id = Guid.NewGuid().ToString();
                var salt = new byte[16];
                using (var rng = RandomNumberGenerator.Create())
                    rng.GetBytes(salt);

                // اول کلید — قبل از اشغال حافظه با فایل‌ها
                var wrapKey = PasswordHasher.DeriveKey(
                    password, salt, BackupKdfMemoryKiB, BackupKdfIterations, BackupKdfParallelism);

                byte[] dbBytes;
                try
                {
                    if (db != null)
                        dbBytes = db.ExportConsistentBytes();
                    else
                        dbBytes = ReadShared(AppPaths.DatabaseFile);
                }
                catch (Exception ex)
                {
                    AppLog.Error("Backup database export failed", ex);
                    return "خواندن پایگاه داده برای پشتیبان ناموفق بود: " + ex.Message;
                }

                try
                {
                    BuildZipOnDisk(zipPath, dbBytes);
                }
                catch (OutOfMemoryException ex)
                {
                    AppLog.Error("Backup zip OOM", ex);
                    return "حافظه برای ساخت پشتیبان کافی نیست. برنامه را ببندید و دوباره تلاش کنید.";
                }
                catch (Exception ex)
                {
                    AppLog.Error("Backup zip failed", ex);
                    return "ساخت آرشیو پشتیبان ناموفق بود: " + ex.Message;
                }
                finally
                {
                    dbBytes = null;
                }

                try
                {
                    AesGcmService.EncryptFile(wrapKey, zipPath, encPath, Encoding.UTF8.GetBytes(id));
                }
                catch (OutOfMemoryException ex)
                {
                    AppLog.Error("Backup encrypt OOM", ex);
                    return "حافظه برای رمزنگاری پشتیبان کافی نیست.";
                }
                catch (Exception ex)
                {
                    AppLog.Error("Backup encrypt failed", ex);
                    return "رمزنگاری پشتیبان ناموفق بود: " + ex.Message;
                }

                try
                {
                    if (File.Exists(zipPath))
                        File.Delete(zipPath);
                }
                catch
                {
                }

                var hash = Sha256Util.HexFile(encPath);
                var signature = SignatureService.SignFile(encPath, wrapKey);
                var header = new JObject
                {
                    ["format"] = FormatV3,
                    ["salt"] = SignatureService.ToBase64Url(salt),
                    ["kdf"] = new JObject
                    {
                        ["alg"] = "argon2id",
                        ["m"] = BackupKdfMemoryKiB,
                        ["t"] = BackupKdfIterations,
                        ["p"] = BackupKdfParallelism
                    },
                    ["manifest"] = new JObject
                    {
                        ["id"] = id,
                        ["createdAt"] = DateTime.UtcNow.ToString("o"),
                        ["appVersion"] = AppConstants.AppVersion,
                        ["schemaVersion"] = AppConstants.SchemaVersion,
                        ["contentHash"] = hash,
                        ["signature"] = signature,
                        ["format"] = FormatV3,
                        ["includes"] = new JArray("database", "documents", "photos", "keystore", "settings-in-db")
                    }
                };

                var outDir = Path.GetDirectoryName(outputPath);
                if (!string.IsNullOrEmpty(outDir))
                    Directory.CreateDirectory(outDir);

                WriteV3Package(outputPath, header, encPath);

                try
                {
                    Directory.CreateDirectory(AppPaths.BackupsDirectory);
                    File.Copy(outputPath, Path.Combine(AppPaths.BackupsDirectory, Path.GetFileName(outputPath)), true);
                }
                catch
                {
                }
                return null;
            }
            catch (OutOfMemoryException ex)
            {
                AppLog.Error("Backup Create OOM", ex);
                return "حافظه کافی برای ساخت پشتیبان نیست. چند برنامه را ببندید و دوباره تلاش کنید.";
            }
            catch (Exception ex)
            {
                AppLog.Error("Backup Create failed", ex);
                return "ساخت پشتیبان ناموفق بود: " + ex.Message;
            }
            finally
            {
                try
                {
                    if (Directory.Exists(workDir))
                        Directory.Delete(workDir, true);
                }
                catch
                {
                }
            }
        }

        static void BuildZipOnDisk(string zipPath, byte[] dbBytes)
        {
            using (var fs = new FileStream(zipPath, FileMode.Create, FileAccess.Write, FileShare.None))
            using (var zip = new ZipArchive(fs, ZipArchiveMode.Create, true))
            {
                AddBytes(zip, "database/" + AppConstants.DbFileName, dbBytes);

                if (Directory.Exists(AppPaths.DocumentsDirectory))
                {
                    foreach (var file in Directory.GetFiles(AppPaths.DocumentsDirectory, "*", SearchOption.AllDirectories))
                    {
                        var rel = RelPath(AppPaths.DocumentsDirectory, file);
                        AddPath(zip, "documents/" + rel, file);
                    }
                }
                if (Directory.Exists(AppPaths.PhotosDirectory))
                {
                    foreach (var file in Directory.GetFiles(AppPaths.PhotosDirectory, "*", SearchOption.AllDirectories))
                    {
                        var rel = RelPath(AppPaths.PhotosDirectory, file);
                        AddPath(zip, "photos/" + rel, file);
                    }
                }

                var keys = KeyStore.ExportKeys();
                var map = new Dictionary<string, string>();
                foreach (var e in keys)
                    map[e.Key] = SignatureService.ToBase64Url(e.Value);
                AddBytes(zip, "keystore.json", Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(map)));

                if (File.Exists(AppPaths.VersionFile))
                    AddPath(zip, "version.json", AppPaths.VersionFile);

                var summary = new JObject
                {
                    ["databaseBytes"] = dbBytes == null ? 0 : dbBytes.Length,
                    ["documents"] = CountFiles(AppPaths.DocumentsDirectory),
                    ["photos"] = CountFiles(AppPaths.PhotosDirectory),
                    ["exportedAt"] = DateTime.UtcNow.ToString("o"),
                    ["appVersion"] = AppConstants.AppVersion,
                    ["schemaVersion"] = AppConstants.SchemaVersion
                };
                AddBytes(zip, "manifest-content.json", Encoding.UTF8.GetBytes(summary.ToString(Formatting.None)));
            }
        }

        static void WriteV3Package(string outputPath, JObject header, string encryptedPath)
        {
            var headerBytes = Encoding.UTF8.GetBytes(header.ToString(Formatting.None));
            using (var output = new FileStream(outputPath, FileMode.Create, FileAccess.Write, FileShare.None))
            {
                var magic = Encoding.ASCII.GetBytes(MagicV3);
                output.Write(magic, 0, magic.Length);
                var len = BitConverter.GetBytes(headerBytes.Length);
                if (!BitConverter.IsLittleEndian)
                    Array.Reverse(len);
                output.Write(len, 0, 4);
                output.Write(headerBytes, 0, headerBytes.Length);
                using (var input = new FileStream(encryptedPath, FileMode.Open, FileAccess.Read, FileShare.Read))
                    input.CopyTo(output, 64 * 1024);
            }
        }

        public static string Restore(string backupPath, string password)
        {
            if (!File.Exists(backupPath))
                return "فایل پشتیبان یافت نشد";

            try
            {
                using (var probe = new FileStream(backupPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                {
                    var magicBuf = new byte[8];
                    var n = probe.Read(magicBuf, 0, 8);
                    if (n == 8 && Encoding.ASCII.GetString(magicBuf) == MagicV3)
                        return RestoreV3(backupPath, password);
                }
            }
            catch (Exception ex)
            {
                AppLog.Error("Backup probe failed", ex);
            }

            return RestoreV2(backupPath, password);
        }

        static string RestoreV3(string backupPath, string password)
        {
            var workDir = Path.Combine(Path.GetTempPath(), "gaz_restore_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(workDir);
            var encPath = Path.Combine(workDir, "payload.bin");
            var zipPath = Path.Combine(workDir, "payload.zip");
            try
            {
                JObject header;
                using (var input = new FileStream(backupPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                {
                    var magic = new byte[8];
                    if (input.Read(magic, 0, 8) != 8 || Encoding.ASCII.GetString(magic) != MagicV3)
                        return "قالب پشتیبان نامعتبر است";
                    var lenBuf = new byte[4];
                    if (input.Read(lenBuf, 0, 4) != 4)
                        return "هدر پشتیبان ناقص است";
                    if (!BitConverter.IsLittleEndian)
                        Array.Reverse(lenBuf);
                    var headerLen = BitConverter.ToInt32(lenBuf, 0);
                    if (headerLen <= 0 || headerLen > 8 * 1024 * 1024)
                        return "هدر پشتیبان نامعتبر است";
                    var headerBytes = new byte[headerLen];
                    var read = 0;
                    while (read < headerLen)
                    {
                        var n = input.Read(headerBytes, read, headerLen - read);
                        if (n <= 0)
                            return "هدر پشتیبان ناقص است";
                        read += n;
                    }
                    header = JObject.Parse(Encoding.UTF8.GetString(headerBytes));
                    using (var enc = new FileStream(encPath, FileMode.Create, FileAccess.Write, FileShare.None))
                        input.CopyTo(enc, 64 * 1024);
                }

                if ((string)header["format"] != FormatV3)
                    return "قالب پشتیبان پشتیبانی نمی‌شود";
                var manifest = (JObject)header["manifest"];
                if (manifest == null)
                    return "مانیفست پشتیبان یافت نشد";
                var id = (string)manifest["id"];
                var salt = SignatureService.FromBase64Url((string)header["salt"]);
                var m = BackupKdfMemoryKiB;
                var t = BackupKdfIterations;
                var p = BackupKdfParallelism;
                var kdf = header["kdf"] as JObject;
                if (kdf != null)
                {
                    m = kdf.Value<int?>("m") ?? m;
                    t = kdf.Value<int?>("t") ?? t;
                    p = kdf.Value<int?>("p") ?? p;
                }
                var wrapKey = PasswordHasher.DeriveKey(password, salt, m, t, p);
                var hash = Sha256Util.HexFile(encPath);
                if (!string.Equals(hash, (string)manifest["contentHash"], StringComparison.OrdinalIgnoreCase))
                    return "هش پشتیبان مطابقت ندارد";
                if (!SignatureService.VerifyFile(encPath, wrapKey, (string)manifest["signature"]))
                    return "رمز یا یکپارچگی پشتیبان نامعتبر است";

                try
                {
                    AesGcmService.DecryptFile(wrapKey, encPath, zipPath, Encoding.UTF8.GetBytes(id));
                }
                catch
                {
                    return "رمزگشایی پشتیبان ناموفق بود";
                }

                return ExtractZipToAppData(zipPath);
            }
            catch (OutOfMemoryException ex)
            {
                AppLog.Error("Backup restore V3 OOM", ex);
                return "حافظه برای بازیابی کافی نیست.";
            }
            catch (Exception ex)
            {
                AppLog.Error("Backup restore V3 failed", ex);
                return "بازیابی ناموفق بود: " + ex.Message;
            }
            finally
            {
                try
                {
                    if (Directory.Exists(workDir))
                        Directory.Delete(workDir, true);
                }
                catch
                {
                }
            }
        }

        static string RestoreV2(string backupPath, string password)
        {
            JObject raw;
            try
            {
                raw = JObject.Parse(File.ReadAllText(backupPath, Encoding.UTF8));
            }
            catch
            {
                return "فایل پشتیبان قابل خواندن نیست";
            }
            if ((string)raw["format"] != FormatV2 || raw["salt"] == null)
                return "این فایل با قالب قدیمی ساخته شده و قابل بازیابی نیست.";
            var manifest = (JObject)raw["manifest"];
            var id = (string)manifest["id"];
            var encrypted = SignatureService.FromBase64Url((string)raw["payload"]);
            var salt = SignatureService.FromBase64Url((string)raw["salt"]);
            var wrapKey = PasswordHasher.DeriveKey(password, salt);
            var hash = Sha256Util.Hex(encrypted);
            if (!string.Equals(hash, (string)manifest["contentHash"], StringComparison.OrdinalIgnoreCase))
                return "هش پشتیبان مطابقت ندارد";
            if (!SignatureService.Verify(encrypted, wrapKey, (string)manifest["signature"]))
                return "رمز یا یکپارچگی پشتیبان نامعتبر است";

            byte[] zipBytes;
            try
            {
                zipBytes = AesGcmService.Decrypt(wrapKey, encrypted, Encoding.UTF8.GetBytes(id));
            }
            catch
            {
                return "رمزگشایی پشتیبان ناموفق بود";
            }

            var workDir = Path.Combine(Path.GetTempPath(), "gaz_restore_v2_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(workDir);
            var zipPath = Path.Combine(workDir, "payload.zip");
            try
            {
                File.WriteAllBytes(zipPath, zipBytes);
                zipBytes = null;
                return ExtractZipToAppData(zipPath);
            }
            finally
            {
                try
                {
                    if (Directory.Exists(workDir))
                        Directory.Delete(workDir, true);
                }
                catch
                {
                }
            }
        }

        static string ExtractZipToAppData(string zipPath)
        {
            AppPaths.EnsureDataDirectories();
            Dictionary<string, byte[]> restoredKeys = null;
            var restoredDb = false;
            using (var zip = ZipFile.OpenRead(zipPath))
            {
                foreach (var entry in zip.Entries)
                {
                    if (string.IsNullOrEmpty(entry.Name) && entry.FullName.EndsWith("/"))
                        continue;
                    if (entry.FullName.StartsWith("database/"))
                    {
                        foreach (var extra in new[] { "-wal", "-shm" })
                        {
                            var side = AppPaths.DatabaseFile + extra;
                            try
                            {
                                if (File.Exists(side))
                                    File.Delete(side);
                            }
                            catch
                            {
                            }
                        }
                        entry.ExtractToFile(AppPaths.DatabaseFile, true);
                        restoredDb = true;
                    }
                    else if (entry.FullName.StartsWith("documents/"))
                    {
                        var rel = entry.FullName.Substring("documents/".Length).Replace('/', Path.DirectorySeparatorChar);
                        var dest = Path.Combine(AppPaths.DocumentsDirectory, rel);
                        Directory.CreateDirectory(Path.GetDirectoryName(dest) ?? AppPaths.DocumentsDirectory);
                        entry.ExtractToFile(dest, true);
                    }
                    else if (entry.FullName.StartsWith("photos/"))
                    {
                        var rel = entry.FullName.Substring("photos/".Length).Replace('/', Path.DirectorySeparatorChar);
                        var dest = Path.Combine(AppPaths.PhotosDirectory, rel);
                        Directory.CreateDirectory(Path.GetDirectoryName(dest) ?? AppPaths.PhotosDirectory);
                        entry.ExtractToFile(dest, true);
                    }
                    else if (entry.FullName == "keystore.json")
                    {
                        using (var s = entry.Open())
                        using (var sr = new StreamReader(s, Encoding.UTF8))
                        {
                            var map = JsonConvert.DeserializeObject<Dictionary<string, string>>(sr.ReadToEnd());
                            restoredKeys = new Dictionary<string, byte[]>();
                            if (map != null)
                            {
                                foreach (var e in map)
                                    restoredKeys[e.Key] = SignatureService.FromBase64Url(e.Value);
                            }
                        }
                    }
                    else if (entry.FullName == "version.json")
                    {
                        entry.ExtractToFile(AppPaths.VersionFile, true);
                    }
                }
            }
            if (!restoredDb)
                return "در پشتیبان فایل پایگاه داده یافت نشد";
            if (restoredKeys != null)
                KeyStore.ImportKeys(restoredKeys);
            VersionStore.WriteCurrent();
            return null;
        }

        static int CountFiles(string dir)
        {
            if (!Directory.Exists(dir))
                return 0;
            return Directory.GetFiles(dir, "*", SearchOption.AllDirectories).Length;
        }

        static string RelPath(string root, string file)
        {
            return file.Substring(root.Length)
                .TrimStart(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar)
                .Replace('\\', '/');
        }

        static byte[] ReadShared(string path)
        {
            using (var fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
            using (var ms = new MemoryStream())
            {
                fs.CopyTo(ms);
                return ms.ToArray();
            }
        }

        static void AddBytes(ZipArchive zip, string name, byte[] data)
        {
            var entry = zip.CreateEntry(name, CompressionLevel.Fastest);
            using (var s = entry.Open())
                s.Write(data, 0, data.Length);
        }

        static void AddPath(ZipArchive zip, string name, string path)
        {
            var entry = zip.CreateEntry(name, CompressionLevel.Fastest);
            using (var es = entry.Open())
            using (var fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
                fs.CopyTo(es, 64 * 1024);
        }
    }
}
