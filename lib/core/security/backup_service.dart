import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import '../errors/failures.dart';
import 'crypto_service.dart';
import 'key_manager.dart';
import 'photo_store.dart';

class BackupManifest {
  BackupManifest({
    required this.id,
    required this.createdAt,
    required this.appVersion,
    required this.schemaVersion,
    required this.contentHash,
    required this.signature,
    this.format = formatV2,
  });

  static const formatV2 = 'gazbak.v2';

  final String id;
  final DateTime createdAt;
  final String appVersion;
  final int schemaVersion;
  final String contentHash;
  final String signature;
  final String format;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'appVersion': appVersion,
        'schemaVersion': schemaVersion,
        'contentHash': contentHash,
        'signature': signature,
        'format': format,
      };

  factory BackupManifest.fromJson(Map<String, dynamic> json) => BackupManifest(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        appVersion: json['appVersion'] as String,
        schemaVersion: json['schemaVersion'] as int,
        contentHash: json['contentHash'] as String,
        signature: json['signature'] as String,
        format: json['format'] as String? ?? 'legacy',
      );
}

/// Encrypted, compressed, signed backup / restore — Win7-compatible gazbak.v2.
class BackupService {
  BackupService({
    Future<Map<String, Uint8List>> Function()? exportKeys,
    Future<void> Function(Map<String, Uint8List> keys)? importKeys,
  })  : _exportKeys = exportKeys ?? (() async => KeyManager.instance.exportKeys()),
        _importKeys = importKeys ??
            ((keys) => KeyManager.instance.importKeys(keys));

  final Future<Map<String, Uint8List>> Function() _exportKeys;
  final Future<void> Function(Map<String, Uint8List> keys) _importKeys;

  Future<Directory> backupsDir() async {
    final support = await getApplicationSupportDirectory();
    final dir = Directory(p.join(support.path, AppConstants.backupsDir));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<Directory> visibleBackupsDir() async {
    final downloads = await getDownloadsDirectory();
    final root = downloads ?? await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, 'GAZ_HRMS_Backups'));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<Result<File>> createBackup({
    required File databaseFile,
    required Directory documentsDir,
    required String password,
    Directory? photosDir,
    File? outputFile,
  }) async {
    try {
      if (!databaseFile.existsSync()) {
        return const Err(StorageFailure('فایل پایگاه داده یافت نشد'));
      }
      if (password.length < 6) {
        return const Err(ValidationFailure('رمز پشتیبان حداقل ۶ کاراکتر باشد'));
      }
      final id = const Uuid().v4();
      final archive = Archive();
      archive.addFile(
        ArchiveFile(
          'database/${AppConstants.dbFileName}',
          databaseFile.lengthSync(),
          await databaseFile.readAsBytes(),
        ),
      );

      Future<void> addTree(Directory dir, String zipPrefix) async {
        if (!dir.existsSync()) return;
        await for (final entity in dir.list(recursive: true)) {
          if (entity is! File) continue;
          final relative = p.relative(entity.path, from: dir.path);
          final bytes = await entity.readAsBytes();
          final name = '$zipPrefix/${relative.replaceAll('\\', '/')}';
          archive.addFile(ArchiveFile(name, bytes.length, bytes));
        }
      }

      await addTree(documentsDir, 'documents');
      final photos = photosDir ?? await PhotoStore.rootDir();
      await addTree(photos, 'photos');

      final keys = await _exportKeys();
      final keyJson = utf8.encode(
        jsonEncode({
          for (final e in keys.entries) e.key: base64Url.encode(e.value),
        }),
      );
      archive.addFile(ArchiveFile('keystore.json', keyJson.length, keyJson));

      final summary = utf8.encode(
        jsonEncode({
          'databaseBytes': databaseFile.lengthSync(),
          'documents': documentsDir.existsSync()
              ? documentsDir.listSync(recursive: true).whereType<File>().length
              : 0,
          'photos': photos.existsSync()
              ? photos.listSync(recursive: true).whereType<File>().length
              : 0,
          'exportedAt': DateTime.now().toUtc().toIso8601String(),
          'appVersion': AppConstants.appVersion,
          'schemaVersion': AppConstants.schemaVersion,
        }),
      );
      archive.addFile(
        ArchiveFile('manifest-content.json', summary.length, summary),
      );

      final zipBytes = Uint8List.fromList(ZipEncoder().encode(archive)!);
      final salt = _randomBytes(16);
      final wrapKey = PasswordHasher.instance.deriveKey(password, salt);
      final encrypted = AesGcmService.instance.encrypt(
        key: wrapKey,
        plaintext: zipBytes,
        aad: utf8.encode(id),
      );

      final hash = SignatureService.instance.sha256Hex(encrypted);
      final signature = SignatureService.instance.sign(encrypted, wrapKey);
      final manifest = BackupManifest(
        id: id,
        createdAt: DateTime.now().toUtc(),
        appVersion: AppConstants.appVersion,
        schemaVersion: AppConstants.schemaVersion,
        contentHash: hash,
        signature: signature,
      );

      final package = utf8.encode(
        jsonEncode({
          'format': BackupManifest.formatV2,
          'salt': base64Url.encode(salt),
          'manifest': manifest.toJson(),
          'payload': base64Url.encode(encrypted),
        }),
      );

      final name =
          'gaz_backup_${manifest.createdAt.millisecondsSinceEpoch}.gazbak';
      final File primary;
      if (outputFile != null) {
        primary = outputFile;
      } else {
        final visible = await visibleBackupsDir();
        primary = File(p.join(visible.path, name));
      }
      await primary.parent.create(recursive: true);
      await primary.writeAsBytes(package, flush: true);
      if (outputFile == null) {
        final copy = File(p.join((await backupsDir()).path, name));
        if (copy.path != primary.path) {
          await copy.writeAsBytes(package, flush: true);
        }
      }
      return Success(primary);
    } catch (e) {
      return Err(StorageFailure('پشتیبان‌گیری ناموفق: $e'));
    }
  }

  Future<Result<void>> restoreBackup({
    required File backupFile,
    required String password,
    required File targetDb,
    required Directory targetDocs,
    Directory? targetPhotos,
    bool applyKeys = true,
  }) async {
    try {
      final raw =
          jsonDecode(await backupFile.readAsString()) as Map<String, dynamic>;
      final format = raw['format'] as String?;
      if (format != BackupManifest.formatV2 || raw['salt'] == null) {
        return const Err(
          SecurityFailure(
            'این فایل با قالب قدیمی ساخته شده و روی دستگاه دیگر قابل بازیابی نیست. یک پشتیبان جدید بگیرید.',
          ),
        );
      }

      final manifest =
          BackupManifest.fromJson(raw['manifest'] as Map<String, dynamic>);
      if (manifest.schemaVersion > AppConstants.schemaVersion) {
        return Err(
          SecurityFailure(
            'این پشتیبان با ساختار پایگاه ${manifest.schemaVersion} ساخته شده '
            'که از نسخهٔ فعلی برنامه (${AppConstants.schemaVersion}) جدیدتر است. '
            'برنامه را به‌روز کنید.',
          ),
        );
      }

      final encrypted = base64Url.decode(raw['payload'] as String);
      final salt = base64Url.decode(raw['salt'] as String);
      final wrapKey = PasswordHasher.instance.deriveKey(password, salt);

      final hash = SignatureService.instance.sha256Hex(encrypted);
      if (hash != manifest.contentHash) {
        return const Err(SecurityFailure('هش پشتیبان مطابقت ندارد'));
      }
      if (!SignatureService.instance.verify(
        encrypted,
        wrapKey,
        manifest.signature,
      )) {
        return const Err(SecurityFailure('رمز یا یکپارچگی پشتیبان نامعتبر است'));
      }

      final zipBytes = AesGcmService.instance.decrypt(
        key: wrapKey,
        payload: encrypted,
        aad: utf8.encode(manifest.id),
      );

      final archive = ZipDecoder().decodeBytes(zipBytes);
      Map<String, Uint8List>? restoredKeys;
      var restoredDb = false;
      final photosRoot = targetPhotos ?? await PhotoStore.rootDir();

      for (final file in archive.files) {
        if (!file.isFile) continue;
        final content = Uint8List.fromList(file.content as List<int>);
        if (file.name.startsWith('database/')) {
          await targetDb.parent.create(recursive: true);
          for (final extra in ['-wal', '-shm']) {
            final side = File('${targetDb.path}$extra');
            if (side.existsSync()) await side.delete();
          }
          await targetDb.writeAsBytes(content, flush: true);
          restoredDb = true;
        } else if (file.name.startsWith('documents/')) {
          final rel = file.name.substring('documents/'.length);
          final out = File(p.join(targetDocs.path, rel));
          await out.parent.create(recursive: true);
          await out.writeAsBytes(content, flush: true);
        } else if (file.name.startsWith('photos/')) {
          final rel = file.name.substring('photos/'.length);
          final out = File(p.join(photosRoot.path, rel));
          await out.parent.create(recursive: true);
          await out.writeAsBytes(content, flush: true);
        } else if (file.name == 'keystore.json') {
          final map = jsonDecode(utf8.decode(content)) as Map<String, dynamic>;
          restoredKeys = {
            for (final e in map.entries)
              e.key: base64Url.decode(e.value as String),
          };
        }
      }
      if (!restoredDb) {
        return const Err(StorageFailure('در پشتیبان فایل پایگاه داده یافت نشد'));
      }
      if (applyKeys && restoredKeys != null) {
        await _importKeys(restoredKeys);
      }
      return const Success(null);
    } on SecurityFailure catch (e) {
      return Err(e);
    } catch (e) {
      return Err(StorageFailure('بازیابی ناموفق: $e'));
    }
  }

  Uint8List _randomBytes(int length) {
    final r = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => r.nextInt(256)));
  }
}
