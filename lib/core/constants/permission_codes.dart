/// Stable permission codes — never renumber; add new codes only.
abstract final class PermissionCodes {
  // Auth / System
  static const String systemSettings = 'system.settings';
  static const String systemBackup = 'system.backup';
  static const String systemRestore = 'system.restore';
  static const String systemAuditView = 'system.audit.view';
  static const String systemAuditExport = 'system.audit.export';

  // Users
  static const String usersView = 'users.view';
  static const String usersCreate = 'users.create';
  static const String usersEdit = 'users.edit';
  static const String usersDelete = 'users.delete';
  static const String usersRoles = 'users.roles';

  // Employees
  static const String employeesView = 'employees.view';
  static const String employeesCreate = 'employees.create';
  static const String employeesEdit = 'employees.edit';
  static const String employeesDelete = 'employees.delete';
  static const String employeesBulk = 'employees.bulk';
  static const String employeesExport = 'employees.export';
  static const String employeesImport = 'employees.import';

  // Documents
  static const String documentsView = 'documents.view';
  static const String documentsUpload = 'documents.upload';
  static const String documentsDownload = 'documents.download';
  static const String documentsDelete = 'documents.delete';

  // Reports
  static const String reportsView = 'reports.view';
  static const String reportsBuild = 'reports.build';
  static const String reportsPrint = 'reports.print';
  static const String reportsExport = 'reports.export';

  // Search
  static const String searchAdvanced = 'search.advanced';

  // Groups
  static const String groupsView = 'groups.view';
  static const String groupsCreate = 'groups.create';
  static const String groupsEdit = 'groups.edit';
  static const String groupsDelete = 'groups.delete';
  static const String groupsExport = 'groups.export';

  // Attendance (Win7 parity)
  static const String attendanceView = 'attendance.view';
  static const String attendanceEdit = 'attendance.edit';

  static const List<String> all = [
    systemSettings,
    systemBackup,
    systemRestore,
    systemAuditView,
    systemAuditExport,
    usersView,
    usersCreate,
    usersEdit,
    usersDelete,
    usersRoles,
    employeesView,
    employeesCreate,
    employeesEdit,
    employeesDelete,
    employeesBulk,
    employeesExport,
    employeesImport,
    documentsView,
    documentsUpload,
    documentsDownload,
    documentsDelete,
    reportsView,
    reportsBuild,
    reportsPrint,
    reportsExport,
    searchAdvanced,
    groupsView,
    groupsCreate,
    groupsEdit,
    groupsDelete,
    groupsExport,
    attendanceView,
    attendanceEdit,
  ];
}
