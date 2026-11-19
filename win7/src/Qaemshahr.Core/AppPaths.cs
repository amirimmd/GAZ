using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Qaemshahr.Core
{
    /// <summary>
    /// نصب عادی: داده در ProgramData.
    /// پرتابل: وجود portable.flag کنار exe → داده در پوشه AppData کنار برنامه.
    /// </summary>
    public static class AppPaths
    {
        const string PortableMarker = "portable.flag";
        const string PortableDataFolder = "AppData";

        static readonly Lazy<bool> PortableLazy = new Lazy<bool>(DetectPortable);
        static string _toolInstall;
        static bool? _toolPortable;

        /// <summary>برای ابزارهای seed/تست: ریشه نصب پرتابل (پوشهٔ حاوی portable.flag).</summary>
        public static void ConfigureForTool(string installDirectory)
        {
            if (string.IsNullOrWhiteSpace(installDirectory))
                throw new ArgumentException("مسیر نصب خالی است.", "installDirectory");
            _toolInstall = Path.GetFullPath(installDirectory.Trim());
            _toolPortable = File.Exists(Path.Combine(_toolInstall, PortableMarker));
        }

        public static bool IsPortable
        {
            get { return _toolPortable ?? PortableLazy.Value; }
        }

        public static string InstallDirectory
        {
            get
            {
                if (!string.IsNullOrEmpty(_toolInstall))
                    return _toolInstall;
                var exe = System.Reflection.Assembly.GetEntryAssembly();
                return exe != null
                    ? Path.GetDirectoryName(exe.Location)
                    : AppDomain.CurrentDomain.BaseDirectory;
            }
        }

        public static string DataRoot
        {
            get
            {
                if (IsPortable)
                    return Path.Combine(InstallDirectory, PortableDataFolder);
                return Path.Combine(
                    Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData),
                    "GAZ",
                    "Qaemshahr");
            }
        }

        public static string DataDirectory => Path.Combine(DataRoot, "data");
        public static string DocumentsDirectory => Path.Combine(DataRoot, AppConstants.EncryptedDocsDir);
        public static string PhotosDirectory => Path.Combine(DataRoot, AppConstants.PhotosDir);
        public static string KeysDirectory => Path.Combine(DataRoot, "keys");
        public static string LogsDirectory => Path.Combine(DataRoot, "logs");
        public static string BackupsDirectory => Path.Combine(DataRoot, AppConstants.BackupsDir);
        public static string DatabaseFile => Path.Combine(DataDirectory, AppConstants.DbFileName);
        public static string VersionFile => Path.Combine(DataRoot, "version.json");
        public static string KeystoreFile => Path.Combine(KeysDirectory, "gaz_hrms_keystore.v1");
        public static string InstallSecretFile => Path.Combine(KeysDirectory, "gaz_hrms_install.secret");
        public static string LogFile => Path.Combine(LogsDirectory, "app.log");

        /// <summary>یادآوری ورود؛ در پرتابل داخل همان AppData تا با فلش جابه‌جا شود.</summary>
        public static string LocalStateDirectory
        {
            get
            {
                if (IsPortable)
                    return Path.Combine(DataRoot, "local");
                return Path.Combine(
                    Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                    "GAZ",
                    "Qaemshahr");
            }
        }

        public static string RememberUserFile => Path.Combine(LocalStateDirectory, "remember_user.bin");
        public static string RememberPassFile => Path.Combine(LocalStateDirectory, "remember_pass.bin");

        /// <summary>Mutex جدا برای هر مسیر پرتابل تا با نصب ثابت تداخل نکند.</summary>
        public static string InstanceMutexName
        {
            get
            {
                if (!IsPortable)
                    return AppConstants.MutexName;
                var id = ShortHash(InstallDirectory ?? string.Empty);
                return AppConstants.MutexName + ".p." + id;
            }
        }

        public static void EnsureDataDirectories()
        {
            Directory.CreateDirectory(DataDirectory);
            Directory.CreateDirectory(DocumentsDirectory);
            Directory.CreateDirectory(PhotosDirectory);
            Directory.CreateDirectory(KeysDirectory);
            Directory.CreateDirectory(LogsDirectory);
            Directory.CreateDirectory(BackupsDirectory);
            Directory.CreateDirectory(LocalStateDirectory);
        }

        static bool DetectPortable()
        {
            try
            {
                var marker = Path.Combine(InstallDirectory, PortableMarker);
                return File.Exists(marker);
            }
            catch
            {
                return false;
            }
        }

        static string ShortHash(string text)
        {
            using (var sha = SHA256.Create())
            {
                var bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(text.ToLowerInvariant()));
                var sb = new StringBuilder(16);
                for (var i = 0; i < 8; i++)
                    sb.Append(bytes[i].ToString("x2"));
                return sb.ToString();
            }
        }
    }
}
