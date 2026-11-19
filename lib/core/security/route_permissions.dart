import '../constants/permission_codes.dart';

/// Maps shell routes to required RBAC permission codes.
abstract final class RoutePermissions {
  static const Map<String, String> _exact = {
    '/dashboard': '',
    '/employees': PermissionCodes.employeesView,
    '/attendance': PermissionCodes.attendanceView,
    '/samples': PermissionCodes.employeesView,
    '/search': PermissionCodes.searchAdvanced,
    '/groups': PermissionCodes.groupsView,
    '/documents': PermissionCodes.documentsView,
    '/reports': PermissionCodes.reportsView,
    '/backup': PermissionCodes.systemBackup,
    '/users': PermissionCodes.usersView,
    '/audit': PermissionCodes.systemAuditView,
    '/settings': PermissionCodes.systemSettings,
  };

  /// Returns permission code required for [location], or null when open to any
  /// authenticated user.
  static String? forLocation(String location) {
    if (location.startsWith('/employees/import')) {
      return PermissionCodes.employeesImport;
    }
    if (location.startsWith('/employees/new')) {
      return PermissionCodes.employeesCreate;
    }
    if (location.startsWith('/employees/') && location != '/employees') {
      return PermissionCodes.employeesView;
    }
    if (location.startsWith('/groups/') && location != '/groups') {
      return PermissionCodes.groupsView;
    }
    for (final entry in _exact.entries) {
      if (location == entry.key || location.startsWith('${entry.key}/')) {
        return entry.value.isEmpty ? null : entry.value;
      }
    }
    return null;
  }

  static bool canAccess(String location, Set<String> permissions) {
    final code = forLocation(location);
    if (code == null) return true;
    return permissions.contains(code);
  }
}
