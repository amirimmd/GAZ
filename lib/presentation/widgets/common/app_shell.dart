import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/permission_codes.dart';
import '../../../core/security/session_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/gaz_logo.dart';
import '../../../domain/entities/user_entity.dart';
import '../../providers/auth_provider.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _allDestinations = [
    _NavItem('/dashboard', Icons.dashboard_outlined, Icons.dashboard, 'داشبورد'),
    _NavItem(
      '/employees',
      Icons.badge_outlined,
      Icons.badge,
      'کارکنان',
      PermissionCodes.employeesView,
    ),
    _NavItem(
      '/attendance',
      Icons.event_available_outlined,
      Icons.event_available,
      'حضور و غیاب',
      PermissionCodes.attendanceView,
    ),
    _NavItem(
      '/samples',
      Icons.military_tech_outlined,
      Icons.military_tech,
      'عناوین نمونه',
      PermissionCodes.employeesView,
    ),
    _NavItem(
      '/search',
      Icons.search_outlined,
      Icons.search,
      'جستجو',
      PermissionCodes.searchAdvanced,
    ),
    _NavItem(
      '/groups',
      Icons.groups_outlined,
      Icons.groups,
      'گروه‌ها',
      PermissionCodes.groupsView,
    ),
    _NavItem(
      '/documents',
      Icons.folder_outlined,
      Icons.folder,
      'اسناد',
      PermissionCodes.documentsView,
    ),
    _NavItem(
      '/reports',
      Icons.assessment_outlined,
      Icons.assessment,
      'گزارش‌ها',
      PermissionCodes.reportsView,
    ),
    _NavItem(
      '/backup',
      Icons.backup_outlined,
      Icons.backup,
      'پشتیبان',
      PermissionCodes.systemBackup,
    ),
    _NavItem(
      '/users',
      Icons.manage_accounts_outlined,
      Icons.manage_accounts,
      'کاربران',
      PermissionCodes.usersView,
    ),
    _NavItem(
      '/audit',
      Icons.history_outlined,
      Icons.history,
      'ممیزی',
      PermissionCodes.systemAuditView,
    ),
    _NavItem(
      '/settings',
      Icons.settings_outlined,
      Icons.settings,
      'تنظیمات',
      PermissionCodes.systemSettings,
    ),
  ];

  static const _mobilePrimaryCount = 4;

  List<_NavItem> _visibleDestinations(AuthSession? session) {
    if (session == null) return _allDestinations.take(1).toList();
    return _allDestinations
        .where(
          (d) =>
              d.permission == null ||
              session.user.hasPermission(d.permission!),
        )
        .toList();
  }

  int _indexForLocation(String location, List<_NavItem> visible) {
    final i = visible.indexWhere((d) => location.startsWith(d.path));
    return i < 0 ? 0 : i;
  }

  Future<void> _logout() async {
    await ref.read(authActionsProvider).logout();
    if (mounted) context.go('/login');
  }

  void _openDrawer() {
    final state = _scaffoldKey.currentState;
    if (state != null && state.hasDrawer) {
      state.openDrawer();
    }
  }

  void _closeDrawer() {
    final state = _scaffoldKey.currentState;
    if (state != null && state.isDrawerOpen) {
      state.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final session = ref.watch(sessionControllerProvider);
    final visible = _visibleDestinations(session);
    final selected = _indexForLocation(location, visible);
    final useRail = !context.isMobileLayout;

    if (useRail) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selected.clamp(0, visible.length - 1),
              onDestinationSelected: (i) => context.go(visible[i].path),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: GazSpacing.md),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(GazRadii.sm),
                      child: const GazLogo(
                        height: 52,
                        width: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.appNameFa,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              destinations: [
                for (final d in visible)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                children: [
                  _TopBar(
                    compact: false,
                    userName: session?.user.displayName ?? '',
                    onLock: () => context.go('/lock'),
                    onLogout: _logout,
                  ),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final primaryCount = visible.length > _mobilePrimaryCount
        ? _mobilePrimaryCount
        : visible.length;
    final bottomIndex = selected < primaryCount
        ? selected
        : selected.clamp(0, primaryCount - 1);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'منو',
          icon: const Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const GazLogo(height: 28, width: 28, fit: BoxFit.contain),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppConstants.appNameFa,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'قفل',
            onPressed: () => context.go('/lock'),
            icon: const Icon(Icons.lock_outline),
          ),
          IconButton(
            tooltip: 'خروج',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GazLogo(height: 48, width: 48, fit: BoxFit.contain),
                    const SizedBox(height: 10),
                    Text(
                      AppConstants.appNameFa,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      AppConstants.organizationNameFa,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (session != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        session.user.displayName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: visible.length,
                  itemBuilder: (context, i) {
                    final item = visible[i];
                    final isSelected = selected == i;
                    return ListTile(
                      leading: Icon(
                        isSelected ? item.selectedIcon : item.icon,
                      ),
                      title: Text(item.label),
                      selected: isSelected,
                      onTap: () {
                        _closeDrawer();
                        context.go(item.path);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: widget.child),
      bottomNavigationBar: primaryCount > 0
          ? NavigationBar(
              selectedIndex: bottomIndex,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              height: 64,
              onDestinationSelected: (i) {
                if (i < primaryCount) {
                  context.go(visible[i].path);
                }
              },
              destinations: [
                for (final d in visible.take(primaryCount))
                  NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: d.label,
                  ),
              ],
            )
          : null,
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.userName,
    required this.onLock,
    required this.onLogout,
    required this.compact,
  });

  final String userName;
  final VoidCallback onLock;
  final VoidCallback onLogout;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      elevation: 0.5,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 20,
            vertical: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppConstants.appNameFa,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              if (!compact) ...[
                Flexible(
                  child: Text(
                    userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              IconButton(
                tooltip: 'قفل',
                onPressed: onLock,
                icon: const Icon(Icons.lock_outline),
              ),
              IconButton(
                tooltip: 'خروج',
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(
    this.path,
    this.icon,
    this.selectedIcon,
    this.label, [
    this.permission,
  ]);

  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String? permission;
}
