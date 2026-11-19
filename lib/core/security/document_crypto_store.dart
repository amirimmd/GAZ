import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import '../errors/failures.dart';
import 'crypto_service.dart';
import 'key_manager.dart';

/// Encrypts employee documents at rest (AES-256-GCM).
class DocumentCryptoStore {
  DocumentCryptoStore();

  Future<Directory> _docsDir() async {
    final support = await getApplicationSupportDirectory();
    final dir = Directory(p.join(support.path, AppConstants.encryptedDocsDir));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<Result<({String storagePath, String contentHash})>> store({
    required String employeeId,
    required String fileName,
    required Uint8List plaintext,
  }) async {
    try {
      final dir = await _docsDir();
      final id = const Uuid().v4();
      final safeName = fileName.replaceAll(RegExp(r'[^\w\.\-]+'), '_');
      final relative = p.join(employeeId, '${id}_$safeName.enc');
      final file = File(p.join(dir.path, relative));
      await file.parent.create(recursive: true);

      final encrypted = AesGcmService.instance.encrypt(
        key: KeyManager.instance.documentKey,
        plaintext: plaintext,
        aad: Uint8List.fromList(utf8.encode(employeeId)),
      );
      await file.writeAsBytes(encrypted, flush: true);
      final hash = SignatureService.instance.sha256Hex(encrypted);
      return Success((storagePath: relative, contentHash: hash));
    } catch (e) {
      return Err(StorageFailure('ذخیره سند ناموفق: $e'));
    }
  }

  Future<Result<Uint8List>> read({
    required String employeeId,
    required String storagePath,
    required String expectedHash,
  }) async {
    try {
      final dir = await _docsDir();
      final file = File(p.join(dir.path, storagePath));
      if (!file.existsSync()) {
        return const Err(NotFoundFailure('فایل سند یافت نشد'));
      }
      final encrypted = await file.readAsBytes();
      final hash = SignatureService.instance.sha256Hex(encrypted);
      if (hash != expectedHash) {
        return const Err(SecurityFailure('یکپارچگی سند نقض شده است'));
      }
      final plain = AesGcmService.instance.decrypt(
        key: KeyManager.instance.documentKey,
        payload: encrypted,
        aad: Uint8List.fromList(utf8.encode(employeeId)),
      );
      return Success(plain);
    } on SecurityFailure catch (e) {
      return Err(e);
    } catch (e) {
      return Err(StorageFailure('خواندن سند ناموفق: $e'));
    }
  }

  Future<Result<void>> deleteFile(String storagePath) async {
    try {
      final dir = await _docsDir();
      final file = File(p.join(dir.path, storagePath));
      if (file.existsSync()) {
        await file.delete();
      }
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('حذف فایل سند ناموفق: $e'));
    }
  }
}
