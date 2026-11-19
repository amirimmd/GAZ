import '../../core/errors/failures.dart';
import '../entities/user_account_summary.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
    required bool rememberMe,
  });

  Future<Result<void>> logout(String sessionId);

  Future<Result<AuthSession?>> restoreSession();

  Future<Result<void>> touchSession(String sessionId);

  Future<Result<void>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  Future<bool> hasPermission(String userId, String permissionCode);

  Future<Result<bool>> verifyPassword({
    required String userId,
    required String password,
  });

  Future<Result<List<UserAccountSummary>>> listUsers();
}
