import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failures.dart';
import '../../core/security/session_controller.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth/auth_usecases.dart';
import 'repository_providers.dart';

class AuthActions {
  AuthActions(this._ref);

  final Ref _ref;

  Future<void> logout() async {
    final session = _ref.read(sessionControllerProvider);
    if (session != null) {
      await LogoutUseCase(_ref.read(authRepositoryProvider))(session.sessionId);
    }
    _ref.read(sessionControllerProvider.notifier).clear();
  }
}

final authActionsProvider = Provider<AuthActions>((ref) => AuthActions(ref));

class LoginState {
  const LoginState({
    this.isLoading = false,
    this.error,
    this.session,
  });

  final bool isLoading;
  final String? error;
  final AuthSession? session;

  LoginState copyWith({
    bool? isLoading,
    String? error,
    AuthSession? session,
    bool clearError = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      session: session ?? this.session,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<bool> submit({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = LoginUseCase(ref.read(authRepositoryProvider));
    final result = await useCase(
      username: username,
      password: password,
      rememberMe: rememberMe,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (session) {
        ref.read(sessionControllerProvider.notifier).start(session);
        state = state.copyWith(isLoading: false, session: session);
        return true;
      },
    );
  }

  Future<bool> unlock(String password) async {
    final session = ref.read(sessionControllerProvider);
    if (session == null) return false;

    final result = await VerifyPasswordUseCase(ref.read(authRepositoryProvider))(
      userId: session.user.id,
      password: password,
    );

    return result.fold(
      (_) => false,
      (ok) {
        if (ok) {
          ref.read(sessionControllerProvider.notifier).touch();
        }
        return ok;
      },
    );
  }

  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final session = ref.read(sessionControllerProvider);
    if (session == null) {
      return const Err(AuthFailure('نشست منقضی شده است'));
    }

    final result = await ChangePasswordUseCase(ref.read(authRepositoryProvider))(
      userId: session.user.id,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    return result.fold(
      (failure) => Err(failure),
      (_) {
        final updatedUser = session.user;
        // Refresh session user flag after password change.
        ref.read(sessionControllerProvider.notifier).start(
              AuthSession(
                sessionId: session.sessionId,
                user: UserEntity(
                  id: updatedUser.id,
                  username: updatedUser.username,
                  displayName: updatedUser.displayName,
                  isActive: updatedUser.isActive,
                  mustChangePassword: false,
                  roleCodes: updatedUser.roleCodes,
                  permissions: updatedUser.permissions,
                  lastLoginAt: updatedUser.lastLoginAt,
                ),
                expiresAt: session.expiresAt,
                lastActivityAt: session.lastActivityAt,
              ),
            );
        return const Success(null);
      },
    );
  }
}

final loginViewModelProvider =
    NotifierProvider<LoginViewModel, LoginState>(LoginViewModel.new);
