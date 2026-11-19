using System;
using System.IO;
using Qaemshahr.Core;

namespace Qaemshahr.Data
{
    /// <summary>پاک‌سازی کامل دادهٔ برنامه (نصب: ProgramData / پرتابل: پوشه AppData کنار exe).</summary>
    public static class DataWipeService
    {
        public const string ConfirmPhrase = "پاک کردن همه";

        public static string WipeAllData()
        {
            try
            {
                // پایگاه + WAL/SHM
                DeleteFile(AppPaths.DatabaseFile);
                DeleteFile(AppPaths.DatabaseFile + "-wal");
                DeleteFile(AppPaths.DatabaseFile + "-shm");
                DeleteFile(AppPaths.VersionFile);

                ClearDirectory(AppPaths.DocumentsDirectory);
                ClearDirectory(AppPaths.PhotosDirectory);
                ClearDirectory(AppPaths.KeysDirectory);
                ClearDirectory(AppPaths.BackupsDirectory);
                ClearDirectory(AppPaths.LogsDirectory);

                // نام کاربری ذخیره‌شده روی این ویندوز
                try
                {
                    SecureStore.Delete(AppPaths.RememberUserFile);
                    SecureStore.Delete(AppPaths.RememberPassFile);
                }
                catch
                {
                }

                AppPaths.EnsureDataDirectories();
                return null;
            }
            catch (Exception ex)
            {
                AppLog.Error("Data wipe failed", ex);
                return "پاک‌سازی داده ناموفق بود: " + ex.Message;
            }
        }

        static void DeleteFile(string path)
        {
            if (string.IsNullOrEmpty(path) || !File.Exists(path))
                return;
            File.SetAttributes(path, FileAttributes.Normal);
            File.Delete(path);
        }

        static void ClearDirectory(string dir)
        {
            if (string.IsNullOrEmpty(dir) || !Directory.Exists(dir))
                return;
            foreach (var file in Directory.GetFiles(dir, "*", SearchOption.AllDirectories))
            {
                try
                {
                    File.SetAttributes(file, FileAttributes.Normal);
                    File.Delete(file);
                }
                catch (Exception ex)
                {
                    AppLog.Error("Could not delete " + file, ex);
                    throw;
                }
            }
            foreach (var sub in Directory.GetDirectories(dir))
            {
                try
                {
                    Directory.Delete(sub, true);
                }
                catch (Exception ex)
                {
                    AppLog.Error("Could not delete dir " + sub, ex);
                    throw;
                }
            }
        }
    }
}
