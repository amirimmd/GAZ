/// Global application constants — Gas Company Qaemshahr HRMS.
abstract final class AppConstants {
  static const String appId = 'ir.gaz.qaemshahr.hrms';
  static const String appNameFa = 'قائم‌شهر';
  static const String appNameEn = 'Qaemshahr';
  static const String organizationNameFa = 'سامانه منابع انسانی قائم‌شهر';
  static const String organizationNameEn = 'Qaemshahr HRMS';
  static const String organizationLogoAsset =
      'assets/logo/organization_logo.png';
  static const String dbFileName = 'gaz_hrms.db';
  static const String encryptedDocsDir = 'secure_documents';
  static const String photosDir = 'photos';
  static const String backupsDir = 'backups';
  /// Align with Win7 feature line for backup/restore messaging.
  static const String appVersion = '2.1.0';
  /// Must match Win7 `AppConstants.SchemaVersion` for .gazbak restore.
  static const int schemaVersion = 12;
  static const int defaultSessionTimeoutMinutes = 15;
  static const int defaultAutoLockMinutes = 5;
  static const int maxLoginAttempts = 5;
  static const int lockoutMinutes = 15;
  static const int argon2MemoryKiB = 65536;
  static const int argon2Iterations = 3;
  static const int argon2Parallelism = 4;
  static const int argon2HashLength = 32;
  static const int aesKeyLength = 32;
}
