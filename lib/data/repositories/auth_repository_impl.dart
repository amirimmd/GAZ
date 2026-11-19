import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../core/security/crypto_service.dart';
import '../../domain/entities/user_account_summary.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../local/database/app_database.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();
  static const _persistedSessionKey = 'gaz_hrms_persisted_session_id';

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final userRow = await (_db.select(_db.users)
            ..where((u) => u.username.equals(username) & u.deletedAt.isNull()))
          .getSingleOrNull();

      if (userRow == null) {
        await _audit(null, username, 'login_failed', 'کاربر یافت نشد');
        return const Err(AuthFailure('نام کاربری یا رمز عبور نادرست است'));
      }

      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      if (userRow.lockedUntil != null && userRow.lockedUntil! > now) {
        return const Err(AuthFailure('حساب کاربری موقتاً قفل شده است'));
      }

      if (!userRow.isActive) {
        return const Err(AuthFailure('حساب کاربری غیرفعال است'));
      }

      final ok = PasswordHasher.instance.verifyPassword(
        password,
        userRow.passwordHash,
      );

      if (!ok) {
        final attempts = userRow.failedAttempts + 1;
        final lockedUntil = attempts >= AppConstants.maxLoginAttempts
            ? now +
                Duration(minutes: AppConstants.lockoutMinutes).inMilliseconds
            : null;
        await (_db.update(_db.users)..where((u) => u.id.equals(userRow.id)))
            .write(
          UsersCompanion(
            failedAttempts: Value(attempts),
            lockedUntil: Value(lockedUntil),
            updatedAt: Value(now),
          ),
        );
        await _audit(userRow.id, username, 'login_failed', 'رمز نادرست');
        return const Err(AuthFailure('نام کاربری یا رمز عبور نادرست است'));
      }

      await (_db.update(_db.users)..where((u) => u.id.equals(userRow.id)))
          .write(
        UsersCompanion(
          failedAttempts: const Value(0),
          lockedUntil: const Value(null),
          lastLoginAt: Value(now),
          rememberMeEnabled: Value(rememberMe),
          updatedAt: Value(now),
        ),
      );

      final permissions = await _loadPermissions(userRow.id);
      final roles = await _loadRoles(userRow.id);
      final user = UserEntity(
        id: userRow.id,
        username: userRow.username,
        displayName: userRow.displayName,
        isActive: userRow.isActive,
        mustChangePassword: userRow.mustChangePassword,
        roleCodes: roles,
        permissions: permissions,
        lastLoginAt: DateTime.fromMillisecondsSinceEpoch(now, isUtc: true),
      );

      final sessionId = _uuid.v4();
      final expiresAt = DateTime.now().toUtc().add(
            const Duration(minutes: AppConstants.defaultSessionTimeoutMinutes),
          );
      final tokenHash = SignatureService.instance.sha256Hex(
        Uint8List.fromList(utf8.encode(sessionId)),
      );

      await _db.into(_db.sessions).insert(
            SessionsCompanion.insert(
              id: sessionId,
              userId: userRow.id,
              tokenHash: tokenHash,
              expiresAt: expiresAt.millisecondsSinceEpoch,
              lastActivityAt: now,
            ),
          );

      await _audit(userRow.id, username, 'login', 'ورود موفق');

      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setString(_persistedSessionKey, sessionId);
      } else {
        await prefs.remove(_persistedSessionKey);
      }

      return Success(
        AuthSession(
          sessionId: sessionId,
          user: user,
          expiresAt: expiresAt,
          lastActivityAt: DateTime.fromMillisecondsSinceEpoch(now, isUtc: true),
        ),
      );
    } catch (e) {
      return Err(UnexpectedFailure('خطا در ورود: $e'));
    }
  }

  @override
  Future<Result<void>> logout(String sessionId) async {
    try {
      final session = await (_db.select(_db.sessions)
            ..where((s) => s.id.equals(sessionId)))
          .getSingleOrNull();
      await (_db.update(_db.sessions)..where((s) => s.id.equals(sessionId)))
          .write(const SessionsCompanion(isValid: Value(false)));
      if (session != null) {
        await _audit(session.userId, null, 'logout', null);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_persistedSessionKey);
      return const Success(null);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<AuthSession?>> restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString(_persistedSessionKey);
      if (sessionId == null) return const Success(null);

      final sessionRow = await (_db.select(_db.sessions)
            ..where(
              (s) => s.id.equals(sessionId) & s.isValid.equals(true),
            ))
          .getSingleOrNull();
      if (sessionRow == null) {
        await prefs.remove(_persistedSessionKey);
        return const Success(null);
      }

      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      if (sessionRow.expiresAt < now) {
        await (_db.update(_db.sessions)
              ..where((s) => s.id.equals(sessionId)))
            .write(const SessionsCompanion(isValid: Value(false)));
        await prefs.remove(_persistedSessionKey);
        return const Success(null);
      }

      final userRow = await (_db.select(_db.users)
            ..where(
              (u) => u.id.equals(sessionRow.userId) & u.deletedAt.isNull(),
            ))
          .getSingleOrNull();
      if (userRow == null ||
          !userRow.isActive ||
          !userRow.rememberMeEnabled) {
        await prefs.remove(_persistedSessionKey);
        return const Success(null);
      }

      final permissions = await _loadPermissions(userRow.id);
      final roles = await _loadRoles(userRow.id);
      final user = UserEntity(
        id: userRow.id,
        username: userRow.username,
        displayName: userRow.displayName,
        isActive: userRow.isActive,
        mustChangePassword: userRow.mustChangePassword,
        roleCodes: roles,
        permissions: permissions,
        lastLoginAt: userRow.lastLoginAt != null
            ? DateTime.fromMillisecondsSinceEpoch(
                userRow.lastLoginAt!,
                isUtc: true,
              )
            : null,
      );

      return Success(
        AuthSession(
          sessionId: sessionRow.id,
          user: user,
          expiresAt: DateTime.fromMillisecondsSinceEpoch(
            sessionRow.expiresAt,
            isUtc: true,
          ),
          lastActivityAt: DateTime.fromMillisecondsSinceEpoch(
            sessionRow.lastActivityAt,
            isUtc: true,
          ),
        ),
      );
    } catch (e) {
      return Err(UnexpectedFailure('خطا در بازگردانی نشست: $e'));
    }
  }

  @override
  Future<Result<void>> touchSession(String sessionId) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await (_db.update(_db.sessions)..where((s) => s.id.equals(sessionId)))
        .write(SessionsCompanion(lastActivityAt: Value(now)));
    return const Success(null);
  }

  @override
  Future<Result<void>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final userRow = await (_db.select(_db.users)
          ..where((u) => u.id.equals(userId)))
        .getSingleOrNull();
    if (userRow == null) return const Err(NotFoundFailure());
    if (!PasswordHasher.instance.verifyPassword(
      currentPassword,
      userRow.passwordHash,
    )) {
      return const Err(AuthFailure('رمز فعلی نادرست است'));
    }
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        passwordHash: Value(PasswordHasher.instance.hashPassword(newPassword)),
        mustChangePassword: const Value(false),
        updatedAt: Value(now),
      ),
    );
    await _audit(userId, userRow.username, 'password_change', null);
    return const Success(null);
  }

  @override
  Future<Result<bool>> verifyPassword({
    required String userId,
    required String password,
  }) async {
    try {
      final userRow = await (_db.select(_db.users)
            ..where((u) => u.id.equals(userId) & u.deletedAt.isNull()))
          .getSingleOrNull();
      if (userRow == null) {
        return const Err(NotFoundFailure());
      }
      final ok = PasswordHasher.instance.verifyPassword(
        password,
        userRow.passwordHash,
      );
      return Success(ok);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<List<UserAccountSummary>>> listUsers() async {
    try {
      final rows = await (_db.select(_db.users)
            ..where((u) => u.deletedAt.isNull())
            ..orderBy([(u) => OrderingTerm.asc(u.username)]))
          .get();
      final list = <UserAccountSummary>[];
      for (final row in rows) {
        final roles = await _loadRoles(row.id);
        final perms = await _loadPermissions(row.id);
        list.add(
          UserAccountSummary(
            id: row.id,
            username: row.username,
            displayName: row.displayName,
            isActive: row.isActive,
            roleCodes: roles,
            permissions: perms,
          ),
        );
      }
      return Success(list);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<bool> hasPermission(String userId, String permissionCode) async {
    final perms = await _loadPermissions(userId);
    return perms.contains(permissionCode);
  }

  Future<Set<String>> _loadPermissions(String userId) async {
    final query = _db.customSelect(
      '''
      SELECT p.code AS code
      FROM permissions p
      INNER JOIN role_permissions rp ON rp.permission_id = p.id
      INNER JOIN user_roles ur ON ur.role_id = rp.role_id
      WHERE ur.user_id = ?
      ''',
      variables: [Variable.withString(userId)],
      readsFrom: {_db.permissions, _db.rolePermissions, _db.userRoles},
    );
    final rows = await query.get();
    return rows.map((r) => r.read<String>('code')).toSet();
  }

  Future<List<String>> _loadRoles(String userId) async {
    final query = _db.customSelect(
      '''
      SELECT r.code AS code
      FROM roles r
      INNER JOIN user_roles ur ON ur.role_id = r.id
      WHERE ur.user_id = ?
      ''',
      variables: [Variable.withString(userId)],
      readsFrom: {_db.roles, _db.userRoles},
    );
    final rows = await query.get();
    return rows.map((r) => r.read<String>('code')).toList();
  }

  Future<void> _audit(
    String? userId,
    String? username,
    String action,
    String? details,
  ) async {
    await _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            id: _uuid.v4(),
            actorUserId: Value(userId),
            actorUsername: Value(username),
            action: action,
            detailsJson: Value(details),
            createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
          ),
        );
  }
}
