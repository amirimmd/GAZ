using System;
using System.Collections.Generic;
using System.IO;
using Qaemshahr.Core;

namespace Qaemshahr.Data
{
    public static class FlutterImporter
    {
        public static string FindLegacyDatabase()
        {
            var roaming = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
            var local = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            var candidates = new[]
            {
                Path.Combine(roaming, "ir.gaz.qaemshahr", "قائم‌شهر", AppConstants.DbFileName),
                Path.Combine(roaming, "ir.gaz.qaemshahr.hrms", AppConstants.DbFileName),
                Path.Combine(roaming, "ir.gaz.qaemshahr", AppConstants.DbFileName),
                Path.Combine(local, "ir.gaz.qaemshahr", "قائم‌شهر", AppConstants.DbFileName),
                Path.Combine(local, "ir.gaz.qaemshahr.hrms", AppConstants.DbFileName)
            };
            foreach (var path in candidates)
            {
                if (File.Exists(path))
                    return path;
            }

            try
            {
                foreach (var dir in Directory.GetDirectories(roaming, "*gaz*", SearchOption.TopDirectoryOnly))
                {
                    var nested = Path.Combine(dir, AppConstants.DbFileName);
                    if (File.Exists(nested))
                        return nested;
                    foreach (var inner in Directory.GetDirectories(dir))
                    {
                        var db = Path.Combine(inner, AppConstants.DbFileName);
                        if (File.Exists(db))
                            return db;
                    }
                }
            }
            catch
            {
            }

            return null;
        }

        public static void ImportFrom(string legacyDbPath)
        {
            if (string.IsNullOrEmpty(legacyDbPath) || !File.Exists(legacyDbPath))
                return;
            AppPaths.EnsureDataDirectories();
            CopySidecar(legacyDbPath, AppPaths.DatabaseFile);
            var srcDir = Path.GetDirectoryName(legacyDbPath);
            CopyDirIfExists(Path.Combine(srcDir, AppConstants.EncryptedDocsDir), AppPaths.DocumentsDirectory);
            CopyDirIfExists(Path.Combine(srcDir, AppConstants.PhotosDir), AppPaths.PhotosDirectory);
            CopyIfExists(Path.Combine(srcDir, "gaz_hrms_keystore.v1"), AppPaths.KeystoreFile);
            CopyIfExists(Path.Combine(srcDir, "gaz_hrms_install.secret"), AppPaths.InstallSecretFile);
            AppLog.Info("Imported Flutter data from " + legacyDbPath);
        }

        static void CopySidecar(string srcDb, string destDb)
        {
            File.Copy(srcDb, destDb, true);
            CopyIfExists(srcDb + "-wal", destDb + "-wal");
            CopyIfExists(srcDb + "-shm", destDb + "-shm");
        }

        static void CopyIfExists(string src, string dest)
        {
            if (!File.Exists(src))
                return;
            Directory.CreateDirectory(Path.GetDirectoryName(dest));
            File.Copy(src, dest, true);
        }

        static void CopyDirIfExists(string src, string dest)
        {
            if (!Directory.Exists(src))
                return;
            Directory.CreateDirectory(dest);
            foreach (var file in Directory.GetFiles(src, "*", SearchOption.AllDirectories))
            {
                var rel = file.Substring(src.Length).TrimStart(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
                var target = Path.Combine(dest, rel);
                Directory.CreateDirectory(Path.GetDirectoryName(target));
                File.Copy(file, target, true);
            }
        }
    }
}
