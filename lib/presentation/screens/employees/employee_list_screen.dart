import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/permission_codes.dart';
import '../../../core/security/photo_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/repositories/employee_repository.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/permission_gate.dart';

final employeeListProvider =
    FutureProvider.autoDispose<List<EmployeeEntity>>((ref) async {
  final repo = ref.watch(employeeRepositoryProvider);
  final result = await repo.search(const EmployeeQuery(limit: 2000));
  return result.fold((f) => throw f, (list) => list);
});

class EmployeeListScreen extends ConsumerStatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  ConsumerState<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends ConsumerState<EmployeeListScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(employeeListProvider);

    return Padding(
      padding: context.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final stack = constraints.maxWidth < 640;
              final title = Text(
                'مدیریت کارکنان',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              );
              final actions = Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PermissionGate(
                    permission: PermissionCodes.employeesImport,
                    child: FilledButton.tonalIcon(
                      onPressed: () => context.push('/employees/import'),
                      icon: const Icon(Icons.group_add),
                      label: const Text('ورود گروهی'),
                    ),
                  ),
                  PermissionGate(
                    permission: PermissionCodes.employeesCreate,
                    child: FilledButton.icon(
                      onPressed: () => context.push('/employees/new'),
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('کارمند جدید'),
                    ),
                  ),
                ],
              );
              if (stack) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [title, const SizedBox(height: 12), actions],
                );
              }
              return Row(
                children: [
                  Expanded(child: title),
                  actions,
                ],
              );
            },
          ),
          const SizedBox(height: GazSpacing.md),
          TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'جستجوی نام، کد ملی، شماره پرسنلی...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.clear),
                    ),
            ),
            onChanged: (v) => setState(() => _query = v.trim()),
          ),
          const SizedBox(height: GazSpacing.md),
          Expanded(
            child: asyncList.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطا: $e')),
              data: (items) {
                final filtered = _query.isEmpty
                    ? items
                    : items
                        .where(
                          (e) =>
                              e.fullName.contains(_query) ||
                              e.nationalId.contains(_query) ||
                              (e.employeeNumber ?? '').contains(_query),
                        )
                        .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('کارمندی یافت نشد'));
                }

                final narrow = MediaQuery.sizeOf(context).width < 700;
                if (narrow) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final e = filtered[i];
                        return ListTile(
                          leading: _EmployeePhoto(path: e.photoPath),
                          title: Text(e.fullName),
                          subtitle: Text(
                            '${e.nationalId} • ${e.currentPosition ?? 'بدون سمت'}'
                            '${e.personType == 'worker' ? ' • کارگر' : ''}',
                          ),
                          trailing: _StatusChip(status: e.employmentStatus),
                          onTap: () => context.push('/employees/${e.id}'),
                        );
                      },
                    ),
                  );
                }

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('نام')),
                          DataColumn(label: Text('کد ملی')),
                          DataColumn(label: Text('شماره پرسنلی')),
                          DataColumn(label: Text('سمت')),
                          DataColumn(label: Text('وضعیت')),
                          DataColumn(label: Text('')),
                        ],
                        rows: [
                          for (final e in filtered)
                            DataRow(
                              cells: [
                                DataCell(Text(e.fullName)),
                                DataCell(Text(e.nationalId)),
                                DataCell(Text(e.employeeNumber ?? '—')),
                                DataCell(Text(e.currentPosition ?? '—')),
                                DataCell(
                                  _StatusChip(status: e.employmentStatus),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.chevron_left),
                                    onPressed: () =>
                                        context.push('/employees/${e.id}'),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'active' => GazColors.success,
      'terminated' => GazColors.error,
      _ => GazColors.info,
    };
    final label = switch (status) {
      'active' => 'فعال',
      'terminated' => 'خاتمه',
      'leave' => 'مرخصی',
      _ => status,
    };
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide.none,
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _EmployeePhoto extends StatelessWidget {
  const _EmployeePhoto({this.path});
  final String? path;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: PhotoStore.resolveFile(path),
      builder: (context, snap) {
        final file = snap.data;
        if (file != null) {
          return CircleAvatar(backgroundImage: FileImage(file));
        }
        return const CircleAvatar(child: Icon(Icons.person_outline));
      },
    );
  }
}
