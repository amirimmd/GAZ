import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/security/route_permissions.dart';
import '../../core/security/session_controller.dart';
import '../providers/biometric_provider.dart';
import '../screens/attendance/attendance_screen.dart';
import '../screens/audit/audit_screen.dart';
import '../screens/backup/backup_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/employees/bulk_import_screen.dart';
import '../screens/employees/employee_detail_screen.dart';
import '../screens/employees/employee_list_screen.dart';
import '../screens/login/change_password_screen.dart';
import '../screens/login/lock_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/documents/documents_screen.dart';
import '../screens/groups/groups_screen.dart';
import '../screens/reports/report_builder_screen.dart';
import '../screens/samples/sample_titles_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/users/users_screen.dart';
import '../widgets/common/app_shell.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final listenable = _SessionListenable(ref);
  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/login',
    refreshListenable: listenable,
    redirect: (context, state) {
      final session = ref.read(sessionControllerProvider);
      final loggedIn = session != null;
      final loc = state.matchedLocation;
      final isAuthRoute =
          loc == '/login' || loc == '/lock' || loc == '/change-password';

      if (!loggedIn && !isAuthRoute) return '/login';
      if (!loggedIn && loc == '/lock') return '/login';

      if (loggedIn) {
        if (session!.user.mustChangePassword &&
            loc != '/change-password' &&
            loc != '/lock') {
          return '/change-password';
        }
        // Stay on login while fingerprint opt-in dialog is showing.
        if (loc == '/login') {
          if (ref.read(pendingBiometricSetupProvider)) return null;
          return '/dashboard';
        }
        if (!RoutePermissions.canAccess(loc, session.user.permissions)) {
          return '/dashboard';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/lock',
        builder: (context, state) => const LockScreen(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/employees',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: EmployeeListScreen(),
            ),
            routes: [
              GoRoute(
                path: 'import',
                builder: (context, state) => const BulkImportScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => EmployeeDetailScreen(
                  employeeId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/attendance',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AttendanceScreen(),
            ),
          ),
          GoRoute(
            path: '/samples',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SampleTitlesScreen(),
            ),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SearchScreen(),
            ),
          ),
          GoRoute(
            path: '/groups',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GroupsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => GroupDetailScreen(
                  groupId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/documents',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DocumentsScreen(),
            ),
          ),
          GoRoute(
            path: '/reports',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ReportBuilderScreen(),
            ),
          ),
          GoRoute(
            path: '/backup',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BackupScreen(),
            ),
          ),
          GoRoute(
            path: '/users',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: UsersScreen(),
            ),
          ),
          GoRoute(
            path: '/audit',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AuditScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

/// Notifies GoRouter only on login/logout, forced password change, or bio setup flag.
class _SessionListenable extends ChangeNotifier {
  _SessionListenable(Ref ref) {
    ref.listen(
      sessionControllerProvider.select(
        (s) => '${s?.sessionId}|${s?.user.mustChangePassword}',
      ),
      (_, __) => notifyListeners(),
    );
    ref.listen(pendingBiometricSetupProvider, (_, __) => notifyListeners());
  }
}
