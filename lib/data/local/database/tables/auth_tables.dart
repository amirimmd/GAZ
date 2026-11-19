import 'package:drift/drift.dart';

/// Authentication users.
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get displayName => text()();
  TextColumn get passwordHash => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn get lockedUntil => integer().nullable()();
  BoolColumn get mustChangePassword =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get rememberMeEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get lastLoginAt => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Roles extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get nameFa => text()();
  TextColumn get nameEn => text().nullable()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Permissions extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get module => text()();
  TextColumn get nameFa => text()();
  TextColumn get nameEn => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserRoles extends Table {
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get roleId => text().references(Roles, #id)();

  @override
  Set<Column> get primaryKey => {userId, roleId};
}

class RolePermissions extends Table {
  TextColumn get roleId => text().references(Roles, #id)();
  TextColumn get permissionId => text().references(Permissions, #id)();

  @override
  Set<Column> get primaryKey => {roleId, permissionId};
}

class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get tokenHash => text()();
  IntColumn get expiresAt => integer()();
  IntColumn get lastActivityAt => integer()();
  TextColumn get deviceInfo => text().nullable()();
  BoolColumn get isValid => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
