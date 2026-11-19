import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import 'crypto_service.dart';

/// Secure key lifecycle.
///
/// Uses an AES-GCM protected keystore file under Application Support
/// (avoids flutter_secure_storage Windows ATL dependency).
class KeyManager {
  KeyManager._();
  static final KeyManager instance = KeyManager._();

  static const _keystoreFile = 'gaz_hrms_keystore.v1';

  Uint8List? _dbKey;
  Uint8List? _docKey;
  Uint8List? _sigKey;
  Uint8List? _master;

  Uint8List get databaseKey {
    final k = _dbKey;
    if (k == null) throw StateError('KeyManager not initialized');
    return k;
  }

  Uint8List get documentKey {
    final k = _docKey;
    if (k == null) throw StateError('KeyManager not initialized');
    return k;
  }

  Uint8List get signatureKey {
    final k = _sigKey;
    if (k == null) throw StateError('KeyManager not initialized');
    return k;
  }

  Future<void> initialize() async {
    _master = await _loadOrCreateMaster();
    final map = await _loadKeyMap();
    _dbKey = map['db'] ?? _randomBytes(AppConstants.aesKeyLength);
    _docKey = map['doc'] ?? _randomBytes(AppConstants.aesKeyLength);
    _sigKey = map['sig'] ?? _randomBytes(AppConstants.aesKeyLength);
    await _persistKeyMap({
      'db': _dbKey!,
      'doc': _docKey!,
      'sig': _sigKey!,
    });
  }

  String databaseKeyHex() {
    return databaseKey.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Map<String, Uint8List> exportKeys() => {
        'db': Uint8List.fromList(databaseKey),
        'doc': Uint8List.fromList(documentKey),
        'sig': Uint8List.fromList(signatureKey),
      };

  Future<void> importKeys(Map<String, Uint8List> map) async {
    _dbKey = map['db'] ?? _dbKey;
    _docKey = map['doc'] ?? _docKey;
    _sigKey = map['sig'] ?? _sigKey;
    await _persistKeyMap({
      'db': _dbKey!,
      'doc': _docKey!,
      'sig': _sigKey!,
    });
  }

  Future<File> _keystorePath() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, _keystoreFile));
  }

  /// Machine-local wrapping key derived from a install-local secret file.
  Future<Uint8List> _loadOrCreateMaster() async {
    final dir = await getApplicationSupportDirectory();
    final secretFile = File(p.join(dir.path, 'gaz_hrms_install.secret'));
    if (!secretFile.existsSync()) {
      final secret = _randomBytes(32);
      await secretFile.parent.create(recursive: true);
      await secretFile.writeAsBytes(secret, flush: true);
      if (!Platform.isWindows) {
        await Process.run('chmod', ['600', secretFile.path]);
      }
      return secret;
    }
    return await secretFile.readAsBytes();
  }

  Future<Map<String, Uint8List>> _loadKeyMap() async {
    final file = await _keystorePath();
    if (!file.existsSync()) return {};
    try {
      final payload = await file.readAsBytes();
      final plain = AesGcmService.instance.decrypt(
        key: _master!,
        payload: payload,
      );
      final json = jsonDecode(utf8.decode(plain)) as Map<String, dynamic>;
      return {
        for (final e in json.entries)
          e.key: base64Url.decode(e.value as String),
      };
    } catch (_) {
      return {};
    }
  }

  Future<void> _persistKeyMap(Map<String, Uint8List> map) async {
    final file = await _keystorePath();
    final json = {
      for (final e in map.entries) e.key: base64Url.encode(e.value),
    };
    final plain = Uint8List.fromList(utf8.encode(jsonEncode(json)));
    final encrypted = AesGcmService.instance.encrypt(
      key: _master!,
      plaintext: plain,
    );
    await file.writeAsBytes(encrypted, flush: true);
  }

  Uint8List _randomBytes(int length) {
    final r = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => r.nextInt(256)));
  }
}
