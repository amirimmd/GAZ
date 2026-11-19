namespace Qaemshahr.Core
{
    public static class AppConstants
    {
        public const string AppId = "ir.gaz.qaemshahr.hrms";
        public const string MutexName = @"Global\ir.gaz.qaemshahr.hrms";
        public const string AppNameFa = "قائم‌شهر";
        public const string OrganizationNameFa = "سامانه منابع انسانی قائم‌شهر";
        public const string OrganizationNameEn = "Qaemshahr HRMS";
        public const string DbFileName = "gaz_hrms.db";
        public const string EncryptedDocsDir = "secure_documents";
        public const string PhotosDir = "photos";
        public const string BackupsDir = "backups";
        public const string AppVersion = "2.3.12";
        public const int SchemaVersion = 14;
        public const int DefaultSessionTimeoutMinutes = 15;
        public const int DefaultAutoLockMinutes = 5;
        public const int MaxLoginAttempts = 5;
        public const int LockoutMinutes = 1;
        public const int Argon2MemoryKiB = 65536;
        public const int Argon2Iterations = 3;
        public const int Argon2Parallelism = 4;
        public const int Argon2HashLength = 32;
        public const int AesKeyLength = 32;
        public const string DefaultAdminUser = "admin";
        public const string DefaultAdminPassword = "Admin@ChangeMe1";
    }
}
