// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _failedAttemptsMeta =
      const VerificationMeta('failedAttempts');
  @override
  late final GeneratedColumn<int> failedAttempts = GeneratedColumn<int>(
      'failed_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lockedUntilMeta =
      const VerificationMeta('lockedUntil');
  @override
  late final GeneratedColumn<int> lockedUntil = GeneratedColumn<int>(
      'locked_until', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _mustChangePasswordMeta =
      const VerificationMeta('mustChangePassword');
  @override
  late final GeneratedColumn<bool> mustChangePassword = GeneratedColumn<bool>(
      'must_change_password', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("must_change_password" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _rememberMeEnabledMeta =
      const VerificationMeta('rememberMeEnabled');
  @override
  late final GeneratedColumn<bool> rememberMeEnabled = GeneratedColumn<bool>(
      'remember_me_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("remember_me_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastLoginAtMeta =
      const VerificationMeta('lastLoginAt');
  @override
  late final GeneratedColumn<int> lastLoginAt = GeneratedColumn<int>(
      'last_login_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        displayName,
        passwordHash,
        isActive,
        failedAttempts,
        lockedUntil,
        mustChangePassword,
        rememberMeEnabled,
        lastLoginAt,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('failed_attempts')) {
      context.handle(
          _failedAttemptsMeta,
          failedAttempts.isAcceptableOrUnknown(
              data['failed_attempts']!, _failedAttemptsMeta));
    }
    if (data.containsKey('locked_until')) {
      context.handle(
          _lockedUntilMeta,
          lockedUntil.isAcceptableOrUnknown(
              data['locked_until']!, _lockedUntilMeta));
    }
    if (data.containsKey('must_change_password')) {
      context.handle(
          _mustChangePasswordMeta,
          mustChangePassword.isAcceptableOrUnknown(
              data['must_change_password']!, _mustChangePasswordMeta));
    }
    if (data.containsKey('remember_me_enabled')) {
      context.handle(
          _rememberMeEnabledMeta,
          rememberMeEnabled.isAcceptableOrUnknown(
              data['remember_me_enabled']!, _rememberMeEnabledMeta));
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
          _lastLoginAtMeta,
          lastLoginAt.isAcceptableOrUnknown(
              data['last_login_at']!, _lastLoginAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      failedAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}failed_attempts'])!,
      lockedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}locked_until']),
      mustChangePassword: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}must_change_password'])!,
      rememberMeEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}remember_me_enabled'])!,
      lastLoginAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_login_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String username;
  final String displayName;
  final String passwordHash;
  final bool isActive;
  final int failedAttempts;
  final int? lockedUntil;
  final bool mustChangePassword;
  final bool rememberMeEnabled;
  final int? lastLoginAt;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const User(
      {required this.id,
      required this.username,
      required this.displayName,
      required this.passwordHash,
      required this.isActive,
      required this.failedAttempts,
      this.lockedUntil,
      required this.mustChangePassword,
      required this.rememberMeEnabled,
      this.lastLoginAt,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['display_name'] = Variable<String>(displayName);
    map['password_hash'] = Variable<String>(passwordHash);
    map['is_active'] = Variable<bool>(isActive);
    map['failed_attempts'] = Variable<int>(failedAttempts);
    if (!nullToAbsent || lockedUntil != null) {
      map['locked_until'] = Variable<int>(lockedUntil);
    }
    map['must_change_password'] = Variable<bool>(mustChangePassword);
    map['remember_me_enabled'] = Variable<bool>(rememberMeEnabled);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<int>(lastLoginAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      displayName: Value(displayName),
      passwordHash: Value(passwordHash),
      isActive: Value(isActive),
      failedAttempts: Value(failedAttempts),
      lockedUntil: lockedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedUntil),
      mustChangePassword: Value(mustChangePassword),
      rememberMeEnabled: Value(rememberMeEnabled),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      displayName: serializer.fromJson<String>(json['displayName']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      failedAttempts: serializer.fromJson<int>(json['failedAttempts']),
      lockedUntil: serializer.fromJson<int?>(json['lockedUntil']),
      mustChangePassword: serializer.fromJson<bool>(json['mustChangePassword']),
      rememberMeEnabled: serializer.fromJson<bool>(json['rememberMeEnabled']),
      lastLoginAt: serializer.fromJson<int?>(json['lastLoginAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'displayName': serializer.toJson<String>(displayName),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'isActive': serializer.toJson<bool>(isActive),
      'failedAttempts': serializer.toJson<int>(failedAttempts),
      'lockedUntil': serializer.toJson<int?>(lockedUntil),
      'mustChangePassword': serializer.toJson<bool>(mustChangePassword),
      'rememberMeEnabled': serializer.toJson<bool>(rememberMeEnabled),
      'lastLoginAt': serializer.toJson<int?>(lastLoginAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  User copyWith(
          {String? id,
          String? username,
          String? displayName,
          String? passwordHash,
          bool? isActive,
          int? failedAttempts,
          Value<int?> lockedUntil = const Value.absent(),
          bool? mustChangePassword,
          bool? rememberMeEnabled,
          Value<int?> lastLoginAt = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        passwordHash: passwordHash ?? this.passwordHash,
        isActive: isActive ?? this.isActive,
        failedAttempts: failedAttempts ?? this.failedAttempts,
        lockedUntil: lockedUntil.present ? lockedUntil.value : this.lockedUntil,
        mustChangePassword: mustChangePassword ?? this.mustChangePassword,
        rememberMeEnabled: rememberMeEnabled ?? this.rememberMeEnabled,
        lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      failedAttempts: data.failedAttempts.present
          ? data.failedAttempts.value
          : this.failedAttempts,
      lockedUntil:
          data.lockedUntil.present ? data.lockedUntil.value : this.lockedUntil,
      mustChangePassword: data.mustChangePassword.present
          ? data.mustChangePassword.value
          : this.mustChangePassword,
      rememberMeEnabled: data.rememberMeEnabled.present
          ? data.rememberMeEnabled.value
          : this.rememberMeEnabled,
      lastLoginAt:
          data.lastLoginAt.present ? data.lastLoginAt.value : this.lastLoginAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('isActive: $isActive, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('mustChangePassword: $mustChangePassword, ')
          ..write('rememberMeEnabled: $rememberMeEnabled, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      username,
      displayName,
      passwordHash,
      isActive,
      failedAttempts,
      lockedUntil,
      mustChangePassword,
      rememberMeEnabled,
      lastLoginAt,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.passwordHash == this.passwordHash &&
          other.isActive == this.isActive &&
          other.failedAttempts == this.failedAttempts &&
          other.lockedUntil == this.lockedUntil &&
          other.mustChangePassword == this.mustChangePassword &&
          other.rememberMeEnabled == this.rememberMeEnabled &&
          other.lastLoginAt == this.lastLoginAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> displayName;
  final Value<String> passwordHash;
  final Value<bool> isActive;
  final Value<int> failedAttempts;
  final Value<int?> lockedUntil;
  final Value<bool> mustChangePassword;
  final Value<bool> rememberMeEnabled;
  final Value<int?> lastLoginAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.isActive = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.mustChangePassword = const Value.absent(),
    this.rememberMeEnabled = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String username,
    required String displayName,
    required String passwordHash,
    this.isActive = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.mustChangePassword = const Value.absent(),
    this.rememberMeEnabled = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        username = Value(username),
        displayName = Value(displayName),
        passwordHash = Value(passwordHash),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? passwordHash,
    Expression<bool>? isActive,
    Expression<int>? failedAttempts,
    Expression<int>? lockedUntil,
    Expression<bool>? mustChangePassword,
    Expression<bool>? rememberMeEnabled,
    Expression<int>? lastLoginAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (isActive != null) 'is_active': isActive,
      if (failedAttempts != null) 'failed_attempts': failedAttempts,
      if (lockedUntil != null) 'locked_until': lockedUntil,
      if (mustChangePassword != null)
        'must_change_password': mustChangePassword,
      if (rememberMeEnabled != null) 'remember_me_enabled': rememberMeEnabled,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? username,
      Value<String>? displayName,
      Value<String>? passwordHash,
      Value<bool>? isActive,
      Value<int>? failedAttempts,
      Value<int?>? lockedUntil,
      Value<bool>? mustChangePassword,
      Value<bool>? rememberMeEnabled,
      Value<int?>? lastLoginAt,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      passwordHash: passwordHash ?? this.passwordHash,
      isActive: isActive ?? this.isActive,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      rememberMeEnabled: rememberMeEnabled ?? this.rememberMeEnabled,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (failedAttempts.present) {
      map['failed_attempts'] = Variable<int>(failedAttempts.value);
    }
    if (lockedUntil.present) {
      map['locked_until'] = Variable<int>(lockedUntil.value);
    }
    if (mustChangePassword.present) {
      map['must_change_password'] = Variable<bool>(mustChangePassword.value);
    }
    if (rememberMeEnabled.present) {
      map['remember_me_enabled'] = Variable<bool>(rememberMeEnabled.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<int>(lastLoginAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('isActive: $isActive, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('mustChangePassword: $mustChangePassword, ')
          ..write('rememberMeEnabled: $rememberMeEnabled, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RolesTable extends Roles with TableInfo<$RolesTable, Role> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameFaMeta = const VerificationMeta('nameFa');
  @override
  late final GeneratedColumn<String> nameFa = GeneratedColumn<String>(
      'name_fa', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, code, nameFa, nameEn, isSystem, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roles';
  @override
  VerificationContext validateIntegrity(Insertable<Role> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_fa')) {
      context.handle(_nameFaMeta,
          nameFa.isAcceptableOrUnknown(data['name_fa']!, _nameFaMeta));
    } else if (isInserting) {
      context.missing(_nameFaMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Role map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Role(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      nameFa: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_fa'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en']),
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $RolesTable createAlias(String alias) {
    return $RolesTable(attachedDatabase, alias);
  }
}

class Role extends DataClass implements Insertable<Role> {
  final String id;
  final String code;
  final String nameFa;
  final String? nameEn;
  final bool isSystem;
  final String? description;
  const Role(
      {required this.id,
      required this.code,
      required this.nameFa,
      this.nameEn,
      required this.isSystem,
      this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name_fa'] = Variable<String>(nameFa);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    map['is_system'] = Variable<bool>(isSystem);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  RolesCompanion toCompanion(bool nullToAbsent) {
    return RolesCompanion(
      id: Value(id),
      code: Value(code),
      nameFa: Value(nameFa),
      nameEn:
          nameEn == null && nullToAbsent ? const Value.absent() : Value(nameEn),
      isSystem: Value(isSystem),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Role.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Role(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameFa: serializer.fromJson<String>(json['nameFa']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'nameFa': serializer.toJson<String>(nameFa),
      'nameEn': serializer.toJson<String?>(nameEn),
      'isSystem': serializer.toJson<bool>(isSystem),
      'description': serializer.toJson<String?>(description),
    };
  }

  Role copyWith(
          {String? id,
          String? code,
          String? nameFa,
          Value<String?> nameEn = const Value.absent(),
          bool? isSystem,
          Value<String?> description = const Value.absent()}) =>
      Role(
        id: id ?? this.id,
        code: code ?? this.code,
        nameFa: nameFa ?? this.nameFa,
        nameEn: nameEn.present ? nameEn.value : this.nameEn,
        isSystem: isSystem ?? this.isSystem,
        description: description.present ? description.value : this.description,
      );
  Role copyWithCompanion(RolesCompanion data) {
    return Role(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameFa: data.nameFa.present ? data.nameFa.value : this.nameFa,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Role(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('isSystem: $isSystem, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, nameFa, nameEn, isSystem, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Role &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameFa == this.nameFa &&
          other.nameEn == this.nameEn &&
          other.isSystem == this.isSystem &&
          other.description == this.description);
}

class RolesCompanion extends UpdateCompanion<Role> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> nameFa;
  final Value<String?> nameEn;
  final Value<bool> isSystem;
  final Value<String?> description;
  final Value<int> rowid;
  const RolesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameFa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RolesCompanion.insert({
    required String id,
    required String code,
    required String nameFa,
    this.nameEn = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        code = Value(code),
        nameFa = Value(nameFa);
  static Insertable<Role> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? nameFa,
    Expression<String>? nameEn,
    Expression<bool>? isSystem,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameFa != null) 'name_fa': nameFa,
      if (nameEn != null) 'name_en': nameEn,
      if (isSystem != null) 'is_system': isSystem,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RolesCompanion copyWith(
      {Value<String>? id,
      Value<String>? code,
      Value<String>? nameFa,
      Value<String?>? nameEn,
      Value<bool>? isSystem,
      Value<String?>? description,
      Value<int>? rowid}) {
    return RolesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameFa: nameFa ?? this.nameFa,
      nameEn: nameEn ?? this.nameEn,
      isSystem: isSystem ?? this.isSystem,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameFa.present) {
      map['name_fa'] = Variable<String>(nameFa.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RolesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('isSystem: $isSystem, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PermissionsTable extends Permissions
    with TableInfo<$PermissionsTable, Permission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PermissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
      'module', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameFaMeta = const VerificationMeta('nameFa');
  @override
  late final GeneratedColumn<String> nameFa = GeneratedColumn<String>(
      'name_fa', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, code, module, nameFa, nameEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'permissions';
  @override
  VerificationContext validateIntegrity(Insertable<Permission> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('module')) {
      context.handle(_moduleMeta,
          module.isAcceptableOrUnknown(data['module']!, _moduleMeta));
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('name_fa')) {
      context.handle(_nameFaMeta,
          nameFa.isAcceptableOrUnknown(data['name_fa']!, _nameFaMeta));
    } else if (isInserting) {
      context.missing(_nameFaMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Permission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Permission(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      module: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module'])!,
      nameFa: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_fa'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en']),
    );
  }

  @override
  $PermissionsTable createAlias(String alias) {
    return $PermissionsTable(attachedDatabase, alias);
  }
}

class Permission extends DataClass implements Insertable<Permission> {
  final String id;
  final String code;
  final String module;
  final String nameFa;
  final String? nameEn;
  const Permission(
      {required this.id,
      required this.code,
      required this.module,
      required this.nameFa,
      this.nameEn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['module'] = Variable<String>(module);
    map['name_fa'] = Variable<String>(nameFa);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    return map;
  }

  PermissionsCompanion toCompanion(bool nullToAbsent) {
    return PermissionsCompanion(
      id: Value(id),
      code: Value(code),
      module: Value(module),
      nameFa: Value(nameFa),
      nameEn:
          nameEn == null && nullToAbsent ? const Value.absent() : Value(nameEn),
    );
  }

  factory Permission.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Permission(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      module: serializer.fromJson<String>(json['module']),
      nameFa: serializer.fromJson<String>(json['nameFa']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'module': serializer.toJson<String>(module),
      'nameFa': serializer.toJson<String>(nameFa),
      'nameEn': serializer.toJson<String?>(nameEn),
    };
  }

  Permission copyWith(
          {String? id,
          String? code,
          String? module,
          String? nameFa,
          Value<String?> nameEn = const Value.absent()}) =>
      Permission(
        id: id ?? this.id,
        code: code ?? this.code,
        module: module ?? this.module,
        nameFa: nameFa ?? this.nameFa,
        nameEn: nameEn.present ? nameEn.value : this.nameEn,
      );
  Permission copyWithCompanion(PermissionsCompanion data) {
    return Permission(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      module: data.module.present ? data.module.value : this.module,
      nameFa: data.nameFa.present ? data.nameFa.value : this.nameFa,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Permission(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('module: $module, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, module, nameFa, nameEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Permission &&
          other.id == this.id &&
          other.code == this.code &&
          other.module == this.module &&
          other.nameFa == this.nameFa &&
          other.nameEn == this.nameEn);
}

class PermissionsCompanion extends UpdateCompanion<Permission> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> module;
  final Value<String> nameFa;
  final Value<String?> nameEn;
  final Value<int> rowid;
  const PermissionsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.module = const Value.absent(),
    this.nameFa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PermissionsCompanion.insert({
    required String id,
    required String code,
    required String module,
    required String nameFa,
    this.nameEn = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        code = Value(code),
        module = Value(module),
        nameFa = Value(nameFa);
  static Insertable<Permission> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? module,
    Expression<String>? nameFa,
    Expression<String>? nameEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (module != null) 'module': module,
      if (nameFa != null) 'name_fa': nameFa,
      if (nameEn != null) 'name_en': nameEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PermissionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? code,
      Value<String>? module,
      Value<String>? nameFa,
      Value<String?>? nameEn,
      Value<int>? rowid}) {
    return PermissionsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      module: module ?? this.module,
      nameFa: nameFa ?? this.nameFa,
      nameEn: nameEn ?? this.nameEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (nameFa.present) {
      map['name_fa'] = Variable<String>(nameFa.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PermissionsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('module: $module, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserRolesTable extends UserRoles
    with TableInfo<$UserRolesTable, UserRole> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserRolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<String> roleId = GeneratedColumn<String>(
      'role_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [userId, roleId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_roles';
  @override
  VerificationContext validateIntegrity(Insertable<UserRole> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role_id')) {
      context.handle(_roleIdMeta,
          roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta));
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, roleId};
  @override
  UserRole map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRole(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      roleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role_id'])!,
    );
  }

  @override
  $UserRolesTable createAlias(String alias) {
    return $UserRolesTable(attachedDatabase, alias);
  }
}

class UserRole extends DataClass implements Insertable<UserRole> {
  final String userId;
  final String roleId;
  const UserRole({required this.userId, required this.roleId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['role_id'] = Variable<String>(roleId);
    return map;
  }

  UserRolesCompanion toCompanion(bool nullToAbsent) {
    return UserRolesCompanion(
      userId: Value(userId),
      roleId: Value(roleId),
    );
  }

  factory UserRole.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRole(
      userId: serializer.fromJson<String>(json['userId']),
      roleId: serializer.fromJson<String>(json['roleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'roleId': serializer.toJson<String>(roleId),
    };
  }

  UserRole copyWith({String? userId, String? roleId}) => UserRole(
        userId: userId ?? this.userId,
        roleId: roleId ?? this.roleId,
      );
  UserRole copyWithCompanion(UserRolesCompanion data) {
    return UserRole(
      userId: data.userId.present ? data.userId.value : this.userId,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRole(')
          ..write('userId: $userId, ')
          ..write('roleId: $roleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, roleId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRole &&
          other.userId == this.userId &&
          other.roleId == this.roleId);
}

class UserRolesCompanion extends UpdateCompanion<UserRole> {
  final Value<String> userId;
  final Value<String> roleId;
  final Value<int> rowid;
  const UserRolesCompanion({
    this.userId = const Value.absent(),
    this.roleId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserRolesCompanion.insert({
    required String userId,
    required String roleId,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        roleId = Value(roleId);
  static Insertable<UserRole> custom({
    Expression<String>? userId,
    Expression<String>? roleId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (roleId != null) 'role_id': roleId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserRolesCompanion copyWith(
      {Value<String>? userId, Value<String>? roleId, Value<int>? rowid}) {
    return UserRolesCompanion(
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<String>(roleId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserRolesCompanion(')
          ..write('userId: $userId, ')
          ..write('roleId: $roleId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RolePermissionsTable extends RolePermissions
    with TableInfo<$RolePermissionsTable, RolePermission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RolePermissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<String> roleId = GeneratedColumn<String>(
      'role_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _permissionIdMeta =
      const VerificationMeta('permissionId');
  @override
  late final GeneratedColumn<String> permissionId = GeneratedColumn<String>(
      'permission_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [roleId, permissionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'role_permissions';
  @override
  VerificationContext validateIntegrity(Insertable<RolePermission> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('role_id')) {
      context.handle(_roleIdMeta,
          roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta));
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    if (data.containsKey('permission_id')) {
      context.handle(
          _permissionIdMeta,
          permissionId.isAcceptableOrUnknown(
              data['permission_id']!, _permissionIdMeta));
    } else if (isInserting) {
      context.missing(_permissionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {roleId, permissionId};
  @override
  RolePermission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RolePermission(
      roleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role_id'])!,
      permissionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}permission_id'])!,
    );
  }

  @override
  $RolePermissionsTable createAlias(String alias) {
    return $RolePermissionsTable(attachedDatabase, alias);
  }
}

class RolePermission extends DataClass implements Insertable<RolePermission> {
  final String roleId;
  final String permissionId;
  const RolePermission({required this.roleId, required this.permissionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['role_id'] = Variable<String>(roleId);
    map['permission_id'] = Variable<String>(permissionId);
    return map;
  }

  RolePermissionsCompanion toCompanion(bool nullToAbsent) {
    return RolePermissionsCompanion(
      roleId: Value(roleId),
      permissionId: Value(permissionId),
    );
  }

  factory RolePermission.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RolePermission(
      roleId: serializer.fromJson<String>(json['roleId']),
      permissionId: serializer.fromJson<String>(json['permissionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'roleId': serializer.toJson<String>(roleId),
      'permissionId': serializer.toJson<String>(permissionId),
    };
  }

  RolePermission copyWith({String? roleId, String? permissionId}) =>
      RolePermission(
        roleId: roleId ?? this.roleId,
        permissionId: permissionId ?? this.permissionId,
      );
  RolePermission copyWithCompanion(RolePermissionsCompanion data) {
    return RolePermission(
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      permissionId: data.permissionId.present
          ? data.permissionId.value
          : this.permissionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RolePermission(')
          ..write('roleId: $roleId, ')
          ..write('permissionId: $permissionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(roleId, permissionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RolePermission &&
          other.roleId == this.roleId &&
          other.permissionId == this.permissionId);
}

class RolePermissionsCompanion extends UpdateCompanion<RolePermission> {
  final Value<String> roleId;
  final Value<String> permissionId;
  final Value<int> rowid;
  const RolePermissionsCompanion({
    this.roleId = const Value.absent(),
    this.permissionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RolePermissionsCompanion.insert({
    required String roleId,
    required String permissionId,
    this.rowid = const Value.absent(),
  })  : roleId = Value(roleId),
        permissionId = Value(permissionId);
  static Insertable<RolePermission> custom({
    Expression<String>? roleId,
    Expression<String>? permissionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (roleId != null) 'role_id': roleId,
      if (permissionId != null) 'permission_id': permissionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RolePermissionsCompanion copyWith(
      {Value<String>? roleId, Value<String>? permissionId, Value<int>? rowid}) {
    return RolePermissionsCompanion(
      roleId: roleId ?? this.roleId,
      permissionId: permissionId ?? this.permissionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (roleId.present) {
      map['role_id'] = Variable<String>(roleId.value);
    }
    if (permissionId.present) {
      map['permission_id'] = Variable<String>(permissionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RolePermissionsCompanion(')
          ..write('roleId: $roleId, ')
          ..write('permissionId: $permissionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tokenHashMeta =
      const VerificationMeta('tokenHash');
  @override
  late final GeneratedColumn<String> tokenHash = GeneratedColumn<String>(
      'token_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<int> expiresAt = GeneratedColumn<int>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastActivityAtMeta =
      const VerificationMeta('lastActivityAt');
  @override
  late final GeneratedColumn<int> lastActivityAt = GeneratedColumn<int>(
      'last_activity_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deviceInfoMeta =
      const VerificationMeta('deviceInfo');
  @override
  late final GeneratedColumn<String> deviceInfo = GeneratedColumn<String>(
      'device_info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isValidMeta =
      const VerificationMeta('isValid');
  @override
  late final GeneratedColumn<bool> isValid = GeneratedColumn<bool>(
      'is_valid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_valid" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, tokenHash, expiresAt, lastActivityAt, deviceInfo, isValid];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<Session> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('token_hash')) {
      context.handle(_tokenHashMeta,
          tokenHash.isAcceptableOrUnknown(data['token_hash']!, _tokenHashMeta));
    } else if (isInserting) {
      context.missing(_tokenHashMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('last_activity_at')) {
      context.handle(
          _lastActivityAtMeta,
          lastActivityAt.isAcceptableOrUnknown(
              data['last_activity_at']!, _lastActivityAtMeta));
    } else if (isInserting) {
      context.missing(_lastActivityAtMeta);
    }
    if (data.containsKey('device_info')) {
      context.handle(
          _deviceInfoMeta,
          deviceInfo.isAcceptableOrUnknown(
              data['device_info']!, _deviceInfoMeta));
    }
    if (data.containsKey('is_valid')) {
      context.handle(_isValidMeta,
          isValid.isAcceptableOrUnknown(data['is_valid']!, _isValidMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      tokenHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token_hash'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expires_at'])!,
      lastActivityAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_activity_at'])!,
      deviceInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_info']),
      isValid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_valid'])!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final String userId;
  final String tokenHash;
  final int expiresAt;
  final int lastActivityAt;
  final String? deviceInfo;
  final bool isValid;
  const Session(
      {required this.id,
      required this.userId,
      required this.tokenHash,
      required this.expiresAt,
      required this.lastActivityAt,
      this.deviceInfo,
      required this.isValid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['token_hash'] = Variable<String>(tokenHash);
    map['expires_at'] = Variable<int>(expiresAt);
    map['last_activity_at'] = Variable<int>(lastActivityAt);
    if (!nullToAbsent || deviceInfo != null) {
      map['device_info'] = Variable<String>(deviceInfo);
    }
    map['is_valid'] = Variable<bool>(isValid);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      tokenHash: Value(tokenHash),
      expiresAt: Value(expiresAt),
      lastActivityAt: Value(lastActivityAt),
      deviceInfo: deviceInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceInfo),
      isValid: Value(isValid),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      tokenHash: serializer.fromJson<String>(json['tokenHash']),
      expiresAt: serializer.fromJson<int>(json['expiresAt']),
      lastActivityAt: serializer.fromJson<int>(json['lastActivityAt']),
      deviceInfo: serializer.fromJson<String?>(json['deviceInfo']),
      isValid: serializer.fromJson<bool>(json['isValid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'tokenHash': serializer.toJson<String>(tokenHash),
      'expiresAt': serializer.toJson<int>(expiresAt),
      'lastActivityAt': serializer.toJson<int>(lastActivityAt),
      'deviceInfo': serializer.toJson<String?>(deviceInfo),
      'isValid': serializer.toJson<bool>(isValid),
    };
  }

  Session copyWith(
          {String? id,
          String? userId,
          String? tokenHash,
          int? expiresAt,
          int? lastActivityAt,
          Value<String?> deviceInfo = const Value.absent(),
          bool? isValid}) =>
      Session(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        tokenHash: tokenHash ?? this.tokenHash,
        expiresAt: expiresAt ?? this.expiresAt,
        lastActivityAt: lastActivityAt ?? this.lastActivityAt,
        deviceInfo: deviceInfo.present ? deviceInfo.value : this.deviceInfo,
        isValid: isValid ?? this.isValid,
      );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      lastActivityAt: data.lastActivityAt.present
          ? data.lastActivityAt.value
          : this.lastActivityAt,
      deviceInfo:
          data.deviceInfo.present ? data.deviceInfo.value : this.deviceInfo,
      isValid: data.isValid.present ? data.isValid.value : this.isValid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('isValid: $isValid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, tokenHash, expiresAt, lastActivityAt, deviceInfo, isValid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.tokenHash == this.tokenHash &&
          other.expiresAt == this.expiresAt &&
          other.lastActivityAt == this.lastActivityAt &&
          other.deviceInfo == this.deviceInfo &&
          other.isValid == this.isValid);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> tokenHash;
  final Value<int> expiresAt;
  final Value<int> lastActivityAt;
  final Value<String?> deviceInfo;
  final Value<bool> isValid;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.tokenHash = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.lastActivityAt = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.isValid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String userId,
    required String tokenHash,
    required int expiresAt,
    required int lastActivityAt,
    this.deviceInfo = const Value.absent(),
    this.isValid = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        tokenHash = Value(tokenHash),
        expiresAt = Value(expiresAt),
        lastActivityAt = Value(lastActivityAt);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? tokenHash,
    Expression<int>? expiresAt,
    Expression<int>? lastActivityAt,
    Expression<String>? deviceInfo,
    Expression<bool>? isValid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (tokenHash != null) 'token_hash': tokenHash,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (lastActivityAt != null) 'last_activity_at': lastActivityAt,
      if (deviceInfo != null) 'device_info': deviceInfo,
      if (isValid != null) 'is_valid': isValid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? tokenHash,
      Value<int>? expiresAt,
      Value<int>? lastActivityAt,
      Value<String?>? deviceInfo,
      Value<bool>? isValid,
      Value<int>? rowid}) {
    return SessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tokenHash: tokenHash ?? this.tokenHash,
      expiresAt: expiresAt ?? this.expiresAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      isValid: isValid ?? this.isValid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<int>(expiresAt.value);
    }
    if (lastActivityAt.present) {
      map['last_activity_at'] = Variable<int>(lastActivityAt.value);
    }
    if (deviceInfo.present) {
      map['device_info'] = Variable<String>(deviceInfo.value);
    }
    if (isValid.present) {
      map['is_valid'] = Variable<bool>(isValid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('lastActivityAt: $lastActivityAt, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('isValid: $isValid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepartmentsTable extends Departments
    with TableInfo<$DepartmentsTable, Department> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameFaMeta = const VerificationMeta('nameFa');
  @override
  late final GeneratedColumn<String> nameFa = GeneratedColumn<String>(
      'name_fa', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, nameFa, nameEn, code, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'departments';
  @override
  VerificationContext validateIntegrity(Insertable<Department> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_fa')) {
      context.handle(_nameFaMeta,
          nameFa.isAcceptableOrUnknown(data['name_fa']!, _nameFaMeta));
    } else if (isInserting) {
      context.missing(_nameFaMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Department map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Department(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nameFa: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_fa'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en']),
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $DepartmentsTable createAlias(String alias) {
    return $DepartmentsTable(attachedDatabase, alias);
  }
}

class Department extends DataClass implements Insertable<Department> {
  final String id;
  final String nameFa;
  final String? nameEn;
  final String? code;
  final bool isActive;
  const Department(
      {required this.id,
      required this.nameFa,
      this.nameEn,
      this.code,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_fa'] = Variable<String>(nameFa);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  DepartmentsCompanion toCompanion(bool nullToAbsent) {
    return DepartmentsCompanion(
      id: Value(id),
      nameFa: Value(nameFa),
      nameEn:
          nameEn == null && nullToAbsent ? const Value.absent() : Value(nameEn),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      isActive: Value(isActive),
    );
  }

  factory Department.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Department(
      id: serializer.fromJson<String>(json['id']),
      nameFa: serializer.fromJson<String>(json['nameFa']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      code: serializer.fromJson<String?>(json['code']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameFa': serializer.toJson<String>(nameFa),
      'nameEn': serializer.toJson<String?>(nameEn),
      'code': serializer.toJson<String?>(code),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Department copyWith(
          {String? id,
          String? nameFa,
          Value<String?> nameEn = const Value.absent(),
          Value<String?> code = const Value.absent(),
          bool? isActive}) =>
      Department(
        id: id ?? this.id,
        nameFa: nameFa ?? this.nameFa,
        nameEn: nameEn.present ? nameEn.value : this.nameEn,
        code: code.present ? code.value : this.code,
        isActive: isActive ?? this.isActive,
      );
  Department copyWithCompanion(DepartmentsCompanion data) {
    return Department(
      id: data.id.present ? data.id.value : this.id,
      nameFa: data.nameFa.present ? data.nameFa.value : this.nameFa,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      code: data.code.present ? data.code.value : this.code,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Department(')
          ..write('id: $id, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('code: $code, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameFa, nameEn, code, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Department &&
          other.id == this.id &&
          other.nameFa == this.nameFa &&
          other.nameEn == this.nameEn &&
          other.code == this.code &&
          other.isActive == this.isActive);
}

class DepartmentsCompanion extends UpdateCompanion<Department> {
  final Value<String> id;
  final Value<String> nameFa;
  final Value<String?> nameEn;
  final Value<String?> code;
  final Value<bool> isActive;
  final Value<int> rowid;
  const DepartmentsCompanion({
    this.id = const Value.absent(),
    this.nameFa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.code = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepartmentsCompanion.insert({
    required String id,
    required String nameFa,
    this.nameEn = const Value.absent(),
    this.code = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nameFa = Value(nameFa);
  static Insertable<Department> custom({
    Expression<String>? id,
    Expression<String>? nameFa,
    Expression<String>? nameEn,
    Expression<String>? code,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameFa != null) 'name_fa': nameFa,
      if (nameEn != null) 'name_en': nameEn,
      if (code != null) 'code': code,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepartmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? nameFa,
      Value<String?>? nameEn,
      Value<String?>? code,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return DepartmentsCompanion(
      id: id ?? this.id,
      nameFa: nameFa ?? this.nameFa,
      nameEn: nameEn ?? this.nameEn,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameFa.present) {
      map['name_fa'] = Variable<String>(nameFa.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentsCompanion(')
          ..write('id: $id, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('code: $code, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _departmentIdMeta =
      const VerificationMeta('departmentId');
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
      'department_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameFaMeta = const VerificationMeta('nameFa');
  @override
  late final GeneratedColumn<String> nameFa = GeneratedColumn<String>(
      'name_fa', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, departmentId, nameFa, nameEn, code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(Insertable<Unit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
          _departmentIdMeta,
          departmentId.isAcceptableOrUnknown(
              data['department_id']!, _departmentIdMeta));
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('name_fa')) {
      context.handle(_nameFaMeta,
          nameFa.isAcceptableOrUnknown(data['name_fa']!, _nameFaMeta));
    } else if (isInserting) {
      context.missing(_nameFaMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      departmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}department_id'])!,
      nameFa: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_fa'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en']),
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code']),
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final String id;
  final String departmentId;
  final String nameFa;
  final String? nameEn;
  final String? code;
  const Unit(
      {required this.id,
      required this.departmentId,
      required this.nameFa,
      this.nameEn,
      this.code});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['department_id'] = Variable<String>(departmentId);
    map['name_fa'] = Variable<String>(nameFa);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      departmentId: Value(departmentId),
      nameFa: Value(nameFa),
      nameEn:
          nameEn == null && nullToAbsent ? const Value.absent() : Value(nameEn),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
    );
  }

  factory Unit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<String>(json['id']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      nameFa: serializer.fromJson<String>(json['nameFa']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      code: serializer.fromJson<String?>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'departmentId': serializer.toJson<String>(departmentId),
      'nameFa': serializer.toJson<String>(nameFa),
      'nameEn': serializer.toJson<String?>(nameEn),
      'code': serializer.toJson<String?>(code),
    };
  }

  Unit copyWith(
          {String? id,
          String? departmentId,
          String? nameFa,
          Value<String?> nameEn = const Value.absent(),
          Value<String?> code = const Value.absent()}) =>
      Unit(
        id: id ?? this.id,
        departmentId: departmentId ?? this.departmentId,
        nameFa: nameFa ?? this.nameFa,
        nameEn: nameEn.present ? nameEn.value : this.nameEn,
        code: code.present ? code.value : this.code,
      );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      nameFa: data.nameFa.present ? data.nameFa.value : this.nameFa,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, departmentId, nameFa, nameEn, code);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.departmentId == this.departmentId &&
          other.nameFa == this.nameFa &&
          other.nameEn == this.nameEn &&
          other.code == this.code);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<String> id;
  final Value<String> departmentId;
  final Value<String> nameFa;
  final Value<String?> nameEn;
  final Value<String?> code;
  final Value<int> rowid;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.nameFa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsCompanion.insert({
    required String id,
    required String departmentId,
    required String nameFa,
    this.nameEn = const Value.absent(),
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        departmentId = Value(departmentId),
        nameFa = Value(nameFa);
  static Insertable<Unit> custom({
    Expression<String>? id,
    Expression<String>? departmentId,
    Expression<String>? nameFa,
    Expression<String>? nameEn,
    Expression<String>? code,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (departmentId != null) 'department_id': departmentId,
      if (nameFa != null) 'name_fa': nameFa,
      if (nameEn != null) 'name_en': nameEn,
      if (code != null) 'code': code,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsCompanion copyWith(
      {Value<String>? id,
      Value<String>? departmentId,
      Value<String>? nameFa,
      Value<String?>? nameEn,
      Value<String?>? code,
      Value<int>? rowid}) {
    return UnitsCompanion(
      id: id ?? this.id,
      departmentId: departmentId ?? this.departmentId,
      nameFa: nameFa ?? this.nameFa,
      nameEn: nameEn ?? this.nameEn,
      code: code ?? this.code,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (nameFa.present) {
      map['name_fa'] = Variable<String>(nameFa.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('nameFa: $nameFa, ')
          ..write('nameEn: $nameEn, ')
          ..write('code: $code, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fatherNameMeta =
      const VerificationMeta('fatherName');
  @override
  late final GeneratedColumn<String> fatherName = GeneratedColumn<String>(
      'father_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nationalIdMeta =
      const VerificationMeta('nationalId');
  @override
  late final GeneratedColumn<String> nationalId = GeneratedColumn<String>(
      'national_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _birthDateMeta =
      const VerificationMeta('birthDate');
  @override
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
      'birth_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _birthPlaceMeta =
      const VerificationMeta('birthPlace');
  @override
  late final GeneratedColumn<String> birthPlace = GeneratedColumn<String>(
      'birth_place', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _maritalStatusMeta =
      const VerificationMeta('maritalStatus');
  @override
  late final GeneratedColumn<String> maritalStatus = GeneratedColumn<String>(
      'marital_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _childrenCountMeta =
      const VerificationMeta('childrenCount');
  @override
  late final GeneratedColumn<int> childrenCount = GeneratedColumn<int>(
      'children_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _bloodGroupMeta =
      const VerificationMeta('bloodGroup');
  @override
  late final GeneratedColumn<String> bloodGroup = GeneratedColumn<String>(
      'blood_group', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _militaryStatusMeta =
      const VerificationMeta('militaryStatus');
  @override
  late final GeneratedColumn<String> militaryStatus = GeneratedColumn<String>(
      'military_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _personalDescriptionMeta =
      const VerificationMeta('personalDescription');
  @override
  late final GeneratedColumn<String> personalDescription =
      GeneratedColumn<String>('personal_description', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _employeeNumberMeta =
      const VerificationMeta('employeeNumber');
  @override
  late final GeneratedColumn<String> employeeNumber = GeneratedColumn<String>(
      'employee_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subscriptionNumberMeta =
      const VerificationMeta('subscriptionNumber');
  @override
  late final GeneratedColumn<String> subscriptionNumber =
      GeneratedColumn<String>('subscription_number', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _departmentIdMeta =
      const VerificationMeta('departmentId');
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
      'department_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
      'unit_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentPositionMeta =
      const VerificationMeta('currentPosition');
  @override
  late final GeneratedColumn<String> currentPosition = GeneratedColumn<String>(
      'current_position', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _previousPositionMeta =
      const VerificationMeta('previousPosition');
  @override
  late final GeneratedColumn<String> previousPosition = GeneratedColumn<String>(
      'previous_position', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _desiredPositionMeta =
      const VerificationMeta('desiredPosition');
  @override
  late final GeneratedColumn<String> desiredPosition = GeneratedColumn<String>(
      'desired_position', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _employmentTypeMeta =
      const VerificationMeta('employmentType');
  @override
  late final GeneratedColumn<String> employmentType = GeneratedColumn<String>(
      'employment_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _employmentDateMeta =
      const VerificationMeta('employmentDate');
  @override
  late final GeneratedColumn<String> employmentDate = GeneratedColumn<String>(
      'employment_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _supervisorIdMeta =
      const VerificationMeta('supervisorId');
  @override
  late final GeneratedColumn<String> supervisorId = GeneratedColumn<String>(
      'supervisor_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _employmentStatusMeta =
      const VerificationMeta('employmentStatus');
  @override
  late final GeneratedColumn<String> employmentStatus = GeneratedColumn<String>(
      'employment_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _personTypeMeta =
      const VerificationMeta('personType');
  @override
  late final GeneratedColumn<String> personType = GeneratedColumn<String>(
      'person_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('staff'));
  static const VerificationMeta _retirementDateMeta =
      const VerificationMeta('retirementDate');
  @override
  late final GeneratedColumn<String> retirementDate = GeneratedColumn<String>(
      'retirement_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _inactiveReasonMeta =
      const VerificationMeta('inactiveReason');
  @override
  late final GeneratedColumn<String> inactiveReason = GeneratedColumn<String>(
      'inactive_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _jobGroupMeta =
      const VerificationMeta('jobGroup');
  @override
  late final GeneratedColumn<String> jobGroup = GeneratedColumn<String>(
      'job_group', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _positionBaseMeta =
      const VerificationMeta('positionBase');
  @override
  late final GeneratedColumn<double> positionBase = GeneratedColumn<double>(
      'position_base', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _personalBaseMeta =
      const VerificationMeta('personalBase');
  @override
  late final GeneratedColumn<double> personalBase = GeneratedColumn<double>(
      'personal_base', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstName,
        lastName,
        fatherName,
        nationalId,
        birthDate,
        birthPlace,
        gender,
        maritalStatus,
        childrenCount,
        bloodGroup,
        militaryStatus,
        personalDescription,
        photoPath,
        employeeNumber,
        subscriptionNumber,
        departmentId,
        unitId,
        currentPosition,
        previousPosition,
        desiredPosition,
        employmentType,
        employmentDate,
        supervisorId,
        employmentStatus,
        personType,
        retirementDate,
        inactiveReason,
        jobGroup,
        positionBase,
        personalBase,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(Insertable<Employee> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('father_name')) {
      context.handle(
          _fatherNameMeta,
          fatherName.isAcceptableOrUnknown(
              data['father_name']!, _fatherNameMeta));
    }
    if (data.containsKey('national_id')) {
      context.handle(
          _nationalIdMeta,
          nationalId.isAcceptableOrUnknown(
              data['national_id']!, _nationalIdMeta));
    } else if (isInserting) {
      context.missing(_nationalIdMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(_birthDateMeta,
          birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta));
    }
    if (data.containsKey('birth_place')) {
      context.handle(
          _birthPlaceMeta,
          birthPlace.isAcceptableOrUnknown(
              data['birth_place']!, _birthPlaceMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('marital_status')) {
      context.handle(
          _maritalStatusMeta,
          maritalStatus.isAcceptableOrUnknown(
              data['marital_status']!, _maritalStatusMeta));
    }
    if (data.containsKey('children_count')) {
      context.handle(
          _childrenCountMeta,
          childrenCount.isAcceptableOrUnknown(
              data['children_count']!, _childrenCountMeta));
    }
    if (data.containsKey('blood_group')) {
      context.handle(
          _bloodGroupMeta,
          bloodGroup.isAcceptableOrUnknown(
              data['blood_group']!, _bloodGroupMeta));
    }
    if (data.containsKey('military_status')) {
      context.handle(
          _militaryStatusMeta,
          militaryStatus.isAcceptableOrUnknown(
              data['military_status']!, _militaryStatusMeta));
    }
    if (data.containsKey('personal_description')) {
      context.handle(
          _personalDescriptionMeta,
          personalDescription.isAcceptableOrUnknown(
              data['personal_description']!, _personalDescriptionMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('employee_number')) {
      context.handle(
          _employeeNumberMeta,
          employeeNumber.isAcceptableOrUnknown(
              data['employee_number']!, _employeeNumberMeta));
    }
    if (data.containsKey('subscription_number')) {
      context.handle(
          _subscriptionNumberMeta,
          subscriptionNumber.isAcceptableOrUnknown(
              data['subscription_number']!, _subscriptionNumberMeta));
    }
    if (data.containsKey('department_id')) {
      context.handle(
          _departmentIdMeta,
          departmentId.isAcceptableOrUnknown(
              data['department_id']!, _departmentIdMeta));
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    }
    if (data.containsKey('current_position')) {
      context.handle(
          _currentPositionMeta,
          currentPosition.isAcceptableOrUnknown(
              data['current_position']!, _currentPositionMeta));
    }
    if (data.containsKey('previous_position')) {
      context.handle(
          _previousPositionMeta,
          previousPosition.isAcceptableOrUnknown(
              data['previous_position']!, _previousPositionMeta));
    }
    if (data.containsKey('desired_position')) {
      context.handle(
          _desiredPositionMeta,
          desiredPosition.isAcceptableOrUnknown(
              data['desired_position']!, _desiredPositionMeta));
    }
    if (data.containsKey('employment_type')) {
      context.handle(
          _employmentTypeMeta,
          employmentType.isAcceptableOrUnknown(
              data['employment_type']!, _employmentTypeMeta));
    }
    if (data.containsKey('employment_date')) {
      context.handle(
          _employmentDateMeta,
          employmentDate.isAcceptableOrUnknown(
              data['employment_date']!, _employmentDateMeta));
    }
    if (data.containsKey('supervisor_id')) {
      context.handle(
          _supervisorIdMeta,
          supervisorId.isAcceptableOrUnknown(
              data['supervisor_id']!, _supervisorIdMeta));
    }
    if (data.containsKey('employment_status')) {
      context.handle(
          _employmentStatusMeta,
          employmentStatus.isAcceptableOrUnknown(
              data['employment_status']!, _employmentStatusMeta));
    }
    if (data.containsKey('person_type')) {
      context.handle(
          _personTypeMeta,
          personType.isAcceptableOrUnknown(
              data['person_type']!, _personTypeMeta));
    }
    if (data.containsKey('retirement_date')) {
      context.handle(
          _retirementDateMeta,
          retirementDate.isAcceptableOrUnknown(
              data['retirement_date']!, _retirementDateMeta));
    }
    if (data.containsKey('inactive_reason')) {
      context.handle(
          _inactiveReasonMeta,
          inactiveReason.isAcceptableOrUnknown(
              data['inactive_reason']!, _inactiveReasonMeta));
    }
    if (data.containsKey('job_group')) {
      context.handle(_jobGroupMeta,
          jobGroup.isAcceptableOrUnknown(data['job_group']!, _jobGroupMeta));
    }
    if (data.containsKey('position_base')) {
      context.handle(
          _positionBaseMeta,
          positionBase.isAcceptableOrUnknown(
              data['position_base']!, _positionBaseMeta));
    }
    if (data.containsKey('personal_base')) {
      context.handle(
          _personalBaseMeta,
          personalBase.isAcceptableOrUnknown(
              data['personal_base']!, _personalBaseMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      fatherName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}father_name']),
      nationalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}national_id'])!,
      birthDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}birth_date']),
      birthPlace: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}birth_place']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender']),
      maritalStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}marital_status']),
      childrenCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}children_count'])!,
      bloodGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}blood_group']),
      militaryStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}military_status']),
      personalDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}personal_description']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      employeeNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_number']),
      subscriptionNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}subscription_number']),
      departmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}department_id']),
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_id']),
      currentPosition: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_position']),
      previousPosition: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}previous_position']),
      desiredPosition: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}desired_position']),
      employmentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employment_type']),
      employmentDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employment_date']),
      supervisorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supervisor_id']),
      employmentStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}employment_status'])!,
      personType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_type'])!,
      retirementDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}retirement_date']),
      inactiveReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inactive_reason']),
      jobGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}job_group']),
      positionBase: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}position_base']),
      personalBase: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}personal_base']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final String id;
  final String firstName;
  final String lastName;
  final String? fatherName;
  final String nationalId;
  final String? birthDate;
  final String? birthPlace;
  final String? gender;
  final String? maritalStatus;
  final int childrenCount;
  final String? bloodGroup;
  final String? militaryStatus;
  final String? personalDescription;
  final String? photoPath;
  final String? employeeNumber;
  final String? subscriptionNumber;
  final String? departmentId;
  final String? unitId;
  final String? currentPosition;
  final String? previousPosition;
  final String? desiredPosition;
  final String? employmentType;
  final String? employmentDate;
  final String? supervisorId;
  final String employmentStatus;

  /// staff | worker — matches Win7.
  final String personType;
  final String? retirementDate;
  final String? inactiveReason;
  final String? jobGroup;
  final double? positionBase;
  final double? personalBase;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const Employee(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.fatherName,
      required this.nationalId,
      this.birthDate,
      this.birthPlace,
      this.gender,
      this.maritalStatus,
      required this.childrenCount,
      this.bloodGroup,
      this.militaryStatus,
      this.personalDescription,
      this.photoPath,
      this.employeeNumber,
      this.subscriptionNumber,
      this.departmentId,
      this.unitId,
      this.currentPosition,
      this.previousPosition,
      this.desiredPosition,
      this.employmentType,
      this.employmentDate,
      this.supervisorId,
      required this.employmentStatus,
      required this.personType,
      this.retirementDate,
      this.inactiveReason,
      this.jobGroup,
      this.positionBase,
      this.personalBase,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || fatherName != null) {
      map['father_name'] = Variable<String>(fatherName);
    }
    map['national_id'] = Variable<String>(nationalId);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<String>(birthDate);
    }
    if (!nullToAbsent || birthPlace != null) {
      map['birth_place'] = Variable<String>(birthPlace);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || maritalStatus != null) {
      map['marital_status'] = Variable<String>(maritalStatus);
    }
    map['children_count'] = Variable<int>(childrenCount);
    if (!nullToAbsent || bloodGroup != null) {
      map['blood_group'] = Variable<String>(bloodGroup);
    }
    if (!nullToAbsent || militaryStatus != null) {
      map['military_status'] = Variable<String>(militaryStatus);
    }
    if (!nullToAbsent || personalDescription != null) {
      map['personal_description'] = Variable<String>(personalDescription);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || employeeNumber != null) {
      map['employee_number'] = Variable<String>(employeeNumber);
    }
    if (!nullToAbsent || subscriptionNumber != null) {
      map['subscription_number'] = Variable<String>(subscriptionNumber);
    }
    if (!nullToAbsent || departmentId != null) {
      map['department_id'] = Variable<String>(departmentId);
    }
    if (!nullToAbsent || unitId != null) {
      map['unit_id'] = Variable<String>(unitId);
    }
    if (!nullToAbsent || currentPosition != null) {
      map['current_position'] = Variable<String>(currentPosition);
    }
    if (!nullToAbsent || previousPosition != null) {
      map['previous_position'] = Variable<String>(previousPosition);
    }
    if (!nullToAbsent || desiredPosition != null) {
      map['desired_position'] = Variable<String>(desiredPosition);
    }
    if (!nullToAbsent || employmentType != null) {
      map['employment_type'] = Variable<String>(employmentType);
    }
    if (!nullToAbsent || employmentDate != null) {
      map['employment_date'] = Variable<String>(employmentDate);
    }
    if (!nullToAbsent || supervisorId != null) {
      map['supervisor_id'] = Variable<String>(supervisorId);
    }
    map['employment_status'] = Variable<String>(employmentStatus);
    map['person_type'] = Variable<String>(personType);
    if (!nullToAbsent || retirementDate != null) {
      map['retirement_date'] = Variable<String>(retirementDate);
    }
    if (!nullToAbsent || inactiveReason != null) {
      map['inactive_reason'] = Variable<String>(inactiveReason);
    }
    if (!nullToAbsent || jobGroup != null) {
      map['job_group'] = Variable<String>(jobGroup);
    }
    if (!nullToAbsent || positionBase != null) {
      map['position_base'] = Variable<double>(positionBase);
    }
    if (!nullToAbsent || personalBase != null) {
      map['personal_base'] = Variable<double>(personalBase);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      fatherName: fatherName == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherName),
      nationalId: Value(nationalId),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      birthPlace: birthPlace == null && nullToAbsent
          ? const Value.absent()
          : Value(birthPlace),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      maritalStatus: maritalStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(maritalStatus),
      childrenCount: Value(childrenCount),
      bloodGroup: bloodGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodGroup),
      militaryStatus: militaryStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(militaryStatus),
      personalDescription: personalDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(personalDescription),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      employeeNumber: employeeNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeNumber),
      subscriptionNumber: subscriptionNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionNumber),
      departmentId: departmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(departmentId),
      unitId:
          unitId == null && nullToAbsent ? const Value.absent() : Value(unitId),
      currentPosition: currentPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPosition),
      previousPosition: previousPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(previousPosition),
      desiredPosition: desiredPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(desiredPosition),
      employmentType: employmentType == null && nullToAbsent
          ? const Value.absent()
          : Value(employmentType),
      employmentDate: employmentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(employmentDate),
      supervisorId: supervisorId == null && nullToAbsent
          ? const Value.absent()
          : Value(supervisorId),
      employmentStatus: Value(employmentStatus),
      personType: Value(personType),
      retirementDate: retirementDate == null && nullToAbsent
          ? const Value.absent()
          : Value(retirementDate),
      inactiveReason: inactiveReason == null && nullToAbsent
          ? const Value.absent()
          : Value(inactiveReason),
      jobGroup: jobGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(jobGroup),
      positionBase: positionBase == null && nullToAbsent
          ? const Value.absent()
          : Value(positionBase),
      personalBase: personalBase == null && nullToAbsent
          ? const Value.absent()
          : Value(personalBase),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Employee.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      fatherName: serializer.fromJson<String?>(json['fatherName']),
      nationalId: serializer.fromJson<String>(json['nationalId']),
      birthDate: serializer.fromJson<String?>(json['birthDate']),
      birthPlace: serializer.fromJson<String?>(json['birthPlace']),
      gender: serializer.fromJson<String?>(json['gender']),
      maritalStatus: serializer.fromJson<String?>(json['maritalStatus']),
      childrenCount: serializer.fromJson<int>(json['childrenCount']),
      bloodGroup: serializer.fromJson<String?>(json['bloodGroup']),
      militaryStatus: serializer.fromJson<String?>(json['militaryStatus']),
      personalDescription:
          serializer.fromJson<String?>(json['personalDescription']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      employeeNumber: serializer.fromJson<String?>(json['employeeNumber']),
      subscriptionNumber:
          serializer.fromJson<String?>(json['subscriptionNumber']),
      departmentId: serializer.fromJson<String?>(json['departmentId']),
      unitId: serializer.fromJson<String?>(json['unitId']),
      currentPosition: serializer.fromJson<String?>(json['currentPosition']),
      previousPosition: serializer.fromJson<String?>(json['previousPosition']),
      desiredPosition: serializer.fromJson<String?>(json['desiredPosition']),
      employmentType: serializer.fromJson<String?>(json['employmentType']),
      employmentDate: serializer.fromJson<String?>(json['employmentDate']),
      supervisorId: serializer.fromJson<String?>(json['supervisorId']),
      employmentStatus: serializer.fromJson<String>(json['employmentStatus']),
      personType: serializer.fromJson<String>(json['personType']),
      retirementDate: serializer.fromJson<String?>(json['retirementDate']),
      inactiveReason: serializer.fromJson<String?>(json['inactiveReason']),
      jobGroup: serializer.fromJson<String?>(json['jobGroup']),
      positionBase: serializer.fromJson<double?>(json['positionBase']),
      personalBase: serializer.fromJson<double?>(json['personalBase']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'fatherName': serializer.toJson<String?>(fatherName),
      'nationalId': serializer.toJson<String>(nationalId),
      'birthDate': serializer.toJson<String?>(birthDate),
      'birthPlace': serializer.toJson<String?>(birthPlace),
      'gender': serializer.toJson<String?>(gender),
      'maritalStatus': serializer.toJson<String?>(maritalStatus),
      'childrenCount': serializer.toJson<int>(childrenCount),
      'bloodGroup': serializer.toJson<String?>(bloodGroup),
      'militaryStatus': serializer.toJson<String?>(militaryStatus),
      'personalDescription': serializer.toJson<String?>(personalDescription),
      'photoPath': serializer.toJson<String?>(photoPath),
      'employeeNumber': serializer.toJson<String?>(employeeNumber),
      'subscriptionNumber': serializer.toJson<String?>(subscriptionNumber),
      'departmentId': serializer.toJson<String?>(departmentId),
      'unitId': serializer.toJson<String?>(unitId),
      'currentPosition': serializer.toJson<String?>(currentPosition),
      'previousPosition': serializer.toJson<String?>(previousPosition),
      'desiredPosition': serializer.toJson<String?>(desiredPosition),
      'employmentType': serializer.toJson<String?>(employmentType),
      'employmentDate': serializer.toJson<String?>(employmentDate),
      'supervisorId': serializer.toJson<String?>(supervisorId),
      'employmentStatus': serializer.toJson<String>(employmentStatus),
      'personType': serializer.toJson<String>(personType),
      'retirementDate': serializer.toJson<String?>(retirementDate),
      'inactiveReason': serializer.toJson<String?>(inactiveReason),
      'jobGroup': serializer.toJson<String?>(jobGroup),
      'positionBase': serializer.toJson<double?>(positionBase),
      'personalBase': serializer.toJson<double?>(personalBase),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  Employee copyWith(
          {String? id,
          String? firstName,
          String? lastName,
          Value<String?> fatherName = const Value.absent(),
          String? nationalId,
          Value<String?> birthDate = const Value.absent(),
          Value<String?> birthPlace = const Value.absent(),
          Value<String?> gender = const Value.absent(),
          Value<String?> maritalStatus = const Value.absent(),
          int? childrenCount,
          Value<String?> bloodGroup = const Value.absent(),
          Value<String?> militaryStatus = const Value.absent(),
          Value<String?> personalDescription = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          Value<String?> employeeNumber = const Value.absent(),
          Value<String?> subscriptionNumber = const Value.absent(),
          Value<String?> departmentId = const Value.absent(),
          Value<String?> unitId = const Value.absent(),
          Value<String?> currentPosition = const Value.absent(),
          Value<String?> previousPosition = const Value.absent(),
          Value<String?> desiredPosition = const Value.absent(),
          Value<String?> employmentType = const Value.absent(),
          Value<String?> employmentDate = const Value.absent(),
          Value<String?> supervisorId = const Value.absent(),
          String? employmentStatus,
          String? personType,
          Value<String?> retirementDate = const Value.absent(),
          Value<String?> inactiveReason = const Value.absent(),
          Value<String?> jobGroup = const Value.absent(),
          Value<double?> positionBase = const Value.absent(),
          Value<double?> personalBase = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent()}) =>
      Employee(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        fatherName: fatherName.present ? fatherName.value : this.fatherName,
        nationalId: nationalId ?? this.nationalId,
        birthDate: birthDate.present ? birthDate.value : this.birthDate,
        birthPlace: birthPlace.present ? birthPlace.value : this.birthPlace,
        gender: gender.present ? gender.value : this.gender,
        maritalStatus:
            maritalStatus.present ? maritalStatus.value : this.maritalStatus,
        childrenCount: childrenCount ?? this.childrenCount,
        bloodGroup: bloodGroup.present ? bloodGroup.value : this.bloodGroup,
        militaryStatus:
            militaryStatus.present ? militaryStatus.value : this.militaryStatus,
        personalDescription: personalDescription.present
            ? personalDescription.value
            : this.personalDescription,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        employeeNumber:
            employeeNumber.present ? employeeNumber.value : this.employeeNumber,
        subscriptionNumber: subscriptionNumber.present
            ? subscriptionNumber.value
            : this.subscriptionNumber,
        departmentId:
            departmentId.present ? departmentId.value : this.departmentId,
        unitId: unitId.present ? unitId.value : this.unitId,
        currentPosition: currentPosition.present
            ? currentPosition.value
            : this.currentPosition,
        previousPosition: previousPosition.present
            ? previousPosition.value
            : this.previousPosition,
        desiredPosition: desiredPosition.present
            ? desiredPosition.value
            : this.desiredPosition,
        employmentType:
            employmentType.present ? employmentType.value : this.employmentType,
        employmentDate:
            employmentDate.present ? employmentDate.value : this.employmentDate,
        supervisorId:
            supervisorId.present ? supervisorId.value : this.supervisorId,
        employmentStatus: employmentStatus ?? this.employmentStatus,
        personType: personType ?? this.personType,
        retirementDate:
            retirementDate.present ? retirementDate.value : this.retirementDate,
        inactiveReason:
            inactiveReason.present ? inactiveReason.value : this.inactiveReason,
        jobGroup: jobGroup.present ? jobGroup.value : this.jobGroup,
        positionBase:
            positionBase.present ? positionBase.value : this.positionBase,
        personalBase:
            personalBase.present ? personalBase.value : this.personalBase,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      fatherName:
          data.fatherName.present ? data.fatherName.value : this.fatherName,
      nationalId:
          data.nationalId.present ? data.nationalId.value : this.nationalId,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      birthPlace:
          data.birthPlace.present ? data.birthPlace.value : this.birthPlace,
      gender: data.gender.present ? data.gender.value : this.gender,
      maritalStatus: data.maritalStatus.present
          ? data.maritalStatus.value
          : this.maritalStatus,
      childrenCount: data.childrenCount.present
          ? data.childrenCount.value
          : this.childrenCount,
      bloodGroup:
          data.bloodGroup.present ? data.bloodGroup.value : this.bloodGroup,
      militaryStatus: data.militaryStatus.present
          ? data.militaryStatus.value
          : this.militaryStatus,
      personalDescription: data.personalDescription.present
          ? data.personalDescription.value
          : this.personalDescription,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      employeeNumber: data.employeeNumber.present
          ? data.employeeNumber.value
          : this.employeeNumber,
      subscriptionNumber: data.subscriptionNumber.present
          ? data.subscriptionNumber.value
          : this.subscriptionNumber,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      currentPosition: data.currentPosition.present
          ? data.currentPosition.value
          : this.currentPosition,
      previousPosition: data.previousPosition.present
          ? data.previousPosition.value
          : this.previousPosition,
      desiredPosition: data.desiredPosition.present
          ? data.desiredPosition.value
          : this.desiredPosition,
      employmentType: data.employmentType.present
          ? data.employmentType.value
          : this.employmentType,
      employmentDate: data.employmentDate.present
          ? data.employmentDate.value
          : this.employmentDate,
      supervisorId: data.supervisorId.present
          ? data.supervisorId.value
          : this.supervisorId,
      employmentStatus: data.employmentStatus.present
          ? data.employmentStatus.value
          : this.employmentStatus,
      personType:
          data.personType.present ? data.personType.value : this.personType,
      retirementDate: data.retirementDate.present
          ? data.retirementDate.value
          : this.retirementDate,
      inactiveReason: data.inactiveReason.present
          ? data.inactiveReason.value
          : this.inactiveReason,
      jobGroup: data.jobGroup.present ? data.jobGroup.value : this.jobGroup,
      positionBase: data.positionBase.present
          ? data.positionBase.value
          : this.positionBase,
      personalBase: data.personalBase.present
          ? data.personalBase.value
          : this.personalBase,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('fatherName: $fatherName, ')
          ..write('nationalId: $nationalId, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('gender: $gender, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('childrenCount: $childrenCount, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('militaryStatus: $militaryStatus, ')
          ..write('personalDescription: $personalDescription, ')
          ..write('photoPath: $photoPath, ')
          ..write('employeeNumber: $employeeNumber, ')
          ..write('subscriptionNumber: $subscriptionNumber, ')
          ..write('departmentId: $departmentId, ')
          ..write('unitId: $unitId, ')
          ..write('currentPosition: $currentPosition, ')
          ..write('previousPosition: $previousPosition, ')
          ..write('desiredPosition: $desiredPosition, ')
          ..write('employmentType: $employmentType, ')
          ..write('employmentDate: $employmentDate, ')
          ..write('supervisorId: $supervisorId, ')
          ..write('employmentStatus: $employmentStatus, ')
          ..write('personType: $personType, ')
          ..write('retirementDate: $retirementDate, ')
          ..write('inactiveReason: $inactiveReason, ')
          ..write('jobGroup: $jobGroup, ')
          ..write('positionBase: $positionBase, ')
          ..write('personalBase: $personalBase, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        firstName,
        lastName,
        fatherName,
        nationalId,
        birthDate,
        birthPlace,
        gender,
        maritalStatus,
        childrenCount,
        bloodGroup,
        militaryStatus,
        personalDescription,
        photoPath,
        employeeNumber,
        subscriptionNumber,
        departmentId,
        unitId,
        currentPosition,
        previousPosition,
        desiredPosition,
        employmentType,
        employmentDate,
        supervisorId,
        employmentStatus,
        personType,
        retirementDate,
        inactiveReason,
        jobGroup,
        positionBase,
        personalBase,
        createdAt,
        updatedAt,
        deletedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.fatherName == this.fatherName &&
          other.nationalId == this.nationalId &&
          other.birthDate == this.birthDate &&
          other.birthPlace == this.birthPlace &&
          other.gender == this.gender &&
          other.maritalStatus == this.maritalStatus &&
          other.childrenCount == this.childrenCount &&
          other.bloodGroup == this.bloodGroup &&
          other.militaryStatus == this.militaryStatus &&
          other.personalDescription == this.personalDescription &&
          other.photoPath == this.photoPath &&
          other.employeeNumber == this.employeeNumber &&
          other.subscriptionNumber == this.subscriptionNumber &&
          other.departmentId == this.departmentId &&
          other.unitId == this.unitId &&
          other.currentPosition == this.currentPosition &&
          other.previousPosition == this.previousPosition &&
          other.desiredPosition == this.desiredPosition &&
          other.employmentType == this.employmentType &&
          other.employmentDate == this.employmentDate &&
          other.supervisorId == this.supervisorId &&
          other.employmentStatus == this.employmentStatus &&
          other.personType == this.personType &&
          other.retirementDate == this.retirementDate &&
          other.inactiveReason == this.inactiveReason &&
          other.jobGroup == this.jobGroup &&
          other.positionBase == this.positionBase &&
          other.personalBase == this.personalBase &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> fatherName;
  final Value<String> nationalId;
  final Value<String?> birthDate;
  final Value<String?> birthPlace;
  final Value<String?> gender;
  final Value<String?> maritalStatus;
  final Value<int> childrenCount;
  final Value<String?> bloodGroup;
  final Value<String?> militaryStatus;
  final Value<String?> personalDescription;
  final Value<String?> photoPath;
  final Value<String?> employeeNumber;
  final Value<String?> subscriptionNumber;
  final Value<String?> departmentId;
  final Value<String?> unitId;
  final Value<String?> currentPosition;
  final Value<String?> previousPosition;
  final Value<String?> desiredPosition;
  final Value<String?> employmentType;
  final Value<String?> employmentDate;
  final Value<String?> supervisorId;
  final Value<String> employmentStatus;
  final Value<String> personType;
  final Value<String?> retirementDate;
  final Value<String?> inactiveReason;
  final Value<String?> jobGroup;
  final Value<double?> positionBase;
  final Value<double?> personalBase;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.fatherName = const Value.absent(),
    this.nationalId = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.gender = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.childrenCount = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.militaryStatus = const Value.absent(),
    this.personalDescription = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.employeeNumber = const Value.absent(),
    this.subscriptionNumber = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.currentPosition = const Value.absent(),
    this.previousPosition = const Value.absent(),
    this.desiredPosition = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.employmentDate = const Value.absent(),
    this.supervisorId = const Value.absent(),
    this.employmentStatus = const Value.absent(),
    this.personType = const Value.absent(),
    this.retirementDate = const Value.absent(),
    this.inactiveReason = const Value.absent(),
    this.jobGroup = const Value.absent(),
    this.positionBase = const Value.absent(),
    this.personalBase = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeesCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    this.fatherName = const Value.absent(),
    required String nationalId,
    this.birthDate = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.gender = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.childrenCount = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.militaryStatus = const Value.absent(),
    this.personalDescription = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.employeeNumber = const Value.absent(),
    this.subscriptionNumber = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.currentPosition = const Value.absent(),
    this.previousPosition = const Value.absent(),
    this.desiredPosition = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.employmentDate = const Value.absent(),
    this.supervisorId = const Value.absent(),
    this.employmentStatus = const Value.absent(),
    this.personType = const Value.absent(),
    this.retirementDate = const Value.absent(),
    this.inactiveReason = const Value.absent(),
    this.jobGroup = const Value.absent(),
    this.positionBase = const Value.absent(),
    this.personalBase = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        firstName = Value(firstName),
        lastName = Value(lastName),
        nationalId = Value(nationalId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Employee> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? fatherName,
    Expression<String>? nationalId,
    Expression<String>? birthDate,
    Expression<String>? birthPlace,
    Expression<String>? gender,
    Expression<String>? maritalStatus,
    Expression<int>? childrenCount,
    Expression<String>? bloodGroup,
    Expression<String>? militaryStatus,
    Expression<String>? personalDescription,
    Expression<String>? photoPath,
    Expression<String>? employeeNumber,
    Expression<String>? subscriptionNumber,
    Expression<String>? departmentId,
    Expression<String>? unitId,
    Expression<String>? currentPosition,
    Expression<String>? previousPosition,
    Expression<String>? desiredPosition,
    Expression<String>? employmentType,
    Expression<String>? employmentDate,
    Expression<String>? supervisorId,
    Expression<String>? employmentStatus,
    Expression<String>? personType,
    Expression<String>? retirementDate,
    Expression<String>? inactiveReason,
    Expression<String>? jobGroup,
    Expression<double>? positionBase,
    Expression<double>? personalBase,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (fatherName != null) 'father_name': fatherName,
      if (nationalId != null) 'national_id': nationalId,
      if (birthDate != null) 'birth_date': birthDate,
      if (birthPlace != null) 'birth_place': birthPlace,
      if (gender != null) 'gender': gender,
      if (maritalStatus != null) 'marital_status': maritalStatus,
      if (childrenCount != null) 'children_count': childrenCount,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (militaryStatus != null) 'military_status': militaryStatus,
      if (personalDescription != null)
        'personal_description': personalDescription,
      if (photoPath != null) 'photo_path': photoPath,
      if (employeeNumber != null) 'employee_number': employeeNumber,
      if (subscriptionNumber != null) 'subscription_number': subscriptionNumber,
      if (departmentId != null) 'department_id': departmentId,
      if (unitId != null) 'unit_id': unitId,
      if (currentPosition != null) 'current_position': currentPosition,
      if (previousPosition != null) 'previous_position': previousPosition,
      if (desiredPosition != null) 'desired_position': desiredPosition,
      if (employmentType != null) 'employment_type': employmentType,
      if (employmentDate != null) 'employment_date': employmentDate,
      if (supervisorId != null) 'supervisor_id': supervisorId,
      if (employmentStatus != null) 'employment_status': employmentStatus,
      if (personType != null) 'person_type': personType,
      if (retirementDate != null) 'retirement_date': retirementDate,
      if (inactiveReason != null) 'inactive_reason': inactiveReason,
      if (jobGroup != null) 'job_group': jobGroup,
      if (positionBase != null) 'position_base': positionBase,
      if (personalBase != null) 'personal_base': personalBase,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeesCompanion copyWith(
      {Value<String>? id,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String?>? fatherName,
      Value<String>? nationalId,
      Value<String?>? birthDate,
      Value<String?>? birthPlace,
      Value<String?>? gender,
      Value<String?>? maritalStatus,
      Value<int>? childrenCount,
      Value<String?>? bloodGroup,
      Value<String?>? militaryStatus,
      Value<String?>? personalDescription,
      Value<String?>? photoPath,
      Value<String?>? employeeNumber,
      Value<String?>? subscriptionNumber,
      Value<String?>? departmentId,
      Value<String?>? unitId,
      Value<String?>? currentPosition,
      Value<String?>? previousPosition,
      Value<String?>? desiredPosition,
      Value<String?>? employmentType,
      Value<String?>? employmentDate,
      Value<String?>? supervisorId,
      Value<String>? employmentStatus,
      Value<String>? personType,
      Value<String?>? retirementDate,
      Value<String?>? inactiveReason,
      Value<String?>? jobGroup,
      Value<double?>? positionBase,
      Value<double?>? personalBase,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<int>? rowid}) {
    return EmployeesCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fatherName: fatherName ?? this.fatherName,
      nationalId: nationalId ?? this.nationalId,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      gender: gender ?? this.gender,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      childrenCount: childrenCount ?? this.childrenCount,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      militaryStatus: militaryStatus ?? this.militaryStatus,
      personalDescription: personalDescription ?? this.personalDescription,
      photoPath: photoPath ?? this.photoPath,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      subscriptionNumber: subscriptionNumber ?? this.subscriptionNumber,
      departmentId: departmentId ?? this.departmentId,
      unitId: unitId ?? this.unitId,
      currentPosition: currentPosition ?? this.currentPosition,
      previousPosition: previousPosition ?? this.previousPosition,
      desiredPosition: desiredPosition ?? this.desiredPosition,
      employmentType: employmentType ?? this.employmentType,
      employmentDate: employmentDate ?? this.employmentDate,
      supervisorId: supervisorId ?? this.supervisorId,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      personType: personType ?? this.personType,
      retirementDate: retirementDate ?? this.retirementDate,
      inactiveReason: inactiveReason ?? this.inactiveReason,
      jobGroup: jobGroup ?? this.jobGroup,
      positionBase: positionBase ?? this.positionBase,
      personalBase: personalBase ?? this.personalBase,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (fatherName.present) {
      map['father_name'] = Variable<String>(fatherName.value);
    }
    if (nationalId.present) {
      map['national_id'] = Variable<String>(nationalId.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (birthPlace.present) {
      map['birth_place'] = Variable<String>(birthPlace.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (maritalStatus.present) {
      map['marital_status'] = Variable<String>(maritalStatus.value);
    }
    if (childrenCount.present) {
      map['children_count'] = Variable<int>(childrenCount.value);
    }
    if (bloodGroup.present) {
      map['blood_group'] = Variable<String>(bloodGroup.value);
    }
    if (militaryStatus.present) {
      map['military_status'] = Variable<String>(militaryStatus.value);
    }
    if (personalDescription.present) {
      map['personal_description'] = Variable<String>(personalDescription.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (employeeNumber.present) {
      map['employee_number'] = Variable<String>(employeeNumber.value);
    }
    if (subscriptionNumber.present) {
      map['subscription_number'] = Variable<String>(subscriptionNumber.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (currentPosition.present) {
      map['current_position'] = Variable<String>(currentPosition.value);
    }
    if (previousPosition.present) {
      map['previous_position'] = Variable<String>(previousPosition.value);
    }
    if (desiredPosition.present) {
      map['desired_position'] = Variable<String>(desiredPosition.value);
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<String>(employmentType.value);
    }
    if (employmentDate.present) {
      map['employment_date'] = Variable<String>(employmentDate.value);
    }
    if (supervisorId.present) {
      map['supervisor_id'] = Variable<String>(supervisorId.value);
    }
    if (employmentStatus.present) {
      map['employment_status'] = Variable<String>(employmentStatus.value);
    }
    if (personType.present) {
      map['person_type'] = Variable<String>(personType.value);
    }
    if (retirementDate.present) {
      map['retirement_date'] = Variable<String>(retirementDate.value);
    }
    if (inactiveReason.present) {
      map['inactive_reason'] = Variable<String>(inactiveReason.value);
    }
    if (jobGroup.present) {
      map['job_group'] = Variable<String>(jobGroup.value);
    }
    if (positionBase.present) {
      map['position_base'] = Variable<double>(positionBase.value);
    }
    if (personalBase.present) {
      map['personal_base'] = Variable<double>(personalBase.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('fatherName: $fatherName, ')
          ..write('nationalId: $nationalId, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('gender: $gender, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('childrenCount: $childrenCount, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('militaryStatus: $militaryStatus, ')
          ..write('personalDescription: $personalDescription, ')
          ..write('photoPath: $photoPath, ')
          ..write('employeeNumber: $employeeNumber, ')
          ..write('subscriptionNumber: $subscriptionNumber, ')
          ..write('departmentId: $departmentId, ')
          ..write('unitId: $unitId, ')
          ..write('currentPosition: $currentPosition, ')
          ..write('previousPosition: $previousPosition, ')
          ..write('desiredPosition: $desiredPosition, ')
          ..write('employmentType: $employmentType, ')
          ..write('employmentDate: $employmentDate, ')
          ..write('supervisorId: $supervisorId, ')
          ..write('employmentStatus: $employmentStatus, ')
          ..write('personType: $personType, ')
          ..write('retirementDate: $retirementDate, ')
          ..write('inactiveReason: $inactiveReason, ')
          ..write('jobGroup: $jobGroup, ')
          ..write('positionBase: $positionBase, ')
          ..write('personalBase: $personalBase, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeContactsTable extends EmployeeContacts
    with TableInfo<$EmployeeContactsTable, EmployeeContact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _primaryPhoneMeta =
      const VerificationMeta('primaryPhone');
  @override
  late final GeneratedColumn<String> primaryPhone = GeneratedColumn<String>(
      'primary_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _secondaryPhoneMeta =
      const VerificationMeta('secondaryPhone');
  @override
  late final GeneratedColumn<String> secondaryPhone = GeneratedColumn<String>(
      'secondary_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emergencyPhoneMeta =
      const VerificationMeta('emergencyPhone');
  @override
  late final GeneratedColumn<String> emergencyPhone = GeneratedColumn<String>(
      'emergency_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _homeAddressMeta =
      const VerificationMeta('homeAddress');
  @override
  late final GeneratedColumn<String> homeAddress = GeneratedColumn<String>(
      'home_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postalCodeMeta =
      const VerificationMeta('postalCode');
  @override
  late final GeneratedColumn<String> postalCode = GeneratedColumn<String>(
      'postal_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        employeeId,
        primaryPhone,
        secondaryPhone,
        emergencyPhone,
        email,
        homeAddress,
        postalCode
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_contacts';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeContact> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('primary_phone')) {
      context.handle(
          _primaryPhoneMeta,
          primaryPhone.isAcceptableOrUnknown(
              data['primary_phone']!, _primaryPhoneMeta));
    }
    if (data.containsKey('secondary_phone')) {
      context.handle(
          _secondaryPhoneMeta,
          secondaryPhone.isAcceptableOrUnknown(
              data['secondary_phone']!, _secondaryPhoneMeta));
    }
    if (data.containsKey('emergency_phone')) {
      context.handle(
          _emergencyPhoneMeta,
          emergencyPhone.isAcceptableOrUnknown(
              data['emergency_phone']!, _emergencyPhoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('home_address')) {
      context.handle(
          _homeAddressMeta,
          homeAddress.isAcceptableOrUnknown(
              data['home_address']!, _homeAddressMeta));
    }
    if (data.containsKey('postal_code')) {
      context.handle(
          _postalCodeMeta,
          postalCode.isAcceptableOrUnknown(
              data['postal_code']!, _postalCodeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {employeeId};
  @override
  EmployeeContact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeContact(
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      primaryPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}primary_phone']),
      secondaryPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}secondary_phone']),
      emergencyPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emergency_phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      homeAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}home_address']),
      postalCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}postal_code']),
    );
  }

  @override
  $EmployeeContactsTable createAlias(String alias) {
    return $EmployeeContactsTable(attachedDatabase, alias);
  }
}

class EmployeeContact extends DataClass implements Insertable<EmployeeContact> {
  final String employeeId;
  final String? primaryPhone;
  final String? secondaryPhone;
  final String? emergencyPhone;
  final String? email;
  final String? homeAddress;
  final String? postalCode;
  const EmployeeContact(
      {required this.employeeId,
      this.primaryPhone,
      this.secondaryPhone,
      this.emergencyPhone,
      this.email,
      this.homeAddress,
      this.postalCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['employee_id'] = Variable<String>(employeeId);
    if (!nullToAbsent || primaryPhone != null) {
      map['primary_phone'] = Variable<String>(primaryPhone);
    }
    if (!nullToAbsent || secondaryPhone != null) {
      map['secondary_phone'] = Variable<String>(secondaryPhone);
    }
    if (!nullToAbsent || emergencyPhone != null) {
      map['emergency_phone'] = Variable<String>(emergencyPhone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || homeAddress != null) {
      map['home_address'] = Variable<String>(homeAddress);
    }
    if (!nullToAbsent || postalCode != null) {
      map['postal_code'] = Variable<String>(postalCode);
    }
    return map;
  }

  EmployeeContactsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeContactsCompanion(
      employeeId: Value(employeeId),
      primaryPhone: primaryPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryPhone),
      secondaryPhone: secondaryPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryPhone),
      emergencyPhone: emergencyPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyPhone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      homeAddress: homeAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(homeAddress),
      postalCode: postalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(postalCode),
    );
  }

  factory EmployeeContact.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeContact(
      employeeId: serializer.fromJson<String>(json['employeeId']),
      primaryPhone: serializer.fromJson<String?>(json['primaryPhone']),
      secondaryPhone: serializer.fromJson<String?>(json['secondaryPhone']),
      emergencyPhone: serializer.fromJson<String?>(json['emergencyPhone']),
      email: serializer.fromJson<String?>(json['email']),
      homeAddress: serializer.fromJson<String?>(json['homeAddress']),
      postalCode: serializer.fromJson<String?>(json['postalCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'employeeId': serializer.toJson<String>(employeeId),
      'primaryPhone': serializer.toJson<String?>(primaryPhone),
      'secondaryPhone': serializer.toJson<String?>(secondaryPhone),
      'emergencyPhone': serializer.toJson<String?>(emergencyPhone),
      'email': serializer.toJson<String?>(email),
      'homeAddress': serializer.toJson<String?>(homeAddress),
      'postalCode': serializer.toJson<String?>(postalCode),
    };
  }

  EmployeeContact copyWith(
          {String? employeeId,
          Value<String?> primaryPhone = const Value.absent(),
          Value<String?> secondaryPhone = const Value.absent(),
          Value<String?> emergencyPhone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> homeAddress = const Value.absent(),
          Value<String?> postalCode = const Value.absent()}) =>
      EmployeeContact(
        employeeId: employeeId ?? this.employeeId,
        primaryPhone:
            primaryPhone.present ? primaryPhone.value : this.primaryPhone,
        secondaryPhone:
            secondaryPhone.present ? secondaryPhone.value : this.secondaryPhone,
        emergencyPhone:
            emergencyPhone.present ? emergencyPhone.value : this.emergencyPhone,
        email: email.present ? email.value : this.email,
        homeAddress: homeAddress.present ? homeAddress.value : this.homeAddress,
        postalCode: postalCode.present ? postalCode.value : this.postalCode,
      );
  EmployeeContact copyWithCompanion(EmployeeContactsCompanion data) {
    return EmployeeContact(
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      primaryPhone: data.primaryPhone.present
          ? data.primaryPhone.value
          : this.primaryPhone,
      secondaryPhone: data.secondaryPhone.present
          ? data.secondaryPhone.value
          : this.secondaryPhone,
      emergencyPhone: data.emergencyPhone.present
          ? data.emergencyPhone.value
          : this.emergencyPhone,
      email: data.email.present ? data.email.value : this.email,
      homeAddress:
          data.homeAddress.present ? data.homeAddress.value : this.homeAddress,
      postalCode:
          data.postalCode.present ? data.postalCode.value : this.postalCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeContact(')
          ..write('employeeId: $employeeId, ')
          ..write('primaryPhone: $primaryPhone, ')
          ..write('secondaryPhone: $secondaryPhone, ')
          ..write('emergencyPhone: $emergencyPhone, ')
          ..write('email: $email, ')
          ..write('homeAddress: $homeAddress, ')
          ..write('postalCode: $postalCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(employeeId, primaryPhone, secondaryPhone,
      emergencyPhone, email, homeAddress, postalCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeContact &&
          other.employeeId == this.employeeId &&
          other.primaryPhone == this.primaryPhone &&
          other.secondaryPhone == this.secondaryPhone &&
          other.emergencyPhone == this.emergencyPhone &&
          other.email == this.email &&
          other.homeAddress == this.homeAddress &&
          other.postalCode == this.postalCode);
}

class EmployeeContactsCompanion extends UpdateCompanion<EmployeeContact> {
  final Value<String> employeeId;
  final Value<String?> primaryPhone;
  final Value<String?> secondaryPhone;
  final Value<String?> emergencyPhone;
  final Value<String?> email;
  final Value<String?> homeAddress;
  final Value<String?> postalCode;
  final Value<int> rowid;
  const EmployeeContactsCompanion({
    this.employeeId = const Value.absent(),
    this.primaryPhone = const Value.absent(),
    this.secondaryPhone = const Value.absent(),
    this.emergencyPhone = const Value.absent(),
    this.email = const Value.absent(),
    this.homeAddress = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeContactsCompanion.insert({
    required String employeeId,
    this.primaryPhone = const Value.absent(),
    this.secondaryPhone = const Value.absent(),
    this.emergencyPhone = const Value.absent(),
    this.email = const Value.absent(),
    this.homeAddress = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : employeeId = Value(employeeId);
  static Insertable<EmployeeContact> custom({
    Expression<String>? employeeId,
    Expression<String>? primaryPhone,
    Expression<String>? secondaryPhone,
    Expression<String>? emergencyPhone,
    Expression<String>? email,
    Expression<String>? homeAddress,
    Expression<String>? postalCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (employeeId != null) 'employee_id': employeeId,
      if (primaryPhone != null) 'primary_phone': primaryPhone,
      if (secondaryPhone != null) 'secondary_phone': secondaryPhone,
      if (emergencyPhone != null) 'emergency_phone': emergencyPhone,
      if (email != null) 'email': email,
      if (homeAddress != null) 'home_address': homeAddress,
      if (postalCode != null) 'postal_code': postalCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeContactsCompanion copyWith(
      {Value<String>? employeeId,
      Value<String?>? primaryPhone,
      Value<String?>? secondaryPhone,
      Value<String?>? emergencyPhone,
      Value<String?>? email,
      Value<String?>? homeAddress,
      Value<String?>? postalCode,
      Value<int>? rowid}) {
    return EmployeeContactsCompanion(
      employeeId: employeeId ?? this.employeeId,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      email: email ?? this.email,
      homeAddress: homeAddress ?? this.homeAddress,
      postalCode: postalCode ?? this.postalCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (primaryPhone.present) {
      map['primary_phone'] = Variable<String>(primaryPhone.value);
    }
    if (secondaryPhone.present) {
      map['secondary_phone'] = Variable<String>(secondaryPhone.value);
    }
    if (emergencyPhone.present) {
      map['emergency_phone'] = Variable<String>(emergencyPhone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (homeAddress.present) {
      map['home_address'] = Variable<String>(homeAddress.value);
    }
    if (postalCode.present) {
      map['postal_code'] = Variable<String>(postalCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeContactsCompanion(')
          ..write('employeeId: $employeeId, ')
          ..write('primaryPhone: $primaryPhone, ')
          ..write('secondaryPhone: $secondaryPhone, ')
          ..write('emergencyPhone: $emergencyPhone, ')
          ..write('email: $email, ')
          ..write('homeAddress: $homeAddress, ')
          ..write('postalCode: $postalCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeSocialsTable extends EmployeeSocials
    with TableInfo<$EmployeeSocialsTable, EmployeeSocial> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeSocialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _telegramMeta =
      const VerificationMeta('telegram');
  @override
  late final GeneratedColumn<String> telegram = GeneratedColumn<String>(
      'telegram', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _whatsappMeta =
      const VerificationMeta('whatsapp');
  @override
  late final GeneratedColumn<String> whatsapp = GeneratedColumn<String>(
      'whatsapp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _instagramMeta =
      const VerificationMeta('instagram');
  @override
  late final GeneratedColumn<String> instagram = GeneratedColumn<String>(
      'instagram', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _linkedinMeta =
      const VerificationMeta('linkedin');
  @override
  late final GeneratedColumn<String> linkedin = GeneratedColumn<String>(
      'linkedin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _otherLinksJsonMeta =
      const VerificationMeta('otherLinksJson');
  @override
  late final GeneratedColumn<String> otherLinksJson = GeneratedColumn<String>(
      'other_links_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [employeeId, telegram, whatsapp, instagram, linkedin, otherLinksJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_socials';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeSocial> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('telegram')) {
      context.handle(_telegramMeta,
          telegram.isAcceptableOrUnknown(data['telegram']!, _telegramMeta));
    }
    if (data.containsKey('whatsapp')) {
      context.handle(_whatsappMeta,
          whatsapp.isAcceptableOrUnknown(data['whatsapp']!, _whatsappMeta));
    }
    if (data.containsKey('instagram')) {
      context.handle(_instagramMeta,
          instagram.isAcceptableOrUnknown(data['instagram']!, _instagramMeta));
    }
    if (data.containsKey('linkedin')) {
      context.handle(_linkedinMeta,
          linkedin.isAcceptableOrUnknown(data['linkedin']!, _linkedinMeta));
    }
    if (data.containsKey('other_links_json')) {
      context.handle(
          _otherLinksJsonMeta,
          otherLinksJson.isAcceptableOrUnknown(
              data['other_links_json']!, _otherLinksJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {employeeId};
  @override
  EmployeeSocial map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeSocial(
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      telegram: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telegram']),
      whatsapp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}whatsapp']),
      instagram: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instagram']),
      linkedin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}linkedin']),
      otherLinksJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}other_links_json']),
    );
  }

  @override
  $EmployeeSocialsTable createAlias(String alias) {
    return $EmployeeSocialsTable(attachedDatabase, alias);
  }
}

class EmployeeSocial extends DataClass implements Insertable<EmployeeSocial> {
  final String employeeId;
  final String? telegram;
  final String? whatsapp;
  final String? instagram;
  final String? linkedin;
  final String? otherLinksJson;
  const EmployeeSocial(
      {required this.employeeId,
      this.telegram,
      this.whatsapp,
      this.instagram,
      this.linkedin,
      this.otherLinksJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['employee_id'] = Variable<String>(employeeId);
    if (!nullToAbsent || telegram != null) {
      map['telegram'] = Variable<String>(telegram);
    }
    if (!nullToAbsent || whatsapp != null) {
      map['whatsapp'] = Variable<String>(whatsapp);
    }
    if (!nullToAbsent || instagram != null) {
      map['instagram'] = Variable<String>(instagram);
    }
    if (!nullToAbsent || linkedin != null) {
      map['linkedin'] = Variable<String>(linkedin);
    }
    if (!nullToAbsent || otherLinksJson != null) {
      map['other_links_json'] = Variable<String>(otherLinksJson);
    }
    return map;
  }

  EmployeeSocialsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeSocialsCompanion(
      employeeId: Value(employeeId),
      telegram: telegram == null && nullToAbsent
          ? const Value.absent()
          : Value(telegram),
      whatsapp: whatsapp == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsapp),
      instagram: instagram == null && nullToAbsent
          ? const Value.absent()
          : Value(instagram),
      linkedin: linkedin == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedin),
      otherLinksJson: otherLinksJson == null && nullToAbsent
          ? const Value.absent()
          : Value(otherLinksJson),
    );
  }

  factory EmployeeSocial.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeSocial(
      employeeId: serializer.fromJson<String>(json['employeeId']),
      telegram: serializer.fromJson<String?>(json['telegram']),
      whatsapp: serializer.fromJson<String?>(json['whatsapp']),
      instagram: serializer.fromJson<String?>(json['instagram']),
      linkedin: serializer.fromJson<String?>(json['linkedin']),
      otherLinksJson: serializer.fromJson<String?>(json['otherLinksJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'employeeId': serializer.toJson<String>(employeeId),
      'telegram': serializer.toJson<String?>(telegram),
      'whatsapp': serializer.toJson<String?>(whatsapp),
      'instagram': serializer.toJson<String?>(instagram),
      'linkedin': serializer.toJson<String?>(linkedin),
      'otherLinksJson': serializer.toJson<String?>(otherLinksJson),
    };
  }

  EmployeeSocial copyWith(
          {String? employeeId,
          Value<String?> telegram = const Value.absent(),
          Value<String?> whatsapp = const Value.absent(),
          Value<String?> instagram = const Value.absent(),
          Value<String?> linkedin = const Value.absent(),
          Value<String?> otherLinksJson = const Value.absent()}) =>
      EmployeeSocial(
        employeeId: employeeId ?? this.employeeId,
        telegram: telegram.present ? telegram.value : this.telegram,
        whatsapp: whatsapp.present ? whatsapp.value : this.whatsapp,
        instagram: instagram.present ? instagram.value : this.instagram,
        linkedin: linkedin.present ? linkedin.value : this.linkedin,
        otherLinksJson:
            otherLinksJson.present ? otherLinksJson.value : this.otherLinksJson,
      );
  EmployeeSocial copyWithCompanion(EmployeeSocialsCompanion data) {
    return EmployeeSocial(
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      telegram: data.telegram.present ? data.telegram.value : this.telegram,
      whatsapp: data.whatsapp.present ? data.whatsapp.value : this.whatsapp,
      instagram: data.instagram.present ? data.instagram.value : this.instagram,
      linkedin: data.linkedin.present ? data.linkedin.value : this.linkedin,
      otherLinksJson: data.otherLinksJson.present
          ? data.otherLinksJson.value
          : this.otherLinksJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeSocial(')
          ..write('employeeId: $employeeId, ')
          ..write('telegram: $telegram, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('instagram: $instagram, ')
          ..write('linkedin: $linkedin, ')
          ..write('otherLinksJson: $otherLinksJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      employeeId, telegram, whatsapp, instagram, linkedin, otherLinksJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeSocial &&
          other.employeeId == this.employeeId &&
          other.telegram == this.telegram &&
          other.whatsapp == this.whatsapp &&
          other.instagram == this.instagram &&
          other.linkedin == this.linkedin &&
          other.otherLinksJson == this.otherLinksJson);
}

class EmployeeSocialsCompanion extends UpdateCompanion<EmployeeSocial> {
  final Value<String> employeeId;
  final Value<String?> telegram;
  final Value<String?> whatsapp;
  final Value<String?> instagram;
  final Value<String?> linkedin;
  final Value<String?> otherLinksJson;
  final Value<int> rowid;
  const EmployeeSocialsCompanion({
    this.employeeId = const Value.absent(),
    this.telegram = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.instagram = const Value.absent(),
    this.linkedin = const Value.absent(),
    this.otherLinksJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeSocialsCompanion.insert({
    required String employeeId,
    this.telegram = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.instagram = const Value.absent(),
    this.linkedin = const Value.absent(),
    this.otherLinksJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : employeeId = Value(employeeId);
  static Insertable<EmployeeSocial> custom({
    Expression<String>? employeeId,
    Expression<String>? telegram,
    Expression<String>? whatsapp,
    Expression<String>? instagram,
    Expression<String>? linkedin,
    Expression<String>? otherLinksJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (employeeId != null) 'employee_id': employeeId,
      if (telegram != null) 'telegram': telegram,
      if (whatsapp != null) 'whatsapp': whatsapp,
      if (instagram != null) 'instagram': instagram,
      if (linkedin != null) 'linkedin': linkedin,
      if (otherLinksJson != null) 'other_links_json': otherLinksJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeSocialsCompanion copyWith(
      {Value<String>? employeeId,
      Value<String?>? telegram,
      Value<String?>? whatsapp,
      Value<String?>? instagram,
      Value<String?>? linkedin,
      Value<String?>? otherLinksJson,
      Value<int>? rowid}) {
    return EmployeeSocialsCompanion(
      employeeId: employeeId ?? this.employeeId,
      telegram: telegram ?? this.telegram,
      whatsapp: whatsapp ?? this.whatsapp,
      instagram: instagram ?? this.instagram,
      linkedin: linkedin ?? this.linkedin,
      otherLinksJson: otherLinksJson ?? this.otherLinksJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (telegram.present) {
      map['telegram'] = Variable<String>(telegram.value);
    }
    if (whatsapp.present) {
      map['whatsapp'] = Variable<String>(whatsapp.value);
    }
    if (instagram.present) {
      map['instagram'] = Variable<String>(instagram.value);
    }
    if (linkedin.present) {
      map['linkedin'] = Variable<String>(linkedin.value);
    }
    if (otherLinksJson.present) {
      map['other_links_json'] = Variable<String>(otherLinksJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeSocialsCompanion(')
          ..write('employeeId: $employeeId, ')
          ..write('telegram: $telegram, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('instagram: $instagram, ')
          ..write('linkedin: $linkedin, ')
          ..write('otherLinksJson: $otherLinksJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeEducationsTable extends EmployeeEducations
    with TableInfo<$EmployeeEducationsTable, EmployeeEducation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeEducationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _educationLevelMeta =
      const VerificationMeta('educationLevel');
  @override
  late final GeneratedColumn<String> educationLevel = GeneratedColumn<String>(
      'education_level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _majorMeta = const VerificationMeta('major');
  @override
  late final GeneratedColumn<String> major = GeneratedColumn<String>(
      'major', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _universityMeta =
      const VerificationMeta('university');
  @override
  late final GeneratedColumn<String> university = GeneratedColumn<String>(
      'university', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _graduationDateMeta =
      const VerificationMeta('graduationDate');
  @override
  late final GeneratedColumn<String> graduationDate = GeneratedColumn<String>(
      'graduation_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gpaMeta = const VerificationMeta('gpa');
  @override
  late final GeneratedColumn<double> gpa = GeneratedColumn<double>(
      'gpa', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _certificatesMeta =
      const VerificationMeta('certificates');
  @override
  late final GeneratedColumn<String> certificates = GeneratedColumn<String>(
      'certificates', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        employeeId,
        educationLevel,
        major,
        university,
        graduationDate,
        gpa,
        certificates
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_educations';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeEducation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('education_level')) {
      context.handle(
          _educationLevelMeta,
          educationLevel.isAcceptableOrUnknown(
              data['education_level']!, _educationLevelMeta));
    }
    if (data.containsKey('major')) {
      context.handle(
          _majorMeta, major.isAcceptableOrUnknown(data['major']!, _majorMeta));
    }
    if (data.containsKey('university')) {
      context.handle(
          _universityMeta,
          university.isAcceptableOrUnknown(
              data['university']!, _universityMeta));
    }
    if (data.containsKey('graduation_date')) {
      context.handle(
          _graduationDateMeta,
          graduationDate.isAcceptableOrUnknown(
              data['graduation_date']!, _graduationDateMeta));
    }
    if (data.containsKey('gpa')) {
      context.handle(
          _gpaMeta, gpa.isAcceptableOrUnknown(data['gpa']!, _gpaMeta));
    }
    if (data.containsKey('certificates')) {
      context.handle(
          _certificatesMeta,
          certificates.isAcceptableOrUnknown(
              data['certificates']!, _certificatesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeEducation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeEducation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      educationLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}education_level']),
      major: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}major']),
      university: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}university']),
      graduationDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}graduation_date']),
      gpa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gpa']),
      certificates: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}certificates']),
    );
  }

  @override
  $EmployeeEducationsTable createAlias(String alias) {
    return $EmployeeEducationsTable(attachedDatabase, alias);
  }
}

class EmployeeEducation extends DataClass
    implements Insertable<EmployeeEducation> {
  final String id;
  final String employeeId;
  final String? educationLevel;
  final String? major;
  final String? university;
  final String? graduationDate;
  final double? gpa;
  final String? certificates;
  const EmployeeEducation(
      {required this.id,
      required this.employeeId,
      this.educationLevel,
      this.major,
      this.university,
      this.graduationDate,
      this.gpa,
      this.certificates});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    if (!nullToAbsent || educationLevel != null) {
      map['education_level'] = Variable<String>(educationLevel);
    }
    if (!nullToAbsent || major != null) {
      map['major'] = Variable<String>(major);
    }
    if (!nullToAbsent || university != null) {
      map['university'] = Variable<String>(university);
    }
    if (!nullToAbsent || graduationDate != null) {
      map['graduation_date'] = Variable<String>(graduationDate);
    }
    if (!nullToAbsent || gpa != null) {
      map['gpa'] = Variable<double>(gpa);
    }
    if (!nullToAbsent || certificates != null) {
      map['certificates'] = Variable<String>(certificates);
    }
    return map;
  }

  EmployeeEducationsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeEducationsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      educationLevel: educationLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(educationLevel),
      major:
          major == null && nullToAbsent ? const Value.absent() : Value(major),
      university: university == null && nullToAbsent
          ? const Value.absent()
          : Value(university),
      graduationDate: graduationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(graduationDate),
      gpa: gpa == null && nullToAbsent ? const Value.absent() : Value(gpa),
      certificates: certificates == null && nullToAbsent
          ? const Value.absent()
          : Value(certificates),
    );
  }

  factory EmployeeEducation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeEducation(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      educationLevel: serializer.fromJson<String?>(json['educationLevel']),
      major: serializer.fromJson<String?>(json['major']),
      university: serializer.fromJson<String?>(json['university']),
      graduationDate: serializer.fromJson<String?>(json['graduationDate']),
      gpa: serializer.fromJson<double?>(json['gpa']),
      certificates: serializer.fromJson<String?>(json['certificates']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'educationLevel': serializer.toJson<String?>(educationLevel),
      'major': serializer.toJson<String?>(major),
      'university': serializer.toJson<String?>(university),
      'graduationDate': serializer.toJson<String?>(graduationDate),
      'gpa': serializer.toJson<double?>(gpa),
      'certificates': serializer.toJson<String?>(certificates),
    };
  }

  EmployeeEducation copyWith(
          {String? id,
          String? employeeId,
          Value<String?> educationLevel = const Value.absent(),
          Value<String?> major = const Value.absent(),
          Value<String?> university = const Value.absent(),
          Value<String?> graduationDate = const Value.absent(),
          Value<double?> gpa = const Value.absent(),
          Value<String?> certificates = const Value.absent()}) =>
      EmployeeEducation(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        educationLevel:
            educationLevel.present ? educationLevel.value : this.educationLevel,
        major: major.present ? major.value : this.major,
        university: university.present ? university.value : this.university,
        graduationDate:
            graduationDate.present ? graduationDate.value : this.graduationDate,
        gpa: gpa.present ? gpa.value : this.gpa,
        certificates:
            certificates.present ? certificates.value : this.certificates,
      );
  EmployeeEducation copyWithCompanion(EmployeeEducationsCompanion data) {
    return EmployeeEducation(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      educationLevel: data.educationLevel.present
          ? data.educationLevel.value
          : this.educationLevel,
      major: data.major.present ? data.major.value : this.major,
      university:
          data.university.present ? data.university.value : this.university,
      graduationDate: data.graduationDate.present
          ? data.graduationDate.value
          : this.graduationDate,
      gpa: data.gpa.present ? data.gpa.value : this.gpa,
      certificates: data.certificates.present
          ? data.certificates.value
          : this.certificates,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeEducation(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('educationLevel: $educationLevel, ')
          ..write('major: $major, ')
          ..write('university: $university, ')
          ..write('graduationDate: $graduationDate, ')
          ..write('gpa: $gpa, ')
          ..write('certificates: $certificates')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, employeeId, educationLevel, major,
      university, graduationDate, gpa, certificates);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeEducation &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.educationLevel == this.educationLevel &&
          other.major == this.major &&
          other.university == this.university &&
          other.graduationDate == this.graduationDate &&
          other.gpa == this.gpa &&
          other.certificates == this.certificates);
}

class EmployeeEducationsCompanion extends UpdateCompanion<EmployeeEducation> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<String?> educationLevel;
  final Value<String?> major;
  final Value<String?> university;
  final Value<String?> graduationDate;
  final Value<double?> gpa;
  final Value<String?> certificates;
  final Value<int> rowid;
  const EmployeeEducationsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.educationLevel = const Value.absent(),
    this.major = const Value.absent(),
    this.university = const Value.absent(),
    this.graduationDate = const Value.absent(),
    this.gpa = const Value.absent(),
    this.certificates = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeEducationsCompanion.insert({
    required String id,
    required String employeeId,
    this.educationLevel = const Value.absent(),
    this.major = const Value.absent(),
    this.university = const Value.absent(),
    this.graduationDate = const Value.absent(),
    this.gpa = const Value.absent(),
    this.certificates = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId);
  static Insertable<EmployeeEducation> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? educationLevel,
    Expression<String>? major,
    Expression<String>? university,
    Expression<String>? graduationDate,
    Expression<double>? gpa,
    Expression<String>? certificates,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (educationLevel != null) 'education_level': educationLevel,
      if (major != null) 'major': major,
      if (university != null) 'university': university,
      if (graduationDate != null) 'graduation_date': graduationDate,
      if (gpa != null) 'gpa': gpa,
      if (certificates != null) 'certificates': certificates,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeEducationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<String?>? educationLevel,
      Value<String?>? major,
      Value<String?>? university,
      Value<String?>? graduationDate,
      Value<double?>? gpa,
      Value<String?>? certificates,
      Value<int>? rowid}) {
    return EmployeeEducationsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      educationLevel: educationLevel ?? this.educationLevel,
      major: major ?? this.major,
      university: university ?? this.university,
      graduationDate: graduationDate ?? this.graduationDate,
      gpa: gpa ?? this.gpa,
      certificates: certificates ?? this.certificates,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (educationLevel.present) {
      map['education_level'] = Variable<String>(educationLevel.value);
    }
    if (major.present) {
      map['major'] = Variable<String>(major.value);
    }
    if (university.present) {
      map['university'] = Variable<String>(university.value);
    }
    if (graduationDate.present) {
      map['graduation_date'] = Variable<String>(graduationDate.value);
    }
    if (gpa.present) {
      map['gpa'] = Variable<double>(gpa.value);
    }
    if (certificates.present) {
      map['certificates'] = Variable<String>(certificates.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeEducationsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('educationLevel: $educationLevel, ')
          ..write('major: $major, ')
          ..write('university: $university, ')
          ..write('graduationDate: $graduationDate, ')
          ..write('gpa: $gpa, ')
          ..write('certificates: $certificates, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeSkillsTable extends EmployeeSkills
    with TableInfo<$EmployeeSkillsTable, EmployeeSkill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeSkillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _skillNameMeta =
      const VerificationMeta('skillName');
  @override
  late final GeneratedColumn<String> skillName = GeneratedColumn<String>(
      'skill_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _certificateMeta =
      const VerificationMeta('certificate');
  @override
  late final GeneratedColumn<String> certificate = GeneratedColumn<String>(
      'certificate', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<String> expiryDate = GeneratedColumn<String>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attachmentPathMeta =
      const VerificationMeta('attachmentPath');
  @override
  late final GeneratedColumn<String> attachmentPath = GeneratedColumn<String>(
      'attachment_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        employeeId,
        skillName,
        level,
        certificate,
        expiryDate,
        attachmentPath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_skills';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeSkill> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('skill_name')) {
      context.handle(_skillNameMeta,
          skillName.isAcceptableOrUnknown(data['skill_name']!, _skillNameMeta));
    } else if (isInserting) {
      context.missing(_skillNameMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('certificate')) {
      context.handle(
          _certificateMeta,
          certificate.isAcceptableOrUnknown(
              data['certificate']!, _certificateMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('attachment_path')) {
      context.handle(
          _attachmentPathMeta,
          attachmentPath.isAcceptableOrUnknown(
              data['attachment_path']!, _attachmentPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeSkill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeSkill(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      skillName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skill_name'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level']),
      certificate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}certificate']),
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}expiry_date']),
      attachmentPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachment_path']),
    );
  }

  @override
  $EmployeeSkillsTable createAlias(String alias) {
    return $EmployeeSkillsTable(attachedDatabase, alias);
  }
}

class EmployeeSkill extends DataClass implements Insertable<EmployeeSkill> {
  final String id;
  final String employeeId;
  final String skillName;
  final String? level;
  final String? certificate;
  final String? expiryDate;
  final String? attachmentPath;
  const EmployeeSkill(
      {required this.id,
      required this.employeeId,
      required this.skillName,
      this.level,
      this.certificate,
      this.expiryDate,
      this.attachmentPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['skill_name'] = Variable<String>(skillName);
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<String>(level);
    }
    if (!nullToAbsent || certificate != null) {
      map['certificate'] = Variable<String>(certificate);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<String>(expiryDate);
    }
    if (!nullToAbsent || attachmentPath != null) {
      map['attachment_path'] = Variable<String>(attachmentPath);
    }
    return map;
  }

  EmployeeSkillsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeSkillsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      skillName: Value(skillName),
      level:
          level == null && nullToAbsent ? const Value.absent() : Value(level),
      certificate: certificate == null && nullToAbsent
          ? const Value.absent()
          : Value(certificate),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      attachmentPath: attachmentPath == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentPath),
    );
  }

  factory EmployeeSkill.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeSkill(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      skillName: serializer.fromJson<String>(json['skillName']),
      level: serializer.fromJson<String?>(json['level']),
      certificate: serializer.fromJson<String?>(json['certificate']),
      expiryDate: serializer.fromJson<String?>(json['expiryDate']),
      attachmentPath: serializer.fromJson<String?>(json['attachmentPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'skillName': serializer.toJson<String>(skillName),
      'level': serializer.toJson<String?>(level),
      'certificate': serializer.toJson<String?>(certificate),
      'expiryDate': serializer.toJson<String?>(expiryDate),
      'attachmentPath': serializer.toJson<String?>(attachmentPath),
    };
  }

  EmployeeSkill copyWith(
          {String? id,
          String? employeeId,
          String? skillName,
          Value<String?> level = const Value.absent(),
          Value<String?> certificate = const Value.absent(),
          Value<String?> expiryDate = const Value.absent(),
          Value<String?> attachmentPath = const Value.absent()}) =>
      EmployeeSkill(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        skillName: skillName ?? this.skillName,
        level: level.present ? level.value : this.level,
        certificate: certificate.present ? certificate.value : this.certificate,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        attachmentPath:
            attachmentPath.present ? attachmentPath.value : this.attachmentPath,
      );
  EmployeeSkill copyWithCompanion(EmployeeSkillsCompanion data) {
    return EmployeeSkill(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      skillName: data.skillName.present ? data.skillName.value : this.skillName,
      level: data.level.present ? data.level.value : this.level,
      certificate:
          data.certificate.present ? data.certificate.value : this.certificate,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      attachmentPath: data.attachmentPath.present
          ? data.attachmentPath.value
          : this.attachmentPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeSkill(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('skillName: $skillName, ')
          ..write('level: $level, ')
          ..write('certificate: $certificate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('attachmentPath: $attachmentPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, employeeId, skillName, level, certificate,
      expiryDate, attachmentPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeSkill &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.skillName == this.skillName &&
          other.level == this.level &&
          other.certificate == this.certificate &&
          other.expiryDate == this.expiryDate &&
          other.attachmentPath == this.attachmentPath);
}

class EmployeeSkillsCompanion extends UpdateCompanion<EmployeeSkill> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<String> skillName;
  final Value<String?> level;
  final Value<String?> certificate;
  final Value<String?> expiryDate;
  final Value<String?> attachmentPath;
  final Value<int> rowid;
  const EmployeeSkillsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.skillName = const Value.absent(),
    this.level = const Value.absent(),
    this.certificate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.attachmentPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeSkillsCompanion.insert({
    required String id,
    required String employeeId,
    required String skillName,
    this.level = const Value.absent(),
    this.certificate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.attachmentPath = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId),
        skillName = Value(skillName);
  static Insertable<EmployeeSkill> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? skillName,
    Expression<String>? level,
    Expression<String>? certificate,
    Expression<String>? expiryDate,
    Expression<String>? attachmentPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (skillName != null) 'skill_name': skillName,
      if (level != null) 'level': level,
      if (certificate != null) 'certificate': certificate,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (attachmentPath != null) 'attachment_path': attachmentPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeSkillsCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<String>? skillName,
      Value<String?>? level,
      Value<String?>? certificate,
      Value<String?>? expiryDate,
      Value<String?>? attachmentPath,
      Value<int>? rowid}) {
    return EmployeeSkillsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      skillName: skillName ?? this.skillName,
      level: level ?? this.level,
      certificate: certificate ?? this.certificate,
      expiryDate: expiryDate ?? this.expiryDate,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (skillName.present) {
      map['skill_name'] = Variable<String>(skillName.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (certificate.present) {
      map['certificate'] = Variable<String>(certificate.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<String>(expiryDate.value);
    }
    if (attachmentPath.present) {
      map['attachment_path'] = Variable<String>(attachmentPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeSkillsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('skillName: $skillName, ')
          ..write('level: $level, ')
          ..write('certificate: $certificate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('attachmentPath: $attachmentPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeInterestsTable extends EmployeeInterests
    with TableInfo<$EmployeeInterestsTable, EmployeeInterest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeInterestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _careerInterestsMeta =
      const VerificationMeta('careerInterests');
  @override
  late final GeneratedColumn<String> careerInterests = GeneratedColumn<String>(
      'career_interests', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _technicalInterestsMeta =
      const VerificationMeta('technicalInterests');
  @override
  late final GeneratedColumn<String> technicalInterests =
      GeneratedColumn<String>('technical_interests', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _managementInterestsMeta =
      const VerificationMeta('managementInterests');
  @override
  late final GeneratedColumn<String> managementInterests =
      GeneratedColumn<String>('management_interests', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _personalInterestsMeta =
      const VerificationMeta('personalInterests');
  @override
  late final GeneratedColumn<String> personalInterests =
      GeneratedColumn<String>('personal_interests', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _talentAssessmentMeta =
      const VerificationMeta('talentAssessment');
  @override
  late final GeneratedColumn<String> talentAssessment = GeneratedColumn<String>(
      'talent_assessment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _behaviorAssessmentMeta =
      const VerificationMeta('behaviorAssessment');
  @override
  late final GeneratedColumn<String> behaviorAssessment =
      GeneratedColumn<String>('behavior_assessment', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _psychologicalNotesMeta =
      const VerificationMeta('psychologicalNotes');
  @override
  late final GeneratedColumn<String> psychologicalNotes =
      GeneratedColumn<String>('psychological_notes', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _managerNotesMeta =
      const VerificationMeta('managerNotes');
  @override
  late final GeneratedColumn<String> managerNotes = GeneratedColumn<String>(
      'manager_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        employeeId,
        careerInterests,
        technicalInterests,
        managementInterests,
        personalInterests,
        talentAssessment,
        behaviorAssessment,
        psychologicalNotes,
        managerNotes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_interests';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeInterest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('career_interests')) {
      context.handle(
          _careerInterestsMeta,
          careerInterests.isAcceptableOrUnknown(
              data['career_interests']!, _careerInterestsMeta));
    }
    if (data.containsKey('technical_interests')) {
      context.handle(
          _technicalInterestsMeta,
          technicalInterests.isAcceptableOrUnknown(
              data['technical_interests']!, _technicalInterestsMeta));
    }
    if (data.containsKey('management_interests')) {
      context.handle(
          _managementInterestsMeta,
          managementInterests.isAcceptableOrUnknown(
              data['management_interests']!, _managementInterestsMeta));
    }
    if (data.containsKey('personal_interests')) {
      context.handle(
          _personalInterestsMeta,
          personalInterests.isAcceptableOrUnknown(
              data['personal_interests']!, _personalInterestsMeta));
    }
    if (data.containsKey('talent_assessment')) {
      context.handle(
          _talentAssessmentMeta,
          talentAssessment.isAcceptableOrUnknown(
              data['talent_assessment']!, _talentAssessmentMeta));
    }
    if (data.containsKey('behavior_assessment')) {
      context.handle(
          _behaviorAssessmentMeta,
          behaviorAssessment.isAcceptableOrUnknown(
              data['behavior_assessment']!, _behaviorAssessmentMeta));
    }
    if (data.containsKey('psychological_notes')) {
      context.handle(
          _psychologicalNotesMeta,
          psychologicalNotes.isAcceptableOrUnknown(
              data['psychological_notes']!, _psychologicalNotesMeta));
    }
    if (data.containsKey('manager_notes')) {
      context.handle(
          _managerNotesMeta,
          managerNotes.isAcceptableOrUnknown(
              data['manager_notes']!, _managerNotesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {employeeId};
  @override
  EmployeeInterest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeInterest(
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      careerInterests: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}career_interests']),
      technicalInterests: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}technical_interests']),
      managementInterests: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}management_interests']),
      personalInterests: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}personal_interests']),
      talentAssessment: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}talent_assessment']),
      behaviorAssessment: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}behavior_assessment']),
      psychologicalNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}psychological_notes']),
      managerNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manager_notes']),
    );
  }

  @override
  $EmployeeInterestsTable createAlias(String alias) {
    return $EmployeeInterestsTable(attachedDatabase, alias);
  }
}

class EmployeeInterest extends DataClass
    implements Insertable<EmployeeInterest> {
  final String employeeId;
  final String? careerInterests;
  final String? technicalInterests;
  final String? managementInterests;
  final String? personalInterests;
  final String? talentAssessment;
  final String? behaviorAssessment;
  final String? psychologicalNotes;
  final String? managerNotes;
  const EmployeeInterest(
      {required this.employeeId,
      this.careerInterests,
      this.technicalInterests,
      this.managementInterests,
      this.personalInterests,
      this.talentAssessment,
      this.behaviorAssessment,
      this.psychologicalNotes,
      this.managerNotes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['employee_id'] = Variable<String>(employeeId);
    if (!nullToAbsent || careerInterests != null) {
      map['career_interests'] = Variable<String>(careerInterests);
    }
    if (!nullToAbsent || technicalInterests != null) {
      map['technical_interests'] = Variable<String>(technicalInterests);
    }
    if (!nullToAbsent || managementInterests != null) {
      map['management_interests'] = Variable<String>(managementInterests);
    }
    if (!nullToAbsent || personalInterests != null) {
      map['personal_interests'] = Variable<String>(personalInterests);
    }
    if (!nullToAbsent || talentAssessment != null) {
      map['talent_assessment'] = Variable<String>(talentAssessment);
    }
    if (!nullToAbsent || behaviorAssessment != null) {
      map['behavior_assessment'] = Variable<String>(behaviorAssessment);
    }
    if (!nullToAbsent || psychologicalNotes != null) {
      map['psychological_notes'] = Variable<String>(psychologicalNotes);
    }
    if (!nullToAbsent || managerNotes != null) {
      map['manager_notes'] = Variable<String>(managerNotes);
    }
    return map;
  }

  EmployeeInterestsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeInterestsCompanion(
      employeeId: Value(employeeId),
      careerInterests: careerInterests == null && nullToAbsent
          ? const Value.absent()
          : Value(careerInterests),
      technicalInterests: technicalInterests == null && nullToAbsent
          ? const Value.absent()
          : Value(technicalInterests),
      managementInterests: managementInterests == null && nullToAbsent
          ? const Value.absent()
          : Value(managementInterests),
      personalInterests: personalInterests == null && nullToAbsent
          ? const Value.absent()
          : Value(personalInterests),
      talentAssessment: talentAssessment == null && nullToAbsent
          ? const Value.absent()
          : Value(talentAssessment),
      behaviorAssessment: behaviorAssessment == null && nullToAbsent
          ? const Value.absent()
          : Value(behaviorAssessment),
      psychologicalNotes: psychologicalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(psychologicalNotes),
      managerNotes: managerNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(managerNotes),
    );
  }

  factory EmployeeInterest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeInterest(
      employeeId: serializer.fromJson<String>(json['employeeId']),
      careerInterests: serializer.fromJson<String?>(json['careerInterests']),
      technicalInterests:
          serializer.fromJson<String?>(json['technicalInterests']),
      managementInterests:
          serializer.fromJson<String?>(json['managementInterests']),
      personalInterests:
          serializer.fromJson<String?>(json['personalInterests']),
      talentAssessment: serializer.fromJson<String?>(json['talentAssessment']),
      behaviorAssessment:
          serializer.fromJson<String?>(json['behaviorAssessment']),
      psychologicalNotes:
          serializer.fromJson<String?>(json['psychologicalNotes']),
      managerNotes: serializer.fromJson<String?>(json['managerNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'employeeId': serializer.toJson<String>(employeeId),
      'careerInterests': serializer.toJson<String?>(careerInterests),
      'technicalInterests': serializer.toJson<String?>(technicalInterests),
      'managementInterests': serializer.toJson<String?>(managementInterests),
      'personalInterests': serializer.toJson<String?>(personalInterests),
      'talentAssessment': serializer.toJson<String?>(talentAssessment),
      'behaviorAssessment': serializer.toJson<String?>(behaviorAssessment),
      'psychologicalNotes': serializer.toJson<String?>(psychologicalNotes),
      'managerNotes': serializer.toJson<String?>(managerNotes),
    };
  }

  EmployeeInterest copyWith(
          {String? employeeId,
          Value<String?> careerInterests = const Value.absent(),
          Value<String?> technicalInterests = const Value.absent(),
          Value<String?> managementInterests = const Value.absent(),
          Value<String?> personalInterests = const Value.absent(),
          Value<String?> talentAssessment = const Value.absent(),
          Value<String?> behaviorAssessment = const Value.absent(),
          Value<String?> psychologicalNotes = const Value.absent(),
          Value<String?> managerNotes = const Value.absent()}) =>
      EmployeeInterest(
        employeeId: employeeId ?? this.employeeId,
        careerInterests: careerInterests.present
            ? careerInterests.value
            : this.careerInterests,
        technicalInterests: technicalInterests.present
            ? technicalInterests.value
            : this.technicalInterests,
        managementInterests: managementInterests.present
            ? managementInterests.value
            : this.managementInterests,
        personalInterests: personalInterests.present
            ? personalInterests.value
            : this.personalInterests,
        talentAssessment: talentAssessment.present
            ? talentAssessment.value
            : this.talentAssessment,
        behaviorAssessment: behaviorAssessment.present
            ? behaviorAssessment.value
            : this.behaviorAssessment,
        psychologicalNotes: psychologicalNotes.present
            ? psychologicalNotes.value
            : this.psychologicalNotes,
        managerNotes:
            managerNotes.present ? managerNotes.value : this.managerNotes,
      );
  EmployeeInterest copyWithCompanion(EmployeeInterestsCompanion data) {
    return EmployeeInterest(
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      careerInterests: data.careerInterests.present
          ? data.careerInterests.value
          : this.careerInterests,
      technicalInterests: data.technicalInterests.present
          ? data.technicalInterests.value
          : this.technicalInterests,
      managementInterests: data.managementInterests.present
          ? data.managementInterests.value
          : this.managementInterests,
      personalInterests: data.personalInterests.present
          ? data.personalInterests.value
          : this.personalInterests,
      talentAssessment: data.talentAssessment.present
          ? data.talentAssessment.value
          : this.talentAssessment,
      behaviorAssessment: data.behaviorAssessment.present
          ? data.behaviorAssessment.value
          : this.behaviorAssessment,
      psychologicalNotes: data.psychologicalNotes.present
          ? data.psychologicalNotes.value
          : this.psychologicalNotes,
      managerNotes: data.managerNotes.present
          ? data.managerNotes.value
          : this.managerNotes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeInterest(')
          ..write('employeeId: $employeeId, ')
          ..write('careerInterests: $careerInterests, ')
          ..write('technicalInterests: $technicalInterests, ')
          ..write('managementInterests: $managementInterests, ')
          ..write('personalInterests: $personalInterests, ')
          ..write('talentAssessment: $talentAssessment, ')
          ..write('behaviorAssessment: $behaviorAssessment, ')
          ..write('psychologicalNotes: $psychologicalNotes, ')
          ..write('managerNotes: $managerNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      employeeId,
      careerInterests,
      technicalInterests,
      managementInterests,
      personalInterests,
      talentAssessment,
      behaviorAssessment,
      psychologicalNotes,
      managerNotes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeInterest &&
          other.employeeId == this.employeeId &&
          other.careerInterests == this.careerInterests &&
          other.technicalInterests == this.technicalInterests &&
          other.managementInterests == this.managementInterests &&
          other.personalInterests == this.personalInterests &&
          other.talentAssessment == this.talentAssessment &&
          other.behaviorAssessment == this.behaviorAssessment &&
          other.psychologicalNotes == this.psychologicalNotes &&
          other.managerNotes == this.managerNotes);
}

class EmployeeInterestsCompanion extends UpdateCompanion<EmployeeInterest> {
  final Value<String> employeeId;
  final Value<String?> careerInterests;
  final Value<String?> technicalInterests;
  final Value<String?> managementInterests;
  final Value<String?> personalInterests;
  final Value<String?> talentAssessment;
  final Value<String?> behaviorAssessment;
  final Value<String?> psychologicalNotes;
  final Value<String?> managerNotes;
  final Value<int> rowid;
  const EmployeeInterestsCompanion({
    this.employeeId = const Value.absent(),
    this.careerInterests = const Value.absent(),
    this.technicalInterests = const Value.absent(),
    this.managementInterests = const Value.absent(),
    this.personalInterests = const Value.absent(),
    this.talentAssessment = const Value.absent(),
    this.behaviorAssessment = const Value.absent(),
    this.psychologicalNotes = const Value.absent(),
    this.managerNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeInterestsCompanion.insert({
    required String employeeId,
    this.careerInterests = const Value.absent(),
    this.technicalInterests = const Value.absent(),
    this.managementInterests = const Value.absent(),
    this.personalInterests = const Value.absent(),
    this.talentAssessment = const Value.absent(),
    this.behaviorAssessment = const Value.absent(),
    this.psychologicalNotes = const Value.absent(),
    this.managerNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : employeeId = Value(employeeId);
  static Insertable<EmployeeInterest> custom({
    Expression<String>? employeeId,
    Expression<String>? careerInterests,
    Expression<String>? technicalInterests,
    Expression<String>? managementInterests,
    Expression<String>? personalInterests,
    Expression<String>? talentAssessment,
    Expression<String>? behaviorAssessment,
    Expression<String>? psychologicalNotes,
    Expression<String>? managerNotes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (employeeId != null) 'employee_id': employeeId,
      if (careerInterests != null) 'career_interests': careerInterests,
      if (technicalInterests != null) 'technical_interests': technicalInterests,
      if (managementInterests != null)
        'management_interests': managementInterests,
      if (personalInterests != null) 'personal_interests': personalInterests,
      if (talentAssessment != null) 'talent_assessment': talentAssessment,
      if (behaviorAssessment != null) 'behavior_assessment': behaviorAssessment,
      if (psychologicalNotes != null) 'psychological_notes': psychologicalNotes,
      if (managerNotes != null) 'manager_notes': managerNotes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeInterestsCompanion copyWith(
      {Value<String>? employeeId,
      Value<String?>? careerInterests,
      Value<String?>? technicalInterests,
      Value<String?>? managementInterests,
      Value<String?>? personalInterests,
      Value<String?>? talentAssessment,
      Value<String?>? behaviorAssessment,
      Value<String?>? psychologicalNotes,
      Value<String?>? managerNotes,
      Value<int>? rowid}) {
    return EmployeeInterestsCompanion(
      employeeId: employeeId ?? this.employeeId,
      careerInterests: careerInterests ?? this.careerInterests,
      technicalInterests: technicalInterests ?? this.technicalInterests,
      managementInterests: managementInterests ?? this.managementInterests,
      personalInterests: personalInterests ?? this.personalInterests,
      talentAssessment: talentAssessment ?? this.talentAssessment,
      behaviorAssessment: behaviorAssessment ?? this.behaviorAssessment,
      psychologicalNotes: psychologicalNotes ?? this.psychologicalNotes,
      managerNotes: managerNotes ?? this.managerNotes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (careerInterests.present) {
      map['career_interests'] = Variable<String>(careerInterests.value);
    }
    if (technicalInterests.present) {
      map['technical_interests'] = Variable<String>(technicalInterests.value);
    }
    if (managementInterests.present) {
      map['management_interests'] = Variable<String>(managementInterests.value);
    }
    if (personalInterests.present) {
      map['personal_interests'] = Variable<String>(personalInterests.value);
    }
    if (talentAssessment.present) {
      map['talent_assessment'] = Variable<String>(talentAssessment.value);
    }
    if (behaviorAssessment.present) {
      map['behavior_assessment'] = Variable<String>(behaviorAssessment.value);
    }
    if (psychologicalNotes.present) {
      map['psychological_notes'] = Variable<String>(psychologicalNotes.value);
    }
    if (managerNotes.present) {
      map['manager_notes'] = Variable<String>(managerNotes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeInterestsCompanion(')
          ..write('employeeId: $employeeId, ')
          ..write('careerInterests: $careerInterests, ')
          ..write('technicalInterests: $technicalInterests, ')
          ..write('managementInterests: $managementInterests, ')
          ..write('personalInterests: $personalInterests, ')
          ..write('talentAssessment: $talentAssessment, ')
          ..write('behaviorAssessment: $behaviorAssessment, ')
          ..write('psychologicalNotes: $psychologicalNotes, ')
          ..write('managerNotes: $managerNotes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeInsurancesTable extends EmployeeInsurances
    with TableInfo<$EmployeeInsurancesTable, EmployeeInsurance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeInsurancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _responsibilityMeta =
      const VerificationMeta('responsibility');
  @override
  late final GeneratedColumn<String> responsibility = GeneratedColumn<String>(
      'responsibility', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _insuranceNumberMeta =
      const VerificationMeta('insuranceNumber');
  @override
  late final GeneratedColumn<String> insuranceNumber = GeneratedColumn<String>(
      'insurance_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _insuranceTypeMeta =
      const VerificationMeta('insuranceType');
  @override
  late final GeneratedColumn<String> insuranceType = GeneratedColumn<String>(
      'insurance_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _insuranceStatusMeta =
      const VerificationMeta('insuranceStatus');
  @override
  late final GeneratedColumn<String> insuranceStatus = GeneratedColumn<String>(
      'insurance_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _effectiveFromMeta =
      const VerificationMeta('effectiveFrom');
  @override
  late final GeneratedColumn<int> effectiveFrom = GeneratedColumn<int>(
      'effective_from', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _effectiveToMeta =
      const VerificationMeta('effectiveTo');
  @override
  late final GeneratedColumn<int> effectiveTo = GeneratedColumn<int>(
      'effective_to', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        employeeId,
        responsibility,
        insuranceNumber,
        insuranceType,
        insuranceStatus,
        notes,
        effectiveFrom,
        effectiveTo,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_insurances';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeInsurance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('responsibility')) {
      context.handle(
          _responsibilityMeta,
          responsibility.isAcceptableOrUnknown(
              data['responsibility']!, _responsibilityMeta));
    }
    if (data.containsKey('insurance_number')) {
      context.handle(
          _insuranceNumberMeta,
          insuranceNumber.isAcceptableOrUnknown(
              data['insurance_number']!, _insuranceNumberMeta));
    }
    if (data.containsKey('insurance_type')) {
      context.handle(
          _insuranceTypeMeta,
          insuranceType.isAcceptableOrUnknown(
              data['insurance_type']!, _insuranceTypeMeta));
    }
    if (data.containsKey('insurance_status')) {
      context.handle(
          _insuranceStatusMeta,
          insuranceStatus.isAcceptableOrUnknown(
              data['insurance_status']!, _insuranceStatusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('effective_from')) {
      context.handle(
          _effectiveFromMeta,
          effectiveFrom.isAcceptableOrUnknown(
              data['effective_from']!, _effectiveFromMeta));
    }
    if (data.containsKey('effective_to')) {
      context.handle(
          _effectiveToMeta,
          effectiveTo.isAcceptableOrUnknown(
              data['effective_to']!, _effectiveToMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeInsurance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeInsurance(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      responsibility: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}responsibility']),
      insuranceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}insurance_number']),
      insuranceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}insurance_type']),
      insuranceStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}insurance_status']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      effectiveFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}effective_from']),
      effectiveTo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}effective_to']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EmployeeInsurancesTable createAlias(String alias) {
    return $EmployeeInsurancesTable(attachedDatabase, alias);
  }
}

class EmployeeInsurance extends DataClass
    implements Insertable<EmployeeInsurance> {
  final String id;
  final String employeeId;
  final String? responsibility;
  final String? insuranceNumber;
  final String? insuranceType;
  final String? insuranceStatus;
  final String? notes;
  final int? effectiveFrom;
  final int? effectiveTo;
  final int createdAt;
  const EmployeeInsurance(
      {required this.id,
      required this.employeeId,
      this.responsibility,
      this.insuranceNumber,
      this.insuranceType,
      this.insuranceStatus,
      this.notes,
      this.effectiveFrom,
      this.effectiveTo,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    if (!nullToAbsent || responsibility != null) {
      map['responsibility'] = Variable<String>(responsibility);
    }
    if (!nullToAbsent || insuranceNumber != null) {
      map['insurance_number'] = Variable<String>(insuranceNumber);
    }
    if (!nullToAbsent || insuranceType != null) {
      map['insurance_type'] = Variable<String>(insuranceType);
    }
    if (!nullToAbsent || insuranceStatus != null) {
      map['insurance_status'] = Variable<String>(insuranceStatus);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || effectiveFrom != null) {
      map['effective_from'] = Variable<int>(effectiveFrom);
    }
    if (!nullToAbsent || effectiveTo != null) {
      map['effective_to'] = Variable<int>(effectiveTo);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  EmployeeInsurancesCompanion toCompanion(bool nullToAbsent) {
    return EmployeeInsurancesCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      responsibility: responsibility == null && nullToAbsent
          ? const Value.absent()
          : Value(responsibility),
      insuranceNumber: insuranceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceNumber),
      insuranceType: insuranceType == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceType),
      insuranceStatus: insuranceStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceStatus),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      effectiveFrom: effectiveFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveFrom),
      effectiveTo: effectiveTo == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveTo),
      createdAt: Value(createdAt),
    );
  }

  factory EmployeeInsurance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeInsurance(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      responsibility: serializer.fromJson<String?>(json['responsibility']),
      insuranceNumber: serializer.fromJson<String?>(json['insuranceNumber']),
      insuranceType: serializer.fromJson<String?>(json['insuranceType']),
      insuranceStatus: serializer.fromJson<String?>(json['insuranceStatus']),
      notes: serializer.fromJson<String?>(json['notes']),
      effectiveFrom: serializer.fromJson<int?>(json['effectiveFrom']),
      effectiveTo: serializer.fromJson<int?>(json['effectiveTo']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'responsibility': serializer.toJson<String?>(responsibility),
      'insuranceNumber': serializer.toJson<String?>(insuranceNumber),
      'insuranceType': serializer.toJson<String?>(insuranceType),
      'insuranceStatus': serializer.toJson<String?>(insuranceStatus),
      'notes': serializer.toJson<String?>(notes),
      'effectiveFrom': serializer.toJson<int?>(effectiveFrom),
      'effectiveTo': serializer.toJson<int?>(effectiveTo),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  EmployeeInsurance copyWith(
          {String? id,
          String? employeeId,
          Value<String?> responsibility = const Value.absent(),
          Value<String?> insuranceNumber = const Value.absent(),
          Value<String?> insuranceType = const Value.absent(),
          Value<String?> insuranceStatus = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<int?> effectiveFrom = const Value.absent(),
          Value<int?> effectiveTo = const Value.absent(),
          int? createdAt}) =>
      EmployeeInsurance(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        responsibility:
            responsibility.present ? responsibility.value : this.responsibility,
        insuranceNumber: insuranceNumber.present
            ? insuranceNumber.value
            : this.insuranceNumber,
        insuranceType:
            insuranceType.present ? insuranceType.value : this.insuranceType,
        insuranceStatus: insuranceStatus.present
            ? insuranceStatus.value
            : this.insuranceStatus,
        notes: notes.present ? notes.value : this.notes,
        effectiveFrom:
            effectiveFrom.present ? effectiveFrom.value : this.effectiveFrom,
        effectiveTo: effectiveTo.present ? effectiveTo.value : this.effectiveTo,
        createdAt: createdAt ?? this.createdAt,
      );
  EmployeeInsurance copyWithCompanion(EmployeeInsurancesCompanion data) {
    return EmployeeInsurance(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      responsibility: data.responsibility.present
          ? data.responsibility.value
          : this.responsibility,
      insuranceNumber: data.insuranceNumber.present
          ? data.insuranceNumber.value
          : this.insuranceNumber,
      insuranceType: data.insuranceType.present
          ? data.insuranceType.value
          : this.insuranceType,
      insuranceStatus: data.insuranceStatus.present
          ? data.insuranceStatus.value
          : this.insuranceStatus,
      notes: data.notes.present ? data.notes.value : this.notes,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
      effectiveTo:
          data.effectiveTo.present ? data.effectiveTo.value : this.effectiveTo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeInsurance(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('responsibility: $responsibility, ')
          ..write('insuranceNumber: $insuranceNumber, ')
          ..write('insuranceType: $insuranceType, ')
          ..write('insuranceStatus: $insuranceStatus, ')
          ..write('notes: $notes, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      employeeId,
      responsibility,
      insuranceNumber,
      insuranceType,
      insuranceStatus,
      notes,
      effectiveFrom,
      effectiveTo,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeInsurance &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.responsibility == this.responsibility &&
          other.insuranceNumber == this.insuranceNumber &&
          other.insuranceType == this.insuranceType &&
          other.insuranceStatus == this.insuranceStatus &&
          other.notes == this.notes &&
          other.effectiveFrom == this.effectiveFrom &&
          other.effectiveTo == this.effectiveTo &&
          other.createdAt == this.createdAt);
}

class EmployeeInsurancesCompanion extends UpdateCompanion<EmployeeInsurance> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<String?> responsibility;
  final Value<String?> insuranceNumber;
  final Value<String?> insuranceType;
  final Value<String?> insuranceStatus;
  final Value<String?> notes;
  final Value<int?> effectiveFrom;
  final Value<int?> effectiveTo;
  final Value<int> createdAt;
  final Value<int> rowid;
  const EmployeeInsurancesCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.responsibility = const Value.absent(),
    this.insuranceNumber = const Value.absent(),
    this.insuranceType = const Value.absent(),
    this.insuranceStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.effectiveTo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeInsurancesCompanion.insert({
    required String id,
    required String employeeId,
    this.responsibility = const Value.absent(),
    this.insuranceNumber = const Value.absent(),
    this.insuranceType = const Value.absent(),
    this.insuranceStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.effectiveTo = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId),
        createdAt = Value(createdAt);
  static Insertable<EmployeeInsurance> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? responsibility,
    Expression<String>? insuranceNumber,
    Expression<String>? insuranceType,
    Expression<String>? insuranceStatus,
    Expression<String>? notes,
    Expression<int>? effectiveFrom,
    Expression<int>? effectiveTo,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (responsibility != null) 'responsibility': responsibility,
      if (insuranceNumber != null) 'insurance_number': insuranceNumber,
      if (insuranceType != null) 'insurance_type': insuranceType,
      if (insuranceStatus != null) 'insurance_status': insuranceStatus,
      if (notes != null) 'notes': notes,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (effectiveTo != null) 'effective_to': effectiveTo,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeInsurancesCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<String?>? responsibility,
      Value<String?>? insuranceNumber,
      Value<String?>? insuranceType,
      Value<String?>? insuranceStatus,
      Value<String?>? notes,
      Value<int?>? effectiveFrom,
      Value<int?>? effectiveTo,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return EmployeeInsurancesCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      responsibility: responsibility ?? this.responsibility,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      insuranceType: insuranceType ?? this.insuranceType,
      insuranceStatus: insuranceStatus ?? this.insuranceStatus,
      notes: notes ?? this.notes,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (responsibility.present) {
      map['responsibility'] = Variable<String>(responsibility.value);
    }
    if (insuranceNumber.present) {
      map['insurance_number'] = Variable<String>(insuranceNumber.value);
    }
    if (insuranceType.present) {
      map['insurance_type'] = Variable<String>(insuranceType.value);
    }
    if (insuranceStatus.present) {
      map['insurance_status'] = Variable<String>(insuranceStatus.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<int>(effectiveFrom.value);
    }
    if (effectiveTo.present) {
      map['effective_to'] = Variable<int>(effectiveTo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeInsurancesCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('responsibility: $responsibility, ')
          ..write('insuranceNumber: $insuranceNumber, ')
          ..write('insuranceType: $insuranceType, ')
          ..write('insuranceStatus: $insuranceStatus, ')
          ..write('notes: $notes, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeEvaluationsTable extends EmployeeEvaluations
    with TableInfo<$EmployeeEvaluationsTable, EmployeeEvaluation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeEvaluationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
      'score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _evaluatorMeta =
      const VerificationMeta('evaluator');
  @override
  late final GeneratedColumn<String> evaluator = GeneratedColumn<String>(
      'evaluator', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _evaluationDateMeta =
      const VerificationMeta('evaluationDate');
  @override
  late final GeneratedColumn<String> evaluationDate = GeneratedColumn<String>(
      'evaluation_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _strengthsMeta =
      const VerificationMeta('strengths');
  @override
  late final GeneratedColumn<String> strengths = GeneratedColumn<String>(
      'strengths', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weaknessesMeta =
      const VerificationMeta('weaknesses');
  @override
  late final GeneratedColumn<String> weaknesses = GeneratedColumn<String>(
      'weaknesses', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _improvementPlanMeta =
      const VerificationMeta('improvementPlan');
  @override
  late final GeneratedColumn<String> improvementPlan = GeneratedColumn<String>(
      'improvement_plan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attachmentPathMeta =
      const VerificationMeta('attachmentPath');
  @override
  late final GeneratedColumn<String> attachmentPath = GeneratedColumn<String>(
      'attachment_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        employeeId,
        year,
        score,
        evaluator,
        evaluationDate,
        strengths,
        weaknesses,
        improvementPlan,
        attachmentPath,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_evaluations';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeEvaluation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    if (data.containsKey('evaluator')) {
      context.handle(_evaluatorMeta,
          evaluator.isAcceptableOrUnknown(data['evaluator']!, _evaluatorMeta));
    }
    if (data.containsKey('evaluation_date')) {
      context.handle(
          _evaluationDateMeta,
          evaluationDate.isAcceptableOrUnknown(
              data['evaluation_date']!, _evaluationDateMeta));
    }
    if (data.containsKey('strengths')) {
      context.handle(_strengthsMeta,
          strengths.isAcceptableOrUnknown(data['strengths']!, _strengthsMeta));
    }
    if (data.containsKey('weaknesses')) {
      context.handle(
          _weaknessesMeta,
          weaknesses.isAcceptableOrUnknown(
              data['weaknesses']!, _weaknessesMeta));
    }
    if (data.containsKey('improvement_plan')) {
      context.handle(
          _improvementPlanMeta,
          improvementPlan.isAcceptableOrUnknown(
              data['improvement_plan']!, _improvementPlanMeta));
    }
    if (data.containsKey('attachment_path')) {
      context.handle(
          _attachmentPathMeta,
          attachmentPath.isAcceptableOrUnknown(
              data['attachment_path']!, _attachmentPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeEvaluation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeEvaluation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}score']),
      evaluator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evaluator']),
      evaluationDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evaluation_date']),
      strengths: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}strengths']),
      weaknesses: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weaknesses']),
      improvementPlan: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}improvement_plan']),
      attachmentPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachment_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EmployeeEvaluationsTable createAlias(String alias) {
    return $EmployeeEvaluationsTable(attachedDatabase, alias);
  }
}

class EmployeeEvaluation extends DataClass
    implements Insertable<EmployeeEvaluation> {
  final String id;
  final String employeeId;
  final int year;
  final double? score;
  final String? evaluator;
  final String? evaluationDate;
  final String? strengths;
  final String? weaknesses;
  final String? improvementPlan;
  final String? attachmentPath;
  final int createdAt;
  const EmployeeEvaluation(
      {required this.id,
      required this.employeeId,
      required this.year,
      this.score,
      this.evaluator,
      this.evaluationDate,
      this.strengths,
      this.weaknesses,
      this.improvementPlan,
      this.attachmentPath,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['year'] = Variable<int>(year);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<double>(score);
    }
    if (!nullToAbsent || evaluator != null) {
      map['evaluator'] = Variable<String>(evaluator);
    }
    if (!nullToAbsent || evaluationDate != null) {
      map['evaluation_date'] = Variable<String>(evaluationDate);
    }
    if (!nullToAbsent || strengths != null) {
      map['strengths'] = Variable<String>(strengths);
    }
    if (!nullToAbsent || weaknesses != null) {
      map['weaknesses'] = Variable<String>(weaknesses);
    }
    if (!nullToAbsent || improvementPlan != null) {
      map['improvement_plan'] = Variable<String>(improvementPlan);
    }
    if (!nullToAbsent || attachmentPath != null) {
      map['attachment_path'] = Variable<String>(attachmentPath);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  EmployeeEvaluationsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeEvaluationsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      year: Value(year),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      evaluator: evaluator == null && nullToAbsent
          ? const Value.absent()
          : Value(evaluator),
      evaluationDate: evaluationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(evaluationDate),
      strengths: strengths == null && nullToAbsent
          ? const Value.absent()
          : Value(strengths),
      weaknesses: weaknesses == null && nullToAbsent
          ? const Value.absent()
          : Value(weaknesses),
      improvementPlan: improvementPlan == null && nullToAbsent
          ? const Value.absent()
          : Value(improvementPlan),
      attachmentPath: attachmentPath == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentPath),
      createdAt: Value(createdAt),
    );
  }

  factory EmployeeEvaluation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeEvaluation(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      year: serializer.fromJson<int>(json['year']),
      score: serializer.fromJson<double?>(json['score']),
      evaluator: serializer.fromJson<String?>(json['evaluator']),
      evaluationDate: serializer.fromJson<String?>(json['evaluationDate']),
      strengths: serializer.fromJson<String?>(json['strengths']),
      weaknesses: serializer.fromJson<String?>(json['weaknesses']),
      improvementPlan: serializer.fromJson<String?>(json['improvementPlan']),
      attachmentPath: serializer.fromJson<String?>(json['attachmentPath']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'year': serializer.toJson<int>(year),
      'score': serializer.toJson<double?>(score),
      'evaluator': serializer.toJson<String?>(evaluator),
      'evaluationDate': serializer.toJson<String?>(evaluationDate),
      'strengths': serializer.toJson<String?>(strengths),
      'weaknesses': serializer.toJson<String?>(weaknesses),
      'improvementPlan': serializer.toJson<String?>(improvementPlan),
      'attachmentPath': serializer.toJson<String?>(attachmentPath),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  EmployeeEvaluation copyWith(
          {String? id,
          String? employeeId,
          int? year,
          Value<double?> score = const Value.absent(),
          Value<String?> evaluator = const Value.absent(),
          Value<String?> evaluationDate = const Value.absent(),
          Value<String?> strengths = const Value.absent(),
          Value<String?> weaknesses = const Value.absent(),
          Value<String?> improvementPlan = const Value.absent(),
          Value<String?> attachmentPath = const Value.absent(),
          int? createdAt}) =>
      EmployeeEvaluation(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        year: year ?? this.year,
        score: score.present ? score.value : this.score,
        evaluator: evaluator.present ? evaluator.value : this.evaluator,
        evaluationDate:
            evaluationDate.present ? evaluationDate.value : this.evaluationDate,
        strengths: strengths.present ? strengths.value : this.strengths,
        weaknesses: weaknesses.present ? weaknesses.value : this.weaknesses,
        improvementPlan: improvementPlan.present
            ? improvementPlan.value
            : this.improvementPlan,
        attachmentPath:
            attachmentPath.present ? attachmentPath.value : this.attachmentPath,
        createdAt: createdAt ?? this.createdAt,
      );
  EmployeeEvaluation copyWithCompanion(EmployeeEvaluationsCompanion data) {
    return EmployeeEvaluation(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      year: data.year.present ? data.year.value : this.year,
      score: data.score.present ? data.score.value : this.score,
      evaluator: data.evaluator.present ? data.evaluator.value : this.evaluator,
      evaluationDate: data.evaluationDate.present
          ? data.evaluationDate.value
          : this.evaluationDate,
      strengths: data.strengths.present ? data.strengths.value : this.strengths,
      weaknesses:
          data.weaknesses.present ? data.weaknesses.value : this.weaknesses,
      improvementPlan: data.improvementPlan.present
          ? data.improvementPlan.value
          : this.improvementPlan,
      attachmentPath: data.attachmentPath.present
          ? data.attachmentPath.value
          : this.attachmentPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeEvaluation(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('year: $year, ')
          ..write('score: $score, ')
          ..write('evaluator: $evaluator, ')
          ..write('evaluationDate: $evaluationDate, ')
          ..write('strengths: $strengths, ')
          ..write('weaknesses: $weaknesses, ')
          ..write('improvementPlan: $improvementPlan, ')
          ..write('attachmentPath: $attachmentPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      employeeId,
      year,
      score,
      evaluator,
      evaluationDate,
      strengths,
      weaknesses,
      improvementPlan,
      attachmentPath,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeEvaluation &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.year == this.year &&
          other.score == this.score &&
          other.evaluator == this.evaluator &&
          other.evaluationDate == this.evaluationDate &&
          other.strengths == this.strengths &&
          other.weaknesses == this.weaknesses &&
          other.improvementPlan == this.improvementPlan &&
          other.attachmentPath == this.attachmentPath &&
          other.createdAt == this.createdAt);
}

class EmployeeEvaluationsCompanion extends UpdateCompanion<EmployeeEvaluation> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<int> year;
  final Value<double?> score;
  final Value<String?> evaluator;
  final Value<String?> evaluationDate;
  final Value<String?> strengths;
  final Value<String?> weaknesses;
  final Value<String?> improvementPlan;
  final Value<String?> attachmentPath;
  final Value<int> createdAt;
  final Value<int> rowid;
  const EmployeeEvaluationsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.year = const Value.absent(),
    this.score = const Value.absent(),
    this.evaluator = const Value.absent(),
    this.evaluationDate = const Value.absent(),
    this.strengths = const Value.absent(),
    this.weaknesses = const Value.absent(),
    this.improvementPlan = const Value.absent(),
    this.attachmentPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeEvaluationsCompanion.insert({
    required String id,
    required String employeeId,
    required int year,
    this.score = const Value.absent(),
    this.evaluator = const Value.absent(),
    this.evaluationDate = const Value.absent(),
    this.strengths = const Value.absent(),
    this.weaknesses = const Value.absent(),
    this.improvementPlan = const Value.absent(),
    this.attachmentPath = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId),
        year = Value(year),
        createdAt = Value(createdAt);
  static Insertable<EmployeeEvaluation> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<int>? year,
    Expression<double>? score,
    Expression<String>? evaluator,
    Expression<String>? evaluationDate,
    Expression<String>? strengths,
    Expression<String>? weaknesses,
    Expression<String>? improvementPlan,
    Expression<String>? attachmentPath,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (year != null) 'year': year,
      if (score != null) 'score': score,
      if (evaluator != null) 'evaluator': evaluator,
      if (evaluationDate != null) 'evaluation_date': evaluationDate,
      if (strengths != null) 'strengths': strengths,
      if (weaknesses != null) 'weaknesses': weaknesses,
      if (improvementPlan != null) 'improvement_plan': improvementPlan,
      if (attachmentPath != null) 'attachment_path': attachmentPath,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeEvaluationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<int>? year,
      Value<double?>? score,
      Value<String?>? evaluator,
      Value<String?>? evaluationDate,
      Value<String?>? strengths,
      Value<String?>? weaknesses,
      Value<String?>? improvementPlan,
      Value<String?>? attachmentPath,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return EmployeeEvaluationsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      year: year ?? this.year,
      score: score ?? this.score,
      evaluator: evaluator ?? this.evaluator,
      evaluationDate: evaluationDate ?? this.evaluationDate,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      improvementPlan: improvementPlan ?? this.improvementPlan,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (evaluator.present) {
      map['evaluator'] = Variable<String>(evaluator.value);
    }
    if (evaluationDate.present) {
      map['evaluation_date'] = Variable<String>(evaluationDate.value);
    }
    if (strengths.present) {
      map['strengths'] = Variable<String>(strengths.value);
    }
    if (weaknesses.present) {
      map['weaknesses'] = Variable<String>(weaknesses.value);
    }
    if (improvementPlan.present) {
      map['improvement_plan'] = Variable<String>(improvementPlan.value);
    }
    if (attachmentPath.present) {
      map['attachment_path'] = Variable<String>(attachmentPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeEvaluationsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('year: $year, ')
          ..write('score: $score, ')
          ..write('evaluator: $evaluator, ')
          ..write('evaluationDate: $evaluationDate, ')
          ..write('strengths: $strengths, ')
          ..write('weaknesses: $weaknesses, ')
          ..write('improvementPlan: $improvementPlan, ')
          ..write('attachmentPath: $attachmentPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeDocumentsTable extends EmployeeDocuments
    with TableInfo<$EmployeeDocumentsTable, EmployeeDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsJsonMeta =
      const VerificationMeta('tagsJson');
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
      'tags_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _storagePathMeta =
      const VerificationMeta('storagePath');
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
      'storage_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentHashMeta =
      const VerificationMeta('contentHash');
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
      'content_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _uploadedByMeta =
      const VerificationMeta('uploadedBy');
  @override
  late final GeneratedColumn<String> uploadedBy = GeneratedColumn<String>(
      'uploaded_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uploadedAtMeta =
      const VerificationMeta('uploadedAt');
  @override
  late final GeneratedColumn<int> uploadedAt = GeneratedColumn<int>(
      'uploaded_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        employeeId,
        title,
        category,
        description,
        tagsJson,
        fileName,
        mimeType,
        fileSize,
        storagePath,
        contentHash,
        version,
        uploadedBy,
        uploadedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_documents';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeDocument> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('tags_json')) {
      context.handle(_tagsJsonMeta,
          tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('storage_path')) {
      context.handle(
          _storagePathMeta,
          storagePath.isAcceptableOrUnknown(
              data['storage_path']!, _storagePathMeta));
    } else if (isInserting) {
      context.missing(_storagePathMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
          _contentHashMeta,
          contentHash.isAcceptableOrUnknown(
              data['content_hash']!, _contentHashMeta));
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('uploaded_by')) {
      context.handle(
          _uploadedByMeta,
          uploadedBy.isAcceptableOrUnknown(
              data['uploaded_by']!, _uploadedByMeta));
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
          _uploadedAtMeta,
          uploadedAt.isAcceptableOrUnknown(
              data['uploaded_at']!, _uploadedAtMeta));
    } else if (isInserting) {
      context.missing(_uploadedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeDocument(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      tagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_json']),
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type'])!,
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size'])!,
      storagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}storage_path'])!,
      contentHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_hash'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      uploadedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uploaded_by']),
      uploadedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}uploaded_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $EmployeeDocumentsTable createAlias(String alias) {
    return $EmployeeDocumentsTable(attachedDatabase, alias);
  }
}

class EmployeeDocument extends DataClass
    implements Insertable<EmployeeDocument> {
  final String id;
  final String employeeId;
  final String title;
  final String category;
  final String? description;
  final String? tagsJson;
  final String fileName;
  final String mimeType;
  final int fileSize;
  final String storagePath;
  final String contentHash;
  final int version;
  final String? uploadedBy;
  final int uploadedAt;
  final int? deletedAt;
  const EmployeeDocument(
      {required this.id,
      required this.employeeId,
      required this.title,
      required this.category,
      this.description,
      this.tagsJson,
      required this.fileName,
      required this.mimeType,
      required this.fileSize,
      required this.storagePath,
      required this.contentHash,
      required this.version,
      this.uploadedBy,
      required this.uploadedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || tagsJson != null) {
      map['tags_json'] = Variable<String>(tagsJson);
    }
    map['file_name'] = Variable<String>(fileName);
    map['mime_type'] = Variable<String>(mimeType);
    map['file_size'] = Variable<int>(fileSize);
    map['storage_path'] = Variable<String>(storagePath);
    map['content_hash'] = Variable<String>(contentHash);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || uploadedBy != null) {
      map['uploaded_by'] = Variable<String>(uploadedBy);
    }
    map['uploaded_at'] = Variable<int>(uploadedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  EmployeeDocumentsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeDocumentsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      title: Value(title),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      tagsJson: tagsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(tagsJson),
      fileName: Value(fileName),
      mimeType: Value(mimeType),
      fileSize: Value(fileSize),
      storagePath: Value(storagePath),
      contentHash: Value(contentHash),
      version: Value(version),
      uploadedBy: uploadedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadedBy),
      uploadedAt: Value(uploadedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EmployeeDocument.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeDocument(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      tagsJson: serializer.fromJson<String?>(json['tagsJson']),
      fileName: serializer.fromJson<String>(json['fileName']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      storagePath: serializer.fromJson<String>(json['storagePath']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      version: serializer.fromJson<int>(json['version']),
      uploadedBy: serializer.fromJson<String?>(json['uploadedBy']),
      uploadedAt: serializer.fromJson<int>(json['uploadedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'tagsJson': serializer.toJson<String?>(tagsJson),
      'fileName': serializer.toJson<String>(fileName),
      'mimeType': serializer.toJson<String>(mimeType),
      'fileSize': serializer.toJson<int>(fileSize),
      'storagePath': serializer.toJson<String>(storagePath),
      'contentHash': serializer.toJson<String>(contentHash),
      'version': serializer.toJson<int>(version),
      'uploadedBy': serializer.toJson<String?>(uploadedBy),
      'uploadedAt': serializer.toJson<int>(uploadedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  EmployeeDocument copyWith(
          {String? id,
          String? employeeId,
          String? title,
          String? category,
          Value<String?> description = const Value.absent(),
          Value<String?> tagsJson = const Value.absent(),
          String? fileName,
          String? mimeType,
          int? fileSize,
          String? storagePath,
          String? contentHash,
          int? version,
          Value<String?> uploadedBy = const Value.absent(),
          int? uploadedAt,
          Value<int?> deletedAt = const Value.absent()}) =>
      EmployeeDocument(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        title: title ?? this.title,
        category: category ?? this.category,
        description: description.present ? description.value : this.description,
        tagsJson: tagsJson.present ? tagsJson.value : this.tagsJson,
        fileName: fileName ?? this.fileName,
        mimeType: mimeType ?? this.mimeType,
        fileSize: fileSize ?? this.fileSize,
        storagePath: storagePath ?? this.storagePath,
        contentHash: contentHash ?? this.contentHash,
        version: version ?? this.version,
        uploadedBy: uploadedBy.present ? uploadedBy.value : this.uploadedBy,
        uploadedAt: uploadedAt ?? this.uploadedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  EmployeeDocument copyWithCompanion(EmployeeDocumentsCompanion data) {
    return EmployeeDocument(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      description:
          data.description.present ? data.description.value : this.description,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      storagePath:
          data.storagePath.present ? data.storagePath.value : this.storagePath,
      contentHash:
          data.contentHash.present ? data.contentHash.value : this.contentHash,
      version: data.version.present ? data.version.value : this.version,
      uploadedBy:
          data.uploadedBy.present ? data.uploadedBy.value : this.uploadedBy,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeDocument(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('storagePath: $storagePath, ')
          ..write('contentHash: $contentHash, ')
          ..write('version: $version, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      employeeId,
      title,
      category,
      description,
      tagsJson,
      fileName,
      mimeType,
      fileSize,
      storagePath,
      contentHash,
      version,
      uploadedBy,
      uploadedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeDocument &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.title == this.title &&
          other.category == this.category &&
          other.description == this.description &&
          other.tagsJson == this.tagsJson &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType &&
          other.fileSize == this.fileSize &&
          other.storagePath == this.storagePath &&
          other.contentHash == this.contentHash &&
          other.version == this.version &&
          other.uploadedBy == this.uploadedBy &&
          other.uploadedAt == this.uploadedAt &&
          other.deletedAt == this.deletedAt);
}

class EmployeeDocumentsCompanion extends UpdateCompanion<EmployeeDocument> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<String> title;
  final Value<String> category;
  final Value<String?> description;
  final Value<String?> tagsJson;
  final Value<String> fileName;
  final Value<String> mimeType;
  final Value<int> fileSize;
  final Value<String> storagePath;
  final Value<String> contentHash;
  final Value<int> version;
  final Value<String?> uploadedBy;
  final Value<int> uploadedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const EmployeeDocumentsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.version = const Value.absent(),
    this.uploadedBy = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeDocumentsCompanion.insert({
    required String id,
    required String employeeId,
    required String title,
    required String category,
    this.description = const Value.absent(),
    this.tagsJson = const Value.absent(),
    required String fileName,
    required String mimeType,
    required int fileSize,
    required String storagePath,
    required String contentHash,
    this.version = const Value.absent(),
    this.uploadedBy = const Value.absent(),
    required int uploadedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId),
        title = Value(title),
        category = Value(category),
        fileName = Value(fileName),
        mimeType = Value(mimeType),
        fileSize = Value(fileSize),
        storagePath = Value(storagePath),
        contentHash = Value(contentHash),
        uploadedAt = Value(uploadedAt);
  static Insertable<EmployeeDocument> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? tagsJson,
    Expression<String>? fileName,
    Expression<String>? mimeType,
    Expression<int>? fileSize,
    Expression<String>? storagePath,
    Expression<String>? contentHash,
    Expression<int>? version,
    Expression<String>? uploadedBy,
    Expression<int>? uploadedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (fileSize != null) 'file_size': fileSize,
      if (storagePath != null) 'storage_path': storagePath,
      if (contentHash != null) 'content_hash': contentHash,
      if (version != null) 'version': version,
      if (uploadedBy != null) 'uploaded_by': uploadedBy,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeDocumentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<String>? title,
      Value<String>? category,
      Value<String?>? description,
      Value<String?>? tagsJson,
      Value<String>? fileName,
      Value<String>? mimeType,
      Value<int>? fileSize,
      Value<String>? storagePath,
      Value<String>? contentHash,
      Value<int>? version,
      Value<String?>? uploadedBy,
      Value<int>? uploadedAt,
      Value<int?>? deletedAt,
      Value<int>? rowid}) {
    return EmployeeDocumentsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      tagsJson: tagsJson ?? this.tagsJson,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      storagePath: storagePath ?? this.storagePath,
      contentHash: contentHash ?? this.contentHash,
      version: version ?? this.version,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (uploadedBy.present) {
      map['uploaded_by'] = Variable<String>(uploadedBy.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<int>(uploadedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('storagePath: $storagePath, ')
          ..write('contentHash: $contentHash, ')
          ..write('version: $version, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeGroupsTable extends EmployeeGroups
    with TableInfo<$EmployeeGroupsTable, EmployeeGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purposeTypeMeta =
      const VerificationMeta('purposeType');
  @override
  late final GeneratedColumn<String> purposeType = GeneratedColumn<String>(
      'purpose_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startsAtMeta =
      const VerificationMeta('startsAt');
  @override
  late final GeneratedColumn<int> startsAt = GeneratedColumn<int>(
      'starts_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _endsAtMeta = const VerificationMeta('endsAt');
  @override
  late final GeneratedColumn<int> endsAt = GeneratedColumn<int>(
      'ends_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        purposeType,
        startsAt,
        endsAt,
        status,
        photoPath,
        createdBy,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_groups';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('purpose_type')) {
      context.handle(
          _purposeTypeMeta,
          purposeType.isAcceptableOrUnknown(
              data['purpose_type']!, _purposeTypeMeta));
    } else if (isInserting) {
      context.missing(_purposeTypeMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(_startsAtMeta,
          startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta));
    }
    if (data.containsKey('ends_at')) {
      context.handle(_endsAtMeta,
          endsAt.isAcceptableOrUnknown(data['ends_at']!, _endsAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      purposeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purpose_type'])!,
      startsAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}starts_at']),
      endsAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ends_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $EmployeeGroupsTable createAlias(String alias) {
    return $EmployeeGroupsTable(attachedDatabase, alias);
  }
}

class EmployeeGroup extends DataClass implements Insertable<EmployeeGroup> {
  final String id;
  final String name;
  final String? description;
  final String purposeType;
  final int? startsAt;
  final int? endsAt;
  final String status;
  final String? photoPath;
  final String? createdBy;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const EmployeeGroup(
      {required this.id,
      required this.name,
      this.description,
      required this.purposeType,
      this.startsAt,
      this.endsAt,
      required this.status,
      this.photoPath,
      this.createdBy,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['purpose_type'] = Variable<String>(purposeType);
    if (!nullToAbsent || startsAt != null) {
      map['starts_at'] = Variable<int>(startsAt);
    }
    if (!nullToAbsent || endsAt != null) {
      map['ends_at'] = Variable<int>(endsAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  EmployeeGroupsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeGroupsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      purposeType: Value(purposeType),
      startsAt: startsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startsAt),
      endsAt:
          endsAt == null && nullToAbsent ? const Value.absent() : Value(endsAt),
      status: Value(status),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EmployeeGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeGroup(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      purposeType: serializer.fromJson<String>(json['purposeType']),
      startsAt: serializer.fromJson<int?>(json['startsAt']),
      endsAt: serializer.fromJson<int?>(json['endsAt']),
      status: serializer.fromJson<String>(json['status']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'purposeType': serializer.toJson<String>(purposeType),
      'startsAt': serializer.toJson<int?>(startsAt),
      'endsAt': serializer.toJson<int?>(endsAt),
      'status': serializer.toJson<String>(status),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdBy': serializer.toJson<String?>(createdBy),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  EmployeeGroup copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          String? purposeType,
          Value<int?> startsAt = const Value.absent(),
          Value<int?> endsAt = const Value.absent(),
          String? status,
          Value<String?> photoPath = const Value.absent(),
          Value<String?> createdBy = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          Value<int?> deletedAt = const Value.absent()}) =>
      EmployeeGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        purposeType: purposeType ?? this.purposeType,
        startsAt: startsAt.present ? startsAt.value : this.startsAt,
        endsAt: endsAt.present ? endsAt.value : this.endsAt,
        status: status ?? this.status,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  EmployeeGroup copyWithCompanion(EmployeeGroupsCompanion data) {
    return EmployeeGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      purposeType:
          data.purposeType.present ? data.purposeType.value : this.purposeType,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      endsAt: data.endsAt.present ? data.endsAt.value : this.endsAt,
      status: data.status.present ? data.status.value : this.status,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('purposeType: $purposeType, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('status: $status, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, purposeType, startsAt,
      endsAt, status, photoPath, createdBy, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.purposeType == this.purposeType &&
          other.startsAt == this.startsAt &&
          other.endsAt == this.endsAt &&
          other.status == this.status &&
          other.photoPath == this.photoPath &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class EmployeeGroupsCompanion extends UpdateCompanion<EmployeeGroup> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> purposeType;
  final Value<int?> startsAt;
  final Value<int?> endsAt;
  final Value<String> status;
  final Value<String?> photoPath;
  final Value<String?> createdBy;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const EmployeeGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.purposeType = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.status = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeGroupsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String purposeType,
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.status = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdBy = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        purposeType = Value(purposeType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<EmployeeGroup> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? purposeType,
    Expression<int>? startsAt,
    Expression<int>? endsAt,
    Expression<String>? status,
    Expression<String>? photoPath,
    Expression<String>? createdBy,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (purposeType != null) 'purpose_type': purposeType,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (status != null) 'status': status,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeGroupsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? purposeType,
      Value<int?>? startsAt,
      Value<int?>? endsAt,
      Value<String>? status,
      Value<String?>? photoPath,
      Value<String?>? createdBy,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int?>? deletedAt,
      Value<int>? rowid}) {
    return EmployeeGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      purposeType: purposeType ?? this.purposeType,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      status: status ?? this.status,
      photoPath: photoPath ?? this.photoPath,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (purposeType.present) {
      map['purpose_type'] = Variable<String>(purposeType.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<int>(startsAt.value);
    }
    if (endsAt.present) {
      map['ends_at'] = Variable<int>(endsAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('purposeType: $purposeType, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('status: $status, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeGroupMembersTable extends EmployeeGroupMembers
    with TableInfo<$EmployeeGroupMembersTable, EmployeeGroupMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeGroupMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<int> addedAt = GeneratedColumn<int>(
      'added_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _addedByMeta =
      const VerificationMeta('addedBy');
  @override
  late final GeneratedColumn<String> addedBy = GeneratedColumn<String>(
      'added_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, groupId, employeeId, addedAt, addedBy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_group_members';
  @override
  VerificationContext validateIntegrity(
      Insertable<EmployeeGroupMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('added_by')) {
      context.handle(_addedByMeta,
          addedBy.isAcceptableOrUnknown(data['added_by']!, _addedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {groupId, employeeId},
      ];
  @override
  EmployeeGroupMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeGroupMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}added_at'])!,
      addedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}added_by']),
    );
  }

  @override
  $EmployeeGroupMembersTable createAlias(String alias) {
    return $EmployeeGroupMembersTable(attachedDatabase, alias);
  }
}

class EmployeeGroupMember extends DataClass
    implements Insertable<EmployeeGroupMember> {
  final String id;
  final String groupId;
  final String employeeId;
  final int addedAt;
  final String? addedBy;
  const EmployeeGroupMember(
      {required this.id,
      required this.groupId,
      required this.employeeId,
      required this.addedAt,
      this.addedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['employee_id'] = Variable<String>(employeeId);
    map['added_at'] = Variable<int>(addedAt);
    if (!nullToAbsent || addedBy != null) {
      map['added_by'] = Variable<String>(addedBy);
    }
    return map;
  }

  EmployeeGroupMembersCompanion toCompanion(bool nullToAbsent) {
    return EmployeeGroupMembersCompanion(
      id: Value(id),
      groupId: Value(groupId),
      employeeId: Value(employeeId),
      addedAt: Value(addedAt),
      addedBy: addedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(addedBy),
    );
  }

  factory EmployeeGroupMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeGroupMember(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      addedAt: serializer.fromJson<int>(json['addedAt']),
      addedBy: serializer.fromJson<String?>(json['addedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'employeeId': serializer.toJson<String>(employeeId),
      'addedAt': serializer.toJson<int>(addedAt),
      'addedBy': serializer.toJson<String?>(addedBy),
    };
  }

  EmployeeGroupMember copyWith(
          {String? id,
          String? groupId,
          String? employeeId,
          int? addedAt,
          Value<String?> addedBy = const Value.absent()}) =>
      EmployeeGroupMember(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        employeeId: employeeId ?? this.employeeId,
        addedAt: addedAt ?? this.addedAt,
        addedBy: addedBy.present ? addedBy.value : this.addedBy,
      );
  EmployeeGroupMember copyWithCompanion(EmployeeGroupMembersCompanion data) {
    return EmployeeGroupMember(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      addedBy: data.addedBy.present ? data.addedBy.value : this.addedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeGroupMember(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('employeeId: $employeeId, ')
          ..write('addedAt: $addedAt, ')
          ..write('addedBy: $addedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, employeeId, addedAt, addedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeGroupMember &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.employeeId == this.employeeId &&
          other.addedAt == this.addedAt &&
          other.addedBy == this.addedBy);
}

class EmployeeGroupMembersCompanion
    extends UpdateCompanion<EmployeeGroupMember> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> employeeId;
  final Value<int> addedAt;
  final Value<String?> addedBy;
  final Value<int> rowid;
  const EmployeeGroupMembersCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.addedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeGroupMembersCompanion.insert({
    required String id,
    required String groupId,
    required String employeeId,
    required int addedAt,
    this.addedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        groupId = Value(groupId),
        employeeId = Value(employeeId),
        addedAt = Value(addedAt);
  static Insertable<EmployeeGroupMember> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? employeeId,
    Expression<int>? addedAt,
    Expression<String>? addedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (employeeId != null) 'employee_id': employeeId,
      if (addedAt != null) 'added_at': addedAt,
      if (addedBy != null) 'added_by': addedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeGroupMembersCompanion copyWith(
      {Value<String>? id,
      Value<String>? groupId,
      Value<String>? employeeId,
      Value<int>? addedAt,
      Value<String?>? addedBy,
      Value<int>? rowid}) {
    return EmployeeGroupMembersCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      employeeId: employeeId ?? this.employeeId,
      addedAt: addedAt ?? this.addedAt,
      addedBy: addedBy ?? this.addedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<int>(addedAt.value);
    }
    if (addedBy.present) {
      map['added_by'] = Variable<String>(addedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeGroupMembersCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('employeeId: $employeeId, ')
          ..write('addedAt: $addedAt, ')
          ..write('addedBy: $addedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeePerformanceReviewsTable extends EmployeePerformanceReviews
    with
        TableInfo<$EmployeePerformanceReviewsTable, EmployeePerformanceReview> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeePerformanceReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _seasonMeta = const VerificationMeta('season');
  @override
  late final GeneratedColumn<int> season = GeneratedColumn<int>(
      'season', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _trackMeta = const VerificationMeta('track');
  @override
  late final GeneratedColumn<String> track = GeneratedColumn<String>(
      'track', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _evaluatorNameMeta =
      const VerificationMeta('evaluatorName');
  @override
  late final GeneratedColumn<String> evaluatorName = GeneratedColumn<String>(
      'evaluator_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _evaluatorUserIdMeta =
      const VerificationMeta('evaluatorUserId');
  @override
  late final GeneratedColumn<String> evaluatorUserId = GeneratedColumn<String>(
      'evaluator_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkInMeta =
      const VerificationMeta('checkIn');
  @override
  late final GeneratedColumn<String> checkIn = GeneratedColumn<String>(
      'check_in', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkOutMeta =
      const VerificationMeta('checkOut');
  @override
  late final GeneratedColumn<String> checkOut = GeneratedColumn<String>(
      'check_out', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _presenceHoursMeta =
      const VerificationMeta('presenceHours');
  @override
  late final GeneratedColumn<double> presenceHours = GeneratedColumn<double>(
      'presence_hours', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dutyHoursMeta =
      const VerificationMeta('dutyHours');
  @override
  late final GeneratedColumn<double> dutyHours = GeneratedColumn<double>(
      'duty_hours', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _worksheetCountMeta =
      const VerificationMeta('worksheetCount');
  @override
  late final GeneratedColumn<int> worksheetCount = GeneratedColumn<int>(
      'worksheet_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _worksheetQuotaMeta =
      const VerificationMeta('worksheetQuota');
  @override
  late final GeneratedColumn<int> worksheetQuota = GeneratedColumn<int>(
      'worksheet_quota', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _complaintsFiledMeta =
      const VerificationMeta('complaintsFiled');
  @override
  late final GeneratedColumn<int> complaintsFiled = GeneratedColumn<int>(
      'complaints_filed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _complaintsValidMeta =
      const VerificationMeta('complaintsValid');
  @override
  late final GeneratedColumn<int> complaintsValid = GeneratedColumn<int>(
      'complaints_valid', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _complaintsAnsweredMeta =
      const VerificationMeta('complaintsAnswered');
  @override
  late final GeneratedColumn<int> complaintsAnswered = GeneratedColumn<int>(
      'complaints_answered', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _responseQualityMeta =
      const VerificationMeta('responseQuality');
  @override
  late final GeneratedColumn<int> responseQuality = GeneratedColumn<int>(
      'response_quality', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _socialParticipationMeta =
      const VerificationMeta('socialParticipation');
  @override
  late final GeneratedColumn<int> socialParticipation = GeneratedColumn<int>(
      'social_participation', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _extraEffortMeta =
      const VerificationMeta('extraEffort');
  @override
  late final GeneratedColumn<int> extraEffort = GeneratedColumn<int>(
      'extra_effort', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _extraHumanCapitalMeta =
      const VerificationMeta('extraHumanCapital');
  @override
  late final GeneratedColumn<int> extraHumanCapital = GeneratedColumn<int>(
      'extra_human_capital', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _extraOrgRelationsMeta =
      const VerificationMeta('extraOrgRelations');
  @override
  late final GeneratedColumn<int> extraOrgRelations = GeneratedColumn<int>(
      'extra_org_relations', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _extraClubMeta =
      const VerificationMeta('extraClub');
  @override
  late final GeneratedColumn<int> extraClub = GeneratedColumn<int>(
      'extra_club', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _extraEvidenceMeta =
      const VerificationMeta('extraEvidence');
  @override
  late final GeneratedColumn<String> extraEvidence = GeneratedColumn<String>(
      'extra_evidence', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expectedProjectsMeta =
      const VerificationMeta('expectedProjects');
  @override
  late final GeneratedColumn<int> expectedProjects = GeneratedColumn<int>(
      'expected_projects', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _expectedVolumeMeta =
      const VerificationMeta('expectedVolume');
  @override
  late final GeneratedColumn<double> expectedVolume = GeneratedColumn<double>(
      'expected_volume', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _expectedChecklistsMeta =
      const VerificationMeta('expectedChecklists');
  @override
  late final GeneratedColumn<int> expectedChecklists = GeneratedColumn<int>(
      'expected_checklists', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _mainScoreMeta =
      const VerificationMeta('mainScore');
  @override
  late final GeneratedColumn<double> mainScore = GeneratedColumn<double>(
      'main_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _extraScoreMeta =
      const VerificationMeta('extraScore');
  @override
  late final GeneratedColumn<double> extraScore = GeneratedColumn<double>(
      'extra_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lightCodeMeta =
      const VerificationMeta('lightCode');
  @override
  late final GeneratedColumn<String> lightCode = GeneratedColumn<String>(
      'light_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _safetyRedFlagMeta =
      const VerificationMeta('safetyRedFlag');
  @override
  late final GeneratedColumn<bool> safetyRedFlag = GeneratedColumn<bool>(
      'safety_red_flag', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("safety_red_flag" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _exemplaryMeta =
      const VerificationMeta('exemplary');
  @override
  late final GeneratedColumn<bool> exemplary = GeneratedColumn<bool>(
      'exemplary', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("exemplary" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _extraOrgBadgeMeta =
      const VerificationMeta('extraOrgBadge');
  @override
  late final GeneratedColumn<bool> extraOrgBadge = GeneratedColumn<bool>(
      'extra_org_badge', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("extra_org_badge" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _approvedAtMeta =
      const VerificationMeta('approvedAt');
  @override
  late final GeneratedColumn<int> approvedAt = GeneratedColumn<int>(
      'approved_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        employeeId,
        year,
        season,
        track,
        status,
        evaluatorName,
        evaluatorUserId,
        notes,
        checkIn,
        checkOut,
        presenceHours,
        dutyHours,
        worksheetCount,
        worksheetQuota,
        complaintsFiled,
        complaintsValid,
        complaintsAnswered,
        responseQuality,
        socialParticipation,
        extraEffort,
        extraHumanCapital,
        extraOrgRelations,
        extraClub,
        extraEvidence,
        expectedProjects,
        expectedVolume,
        expectedChecklists,
        mainScore,
        extraScore,
        lightCode,
        safetyRedFlag,
        exemplary,
        extraOrgBadge,
        approvedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_performance_reviews';
  @override
  VerificationContext validateIntegrity(
      Insertable<EmployeePerformanceReview> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('season')) {
      context.handle(_seasonMeta,
          season.isAcceptableOrUnknown(data['season']!, _seasonMeta));
    } else if (isInserting) {
      context.missing(_seasonMeta);
    }
    if (data.containsKey('track')) {
      context.handle(
          _trackMeta, track.isAcceptableOrUnknown(data['track']!, _trackMeta));
    } else if (isInserting) {
      context.missing(_trackMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('evaluator_name')) {
      context.handle(
          _evaluatorNameMeta,
          evaluatorName.isAcceptableOrUnknown(
              data['evaluator_name']!, _evaluatorNameMeta));
    }
    if (data.containsKey('evaluator_user_id')) {
      context.handle(
          _evaluatorUserIdMeta,
          evaluatorUserId.isAcceptableOrUnknown(
              data['evaluator_user_id']!, _evaluatorUserIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('check_in')) {
      context.handle(_checkInMeta,
          checkIn.isAcceptableOrUnknown(data['check_in']!, _checkInMeta));
    }
    if (data.containsKey('check_out')) {
      context.handle(_checkOutMeta,
          checkOut.isAcceptableOrUnknown(data['check_out']!, _checkOutMeta));
    }
    if (data.containsKey('presence_hours')) {
      context.handle(
          _presenceHoursMeta,
          presenceHours.isAcceptableOrUnknown(
              data['presence_hours']!, _presenceHoursMeta));
    }
    if (data.containsKey('duty_hours')) {
      context.handle(_dutyHoursMeta,
          dutyHours.isAcceptableOrUnknown(data['duty_hours']!, _dutyHoursMeta));
    }
    if (data.containsKey('worksheet_count')) {
      context.handle(
          _worksheetCountMeta,
          worksheetCount.isAcceptableOrUnknown(
              data['worksheet_count']!, _worksheetCountMeta));
    }
    if (data.containsKey('worksheet_quota')) {
      context.handle(
          _worksheetQuotaMeta,
          worksheetQuota.isAcceptableOrUnknown(
              data['worksheet_quota']!, _worksheetQuotaMeta));
    }
    if (data.containsKey('complaints_filed')) {
      context.handle(
          _complaintsFiledMeta,
          complaintsFiled.isAcceptableOrUnknown(
              data['complaints_filed']!, _complaintsFiledMeta));
    }
    if (data.containsKey('complaints_valid')) {
      context.handle(
          _complaintsValidMeta,
          complaintsValid.isAcceptableOrUnknown(
              data['complaints_valid']!, _complaintsValidMeta));
    }
    if (data.containsKey('complaints_answered')) {
      context.handle(
          _complaintsAnsweredMeta,
          complaintsAnswered.isAcceptableOrUnknown(
              data['complaints_answered']!, _complaintsAnsweredMeta));
    }
    if (data.containsKey('response_quality')) {
      context.handle(
          _responseQualityMeta,
          responseQuality.isAcceptableOrUnknown(
              data['response_quality']!, _responseQualityMeta));
    }
    if (data.containsKey('social_participation')) {
      context.handle(
          _socialParticipationMeta,
          socialParticipation.isAcceptableOrUnknown(
              data['social_participation']!, _socialParticipationMeta));
    }
    if (data.containsKey('extra_effort')) {
      context.handle(
          _extraEffortMeta,
          extraEffort.isAcceptableOrUnknown(
              data['extra_effort']!, _extraEffortMeta));
    }
    if (data.containsKey('extra_human_capital')) {
      context.handle(
          _extraHumanCapitalMeta,
          extraHumanCapital.isAcceptableOrUnknown(
              data['extra_human_capital']!, _extraHumanCapitalMeta));
    }
    if (data.containsKey('extra_org_relations')) {
      context.handle(
          _extraOrgRelationsMeta,
          extraOrgRelations.isAcceptableOrUnknown(
              data['extra_org_relations']!, _extraOrgRelationsMeta));
    }
    if (data.containsKey('extra_club')) {
      context.handle(_extraClubMeta,
          extraClub.isAcceptableOrUnknown(data['extra_club']!, _extraClubMeta));
    }
    if (data.containsKey('extra_evidence')) {
      context.handle(
          _extraEvidenceMeta,
          extraEvidence.isAcceptableOrUnknown(
              data['extra_evidence']!, _extraEvidenceMeta));
    }
    if (data.containsKey('expected_projects')) {
      context.handle(
          _expectedProjectsMeta,
          expectedProjects.isAcceptableOrUnknown(
              data['expected_projects']!, _expectedProjectsMeta));
    }
    if (data.containsKey('expected_volume')) {
      context.handle(
          _expectedVolumeMeta,
          expectedVolume.isAcceptableOrUnknown(
              data['expected_volume']!, _expectedVolumeMeta));
    }
    if (data.containsKey('expected_checklists')) {
      context.handle(
          _expectedChecklistsMeta,
          expectedChecklists.isAcceptableOrUnknown(
              data['expected_checklists']!, _expectedChecklistsMeta));
    }
    if (data.containsKey('main_score')) {
      context.handle(_mainScoreMeta,
          mainScore.isAcceptableOrUnknown(data['main_score']!, _mainScoreMeta));
    }
    if (data.containsKey('extra_score')) {
      context.handle(
          _extraScoreMeta,
          extraScore.isAcceptableOrUnknown(
              data['extra_score']!, _extraScoreMeta));
    }
    if (data.containsKey('light_code')) {
      context.handle(_lightCodeMeta,
          lightCode.isAcceptableOrUnknown(data['light_code']!, _lightCodeMeta));
    }
    if (data.containsKey('safety_red_flag')) {
      context.handle(
          _safetyRedFlagMeta,
          safetyRedFlag.isAcceptableOrUnknown(
              data['safety_red_flag']!, _safetyRedFlagMeta));
    }
    if (data.containsKey('exemplary')) {
      context.handle(_exemplaryMeta,
          exemplary.isAcceptableOrUnknown(data['exemplary']!, _exemplaryMeta));
    }
    if (data.containsKey('extra_org_badge')) {
      context.handle(
          _extraOrgBadgeMeta,
          extraOrgBadge.isAcceptableOrUnknown(
              data['extra_org_badge']!, _extraOrgBadgeMeta));
    }
    if (data.containsKey('approved_at')) {
      context.handle(
          _approvedAtMeta,
          approvedAt.isAcceptableOrUnknown(
              data['approved_at']!, _approvedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {employeeId, year, season, track},
      ];
  @override
  EmployeePerformanceReview map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeePerformanceReview(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      season: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}season'])!,
      track: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}track'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      evaluatorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evaluator_name']),
      evaluatorUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}evaluator_user_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      checkIn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}check_in']),
      checkOut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}check_out']),
      presenceHours: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}presence_hours']),
      dutyHours: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}duty_hours']),
      worksheetCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}worksheet_count'])!,
      worksheetQuota: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}worksheet_quota'])!,
      complaintsFiled: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}complaints_filed'])!,
      complaintsValid: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}complaints_valid'])!,
      complaintsAnswered: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}complaints_answered'])!,
      responseQuality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}response_quality'])!,
      socialParticipation: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}social_participation'])!,
      extraEffort: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}extra_effort'])!,
      extraHumanCapital: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}extra_human_capital'])!,
      extraOrgRelations: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}extra_org_relations'])!,
      extraClub: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}extra_club'])!,
      extraEvidence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_evidence']),
      expectedProjects: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expected_projects'])!,
      expectedVolume: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}expected_volume'])!,
      expectedChecklists: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}expected_checklists'])!,
      mainScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}main_score']),
      extraScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}extra_score']),
      lightCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}light_code']),
      safetyRedFlag: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}safety_red_flag'])!,
      exemplary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}exemplary'])!,
      extraOrgBadge: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}extra_org_badge'])!,
      approvedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}approved_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $EmployeePerformanceReviewsTable createAlias(String alias) {
    return $EmployeePerformanceReviewsTable(attachedDatabase, alias);
  }
}

class EmployeePerformanceReview extends DataClass
    implements Insertable<EmployeePerformanceReview> {
  final String id;
  final String employeeId;
  final int year;
  final int season;
  final String track;
  final String status;
  final String? evaluatorName;
  final String? evaluatorUserId;
  final String? notes;
  final String? checkIn;
  final String? checkOut;
  final double? presenceHours;
  final double? dutyHours;
  final int worksheetCount;
  final int worksheetQuota;
  final int complaintsFiled;
  final int complaintsValid;
  final int complaintsAnswered;
  final int responseQuality;
  final int socialParticipation;
  final int extraEffort;
  final int extraHumanCapital;
  final int extraOrgRelations;
  final int extraClub;
  final String? extraEvidence;
  final int expectedProjects;
  final double expectedVolume;
  final int expectedChecklists;
  final double? mainScore;
  final double? extraScore;
  final String? lightCode;
  final bool safetyRedFlag;
  final bool exemplary;
  final bool extraOrgBadge;
  final int? approvedAt;
  final int createdAt;
  final int updatedAt;
  const EmployeePerformanceReview(
      {required this.id,
      required this.employeeId,
      required this.year,
      required this.season,
      required this.track,
      required this.status,
      this.evaluatorName,
      this.evaluatorUserId,
      this.notes,
      this.checkIn,
      this.checkOut,
      this.presenceHours,
      this.dutyHours,
      required this.worksheetCount,
      required this.worksheetQuota,
      required this.complaintsFiled,
      required this.complaintsValid,
      required this.complaintsAnswered,
      required this.responseQuality,
      required this.socialParticipation,
      required this.extraEffort,
      required this.extraHumanCapital,
      required this.extraOrgRelations,
      required this.extraClub,
      this.extraEvidence,
      required this.expectedProjects,
      required this.expectedVolume,
      required this.expectedChecklists,
      this.mainScore,
      this.extraScore,
      this.lightCode,
      required this.safetyRedFlag,
      required this.exemplary,
      required this.extraOrgBadge,
      this.approvedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['year'] = Variable<int>(year);
    map['season'] = Variable<int>(season);
    map['track'] = Variable<String>(track);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || evaluatorName != null) {
      map['evaluator_name'] = Variable<String>(evaluatorName);
    }
    if (!nullToAbsent || evaluatorUserId != null) {
      map['evaluator_user_id'] = Variable<String>(evaluatorUserId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || checkIn != null) {
      map['check_in'] = Variable<String>(checkIn);
    }
    if (!nullToAbsent || checkOut != null) {
      map['check_out'] = Variable<String>(checkOut);
    }
    if (!nullToAbsent || presenceHours != null) {
      map['presence_hours'] = Variable<double>(presenceHours);
    }
    if (!nullToAbsent || dutyHours != null) {
      map['duty_hours'] = Variable<double>(dutyHours);
    }
    map['worksheet_count'] = Variable<int>(worksheetCount);
    map['worksheet_quota'] = Variable<int>(worksheetQuota);
    map['complaints_filed'] = Variable<int>(complaintsFiled);
    map['complaints_valid'] = Variable<int>(complaintsValid);
    map['complaints_answered'] = Variable<int>(complaintsAnswered);
    map['response_quality'] = Variable<int>(responseQuality);
    map['social_participation'] = Variable<int>(socialParticipation);
    map['extra_effort'] = Variable<int>(extraEffort);
    map['extra_human_capital'] = Variable<int>(extraHumanCapital);
    map['extra_org_relations'] = Variable<int>(extraOrgRelations);
    map['extra_club'] = Variable<int>(extraClub);
    if (!nullToAbsent || extraEvidence != null) {
      map['extra_evidence'] = Variable<String>(extraEvidence);
    }
    map['expected_projects'] = Variable<int>(expectedProjects);
    map['expected_volume'] = Variable<double>(expectedVolume);
    map['expected_checklists'] = Variable<int>(expectedChecklists);
    if (!nullToAbsent || mainScore != null) {
      map['main_score'] = Variable<double>(mainScore);
    }
    if (!nullToAbsent || extraScore != null) {
      map['extra_score'] = Variable<double>(extraScore);
    }
    if (!nullToAbsent || lightCode != null) {
      map['light_code'] = Variable<String>(lightCode);
    }
    map['safety_red_flag'] = Variable<bool>(safetyRedFlag);
    map['exemplary'] = Variable<bool>(exemplary);
    map['extra_org_badge'] = Variable<bool>(extraOrgBadge);
    if (!nullToAbsent || approvedAt != null) {
      map['approved_at'] = Variable<int>(approvedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  EmployeePerformanceReviewsCompanion toCompanion(bool nullToAbsent) {
    return EmployeePerformanceReviewsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      year: Value(year),
      season: Value(season),
      track: Value(track),
      status: Value(status),
      evaluatorName: evaluatorName == null && nullToAbsent
          ? const Value.absent()
          : Value(evaluatorName),
      evaluatorUserId: evaluatorUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(evaluatorUserId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      checkIn: checkIn == null && nullToAbsent
          ? const Value.absent()
          : Value(checkIn),
      checkOut: checkOut == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOut),
      presenceHours: presenceHours == null && nullToAbsent
          ? const Value.absent()
          : Value(presenceHours),
      dutyHours: dutyHours == null && nullToAbsent
          ? const Value.absent()
          : Value(dutyHours),
      worksheetCount: Value(worksheetCount),
      worksheetQuota: Value(worksheetQuota),
      complaintsFiled: Value(complaintsFiled),
      complaintsValid: Value(complaintsValid),
      complaintsAnswered: Value(complaintsAnswered),
      responseQuality: Value(responseQuality),
      socialParticipation: Value(socialParticipation),
      extraEffort: Value(extraEffort),
      extraHumanCapital: Value(extraHumanCapital),
      extraOrgRelations: Value(extraOrgRelations),
      extraClub: Value(extraClub),
      extraEvidence: extraEvidence == null && nullToAbsent
          ? const Value.absent()
          : Value(extraEvidence),
      expectedProjects: Value(expectedProjects),
      expectedVolume: Value(expectedVolume),
      expectedChecklists: Value(expectedChecklists),
      mainScore: mainScore == null && nullToAbsent
          ? const Value.absent()
          : Value(mainScore),
      extraScore: extraScore == null && nullToAbsent
          ? const Value.absent()
          : Value(extraScore),
      lightCode: lightCode == null && nullToAbsent
          ? const Value.absent()
          : Value(lightCode),
      safetyRedFlag: Value(safetyRedFlag),
      exemplary: Value(exemplary),
      extraOrgBadge: Value(extraOrgBadge),
      approvedAt: approvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmployeePerformanceReview.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeePerformanceReview(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      year: serializer.fromJson<int>(json['year']),
      season: serializer.fromJson<int>(json['season']),
      track: serializer.fromJson<String>(json['track']),
      status: serializer.fromJson<String>(json['status']),
      evaluatorName: serializer.fromJson<String?>(json['evaluatorName']),
      evaluatorUserId: serializer.fromJson<String?>(json['evaluatorUserId']),
      notes: serializer.fromJson<String?>(json['notes']),
      checkIn: serializer.fromJson<String?>(json['checkIn']),
      checkOut: serializer.fromJson<String?>(json['checkOut']),
      presenceHours: serializer.fromJson<double?>(json['presenceHours']),
      dutyHours: serializer.fromJson<double?>(json['dutyHours']),
      worksheetCount: serializer.fromJson<int>(json['worksheetCount']),
      worksheetQuota: serializer.fromJson<int>(json['worksheetQuota']),
      complaintsFiled: serializer.fromJson<int>(json['complaintsFiled']),
      complaintsValid: serializer.fromJson<int>(json['complaintsValid']),
      complaintsAnswered: serializer.fromJson<int>(json['complaintsAnswered']),
      responseQuality: serializer.fromJson<int>(json['responseQuality']),
      socialParticipation:
          serializer.fromJson<int>(json['socialParticipation']),
      extraEffort: serializer.fromJson<int>(json['extraEffort']),
      extraHumanCapital: serializer.fromJson<int>(json['extraHumanCapital']),
      extraOrgRelations: serializer.fromJson<int>(json['extraOrgRelations']),
      extraClub: serializer.fromJson<int>(json['extraClub']),
      extraEvidence: serializer.fromJson<String?>(json['extraEvidence']),
      expectedProjects: serializer.fromJson<int>(json['expectedProjects']),
      expectedVolume: serializer.fromJson<double>(json['expectedVolume']),
      expectedChecklists: serializer.fromJson<int>(json['expectedChecklists']),
      mainScore: serializer.fromJson<double?>(json['mainScore']),
      extraScore: serializer.fromJson<double?>(json['extraScore']),
      lightCode: serializer.fromJson<String?>(json['lightCode']),
      safetyRedFlag: serializer.fromJson<bool>(json['safetyRedFlag']),
      exemplary: serializer.fromJson<bool>(json['exemplary']),
      extraOrgBadge: serializer.fromJson<bool>(json['extraOrgBadge']),
      approvedAt: serializer.fromJson<int?>(json['approvedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'year': serializer.toJson<int>(year),
      'season': serializer.toJson<int>(season),
      'track': serializer.toJson<String>(track),
      'status': serializer.toJson<String>(status),
      'evaluatorName': serializer.toJson<String?>(evaluatorName),
      'evaluatorUserId': serializer.toJson<String?>(evaluatorUserId),
      'notes': serializer.toJson<String?>(notes),
      'checkIn': serializer.toJson<String?>(checkIn),
      'checkOut': serializer.toJson<String?>(checkOut),
      'presenceHours': serializer.toJson<double?>(presenceHours),
      'dutyHours': serializer.toJson<double?>(dutyHours),
      'worksheetCount': serializer.toJson<int>(worksheetCount),
      'worksheetQuota': serializer.toJson<int>(worksheetQuota),
      'complaintsFiled': serializer.toJson<int>(complaintsFiled),
      'complaintsValid': serializer.toJson<int>(complaintsValid),
      'complaintsAnswered': serializer.toJson<int>(complaintsAnswered),
      'responseQuality': serializer.toJson<int>(responseQuality),
      'socialParticipation': serializer.toJson<int>(socialParticipation),
      'extraEffort': serializer.toJson<int>(extraEffort),
      'extraHumanCapital': serializer.toJson<int>(extraHumanCapital),
      'extraOrgRelations': serializer.toJson<int>(extraOrgRelations),
      'extraClub': serializer.toJson<int>(extraClub),
      'extraEvidence': serializer.toJson<String?>(extraEvidence),
      'expectedProjects': serializer.toJson<int>(expectedProjects),
      'expectedVolume': serializer.toJson<double>(expectedVolume),
      'expectedChecklists': serializer.toJson<int>(expectedChecklists),
      'mainScore': serializer.toJson<double?>(mainScore),
      'extraScore': serializer.toJson<double?>(extraScore),
      'lightCode': serializer.toJson<String?>(lightCode),
      'safetyRedFlag': serializer.toJson<bool>(safetyRedFlag),
      'exemplary': serializer.toJson<bool>(exemplary),
      'extraOrgBadge': serializer.toJson<bool>(extraOrgBadge),
      'approvedAt': serializer.toJson<int?>(approvedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  EmployeePerformanceReview copyWith(
          {String? id,
          String? employeeId,
          int? year,
          int? season,
          String? track,
          String? status,
          Value<String?> evaluatorName = const Value.absent(),
          Value<String?> evaluatorUserId = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> checkIn = const Value.absent(),
          Value<String?> checkOut = const Value.absent(),
          Value<double?> presenceHours = const Value.absent(),
          Value<double?> dutyHours = const Value.absent(),
          int? worksheetCount,
          int? worksheetQuota,
          int? complaintsFiled,
          int? complaintsValid,
          int? complaintsAnswered,
          int? responseQuality,
          int? socialParticipation,
          int? extraEffort,
          int? extraHumanCapital,
          int? extraOrgRelations,
          int? extraClub,
          Value<String?> extraEvidence = const Value.absent(),
          int? expectedProjects,
          double? expectedVolume,
          int? expectedChecklists,
          Value<double?> mainScore = const Value.absent(),
          Value<double?> extraScore = const Value.absent(),
          Value<String?> lightCode = const Value.absent(),
          bool? safetyRedFlag,
          bool? exemplary,
          bool? extraOrgBadge,
          Value<int?> approvedAt = const Value.absent(),
          int? createdAt,
          int? updatedAt}) =>
      EmployeePerformanceReview(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        year: year ?? this.year,
        season: season ?? this.season,
        track: track ?? this.track,
        status: status ?? this.status,
        evaluatorName:
            evaluatorName.present ? evaluatorName.value : this.evaluatorName,
        evaluatorUserId: evaluatorUserId.present
            ? evaluatorUserId.value
            : this.evaluatorUserId,
        notes: notes.present ? notes.value : this.notes,
        checkIn: checkIn.present ? checkIn.value : this.checkIn,
        checkOut: checkOut.present ? checkOut.value : this.checkOut,
        presenceHours:
            presenceHours.present ? presenceHours.value : this.presenceHours,
        dutyHours: dutyHours.present ? dutyHours.value : this.dutyHours,
        worksheetCount: worksheetCount ?? this.worksheetCount,
        worksheetQuota: worksheetQuota ?? this.worksheetQuota,
        complaintsFiled: complaintsFiled ?? this.complaintsFiled,
        complaintsValid: complaintsValid ?? this.complaintsValid,
        complaintsAnswered: complaintsAnswered ?? this.complaintsAnswered,
        responseQuality: responseQuality ?? this.responseQuality,
        socialParticipation: socialParticipation ?? this.socialParticipation,
        extraEffort: extraEffort ?? this.extraEffort,
        extraHumanCapital: extraHumanCapital ?? this.extraHumanCapital,
        extraOrgRelations: extraOrgRelations ?? this.extraOrgRelations,
        extraClub: extraClub ?? this.extraClub,
        extraEvidence:
            extraEvidence.present ? extraEvidence.value : this.extraEvidence,
        expectedProjects: expectedProjects ?? this.expectedProjects,
        expectedVolume: expectedVolume ?? this.expectedVolume,
        expectedChecklists: expectedChecklists ?? this.expectedChecklists,
        mainScore: mainScore.present ? mainScore.value : this.mainScore,
        extraScore: extraScore.present ? extraScore.value : this.extraScore,
        lightCode: lightCode.present ? lightCode.value : this.lightCode,
        safetyRedFlag: safetyRedFlag ?? this.safetyRedFlag,
        exemplary: exemplary ?? this.exemplary,
        extraOrgBadge: extraOrgBadge ?? this.extraOrgBadge,
        approvedAt: approvedAt.present ? approvedAt.value : this.approvedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  EmployeePerformanceReview copyWithCompanion(
      EmployeePerformanceReviewsCompanion data) {
    return EmployeePerformanceReview(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      year: data.year.present ? data.year.value : this.year,
      season: data.season.present ? data.season.value : this.season,
      track: data.track.present ? data.track.value : this.track,
      status: data.status.present ? data.status.value : this.status,
      evaluatorName: data.evaluatorName.present
          ? data.evaluatorName.value
          : this.evaluatorName,
      evaluatorUserId: data.evaluatorUserId.present
          ? data.evaluatorUserId.value
          : this.evaluatorUserId,
      notes: data.notes.present ? data.notes.value : this.notes,
      checkIn: data.checkIn.present ? data.checkIn.value : this.checkIn,
      checkOut: data.checkOut.present ? data.checkOut.value : this.checkOut,
      presenceHours: data.presenceHours.present
          ? data.presenceHours.value
          : this.presenceHours,
      dutyHours: data.dutyHours.present ? data.dutyHours.value : this.dutyHours,
      worksheetCount: data.worksheetCount.present
          ? data.worksheetCount.value
          : this.worksheetCount,
      worksheetQuota: data.worksheetQuota.present
          ? data.worksheetQuota.value
          : this.worksheetQuota,
      complaintsFiled: data.complaintsFiled.present
          ? data.complaintsFiled.value
          : this.complaintsFiled,
      complaintsValid: data.complaintsValid.present
          ? data.complaintsValid.value
          : this.complaintsValid,
      complaintsAnswered: data.complaintsAnswered.present
          ? data.complaintsAnswered.value
          : this.complaintsAnswered,
      responseQuality: data.responseQuality.present
          ? data.responseQuality.value
          : this.responseQuality,
      socialParticipation: data.socialParticipation.present
          ? data.socialParticipation.value
          : this.socialParticipation,
      extraEffort:
          data.extraEffort.present ? data.extraEffort.value : this.extraEffort,
      extraHumanCapital: data.extraHumanCapital.present
          ? data.extraHumanCapital.value
          : this.extraHumanCapital,
      extraOrgRelations: data.extraOrgRelations.present
          ? data.extraOrgRelations.value
          : this.extraOrgRelations,
      extraClub: data.extraClub.present ? data.extraClub.value : this.extraClub,
      extraEvidence: data.extraEvidence.present
          ? data.extraEvidence.value
          : this.extraEvidence,
      expectedProjects: data.expectedProjects.present
          ? data.expectedProjects.value
          : this.expectedProjects,
      expectedVolume: data.expectedVolume.present
          ? data.expectedVolume.value
          : this.expectedVolume,
      expectedChecklists: data.expectedChecklists.present
          ? data.expectedChecklists.value
          : this.expectedChecklists,
      mainScore: data.mainScore.present ? data.mainScore.value : this.mainScore,
      extraScore:
          data.extraScore.present ? data.extraScore.value : this.extraScore,
      lightCode: data.lightCode.present ? data.lightCode.value : this.lightCode,
      safetyRedFlag: data.safetyRedFlag.present
          ? data.safetyRedFlag.value
          : this.safetyRedFlag,
      exemplary: data.exemplary.present ? data.exemplary.value : this.exemplary,
      extraOrgBadge: data.extraOrgBadge.present
          ? data.extraOrgBadge.value
          : this.extraOrgBadge,
      approvedAt:
          data.approvedAt.present ? data.approvedAt.value : this.approvedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeePerformanceReview(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('year: $year, ')
          ..write('season: $season, ')
          ..write('track: $track, ')
          ..write('status: $status, ')
          ..write('evaluatorName: $evaluatorName, ')
          ..write('evaluatorUserId: $evaluatorUserId, ')
          ..write('notes: $notes, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('presenceHours: $presenceHours, ')
          ..write('dutyHours: $dutyHours, ')
          ..write('worksheetCount: $worksheetCount, ')
          ..write('worksheetQuota: $worksheetQuota, ')
          ..write('complaintsFiled: $complaintsFiled, ')
          ..write('complaintsValid: $complaintsValid, ')
          ..write('complaintsAnswered: $complaintsAnswered, ')
          ..write('responseQuality: $responseQuality, ')
          ..write('socialParticipation: $socialParticipation, ')
          ..write('extraEffort: $extraEffort, ')
          ..write('extraHumanCapital: $extraHumanCapital, ')
          ..write('extraOrgRelations: $extraOrgRelations, ')
          ..write('extraClub: $extraClub, ')
          ..write('extraEvidence: $extraEvidence, ')
          ..write('expectedProjects: $expectedProjects, ')
          ..write('expectedVolume: $expectedVolume, ')
          ..write('expectedChecklists: $expectedChecklists, ')
          ..write('mainScore: $mainScore, ')
          ..write('extraScore: $extraScore, ')
          ..write('lightCode: $lightCode, ')
          ..write('safetyRedFlag: $safetyRedFlag, ')
          ..write('exemplary: $exemplary, ')
          ..write('extraOrgBadge: $extraOrgBadge, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        employeeId,
        year,
        season,
        track,
        status,
        evaluatorName,
        evaluatorUserId,
        notes,
        checkIn,
        checkOut,
        presenceHours,
        dutyHours,
        worksheetCount,
        worksheetQuota,
        complaintsFiled,
        complaintsValid,
        complaintsAnswered,
        responseQuality,
        socialParticipation,
        extraEffort,
        extraHumanCapital,
        extraOrgRelations,
        extraClub,
        extraEvidence,
        expectedProjects,
        expectedVolume,
        expectedChecklists,
        mainScore,
        extraScore,
        lightCode,
        safetyRedFlag,
        exemplary,
        extraOrgBadge,
        approvedAt,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeePerformanceReview &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.year == this.year &&
          other.season == this.season &&
          other.track == this.track &&
          other.status == this.status &&
          other.evaluatorName == this.evaluatorName &&
          other.evaluatorUserId == this.evaluatorUserId &&
          other.notes == this.notes &&
          other.checkIn == this.checkIn &&
          other.checkOut == this.checkOut &&
          other.presenceHours == this.presenceHours &&
          other.dutyHours == this.dutyHours &&
          other.worksheetCount == this.worksheetCount &&
          other.worksheetQuota == this.worksheetQuota &&
          other.complaintsFiled == this.complaintsFiled &&
          other.complaintsValid == this.complaintsValid &&
          other.complaintsAnswered == this.complaintsAnswered &&
          other.responseQuality == this.responseQuality &&
          other.socialParticipation == this.socialParticipation &&
          other.extraEffort == this.extraEffort &&
          other.extraHumanCapital == this.extraHumanCapital &&
          other.extraOrgRelations == this.extraOrgRelations &&
          other.extraClub == this.extraClub &&
          other.extraEvidence == this.extraEvidence &&
          other.expectedProjects == this.expectedProjects &&
          other.expectedVolume == this.expectedVolume &&
          other.expectedChecklists == this.expectedChecklists &&
          other.mainScore == this.mainScore &&
          other.extraScore == this.extraScore &&
          other.lightCode == this.lightCode &&
          other.safetyRedFlag == this.safetyRedFlag &&
          other.exemplary == this.exemplary &&
          other.extraOrgBadge == this.extraOrgBadge &&
          other.approvedAt == this.approvedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmployeePerformanceReviewsCompanion
    extends UpdateCompanion<EmployeePerformanceReview> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<int> year;
  final Value<int> season;
  final Value<String> track;
  final Value<String> status;
  final Value<String?> evaluatorName;
  final Value<String?> evaluatorUserId;
  final Value<String?> notes;
  final Value<String?> checkIn;
  final Value<String?> checkOut;
  final Value<double?> presenceHours;
  final Value<double?> dutyHours;
  final Value<int> worksheetCount;
  final Value<int> worksheetQuota;
  final Value<int> complaintsFiled;
  final Value<int> complaintsValid;
  final Value<int> complaintsAnswered;
  final Value<int> responseQuality;
  final Value<int> socialParticipation;
  final Value<int> extraEffort;
  final Value<int> extraHumanCapital;
  final Value<int> extraOrgRelations;
  final Value<int> extraClub;
  final Value<String?> extraEvidence;
  final Value<int> expectedProjects;
  final Value<double> expectedVolume;
  final Value<int> expectedChecklists;
  final Value<double?> mainScore;
  final Value<double?> extraScore;
  final Value<String?> lightCode;
  final Value<bool> safetyRedFlag;
  final Value<bool> exemplary;
  final Value<bool> extraOrgBadge;
  final Value<int?> approvedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const EmployeePerformanceReviewsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.year = const Value.absent(),
    this.season = const Value.absent(),
    this.track = const Value.absent(),
    this.status = const Value.absent(),
    this.evaluatorName = const Value.absent(),
    this.evaluatorUserId = const Value.absent(),
    this.notes = const Value.absent(),
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    this.presenceHours = const Value.absent(),
    this.dutyHours = const Value.absent(),
    this.worksheetCount = const Value.absent(),
    this.worksheetQuota = const Value.absent(),
    this.complaintsFiled = const Value.absent(),
    this.complaintsValid = const Value.absent(),
    this.complaintsAnswered = const Value.absent(),
    this.responseQuality = const Value.absent(),
    this.socialParticipation = const Value.absent(),
    this.extraEffort = const Value.absent(),
    this.extraHumanCapital = const Value.absent(),
    this.extraOrgRelations = const Value.absent(),
    this.extraClub = const Value.absent(),
    this.extraEvidence = const Value.absent(),
    this.expectedProjects = const Value.absent(),
    this.expectedVolume = const Value.absent(),
    this.expectedChecklists = const Value.absent(),
    this.mainScore = const Value.absent(),
    this.extraScore = const Value.absent(),
    this.lightCode = const Value.absent(),
    this.safetyRedFlag = const Value.absent(),
    this.exemplary = const Value.absent(),
    this.extraOrgBadge = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeePerformanceReviewsCompanion.insert({
    required String id,
    required String employeeId,
    required int year,
    required int season,
    required String track,
    this.status = const Value.absent(),
    this.evaluatorName = const Value.absent(),
    this.evaluatorUserId = const Value.absent(),
    this.notes = const Value.absent(),
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    this.presenceHours = const Value.absent(),
    this.dutyHours = const Value.absent(),
    this.worksheetCount = const Value.absent(),
    this.worksheetQuota = const Value.absent(),
    this.complaintsFiled = const Value.absent(),
    this.complaintsValid = const Value.absent(),
    this.complaintsAnswered = const Value.absent(),
    this.responseQuality = const Value.absent(),
    this.socialParticipation = const Value.absent(),
    this.extraEffort = const Value.absent(),
    this.extraHumanCapital = const Value.absent(),
    this.extraOrgRelations = const Value.absent(),
    this.extraClub = const Value.absent(),
    this.extraEvidence = const Value.absent(),
    this.expectedProjects = const Value.absent(),
    this.expectedVolume = const Value.absent(),
    this.expectedChecklists = const Value.absent(),
    this.mainScore = const Value.absent(),
    this.extraScore = const Value.absent(),
    this.lightCode = const Value.absent(),
    this.safetyRedFlag = const Value.absent(),
    this.exemplary = const Value.absent(),
    this.extraOrgBadge = const Value.absent(),
    this.approvedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId),
        year = Value(year),
        season = Value(season),
        track = Value(track),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<EmployeePerformanceReview> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<int>? year,
    Expression<int>? season,
    Expression<String>? track,
    Expression<String>? status,
    Expression<String>? evaluatorName,
    Expression<String>? evaluatorUserId,
    Expression<String>? notes,
    Expression<String>? checkIn,
    Expression<String>? checkOut,
    Expression<double>? presenceHours,
    Expression<double>? dutyHours,
    Expression<int>? worksheetCount,
    Expression<int>? worksheetQuota,
    Expression<int>? complaintsFiled,
    Expression<int>? complaintsValid,
    Expression<int>? complaintsAnswered,
    Expression<int>? responseQuality,
    Expression<int>? socialParticipation,
    Expression<int>? extraEffort,
    Expression<int>? extraHumanCapital,
    Expression<int>? extraOrgRelations,
    Expression<int>? extraClub,
    Expression<String>? extraEvidence,
    Expression<int>? expectedProjects,
    Expression<double>? expectedVolume,
    Expression<int>? expectedChecklists,
    Expression<double>? mainScore,
    Expression<double>? extraScore,
    Expression<String>? lightCode,
    Expression<bool>? safetyRedFlag,
    Expression<bool>? exemplary,
    Expression<bool>? extraOrgBadge,
    Expression<int>? approvedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (year != null) 'year': year,
      if (season != null) 'season': season,
      if (track != null) 'track': track,
      if (status != null) 'status': status,
      if (evaluatorName != null) 'evaluator_name': evaluatorName,
      if (evaluatorUserId != null) 'evaluator_user_id': evaluatorUserId,
      if (notes != null) 'notes': notes,
      if (checkIn != null) 'check_in': checkIn,
      if (checkOut != null) 'check_out': checkOut,
      if (presenceHours != null) 'presence_hours': presenceHours,
      if (dutyHours != null) 'duty_hours': dutyHours,
      if (worksheetCount != null) 'worksheet_count': worksheetCount,
      if (worksheetQuota != null) 'worksheet_quota': worksheetQuota,
      if (complaintsFiled != null) 'complaints_filed': complaintsFiled,
      if (complaintsValid != null) 'complaints_valid': complaintsValid,
      if (complaintsAnswered != null) 'complaints_answered': complaintsAnswered,
      if (responseQuality != null) 'response_quality': responseQuality,
      if (socialParticipation != null)
        'social_participation': socialParticipation,
      if (extraEffort != null) 'extra_effort': extraEffort,
      if (extraHumanCapital != null) 'extra_human_capital': extraHumanCapital,
      if (extraOrgRelations != null) 'extra_org_relations': extraOrgRelations,
      if (extraClub != null) 'extra_club': extraClub,
      if (extraEvidence != null) 'extra_evidence': extraEvidence,
      if (expectedProjects != null) 'expected_projects': expectedProjects,
      if (expectedVolume != null) 'expected_volume': expectedVolume,
      if (expectedChecklists != null) 'expected_checklists': expectedChecklists,
      if (mainScore != null) 'main_score': mainScore,
      if (extraScore != null) 'extra_score': extraScore,
      if (lightCode != null) 'light_code': lightCode,
      if (safetyRedFlag != null) 'safety_red_flag': safetyRedFlag,
      if (exemplary != null) 'exemplary': exemplary,
      if (extraOrgBadge != null) 'extra_org_badge': extraOrgBadge,
      if (approvedAt != null) 'approved_at': approvedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeePerformanceReviewsCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<int>? year,
      Value<int>? season,
      Value<String>? track,
      Value<String>? status,
      Value<String?>? evaluatorName,
      Value<String?>? evaluatorUserId,
      Value<String?>? notes,
      Value<String?>? checkIn,
      Value<String?>? checkOut,
      Value<double?>? presenceHours,
      Value<double?>? dutyHours,
      Value<int>? worksheetCount,
      Value<int>? worksheetQuota,
      Value<int>? complaintsFiled,
      Value<int>? complaintsValid,
      Value<int>? complaintsAnswered,
      Value<int>? responseQuality,
      Value<int>? socialParticipation,
      Value<int>? extraEffort,
      Value<int>? extraHumanCapital,
      Value<int>? extraOrgRelations,
      Value<int>? extraClub,
      Value<String?>? extraEvidence,
      Value<int>? expectedProjects,
      Value<double>? expectedVolume,
      Value<int>? expectedChecklists,
      Value<double?>? mainScore,
      Value<double?>? extraScore,
      Value<String?>? lightCode,
      Value<bool>? safetyRedFlag,
      Value<bool>? exemplary,
      Value<bool>? extraOrgBadge,
      Value<int?>? approvedAt,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return EmployeePerformanceReviewsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      year: year ?? this.year,
      season: season ?? this.season,
      track: track ?? this.track,
      status: status ?? this.status,
      evaluatorName: evaluatorName ?? this.evaluatorName,
      evaluatorUserId: evaluatorUserId ?? this.evaluatorUserId,
      notes: notes ?? this.notes,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      presenceHours: presenceHours ?? this.presenceHours,
      dutyHours: dutyHours ?? this.dutyHours,
      worksheetCount: worksheetCount ?? this.worksheetCount,
      worksheetQuota: worksheetQuota ?? this.worksheetQuota,
      complaintsFiled: complaintsFiled ?? this.complaintsFiled,
      complaintsValid: complaintsValid ?? this.complaintsValid,
      complaintsAnswered: complaintsAnswered ?? this.complaintsAnswered,
      responseQuality: responseQuality ?? this.responseQuality,
      socialParticipation: socialParticipation ?? this.socialParticipation,
      extraEffort: extraEffort ?? this.extraEffort,
      extraHumanCapital: extraHumanCapital ?? this.extraHumanCapital,
      extraOrgRelations: extraOrgRelations ?? this.extraOrgRelations,
      extraClub: extraClub ?? this.extraClub,
      extraEvidence: extraEvidence ?? this.extraEvidence,
      expectedProjects: expectedProjects ?? this.expectedProjects,
      expectedVolume: expectedVolume ?? this.expectedVolume,
      expectedChecklists: expectedChecklists ?? this.expectedChecklists,
      mainScore: mainScore ?? this.mainScore,
      extraScore: extraScore ?? this.extraScore,
      lightCode: lightCode ?? this.lightCode,
      safetyRedFlag: safetyRedFlag ?? this.safetyRedFlag,
      exemplary: exemplary ?? this.exemplary,
      extraOrgBadge: extraOrgBadge ?? this.extraOrgBadge,
      approvedAt: approvedAt ?? this.approvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (season.present) {
      map['season'] = Variable<int>(season.value);
    }
    if (track.present) {
      map['track'] = Variable<String>(track.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (evaluatorName.present) {
      map['evaluator_name'] = Variable<String>(evaluatorName.value);
    }
    if (evaluatorUserId.present) {
      map['evaluator_user_id'] = Variable<String>(evaluatorUserId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (checkIn.present) {
      map['check_in'] = Variable<String>(checkIn.value);
    }
    if (checkOut.present) {
      map['check_out'] = Variable<String>(checkOut.value);
    }
    if (presenceHours.present) {
      map['presence_hours'] = Variable<double>(presenceHours.value);
    }
    if (dutyHours.present) {
      map['duty_hours'] = Variable<double>(dutyHours.value);
    }
    if (worksheetCount.present) {
      map['worksheet_count'] = Variable<int>(worksheetCount.value);
    }
    if (worksheetQuota.present) {
      map['worksheet_quota'] = Variable<int>(worksheetQuota.value);
    }
    if (complaintsFiled.present) {
      map['complaints_filed'] = Variable<int>(complaintsFiled.value);
    }
    if (complaintsValid.present) {
      map['complaints_valid'] = Variable<int>(complaintsValid.value);
    }
    if (complaintsAnswered.present) {
      map['complaints_answered'] = Variable<int>(complaintsAnswered.value);
    }
    if (responseQuality.present) {
      map['response_quality'] = Variable<int>(responseQuality.value);
    }
    if (socialParticipation.present) {
      map['social_participation'] = Variable<int>(socialParticipation.value);
    }
    if (extraEffort.present) {
      map['extra_effort'] = Variable<int>(extraEffort.value);
    }
    if (extraHumanCapital.present) {
      map['extra_human_capital'] = Variable<int>(extraHumanCapital.value);
    }
    if (extraOrgRelations.present) {
      map['extra_org_relations'] = Variable<int>(extraOrgRelations.value);
    }
    if (extraClub.present) {
      map['extra_club'] = Variable<int>(extraClub.value);
    }
    if (extraEvidence.present) {
      map['extra_evidence'] = Variable<String>(extraEvidence.value);
    }
    if (expectedProjects.present) {
      map['expected_projects'] = Variable<int>(expectedProjects.value);
    }
    if (expectedVolume.present) {
      map['expected_volume'] = Variable<double>(expectedVolume.value);
    }
    if (expectedChecklists.present) {
      map['expected_checklists'] = Variable<int>(expectedChecklists.value);
    }
    if (mainScore.present) {
      map['main_score'] = Variable<double>(mainScore.value);
    }
    if (extraScore.present) {
      map['extra_score'] = Variable<double>(extraScore.value);
    }
    if (lightCode.present) {
      map['light_code'] = Variable<String>(lightCode.value);
    }
    if (safetyRedFlag.present) {
      map['safety_red_flag'] = Variable<bool>(safetyRedFlag.value);
    }
    if (exemplary.present) {
      map['exemplary'] = Variable<bool>(exemplary.value);
    }
    if (extraOrgBadge.present) {
      map['extra_org_badge'] = Variable<bool>(extraOrgBadge.value);
    }
    if (approvedAt.present) {
      map['approved_at'] = Variable<int>(approvedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeePerformanceReviewsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('year: $year, ')
          ..write('season: $season, ')
          ..write('track: $track, ')
          ..write('status: $status, ')
          ..write('evaluatorName: $evaluatorName, ')
          ..write('evaluatorUserId: $evaluatorUserId, ')
          ..write('notes: $notes, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('presenceHours: $presenceHours, ')
          ..write('dutyHours: $dutyHours, ')
          ..write('worksheetCount: $worksheetCount, ')
          ..write('worksheetQuota: $worksheetQuota, ')
          ..write('complaintsFiled: $complaintsFiled, ')
          ..write('complaintsValid: $complaintsValid, ')
          ..write('complaintsAnswered: $complaintsAnswered, ')
          ..write('responseQuality: $responseQuality, ')
          ..write('socialParticipation: $socialParticipation, ')
          ..write('extraEffort: $extraEffort, ')
          ..write('extraHumanCapital: $extraHumanCapital, ')
          ..write('extraOrgRelations: $extraOrgRelations, ')
          ..write('extraClub: $extraClub, ')
          ..write('extraEvidence: $extraEvidence, ')
          ..write('expectedProjects: $expectedProjects, ')
          ..write('expectedVolume: $expectedVolume, ')
          ..write('expectedChecklists: $expectedChecklists, ')
          ..write('mainScore: $mainScore, ')
          ..write('extraScore: $extraScore, ')
          ..write('lightCode: $lightCode, ')
          ..write('safetyRedFlag: $safetyRedFlag, ')
          ..write('exemplary: $exemplary, ')
          ..write('extraOrgBadge: $extraOrgBadge, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeWorkerProjectsTable extends EmployeeWorkerProjects
    with TableInfo<$EmployeeWorkerProjectsTable, EmployeeWorkerProject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeWorkerProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reviewIdMeta =
      const VerificationMeta('reviewId');
  @override
  late final GeneratedColumn<String> reviewId = GeneratedColumn<String>(
      'review_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  @override
  late final GeneratedColumn<double> hours = GeneratedColumn<double>(
      'hours', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _progressPercentMeta =
      const VerificationMeta('progressPercent');
  @override
  late final GeneratedColumn<double> progressPercent = GeneratedColumn<double>(
      'progress_percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _checklistCountMeta =
      const VerificationMeta('checklistCount');
  @override
  late final GeneratedColumn<int> checklistCount = GeneratedColumn<int>(
      'checklist_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _incidentsDirectMeta =
      const VerificationMeta('incidentsDirect');
  @override
  late final GeneratedColumn<int> incidentsDirect = GeneratedColumn<int>(
      'incidents_direct', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _incidentsIndirectMeta =
      const VerificationMeta('incidentsIndirect');
  @override
  late final GeneratedColumn<int> incidentsIndirect = GeneratedColumn<int>(
      'incidents_indirect', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _severeMeta = const VerificationMeta('severe');
  @override
  late final GeneratedColumn<bool> severe = GeneratedColumn<bool>(
      'severe', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("severe" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        reviewId,
        title,
        level,
        hours,
        progressPercent,
        checklistCount,
        incidentsDirect,
        incidentsIndirect,
        severe,
        sortOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_worker_projects';
  @override
  VerificationContext validateIntegrity(
      Insertable<EmployeeWorkerProject> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('review_id')) {
      context.handle(_reviewIdMeta,
          reviewId.isAcceptableOrUnknown(data['review_id']!, _reviewIdMeta));
    } else if (isInserting) {
      context.missing(_reviewIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('hours')) {
      context.handle(
          _hoursMeta, hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta));
    } else if (isInserting) {
      context.missing(_hoursMeta);
    }
    if (data.containsKey('progress_percent')) {
      context.handle(
          _progressPercentMeta,
          progressPercent.isAcceptableOrUnknown(
              data['progress_percent']!, _progressPercentMeta));
    } else if (isInserting) {
      context.missing(_progressPercentMeta);
    }
    if (data.containsKey('checklist_count')) {
      context.handle(
          _checklistCountMeta,
          checklistCount.isAcceptableOrUnknown(
              data['checklist_count']!, _checklistCountMeta));
    }
    if (data.containsKey('incidents_direct')) {
      context.handle(
          _incidentsDirectMeta,
          incidentsDirect.isAcceptableOrUnknown(
              data['incidents_direct']!, _incidentsDirectMeta));
    }
    if (data.containsKey('incidents_indirect')) {
      context.handle(
          _incidentsIndirectMeta,
          incidentsIndirect.isAcceptableOrUnknown(
              data['incidents_indirect']!, _incidentsIndirectMeta));
    }
    if (data.containsKey('severe')) {
      context.handle(_severeMeta,
          severe.isAcceptableOrUnknown(data['severe']!, _severeMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeWorkerProject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeWorkerProject(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      reviewId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}review_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      hours: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}hours'])!,
      progressPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}progress_percent'])!,
      checklistCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}checklist_count'])!,
      incidentsDirect: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}incidents_direct'])!,
      incidentsIndirect: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}incidents_indirect'])!,
      severe: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}severe'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $EmployeeWorkerProjectsTable createAlias(String alias) {
    return $EmployeeWorkerProjectsTable(attachedDatabase, alias);
  }
}

class EmployeeWorkerProject extends DataClass
    implements Insertable<EmployeeWorkerProject> {
  final String id;
  final String reviewId;
  final String title;
  final int level;
  final double hours;
  final double progressPercent;
  final int checklistCount;
  final int incidentsDirect;
  final int incidentsIndirect;
  final bool severe;
  final int sortOrder;
  const EmployeeWorkerProject(
      {required this.id,
      required this.reviewId,
      required this.title,
      required this.level,
      required this.hours,
      required this.progressPercent,
      required this.checklistCount,
      required this.incidentsDirect,
      required this.incidentsIndirect,
      required this.severe,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['review_id'] = Variable<String>(reviewId);
    map['title'] = Variable<String>(title);
    map['level'] = Variable<int>(level);
    map['hours'] = Variable<double>(hours);
    map['progress_percent'] = Variable<double>(progressPercent);
    map['checklist_count'] = Variable<int>(checklistCount);
    map['incidents_direct'] = Variable<int>(incidentsDirect);
    map['incidents_indirect'] = Variable<int>(incidentsIndirect);
    map['severe'] = Variable<bool>(severe);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  EmployeeWorkerProjectsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeWorkerProjectsCompanion(
      id: Value(id),
      reviewId: Value(reviewId),
      title: Value(title),
      level: Value(level),
      hours: Value(hours),
      progressPercent: Value(progressPercent),
      checklistCount: Value(checklistCount),
      incidentsDirect: Value(incidentsDirect),
      incidentsIndirect: Value(incidentsIndirect),
      severe: Value(severe),
      sortOrder: Value(sortOrder),
    );
  }

  factory EmployeeWorkerProject.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeWorkerProject(
      id: serializer.fromJson<String>(json['id']),
      reviewId: serializer.fromJson<String>(json['reviewId']),
      title: serializer.fromJson<String>(json['title']),
      level: serializer.fromJson<int>(json['level']),
      hours: serializer.fromJson<double>(json['hours']),
      progressPercent: serializer.fromJson<double>(json['progressPercent']),
      checklistCount: serializer.fromJson<int>(json['checklistCount']),
      incidentsDirect: serializer.fromJson<int>(json['incidentsDirect']),
      incidentsIndirect: serializer.fromJson<int>(json['incidentsIndirect']),
      severe: serializer.fromJson<bool>(json['severe']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reviewId': serializer.toJson<String>(reviewId),
      'title': serializer.toJson<String>(title),
      'level': serializer.toJson<int>(level),
      'hours': serializer.toJson<double>(hours),
      'progressPercent': serializer.toJson<double>(progressPercent),
      'checklistCount': serializer.toJson<int>(checklistCount),
      'incidentsDirect': serializer.toJson<int>(incidentsDirect),
      'incidentsIndirect': serializer.toJson<int>(incidentsIndirect),
      'severe': serializer.toJson<bool>(severe),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  EmployeeWorkerProject copyWith(
          {String? id,
          String? reviewId,
          String? title,
          int? level,
          double? hours,
          double? progressPercent,
          int? checklistCount,
          int? incidentsDirect,
          int? incidentsIndirect,
          bool? severe,
          int? sortOrder}) =>
      EmployeeWorkerProject(
        id: id ?? this.id,
        reviewId: reviewId ?? this.reviewId,
        title: title ?? this.title,
        level: level ?? this.level,
        hours: hours ?? this.hours,
        progressPercent: progressPercent ?? this.progressPercent,
        checklistCount: checklistCount ?? this.checklistCount,
        incidentsDirect: incidentsDirect ?? this.incidentsDirect,
        incidentsIndirect: incidentsIndirect ?? this.incidentsIndirect,
        severe: severe ?? this.severe,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  EmployeeWorkerProject copyWithCompanion(
      EmployeeWorkerProjectsCompanion data) {
    return EmployeeWorkerProject(
      id: data.id.present ? data.id.value : this.id,
      reviewId: data.reviewId.present ? data.reviewId.value : this.reviewId,
      title: data.title.present ? data.title.value : this.title,
      level: data.level.present ? data.level.value : this.level,
      hours: data.hours.present ? data.hours.value : this.hours,
      progressPercent: data.progressPercent.present
          ? data.progressPercent.value
          : this.progressPercent,
      checklistCount: data.checklistCount.present
          ? data.checklistCount.value
          : this.checklistCount,
      incidentsDirect: data.incidentsDirect.present
          ? data.incidentsDirect.value
          : this.incidentsDirect,
      incidentsIndirect: data.incidentsIndirect.present
          ? data.incidentsIndirect.value
          : this.incidentsIndirect,
      severe: data.severe.present ? data.severe.value : this.severe,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeWorkerProject(')
          ..write('id: $id, ')
          ..write('reviewId: $reviewId, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('hours: $hours, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('checklistCount: $checklistCount, ')
          ..write('incidentsDirect: $incidentsDirect, ')
          ..write('incidentsIndirect: $incidentsIndirect, ')
          ..write('severe: $severe, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      reviewId,
      title,
      level,
      hours,
      progressPercent,
      checklistCount,
      incidentsDirect,
      incidentsIndirect,
      severe,
      sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeWorkerProject &&
          other.id == this.id &&
          other.reviewId == this.reviewId &&
          other.title == this.title &&
          other.level == this.level &&
          other.hours == this.hours &&
          other.progressPercent == this.progressPercent &&
          other.checklistCount == this.checklistCount &&
          other.incidentsDirect == this.incidentsDirect &&
          other.incidentsIndirect == this.incidentsIndirect &&
          other.severe == this.severe &&
          other.sortOrder == this.sortOrder);
}

class EmployeeWorkerProjectsCompanion
    extends UpdateCompanion<EmployeeWorkerProject> {
  final Value<String> id;
  final Value<String> reviewId;
  final Value<String> title;
  final Value<int> level;
  final Value<double> hours;
  final Value<double> progressPercent;
  final Value<int> checklistCount;
  final Value<int> incidentsDirect;
  final Value<int> incidentsIndirect;
  final Value<bool> severe;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const EmployeeWorkerProjectsCompanion({
    this.id = const Value.absent(),
    this.reviewId = const Value.absent(),
    this.title = const Value.absent(),
    this.level = const Value.absent(),
    this.hours = const Value.absent(),
    this.progressPercent = const Value.absent(),
    this.checklistCount = const Value.absent(),
    this.incidentsDirect = const Value.absent(),
    this.incidentsIndirect = const Value.absent(),
    this.severe = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeWorkerProjectsCompanion.insert({
    required String id,
    required String reviewId,
    required String title,
    required int level,
    required double hours,
    required double progressPercent,
    this.checklistCount = const Value.absent(),
    this.incidentsDirect = const Value.absent(),
    this.incidentsIndirect = const Value.absent(),
    this.severe = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        reviewId = Value(reviewId),
        title = Value(title),
        level = Value(level),
        hours = Value(hours),
        progressPercent = Value(progressPercent);
  static Insertable<EmployeeWorkerProject> custom({
    Expression<String>? id,
    Expression<String>? reviewId,
    Expression<String>? title,
    Expression<int>? level,
    Expression<double>? hours,
    Expression<double>? progressPercent,
    Expression<int>? checklistCount,
    Expression<int>? incidentsDirect,
    Expression<int>? incidentsIndirect,
    Expression<bool>? severe,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reviewId != null) 'review_id': reviewId,
      if (title != null) 'title': title,
      if (level != null) 'level': level,
      if (hours != null) 'hours': hours,
      if (progressPercent != null) 'progress_percent': progressPercent,
      if (checklistCount != null) 'checklist_count': checklistCount,
      if (incidentsDirect != null) 'incidents_direct': incidentsDirect,
      if (incidentsIndirect != null) 'incidents_indirect': incidentsIndirect,
      if (severe != null) 'severe': severe,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeWorkerProjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? reviewId,
      Value<String>? title,
      Value<int>? level,
      Value<double>? hours,
      Value<double>? progressPercent,
      Value<int>? checklistCount,
      Value<int>? incidentsDirect,
      Value<int>? incidentsIndirect,
      Value<bool>? severe,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return EmployeeWorkerProjectsCompanion(
      id: id ?? this.id,
      reviewId: reviewId ?? this.reviewId,
      title: title ?? this.title,
      level: level ?? this.level,
      hours: hours ?? this.hours,
      progressPercent: progressPercent ?? this.progressPercent,
      checklistCount: checklistCount ?? this.checklistCount,
      incidentsDirect: incidentsDirect ?? this.incidentsDirect,
      incidentsIndirect: incidentsIndirect ?? this.incidentsIndirect,
      severe: severe ?? this.severe,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reviewId.present) {
      map['review_id'] = Variable<String>(reviewId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (hours.present) {
      map['hours'] = Variable<double>(hours.value);
    }
    if (progressPercent.present) {
      map['progress_percent'] = Variable<double>(progressPercent.value);
    }
    if (checklistCount.present) {
      map['checklist_count'] = Variable<int>(checklistCount.value);
    }
    if (incidentsDirect.present) {
      map['incidents_direct'] = Variable<int>(incidentsDirect.value);
    }
    if (incidentsIndirect.present) {
      map['incidents_indirect'] = Variable<int>(incidentsIndirect.value);
    }
    if (severe.present) {
      map['severe'] = Variable<bool>(severe.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeWorkerProjectsCompanion(')
          ..write('id: $id, ')
          ..write('reviewId: $reviewId, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('hours: $hours, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('checklistCount: $checklistCount, ')
          ..write('incidentsDirect: $incidentsDirect, ')
          ..write('incidentsIndirect: $incidentsIndirect, ')
          ..write('severe: $severe, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceRecordsTable extends AttendanceRecords
    with TableInfo<$AttendanceRecordsTable, AttendanceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workDateMeta =
      const VerificationMeta('workDate');
  @override
  late final GeneratedColumn<String> workDate = GeneratedColumn<String>(
      'work_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _checkInMeta =
      const VerificationMeta('checkIn');
  @override
  late final GeneratedColumn<String> checkIn = GeneratedColumn<String>(
      'check_in', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkOutMeta =
      const VerificationMeta('checkOut');
  @override
  late final GeneratedColumn<String> checkOut = GeneratedColumn<String>(
      'check_out', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  @override
  late final GeneratedColumn<double> hours = GeneratedColumn<double>(
      'hours', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        employeeId,
        workDate,
        status,
        checkIn,
        checkOut,
        hours,
        note,
        createdBy,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_records';
  @override
  VerificationContext validateIntegrity(Insertable<AttendanceRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('work_date')) {
      context.handle(_workDateMeta,
          workDate.isAcceptableOrUnknown(data['work_date']!, _workDateMeta));
    } else if (isInserting) {
      context.missing(_workDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('check_in')) {
      context.handle(_checkInMeta,
          checkIn.isAcceptableOrUnknown(data['check_in']!, _checkInMeta));
    }
    if (data.containsKey('check_out')) {
      context.handle(_checkOutMeta,
          checkOut.isAcceptableOrUnknown(data['check_out']!, _checkOutMeta));
    }
    if (data.containsKey('hours')) {
      context.handle(
          _hoursMeta, hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {employeeId, workDate},
      ];
  @override
  AttendanceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      workDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      checkIn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}check_in']),
      checkOut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}check_out']),
      hours: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}hours']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AttendanceRecordsTable createAlias(String alias) {
    return $AttendanceRecordsTable(attachedDatabase, alias);
  }
}

class AttendanceRecord extends DataClass
    implements Insertable<AttendanceRecord> {
  final String id;
  final String employeeId;
  final String workDate;
  final String status;
  final String? checkIn;
  final String? checkOut;
  final double? hours;
  final String? note;
  final String? createdBy;
  final int createdAt;
  final int updatedAt;
  const AttendanceRecord(
      {required this.id,
      required this.employeeId,
      required this.workDate,
      required this.status,
      this.checkIn,
      this.checkOut,
      this.hours,
      this.note,
      this.createdBy,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['work_date'] = Variable<String>(workDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || checkIn != null) {
      map['check_in'] = Variable<String>(checkIn);
    }
    if (!nullToAbsent || checkOut != null) {
      map['check_out'] = Variable<String>(checkOut);
    }
    if (!nullToAbsent || hours != null) {
      map['hours'] = Variable<double>(hours);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AttendanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return AttendanceRecordsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      workDate: Value(workDate),
      status: Value(status),
      checkIn: checkIn == null && nullToAbsent
          ? const Value.absent()
          : Value(checkIn),
      checkOut: checkOut == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOut),
      hours:
          hours == null && nullToAbsent ? const Value.absent() : Value(hours),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceRecord(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      workDate: serializer.fromJson<String>(json['workDate']),
      status: serializer.fromJson<String>(json['status']),
      checkIn: serializer.fromJson<String?>(json['checkIn']),
      checkOut: serializer.fromJson<String?>(json['checkOut']),
      hours: serializer.fromJson<double?>(json['hours']),
      note: serializer.fromJson<String?>(json['note']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'workDate': serializer.toJson<String>(workDate),
      'status': serializer.toJson<String>(status),
      'checkIn': serializer.toJson<String?>(checkIn),
      'checkOut': serializer.toJson<String?>(checkOut),
      'hours': serializer.toJson<double?>(hours),
      'note': serializer.toJson<String?>(note),
      'createdBy': serializer.toJson<String?>(createdBy),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AttendanceRecord copyWith(
          {String? id,
          String? employeeId,
          String? workDate,
          String? status,
          Value<String?> checkIn = const Value.absent(),
          Value<String?> checkOut = const Value.absent(),
          Value<double?> hours = const Value.absent(),
          Value<String?> note = const Value.absent(),
          Value<String?> createdBy = const Value.absent(),
          int? createdAt,
          int? updatedAt}) =>
      AttendanceRecord(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        workDate: workDate ?? this.workDate,
        status: status ?? this.status,
        checkIn: checkIn.present ? checkIn.value : this.checkIn,
        checkOut: checkOut.present ? checkOut.value : this.checkOut,
        hours: hours.present ? hours.value : this.hours,
        note: note.present ? note.value : this.note,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AttendanceRecord copyWithCompanion(AttendanceRecordsCompanion data) {
    return AttendanceRecord(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      workDate: data.workDate.present ? data.workDate.value : this.workDate,
      status: data.status.present ? data.status.value : this.status,
      checkIn: data.checkIn.present ? data.checkIn.value : this.checkIn,
      checkOut: data.checkOut.present ? data.checkOut.value : this.checkOut,
      hours: data.hours.present ? data.hours.value : this.hours,
      note: data.note.present ? data.note.value : this.note,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecord(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('workDate: $workDate, ')
          ..write('status: $status, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('hours: $hours, ')
          ..write('note: $note, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, employeeId, workDate, status, checkIn,
      checkOut, hours, note, createdBy, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceRecord &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.workDate == this.workDate &&
          other.status == this.status &&
          other.checkIn == this.checkIn &&
          other.checkOut == this.checkOut &&
          other.hours == this.hours &&
          other.note == this.note &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AttendanceRecordsCompanion extends UpdateCompanion<AttendanceRecord> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<String> workDate;
  final Value<String> status;
  final Value<String?> checkIn;
  final Value<String?> checkOut;
  final Value<double?> hours;
  final Value<String?> note;
  final Value<String?> createdBy;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AttendanceRecordsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.workDate = const Value.absent(),
    this.status = const Value.absent(),
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    this.hours = const Value.absent(),
    this.note = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceRecordsCompanion.insert({
    required String id,
    required String employeeId,
    required String workDate,
    required String status,
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    this.hours = const Value.absent(),
    this.note = const Value.absent(),
    this.createdBy = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId),
        workDate = Value(workDate),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AttendanceRecord> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? workDate,
    Expression<String>? status,
    Expression<String>? checkIn,
    Expression<String>? checkOut,
    Expression<double>? hours,
    Expression<String>? note,
    Expression<String>? createdBy,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (workDate != null) 'work_date': workDate,
      if (status != null) 'status': status,
      if (checkIn != null) 'check_in': checkIn,
      if (checkOut != null) 'check_out': checkOut,
      if (hours != null) 'hours': hours,
      if (note != null) 'note': note,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<String>? workDate,
      Value<String>? status,
      Value<String?>? checkIn,
      Value<String?>? checkOut,
      Value<double?>? hours,
      Value<String?>? note,
      Value<String?>? createdBy,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return AttendanceRecordsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      workDate: workDate ?? this.workDate,
      status: status ?? this.status,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      hours: hours ?? this.hours,
      note: note ?? this.note,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (workDate.present) {
      map['work_date'] = Variable<String>(workDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (checkIn.present) {
      map['check_in'] = Variable<String>(checkIn.value);
    }
    if (checkOut.present) {
      map['check_out'] = Variable<String>(checkOut.value);
    }
    if (hours.present) {
      map['hours'] = Variable<double>(hours.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('workDate: $workDate, ')
          ..write('status: $status, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('hours: $hours, ')
          ..write('note: $note, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FieldSuggestionsTable extends FieldSuggestions
    with TableInfo<$FieldSuggestionsTable, FieldSuggestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FieldSuggestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [category, value, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'field_suggestions';
  @override
  VerificationContext validateIntegrity(Insertable<FieldSuggestion> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {category, value};
  @override
  FieldSuggestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FieldSuggestion(
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FieldSuggestionsTable createAlias(String alias) {
    return $FieldSuggestionsTable(attachedDatabase, alias);
  }
}

class FieldSuggestion extends DataClass implements Insertable<FieldSuggestion> {
  final String category;
  final String value;
  final int createdAt;
  const FieldSuggestion(
      {required this.category, required this.value, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category'] = Variable<String>(category);
    map['value'] = Variable<String>(value);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  FieldSuggestionsCompanion toCompanion(bool nullToAbsent) {
    return FieldSuggestionsCompanion(
      category: Value(category),
      value: Value(value),
      createdAt: Value(createdAt),
    );
  }

  factory FieldSuggestion.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FieldSuggestion(
      category: serializer.fromJson<String>(json['category']),
      value: serializer.fromJson<String>(json['value']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'category': serializer.toJson<String>(category),
      'value': serializer.toJson<String>(value),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  FieldSuggestion copyWith({String? category, String? value, int? createdAt}) =>
      FieldSuggestion(
        category: category ?? this.category,
        value: value ?? this.value,
        createdAt: createdAt ?? this.createdAt,
      );
  FieldSuggestion copyWithCompanion(FieldSuggestionsCompanion data) {
    return FieldSuggestion(
      category: data.category.present ? data.category.value : this.category,
      value: data.value.present ? data.value.value : this.value,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FieldSuggestion(')
          ..write('category: $category, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(category, value, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FieldSuggestion &&
          other.category == this.category &&
          other.value == this.value &&
          other.createdAt == this.createdAt);
}

class FieldSuggestionsCompanion extends UpdateCompanion<FieldSuggestion> {
  final Value<String> category;
  final Value<String> value;
  final Value<int> createdAt;
  final Value<int> rowid;
  const FieldSuggestionsCompanion({
    this.category = const Value.absent(),
    this.value = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FieldSuggestionsCompanion.insert({
    required String category,
    required String value,
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : category = Value(category),
        value = Value(value),
        createdAt = Value(createdAt);
  static Insertable<FieldSuggestion> custom({
    Expression<String>? category,
    Expression<String>? value,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (category != null) 'category': category,
      if (value != null) 'value': value,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FieldSuggestionsCompanion copyWith(
      {Value<String>? category,
      Value<String>? value,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return FieldSuggestionsCompanion(
      category: category ?? this.category,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FieldSuggestionsCompanion(')
          ..write('category: $category, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeSampleTitlesTable extends EmployeeSampleTitles
    with TableInfo<$EmployeeSampleTitlesTable, EmployeeSampleTitle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeSampleTitlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, employeeId, year, kind, note, createdAt, updatedAt, createdBy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_sample_titles';
  @override
  VerificationContext validateIntegrity(
      Insertable<EmployeeSampleTitle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {employeeId, year, kind},
      ];
  @override
  EmployeeSampleTitle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeSampleTitle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
    );
  }

  @override
  $EmployeeSampleTitlesTable createAlias(String alias) {
    return $EmployeeSampleTitlesTable(attachedDatabase, alias);
  }
}

class EmployeeSampleTitle extends DataClass
    implements Insertable<EmployeeSampleTitle> {
  final String id;
  final String employeeId;
  final int year;
  final String kind;
  final String? note;
  final int createdAt;
  final int updatedAt;
  final String? createdBy;
  const EmployeeSampleTitle(
      {required this.id,
      required this.employeeId,
      required this.year,
      required this.kind,
      this.note,
      required this.createdAt,
      required this.updatedAt,
      this.createdBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['year'] = Variable<int>(year);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    return map;
  }

  EmployeeSampleTitlesCompanion toCompanion(bool nullToAbsent) {
    return EmployeeSampleTitlesCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      year: Value(year),
      kind: Value(kind),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  factory EmployeeSampleTitle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeSampleTitle(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      year: serializer.fromJson<int>(json['year']),
      kind: serializer.fromJson<String>(json['kind']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'year': serializer.toJson<int>(year),
      'kind': serializer.toJson<String>(kind),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'createdBy': serializer.toJson<String?>(createdBy),
    };
  }

  EmployeeSampleTitle copyWith(
          {String? id,
          String? employeeId,
          int? year,
          String? kind,
          Value<String?> note = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          Value<String?> createdBy = const Value.absent()}) =>
      EmployeeSampleTitle(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        year: year ?? this.year,
        kind: kind ?? this.kind,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
      );
  EmployeeSampleTitle copyWithCompanion(EmployeeSampleTitlesCompanion data) {
    return EmployeeSampleTitle(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      year: data.year.present ? data.year.value : this.year,
      kind: data.kind.present ? data.kind.value : this.kind,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeSampleTitle(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('year: $year, ')
          ..write('kind: $kind, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, employeeId, year, kind, note, createdAt, updatedAt, createdBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeSampleTitle &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.year == this.year &&
          other.kind == this.kind &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.createdBy == this.createdBy);
}

class EmployeeSampleTitlesCompanion
    extends UpdateCompanion<EmployeeSampleTitle> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<int> year;
  final Value<String> kind;
  final Value<String?> note;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String?> createdBy;
  final Value<int> rowid;
  const EmployeeSampleTitlesCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.year = const Value.absent(),
    this.kind = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeSampleTitlesCompanion.insert({
    required String id,
    required String employeeId,
    required int year,
    required String kind,
    this.note = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.createdBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId),
        year = Value(year),
        kind = Value(kind),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<EmployeeSampleTitle> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<int>? year,
    Expression<String>? kind,
    Expression<String>? note,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? createdBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (year != null) 'year': year,
      if (kind != null) 'kind': kind,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeSampleTitlesCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<int>? year,
      Value<String>? kind,
      Value<String?>? note,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String?>? createdBy,
      Value<int>? rowid}) {
    return EmployeeSampleTitlesCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      year: year ?? this.year,
      kind: kind ?? this.kind,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeSampleTitlesCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('year: $year, ')
          ..write('kind: $kind, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeSampleIntroductionsTable extends EmployeeSampleIntroductions
    with
        TableInfo<$EmployeeSampleIntroductionsTable,
            EmployeeSampleIntroduction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeSampleIntroductionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sampleTitleIdMeta =
      const VerificationMeta('sampleTitleId');
  @override
  late final GeneratedColumn<String> sampleTitleId = GeneratedColumn<String>(
      'sample_title_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _organizationMeta =
      const VerificationMeta('organization');
  @override
  late final GeneratedColumn<String> organization = GeneratedColumn<String>(
      'organization', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sampleTitleId, organization, note, createdAt, createdBy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_sample_introductions';
  @override
  VerificationContext validateIntegrity(
      Insertable<EmployeeSampleIntroduction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sample_title_id')) {
      context.handle(
          _sampleTitleIdMeta,
          sampleTitleId.isAcceptableOrUnknown(
              data['sample_title_id']!, _sampleTitleIdMeta));
    } else if (isInserting) {
      context.missing(_sampleTitleIdMeta);
    }
    if (data.containsKey('organization')) {
      context.handle(
          _organizationMeta,
          organization.isAcceptableOrUnknown(
              data['organization']!, _organizationMeta));
    } else if (isInserting) {
      context.missing(_organizationMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeSampleIntroduction map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeSampleIntroduction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sampleTitleId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sample_title_id'])!,
      organization: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}organization'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
    );
  }

  @override
  $EmployeeSampleIntroductionsTable createAlias(String alias) {
    return $EmployeeSampleIntroductionsTable(attachedDatabase, alias);
  }
}

class EmployeeSampleIntroduction extends DataClass
    implements Insertable<EmployeeSampleIntroduction> {
  final String id;
  final String sampleTitleId;
  final String organization;
  final String? note;
  final int createdAt;
  final String? createdBy;
  const EmployeeSampleIntroduction(
      {required this.id,
      required this.sampleTitleId,
      required this.organization,
      this.note,
      required this.createdAt,
      this.createdBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sample_title_id'] = Variable<String>(sampleTitleId);
    map['organization'] = Variable<String>(organization);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    return map;
  }

  EmployeeSampleIntroductionsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeSampleIntroductionsCompanion(
      id: Value(id),
      sampleTitleId: Value(sampleTitleId),
      organization: Value(organization),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  factory EmployeeSampleIntroduction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeSampleIntroduction(
      id: serializer.fromJson<String>(json['id']),
      sampleTitleId: serializer.fromJson<String>(json['sampleTitleId']),
      organization: serializer.fromJson<String>(json['organization']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sampleTitleId': serializer.toJson<String>(sampleTitleId),
      'organization': serializer.toJson<String>(organization),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<int>(createdAt),
      'createdBy': serializer.toJson<String?>(createdBy),
    };
  }

  EmployeeSampleIntroduction copyWith(
          {String? id,
          String? sampleTitleId,
          String? organization,
          Value<String?> note = const Value.absent(),
          int? createdAt,
          Value<String?> createdBy = const Value.absent()}) =>
      EmployeeSampleIntroduction(
        id: id ?? this.id,
        sampleTitleId: sampleTitleId ?? this.sampleTitleId,
        organization: organization ?? this.organization,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
      );
  EmployeeSampleIntroduction copyWithCompanion(
      EmployeeSampleIntroductionsCompanion data) {
    return EmployeeSampleIntroduction(
      id: data.id.present ? data.id.value : this.id,
      sampleTitleId: data.sampleTitleId.present
          ? data.sampleTitleId.value
          : this.sampleTitleId,
      organization: data.organization.present
          ? data.organization.value
          : this.organization,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeSampleIntroduction(')
          ..write('id: $id, ')
          ..write('sampleTitleId: $sampleTitleId, ')
          ..write('organization: $organization, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sampleTitleId, organization, note, createdAt, createdBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeSampleIntroduction &&
          other.id == this.id &&
          other.sampleTitleId == this.sampleTitleId &&
          other.organization == this.organization &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy);
}

class EmployeeSampleIntroductionsCompanion
    extends UpdateCompanion<EmployeeSampleIntroduction> {
  final Value<String> id;
  final Value<String> sampleTitleId;
  final Value<String> organization;
  final Value<String?> note;
  final Value<int> createdAt;
  final Value<String?> createdBy;
  final Value<int> rowid;
  const EmployeeSampleIntroductionsCompanion({
    this.id = const Value.absent(),
    this.sampleTitleId = const Value.absent(),
    this.organization = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeSampleIntroductionsCompanion.insert({
    required String id,
    required String sampleTitleId,
    required String organization,
    this.note = const Value.absent(),
    required int createdAt,
    this.createdBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sampleTitleId = Value(sampleTitleId),
        organization = Value(organization),
        createdAt = Value(createdAt);
  static Insertable<EmployeeSampleIntroduction> custom({
    Expression<String>? id,
    Expression<String>? sampleTitleId,
    Expression<String>? organization,
    Expression<String>? note,
    Expression<int>? createdAt,
    Expression<String>? createdBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sampleTitleId != null) 'sample_title_id': sampleTitleId,
      if (organization != null) 'organization': organization,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeSampleIntroductionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sampleTitleId,
      Value<String>? organization,
      Value<String?>? note,
      Value<int>? createdAt,
      Value<String?>? createdBy,
      Value<int>? rowid}) {
    return EmployeeSampleIntroductionsCompanion(
      id: id ?? this.id,
      sampleTitleId: sampleTitleId ?? this.sampleTitleId,
      organization: organization ?? this.organization,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sampleTitleId.present) {
      map['sample_title_id'] = Variable<String>(sampleTitleId.value);
    }
    if (organization.present) {
      map['organization'] = Variable<String>(organization.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeSampleIntroductionsCompanion(')
          ..write('id: $id, ')
          ..write('sampleTitleId: $sampleTitleId, ')
          ..write('organization: $organization, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeGroupActivitiesTable extends EmployeeGroupActivities
    with TableInfo<$EmployeeGroupActivitiesTable, EmployeeGroupActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeGroupActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activityDateMeta =
      const VerificationMeta('activityDate');
  @override
  late final GeneratedColumn<String> activityDate = GeneratedColumn<String>(
      'activity_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByNameMeta =
      const VerificationMeta('createdByName');
  @override
  late final GeneratedColumn<String> createdByName = GeneratedColumn<String>(
      'created_by_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        groupId,
        title,
        note,
        activityDate,
        createdBy,
        createdByName,
        createdAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_group_activities';
  @override
  VerificationContext validateIntegrity(
      Insertable<EmployeeGroupActivity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('activity_date')) {
      context.handle(
          _activityDateMeta,
          activityDate.isAcceptableOrUnknown(
              data['activity_date']!, _activityDateMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('created_by_name')) {
      context.handle(
          _createdByNameMeta,
          createdByName.isAcceptableOrUnknown(
              data['created_by_name']!, _createdByNameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeGroupActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeGroupActivity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      activityDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activity_date']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      createdByName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by_name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $EmployeeGroupActivitiesTable createAlias(String alias) {
    return $EmployeeGroupActivitiesTable(attachedDatabase, alias);
  }
}

class EmployeeGroupActivity extends DataClass
    implements Insertable<EmployeeGroupActivity> {
  final String id;
  final String groupId;
  final String title;
  final String? note;
  final String? activityDate;
  final String? createdBy;
  final String? createdByName;
  final int createdAt;
  final int? deletedAt;
  const EmployeeGroupActivity(
      {required this.id,
      required this.groupId,
      required this.title,
      this.note,
      this.activityDate,
      this.createdBy,
      this.createdByName,
      required this.createdAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || activityDate != null) {
      map['activity_date'] = Variable<String>(activityDate);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || createdByName != null) {
      map['created_by_name'] = Variable<String>(createdByName);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  EmployeeGroupActivitiesCompanion toCompanion(bool nullToAbsent) {
    return EmployeeGroupActivitiesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      title: Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      activityDate: activityDate == null && nullToAbsent
          ? const Value.absent()
          : Value(activityDate),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      createdByName: createdByName == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByName),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EmployeeGroupActivity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeGroupActivity(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
      activityDate: serializer.fromJson<String?>(json['activityDate']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      createdByName: serializer.fromJson<String?>(json['createdByName']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String?>(note),
      'activityDate': serializer.toJson<String?>(activityDate),
      'createdBy': serializer.toJson<String?>(createdBy),
      'createdByName': serializer.toJson<String?>(createdByName),
      'createdAt': serializer.toJson<int>(createdAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  EmployeeGroupActivity copyWith(
          {String? id,
          String? groupId,
          String? title,
          Value<String?> note = const Value.absent(),
          Value<String?> activityDate = const Value.absent(),
          Value<String?> createdBy = const Value.absent(),
          Value<String?> createdByName = const Value.absent(),
          int? createdAt,
          Value<int?> deletedAt = const Value.absent()}) =>
      EmployeeGroupActivity(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        title: title ?? this.title,
        note: note.present ? note.value : this.note,
        activityDate:
            activityDate.present ? activityDate.value : this.activityDate,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        createdByName:
            createdByName.present ? createdByName.value : this.createdByName,
        createdAt: createdAt ?? this.createdAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  EmployeeGroupActivity copyWithCompanion(
      EmployeeGroupActivitiesCompanion data) {
    return EmployeeGroupActivity(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      activityDate: data.activityDate.present
          ? data.activityDate.value
          : this.activityDate,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdByName: data.createdByName.present
          ? data.createdByName.value
          : this.createdByName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeGroupActivity(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('activityDate: $activityDate, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdByName: $createdByName, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, title, note, activityDate,
      createdBy, createdByName, createdAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeGroupActivity &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.title == this.title &&
          other.note == this.note &&
          other.activityDate == this.activityDate &&
          other.createdBy == this.createdBy &&
          other.createdByName == this.createdByName &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class EmployeeGroupActivitiesCompanion
    extends UpdateCompanion<EmployeeGroupActivity> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> title;
  final Value<String?> note;
  final Value<String?> activityDate;
  final Value<String?> createdBy;
  final Value<String?> createdByName;
  final Value<int> createdAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const EmployeeGroupActivitiesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.activityDate = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdByName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeGroupActivitiesCompanion.insert({
    required String id,
    required String groupId,
    required String title,
    this.note = const Value.absent(),
    this.activityDate = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdByName = const Value.absent(),
    required int createdAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        groupId = Value(groupId),
        title = Value(title),
        createdAt = Value(createdAt);
  static Insertable<EmployeeGroupActivity> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? title,
    Expression<String>? note,
    Expression<String>? activityDate,
    Expression<String>? createdBy,
    Expression<String>? createdByName,
    Expression<int>? createdAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (activityDate != null) 'activity_date': activityDate,
      if (createdBy != null) 'created_by': createdBy,
      if (createdByName != null) 'created_by_name': createdByName,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeGroupActivitiesCompanion copyWith(
      {Value<String>? id,
      Value<String>? groupId,
      Value<String>? title,
      Value<String?>? note,
      Value<String?>? activityDate,
      Value<String?>? createdBy,
      Value<String?>? createdByName,
      Value<int>? createdAt,
      Value<int?>? deletedAt,
      Value<int>? rowid}) {
    return EmployeeGroupActivitiesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      note: note ?? this.note,
      activityDate: activityDate ?? this.activityDate,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (activityDate.present) {
      map['activity_date'] = Variable<String>(activityDate.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdByName.present) {
      map['created_by_name'] = Variable<String>(createdByName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeGroupActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('activityDate: $activityDate, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdByName: $createdByName, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actorUserIdMeta =
      const VerificationMeta('actorUserId');
  @override
  late final GeneratedColumn<String> actorUserId = GeneratedColumn<String>(
      'actor_user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actorUsernameMeta =
      const VerificationMeta('actorUsername');
  @override
  late final GeneratedColumn<String> actorUsername = GeneratedColumn<String>(
      'actor_username', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _detailsJsonMeta =
      const VerificationMeta('detailsJson');
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
      'details_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deviceInfoMeta =
      const VerificationMeta('deviceInfo');
  @override
  late final GeneratedColumn<String> deviceInfo = GeneratedColumn<String>(
      'device_info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        actorUserId,
        actorUsername,
        action,
        entityType,
        entityId,
        detailsJson,
        deviceInfo,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('actor_user_id')) {
      context.handle(
          _actorUserIdMeta,
          actorUserId.isAcceptableOrUnknown(
              data['actor_user_id']!, _actorUserIdMeta));
    }
    if (data.containsKey('actor_username')) {
      context.handle(
          _actorUsernameMeta,
          actorUsername.isAcceptableOrUnknown(
              data['actor_username']!, _actorUsernameMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('details_json')) {
      context.handle(
          _detailsJsonMeta,
          detailsJson.isAcceptableOrUnknown(
              data['details_json']!, _detailsJsonMeta));
    }
    if (data.containsKey('device_info')) {
      context.handle(
          _deviceInfoMeta,
          deviceInfo.isAcceptableOrUnknown(
              data['device_info']!, _deviceInfoMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      actorUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor_user_id']),
      actorUsername: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor_username']),
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type']),
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id']),
      detailsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details_json']),
      deviceInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_info']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final String id;
  final String? actorUserId;
  final String? actorUsername;
  final String action;
  final String? entityType;
  final String? entityId;
  final String? detailsJson;
  final String? deviceInfo;
  final int createdAt;
  const AuditLog(
      {required this.id,
      this.actorUserId,
      this.actorUsername,
      required this.action,
      this.entityType,
      this.entityId,
      this.detailsJson,
      this.deviceInfo,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || actorUserId != null) {
      map['actor_user_id'] = Variable<String>(actorUserId);
    }
    if (!nullToAbsent || actorUsername != null) {
      map['actor_username'] = Variable<String>(actorUsername);
    }
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    if (!nullToAbsent || detailsJson != null) {
      map['details_json'] = Variable<String>(detailsJson);
    }
    if (!nullToAbsent || deviceInfo != null) {
      map['device_info'] = Variable<String>(deviceInfo);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      actorUserId: actorUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(actorUserId),
      actorUsername: actorUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(actorUsername),
      action: Value(action),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      detailsJson: detailsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(detailsJson),
      deviceInfo: deviceInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceInfo),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<String>(json['id']),
      actorUserId: serializer.fromJson<String?>(json['actorUserId']),
      actorUsername: serializer.fromJson<String?>(json['actorUsername']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String?>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      detailsJson: serializer.fromJson<String?>(json['detailsJson']),
      deviceInfo: serializer.fromJson<String?>(json['deviceInfo']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'actorUserId': serializer.toJson<String?>(actorUserId),
      'actorUsername': serializer.toJson<String?>(actorUsername),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String?>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'detailsJson': serializer.toJson<String?>(detailsJson),
      'deviceInfo': serializer.toJson<String?>(deviceInfo),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  AuditLog copyWith(
          {String? id,
          Value<String?> actorUserId = const Value.absent(),
          Value<String?> actorUsername = const Value.absent(),
          String? action,
          Value<String?> entityType = const Value.absent(),
          Value<String?> entityId = const Value.absent(),
          Value<String?> detailsJson = const Value.absent(),
          Value<String?> deviceInfo = const Value.absent(),
          int? createdAt}) =>
      AuditLog(
        id: id ?? this.id,
        actorUserId: actorUserId.present ? actorUserId.value : this.actorUserId,
        actorUsername:
            actorUsername.present ? actorUsername.value : this.actorUsername,
        action: action ?? this.action,
        entityType: entityType.present ? entityType.value : this.entityType,
        entityId: entityId.present ? entityId.value : this.entityId,
        detailsJson: detailsJson.present ? detailsJson.value : this.detailsJson,
        deviceInfo: deviceInfo.present ? deviceInfo.value : this.deviceInfo,
        createdAt: createdAt ?? this.createdAt,
      );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      actorUserId:
          data.actorUserId.present ? data.actorUserId.value : this.actorUserId,
      actorUsername: data.actorUsername.present
          ? data.actorUsername.value
          : this.actorUsername,
      action: data.action.present ? data.action.value : this.action,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      detailsJson:
          data.detailsJson.present ? data.detailsJson.value : this.detailsJson,
      deviceInfo:
          data.deviceInfo.present ? data.deviceInfo.value : this.deviceInfo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('actorUserId: $actorUserId, ')
          ..write('actorUsername: $actorUsername, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, actorUserId, actorUsername, action,
      entityType, entityId, detailsJson, deviceInfo, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.actorUserId == this.actorUserId &&
          other.actorUsername == this.actorUsername &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.detailsJson == this.detailsJson &&
          other.deviceInfo == this.deviceInfo &&
          other.createdAt == this.createdAt);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<String> id;
  final Value<String?> actorUserId;
  final Value<String?> actorUsername;
  final Value<String> action;
  final Value<String?> entityType;
  final Value<String?> entityId;
  final Value<String?> detailsJson;
  final Value<String?> deviceInfo;
  final Value<int> createdAt;
  final Value<int> rowid;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.actorUserId = const Value.absent(),
    this.actorUsername = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    required String id,
    this.actorUserId = const Value.absent(),
    this.actorUsername = const Value.absent(),
    required String action,
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        action = Value(action),
        createdAt = Value(createdAt);
  static Insertable<AuditLog> custom({
    Expression<String>? id,
    Expression<String>? actorUserId,
    Expression<String>? actorUsername,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? detailsJson,
    Expression<String>? deviceInfo,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actorUserId != null) 'actor_user_id': actorUserId,
      if (actorUsername != null) 'actor_username': actorUsername,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (detailsJson != null) 'details_json': detailsJson,
      if (deviceInfo != null) 'device_info': deviceInfo,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? actorUserId,
      Value<String?>? actorUsername,
      Value<String>? action,
      Value<String?>? entityType,
      Value<String?>? entityId,
      Value<String?>? detailsJson,
      Value<String?>? deviceInfo,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      actorUserId: actorUserId ?? this.actorUserId,
      actorUsername: actorUsername ?? this.actorUsername,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      detailsJson: detailsJson ?? this.detailsJson,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (actorUserId.present) {
      map['actor_user_id'] = Variable<String>(actorUserId.value);
    }
    if (actorUsername.present) {
      map['actor_username'] = Variable<String>(actorUsername.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    if (deviceInfo.present) {
      map['device_info'] = Variable<String>(deviceInfo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('actorUserId: $actorUserId, ')
          ..write('actorUsername: $actorUsername, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final int updatedAt;
  const AppSetting(
      {required this.key, required this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? value, int? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value),
        updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key,
      Value<String>? value,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedFiltersTable extends SavedFilters
    with TableInfo<$SavedFiltersTable, SavedFilter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedFiltersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _queryJsonMeta =
      const VerificationMeta('queryJson');
  @override
  late final GeneratedColumn<String> queryJson = GeneratedColumn<String>(
      'query_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, name, queryJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_filters';
  @override
  VerificationContext validateIntegrity(Insertable<SavedFilter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('query_json')) {
      context.handle(_queryJsonMeta,
          queryJson.isAcceptableOrUnknown(data['query_json']!, _queryJsonMeta));
    } else if (isInserting) {
      context.missing(_queryJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedFilter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedFilter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      queryJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SavedFiltersTable createAlias(String alias) {
    return $SavedFiltersTable(attachedDatabase, alias);
  }
}

class SavedFilter extends DataClass implements Insertable<SavedFilter> {
  final String id;
  final String userId;
  final String name;
  final String queryJson;
  final int createdAt;
  const SavedFilter(
      {required this.id,
      required this.userId,
      required this.name,
      required this.queryJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['query_json'] = Variable<String>(queryJson);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SavedFiltersCompanion toCompanion(bool nullToAbsent) {
    return SavedFiltersCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      queryJson: Value(queryJson),
      createdAt: Value(createdAt),
    );
  }

  factory SavedFilter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedFilter(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      queryJson: serializer.fromJson<String>(json['queryJson']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'queryJson': serializer.toJson<String>(queryJson),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  SavedFilter copyWith(
          {String? id,
          String? userId,
          String? name,
          String? queryJson,
          int? createdAt}) =>
      SavedFilter(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        queryJson: queryJson ?? this.queryJson,
        createdAt: createdAt ?? this.createdAt,
      );
  SavedFilter copyWithCompanion(SavedFiltersCompanion data) {
    return SavedFilter(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      queryJson: data.queryJson.present ? data.queryJson.value : this.queryJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedFilter(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('queryJson: $queryJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, name, queryJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedFilter &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.queryJson == this.queryJson &&
          other.createdAt == this.createdAt);
}

class SavedFiltersCompanion extends UpdateCompanion<SavedFilter> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> queryJson;
  final Value<int> createdAt;
  final Value<int> rowid;
  const SavedFiltersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.queryJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedFiltersCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String queryJson,
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        name = Value(name),
        queryJson = Value(queryJson),
        createdAt = Value(createdAt);
  static Insertable<SavedFilter> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? queryJson,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (queryJson != null) 'query_json': queryJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedFiltersCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? name,
      Value<String>? queryJson,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return SavedFiltersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      queryJson: queryJson ?? this.queryJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (queryJson.present) {
      map['query_json'] = Variable<String>(queryJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedFiltersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('queryJson: $queryJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportTemplatesTable extends ReportTemplates
    with TableInfo<$ReportTemplatesTable, ReportTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _configJsonMeta =
      const VerificationMeta('configJson');
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
      'config_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, configJson, createdBy, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_templates';
  @override
  VerificationContext validateIntegrity(Insertable<ReportTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('config_json')) {
      context.handle(
          _configJsonMeta,
          configJson.isAcceptableOrUnknown(
              data['config_json']!, _configJsonMeta));
    } else if (isInserting) {
      context.missing(_configJsonMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportTemplate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      configJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config_json'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ReportTemplatesTable createAlias(String alias) {
    return $ReportTemplatesTable(attachedDatabase, alias);
  }
}

class ReportTemplate extends DataClass implements Insertable<ReportTemplate> {
  final String id;
  final String name;
  final String configJson;
  final String? createdBy;
  final int createdAt;
  final int updatedAt;
  const ReportTemplate(
      {required this.id,
      required this.name,
      required this.configJson,
      this.createdBy,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['config_json'] = Variable<String>(configJson);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ReportTemplatesCompanion toCompanion(bool nullToAbsent) {
    return ReportTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      configJson: Value(configJson),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReportTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportTemplate(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      configJson: serializer.fromJson<String>(json['configJson']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'configJson': serializer.toJson<String>(configJson),
      'createdBy': serializer.toJson<String?>(createdBy),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ReportTemplate copyWith(
          {String? id,
          String? name,
          String? configJson,
          Value<String?> createdBy = const Value.absent(),
          int? createdAt,
          int? updatedAt}) =>
      ReportTemplate(
        id: id ?? this.id,
        name: name ?? this.name,
        configJson: configJson ?? this.configJson,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ReportTemplate copyWithCompanion(ReportTemplatesCompanion data) {
    return ReportTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      configJson:
          data.configJson.present ? data.configJson.value : this.configJson,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('configJson: $configJson, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, configJson, createdBy, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.configJson == this.configJson &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReportTemplatesCompanion extends UpdateCompanion<ReportTemplate> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> configJson;
  final Value<String?> createdBy;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ReportTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.configJson = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportTemplatesCompanion.insert({
    required String id,
    required String name,
    required String configJson,
    this.createdBy = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        configJson = Value(configJson),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ReportTemplate> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? configJson,
    Expression<String>? createdBy,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (configJson != null) 'config_json': configJson,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportTemplatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? configJson,
      Value<String?>? createdBy,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return ReportTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      configJson: configJson ?? this.configJson,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('configJson: $configJson, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackupJobsTable extends BackupJobs
    with TableInfo<$BackupJobsTable, BackupJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduleMeta =
      const VerificationMeta('schedule');
  @override
  late final GeneratedColumn<String> schedule = GeneratedColumn<String>(
      'schedule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastRunAtMeta =
      const VerificationMeta('lastRunAt');
  @override
  late final GeneratedColumn<int> lastRunAt = GeneratedColumn<int>(
      'last_run_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _signatureMeta =
      const VerificationMeta('signature');
  @override
  late final GeneratedColumn<String> signature = GeneratedColumn<String>(
      'signature', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentHashMeta =
      const VerificationMeta('contentHash');
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
      'content_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        schedule,
        lastRunAt,
        status,
        path,
        signature,
        contentHash,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_jobs';
  @override
  VerificationContext validateIntegrity(Insertable<BackupJob> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('schedule')) {
      context.handle(_scheduleMeta,
          schedule.isAcceptableOrUnknown(data['schedule']!, _scheduleMeta));
    }
    if (data.containsKey('last_run_at')) {
      context.handle(
          _lastRunAtMeta,
          lastRunAt.isAcceptableOrUnknown(
              data['last_run_at']!, _lastRunAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    }
    if (data.containsKey('signature')) {
      context.handle(_signatureMeta,
          signature.isAcceptableOrUnknown(data['signature']!, _signatureMeta));
    }
    if (data.containsKey('content_hash')) {
      context.handle(
          _contentHashMeta,
          contentHash.isAcceptableOrUnknown(
              data['content_hash']!, _contentHashMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BackupJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupJob(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      schedule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule']),
      lastRunAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_run_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path']),
      signature: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}signature']),
      contentHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_hash']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BackupJobsTable createAlias(String alias) {
    return $BackupJobsTable(attachedDatabase, alias);
  }
}

class BackupJob extends DataClass implements Insertable<BackupJob> {
  final String id;
  final String type;
  final String? schedule;
  final int? lastRunAt;
  final String? status;
  final String? path;
  final String? signature;
  final String? contentHash;
  final int createdAt;
  const BackupJob(
      {required this.id,
      required this.type,
      this.schedule,
      this.lastRunAt,
      this.status,
      this.path,
      this.signature,
      this.contentHash,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || schedule != null) {
      map['schedule'] = Variable<String>(schedule);
    }
    if (!nullToAbsent || lastRunAt != null) {
      map['last_run_at'] = Variable<int>(lastRunAt);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    if (!nullToAbsent || signature != null) {
      map['signature'] = Variable<String>(signature);
    }
    if (!nullToAbsent || contentHash != null) {
      map['content_hash'] = Variable<String>(contentHash);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  BackupJobsCompanion toCompanion(bool nullToAbsent) {
    return BackupJobsCompanion(
      id: Value(id),
      type: Value(type),
      schedule: schedule == null && nullToAbsent
          ? const Value.absent()
          : Value(schedule),
      lastRunAt: lastRunAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRunAt),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      signature: signature == null && nullToAbsent
          ? const Value.absent()
          : Value(signature),
      contentHash: contentHash == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHash),
      createdAt: Value(createdAt),
    );
  }

  factory BackupJob.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupJob(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      schedule: serializer.fromJson<String?>(json['schedule']),
      lastRunAt: serializer.fromJson<int?>(json['lastRunAt']),
      status: serializer.fromJson<String?>(json['status']),
      path: serializer.fromJson<String?>(json['path']),
      signature: serializer.fromJson<String?>(json['signature']),
      contentHash: serializer.fromJson<String?>(json['contentHash']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'schedule': serializer.toJson<String?>(schedule),
      'lastRunAt': serializer.toJson<int?>(lastRunAt),
      'status': serializer.toJson<String?>(status),
      'path': serializer.toJson<String?>(path),
      'signature': serializer.toJson<String?>(signature),
      'contentHash': serializer.toJson<String?>(contentHash),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  BackupJob copyWith(
          {String? id,
          String? type,
          Value<String?> schedule = const Value.absent(),
          Value<int?> lastRunAt = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> path = const Value.absent(),
          Value<String?> signature = const Value.absent(),
          Value<String?> contentHash = const Value.absent(),
          int? createdAt}) =>
      BackupJob(
        id: id ?? this.id,
        type: type ?? this.type,
        schedule: schedule.present ? schedule.value : this.schedule,
        lastRunAt: lastRunAt.present ? lastRunAt.value : this.lastRunAt,
        status: status.present ? status.value : this.status,
        path: path.present ? path.value : this.path,
        signature: signature.present ? signature.value : this.signature,
        contentHash: contentHash.present ? contentHash.value : this.contentHash,
        createdAt: createdAt ?? this.createdAt,
      );
  BackupJob copyWithCompanion(BackupJobsCompanion data) {
    return BackupJob(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      schedule: data.schedule.present ? data.schedule.value : this.schedule,
      lastRunAt: data.lastRunAt.present ? data.lastRunAt.value : this.lastRunAt,
      status: data.status.present ? data.status.value : this.status,
      path: data.path.present ? data.path.value : this.path,
      signature: data.signature.present ? data.signature.value : this.signature,
      contentHash:
          data.contentHash.present ? data.contentHash.value : this.contentHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupJob(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('schedule: $schedule, ')
          ..write('lastRunAt: $lastRunAt, ')
          ..write('status: $status, ')
          ..write('path: $path, ')
          ..write('signature: $signature, ')
          ..write('contentHash: $contentHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, schedule, lastRunAt, status, path,
      signature, contentHash, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupJob &&
          other.id == this.id &&
          other.type == this.type &&
          other.schedule == this.schedule &&
          other.lastRunAt == this.lastRunAt &&
          other.status == this.status &&
          other.path == this.path &&
          other.signature == this.signature &&
          other.contentHash == this.contentHash &&
          other.createdAt == this.createdAt);
}

class BackupJobsCompanion extends UpdateCompanion<BackupJob> {
  final Value<String> id;
  final Value<String> type;
  final Value<String?> schedule;
  final Value<int?> lastRunAt;
  final Value<String?> status;
  final Value<String?> path;
  final Value<String?> signature;
  final Value<String?> contentHash;
  final Value<int> createdAt;
  final Value<int> rowid;
  const BackupJobsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.schedule = const Value.absent(),
    this.lastRunAt = const Value.absent(),
    this.status = const Value.absent(),
    this.path = const Value.absent(),
    this.signature = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackupJobsCompanion.insert({
    required String id,
    required String type,
    this.schedule = const Value.absent(),
    this.lastRunAt = const Value.absent(),
    this.status = const Value.absent(),
    this.path = const Value.absent(),
    this.signature = const Value.absent(),
    this.contentHash = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        createdAt = Value(createdAt);
  static Insertable<BackupJob> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? schedule,
    Expression<int>? lastRunAt,
    Expression<String>? status,
    Expression<String>? path,
    Expression<String>? signature,
    Expression<String>? contentHash,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (schedule != null) 'schedule': schedule,
      if (lastRunAt != null) 'last_run_at': lastRunAt,
      if (status != null) 'status': status,
      if (path != null) 'path': path,
      if (signature != null) 'signature': signature,
      if (contentHash != null) 'content_hash': contentHash,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackupJobsCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String?>? schedule,
      Value<int?>? lastRunAt,
      Value<String?>? status,
      Value<String?>? path,
      Value<String?>? signature,
      Value<String?>? contentHash,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return BackupJobsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      schedule: schedule ?? this.schedule,
      lastRunAt: lastRunAt ?? this.lastRunAt,
      status: status ?? this.status,
      path: path ?? this.path,
      signature: signature ?? this.signature,
      contentHash: contentHash ?? this.contentHash,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (schedule.present) {
      map['schedule'] = Variable<String>(schedule.value);
    }
    if (lastRunAt.present) {
      map['last_run_at'] = Variable<int>(lastRunAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (signature.present) {
      map['signature'] = Variable<String>(signature.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupJobsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('schedule: $schedule, ')
          ..write('lastRunAt: $lastRunAt, ')
          ..write('status: $status, ')
          ..write('path: $path, ')
          ..write('signature: $signature, ')
          ..write('contentHash: $contentHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $RolesTable roles = $RolesTable(this);
  late final $PermissionsTable permissions = $PermissionsTable(this);
  late final $UserRolesTable userRoles = $UserRolesTable(this);
  late final $RolePermissionsTable rolePermissions =
      $RolePermissionsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $DepartmentsTable departments = $DepartmentsTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $EmployeeContactsTable employeeContacts =
      $EmployeeContactsTable(this);
  late final $EmployeeSocialsTable employeeSocials =
      $EmployeeSocialsTable(this);
  late final $EmployeeEducationsTable employeeEducations =
      $EmployeeEducationsTable(this);
  late final $EmployeeSkillsTable employeeSkills = $EmployeeSkillsTable(this);
  late final $EmployeeInterestsTable employeeInterests =
      $EmployeeInterestsTable(this);
  late final $EmployeeInsurancesTable employeeInsurances =
      $EmployeeInsurancesTable(this);
  late final $EmployeeEvaluationsTable employeeEvaluations =
      $EmployeeEvaluationsTable(this);
  late final $EmployeeDocumentsTable employeeDocuments =
      $EmployeeDocumentsTable(this);
  late final $EmployeeGroupsTable employeeGroups = $EmployeeGroupsTable(this);
  late final $EmployeeGroupMembersTable employeeGroupMembers =
      $EmployeeGroupMembersTable(this);
  late final $EmployeePerformanceReviewsTable employeePerformanceReviews =
      $EmployeePerformanceReviewsTable(this);
  late final $EmployeeWorkerProjectsTable employeeWorkerProjects =
      $EmployeeWorkerProjectsTable(this);
  late final $AttendanceRecordsTable attendanceRecords =
      $AttendanceRecordsTable(this);
  late final $FieldSuggestionsTable fieldSuggestions =
      $FieldSuggestionsTable(this);
  late final $EmployeeSampleTitlesTable employeeSampleTitles =
      $EmployeeSampleTitlesTable(this);
  late final $EmployeeSampleIntroductionsTable employeeSampleIntroductions =
      $EmployeeSampleIntroductionsTable(this);
  late final $EmployeeGroupActivitiesTable employeeGroupActivities =
      $EmployeeGroupActivitiesTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $SavedFiltersTable savedFilters = $SavedFiltersTable(this);
  late final $ReportTemplatesTable reportTemplates =
      $ReportTemplatesTable(this);
  late final $BackupJobsTable backupJobs = $BackupJobsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        roles,
        permissions,
        userRoles,
        rolePermissions,
        sessions,
        departments,
        units,
        employees,
        employeeContacts,
        employeeSocials,
        employeeEducations,
        employeeSkills,
        employeeInterests,
        employeeInsurances,
        employeeEvaluations,
        employeeDocuments,
        employeeGroups,
        employeeGroupMembers,
        employeePerformanceReviews,
        employeeWorkerProjects,
        attendanceRecords,
        fieldSuggestions,
        employeeSampleTitles,
        employeeSampleIntroductions,
        employeeGroupActivities,
        auditLogs,
        appSettings,
        savedFilters,
        reportTemplates,
        backupJobs
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String username,
  required String displayName,
  required String passwordHash,
  Value<bool> isActive,
  Value<int> failedAttempts,
  Value<int?> lockedUntil,
  Value<bool> mustChangePassword,
  Value<bool> rememberMeEnabled,
  Value<int?> lastLoginAt,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> username,
  Value<String> displayName,
  Value<String> passwordHash,
  Value<bool> isActive,
  Value<int> failedAttempts,
  Value<int?> lockedUntil,
  Value<bool> mustChangePassword,
  Value<bool> rememberMeEnabled,
  Value<int?> lastLoginAt,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get mustChangePassword => $composableBuilder(
      column: $table.mustChangePassword,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get rememberMeEnabled => $composableBuilder(
      column: $table.rememberMeEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get mustChangePassword => $composableBuilder(
      column: $table.mustChangePassword,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get rememberMeEnabled => $composableBuilder(
      column: $table.rememberMeEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts, builder: (column) => column);

  GeneratedColumn<int> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => column);

  GeneratedColumn<bool> get mustChangePassword => $composableBuilder(
      column: $table.mustChangePassword, builder: (column) => column);

  GeneratedColumn<bool> get rememberMeEnabled => $composableBuilder(
      column: $table.rememberMeEnabled, builder: (column) => column);

  GeneratedColumn<int> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> failedAttempts = const Value.absent(),
            Value<int?> lockedUntil = const Value.absent(),
            Value<bool> mustChangePassword = const Value.absent(),
            Value<bool> rememberMeEnabled = const Value.absent(),
            Value<int?> lastLoginAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            displayName: displayName,
            passwordHash: passwordHash,
            isActive: isActive,
            failedAttempts: failedAttempts,
            lockedUntil: lockedUntil,
            mustChangePassword: mustChangePassword,
            rememberMeEnabled: rememberMeEnabled,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String username,
            required String displayName,
            required String passwordHash,
            Value<bool> isActive = const Value.absent(),
            Value<int> failedAttempts = const Value.absent(),
            Value<int?> lockedUntil = const Value.absent(),
            Value<bool> mustChangePassword = const Value.absent(),
            Value<bool> rememberMeEnabled = const Value.absent(),
            Value<int?> lastLoginAt = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            displayName: displayName,
            passwordHash: passwordHash,
            isActive: isActive,
            failedAttempts: failedAttempts,
            lockedUntil: lockedUntil,
            mustChangePassword: mustChangePassword,
            rememberMeEnabled: rememberMeEnabled,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$RolesTableCreateCompanionBuilder = RolesCompanion Function({
  required String id,
  required String code,
  required String nameFa,
  Value<String?> nameEn,
  Value<bool> isSystem,
  Value<String?> description,
  Value<int> rowid,
});
typedef $$RolesTableUpdateCompanionBuilder = RolesCompanion Function({
  Value<String> id,
  Value<String> code,
  Value<String> nameFa,
  Value<String?> nameEn,
  Value<bool> isSystem,
  Value<String?> description,
  Value<int> rowid,
});

class $$RolesTableFilterComposer extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFa => $composableBuilder(
      column: $table.nameFa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));
}

class $$RolesTableOrderingComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFa => $composableBuilder(
      column: $table.nameFa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));
}

class $$RolesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameFa =>
      $composableBuilder(column: $table.nameFa, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);
}

class $$RolesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RolesTable,
    Role,
    $$RolesTableFilterComposer,
    $$RolesTableOrderingComposer,
    $$RolesTableAnnotationComposer,
    $$RolesTableCreateCompanionBuilder,
    $$RolesTableUpdateCompanionBuilder,
    (Role, BaseReferences<_$AppDatabase, $RolesTable, Role>),
    Role,
    PrefetchHooks Function()> {
  $$RolesTableTableManager(_$AppDatabase db, $RolesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> nameFa = const Value.absent(),
            Value<String?> nameEn = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RolesCompanion(
            id: id,
            code: code,
            nameFa: nameFa,
            nameEn: nameEn,
            isSystem: isSystem,
            description: description,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String code,
            required String nameFa,
            Value<String?> nameEn = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RolesCompanion.insert(
            id: id,
            code: code,
            nameFa: nameFa,
            nameEn: nameEn,
            isSystem: isSystem,
            description: description,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RolesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RolesTable,
    Role,
    $$RolesTableFilterComposer,
    $$RolesTableOrderingComposer,
    $$RolesTableAnnotationComposer,
    $$RolesTableCreateCompanionBuilder,
    $$RolesTableUpdateCompanionBuilder,
    (Role, BaseReferences<_$AppDatabase, $RolesTable, Role>),
    Role,
    PrefetchHooks Function()>;
typedef $$PermissionsTableCreateCompanionBuilder = PermissionsCompanion
    Function({
  required String id,
  required String code,
  required String module,
  required String nameFa,
  Value<String?> nameEn,
  Value<int> rowid,
});
typedef $$PermissionsTableUpdateCompanionBuilder = PermissionsCompanion
    Function({
  Value<String> id,
  Value<String> code,
  Value<String> module,
  Value<String> nameFa,
  Value<String?> nameEn,
  Value<int> rowid,
});

class $$PermissionsTableFilterComposer
    extends Composer<_$AppDatabase, $PermissionsTable> {
  $$PermissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get module => $composableBuilder(
      column: $table.module, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFa => $composableBuilder(
      column: $table.nameFa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));
}

class $$PermissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PermissionsTable> {
  $$PermissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get module => $composableBuilder(
      column: $table.module, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFa => $composableBuilder(
      column: $table.nameFa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));
}

class $$PermissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PermissionsTable> {
  $$PermissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);

  GeneratedColumn<String> get nameFa =>
      $composableBuilder(column: $table.nameFa, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);
}

class $$PermissionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PermissionsTable,
    Permission,
    $$PermissionsTableFilterComposer,
    $$PermissionsTableOrderingComposer,
    $$PermissionsTableAnnotationComposer,
    $$PermissionsTableCreateCompanionBuilder,
    $$PermissionsTableUpdateCompanionBuilder,
    (Permission, BaseReferences<_$AppDatabase, $PermissionsTable, Permission>),
    Permission,
    PrefetchHooks Function()> {
  $$PermissionsTableTableManager(_$AppDatabase db, $PermissionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PermissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PermissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PermissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> module = const Value.absent(),
            Value<String> nameFa = const Value.absent(),
            Value<String?> nameEn = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PermissionsCompanion(
            id: id,
            code: code,
            module: module,
            nameFa: nameFa,
            nameEn: nameEn,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String code,
            required String module,
            required String nameFa,
            Value<String?> nameEn = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PermissionsCompanion.insert(
            id: id,
            code: code,
            module: module,
            nameFa: nameFa,
            nameEn: nameEn,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PermissionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PermissionsTable,
    Permission,
    $$PermissionsTableFilterComposer,
    $$PermissionsTableOrderingComposer,
    $$PermissionsTableAnnotationComposer,
    $$PermissionsTableCreateCompanionBuilder,
    $$PermissionsTableUpdateCompanionBuilder,
    (Permission, BaseReferences<_$AppDatabase, $PermissionsTable, Permission>),
    Permission,
    PrefetchHooks Function()>;
typedef $$UserRolesTableCreateCompanionBuilder = UserRolesCompanion Function({
  required String userId,
  required String roleId,
  Value<int> rowid,
});
typedef $$UserRolesTableUpdateCompanionBuilder = UserRolesCompanion Function({
  Value<String> userId,
  Value<String> roleId,
  Value<int> rowid,
});

class $$UserRolesTableFilterComposer
    extends Composer<_$AppDatabase, $UserRolesTable> {
  $$UserRolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roleId => $composableBuilder(
      column: $table.roleId, builder: (column) => ColumnFilters(column));
}

class $$UserRolesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserRolesTable> {
  $$UserRolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roleId => $composableBuilder(
      column: $table.roleId, builder: (column) => ColumnOrderings(column));
}

class $$UserRolesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserRolesTable> {
  $$UserRolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get roleId =>
      $composableBuilder(column: $table.roleId, builder: (column) => column);
}

class $$UserRolesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserRolesTable,
    UserRole,
    $$UserRolesTableFilterComposer,
    $$UserRolesTableOrderingComposer,
    $$UserRolesTableAnnotationComposer,
    $$UserRolesTableCreateCompanionBuilder,
    $$UserRolesTableUpdateCompanionBuilder,
    (UserRole, BaseReferences<_$AppDatabase, $UserRolesTable, UserRole>),
    UserRole,
    PrefetchHooks Function()> {
  $$UserRolesTableTableManager(_$AppDatabase db, $UserRolesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserRolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserRolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserRolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> roleId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserRolesCompanion(
            userId: userId,
            roleId: roleId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required String roleId,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserRolesCompanion.insert(
            userId: userId,
            roleId: roleId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserRolesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserRolesTable,
    UserRole,
    $$UserRolesTableFilterComposer,
    $$UserRolesTableOrderingComposer,
    $$UserRolesTableAnnotationComposer,
    $$UserRolesTableCreateCompanionBuilder,
    $$UserRolesTableUpdateCompanionBuilder,
    (UserRole, BaseReferences<_$AppDatabase, $UserRolesTable, UserRole>),
    UserRole,
    PrefetchHooks Function()>;
typedef $$RolePermissionsTableCreateCompanionBuilder = RolePermissionsCompanion
    Function({
  required String roleId,
  required String permissionId,
  Value<int> rowid,
});
typedef $$RolePermissionsTableUpdateCompanionBuilder = RolePermissionsCompanion
    Function({
  Value<String> roleId,
  Value<String> permissionId,
  Value<int> rowid,
});

class $$RolePermissionsTableFilterComposer
    extends Composer<_$AppDatabase, $RolePermissionsTable> {
  $$RolePermissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get roleId => $composableBuilder(
      column: $table.roleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get permissionId => $composableBuilder(
      column: $table.permissionId, builder: (column) => ColumnFilters(column));
}

class $$RolePermissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RolePermissionsTable> {
  $$RolePermissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get roleId => $composableBuilder(
      column: $table.roleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get permissionId => $composableBuilder(
      column: $table.permissionId,
      builder: (column) => ColumnOrderings(column));
}

class $$RolePermissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RolePermissionsTable> {
  $$RolePermissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get roleId =>
      $composableBuilder(column: $table.roleId, builder: (column) => column);

  GeneratedColumn<String> get permissionId => $composableBuilder(
      column: $table.permissionId, builder: (column) => column);
}

class $$RolePermissionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RolePermissionsTable,
    RolePermission,
    $$RolePermissionsTableFilterComposer,
    $$RolePermissionsTableOrderingComposer,
    $$RolePermissionsTableAnnotationComposer,
    $$RolePermissionsTableCreateCompanionBuilder,
    $$RolePermissionsTableUpdateCompanionBuilder,
    (
      RolePermission,
      BaseReferences<_$AppDatabase, $RolePermissionsTable, RolePermission>
    ),
    RolePermission,
    PrefetchHooks Function()> {
  $$RolePermissionsTableTableManager(
      _$AppDatabase db, $RolePermissionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RolePermissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RolePermissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RolePermissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> roleId = const Value.absent(),
            Value<String> permissionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RolePermissionsCompanion(
            roleId: roleId,
            permissionId: permissionId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String roleId,
            required String permissionId,
            Value<int> rowid = const Value.absent(),
          }) =>
              RolePermissionsCompanion.insert(
            roleId: roleId,
            permissionId: permissionId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RolePermissionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RolePermissionsTable,
    RolePermission,
    $$RolePermissionsTableFilterComposer,
    $$RolePermissionsTableOrderingComposer,
    $$RolePermissionsTableAnnotationComposer,
    $$RolePermissionsTableCreateCompanionBuilder,
    $$RolePermissionsTableUpdateCompanionBuilder,
    (
      RolePermission,
      BaseReferences<_$AppDatabase, $RolePermissionsTable, RolePermission>
    ),
    RolePermission,
    PrefetchHooks Function()>;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  required String id,
  required String userId,
  required String tokenHash,
  required int expiresAt,
  required int lastActivityAt,
  Value<String?> deviceInfo,
  Value<bool> isValid,
  Value<int> rowid,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> tokenHash,
  Value<int> expiresAt,
  Value<int> lastActivityAt,
  Value<String?> deviceInfo,
  Value<bool> isValid,
  Value<int> rowid,
});

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tokenHash => $composableBuilder(
      column: $table.tokenHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceInfo => $composableBuilder(
      column: $table.deviceInfo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isValid => $composableBuilder(
      column: $table.isValid, builder: (column) => ColumnFilters(column));
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tokenHash => $composableBuilder(
      column: $table.tokenHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceInfo => $composableBuilder(
      column: $table.deviceInfo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isValid => $composableBuilder(
      column: $table.isValid, builder: (column) => ColumnOrderings(column));
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);

  GeneratedColumn<int> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<int> get lastActivityAt => $composableBuilder(
      column: $table.lastActivityAt, builder: (column) => column);

  GeneratedColumn<String> get deviceInfo => $composableBuilder(
      column: $table.deviceInfo, builder: (column) => column);

  GeneratedColumn<bool> get isValid =>
      $composableBuilder(column: $table.isValid, builder: (column) => column);
}

class $$SessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
    Session,
    PrefetchHooks Function()> {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> tokenHash = const Value.absent(),
            Value<int> expiresAt = const Value.absent(),
            Value<int> lastActivityAt = const Value.absent(),
            Value<String?> deviceInfo = const Value.absent(),
            Value<bool> isValid = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            userId: userId,
            tokenHash: tokenHash,
            expiresAt: expiresAt,
            lastActivityAt: lastActivityAt,
            deviceInfo: deviceInfo,
            isValid: isValid,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String tokenHash,
            required int expiresAt,
            required int lastActivityAt,
            Value<String?> deviceInfo = const Value.absent(),
            Value<bool> isValid = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionsCompanion.insert(
            id: id,
            userId: userId,
            tokenHash: tokenHash,
            expiresAt: expiresAt,
            lastActivityAt: lastActivityAt,
            deviceInfo: deviceInfo,
            isValid: isValid,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
    Session,
    PrefetchHooks Function()>;
typedef $$DepartmentsTableCreateCompanionBuilder = DepartmentsCompanion
    Function({
  required String id,
  required String nameFa,
  Value<String?> nameEn,
  Value<String?> code,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$DepartmentsTableUpdateCompanionBuilder = DepartmentsCompanion
    Function({
  Value<String> id,
  Value<String> nameFa,
  Value<String?> nameEn,
  Value<String?> code,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$DepartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFa => $composableBuilder(
      column: $table.nameFa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$DepartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFa => $composableBuilder(
      column: $table.nameFa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$DepartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameFa =>
      $composableBuilder(column: $table.nameFa, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$DepartmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DepartmentsTable,
    Department,
    $$DepartmentsTableFilterComposer,
    $$DepartmentsTableOrderingComposer,
    $$DepartmentsTableAnnotationComposer,
    $$DepartmentsTableCreateCompanionBuilder,
    $$DepartmentsTableUpdateCompanionBuilder,
    (Department, BaseReferences<_$AppDatabase, $DepartmentsTable, Department>),
    Department,
    PrefetchHooks Function()> {
  $$DepartmentsTableTableManager(_$AppDatabase db, $DepartmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nameFa = const Value.absent(),
            Value<String?> nameEn = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DepartmentsCompanion(
            id: id,
            nameFa: nameFa,
            nameEn: nameEn,
            code: code,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nameFa,
            Value<String?> nameEn = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DepartmentsCompanion.insert(
            id: id,
            nameFa: nameFa,
            nameEn: nameEn,
            code: code,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DepartmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DepartmentsTable,
    Department,
    $$DepartmentsTableFilterComposer,
    $$DepartmentsTableOrderingComposer,
    $$DepartmentsTableAnnotationComposer,
    $$DepartmentsTableCreateCompanionBuilder,
    $$DepartmentsTableUpdateCompanionBuilder,
    (Department, BaseReferences<_$AppDatabase, $DepartmentsTable, Department>),
    Department,
    PrefetchHooks Function()>;
typedef $$UnitsTableCreateCompanionBuilder = UnitsCompanion Function({
  required String id,
  required String departmentId,
  required String nameFa,
  Value<String?> nameEn,
  Value<String?> code,
  Value<int> rowid,
});
typedef $$UnitsTableUpdateCompanionBuilder = UnitsCompanion Function({
  Value<String> id,
  Value<String> departmentId,
  Value<String> nameFa,
  Value<String?> nameEn,
  Value<String?> code,
  Value<int> rowid,
});

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get departmentId => $composableBuilder(
      column: $table.departmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFa => $composableBuilder(
      column: $table.nameFa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get departmentId => $composableBuilder(
      column: $table.departmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFa => $composableBuilder(
      column: $table.nameFa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get departmentId => $composableBuilder(
      column: $table.departmentId, builder: (column) => column);

  GeneratedColumn<String> get nameFa =>
      $composableBuilder(column: $table.nameFa, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);
}

class $$UnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
    Unit,
    PrefetchHooks Function()> {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> departmentId = const Value.absent(),
            Value<String> nameFa = const Value.absent(),
            Value<String?> nameEn = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitsCompanion(
            id: id,
            departmentId: departmentId,
            nameFa: nameFa,
            nameEn: nameEn,
            code: code,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String departmentId,
            required String nameFa,
            Value<String?> nameEn = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnitsCompanion.insert(
            id: id,
            departmentId: departmentId,
            nameFa: nameFa,
            nameEn: nameEn,
            code: code,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
    Unit,
    PrefetchHooks Function()>;
typedef $$EmployeesTableCreateCompanionBuilder = EmployeesCompanion Function({
  required String id,
  required String firstName,
  required String lastName,
  Value<String?> fatherName,
  required String nationalId,
  Value<String?> birthDate,
  Value<String?> birthPlace,
  Value<String?> gender,
  Value<String?> maritalStatus,
  Value<int> childrenCount,
  Value<String?> bloodGroup,
  Value<String?> militaryStatus,
  Value<String?> personalDescription,
  Value<String?> photoPath,
  Value<String?> employeeNumber,
  Value<String?> subscriptionNumber,
  Value<String?> departmentId,
  Value<String?> unitId,
  Value<String?> currentPosition,
  Value<String?> previousPosition,
  Value<String?> desiredPosition,
  Value<String?> employmentType,
  Value<String?> employmentDate,
  Value<String?> supervisorId,
  Value<String> employmentStatus,
  Value<String> personType,
  Value<String?> retirementDate,
  Value<String?> inactiveReason,
  Value<String?> jobGroup,
  Value<double?> positionBase,
  Value<double?> personalBase,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});
typedef $$EmployeesTableUpdateCompanionBuilder = EmployeesCompanion Function({
  Value<String> id,
  Value<String> firstName,
  Value<String> lastName,
  Value<String?> fatherName,
  Value<String> nationalId,
  Value<String?> birthDate,
  Value<String?> birthPlace,
  Value<String?> gender,
  Value<String?> maritalStatus,
  Value<int> childrenCount,
  Value<String?> bloodGroup,
  Value<String?> militaryStatus,
  Value<String?> personalDescription,
  Value<String?> photoPath,
  Value<String?> employeeNumber,
  Value<String?> subscriptionNumber,
  Value<String?> departmentId,
  Value<String?> unitId,
  Value<String?> currentPosition,
  Value<String?> previousPosition,
  Value<String?> desiredPosition,
  Value<String?> employmentType,
  Value<String?> employmentDate,
  Value<String?> supervisorId,
  Value<String> employmentStatus,
  Value<String> personType,
  Value<String?> retirementDate,
  Value<String?> inactiveReason,
  Value<String?> jobGroup,
  Value<double?> positionBase,
  Value<double?> personalBase,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherName => $composableBuilder(
      column: $table.fatherName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nationalId => $composableBuilder(
      column: $table.nationalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get birthDate => $composableBuilder(
      column: $table.birthDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get birthPlace => $composableBuilder(
      column: $table.birthPlace, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get maritalStatus => $composableBuilder(
      column: $table.maritalStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get childrenCount => $composableBuilder(
      column: $table.childrenCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bloodGroup => $composableBuilder(
      column: $table.bloodGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get militaryStatus => $composableBuilder(
      column: $table.militaryStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personalDescription => $composableBuilder(
      column: $table.personalDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeNumber => $composableBuilder(
      column: $table.employeeNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subscriptionNumber => $composableBuilder(
      column: $table.subscriptionNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get departmentId => $composableBuilder(
      column: $table.departmentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentPosition => $composableBuilder(
      column: $table.currentPosition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previousPosition => $composableBuilder(
      column: $table.previousPosition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get desiredPosition => $composableBuilder(
      column: $table.desiredPosition,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employmentType => $composableBuilder(
      column: $table.employmentType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employmentDate => $composableBuilder(
      column: $table.employmentDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employmentStatus => $composableBuilder(
      column: $table.employmentStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personType => $composableBuilder(
      column: $table.personType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get retirementDate => $composableBuilder(
      column: $table.retirementDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inactiveReason => $composableBuilder(
      column: $table.inactiveReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jobGroup => $composableBuilder(
      column: $table.jobGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get positionBase => $composableBuilder(
      column: $table.positionBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get personalBase => $composableBuilder(
      column: $table.personalBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherName => $composableBuilder(
      column: $table.fatherName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nationalId => $composableBuilder(
      column: $table.nationalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get birthDate => $composableBuilder(
      column: $table.birthDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get birthPlace => $composableBuilder(
      column: $table.birthPlace, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get maritalStatus => $composableBuilder(
      column: $table.maritalStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get childrenCount => $composableBuilder(
      column: $table.childrenCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bloodGroup => $composableBuilder(
      column: $table.bloodGroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get militaryStatus => $composableBuilder(
      column: $table.militaryStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personalDescription => $composableBuilder(
      column: $table.personalDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeNumber => $composableBuilder(
      column: $table.employeeNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subscriptionNumber => $composableBuilder(
      column: $table.subscriptionNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get departmentId => $composableBuilder(
      column: $table.departmentId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentPosition => $composableBuilder(
      column: $table.currentPosition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previousPosition => $composableBuilder(
      column: $table.previousPosition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get desiredPosition => $composableBuilder(
      column: $table.desiredPosition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employmentType => $composableBuilder(
      column: $table.employmentType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employmentDate => $composableBuilder(
      column: $table.employmentDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employmentStatus => $composableBuilder(
      column: $table.employmentStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personType => $composableBuilder(
      column: $table.personType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get retirementDate => $composableBuilder(
      column: $table.retirementDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inactiveReason => $composableBuilder(
      column: $table.inactiveReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jobGroup => $composableBuilder(
      column: $table.jobGroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get positionBase => $composableBuilder(
      column: $table.positionBase,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get personalBase => $composableBuilder(
      column: $table.personalBase,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get fatherName => $composableBuilder(
      column: $table.fatherName, builder: (column) => column);

  GeneratedColumn<String> get nationalId => $composableBuilder(
      column: $table.nationalId, builder: (column) => column);

  GeneratedColumn<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get birthPlace => $composableBuilder(
      column: $table.birthPlace, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get maritalStatus => $composableBuilder(
      column: $table.maritalStatus, builder: (column) => column);

  GeneratedColumn<int> get childrenCount => $composableBuilder(
      column: $table.childrenCount, builder: (column) => column);

  GeneratedColumn<String> get bloodGroup => $composableBuilder(
      column: $table.bloodGroup, builder: (column) => column);

  GeneratedColumn<String> get militaryStatus => $composableBuilder(
      column: $table.militaryStatus, builder: (column) => column);

  GeneratedColumn<String> get personalDescription => $composableBuilder(
      column: $table.personalDescription, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get employeeNumber => $composableBuilder(
      column: $table.employeeNumber, builder: (column) => column);

  GeneratedColumn<String> get subscriptionNumber => $composableBuilder(
      column: $table.subscriptionNumber, builder: (column) => column);

  GeneratedColumn<String> get departmentId => $composableBuilder(
      column: $table.departmentId, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<String> get currentPosition => $composableBuilder(
      column: $table.currentPosition, builder: (column) => column);

  GeneratedColumn<String> get previousPosition => $composableBuilder(
      column: $table.previousPosition, builder: (column) => column);

  GeneratedColumn<String> get desiredPosition => $composableBuilder(
      column: $table.desiredPosition, builder: (column) => column);

  GeneratedColumn<String> get employmentType => $composableBuilder(
      column: $table.employmentType, builder: (column) => column);

  GeneratedColumn<String> get employmentDate => $composableBuilder(
      column: $table.employmentDate, builder: (column) => column);

  GeneratedColumn<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId, builder: (column) => column);

  GeneratedColumn<String> get employmentStatus => $composableBuilder(
      column: $table.employmentStatus, builder: (column) => column);

  GeneratedColumn<String> get personType => $composableBuilder(
      column: $table.personType, builder: (column) => column);

  GeneratedColumn<String> get retirementDate => $composableBuilder(
      column: $table.retirementDate, builder: (column) => column);

  GeneratedColumn<String> get inactiveReason => $composableBuilder(
      column: $table.inactiveReason, builder: (column) => column);

  GeneratedColumn<String> get jobGroup =>
      $composableBuilder(column: $table.jobGroup, builder: (column) => column);

  GeneratedColumn<double> get positionBase => $composableBuilder(
      column: $table.positionBase, builder: (column) => column);

  GeneratedColumn<double> get personalBase => $composableBuilder(
      column: $table.personalBase, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$EmployeesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeesTable,
    Employee,
    $$EmployeesTableFilterComposer,
    $$EmployeesTableOrderingComposer,
    $$EmployeesTableAnnotationComposer,
    $$EmployeesTableCreateCompanionBuilder,
    $$EmployeesTableUpdateCompanionBuilder,
    (Employee, BaseReferences<_$AppDatabase, $EmployeesTable, Employee>),
    Employee,
    PrefetchHooks Function()> {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String?> fatherName = const Value.absent(),
            Value<String> nationalId = const Value.absent(),
            Value<String?> birthDate = const Value.absent(),
            Value<String?> birthPlace = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> maritalStatus = const Value.absent(),
            Value<int> childrenCount = const Value.absent(),
            Value<String?> bloodGroup = const Value.absent(),
            Value<String?> militaryStatus = const Value.absent(),
            Value<String?> personalDescription = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> employeeNumber = const Value.absent(),
            Value<String?> subscriptionNumber = const Value.absent(),
            Value<String?> departmentId = const Value.absent(),
            Value<String?> unitId = const Value.absent(),
            Value<String?> currentPosition = const Value.absent(),
            Value<String?> previousPosition = const Value.absent(),
            Value<String?> desiredPosition = const Value.absent(),
            Value<String?> employmentType = const Value.absent(),
            Value<String?> employmentDate = const Value.absent(),
            Value<String?> supervisorId = const Value.absent(),
            Value<String> employmentStatus = const Value.absent(),
            Value<String> personType = const Value.absent(),
            Value<String?> retirementDate = const Value.absent(),
            Value<String?> inactiveReason = const Value.absent(),
            Value<String?> jobGroup = const Value.absent(),
            Value<double?> positionBase = const Value.absent(),
            Value<double?> personalBase = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeesCompanion(
            id: id,
            firstName: firstName,
            lastName: lastName,
            fatherName: fatherName,
            nationalId: nationalId,
            birthDate: birthDate,
            birthPlace: birthPlace,
            gender: gender,
            maritalStatus: maritalStatus,
            childrenCount: childrenCount,
            bloodGroup: bloodGroup,
            militaryStatus: militaryStatus,
            personalDescription: personalDescription,
            photoPath: photoPath,
            employeeNumber: employeeNumber,
            subscriptionNumber: subscriptionNumber,
            departmentId: departmentId,
            unitId: unitId,
            currentPosition: currentPosition,
            previousPosition: previousPosition,
            desiredPosition: desiredPosition,
            employmentType: employmentType,
            employmentDate: employmentDate,
            supervisorId: supervisorId,
            employmentStatus: employmentStatus,
            personType: personType,
            retirementDate: retirementDate,
            inactiveReason: inactiveReason,
            jobGroup: jobGroup,
            positionBase: positionBase,
            personalBase: personalBase,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String firstName,
            required String lastName,
            Value<String?> fatherName = const Value.absent(),
            required String nationalId,
            Value<String?> birthDate = const Value.absent(),
            Value<String?> birthPlace = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> maritalStatus = const Value.absent(),
            Value<int> childrenCount = const Value.absent(),
            Value<String?> bloodGroup = const Value.absent(),
            Value<String?> militaryStatus = const Value.absent(),
            Value<String?> personalDescription = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> employeeNumber = const Value.absent(),
            Value<String?> subscriptionNumber = const Value.absent(),
            Value<String?> departmentId = const Value.absent(),
            Value<String?> unitId = const Value.absent(),
            Value<String?> currentPosition = const Value.absent(),
            Value<String?> previousPosition = const Value.absent(),
            Value<String?> desiredPosition = const Value.absent(),
            Value<String?> employmentType = const Value.absent(),
            Value<String?> employmentDate = const Value.absent(),
            Value<String?> supervisorId = const Value.absent(),
            Value<String> employmentStatus = const Value.absent(),
            Value<String> personType = const Value.absent(),
            Value<String?> retirementDate = const Value.absent(),
            Value<String?> inactiveReason = const Value.absent(),
            Value<String?> jobGroup = const Value.absent(),
            Value<double?> positionBase = const Value.absent(),
            Value<double?> personalBase = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeesCompanion.insert(
            id: id,
            firstName: firstName,
            lastName: lastName,
            fatherName: fatherName,
            nationalId: nationalId,
            birthDate: birthDate,
            birthPlace: birthPlace,
            gender: gender,
            maritalStatus: maritalStatus,
            childrenCount: childrenCount,
            bloodGroup: bloodGroup,
            militaryStatus: militaryStatus,
            personalDescription: personalDescription,
            photoPath: photoPath,
            employeeNumber: employeeNumber,
            subscriptionNumber: subscriptionNumber,
            departmentId: departmentId,
            unitId: unitId,
            currentPosition: currentPosition,
            previousPosition: previousPosition,
            desiredPosition: desiredPosition,
            employmentType: employmentType,
            employmentDate: employmentDate,
            supervisorId: supervisorId,
            employmentStatus: employmentStatus,
            personType: personType,
            retirementDate: retirementDate,
            inactiveReason: inactiveReason,
            jobGroup: jobGroup,
            positionBase: positionBase,
            personalBase: personalBase,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeesTable,
    Employee,
    $$EmployeesTableFilterComposer,
    $$EmployeesTableOrderingComposer,
    $$EmployeesTableAnnotationComposer,
    $$EmployeesTableCreateCompanionBuilder,
    $$EmployeesTableUpdateCompanionBuilder,
    (Employee, BaseReferences<_$AppDatabase, $EmployeesTable, Employee>),
    Employee,
    PrefetchHooks Function()>;
typedef $$EmployeeContactsTableCreateCompanionBuilder
    = EmployeeContactsCompanion Function({
  required String employeeId,
  Value<String?> primaryPhone,
  Value<String?> secondaryPhone,
  Value<String?> emergencyPhone,
  Value<String?> email,
  Value<String?> homeAddress,
  Value<String?> postalCode,
  Value<int> rowid,
});
typedef $$EmployeeContactsTableUpdateCompanionBuilder
    = EmployeeContactsCompanion Function({
  Value<String> employeeId,
  Value<String?> primaryPhone,
  Value<String?> secondaryPhone,
  Value<String?> emergencyPhone,
  Value<String?> email,
  Value<String?> homeAddress,
  Value<String?> postalCode,
  Value<int> rowid,
});

class $$EmployeeContactsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeContactsTable> {
  $$EmployeeContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryPhone => $composableBuilder(
      column: $table.primaryPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get secondaryPhone => $composableBuilder(
      column: $table.secondaryPhone,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyPhone => $composableBuilder(
      column: $table.emergencyPhone,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get homeAddress => $composableBuilder(
      column: $table.homeAddress, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => ColumnFilters(column));
}

class $$EmployeeContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeContactsTable> {
  $$EmployeeContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryPhone => $composableBuilder(
      column: $table.primaryPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get secondaryPhone => $composableBuilder(
      column: $table.secondaryPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyPhone => $composableBuilder(
      column: $table.emergencyPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get homeAddress => $composableBuilder(
      column: $table.homeAddress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeContactsTable> {
  $$EmployeeContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get primaryPhone => $composableBuilder(
      column: $table.primaryPhone, builder: (column) => column);

  GeneratedColumn<String> get secondaryPhone => $composableBuilder(
      column: $table.secondaryPhone, builder: (column) => column);

  GeneratedColumn<String> get emergencyPhone => $composableBuilder(
      column: $table.emergencyPhone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get homeAddress => $composableBuilder(
      column: $table.homeAddress, builder: (column) => column);

  GeneratedColumn<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => column);
}

class $$EmployeeContactsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeContactsTable,
    EmployeeContact,
    $$EmployeeContactsTableFilterComposer,
    $$EmployeeContactsTableOrderingComposer,
    $$EmployeeContactsTableAnnotationComposer,
    $$EmployeeContactsTableCreateCompanionBuilder,
    $$EmployeeContactsTableUpdateCompanionBuilder,
    (
      EmployeeContact,
      BaseReferences<_$AppDatabase, $EmployeeContactsTable, EmployeeContact>
    ),
    EmployeeContact,
    PrefetchHooks Function()> {
  $$EmployeeContactsTableTableManager(
      _$AppDatabase db, $EmployeeContactsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> employeeId = const Value.absent(),
            Value<String?> primaryPhone = const Value.absent(),
            Value<String?> secondaryPhone = const Value.absent(),
            Value<String?> emergencyPhone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> homeAddress = const Value.absent(),
            Value<String?> postalCode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeContactsCompanion(
            employeeId: employeeId,
            primaryPhone: primaryPhone,
            secondaryPhone: secondaryPhone,
            emergencyPhone: emergencyPhone,
            email: email,
            homeAddress: homeAddress,
            postalCode: postalCode,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String employeeId,
            Value<String?> primaryPhone = const Value.absent(),
            Value<String?> secondaryPhone = const Value.absent(),
            Value<String?> emergencyPhone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> homeAddress = const Value.absent(),
            Value<String?> postalCode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeContactsCompanion.insert(
            employeeId: employeeId,
            primaryPhone: primaryPhone,
            secondaryPhone: secondaryPhone,
            emergencyPhone: emergencyPhone,
            email: email,
            homeAddress: homeAddress,
            postalCode: postalCode,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeContactsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeeContactsTable,
    EmployeeContact,
    $$EmployeeContactsTableFilterComposer,
    $$EmployeeContactsTableOrderingComposer,
    $$EmployeeContactsTableAnnotationComposer,
    $$EmployeeContactsTableCreateCompanionBuilder,
    $$EmployeeContactsTableUpdateCompanionBuilder,
    (
      EmployeeContact,
      BaseReferences<_$AppDatabase, $EmployeeContactsTable, EmployeeContact>
    ),
    EmployeeContact,
    PrefetchHooks Function()>;
typedef $$EmployeeSocialsTableCreateCompanionBuilder = EmployeeSocialsCompanion
    Function({
  required String employeeId,
  Value<String?> telegram,
  Value<String?> whatsapp,
  Value<String?> instagram,
  Value<String?> linkedin,
  Value<String?> otherLinksJson,
  Value<int> rowid,
});
typedef $$EmployeeSocialsTableUpdateCompanionBuilder = EmployeeSocialsCompanion
    Function({
  Value<String> employeeId,
  Value<String?> telegram,
  Value<String?> whatsapp,
  Value<String?> instagram,
  Value<String?> linkedin,
  Value<String?> otherLinksJson,
  Value<int> rowid,
});

class $$EmployeeSocialsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeSocialsTable> {
  $$EmployeeSocialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telegram => $composableBuilder(
      column: $table.telegram, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whatsapp => $composableBuilder(
      column: $table.whatsapp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instagram => $composableBuilder(
      column: $table.instagram, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedin => $composableBuilder(
      column: $table.linkedin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get otherLinksJson => $composableBuilder(
      column: $table.otherLinksJson,
      builder: (column) => ColumnFilters(column));
}

class $$EmployeeSocialsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeSocialsTable> {
  $$EmployeeSocialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telegram => $composableBuilder(
      column: $table.telegram, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whatsapp => $composableBuilder(
      column: $table.whatsapp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instagram => $composableBuilder(
      column: $table.instagram, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedin => $composableBuilder(
      column: $table.linkedin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get otherLinksJson => $composableBuilder(
      column: $table.otherLinksJson,
      builder: (column) => ColumnOrderings(column));
}

class $$EmployeeSocialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeSocialsTable> {
  $$EmployeeSocialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get telegram =>
      $composableBuilder(column: $table.telegram, builder: (column) => column);

  GeneratedColumn<String> get whatsapp =>
      $composableBuilder(column: $table.whatsapp, builder: (column) => column);

  GeneratedColumn<String> get instagram =>
      $composableBuilder(column: $table.instagram, builder: (column) => column);

  GeneratedColumn<String> get linkedin =>
      $composableBuilder(column: $table.linkedin, builder: (column) => column);

  GeneratedColumn<String> get otherLinksJson => $composableBuilder(
      column: $table.otherLinksJson, builder: (column) => column);
}

class $$EmployeeSocialsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeSocialsTable,
    EmployeeSocial,
    $$EmployeeSocialsTableFilterComposer,
    $$EmployeeSocialsTableOrderingComposer,
    $$EmployeeSocialsTableAnnotationComposer,
    $$EmployeeSocialsTableCreateCompanionBuilder,
    $$EmployeeSocialsTableUpdateCompanionBuilder,
    (
      EmployeeSocial,
      BaseReferences<_$AppDatabase, $EmployeeSocialsTable, EmployeeSocial>
    ),
    EmployeeSocial,
    PrefetchHooks Function()> {
  $$EmployeeSocialsTableTableManager(
      _$AppDatabase db, $EmployeeSocialsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeSocialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeSocialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeSocialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> employeeId = const Value.absent(),
            Value<String?> telegram = const Value.absent(),
            Value<String?> whatsapp = const Value.absent(),
            Value<String?> instagram = const Value.absent(),
            Value<String?> linkedin = const Value.absent(),
            Value<String?> otherLinksJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeSocialsCompanion(
            employeeId: employeeId,
            telegram: telegram,
            whatsapp: whatsapp,
            instagram: instagram,
            linkedin: linkedin,
            otherLinksJson: otherLinksJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String employeeId,
            Value<String?> telegram = const Value.absent(),
            Value<String?> whatsapp = const Value.absent(),
            Value<String?> instagram = const Value.absent(),
            Value<String?> linkedin = const Value.absent(),
            Value<String?> otherLinksJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeSocialsCompanion.insert(
            employeeId: employeeId,
            telegram: telegram,
            whatsapp: whatsapp,
            instagram: instagram,
            linkedin: linkedin,
            otherLinksJson: otherLinksJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeSocialsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeeSocialsTable,
    EmployeeSocial,
    $$EmployeeSocialsTableFilterComposer,
    $$EmployeeSocialsTableOrderingComposer,
    $$EmployeeSocialsTableAnnotationComposer,
    $$EmployeeSocialsTableCreateCompanionBuilder,
    $$EmployeeSocialsTableUpdateCompanionBuilder,
    (
      EmployeeSocial,
      BaseReferences<_$AppDatabase, $EmployeeSocialsTable, EmployeeSocial>
    ),
    EmployeeSocial,
    PrefetchHooks Function()>;
typedef $$EmployeeEducationsTableCreateCompanionBuilder
    = EmployeeEducationsCompanion Function({
  required String id,
  required String employeeId,
  Value<String?> educationLevel,
  Value<String?> major,
  Value<String?> university,
  Value<String?> graduationDate,
  Value<double?> gpa,
  Value<String?> certificates,
  Value<int> rowid,
});
typedef $$EmployeeEducationsTableUpdateCompanionBuilder
    = EmployeeEducationsCompanion Function({
  Value<String> id,
  Value<String> employeeId,
  Value<String?> educationLevel,
  Value<String?> major,
  Value<String?> university,
  Value<String?> graduationDate,
  Value<double?> gpa,
  Value<String?> certificates,
  Value<int> rowid,
});

class $$EmployeeEducationsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeEducationsTable> {
  $$EmployeeEducationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get educationLevel => $composableBuilder(
      column: $table.educationLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get major => $composableBuilder(
      column: $table.major, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get university => $composableBuilder(
      column: $table.university, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get graduationDate => $composableBuilder(
      column: $table.graduationDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gpa => $composableBuilder(
      column: $table.gpa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get certificates => $composableBuilder(
      column: $table.certificates, builder: (column) => ColumnFilters(column));
}

class $$EmployeeEducationsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeEducationsTable> {
  $$EmployeeEducationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get educationLevel => $composableBuilder(
      column: $table.educationLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get major => $composableBuilder(
      column: $table.major, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get university => $composableBuilder(
      column: $table.university, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get graduationDate => $composableBuilder(
      column: $table.graduationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gpa => $composableBuilder(
      column: $table.gpa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get certificates => $composableBuilder(
      column: $table.certificates,
      builder: (column) => ColumnOrderings(column));
}

class $$EmployeeEducationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeEducationsTable> {
  $$EmployeeEducationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get educationLevel => $composableBuilder(
      column: $table.educationLevel, builder: (column) => column);

  GeneratedColumn<String> get major =>
      $composableBuilder(column: $table.major, builder: (column) => column);

  GeneratedColumn<String> get university => $composableBuilder(
      column: $table.university, builder: (column) => column);

  GeneratedColumn<String> get graduationDate => $composableBuilder(
      column: $table.graduationDate, builder: (column) => column);

  GeneratedColumn<double> get gpa =>
      $composableBuilder(column: $table.gpa, builder: (column) => column);

  GeneratedColumn<String> get certificates => $composableBuilder(
      column: $table.certificates, builder: (column) => column);
}

class $$EmployeeEducationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeEducationsTable,
    EmployeeEducation,
    $$EmployeeEducationsTableFilterComposer,
    $$EmployeeEducationsTableOrderingComposer,
    $$EmployeeEducationsTableAnnotationComposer,
    $$EmployeeEducationsTableCreateCompanionBuilder,
    $$EmployeeEducationsTableUpdateCompanionBuilder,
    (
      EmployeeEducation,
      BaseReferences<_$AppDatabase, $EmployeeEducationsTable, EmployeeEducation>
    ),
    EmployeeEducation,
    PrefetchHooks Function()> {
  $$EmployeeEducationsTableTableManager(
      _$AppDatabase db, $EmployeeEducationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeEducationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeEducationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeEducationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<String?> educationLevel = const Value.absent(),
            Value<String?> major = const Value.absent(),
            Value<String?> university = const Value.absent(),
            Value<String?> graduationDate = const Value.absent(),
            Value<double?> gpa = const Value.absent(),
            Value<String?> certificates = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeEducationsCompanion(
            id: id,
            employeeId: employeeId,
            educationLevel: educationLevel,
            major: major,
            university: university,
            graduationDate: graduationDate,
            gpa: gpa,
            certificates: certificates,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            Value<String?> educationLevel = const Value.absent(),
            Value<String?> major = const Value.absent(),
            Value<String?> university = const Value.absent(),
            Value<String?> graduationDate = const Value.absent(),
            Value<double?> gpa = const Value.absent(),
            Value<String?> certificates = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeEducationsCompanion.insert(
            id: id,
            employeeId: employeeId,
            educationLevel: educationLevel,
            major: major,
            university: university,
            graduationDate: graduationDate,
            gpa: gpa,
            certificates: certificates,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeEducationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeeEducationsTable,
    EmployeeEducation,
    $$EmployeeEducationsTableFilterComposer,
    $$EmployeeEducationsTableOrderingComposer,
    $$EmployeeEducationsTableAnnotationComposer,
    $$EmployeeEducationsTableCreateCompanionBuilder,
    $$EmployeeEducationsTableUpdateCompanionBuilder,
    (
      EmployeeEducation,
      BaseReferences<_$AppDatabase, $EmployeeEducationsTable, EmployeeEducation>
    ),
    EmployeeEducation,
    PrefetchHooks Function()>;
typedef $$EmployeeSkillsTableCreateCompanionBuilder = EmployeeSkillsCompanion
    Function({
  required String id,
  required String employeeId,
  required String skillName,
  Value<String?> level,
  Value<String?> certificate,
  Value<String?> expiryDate,
  Value<String?> attachmentPath,
  Value<int> rowid,
});
typedef $$EmployeeSkillsTableUpdateCompanionBuilder = EmployeeSkillsCompanion
    Function({
  Value<String> id,
  Value<String> employeeId,
  Value<String> skillName,
  Value<String?> level,
  Value<String?> certificate,
  Value<String?> expiryDate,
  Value<String?> attachmentPath,
  Value<int> rowid,
});

class $$EmployeeSkillsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeSkillsTable> {
  $$EmployeeSkillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get skillName => $composableBuilder(
      column: $table.skillName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get certificate => $composableBuilder(
      column: $table.certificate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attachmentPath => $composableBuilder(
      column: $table.attachmentPath,
      builder: (column) => ColumnFilters(column));
}

class $$EmployeeSkillsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeSkillsTable> {
  $$EmployeeSkillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get skillName => $composableBuilder(
      column: $table.skillName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get certificate => $composableBuilder(
      column: $table.certificate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachmentPath => $composableBuilder(
      column: $table.attachmentPath,
      builder: (column) => ColumnOrderings(column));
}

class $$EmployeeSkillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeSkillsTable> {
  $$EmployeeSkillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get skillName =>
      $composableBuilder(column: $table.skillName, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get certificate => $composableBuilder(
      column: $table.certificate, builder: (column) => column);

  GeneratedColumn<String> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<String> get attachmentPath => $composableBuilder(
      column: $table.attachmentPath, builder: (column) => column);
}

class $$EmployeeSkillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeSkillsTable,
    EmployeeSkill,
    $$EmployeeSkillsTableFilterComposer,
    $$EmployeeSkillsTableOrderingComposer,
    $$EmployeeSkillsTableAnnotationComposer,
    $$EmployeeSkillsTableCreateCompanionBuilder,
    $$EmployeeSkillsTableUpdateCompanionBuilder,
    (
      EmployeeSkill,
      BaseReferences<_$AppDatabase, $EmployeeSkillsTable, EmployeeSkill>
    ),
    EmployeeSkill,
    PrefetchHooks Function()> {
  $$EmployeeSkillsTableTableManager(
      _$AppDatabase db, $EmployeeSkillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeSkillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeSkillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeSkillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<String> skillName = const Value.absent(),
            Value<String?> level = const Value.absent(),
            Value<String?> certificate = const Value.absent(),
            Value<String?> expiryDate = const Value.absent(),
            Value<String?> attachmentPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeSkillsCompanion(
            id: id,
            employeeId: employeeId,
            skillName: skillName,
            level: level,
            certificate: certificate,
            expiryDate: expiryDate,
            attachmentPath: attachmentPath,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            required String skillName,
            Value<String?> level = const Value.absent(),
            Value<String?> certificate = const Value.absent(),
            Value<String?> expiryDate = const Value.absent(),
            Value<String?> attachmentPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeSkillsCompanion.insert(
            id: id,
            employeeId: employeeId,
            skillName: skillName,
            level: level,
            certificate: certificate,
            expiryDate: expiryDate,
            attachmentPath: attachmentPath,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeSkillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeeSkillsTable,
    EmployeeSkill,
    $$EmployeeSkillsTableFilterComposer,
    $$EmployeeSkillsTableOrderingComposer,
    $$EmployeeSkillsTableAnnotationComposer,
    $$EmployeeSkillsTableCreateCompanionBuilder,
    $$EmployeeSkillsTableUpdateCompanionBuilder,
    (
      EmployeeSkill,
      BaseReferences<_$AppDatabase, $EmployeeSkillsTable, EmployeeSkill>
    ),
    EmployeeSkill,
    PrefetchHooks Function()>;
typedef $$EmployeeInterestsTableCreateCompanionBuilder
    = EmployeeInterestsCompanion Function({
  required String employeeId,
  Value<String?> careerInterests,
  Value<String?> technicalInterests,
  Value<String?> managementInterests,
  Value<String?> personalInterests,
  Value<String?> talentAssessment,
  Value<String?> behaviorAssessment,
  Value<String?> psychologicalNotes,
  Value<String?> managerNotes,
  Value<int> rowid,
});
typedef $$EmployeeInterestsTableUpdateCompanionBuilder
    = EmployeeInterestsCompanion Function({
  Value<String> employeeId,
  Value<String?> careerInterests,
  Value<String?> technicalInterests,
  Value<String?> managementInterests,
  Value<String?> personalInterests,
  Value<String?> talentAssessment,
  Value<String?> behaviorAssessment,
  Value<String?> psychologicalNotes,
  Value<String?> managerNotes,
  Value<int> rowid,
});

class $$EmployeeInterestsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeInterestsTable> {
  $$EmployeeInterestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get careerInterests => $composableBuilder(
      column: $table.careerInterests,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get technicalInterests => $composableBuilder(
      column: $table.technicalInterests,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get managementInterests => $composableBuilder(
      column: $table.managementInterests,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personalInterests => $composableBuilder(
      column: $table.personalInterests,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get talentAssessment => $composableBuilder(
      column: $table.talentAssessment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get behaviorAssessment => $composableBuilder(
      column: $table.behaviorAssessment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get psychologicalNotes => $composableBuilder(
      column: $table.psychologicalNotes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get managerNotes => $composableBuilder(
      column: $table.managerNotes, builder: (column) => ColumnFilters(column));
}

class $$EmployeeInterestsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeInterestsTable> {
  $$EmployeeInterestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get careerInterests => $composableBuilder(
      column: $table.careerInterests,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get technicalInterests => $composableBuilder(
      column: $table.technicalInterests,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get managementInterests => $composableBuilder(
      column: $table.managementInterests,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personalInterests => $composableBuilder(
      column: $table.personalInterests,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get talentAssessment => $composableBuilder(
      column: $table.talentAssessment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get behaviorAssessment => $composableBuilder(
      column: $table.behaviorAssessment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get psychologicalNotes => $composableBuilder(
      column: $table.psychologicalNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get managerNotes => $composableBuilder(
      column: $table.managerNotes,
      builder: (column) => ColumnOrderings(column));
}

class $$EmployeeInterestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeInterestsTable> {
  $$EmployeeInterestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get careerInterests => $composableBuilder(
      column: $table.careerInterests, builder: (column) => column);

  GeneratedColumn<String> get technicalInterests => $composableBuilder(
      column: $table.technicalInterests, builder: (column) => column);

  GeneratedColumn<String> get managementInterests => $composableBuilder(
      column: $table.managementInterests, builder: (column) => column);

  GeneratedColumn<String> get personalInterests => $composableBuilder(
      column: $table.personalInterests, builder: (column) => column);

  GeneratedColumn<String> get talentAssessment => $composableBuilder(
      column: $table.talentAssessment, builder: (column) => column);

  GeneratedColumn<String> get behaviorAssessment => $composableBuilder(
      column: $table.behaviorAssessment, builder: (column) => column);

  GeneratedColumn<String> get psychologicalNotes => $composableBuilder(
      column: $table.psychologicalNotes, builder: (column) => column);

  GeneratedColumn<String> get managerNotes => $composableBuilder(
      column: $table.managerNotes, builder: (column) => column);
}

class $$EmployeeInterestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeInterestsTable,
    EmployeeInterest,
    $$EmployeeInterestsTableFilterComposer,
    $$EmployeeInterestsTableOrderingComposer,
    $$EmployeeInterestsTableAnnotationComposer,
    $$EmployeeInterestsTableCreateCompanionBuilder,
    $$EmployeeInterestsTableUpdateCompanionBuilder,
    (
      EmployeeInterest,
      BaseReferences<_$AppDatabase, $EmployeeInterestsTable, EmployeeInterest>
    ),
    EmployeeInterest,
    PrefetchHooks Function()> {
  $$EmployeeInterestsTableTableManager(
      _$AppDatabase db, $EmployeeInterestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeInterestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeInterestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeInterestsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> employeeId = const Value.absent(),
            Value<String?> careerInterests = const Value.absent(),
            Value<String?> technicalInterests = const Value.absent(),
            Value<String?> managementInterests = const Value.absent(),
            Value<String?> personalInterests = const Value.absent(),
            Value<String?> talentAssessment = const Value.absent(),
            Value<String?> behaviorAssessment = const Value.absent(),
            Value<String?> psychologicalNotes = const Value.absent(),
            Value<String?> managerNotes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeInterestsCompanion(
            employeeId: employeeId,
            careerInterests: careerInterests,
            technicalInterests: technicalInterests,
            managementInterests: managementInterests,
            personalInterests: personalInterests,
            talentAssessment: talentAssessment,
            behaviorAssessment: behaviorAssessment,
            psychologicalNotes: psychologicalNotes,
            managerNotes: managerNotes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String employeeId,
            Value<String?> careerInterests = const Value.absent(),
            Value<String?> technicalInterests = const Value.absent(),
            Value<String?> managementInterests = const Value.absent(),
            Value<String?> personalInterests = const Value.absent(),
            Value<String?> talentAssessment = const Value.absent(),
            Value<String?> behaviorAssessment = const Value.absent(),
            Value<String?> psychologicalNotes = const Value.absent(),
            Value<String?> managerNotes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeInterestsCompanion.insert(
            employeeId: employeeId,
            careerInterests: careerInterests,
            technicalInterests: technicalInterests,
            managementInterests: managementInterests,
            personalInterests: personalInterests,
            talentAssessment: talentAssessment,
            behaviorAssessment: behaviorAssessment,
            psychologicalNotes: psychologicalNotes,
            managerNotes: managerNotes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeInterestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeeInterestsTable,
    EmployeeInterest,
    $$EmployeeInterestsTableFilterComposer,
    $$EmployeeInterestsTableOrderingComposer,
    $$EmployeeInterestsTableAnnotationComposer,
    $$EmployeeInterestsTableCreateCompanionBuilder,
    $$EmployeeInterestsTableUpdateCompanionBuilder,
    (
      EmployeeInterest,
      BaseReferences<_$AppDatabase, $EmployeeInterestsTable, EmployeeInterest>
    ),
    EmployeeInterest,
    PrefetchHooks Function()>;
typedef $$EmployeeInsurancesTableCreateCompanionBuilder
    = EmployeeInsurancesCompanion Function({
  required String id,
  required String employeeId,
  Value<String?> responsibility,
  Value<String?> insuranceNumber,
  Value<String?> insuranceType,
  Value<String?> insuranceStatus,
  Value<String?> notes,
  Value<int?> effectiveFrom,
  Value<int?> effectiveTo,
  required int createdAt,
  Value<int> rowid,
});
typedef $$EmployeeInsurancesTableUpdateCompanionBuilder
    = EmployeeInsurancesCompanion Function({
  Value<String> id,
  Value<String> employeeId,
  Value<String?> responsibility,
  Value<String?> insuranceNumber,
  Value<String?> insuranceType,
  Value<String?> insuranceStatus,
  Value<String?> notes,
  Value<int?> effectiveFrom,
  Value<int?> effectiveTo,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$EmployeeInsurancesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeInsurancesTable> {
  $$EmployeeInsurancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get responsibility => $composableBuilder(
      column: $table.responsibility,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get insuranceNumber => $composableBuilder(
      column: $table.insuranceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get insuranceType => $composableBuilder(
      column: $table.insuranceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get insuranceStatus => $composableBuilder(
      column: $table.insuranceStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get effectiveTo => $composableBuilder(
      column: $table.effectiveTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$EmployeeInsurancesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeInsurancesTable> {
  $$EmployeeInsurancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get responsibility => $composableBuilder(
      column: $table.responsibility,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get insuranceNumber => $composableBuilder(
      column: $table.insuranceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get insuranceType => $composableBuilder(
      column: $table.insuranceType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get insuranceStatus => $composableBuilder(
      column: $table.insuranceStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get effectiveTo => $composableBuilder(
      column: $table.effectiveTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeInsurancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeInsurancesTable> {
  $$EmployeeInsurancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get responsibility => $composableBuilder(
      column: $table.responsibility, builder: (column) => column);

  GeneratedColumn<String> get insuranceNumber => $composableBuilder(
      column: $table.insuranceNumber, builder: (column) => column);

  GeneratedColumn<String> get insuranceType => $composableBuilder(
      column: $table.insuranceType, builder: (column) => column);

  GeneratedColumn<String> get insuranceStatus => $composableBuilder(
      column: $table.insuranceStatus, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom, builder: (column) => column);

  GeneratedColumn<int> get effectiveTo => $composableBuilder(
      column: $table.effectiveTo, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EmployeeInsurancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeInsurancesTable,
    EmployeeInsurance,
    $$EmployeeInsurancesTableFilterComposer,
    $$EmployeeInsurancesTableOrderingComposer,
    $$EmployeeInsurancesTableAnnotationComposer,
    $$EmployeeInsurancesTableCreateCompanionBuilder,
    $$EmployeeInsurancesTableUpdateCompanionBuilder,
    (
      EmployeeInsurance,
      BaseReferences<_$AppDatabase, $EmployeeInsurancesTable, EmployeeInsurance>
    ),
    EmployeeInsurance,
    PrefetchHooks Function()> {
  $$EmployeeInsurancesTableTableManager(
      _$AppDatabase db, $EmployeeInsurancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeInsurancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeInsurancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeInsurancesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<String?> responsibility = const Value.absent(),
            Value<String?> insuranceNumber = const Value.absent(),
            Value<String?> insuranceType = const Value.absent(),
            Value<String?> insuranceStatus = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> effectiveFrom = const Value.absent(),
            Value<int?> effectiveTo = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeInsurancesCompanion(
            id: id,
            employeeId: employeeId,
            responsibility: responsibility,
            insuranceNumber: insuranceNumber,
            insuranceType: insuranceType,
            insuranceStatus: insuranceStatus,
            notes: notes,
            effectiveFrom: effectiveFrom,
            effectiveTo: effectiveTo,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            Value<String?> responsibility = const Value.absent(),
            Value<String?> insuranceNumber = const Value.absent(),
            Value<String?> insuranceType = const Value.absent(),
            Value<String?> insuranceStatus = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> effectiveFrom = const Value.absent(),
            Value<int?> effectiveTo = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeInsurancesCompanion.insert(
            id: id,
            employeeId: employeeId,
            responsibility: responsibility,
            insuranceNumber: insuranceNumber,
            insuranceType: insuranceType,
            insuranceStatus: insuranceStatus,
            notes: notes,
            effectiveFrom: effectiveFrom,
            effectiveTo: effectiveTo,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeInsurancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeeInsurancesTable,
    EmployeeInsurance,
    $$EmployeeInsurancesTableFilterComposer,
    $$EmployeeInsurancesTableOrderingComposer,
    $$EmployeeInsurancesTableAnnotationComposer,
    $$EmployeeInsurancesTableCreateCompanionBuilder,
    $$EmployeeInsurancesTableUpdateCompanionBuilder,
    (
      EmployeeInsurance,
      BaseReferences<_$AppDatabase, $EmployeeInsurancesTable, EmployeeInsurance>
    ),
    EmployeeInsurance,
    PrefetchHooks Function()>;
typedef $$EmployeeEvaluationsTableCreateCompanionBuilder
    = EmployeeEvaluationsCompanion Function({
  required String id,
  required String employeeId,
  required int year,
  Value<double?> score,
  Value<String?> evaluator,
  Value<String?> evaluationDate,
  Value<String?> strengths,
  Value<String?> weaknesses,
  Value<String?> improvementPlan,
  Value<String?> attachmentPath,
  required int createdAt,
  Value<int> rowid,
});
typedef $$EmployeeEvaluationsTableUpdateCompanionBuilder
    = EmployeeEvaluationsCompanion Function({
  Value<String> id,
  Value<String> employeeId,
  Value<int> year,
  Value<double?> score,
  Value<String?> evaluator,
  Value<String?> evaluationDate,
  Value<String?> strengths,
  Value<String?> weaknesses,
  Value<String?> improvementPlan,
  Value<String?> attachmentPath,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$EmployeeEvaluationsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeEvaluationsTable> {
  $$EmployeeEvaluationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evaluator => $composableBuilder(
      column: $table.evaluator, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evaluationDate => $composableBuilder(
      column: $table.evaluationDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get strengths => $composableBuilder(
      column: $table.strengths, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weaknesses => $composableBuilder(
      column: $table.weaknesses, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get improvementPlan => $composableBuilder(
      column: $table.improvementPlan,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attachmentPath => $composableBuilder(
      column: $table.attachmentPath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$EmployeeEvaluationsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeEvaluationsTable> {
  $$EmployeeEvaluationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evaluator => $composableBuilder(
      column: $table.evaluator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evaluationDate => $composableBuilder(
      column: $table.evaluationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get strengths => $composableBuilder(
      column: $table.strengths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weaknesses => $composableBuilder(
      column: $table.weaknesses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get improvementPlan => $composableBuilder(
      column: $table.improvementPlan,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachmentPath => $composableBuilder(
      column: $table.attachmentPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeEvaluationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeEvaluationsTable> {
  $$EmployeeEvaluationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get evaluator =>
      $composableBuilder(column: $table.evaluator, builder: (column) => column);

  GeneratedColumn<String> get evaluationDate => $composableBuilder(
      column: $table.evaluationDate, builder: (column) => column);

  GeneratedColumn<String> get strengths =>
      $composableBuilder(column: $table.strengths, builder: (column) => column);

  GeneratedColumn<String> get weaknesses => $composableBuilder(
      column: $table.weaknesses, builder: (column) => column);

  GeneratedColumn<String> get improvementPlan => $composableBuilder(
      column: $table.improvementPlan, builder: (column) => column);

  GeneratedColumn<String> get attachmentPath => $composableBuilder(
      column: $table.attachmentPath, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EmployeeEvaluationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeEvaluationsTable,
    EmployeeEvaluation,
    $$EmployeeEvaluationsTableFilterComposer,
    $$EmployeeEvaluationsTableOrderingComposer,
    $$EmployeeEvaluationsTableAnnotationComposer,
    $$EmployeeEvaluationsTableCreateCompanionBuilder,
    $$EmployeeEvaluationsTableUpdateCompanionBuilder,
    (
      EmployeeEvaluation,
      BaseReferences<_$AppDatabase, $EmployeeEvaluationsTable,
          EmployeeEvaluation>
    ),
    EmployeeEvaluation,
    PrefetchHooks Function()> {
  $$EmployeeEvaluationsTableTableManager(
      _$AppDatabase db, $EmployeeEvaluationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeEvaluationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeEvaluationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeEvaluationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<double?> score = const Value.absent(),
            Value<String?> evaluator = const Value.absent(),
            Value<String?> evaluationDate = const Value.absent(),
            Value<String?> strengths = const Value.absent(),
            Value<String?> weaknesses = const Value.absent(),
            Value<String?> improvementPlan = const Value.absent(),
            Value<String?> attachmentPath = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeEvaluationsCompanion(
            id: id,
            employeeId: employeeId,
            year: year,
            score: score,
            evaluator: evaluator,
            evaluationDate: evaluationDate,
            strengths: strengths,
            weaknesses: weaknesses,
            improvementPlan: improvementPlan,
            attachmentPath: attachmentPath,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            required int year,
            Value<double?> score = const Value.absent(),
            Value<String?> evaluator = const Value.absent(),
            Value<String?> evaluationDate = const Value.absent(),
            Value<String?> strengths = const Value.absent(),
            Value<String?> weaknesses = const Value.absent(),
            Value<String?> improvementPlan = const Value.absent(),
            Value<String?> attachmentPath = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeEvaluationsCompanion.insert(
            id: id,
            employeeId: employeeId,
            year: year,
            score: score,
            evaluator: evaluator,
            evaluationDate: evaluationDate,
            strengths: strengths,
            weaknesses: weaknesses,
            improvementPlan: improvementPlan,
            attachmentPath: attachmentPath,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeEvaluationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeeEvaluationsTable,
    EmployeeEvaluation,
    $$EmployeeEvaluationsTableFilterComposer,
    $$EmployeeEvaluationsTableOrderingComposer,
    $$EmployeeEvaluationsTableAnnotationComposer,
    $$EmployeeEvaluationsTableCreateCompanionBuilder,
    $$EmployeeEvaluationsTableUpdateCompanionBuilder,
    (
      EmployeeEvaluation,
      BaseReferences<_$AppDatabase, $EmployeeEvaluationsTable,
          EmployeeEvaluation>
    ),
    EmployeeEvaluation,
    PrefetchHooks Function()>;
typedef $$EmployeeDocumentsTableCreateCompanionBuilder
    = EmployeeDocumentsCompanion Function({
  required String id,
  required String employeeId,
  required String title,
  required String category,
  Value<String?> description,
  Value<String?> tagsJson,
  required String fileName,
  required String mimeType,
  required int fileSize,
  required String storagePath,
  required String contentHash,
  Value<int> version,
  Value<String?> uploadedBy,
  required int uploadedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});
typedef $$EmployeeDocumentsTableUpdateCompanionBuilder
    = EmployeeDocumentsCompanion Function({
  Value<String> id,
  Value<String> employeeId,
  Value<String> title,
  Value<String> category,
  Value<String?> description,
  Value<String?> tagsJson,
  Value<String> fileName,
  Value<String> mimeType,
  Value<int> fileSize,
  Value<String> storagePath,
  Value<String> contentHash,
  Value<int> version,
  Value<String?> uploadedBy,
  Value<int> uploadedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});

class $$EmployeeDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeDocumentsTable> {
  $$EmployeeDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$EmployeeDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeDocumentsTable> {
  $$EmployeeDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeDocumentsTable> {
  $$EmployeeDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => column);

  GeneratedColumn<int> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$EmployeeDocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeDocumentsTable,
    EmployeeDocument,
    $$EmployeeDocumentsTableFilterComposer,
    $$EmployeeDocumentsTableOrderingComposer,
    $$EmployeeDocumentsTableAnnotationComposer,
    $$EmployeeDocumentsTableCreateCompanionBuilder,
    $$EmployeeDocumentsTableUpdateCompanionBuilder,
    (
      EmployeeDocument,
      BaseReferences<_$AppDatabase, $EmployeeDocumentsTable, EmployeeDocument>
    ),
    EmployeeDocument,
    PrefetchHooks Function()> {
  $$EmployeeDocumentsTableTableManager(
      _$AppDatabase db, $EmployeeDocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeDocumentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> tagsJson = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> mimeType = const Value.absent(),
            Value<int> fileSize = const Value.absent(),
            Value<String> storagePath = const Value.absent(),
            Value<String> contentHash = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<String?> uploadedBy = const Value.absent(),
            Value<int> uploadedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeDocumentsCompanion(
            id: id,
            employeeId: employeeId,
            title: title,
            category: category,
            description: description,
            tagsJson: tagsJson,
            fileName: fileName,
            mimeType: mimeType,
            fileSize: fileSize,
            storagePath: storagePath,
            contentHash: contentHash,
            version: version,
            uploadedBy: uploadedBy,
            uploadedAt: uploadedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            required String title,
            required String category,
            Value<String?> description = const Value.absent(),
            Value<String?> tagsJson = const Value.absent(),
            required String fileName,
            required String mimeType,
            required int fileSize,
            required String storagePath,
            required String contentHash,
            Value<int> version = const Value.absent(),
            Value<String?> uploadedBy = const Value.absent(),
            required int uploadedAt,
            Value<int?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeDocumentsCompanion.insert(
            id: id,
            employeeId: employeeId,
            title: title,
            category: category,
            description: description,
            tagsJson: tagsJson,
            fileName: fileName,
            mimeType: mimeType,
            fileSize: fileSize,
            storagePath: storagePath,
            contentHash: contentHash,
            version: version,
            uploadedBy: uploadedBy,
            uploadedAt: uploadedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeDocumentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeeDocumentsTable,
    EmployeeDocument,
    $$EmployeeDocumentsTableFilterComposer,
    $$EmployeeDocumentsTableOrderingComposer,
    $$EmployeeDocumentsTableAnnotationComposer,
    $$EmployeeDocumentsTableCreateCompanionBuilder,
    $$EmployeeDocumentsTableUpdateCompanionBuilder,
    (
      EmployeeDocument,
      BaseReferences<_$AppDatabase, $EmployeeDocumentsTable, EmployeeDocument>
    ),
    EmployeeDocument,
    PrefetchHooks Function()>;
typedef $$EmployeeGroupsTableCreateCompanionBuilder = EmployeeGroupsCompanion
    Function({
  required String id,
  required String name,
  Value<String?> description,
  required String purposeType,
  Value<int?> startsAt,
  Value<int?> endsAt,
  Value<String> status,
  Value<String?> photoPath,
  Value<String?> createdBy,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});
typedef $$EmployeeGroupsTableUpdateCompanionBuilder = EmployeeGroupsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String> purposeType,
  Value<int?> startsAt,
  Value<int?> endsAt,
  Value<String> status,
  Value<String?> photoPath,
  Value<String?> createdBy,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});

class $$EmployeeGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeGroupsTable> {
  $$EmployeeGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purposeType => $composableBuilder(
      column: $table.purposeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startsAt => $composableBuilder(
      column: $table.startsAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endsAt => $composableBuilder(
      column: $table.endsAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$EmployeeGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeGroupsTable> {
  $$EmployeeGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purposeType => $composableBuilder(
      column: $table.purposeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startsAt => $composableBuilder(
      column: $table.startsAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endsAt => $composableBuilder(
      column: $table.endsAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeGroupsTable> {
  $$EmployeeGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get purposeType => $composableBuilder(
      column: $table.purposeType, builder: (column) => column);

  GeneratedColumn<int> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<int> get endsAt =>
      $composableBuilder(column: $table.endsAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$EmployeeGroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeGroupsTable,
    EmployeeGroup,
    $$EmployeeGroupsTableFilterComposer,
    $$EmployeeGroupsTableOrderingComposer,
    $$EmployeeGroupsTableAnnotationComposer,
    $$EmployeeGroupsTableCreateCompanionBuilder,
    $$EmployeeGroupsTableUpdateCompanionBuilder,
    (
      EmployeeGroup,
      BaseReferences<_$AppDatabase, $EmployeeGroupsTable, EmployeeGroup>
    ),
    EmployeeGroup,
    PrefetchHooks Function()> {
  $$EmployeeGroupsTableTableManager(
      _$AppDatabase db, $EmployeeGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> purposeType = const Value.absent(),
            Value<int?> startsAt = const Value.absent(),
            Value<int?> endsAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeGroupsCompanion(
            id: id,
            name: name,
            description: description,
            purposeType: purposeType,
            startsAt: startsAt,
            endsAt: endsAt,
            status: status,
            photoPath: photoPath,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            required String purposeType,
            Value<int?> startsAt = const Value.absent(),
            Value<int?> endsAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeGroupsCompanion.insert(
            id: id,
            name: name,
            description: description,
            purposeType: purposeType,
            startsAt: startsAt,
            endsAt: endsAt,
            status: status,
            photoPath: photoPath,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeGroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeeGroupsTable,
    EmployeeGroup,
    $$EmployeeGroupsTableFilterComposer,
    $$EmployeeGroupsTableOrderingComposer,
    $$EmployeeGroupsTableAnnotationComposer,
    $$EmployeeGroupsTableCreateCompanionBuilder,
    $$EmployeeGroupsTableUpdateCompanionBuilder,
    (
      EmployeeGroup,
      BaseReferences<_$AppDatabase, $EmployeeGroupsTable, EmployeeGroup>
    ),
    EmployeeGroup,
    PrefetchHooks Function()>;
typedef $$EmployeeGroupMembersTableCreateCompanionBuilder
    = EmployeeGroupMembersCompanion Function({
  required String id,
  required String groupId,
  required String employeeId,
  required int addedAt,
  Value<String?> addedBy,
  Value<int> rowid,
});
typedef $$EmployeeGroupMembersTableUpdateCompanionBuilder
    = EmployeeGroupMembersCompanion Function({
  Value<String> id,
  Value<String> groupId,
  Value<String> employeeId,
  Value<int> addedAt,
  Value<String?> addedBy,
  Value<int> rowid,
});

class $$EmployeeGroupMembersTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeGroupMembersTable> {
  $$EmployeeGroupMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get addedBy => $composableBuilder(
      column: $table.addedBy, builder: (column) => ColumnFilters(column));
}

class $$EmployeeGroupMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeGroupMembersTable> {
  $$EmployeeGroupMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get addedBy => $composableBuilder(
      column: $table.addedBy, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeGroupMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeGroupMembersTable> {
  $$EmployeeGroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<int> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<String> get addedBy =>
      $composableBuilder(column: $table.addedBy, builder: (column) => column);
}

class $$EmployeeGroupMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeGroupMembersTable,
    EmployeeGroupMember,
    $$EmployeeGroupMembersTableFilterComposer,
    $$EmployeeGroupMembersTableOrderingComposer,
    $$EmployeeGroupMembersTableAnnotationComposer,
    $$EmployeeGroupMembersTableCreateCompanionBuilder,
    $$EmployeeGroupMembersTableUpdateCompanionBuilder,
    (
      EmployeeGroupMember,
      BaseReferences<_$AppDatabase, $EmployeeGroupMembersTable,
          EmployeeGroupMember>
    ),
    EmployeeGroupMember,
    PrefetchHooks Function()> {
  $$EmployeeGroupMembersTableTableManager(
      _$AppDatabase db, $EmployeeGroupMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeGroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeGroupMembersTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeGroupMembersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> groupId = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<int> addedAt = const Value.absent(),
            Value<String?> addedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeGroupMembersCompanion(
            id: id,
            groupId: groupId,
            employeeId: employeeId,
            addedAt: addedAt,
            addedBy: addedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String groupId,
            required String employeeId,
            required int addedAt,
            Value<String?> addedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeGroupMembersCompanion.insert(
            id: id,
            groupId: groupId,
            employeeId: employeeId,
            addedAt: addedAt,
            addedBy: addedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeGroupMembersTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $EmployeeGroupMembersTable,
        EmployeeGroupMember,
        $$EmployeeGroupMembersTableFilterComposer,
        $$EmployeeGroupMembersTableOrderingComposer,
        $$EmployeeGroupMembersTableAnnotationComposer,
        $$EmployeeGroupMembersTableCreateCompanionBuilder,
        $$EmployeeGroupMembersTableUpdateCompanionBuilder,
        (
          EmployeeGroupMember,
          BaseReferences<_$AppDatabase, $EmployeeGroupMembersTable,
              EmployeeGroupMember>
        ),
        EmployeeGroupMember,
        PrefetchHooks Function()>;
typedef $$EmployeePerformanceReviewsTableCreateCompanionBuilder
    = EmployeePerformanceReviewsCompanion Function({
  required String id,
  required String employeeId,
  required int year,
  required int season,
  required String track,
  Value<String> status,
  Value<String?> evaluatorName,
  Value<String?> evaluatorUserId,
  Value<String?> notes,
  Value<String?> checkIn,
  Value<String?> checkOut,
  Value<double?> presenceHours,
  Value<double?> dutyHours,
  Value<int> worksheetCount,
  Value<int> worksheetQuota,
  Value<int> complaintsFiled,
  Value<int> complaintsValid,
  Value<int> complaintsAnswered,
  Value<int> responseQuality,
  Value<int> socialParticipation,
  Value<int> extraEffort,
  Value<int> extraHumanCapital,
  Value<int> extraOrgRelations,
  Value<int> extraClub,
  Value<String?> extraEvidence,
  Value<int> expectedProjects,
  Value<double> expectedVolume,
  Value<int> expectedChecklists,
  Value<double?> mainScore,
  Value<double?> extraScore,
  Value<String?> lightCode,
  Value<bool> safetyRedFlag,
  Value<bool> exemplary,
  Value<bool> extraOrgBadge,
  Value<int?> approvedAt,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$EmployeePerformanceReviewsTableUpdateCompanionBuilder
    = EmployeePerformanceReviewsCompanion Function({
  Value<String> id,
  Value<String> employeeId,
  Value<int> year,
  Value<int> season,
  Value<String> track,
  Value<String> status,
  Value<String?> evaluatorName,
  Value<String?> evaluatorUserId,
  Value<String?> notes,
  Value<String?> checkIn,
  Value<String?> checkOut,
  Value<double?> presenceHours,
  Value<double?> dutyHours,
  Value<int> worksheetCount,
  Value<int> worksheetQuota,
  Value<int> complaintsFiled,
  Value<int> complaintsValid,
  Value<int> complaintsAnswered,
  Value<int> responseQuality,
  Value<int> socialParticipation,
  Value<int> extraEffort,
  Value<int> extraHumanCapital,
  Value<int> extraOrgRelations,
  Value<int> extraClub,
  Value<String?> extraEvidence,
  Value<int> expectedProjects,
  Value<double> expectedVolume,
  Value<int> expectedChecklists,
  Value<double?> mainScore,
  Value<double?> extraScore,
  Value<String?> lightCode,
  Value<bool> safetyRedFlag,
  Value<bool> exemplary,
  Value<bool> extraOrgBadge,
  Value<int?> approvedAt,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$EmployeePerformanceReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeePerformanceReviewsTable> {
  $$EmployeePerformanceReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get season => $composableBuilder(
      column: $table.season, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get track => $composableBuilder(
      column: $table.track, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evaluatorName => $composableBuilder(
      column: $table.evaluatorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evaluatorUserId => $composableBuilder(
      column: $table.evaluatorUserId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkIn => $composableBuilder(
      column: $table.checkIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkOut => $composableBuilder(
      column: $table.checkOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get presenceHours => $composableBuilder(
      column: $table.presenceHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get dutyHours => $composableBuilder(
      column: $table.dutyHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get worksheetCount => $composableBuilder(
      column: $table.worksheetCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get worksheetQuota => $composableBuilder(
      column: $table.worksheetQuota,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get complaintsFiled => $composableBuilder(
      column: $table.complaintsFiled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get complaintsValid => $composableBuilder(
      column: $table.complaintsValid,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get complaintsAnswered => $composableBuilder(
      column: $table.complaintsAnswered,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get responseQuality => $composableBuilder(
      column: $table.responseQuality,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get socialParticipation => $composableBuilder(
      column: $table.socialParticipation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get extraEffort => $composableBuilder(
      column: $table.extraEffort, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get extraHumanCapital => $composableBuilder(
      column: $table.extraHumanCapital,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get extraOrgRelations => $composableBuilder(
      column: $table.extraOrgRelations,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get extraClub => $composableBuilder(
      column: $table.extraClub, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extraEvidence => $composableBuilder(
      column: $table.extraEvidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedProjects => $composableBuilder(
      column: $table.expectedProjects,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get expectedVolume => $composableBuilder(
      column: $table.expectedVolume,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedChecklists => $composableBuilder(
      column: $table.expectedChecklists,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get mainScore => $composableBuilder(
      column: $table.mainScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get extraScore => $composableBuilder(
      column: $table.extraScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lightCode => $composableBuilder(
      column: $table.lightCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get safetyRedFlag => $composableBuilder(
      column: $table.safetyRedFlag, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get exemplary => $composableBuilder(
      column: $table.exemplary, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get extraOrgBadge => $composableBuilder(
      column: $table.extraOrgBadge, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$EmployeePerformanceReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeePerformanceReviewsTable> {
  $$EmployeePerformanceReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get season => $composableBuilder(
      column: $table.season, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get track => $composableBuilder(
      column: $table.track, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evaluatorName => $composableBuilder(
      column: $table.evaluatorName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evaluatorUserId => $composableBuilder(
      column: $table.evaluatorUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkIn => $composableBuilder(
      column: $table.checkIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkOut => $composableBuilder(
      column: $table.checkOut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get presenceHours => $composableBuilder(
      column: $table.presenceHours,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get dutyHours => $composableBuilder(
      column: $table.dutyHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get worksheetCount => $composableBuilder(
      column: $table.worksheetCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get worksheetQuota => $composableBuilder(
      column: $table.worksheetQuota,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get complaintsFiled => $composableBuilder(
      column: $table.complaintsFiled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get complaintsValid => $composableBuilder(
      column: $table.complaintsValid,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get complaintsAnswered => $composableBuilder(
      column: $table.complaintsAnswered,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get responseQuality => $composableBuilder(
      column: $table.responseQuality,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get socialParticipation => $composableBuilder(
      column: $table.socialParticipation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get extraEffort => $composableBuilder(
      column: $table.extraEffort, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get extraHumanCapital => $composableBuilder(
      column: $table.extraHumanCapital,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get extraOrgRelations => $composableBuilder(
      column: $table.extraOrgRelations,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get extraClub => $composableBuilder(
      column: $table.extraClub, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraEvidence => $composableBuilder(
      column: $table.extraEvidence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedProjects => $composableBuilder(
      column: $table.expectedProjects,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get expectedVolume => $composableBuilder(
      column: $table.expectedVolume,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedChecklists => $composableBuilder(
      column: $table.expectedChecklists,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get mainScore => $composableBuilder(
      column: $table.mainScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get extraScore => $composableBuilder(
      column: $table.extraScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lightCode => $composableBuilder(
      column: $table.lightCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get safetyRedFlag => $composableBuilder(
      column: $table.safetyRedFlag,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get exemplary => $composableBuilder(
      column: $table.exemplary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get extraOrgBadge => $composableBuilder(
      column: $table.extraOrgBadge,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$EmployeePerformanceReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeePerformanceReviewsTable> {
  $$EmployeePerformanceReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get season =>
      $composableBuilder(column: $table.season, builder: (column) => column);

  GeneratedColumn<String> get track =>
      $composableBuilder(column: $table.track, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get evaluatorName => $composableBuilder(
      column: $table.evaluatorName, builder: (column) => column);

  GeneratedColumn<String> get evaluatorUserId => $composableBuilder(
      column: $table.evaluatorUserId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get checkIn =>
      $composableBuilder(column: $table.checkIn, builder: (column) => column);

  GeneratedColumn<String> get checkOut =>
      $composableBuilder(column: $table.checkOut, builder: (column) => column);

  GeneratedColumn<double> get presenceHours => $composableBuilder(
      column: $table.presenceHours, builder: (column) => column);

  GeneratedColumn<double> get dutyHours =>
      $composableBuilder(column: $table.dutyHours, builder: (column) => column);

  GeneratedColumn<int> get worksheetCount => $composableBuilder(
      column: $table.worksheetCount, builder: (column) => column);

  GeneratedColumn<int> get worksheetQuota => $composableBuilder(
      column: $table.worksheetQuota, builder: (column) => column);

  GeneratedColumn<int> get complaintsFiled => $composableBuilder(
      column: $table.complaintsFiled, builder: (column) => column);

  GeneratedColumn<int> get complaintsValid => $composableBuilder(
      column: $table.complaintsValid, builder: (column) => column);

  GeneratedColumn<int> get complaintsAnswered => $composableBuilder(
      column: $table.complaintsAnswered, builder: (column) => column);

  GeneratedColumn<int> get responseQuality => $composableBuilder(
      column: $table.responseQuality, builder: (column) => column);

  GeneratedColumn<int> get socialParticipation => $composableBuilder(
      column: $table.socialParticipation, builder: (column) => column);

  GeneratedColumn<int> get extraEffort => $composableBuilder(
      column: $table.extraEffort, builder: (column) => column);

  GeneratedColumn<int> get extraHumanCapital => $composableBuilder(
      column: $table.extraHumanCapital, builder: (column) => column);

  GeneratedColumn<int> get extraOrgRelations => $composableBuilder(
      column: $table.extraOrgRelations, builder: (column) => column);

  GeneratedColumn<int> get extraClub =>
      $composableBuilder(column: $table.extraClub, builder: (column) => column);

  GeneratedColumn<String> get extraEvidence => $composableBuilder(
      column: $table.extraEvidence, builder: (column) => column);

  GeneratedColumn<int> get expectedProjects => $composableBuilder(
      column: $table.expectedProjects, builder: (column) => column);

  GeneratedColumn<double> get expectedVolume => $composableBuilder(
      column: $table.expectedVolume, builder: (column) => column);

  GeneratedColumn<int> get expectedChecklists => $composableBuilder(
      column: $table.expectedChecklists, builder: (column) => column);

  GeneratedColumn<double> get mainScore =>
      $composableBuilder(column: $table.mainScore, builder: (column) => column);

  GeneratedColumn<double> get extraScore => $composableBuilder(
      column: $table.extraScore, builder: (column) => column);

  GeneratedColumn<String> get lightCode =>
      $composableBuilder(column: $table.lightCode, builder: (column) => column);

  GeneratedColumn<bool> get safetyRedFlag => $composableBuilder(
      column: $table.safetyRedFlag, builder: (column) => column);

  GeneratedColumn<bool> get exemplary =>
      $composableBuilder(column: $table.exemplary, builder: (column) => column);

  GeneratedColumn<bool> get extraOrgBadge => $composableBuilder(
      column: $table.extraOrgBadge, builder: (column) => column);

  GeneratedColumn<int> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EmployeePerformanceReviewsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeePerformanceReviewsTable,
    EmployeePerformanceReview,
    $$EmployeePerformanceReviewsTableFilterComposer,
    $$EmployeePerformanceReviewsTableOrderingComposer,
    $$EmployeePerformanceReviewsTableAnnotationComposer,
    $$EmployeePerformanceReviewsTableCreateCompanionBuilder,
    $$EmployeePerformanceReviewsTableUpdateCompanionBuilder,
    (
      EmployeePerformanceReview,
      BaseReferences<_$AppDatabase, $EmployeePerformanceReviewsTable,
          EmployeePerformanceReview>
    ),
    EmployeePerformanceReview,
    PrefetchHooks Function()> {
  $$EmployeePerformanceReviewsTableTableManager(
      _$AppDatabase db, $EmployeePerformanceReviewsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeePerformanceReviewsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeePerformanceReviewsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeePerformanceReviewsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> season = const Value.absent(),
            Value<String> track = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> evaluatorName = const Value.absent(),
            Value<String?> evaluatorUserId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> checkIn = const Value.absent(),
            Value<String?> checkOut = const Value.absent(),
            Value<double?> presenceHours = const Value.absent(),
            Value<double?> dutyHours = const Value.absent(),
            Value<int> worksheetCount = const Value.absent(),
            Value<int> worksheetQuota = const Value.absent(),
            Value<int> complaintsFiled = const Value.absent(),
            Value<int> complaintsValid = const Value.absent(),
            Value<int> complaintsAnswered = const Value.absent(),
            Value<int> responseQuality = const Value.absent(),
            Value<int> socialParticipation = const Value.absent(),
            Value<int> extraEffort = const Value.absent(),
            Value<int> extraHumanCapital = const Value.absent(),
            Value<int> extraOrgRelations = const Value.absent(),
            Value<int> extraClub = const Value.absent(),
            Value<String?> extraEvidence = const Value.absent(),
            Value<int> expectedProjects = const Value.absent(),
            Value<double> expectedVolume = const Value.absent(),
            Value<int> expectedChecklists = const Value.absent(),
            Value<double?> mainScore = const Value.absent(),
            Value<double?> extraScore = const Value.absent(),
            Value<String?> lightCode = const Value.absent(),
            Value<bool> safetyRedFlag = const Value.absent(),
            Value<bool> exemplary = const Value.absent(),
            Value<bool> extraOrgBadge = const Value.absent(),
            Value<int?> approvedAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeePerformanceReviewsCompanion(
            id: id,
            employeeId: employeeId,
            year: year,
            season: season,
            track: track,
            status: status,
            evaluatorName: evaluatorName,
            evaluatorUserId: evaluatorUserId,
            notes: notes,
            checkIn: checkIn,
            checkOut: checkOut,
            presenceHours: presenceHours,
            dutyHours: dutyHours,
            worksheetCount: worksheetCount,
            worksheetQuota: worksheetQuota,
            complaintsFiled: complaintsFiled,
            complaintsValid: complaintsValid,
            complaintsAnswered: complaintsAnswered,
            responseQuality: responseQuality,
            socialParticipation: socialParticipation,
            extraEffort: extraEffort,
            extraHumanCapital: extraHumanCapital,
            extraOrgRelations: extraOrgRelations,
            extraClub: extraClub,
            extraEvidence: extraEvidence,
            expectedProjects: expectedProjects,
            expectedVolume: expectedVolume,
            expectedChecklists: expectedChecklists,
            mainScore: mainScore,
            extraScore: extraScore,
            lightCode: lightCode,
            safetyRedFlag: safetyRedFlag,
            exemplary: exemplary,
            extraOrgBadge: extraOrgBadge,
            approvedAt: approvedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            required int year,
            required int season,
            required String track,
            Value<String> status = const Value.absent(),
            Value<String?> evaluatorName = const Value.absent(),
            Value<String?> evaluatorUserId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> checkIn = const Value.absent(),
            Value<String?> checkOut = const Value.absent(),
            Value<double?> presenceHours = const Value.absent(),
            Value<double?> dutyHours = const Value.absent(),
            Value<int> worksheetCount = const Value.absent(),
            Value<int> worksheetQuota = const Value.absent(),
            Value<int> complaintsFiled = const Value.absent(),
            Value<int> complaintsValid = const Value.absent(),
            Value<int> complaintsAnswered = const Value.absent(),
            Value<int> responseQuality = const Value.absent(),
            Value<int> socialParticipation = const Value.absent(),
            Value<int> extraEffort = const Value.absent(),
            Value<int> extraHumanCapital = const Value.absent(),
            Value<int> extraOrgRelations = const Value.absent(),
            Value<int> extraClub = const Value.absent(),
            Value<String?> extraEvidence = const Value.absent(),
            Value<int> expectedProjects = const Value.absent(),
            Value<double> expectedVolume = const Value.absent(),
            Value<int> expectedChecklists = const Value.absent(),
            Value<double?> mainScore = const Value.absent(),
            Value<double?> extraScore = const Value.absent(),
            Value<String?> lightCode = const Value.absent(),
            Value<bool> safetyRedFlag = const Value.absent(),
            Value<bool> exemplary = const Value.absent(),
            Value<bool> extraOrgBadge = const Value.absent(),
            Value<int?> approvedAt = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeePerformanceReviewsCompanion.insert(
            id: id,
            employeeId: employeeId,
            year: year,
            season: season,
            track: track,
            status: status,
            evaluatorName: evaluatorName,
            evaluatorUserId: evaluatorUserId,
            notes: notes,
            checkIn: checkIn,
            checkOut: checkOut,
            presenceHours: presenceHours,
            dutyHours: dutyHours,
            worksheetCount: worksheetCount,
            worksheetQuota: worksheetQuota,
            complaintsFiled: complaintsFiled,
            complaintsValid: complaintsValid,
            complaintsAnswered: complaintsAnswered,
            responseQuality: responseQuality,
            socialParticipation: socialParticipation,
            extraEffort: extraEffort,
            extraHumanCapital: extraHumanCapital,
            extraOrgRelations: extraOrgRelations,
            extraClub: extraClub,
            extraEvidence: extraEvidence,
            expectedProjects: expectedProjects,
            expectedVolume: expectedVolume,
            expectedChecklists: expectedChecklists,
            mainScore: mainScore,
            extraScore: extraScore,
            lightCode: lightCode,
            safetyRedFlag: safetyRedFlag,
            exemplary: exemplary,
            extraOrgBadge: extraOrgBadge,
            approvedAt: approvedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeePerformanceReviewsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $EmployeePerformanceReviewsTable,
        EmployeePerformanceReview,
        $$EmployeePerformanceReviewsTableFilterComposer,
        $$EmployeePerformanceReviewsTableOrderingComposer,
        $$EmployeePerformanceReviewsTableAnnotationComposer,
        $$EmployeePerformanceReviewsTableCreateCompanionBuilder,
        $$EmployeePerformanceReviewsTableUpdateCompanionBuilder,
        (
          EmployeePerformanceReview,
          BaseReferences<_$AppDatabase, $EmployeePerformanceReviewsTable,
              EmployeePerformanceReview>
        ),
        EmployeePerformanceReview,
        PrefetchHooks Function()>;
typedef $$EmployeeWorkerProjectsTableCreateCompanionBuilder
    = EmployeeWorkerProjectsCompanion Function({
  required String id,
  required String reviewId,
  required String title,
  required int level,
  required double hours,
  required double progressPercent,
  Value<int> checklistCount,
  Value<int> incidentsDirect,
  Value<int> incidentsIndirect,
  Value<bool> severe,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$EmployeeWorkerProjectsTableUpdateCompanionBuilder
    = EmployeeWorkerProjectsCompanion Function({
  Value<String> id,
  Value<String> reviewId,
  Value<String> title,
  Value<int> level,
  Value<double> hours,
  Value<double> progressPercent,
  Value<int> checklistCount,
  Value<int> incidentsDirect,
  Value<int> incidentsIndirect,
  Value<bool> severe,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$EmployeeWorkerProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeWorkerProjectsTable> {
  $$EmployeeWorkerProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reviewId => $composableBuilder(
      column: $table.reviewId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hours => $composableBuilder(
      column: $table.hours, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get progressPercent => $composableBuilder(
      column: $table.progressPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checklistCount => $composableBuilder(
      column: $table.checklistCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get incidentsDirect => $composableBuilder(
      column: $table.incidentsDirect,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get incidentsIndirect => $composableBuilder(
      column: $table.incidentsIndirect,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get severe => $composableBuilder(
      column: $table.severe, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$EmployeeWorkerProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeWorkerProjectsTable> {
  $$EmployeeWorkerProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reviewId => $composableBuilder(
      column: $table.reviewId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hours => $composableBuilder(
      column: $table.hours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get progressPercent => $composableBuilder(
      column: $table.progressPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checklistCount => $composableBuilder(
      column: $table.checklistCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get incidentsDirect => $composableBuilder(
      column: $table.incidentsDirect,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get incidentsIndirect => $composableBuilder(
      column: $table.incidentsIndirect,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get severe => $composableBuilder(
      column: $table.severe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeWorkerProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeWorkerProjectsTable> {
  $$EmployeeWorkerProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reviewId =>
      $composableBuilder(column: $table.reviewId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<double> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => column);

  GeneratedColumn<double> get progressPercent => $composableBuilder(
      column: $table.progressPercent, builder: (column) => column);

  GeneratedColumn<int> get checklistCount => $composableBuilder(
      column: $table.checklistCount, builder: (column) => column);

  GeneratedColumn<int> get incidentsDirect => $composableBuilder(
      column: $table.incidentsDirect, builder: (column) => column);

  GeneratedColumn<int> get incidentsIndirect => $composableBuilder(
      column: $table.incidentsIndirect, builder: (column) => column);

  GeneratedColumn<bool> get severe =>
      $composableBuilder(column: $table.severe, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$EmployeeWorkerProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeWorkerProjectsTable,
    EmployeeWorkerProject,
    $$EmployeeWorkerProjectsTableFilterComposer,
    $$EmployeeWorkerProjectsTableOrderingComposer,
    $$EmployeeWorkerProjectsTableAnnotationComposer,
    $$EmployeeWorkerProjectsTableCreateCompanionBuilder,
    $$EmployeeWorkerProjectsTableUpdateCompanionBuilder,
    (
      EmployeeWorkerProject,
      BaseReferences<_$AppDatabase, $EmployeeWorkerProjectsTable,
          EmployeeWorkerProject>
    ),
    EmployeeWorkerProject,
    PrefetchHooks Function()> {
  $$EmployeeWorkerProjectsTableTableManager(
      _$AppDatabase db, $EmployeeWorkerProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeWorkerProjectsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeWorkerProjectsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeWorkerProjectsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> reviewId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<double> hours = const Value.absent(),
            Value<double> progressPercent = const Value.absent(),
            Value<int> checklistCount = const Value.absent(),
            Value<int> incidentsDirect = const Value.absent(),
            Value<int> incidentsIndirect = const Value.absent(),
            Value<bool> severe = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeWorkerProjectsCompanion(
            id: id,
            reviewId: reviewId,
            title: title,
            level: level,
            hours: hours,
            progressPercent: progressPercent,
            checklistCount: checklistCount,
            incidentsDirect: incidentsDirect,
            incidentsIndirect: incidentsIndirect,
            severe: severe,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String reviewId,
            required String title,
            required int level,
            required double hours,
            required double progressPercent,
            Value<int> checklistCount = const Value.absent(),
            Value<int> incidentsDirect = const Value.absent(),
            Value<int> incidentsIndirect = const Value.absent(),
            Value<bool> severe = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeWorkerProjectsCompanion.insert(
            id: id,
            reviewId: reviewId,
            title: title,
            level: level,
            hours: hours,
            progressPercent: progressPercent,
            checklistCount: checklistCount,
            incidentsDirect: incidentsDirect,
            incidentsIndirect: incidentsIndirect,
            severe: severe,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeWorkerProjectsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $EmployeeWorkerProjectsTable,
        EmployeeWorkerProject,
        $$EmployeeWorkerProjectsTableFilterComposer,
        $$EmployeeWorkerProjectsTableOrderingComposer,
        $$EmployeeWorkerProjectsTableAnnotationComposer,
        $$EmployeeWorkerProjectsTableCreateCompanionBuilder,
        $$EmployeeWorkerProjectsTableUpdateCompanionBuilder,
        (
          EmployeeWorkerProject,
          BaseReferences<_$AppDatabase, $EmployeeWorkerProjectsTable,
              EmployeeWorkerProject>
        ),
        EmployeeWorkerProject,
        PrefetchHooks Function()>;
typedef $$AttendanceRecordsTableCreateCompanionBuilder
    = AttendanceRecordsCompanion Function({
  required String id,
  required String employeeId,
  required String workDate,
  required String status,
  Value<String?> checkIn,
  Value<String?> checkOut,
  Value<double?> hours,
  Value<String?> note,
  Value<String?> createdBy,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$AttendanceRecordsTableUpdateCompanionBuilder
    = AttendanceRecordsCompanion Function({
  Value<String> id,
  Value<String> employeeId,
  Value<String> workDate,
  Value<String> status,
  Value<String?> checkIn,
  Value<String?> checkOut,
  Value<double?> hours,
  Value<String?> note,
  Value<String?> createdBy,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$AttendanceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workDate => $composableBuilder(
      column: $table.workDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkIn => $composableBuilder(
      column: $table.checkIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkOut => $composableBuilder(
      column: $table.checkOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hours => $composableBuilder(
      column: $table.hours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AttendanceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workDate => $composableBuilder(
      column: $table.workDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkIn => $composableBuilder(
      column: $table.checkIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkOut => $composableBuilder(
      column: $table.checkOut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hours => $composableBuilder(
      column: $table.hours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AttendanceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get workDate =>
      $composableBuilder(column: $table.workDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get checkIn =>
      $composableBuilder(column: $table.checkIn, builder: (column) => column);

  GeneratedColumn<String> get checkOut =>
      $composableBuilder(column: $table.checkOut, builder: (column) => column);

  GeneratedColumn<double> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AttendanceRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttendanceRecordsTable,
    AttendanceRecord,
    $$AttendanceRecordsTableFilterComposer,
    $$AttendanceRecordsTableOrderingComposer,
    $$AttendanceRecordsTableAnnotationComposer,
    $$AttendanceRecordsTableCreateCompanionBuilder,
    $$AttendanceRecordsTableUpdateCompanionBuilder,
    (
      AttendanceRecord,
      BaseReferences<_$AppDatabase, $AttendanceRecordsTable, AttendanceRecord>
    ),
    AttendanceRecord,
    PrefetchHooks Function()> {
  $$AttendanceRecordsTableTableManager(
      _$AppDatabase db, $AttendanceRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<String> workDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> checkIn = const Value.absent(),
            Value<String?> checkOut = const Value.absent(),
            Value<double?> hours = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttendanceRecordsCompanion(
            id: id,
            employeeId: employeeId,
            workDate: workDate,
            status: status,
            checkIn: checkIn,
            checkOut: checkOut,
            hours: hours,
            note: note,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            required String workDate,
            required String status,
            Value<String?> checkIn = const Value.absent(),
            Value<String?> checkOut = const Value.absent(),
            Value<double?> hours = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AttendanceRecordsCompanion.insert(
            id: id,
            employeeId: employeeId,
            workDate: workDate,
            status: status,
            checkIn: checkIn,
            checkOut: checkOut,
            hours: hours,
            note: note,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttendanceRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttendanceRecordsTable,
    AttendanceRecord,
    $$AttendanceRecordsTableFilterComposer,
    $$AttendanceRecordsTableOrderingComposer,
    $$AttendanceRecordsTableAnnotationComposer,
    $$AttendanceRecordsTableCreateCompanionBuilder,
    $$AttendanceRecordsTableUpdateCompanionBuilder,
    (
      AttendanceRecord,
      BaseReferences<_$AppDatabase, $AttendanceRecordsTable, AttendanceRecord>
    ),
    AttendanceRecord,
    PrefetchHooks Function()>;
typedef $$FieldSuggestionsTableCreateCompanionBuilder
    = FieldSuggestionsCompanion Function({
  required String category,
  required String value,
  required int createdAt,
  Value<int> rowid,
});
typedef $$FieldSuggestionsTableUpdateCompanionBuilder
    = FieldSuggestionsCompanion Function({
  Value<String> category,
  Value<String> value,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$FieldSuggestionsTableFilterComposer
    extends Composer<_$AppDatabase, $FieldSuggestionsTable> {
  $$FieldSuggestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$FieldSuggestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FieldSuggestionsTable> {
  $$FieldSuggestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$FieldSuggestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FieldSuggestionsTable> {
  $$FieldSuggestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FieldSuggestionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FieldSuggestionsTable,
    FieldSuggestion,
    $$FieldSuggestionsTableFilterComposer,
    $$FieldSuggestionsTableOrderingComposer,
    $$FieldSuggestionsTableAnnotationComposer,
    $$FieldSuggestionsTableCreateCompanionBuilder,
    $$FieldSuggestionsTableUpdateCompanionBuilder,
    (
      FieldSuggestion,
      BaseReferences<_$AppDatabase, $FieldSuggestionsTable, FieldSuggestion>
    ),
    FieldSuggestion,
    PrefetchHooks Function()> {
  $$FieldSuggestionsTableTableManager(
      _$AppDatabase db, $FieldSuggestionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FieldSuggestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FieldSuggestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FieldSuggestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> category = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FieldSuggestionsCompanion(
            category: category,
            value: value,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String category,
            required String value,
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FieldSuggestionsCompanion.insert(
            category: category,
            value: value,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FieldSuggestionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FieldSuggestionsTable,
    FieldSuggestion,
    $$FieldSuggestionsTableFilterComposer,
    $$FieldSuggestionsTableOrderingComposer,
    $$FieldSuggestionsTableAnnotationComposer,
    $$FieldSuggestionsTableCreateCompanionBuilder,
    $$FieldSuggestionsTableUpdateCompanionBuilder,
    (
      FieldSuggestion,
      BaseReferences<_$AppDatabase, $FieldSuggestionsTable, FieldSuggestion>
    ),
    FieldSuggestion,
    PrefetchHooks Function()>;
typedef $$EmployeeSampleTitlesTableCreateCompanionBuilder
    = EmployeeSampleTitlesCompanion Function({
  required String id,
  required String employeeId,
  required int year,
  required String kind,
  Value<String?> note,
  required int createdAt,
  required int updatedAt,
  Value<String?> createdBy,
  Value<int> rowid,
});
typedef $$EmployeeSampleTitlesTableUpdateCompanionBuilder
    = EmployeeSampleTitlesCompanion Function({
  Value<String> id,
  Value<String> employeeId,
  Value<int> year,
  Value<String> kind,
  Value<String?> note,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String?> createdBy,
  Value<int> rowid,
});

class $$EmployeeSampleTitlesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeSampleTitlesTable> {
  $$EmployeeSampleTitlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));
}

class $$EmployeeSampleTitlesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeSampleTitlesTable> {
  $$EmployeeSampleTitlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeSampleTitlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeSampleTitlesTable> {
  $$EmployeeSampleTitlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);
}

class $$EmployeeSampleTitlesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeSampleTitlesTable,
    EmployeeSampleTitle,
    $$EmployeeSampleTitlesTableFilterComposer,
    $$EmployeeSampleTitlesTableOrderingComposer,
    $$EmployeeSampleTitlesTableAnnotationComposer,
    $$EmployeeSampleTitlesTableCreateCompanionBuilder,
    $$EmployeeSampleTitlesTableUpdateCompanionBuilder,
    (
      EmployeeSampleTitle,
      BaseReferences<_$AppDatabase, $EmployeeSampleTitlesTable,
          EmployeeSampleTitle>
    ),
    EmployeeSampleTitle,
    PrefetchHooks Function()> {
  $$EmployeeSampleTitlesTableTableManager(
      _$AppDatabase db, $EmployeeSampleTitlesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeSampleTitlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeSampleTitlesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeSampleTitlesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeSampleTitlesCompanion(
            id: id,
            employeeId: employeeId,
            year: year,
            kind: kind,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            required int year,
            required String kind,
            Value<String?> note = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<String?> createdBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeSampleTitlesCompanion.insert(
            id: id,
            employeeId: employeeId,
            year: year,
            kind: kind,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeSampleTitlesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $EmployeeSampleTitlesTable,
        EmployeeSampleTitle,
        $$EmployeeSampleTitlesTableFilterComposer,
        $$EmployeeSampleTitlesTableOrderingComposer,
        $$EmployeeSampleTitlesTableAnnotationComposer,
        $$EmployeeSampleTitlesTableCreateCompanionBuilder,
        $$EmployeeSampleTitlesTableUpdateCompanionBuilder,
        (
          EmployeeSampleTitle,
          BaseReferences<_$AppDatabase, $EmployeeSampleTitlesTable,
              EmployeeSampleTitle>
        ),
        EmployeeSampleTitle,
        PrefetchHooks Function()>;
typedef $$EmployeeSampleIntroductionsTableCreateCompanionBuilder
    = EmployeeSampleIntroductionsCompanion Function({
  required String id,
  required String sampleTitleId,
  required String organization,
  Value<String?> note,
  required int createdAt,
  Value<String?> createdBy,
  Value<int> rowid,
});
typedef $$EmployeeSampleIntroductionsTableUpdateCompanionBuilder
    = EmployeeSampleIntroductionsCompanion Function({
  Value<String> id,
  Value<String> sampleTitleId,
  Value<String> organization,
  Value<String?> note,
  Value<int> createdAt,
  Value<String?> createdBy,
  Value<int> rowid,
});

class $$EmployeeSampleIntroductionsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeSampleIntroductionsTable> {
  $$EmployeeSampleIntroductionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sampleTitleId => $composableBuilder(
      column: $table.sampleTitleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get organization => $composableBuilder(
      column: $table.organization, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));
}

class $$EmployeeSampleIntroductionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeSampleIntroductionsTable> {
  $$EmployeeSampleIntroductionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sampleTitleId => $composableBuilder(
      column: $table.sampleTitleId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get organization => $composableBuilder(
      column: $table.organization,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeSampleIntroductionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeSampleIntroductionsTable> {
  $$EmployeeSampleIntroductionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sampleTitleId => $composableBuilder(
      column: $table.sampleTitleId, builder: (column) => column);

  GeneratedColumn<String> get organization => $composableBuilder(
      column: $table.organization, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);
}

class $$EmployeeSampleIntroductionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeSampleIntroductionsTable,
    EmployeeSampleIntroduction,
    $$EmployeeSampleIntroductionsTableFilterComposer,
    $$EmployeeSampleIntroductionsTableOrderingComposer,
    $$EmployeeSampleIntroductionsTableAnnotationComposer,
    $$EmployeeSampleIntroductionsTableCreateCompanionBuilder,
    $$EmployeeSampleIntroductionsTableUpdateCompanionBuilder,
    (
      EmployeeSampleIntroduction,
      BaseReferences<_$AppDatabase, $EmployeeSampleIntroductionsTable,
          EmployeeSampleIntroduction>
    ),
    EmployeeSampleIntroduction,
    PrefetchHooks Function()> {
  $$EmployeeSampleIntroductionsTableTableManager(
      _$AppDatabase db, $EmployeeSampleIntroductionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeSampleIntroductionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeSampleIntroductionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeSampleIntroductionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sampleTitleId = const Value.absent(),
            Value<String> organization = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeSampleIntroductionsCompanion(
            id: id,
            sampleTitleId: sampleTitleId,
            organization: organization,
            note: note,
            createdAt: createdAt,
            createdBy: createdBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sampleTitleId,
            required String organization,
            Value<String?> note = const Value.absent(),
            required int createdAt,
            Value<String?> createdBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeSampleIntroductionsCompanion.insert(
            id: id,
            sampleTitleId: sampleTitleId,
            organization: organization,
            note: note,
            createdAt: createdAt,
            createdBy: createdBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeSampleIntroductionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $EmployeeSampleIntroductionsTable,
        EmployeeSampleIntroduction,
        $$EmployeeSampleIntroductionsTableFilterComposer,
        $$EmployeeSampleIntroductionsTableOrderingComposer,
        $$EmployeeSampleIntroductionsTableAnnotationComposer,
        $$EmployeeSampleIntroductionsTableCreateCompanionBuilder,
        $$EmployeeSampleIntroductionsTableUpdateCompanionBuilder,
        (
          EmployeeSampleIntroduction,
          BaseReferences<_$AppDatabase, $EmployeeSampleIntroductionsTable,
              EmployeeSampleIntroduction>
        ),
        EmployeeSampleIntroduction,
        PrefetchHooks Function()>;
typedef $$EmployeeGroupActivitiesTableCreateCompanionBuilder
    = EmployeeGroupActivitiesCompanion Function({
  required String id,
  required String groupId,
  required String title,
  Value<String?> note,
  Value<String?> activityDate,
  Value<String?> createdBy,
  Value<String?> createdByName,
  required int createdAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});
typedef $$EmployeeGroupActivitiesTableUpdateCompanionBuilder
    = EmployeeGroupActivitiesCompanion Function({
  Value<String> id,
  Value<String> groupId,
  Value<String> title,
  Value<String?> note,
  Value<String?> activityDate,
  Value<String?> createdBy,
  Value<String?> createdByName,
  Value<int> createdAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});

class $$EmployeeGroupActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeGroupActivitiesTable> {
  $$EmployeeGroupActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activityDate => $composableBuilder(
      column: $table.activityDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdByName => $composableBuilder(
      column: $table.createdByName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$EmployeeGroupActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeGroupActivitiesTable> {
  $$EmployeeGroupActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activityDate => $composableBuilder(
      column: $table.activityDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdByName => $composableBuilder(
      column: $table.createdByName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$EmployeeGroupActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeGroupActivitiesTable> {
  $$EmployeeGroupActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get activityDate => $composableBuilder(
      column: $table.activityDate, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get createdByName => $composableBuilder(
      column: $table.createdByName, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$EmployeeGroupActivitiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeeGroupActivitiesTable,
    EmployeeGroupActivity,
    $$EmployeeGroupActivitiesTableFilterComposer,
    $$EmployeeGroupActivitiesTableOrderingComposer,
    $$EmployeeGroupActivitiesTableAnnotationComposer,
    $$EmployeeGroupActivitiesTableCreateCompanionBuilder,
    $$EmployeeGroupActivitiesTableUpdateCompanionBuilder,
    (
      EmployeeGroupActivity,
      BaseReferences<_$AppDatabase, $EmployeeGroupActivitiesTable,
          EmployeeGroupActivity>
    ),
    EmployeeGroupActivity,
    PrefetchHooks Function()> {
  $$EmployeeGroupActivitiesTableTableManager(
      _$AppDatabase db, $EmployeeGroupActivitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeGroupActivitiesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeGroupActivitiesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeGroupActivitiesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> groupId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> activityDate = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<String?> createdByName = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeGroupActivitiesCompanion(
            id: id,
            groupId: groupId,
            title: title,
            note: note,
            activityDate: activityDate,
            createdBy: createdBy,
            createdByName: createdByName,
            createdAt: createdAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String groupId,
            required String title,
            Value<String?> note = const Value.absent(),
            Value<String?> activityDate = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<String?> createdByName = const Value.absent(),
            required int createdAt,
            Value<int?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeeGroupActivitiesCompanion.insert(
            id: id,
            groupId: groupId,
            title: title,
            note: note,
            activityDate: activityDate,
            createdBy: createdBy,
            createdByName: createdByName,
            createdAt: createdAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmployeeGroupActivitiesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $EmployeeGroupActivitiesTable,
        EmployeeGroupActivity,
        $$EmployeeGroupActivitiesTableFilterComposer,
        $$EmployeeGroupActivitiesTableOrderingComposer,
        $$EmployeeGroupActivitiesTableAnnotationComposer,
        $$EmployeeGroupActivitiesTableCreateCompanionBuilder,
        $$EmployeeGroupActivitiesTableUpdateCompanionBuilder,
        (
          EmployeeGroupActivity,
          BaseReferences<_$AppDatabase, $EmployeeGroupActivitiesTable,
              EmployeeGroupActivity>
        ),
        EmployeeGroupActivity,
        PrefetchHooks Function()>;
typedef $$AuditLogsTableCreateCompanionBuilder = AuditLogsCompanion Function({
  required String id,
  Value<String?> actorUserId,
  Value<String?> actorUsername,
  required String action,
  Value<String?> entityType,
  Value<String?> entityId,
  Value<String?> detailsJson,
  Value<String?> deviceInfo,
  required int createdAt,
  Value<int> rowid,
});
typedef $$AuditLogsTableUpdateCompanionBuilder = AuditLogsCompanion Function({
  Value<String> id,
  Value<String?> actorUserId,
  Value<String?> actorUsername,
  Value<String> action,
  Value<String?> entityType,
  Value<String?> entityId,
  Value<String?> detailsJson,
  Value<String?> deviceInfo,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actorUserId => $composableBuilder(
      column: $table.actorUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actorUsername => $composableBuilder(
      column: $table.actorUsername, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceInfo => $composableBuilder(
      column: $table.deviceInfo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actorUserId => $composableBuilder(
      column: $table.actorUserId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actorUsername => $composableBuilder(
      column: $table.actorUsername,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceInfo => $composableBuilder(
      column: $table.deviceInfo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actorUserId => $composableBuilder(
      column: $table.actorUserId, builder: (column) => column);

  GeneratedColumn<String> get actorUsername => $composableBuilder(
      column: $table.actorUsername, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => column);

  GeneratedColumn<String> get deviceInfo => $composableBuilder(
      column: $table.deviceInfo, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuditLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
    AuditLog,
    PrefetchHooks Function()> {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> actorUserId = const Value.absent(),
            Value<String?> actorUsername = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String?> entityType = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<String?> detailsJson = const Value.absent(),
            Value<String?> deviceInfo = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogsCompanion(
            id: id,
            actorUserId: actorUserId,
            actorUsername: actorUsername,
            action: action,
            entityType: entityType,
            entityId: entityId,
            detailsJson: detailsJson,
            deviceInfo: deviceInfo,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> actorUserId = const Value.absent(),
            Value<String?> actorUsername = const Value.absent(),
            required String action,
            Value<String?> entityType = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<String?> detailsJson = const Value.absent(),
            Value<String?> deviceInfo = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogsCompanion.insert(
            id: id,
            actorUserId: actorUserId,
            actorUsername: actorUsername,
            action: action,
            entityType: entityType,
            entityId: entityId,
            detailsJson: detailsJson,
            deviceInfo: deviceInfo,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuditLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
    AuditLog,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;
typedef $$SavedFiltersTableCreateCompanionBuilder = SavedFiltersCompanion
    Function({
  required String id,
  required String userId,
  required String name,
  required String queryJson,
  required int createdAt,
  Value<int> rowid,
});
typedef $$SavedFiltersTableUpdateCompanionBuilder = SavedFiltersCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> name,
  Value<String> queryJson,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$SavedFiltersTableFilterComposer
    extends Composer<_$AppDatabase, $SavedFiltersTable> {
  $$SavedFiltersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get queryJson => $composableBuilder(
      column: $table.queryJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SavedFiltersTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedFiltersTable> {
  $$SavedFiltersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get queryJson => $composableBuilder(
      column: $table.queryJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SavedFiltersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedFiltersTable> {
  $$SavedFiltersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get queryJson =>
      $composableBuilder(column: $table.queryJson, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavedFiltersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavedFiltersTable,
    SavedFilter,
    $$SavedFiltersTableFilterComposer,
    $$SavedFiltersTableOrderingComposer,
    $$SavedFiltersTableAnnotationComposer,
    $$SavedFiltersTableCreateCompanionBuilder,
    $$SavedFiltersTableUpdateCompanionBuilder,
    (
      SavedFilter,
      BaseReferences<_$AppDatabase, $SavedFiltersTable, SavedFilter>
    ),
    SavedFilter,
    PrefetchHooks Function()> {
  $$SavedFiltersTableTableManager(_$AppDatabase db, $SavedFiltersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedFiltersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedFiltersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedFiltersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> queryJson = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavedFiltersCompanion(
            id: id,
            userId: userId,
            name: name,
            queryJson: queryJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String name,
            required String queryJson,
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SavedFiltersCompanion.insert(
            id: id,
            userId: userId,
            name: name,
            queryJson: queryJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SavedFiltersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SavedFiltersTable,
    SavedFilter,
    $$SavedFiltersTableFilterComposer,
    $$SavedFiltersTableOrderingComposer,
    $$SavedFiltersTableAnnotationComposer,
    $$SavedFiltersTableCreateCompanionBuilder,
    $$SavedFiltersTableUpdateCompanionBuilder,
    (
      SavedFilter,
      BaseReferences<_$AppDatabase, $SavedFiltersTable, SavedFilter>
    ),
    SavedFilter,
    PrefetchHooks Function()>;
typedef $$ReportTemplatesTableCreateCompanionBuilder = ReportTemplatesCompanion
    Function({
  required String id,
  required String name,
  required String configJson,
  Value<String?> createdBy,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$ReportTemplatesTableUpdateCompanionBuilder = ReportTemplatesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> configJson,
  Value<String?> createdBy,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$ReportTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $ReportTemplatesTable> {
  $$ReportTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get configJson => $composableBuilder(
      column: $table.configJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ReportTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportTemplatesTable> {
  $$ReportTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get configJson => $composableBuilder(
      column: $table.configJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ReportTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportTemplatesTable> {
  $$ReportTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
      column: $table.configJson, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReportTemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReportTemplatesTable,
    ReportTemplate,
    $$ReportTemplatesTableFilterComposer,
    $$ReportTemplatesTableOrderingComposer,
    $$ReportTemplatesTableAnnotationComposer,
    $$ReportTemplatesTableCreateCompanionBuilder,
    $$ReportTemplatesTableUpdateCompanionBuilder,
    (
      ReportTemplate,
      BaseReferences<_$AppDatabase, $ReportTemplatesTable, ReportTemplate>
    ),
    ReportTemplate,
    PrefetchHooks Function()> {
  $$ReportTemplatesTableTableManager(
      _$AppDatabase db, $ReportTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> configJson = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReportTemplatesCompanion(
            id: id,
            name: name,
            configJson: configJson,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String configJson,
            Value<String?> createdBy = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReportTemplatesCompanion.insert(
            id: id,
            name: name,
            configJson: configJson,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReportTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReportTemplatesTable,
    ReportTemplate,
    $$ReportTemplatesTableFilterComposer,
    $$ReportTemplatesTableOrderingComposer,
    $$ReportTemplatesTableAnnotationComposer,
    $$ReportTemplatesTableCreateCompanionBuilder,
    $$ReportTemplatesTableUpdateCompanionBuilder,
    (
      ReportTemplate,
      BaseReferences<_$AppDatabase, $ReportTemplatesTable, ReportTemplate>
    ),
    ReportTemplate,
    PrefetchHooks Function()>;
typedef $$BackupJobsTableCreateCompanionBuilder = BackupJobsCompanion Function({
  required String id,
  required String type,
  Value<String?> schedule,
  Value<int?> lastRunAt,
  Value<String?> status,
  Value<String?> path,
  Value<String?> signature,
  Value<String?> contentHash,
  required int createdAt,
  Value<int> rowid,
});
typedef $$BackupJobsTableUpdateCompanionBuilder = BackupJobsCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String?> schedule,
  Value<int?> lastRunAt,
  Value<String?> status,
  Value<String?> path,
  Value<String?> signature,
  Value<String?> contentHash,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$BackupJobsTableFilterComposer
    extends Composer<_$AppDatabase, $BackupJobsTable> {
  $$BackupJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get schedule => $composableBuilder(
      column: $table.schedule, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastRunAt => $composableBuilder(
      column: $table.lastRunAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get signature => $composableBuilder(
      column: $table.signature, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BackupJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $BackupJobsTable> {
  $$BackupJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get schedule => $composableBuilder(
      column: $table.schedule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastRunAt => $composableBuilder(
      column: $table.lastRunAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get signature => $composableBuilder(
      column: $table.signature, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BackupJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackupJobsTable> {
  $$BackupJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get schedule =>
      $composableBuilder(column: $table.schedule, builder: (column) => column);

  GeneratedColumn<int> get lastRunAt =>
      $composableBuilder(column: $table.lastRunAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get signature =>
      $composableBuilder(column: $table.signature, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BackupJobsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BackupJobsTable,
    BackupJob,
    $$BackupJobsTableFilterComposer,
    $$BackupJobsTableOrderingComposer,
    $$BackupJobsTableAnnotationComposer,
    $$BackupJobsTableCreateCompanionBuilder,
    $$BackupJobsTableUpdateCompanionBuilder,
    (BackupJob, BaseReferences<_$AppDatabase, $BackupJobsTable, BackupJob>),
    BackupJob,
    PrefetchHooks Function()> {
  $$BackupJobsTableTableManager(_$AppDatabase db, $BackupJobsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackupJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackupJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackupJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> schedule = const Value.absent(),
            Value<int?> lastRunAt = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> path = const Value.absent(),
            Value<String?> signature = const Value.absent(),
            Value<String?> contentHash = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupJobsCompanion(
            id: id,
            type: type,
            schedule: schedule,
            lastRunAt: lastRunAt,
            status: status,
            path: path,
            signature: signature,
            contentHash: contentHash,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            Value<String?> schedule = const Value.absent(),
            Value<int?> lastRunAt = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> path = const Value.absent(),
            Value<String?> signature = const Value.absent(),
            Value<String?> contentHash = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupJobsCompanion.insert(
            id: id,
            type: type,
            schedule: schedule,
            lastRunAt: lastRunAt,
            status: status,
            path: path,
            signature: signature,
            contentHash: contentHash,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BackupJobsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BackupJobsTable,
    BackupJob,
    $$BackupJobsTableFilterComposer,
    $$BackupJobsTableOrderingComposer,
    $$BackupJobsTableAnnotationComposer,
    $$BackupJobsTableCreateCompanionBuilder,
    $$BackupJobsTableUpdateCompanionBuilder,
    (BackupJob, BaseReferences<_$AppDatabase, $BackupJobsTable, BackupJob>),
    BackupJob,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$RolesTableTableManager get roles =>
      $$RolesTableTableManager(_db, _db.roles);
  $$PermissionsTableTableManager get permissions =>
      $$PermissionsTableTableManager(_db, _db.permissions);
  $$UserRolesTableTableManager get userRoles =>
      $$UserRolesTableTableManager(_db, _db.userRoles);
  $$RolePermissionsTableTableManager get rolePermissions =>
      $$RolePermissionsTableTableManager(_db, _db.rolePermissions);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$DepartmentsTableTableManager get departments =>
      $$DepartmentsTableTableManager(_db, _db.departments);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$EmployeeContactsTableTableManager get employeeContacts =>
      $$EmployeeContactsTableTableManager(_db, _db.employeeContacts);
  $$EmployeeSocialsTableTableManager get employeeSocials =>
      $$EmployeeSocialsTableTableManager(_db, _db.employeeSocials);
  $$EmployeeEducationsTableTableManager get employeeEducations =>
      $$EmployeeEducationsTableTableManager(_db, _db.employeeEducations);
  $$EmployeeSkillsTableTableManager get employeeSkills =>
      $$EmployeeSkillsTableTableManager(_db, _db.employeeSkills);
  $$EmployeeInterestsTableTableManager get employeeInterests =>
      $$EmployeeInterestsTableTableManager(_db, _db.employeeInterests);
  $$EmployeeInsurancesTableTableManager get employeeInsurances =>
      $$EmployeeInsurancesTableTableManager(_db, _db.employeeInsurances);
  $$EmployeeEvaluationsTableTableManager get employeeEvaluations =>
      $$EmployeeEvaluationsTableTableManager(_db, _db.employeeEvaluations);
  $$EmployeeDocumentsTableTableManager get employeeDocuments =>
      $$EmployeeDocumentsTableTableManager(_db, _db.employeeDocuments);
  $$EmployeeGroupsTableTableManager get employeeGroups =>
      $$EmployeeGroupsTableTableManager(_db, _db.employeeGroups);
  $$EmployeeGroupMembersTableTableManager get employeeGroupMembers =>
      $$EmployeeGroupMembersTableTableManager(_db, _db.employeeGroupMembers);
  $$EmployeePerformanceReviewsTableTableManager
      get employeePerformanceReviews =>
          $$EmployeePerformanceReviewsTableTableManager(
              _db, _db.employeePerformanceReviews);
  $$EmployeeWorkerProjectsTableTableManager get employeeWorkerProjects =>
      $$EmployeeWorkerProjectsTableTableManager(
          _db, _db.employeeWorkerProjects);
  $$AttendanceRecordsTableTableManager get attendanceRecords =>
      $$AttendanceRecordsTableTableManager(_db, _db.attendanceRecords);
  $$FieldSuggestionsTableTableManager get fieldSuggestions =>
      $$FieldSuggestionsTableTableManager(_db, _db.fieldSuggestions);
  $$EmployeeSampleTitlesTableTableManager get employeeSampleTitles =>
      $$EmployeeSampleTitlesTableTableManager(_db, _db.employeeSampleTitles);
  $$EmployeeSampleIntroductionsTableTableManager
      get employeeSampleIntroductions =>
          $$EmployeeSampleIntroductionsTableTableManager(
              _db, _db.employeeSampleIntroductions);
  $$EmployeeGroupActivitiesTableTableManager get employeeGroupActivities =>
      $$EmployeeGroupActivitiesTableTableManager(
          _db, _db.employeeGroupActivities);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$SavedFiltersTableTableManager get savedFilters =>
      $$SavedFiltersTableTableManager(_db, _db.savedFilters);
  $$ReportTemplatesTableTableManager get reportTemplates =>
      $$ReportTemplatesTableTableManager(_db, _db.reportTemplates);
  $$BackupJobsTableTableManager get backupJobs =>
      $$BackupJobsTableTableManager(_db, _db.backupJobs);
}
