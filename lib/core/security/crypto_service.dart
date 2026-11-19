import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:pointycastle/export.dart';

import '../constants/app_constants.dart';
import '../errors/failures.dart';

/// Argon2id password hashing (PointyCastle) for offline enterprise auth.
class PasswordHasher {
  PasswordHasher._();
  static final PasswordHasher instance = PasswordHasher._();

  static const int _saltLength = 16;

  /// Raw Argon2id key (32 bytes) for backup wrapping.
  Uint8List deriveKey(String password, Uint8List salt) {
    return _argon2id(password: utf8.encode(password), salt: salt);
  }

  /// Returns PHC-style encoded string: `$argon2id$v=19$m=...,t=...,p=...$salt$hash`
  String hashPassword(String password, {Uint8List? salt}) {
    final s = salt ?? _randomBytes(_saltLength);
    final hash = _argon2id(
      password: utf8.encode(password),
      salt: s,
    );
    final saltB64 = base64Url.encode(s).replaceAll('=', '');
    final hashB64 = base64Url.encode(hash).replaceAll('=', '');
    return '\$argon2id\$v=19\$m=${AppConstants.argon2MemoryKiB},'
        't=${AppConstants.argon2Iterations},p=${AppConstants.argon2Parallelism}'
        '\$$saltB64\$$hashB64';
  }

  bool verifyPassword(String password, String encoded) {
    try {
      final parts = encoded.split('\$');
      // ['', 'argon2id', 'v=19', 'm=...,t=...,p=...', 'salt', 'hash']
      if (parts.length < 6 || parts[1] != 'argon2id') return false;
      final salt = _padBase64(parts[4]);
      final expected = _padBase64(parts[5]);
      final actual = _argon2id(
        password: utf8.encode(password),
        salt: base64Url.decode(salt),
      );
      return _constantTimeEquals(actual, base64Url.decode(expected));
    } catch (_) {
      return false;
    }
  }

  Uint8List _argon2id({
    required List<int> password,
    required Uint8List salt,
  }) {
    final gen = Argon2BytesGenerator();
    final params = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      salt,
      desiredKeyLength: AppConstants.argon2HashLength,
      memory: AppConstants.argon2MemoryKiB,
      iterations: AppConstants.argon2Iterations,
      lanes: AppConstants.argon2Parallelism,
      version: Argon2Parameters.ARGON2_VERSION_13,
    );
    gen.init(params);
    final out = Uint8List(AppConstants.argon2HashLength);
    gen.deriveKey(Uint8List.fromList(password), 0, out, 0);
    return out;
  }

  Uint8List _randomBytes(int length) {
    final r = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => r.nextInt(256)));
  }

  String _padBase64(String input) {
    final pad = (4 - input.length % 4) % 4;
    return input + ('=' * pad);
  }

  bool _constantTimeEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}

/// AES-256-GCM encryption for documents and backup payloads.
class AesGcmService {
  AesGcmService._();
  static final AesGcmService instance = AesGcmService._();

  static const int nonceLength = 12;

  Uint8List encrypt({
    required Uint8List key,
    required Uint8List plaintext,
    Uint8List? aad,
  }) {
    if (key.length != AppConstants.aesKeyLength) {
      throw const SecurityFailure('طول کلید AES نامعتبر است');
    }
    final nonce = _randomBytes(nonceLength);
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(KeyParameter(key), 128, nonce, aad ?? Uint8List(0)),
      );
    final cipherText = cipher.process(plaintext);
    // nonce || ciphertext+tag
    return Uint8List.fromList([...nonce, ...cipherText]);
  }

  Uint8List decrypt({
    required Uint8List key,
    required Uint8List payload,
    Uint8List? aad,
  }) {
    if (payload.length < nonceLength + 16) {
      throw const SecurityFailure('داده رمزنگاری‌شده نامعتبر است');
    }
    final nonce = payload.sublist(0, nonceLength);
    final cipherText = payload.sublist(nonceLength);
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(KeyParameter(key), 128, nonce, aad ?? Uint8List(0)),
      );
    try {
      return cipher.process(cipherText);
    } catch (_) {
      throw const SecurityFailure('رمزگشایی ناموفق — داده دستکاری شده است');
    }
  }

  Uint8List _randomBytes(int length) {
    final r = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => r.nextInt(256)));
  }
}

/// HMAC-SHA256 digital signature for backup integrity.
class SignatureService {
  SignatureService._();
  static final SignatureService instance = SignatureService._();

  String sign(Uint8List data, Uint8List key) {
    final hmac = crypto.Hmac(crypto.sha256, key);
    return base64Url.encode(hmac.convert(data).bytes);
  }

  bool verify(Uint8List data, Uint8List key, String signature) {
    final expected = sign(data, key);
    if (expected.length != signature.length) return false;
    var diff = 0;
    for (var i = 0; i < expected.length; i++) {
      diff |= expected.codeUnitAt(i) ^ signature.codeUnitAt(i);
    }
    return diff == 0;
  }

  String sha256Hex(Uint8List data) => crypto.sha256.convert(data).toString();
}
