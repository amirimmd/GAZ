import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.username,
    required this.displayName,
    required this.isActive,
    required this.mustChangePassword,
    required this.roleCodes,
    required this.permissions,
    this.lastLoginAt,
  });

  final String id;
  final String username;
  final String displayName;
  final bool isActive;
  final bool mustChangePassword;
  final List<String> roleCodes;
  final Set<String> permissions;
  final DateTime? lastLoginAt;

  bool hasPermission(String code) => permissions.contains(code);

  @override
  List<Object?> get props =>
      [id, username, displayName, isActive, roleCodes, permissions];
}

class AuthSession extends Equatable {
  const AuthSession({
    required this.sessionId,
    required this.user,
    required this.expiresAt,
    required this.lastActivityAt,
  });

  final String sessionId;
  final UserEntity user;
  final DateTime expiresAt;
  final DateTime lastActivityAt;

  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt);

  AuthSession copyWithActivity(DateTime at) => AuthSession(
        sessionId: sessionId,
        user: user,
        expiresAt: expiresAt,
        lastActivityAt: at,
      );

  @override
  List<Object?> get props => [sessionId, user, expiresAt, lastActivityAt];
}
