import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/permission_codes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/user_account_summary.dart';
import '../../providers/app_data_providers.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  String? _selectedUserId;

  void _showStubMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature — در نسخه بعدی تکمیل می‌شود')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = context.isNarrow;
    final usersAsync = ref.watch(usersListProvider);

    return Padding(
      padding: EdgeInsets.all(isNarrow ? GazSpacing.md : GazSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final stack = constraints.maxWidth < GazBreakpoints.sm;
              final title = Text(
                'کاربران و نقش‌ها',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              );
              final addButton = FilledButton.icon(
                onPressed: () => _showStubMessage('ایجاد کاربر'),
                icon: const Icon(Icons.person_add),
                label: const Text('کاربر جدید'),
              );
              if (stack) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [title, const SizedBox(height: 12), addButton],
                );
              }
              return Row(
                children: [
                  Expanded(child: title),
                  addButton,
                ],
              );
            },
          ),
          const SizedBox(height: GazSpacing.md),
          Expanded(
            child: usersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطا: $e')),
              data: (users) {
                if (users.isEmpty) {
                  return const Center(child: Text('کاربری ثبت نشده'));
                }

                final selectedId = _selectedUserId ?? users.first.id;
                final selected = users.firstWhere(
                  (u) => u.id == selectedId,
                  orElse: () => users.first,
                );

                final listCard = _UsersListCard(
                  users: users,
                  selectedId: selected.id,
                  onSelect: (id) => setState(() => _selectedUserId = id),
                );
                final permsCard = _PermissionsCard(
                  user: selected,
                  onStub: _showStubMessage,
                );

                if (isNarrow) {
                  return Column(
                    children: [
                      Expanded(child: listCard),
                      const SizedBox(height: GazSpacing.md),
                      Expanded(flex: 2, child: permsCard),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: listCard),
                    const SizedBox(width: GazSpacing.md),
                    Expanded(flex: 2, child: permsCard),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersListCard extends StatelessWidget {
  const _UsersListCard({
    required this.users,
    required this.selectedId,
    required this.onSelect,
  });

  final List<UserAccountSummary> users;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final u = users[i];
          final roles = u.roleCodes.isEmpty
              ? 'بدون نقش'
              : u.roleCodes.join('، ');
          return ListTile(
            selected: u.id == selectedId,
            onTap: () => onSelect(u.id),
            leading: const Icon(Icons.admin_panel_settings),
            title: Text(u.username),
            subtitle: Text('${u.displayName} — $roles'),
            trailing: Chip(
              label: Text(u.isActive ? 'فعال' : 'غیرفعال'),
            ),
          );
        },
      ),
    );
  }
}

class _PermissionsCard extends StatelessWidget {
  const _PermissionsCard({
    required this.user,
    required this.onStub,
  });

  final UserAccountSummary user;
  final void Function(String) onStub;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GazSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ماتریس دسترسی — ${user.username}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: GazSpacing.md),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final code in PermissionCodes.all)
                      FilterChip(
                        label: Text(code),
                        selected: user.permissions.contains(code),
                        onSelected: (_) => onStub('ویرایش دسترسی'),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
