import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/permission_codes.dart';
import '../../../core/security/crypto_service.dart';
import 'tables/auth_tables.dart';
import 'tables/employee_tables.dart';
import 'tables/system_tables.dart';
import 'tables/win7_parity_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Roles,
    Permissions,
    UserRoles,
    RolePermissions,
    Sessions,
    Departments,
    Units,
    Employees,
    EmployeeContacts,
    EmployeeSocials,
    EmployeeEducations,
    EmployeeSkills,
    EmployeeInterests,
    EmployeeInsurances,
    EmployeeEvaluations,
    EmployeeDocuments,
    EmployeeGroups,
    EmployeeGroupMembers,
    EmployeePerformanceReviews,
    EmployeeWorkerProjects,
    AttendanceRecords,
    FieldSuggestions,
    EmployeeSampleTitles,
    EmployeeSampleIntroductions,
    EmployeeGroupActivities,
    AuditLogs,
    AppSettings,
    SavedFilters,
    ReportTemplates,
    BackupJobs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => AppConstants.schemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement('PRAGMA foreign_keys = ON');
          await _seed();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(employeeGroups);
            await m.createTable(employeeGroupMembers);
            await _migrateV2Permissions();
          }
          if (from < 3) {
            await m.createTable(employeePerformanceReviews);
            await m.createTable(employeeWorkerProjects);
          }
          if (from < 4) {
            await m.createTable(attendanceRecords);
            await _ensurePermissions([
              PermissionCodes.attendanceView,
              PermissionCodes.attendanceEdit,
            ]);
          }
          if (from < 5) {
            await _addColumnSafe(
              employees,
              employees.jobGroup,
              "ALTER TABLE employees ADD COLUMN job_group TEXT NULL",
            );
            await _addColumnSafe(
              employees,
              employees.positionBase,
              "ALTER TABLE employees ADD COLUMN position_base REAL NULL",
            );
            await _addColumnSafe(
              employees,
              employees.personalBase,
              "ALTER TABLE employees ADD COLUMN personal_base REAL NULL",
            );
          }
          if (from < 6) {
            await m.createTable(fieldSuggestions);
          }
          if (from < 7) {
            await m.createTable(employeeSampleTitles);
          }
          if (from < 8) {
            await _addColumnSafe(
              employees,
              employees.personType,
              "ALTER TABLE employees ADD COLUMN person_type TEXT NOT NULL DEFAULT 'staff'",
            );
          }
          if (from < 9) {
            await m.createTable(employeeSampleIntroductions);
          }
          if (from < 10) {
            await _addColumnSafe(
              employees,
              employees.retirementDate,
              "ALTER TABLE employees ADD COLUMN retirement_date TEXT NULL",
            );
            await _addColumnSafe(
              employees,
              employees.inactiveReason,
              "ALTER TABLE employees ADD COLUMN inactive_reason TEXT NULL",
            );
          }
          if (from < 11) {
            await m.createTable(employeeGroupActivities);
          }
          if (from < 12) {
            await _addColumnSafe(
              employeeGroups,
              employeeGroups.photoPath,
              "ALTER TABLE employee_groups ADD COLUMN photo_path TEXT NULL",
            );
          }
          if (from < to) {
            await _ensurePermissions(PermissionCodes.all);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('PRAGMA journal_mode = WAL');
          // Heal restored Win7 DBs / partial upgrades without stomping user_version.
          await _ensureWin7SchemaParity();
        },
      );

  Future<void> _addColumnSafe(
    TableInfo table,
    GeneratedColumn column,
    String sql,
  ) async {
    final rows = await customSelect('PRAGMA table_info(${table.actualTableName})')
        .get();
    final names = rows.map((r) => r.read<String>('name')).toSet();
    if (names.contains(column.name)) return;
    await customStatement(sql);
  }

  /// Idempotent CREATE IF NOT EXISTS for tables that may arrive via Win7 backup.
  Future<void> _ensureWin7SchemaParity() async {
    await customStatement('''
CREATE TABLE IF NOT EXISTS employee_performance_reviews (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  year INTEGER NOT NULL,
  season INTEGER NOT NULL,
  track TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'draft',
  evaluator_name TEXT NULL,
  evaluator_user_id TEXT NULL,
  notes TEXT NULL,
  check_in TEXT NULL,
  check_out TEXT NULL,
  presence_hours REAL NULL,
  duty_hours REAL NULL,
  worksheet_count INTEGER NOT NULL DEFAULT 0,
  worksheet_quota INTEGER NOT NULL DEFAULT 0,
  complaints_filed INTEGER NOT NULL DEFAULT 0,
  complaints_valid INTEGER NOT NULL DEFAULT 0,
  complaints_answered INTEGER NOT NULL DEFAULT 0,
  response_quality INTEGER NOT NULL DEFAULT 5,
  social_participation INTEGER NOT NULL DEFAULT 3,
  extra_effort INTEGER NOT NULL DEFAULT 3,
  extra_human_capital INTEGER NOT NULL DEFAULT 3,
  extra_org_relations INTEGER NOT NULL DEFAULT 3,
  extra_club INTEGER NOT NULL DEFAULT 3,
  extra_evidence TEXT NULL,
  expected_projects INTEGER NOT NULL DEFAULT 0,
  expected_volume REAL NOT NULL DEFAULT 0,
  expected_checklists INTEGER NOT NULL DEFAULT 0,
  main_score REAL NULL,
  extra_score REAL NULL,
  light_code TEXT NULL,
  safety_red_flag INTEGER NOT NULL DEFAULT 0,
  exemplary INTEGER NOT NULL DEFAULT 0,
  extra_org_badge INTEGER NOT NULL DEFAULT 0,
  approved_at INTEGER NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE (employee_id, year, season, track)
)''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS employee_worker_projects (
  id TEXT NOT NULL PRIMARY KEY,
  review_id TEXT NOT NULL REFERENCES employee_performance_reviews(id),
  title TEXT NOT NULL,
  level INTEGER NOT NULL,
  hours REAL NOT NULL,
  progress_percent REAL NOT NULL,
  checklist_count INTEGER NOT NULL DEFAULT 0,
  incidents_direct INTEGER NOT NULL DEFAULT 0,
  incidents_indirect INTEGER NOT NULL DEFAULT 0,
  severe INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER NOT NULL DEFAULT 0
)''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS attendance_records (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  work_date TEXT NOT NULL,
  status TEXT NOT NULL,
  check_in TEXT NULL,
  check_out TEXT NULL,
  hours REAL NULL,
  note TEXT NULL,
  created_by TEXT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE (employee_id, work_date)
)''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS field_suggestions (
  category TEXT NOT NULL,
  value TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  PRIMARY KEY (category, value)
)''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS employee_sample_titles (
  id TEXT NOT NULL PRIMARY KEY,
  employee_id TEXT NOT NULL REFERENCES employees(id),
  year INTEGER NOT NULL,
  kind TEXT NOT NULL,
  note TEXT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  created_by TEXT NULL,
  UNIQUE (employee_id, year, kind)
)''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS employee_sample_introductions (
  id TEXT NOT NULL PRIMARY KEY,
  sample_title_id TEXT NOT NULL REFERENCES employee_sample_titles(id) ON DELETE CASCADE,
  organization TEXT NOT NULL,
  note TEXT NULL,
  created_at INTEGER NOT NULL,
  created_by TEXT NULL
)''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS employee_group_activities (
  id TEXT NOT NULL PRIMARY KEY,
  group_id TEXT NOT NULL REFERENCES employee_groups(id),
  title TEXT NOT NULL,
  note TEXT NULL,
  activity_date TEXT NULL,
  created_by TEXT NULL,
  created_by_name TEXT NULL,
  created_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
)''');

    Future<void> addEmpCol(String name, String ddl) async {
      final rows = await customSelect('PRAGMA table_info(employees)').get();
      final have = rows.map((r) => r.read<String>('name')).toSet();
      if (!have.contains(name)) await customStatement(ddl);
    }

    await addEmpCol(
      'person_type',
      "ALTER TABLE employees ADD COLUMN person_type TEXT NOT NULL DEFAULT 'staff'",
    );
    await addEmpCol(
      'retirement_date',
      'ALTER TABLE employees ADD COLUMN retirement_date TEXT NULL',
    );
    await addEmpCol(
      'inactive_reason',
      'ALTER TABLE employees ADD COLUMN inactive_reason TEXT NULL',
    );
    await addEmpCol(
      'job_group',
      'ALTER TABLE employees ADD COLUMN job_group TEXT NULL',
    );
    await addEmpCol(
      'position_base',
      'ALTER TABLE employees ADD COLUMN position_base REAL NULL',
    );
    await addEmpCol(
      'personal_base',
      'ALTER TABLE employees ADD COLUMN personal_base REAL NULL',
    );

    final gRows =
        await customSelect('PRAGMA table_info(employee_groups)').get();
    final gHave = gRows.map((r) => r.read<String>('name')).toSet();
    if (!gHave.contains('photo_path')) {
      await customStatement(
        'ALTER TABLE employee_groups ADD COLUMN photo_path TEXT NULL',
      );
    }

    await _ensurePermissions(PermissionCodes.all);
  }

  Future<void> _ensurePermissions(List<String> codes) async {
    const uuid = Uuid();
    final existing = await select(permissions).get();
    final have = existing.map((p) => p.code).toSet();
    final permissionIds = <String, String>{
      for (final p in existing) p.code: p.id,
    };
    for (final code in codes) {
      if (have.contains(code)) continue;
      final id = uuid.v4();
      permissionIds[code] = id;
      await into(permissions).insert(
        PermissionsCompanion.insert(
          id: id,
          code: code,
          module: code.split('.').first,
          nameFa: code,
          nameEn: Value(code),
        ),
      );
    }
    final roleRows = await select(roles).get();
    String? adminRoleId;
    String? hrRoleId;
    String? opRoleId;
    String? viewerRoleId;
    for (final r in roleRows) {
      if (r.code == 'administrator') adminRoleId = r.id;
      if (r.code == 'hr_manager') hrRoleId = r.id;
      if (r.code == 'operator') opRoleId = r.id;
      if (r.code == 'viewer') viewerRoleId = r.id;
    }

    Future<void> grant(String? roleId, Iterable<String> grantCodes) async {
      if (roleId == null) return;
      final current = await (select(rolePermissions)
            ..where((rp) => rp.roleId.equals(roleId)))
          .get();
      final havePerm = current.map((e) => e.permissionId).toSet();
      for (final code in grantCodes) {
        final pid = permissionIds[code];
        if (pid == null || havePerm.contains(pid)) continue;
        await into(rolePermissions).insert(
          RolePermissionsCompanion.insert(roleId: roleId, permissionId: pid),
        );
      }
    }

    await grant(adminRoleId, PermissionCodes.all);
    await grant(hrRoleId, [
      PermissionCodes.attendanceView,
      PermissionCodes.attendanceEdit,
      PermissionCodes.groupsView,
      PermissionCodes.groupsCreate,
      PermissionCodes.groupsEdit,
      PermissionCodes.groupsDelete,
      PermissionCodes.groupsExport,
    ]);
    await grant(opRoleId, [
      PermissionCodes.attendanceView,
      PermissionCodes.attendanceEdit,
    ]);
    await grant(viewerRoleId, [PermissionCodes.attendanceView]);
  }

  Future<void> _seed() async {
    const uuid = Uuid();
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;

    // Roles
    final adminRoleId = uuid.v4();
    final hrRoleId = uuid.v4();
    final operatorRoleId = uuid.v4();
    final viewerRoleId = uuid.v4();

    await batch((b) {
      b.insertAll(roles, [
        RolesCompanion.insert(
          id: adminRoleId,
          code: 'administrator',
          nameFa: 'مدیر سیستم',
          nameEn: const Value('Administrator'),
          isSystem: const Value(true),
        ),
        RolesCompanion.insert(
          id: hrRoleId,
          code: 'hr_manager',
          nameFa: 'مدیر منابع انسانی',
          nameEn: const Value('HR Manager'),
          isSystem: const Value(true),
        ),
        RolesCompanion.insert(
          id: operatorRoleId,
          code: 'operator',
          nameFa: 'اپراتور',
          nameEn: const Value('Operator'),
          isSystem: const Value(true),
        ),
        RolesCompanion.insert(
          id: viewerRoleId,
          code: 'viewer',
          nameFa: 'بازدیدکننده',
          nameEn: const Value('Viewer'),
          isSystem: const Value(true),
        ),
      ]);
    });

    // Permissions
    final permissionIds = <String, String>{};
    for (final code in PermissionCodes.all) {
      final id = uuid.v4();
      permissionIds[code] = id;
      final module = code.split('.').first;
      await into(permissions).insert(
        PermissionsCompanion.insert(
          id: id,
          code: code,
          module: module,
          nameFa: code,
          nameEn: Value(code),
        ),
      );
    }

    // Admin gets all permissions
    await batch((b) {
      b.insertAll(
        rolePermissions,
        permissionIds.values
            .map(
              (pid) => RolePermissionsCompanion.insert(
                roleId: adminRoleId,
                permissionId: pid,
              ),
            )
            .toList(),
      );
    });

    // HR subset
    final hrPerms = [
      PermissionCodes.employeesView,
      PermissionCodes.employeesCreate,
      PermissionCodes.employeesEdit,
      PermissionCodes.employeesDelete,
      PermissionCodes.employeesBulk,
      PermissionCodes.employeesExport,
      PermissionCodes.employeesImport,
      PermissionCodes.documentsView,
      PermissionCodes.documentsUpload,
      PermissionCodes.documentsDownload,
      PermissionCodes.documentsDelete,
      PermissionCodes.reportsView,
      PermissionCodes.reportsBuild,
      PermissionCodes.reportsPrint,
      PermissionCodes.reportsExport,
      PermissionCodes.searchAdvanced,
      PermissionCodes.systemAuditView,
      PermissionCodes.groupsView,
      PermissionCodes.groupsCreate,
      PermissionCodes.groupsEdit,
      PermissionCodes.groupsDelete,
      PermissionCodes.groupsExport,
      PermissionCodes.attendanceView,
      PermissionCodes.attendanceEdit,
    ];
    await batch((b) {
      b.insertAll(
        rolePermissions,
        hrPerms
            .where(permissionIds.containsKey)
            .map(
              (c) => RolePermissionsCompanion.insert(
                roleId: hrRoleId,
                permissionId: permissionIds[c]!,
              ),
            )
            .toList(),
      );
    });

    // Operator subset
    final opPerms = [
      PermissionCodes.employeesView,
      PermissionCodes.employeesCreate,
      PermissionCodes.employeesEdit,
      PermissionCodes.documentsView,
      PermissionCodes.documentsUpload,
      PermissionCodes.reportsView,
      PermissionCodes.attendanceView,
      PermissionCodes.attendanceEdit,
    ];
    await batch((b) {
      b.insertAll(
        rolePermissions,
        opPerms
            .map(
              (c) => RolePermissionsCompanion.insert(
                roleId: operatorRoleId,
                permissionId: permissionIds[c]!,
              ),
            )
            .toList(),
      );
    });

    // Viewer subset
    final viewPerms = [
      PermissionCodes.employeesView,
      PermissionCodes.documentsView,
      PermissionCodes.reportsView,
      PermissionCodes.attendanceView,
    ];
    await batch((b) {
      b.insertAll(
        rolePermissions,
        viewPerms
            .map(
              (c) => RolePermissionsCompanion.insert(
                roleId: viewerRoleId,
                permissionId: permissionIds[c]!,
              ),
            )
            .toList(),
      );
    });

    // Default admin — must change password on first login
    final adminId = uuid.v4();
    final hash = PasswordHasher.instance.hashPassword('Admin@ChangeMe1');
    await into(users).insert(
      UsersCompanion.insert(
        id: adminId,
        username: 'admin',
        displayName: 'مدیر سیستم',
        passwordHash: hash,
        mustChangePassword: const Value(true),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await into(userRoles).insert(
      UserRolesCompanion.insert(userId: adminId, roleId: adminRoleId),
    );

    // Organization settings
    await batch((b) {
      b.insertAll(appSettings, [
        AppSettingsCompanion.insert(
          key: 'organization.name.fa',
          value: AppConstants.organizationNameFa,
          updatedAt: now,
        ),
        AppSettingsCompanion.insert(
          key: 'organization.name.en',
          value: AppConstants.organizationNameEn,
          updatedAt: now,
        ),
        AppSettingsCompanion.insert(
          key: 'security.session_timeout_minutes',
          value: '${AppConstants.defaultSessionTimeoutMinutes}',
          updatedAt: now,
        ),
        AppSettingsCompanion.insert(
          key: 'security.auto_lock_minutes',
          value: '${AppConstants.defaultAutoLockMinutes}',
          updatedAt: now,
        ),
        AppSettingsCompanion.insert(
          key: 'theme.mode',
          value: 'system',
          updatedAt: now,
        ),
        AppSettingsCompanion.insert(
          key: 'locale',
          value: 'fa',
          updatedAt: now,
        ),
      ]);
    });
  }

  Future<void> _migrateV2Permissions() async {
    const uuid = Uuid();
    final newCodes = [
      PermissionCodes.groupsView,
      PermissionCodes.groupsCreate,
      PermissionCodes.groupsEdit,
      PermissionCodes.groupsDelete,
      PermissionCodes.groupsExport,
    ];

    final existing = await select(permissions).get();
    final have = existing.map((p) => p.code).toSet();
    final permissionIds = <String, String>{
      for (final p in existing) p.code: p.id,
    };

    for (final code in newCodes) {
      if (have.contains(code)) continue;
      final id = uuid.v4();
      permissionIds[code] = id;
      await into(permissions).insert(
        PermissionsCompanion.insert(
          id: id,
          code: code,
          module: 'groups',
          nameFa: code,
          nameEn: Value(code),
        ),
      );
    }

    final roleRows = await select(roles).get();
    String? adminRoleId;
    String? hrRoleId;
    for (final r in roleRows) {
      if (r.code == 'administrator') adminRoleId = r.id;
      if (r.code == 'hr_manager') hrRoleId = r.id;
    }

    Future<void> grant(String? roleId, List<String> codes) async {
      if (roleId == null) return;
      final current = await (select(rolePermissions)
            ..where((rp) => rp.roleId.equals(roleId)))
          .get();
      final havePerm = current.map((e) => e.permissionId).toSet();
      for (final code in codes) {
        final pid = permissionIds[code];
        if (pid == null || havePerm.contains(pid)) continue;
        await into(rolePermissions).insert(
          RolePermissionsCompanion.insert(roleId: roleId, permissionId: pid),
        );
      }
    }

    await grant(adminRoleId, PermissionCodes.all);
    await grant(hrRoleId, newCodes);
  }
}

/// Opens local SQLite. Document/backup AES-256 remains active via KeyManager.
/// Full SQLCipher / SQLite3MultipleCiphers can be re-enabled via encrypted_drift.
LazyDatabase openEncryptedConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, AppConstants.dbFileName));
    return NativeDatabase.createInBackground(
      file,
      setup: (db) {
        db.execute('PRAGMA foreign_keys = ON;');
        db.execute('PRAGMA journal_mode = WAL;');
      },
    );
  });
}
