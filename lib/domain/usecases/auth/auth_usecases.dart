import '../../../core/errors/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._auth);

  final AuthRepository _auth;

  Future<Result<AuthSession>> call({
    required String username,
    required String password,
    bool rememberMe = false,
  }) {
    final u = username.trim();
    if (u.isEmpty || password.isEmpty) {
      return Future.value(
        const Err(ValidationFailure('نام کاربری و رمز عبور الزامی است')),
      );
    }
    return _auth.login(
      username: u,
      password: password,
      rememberMe: rememberMe,
    );
  }
}

class LogoutUseCase {
  LogoutUseCase(this._auth);
  final AuthRepository _auth;

  Future<Result<void>> call(String sessionId) => _auth.logout(sessionId);
}

class VerifyPasswordUseCase {
  VerifyPasswordUseCase(this._auth);
  final AuthRepository _auth;

  Future<Result<bool>> call({
    required String userId,
    required String password,
  }) {
    if (password.isEmpty) {
      return Future.value(
        const Err(ValidationFailure('رمز عبور الزامی است')),
      );
    }
    return _auth.verifyPassword(userId: userId, password: password);
  }
}

class ChangePasswordUseCase {
  ChangePasswordUseCase(this._auth);
  final AuthRepository _auth;

  Future<Result<void>> call({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) {
    if (newPassword.length < 10) {
      return Future.value(
        const Err(
          ValidationFailure('رمز عبور باید حداقل ۱۰ کاراکتر باشد'),
        ),
      );
    }
    final hasUpper = newPassword.contains(RegExp('[A-Z]'));
    final hasLower = newPassword.contains(RegExp('[a-z]'));
    final hasDigit = newPassword.contains(RegExp('[0-9]'));
    if (!(hasUpper && hasLower && hasDigit)) {
      return Future.value(
        const Err(
          ValidationFailure(
            'رمز عبور باید شامل حروف بزرگ، کوچک و عدد باشد',
          ),
        ),
      );
    }
    return _auth.changePassword(
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
