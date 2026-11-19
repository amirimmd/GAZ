import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/security/biometric_auth_service.dart';

final biometricAuthServiceProvider = Provider((ref) => BiometricAuthService());

/// When true, GoRouter must not redirect away from /login (biometric opt-in dialog).
final pendingBiometricSetupProvider = StateProvider<bool>((ref) => false);
