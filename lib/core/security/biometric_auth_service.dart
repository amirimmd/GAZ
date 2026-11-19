import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricResult {
  const BiometricResult.ok() : ok = true, message = null;
  const BiometricResult.fail(this.message) : ok = false;

  final bool ok;
  final String? message;
}

/// Fingerprint / biometric login after first successful password login.
class BiometricAuthService {
  BiometricAuthService({
    LocalAuthentication? auth,
    FlutterSecureStorage? storage,
  })  : _auth = auth ?? LocalAuthentication(),
        _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  static const _prefEnabled = 'gaz_biometric_enabled';
  static const _prefUsername = 'gaz_biometric_username';
  static const _securePassword = 'gaz_biometric_password';

  Future<bool> get isDeviceSupported async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> get canCheckBiometrics async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> get isAvailable async {
    final supported = await isDeviceSupported;
    if (!supported) return false;
    try {
      final bios = await _auth.getAvailableBiometrics();
      if (bios.isNotEmpty) return true;
      return await canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> get isEnabled async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefEnabled) ?? false;
  }

  Future<String?> get savedUsername async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefUsername);
  }

  /// Writes password first, verifies read-back, then sets enabled flag.
  Future<BiometricResult> enable({
    required String username,
    required String password,
  }) async {
    try {
      final user = username.trim();
      if (user.isEmpty || password.isEmpty) {
        return const BiometricResult.fail('نام کاربری یا رمز خالی است');
      }
      await _storage.write(key: _securePassword, value: password);
      final readBack = await _storage.read(key: _securePassword);
      if (readBack != password) {
        await _storage.delete(key: _securePassword);
        return const BiometricResult.fail('ذخیره امن رمز ناموفق بود');
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefUsername, user);
      await prefs.setBool(_prefEnabled, true);
      return const BiometricResult.ok();
    } catch (e) {
      return BiometricResult.fail('فعال‌سازی ناموفق: $e');
    }
  }

  /// Updates stored password when already enabled (e.g. after password change).
  Future<BiometricResult> updateStoredPassword(String password) async {
    if (!await isEnabled) {
      return const BiometricResult.fail('اثر انگشت فعال نیست');
    }
    final username = await savedUsername;
    if (username == null || username.isEmpty) {
      return const BiometricResult.fail('نام کاربری ذخیره‌شده یافت نشد');
    }
    return enable(username: username, password: password);
  }

  Future<void> disable() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefEnabled, false);
    await prefs.remove(_prefUsername);
    await _storage.delete(key: _securePassword);
  }

  Future<BiometricResult> authenticate({
    String reason = 'ورود با اثر انگشت به قائم‌شهر',
  }) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      if (ok) return const BiometricResult.ok();
      return const BiometricResult.fail('احراز هویت بیومتریک لغو یا ناموفق شد');
    } on PlatformException catch (e) {
      return BiometricResult.fail(_mapPlatformError(e));
    } catch (e) {
      return BiometricResult.fail('خطای بیومتریک: $e');
    }
  }

  String _mapPlatformError(PlatformException e) {
    return switch (e.code) {
      'NotAvailable' => 'اثر انگشت روی این دستگاه در دسترس نیست',
      'NotEnrolled' => 'اثر انگشتی روی دستگاه ثبت نشده است',
      'LockedOut' || 'PermanentlyLockedOut' => 'اثر انگشت موقتاً قفل شده است',
      'no_fragment_activity' =>
        'پیکربندی اندروید ناقص است (FlutterFragmentActivity)',
      _ => e.message ?? 'خطای بیومتریک (${e.code})',
    };
  }

  /// Returns credentials after successful biometric prompt, or null.
  Future<({String username, String password})?> unlockCredentials() async {
    if (!await isEnabled) return null;
    if (!await isAvailable) return null;
    final auth = await authenticate();
    if (!auth.ok) return null;
    final username = await savedUsername;
    final password = await _storage.read(key: _securePassword);
    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) {
      return null;
    }
    return (username: username, password: password);
  }
}
