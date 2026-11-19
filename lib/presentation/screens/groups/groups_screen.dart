import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/permission_codes.dart';
import '../../../core/security/session_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/open_saved_file.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/entities/employee_group_entity.dart';
import '../../../domain/repositories/employee_repository.dart';
import '../../../domain/usecases/report/report_builder_service.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/permission_gate.dart';
import '../../widgets/common/report_column_picker.dart';

final groupsFilterProvider = StateProvider<GroupQuery>(
  (ref) => const GroupQuery(status: GroupStatus.active),
);

final groupsListProvider =
    FutureProvider.autoDispose<List<EmployeeGroupEntity>>((ref) async {
  final query = ref.watch(groupsFilterProvider);
  final result = await ref.watch(employeeGroupRepositoryProvider).list(query);
  return result.fold((f) => throw f, (list) => list);
});

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter({
    String? searchText,
    GroupStatus? status,
    GroupPurposeType? purposeType,
    bool clearPurpose = false,
  }) {
    final current = ref.read(groupsFilterProvider);
    ref.read(groupsFilterProvider.notifier).state = GroupQuery(
      searchText: searchText ?? current.searchText,
      status: status ?? current.status,
      purposeType: clearPurpose ? null : (purposeType ?? current.purposeType),
    );
  }

  Future<void> _createGroup() async {
    final createdId = await showCreateGroupDialog(context, ref);
    if (!mounted || createdId == null) return;
    ref.invalidate(groupsListProvider);
    context.push('/groups/$createdId');
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(groupsFilterProvider);
    final asyncList = ref.watch(groupsListProvider);

    return Padding(
      padding: context.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: GazSpacing.sm,
            runSpacing: GazSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(
                'گروه‌های کارمندان',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              PermissionGate(
                permission: PermissionCodes.groupsCreate,
                child: FilledButton.icon(
                  onPressed: _createGroup,
                  icon: const Icon(Icons.group_add),
                  label: const Text('گروه جدید'),
                ),
              ),
            ],
          ),
          const SizedBox(height: GazSpacing.md),
          Wrap(
            spacing: GazSpacing.sm,
            runSpacing: GazSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                    hintText: 'جستجوی نام گروه...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) => _applyFilter(
                    searchText: v.trim().isEmpty ? null : v.trim(),
                  ),
                ),
              ),
              DropdownButton<GroupStatus?>(
                value: filter.status,
                hint: const Text('وضعیت'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('همه')),
                  for (final s in GroupStatus.values)
                    DropdownMenuItem(value: s, child: Text(s.labelFa)),
                ],
                onChanged: (v) {
                  ref.read(groupsFilterProvider.notifier).state = GroupQuery(
                    searchText: filter.searchText,
                    status: v,
                    purposeType: filter.purposeType,
                  );
                },
              ),
              DropdownButton<GroupPurposeType?>(
                value: filter.purposeType,
                hint: const Text('نوع'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('همه')),
                  for (final p in GroupPurposeType.values)
                    DropdownMenuItem(value: p, child: Text(p.labelFa)),
                ],
                onChanged: (v) {
                  ref.read(groupsFilterProvider.notifier).state = GroupQuery(
                    searchText: filter.searchText,
                    status: filter.status,
                    purposeType: v,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: GazSpacing.md),
          Expanded(
            child: asyncList.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('خطا: $e', textAlign: TextAlign.center),
                    const SizedBox(height: GazSpacing.md),
                    FilledButton(
                      onPressed: () => ref.invalidate(groupsListProvider),
                      child: const Text('تلاش مجدد'),
                    ),
                  ],
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('گروهی یافت نشد'));
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final g = items[i];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${g.memberCount}'),
                        ),
                        title: Text(g.name),
                        subtitle: Text(
                          '${g.purposeType.labelFa} · ${g.status.labelFa}',
                        ),
                        trailing: const Icon(Icons.chevron_left),
                        onTap: () => context.push('/groups/${g.id}'),
                      );
                    },
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

/// Shared dialog for creating a group. Returns the new group id, or null.
Future<String?> showCreateGroupDialog(
  BuildContext context,
  WidgetRef ref, {
  List<String> memberIds = const [],
  String? suggestedName,
}) async {
  final nameCtrl = TextEditingController(text: suggestedName ?? '');
  final descCtrl = TextEditingController();
  var purpose = GroupPurposeType.other;
  DateTime? startsAt;
  DateTime? endsAt;
  var saving = false;

  final createdId = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setLocal) {
          return AlertDialog(
            title: Text(
              memberIds.isEmpty
                  ? 'ایجاد گروه'
                  : 'ایجاد گروه از ${memberIds.length} نفر',
            ),
            content: SizedBox(
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'نام گروه *',
                      ),
                    ),
                    const SizedBox(height: GazSpacing.md),
                    DropdownButtonFormField<GroupPurposeType>(
                      value: purpose,
                      decoration: const InputDecoration(labelText: 'نوع/منظور'),
                      items: [
                        for (final p in GroupPurposeType.values)
                          DropdownMenuItem(value: p, child: Text(p.labelFa)),
                      ],
                      onChanged: (v) {
                        if (v != null) setLocal(() => purpose = v);
                      },
                    ),
                    const SizedBox(height: GazSpacing.md),
                    TextField(
                      controller: descCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'توضیحات'),
                    ),
                    const SizedBox(height: GazSpacing.md),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        startsAt == null
                            ? 'تاریخ شروع'
                            : 'شروع: ${DateFormat('yyyy/MM/dd').format(startsAt!)}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final d = await showDatePicker(
                          context: ctx,
                          initialDate: startsAt ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) setLocal(() => startsAt = d);
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        endsAt == null
                            ? 'تاریخ پایان'
                            : 'پایان: ${DateFormat('yyyy/MM/dd').format(endsAt!)}',
                      ),
                      trailing: const Icon(Icons.event),
                      onTap: () async {
                        final d = await showDatePicker(
                          context: ctx,
                          initialDate: endsAt ?? startsAt ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) setLocal(() => endsAt = d);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: saving ? null : () => Navigator.pop(ctx),
                child: const Text('انصراف'),
              ),
              FilledButton(
                onPressed: saving
                    ? null
                    : () async {
                        final user =
                            ref.read(sessionControllerProvider)?.user;
                        setLocal(() => saving = true);
                        final result = await ref
                            .read(employeeGroupRepositoryProvider)
                            .create(
                              name: nameCtrl.text,
                              purposeType: purpose,
                              description: descCtrl.text.trim().isEmpty
                                  ? null
                                  : descCtrl.text.trim(),
                              startsAt: startsAt,
                              endsAt: endsAt,
                              createdBy: user?.username ?? 'system',
                              memberIds: memberIds,
                            );
                        if (!ctx.mounted) return;
                        result.fold(
                          (f) {
                            setLocal(() => saving = false);
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text(f.message)),
                            );
                          },
                          (g) => Navigator.pop(ctx, g.id),
                        );
                      },
                child: saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('ایجاد'),
              ),
            ],
          );
        },
      );
    },
  );

  nameCtrl.dispose();
  descCtrl.dispose();
  return createdId;
}

class GroupDetailScreen extends ConsumerStatefulWidget {
  const GroupDetailScreen({required this.groupId, super.key});

  final String groupId;

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  EmployeeGroupEntity? _group;
  bool _loading = true;
  String? _error;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref
        .read(employeeGroupRepositoryProvider)
        .getById(widget.groupId);
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _loading = false;
        _error = f.message;
      }),
      (g) => setState(() {
        _loading = false;
        _group = g;
      }),
    );
  }

  Future<void> _toggleArchive() async {
    final g = _group;
    if (g == null) return;
    final next = g.status == GroupStatus.active
        ? GroupStatus.archived
        : GroupStatus.active;
    await ref.read(employeeGroupRepositoryProvider).setStatus(g.id, next);
    await _load();
    ref.invalidate(groupsListProvider);
  }

  Future<void> _export({required bool excel}) async {
    final g = _group;
    if (g == null) return;
    final keys = await showReportColumnPickerDialog(context);
    if (keys == null || keys.isEmpty || !mounted) return;
    setState(() => _exporting = true);
    try {
      final svc = ReportBuilderService();
      final cols = ReportColumnCatalog.all
          .where((c) => keys.contains(c.key))
          .toList();
      final config = ReportConfig(
        title: 'اعضای گروه: ${g.name}',
        columns: cols,
        headerText: '${g.purposeType.labelFa} — ${g.status.labelFa}',
        generatedBy: ref.read(sessionControllerProvider)?.user.username,
        showLogo: true,
      );
      final bytes = excel
          ? await svc.buildEmployeeExcel(
              config: config,
              employees: g.members,
            )
          : await svc.buildEmployeeReport(
              config: config,
              employees: g.members,
            );
      final ext = excel ? 'xlsx' : 'pdf';
      final opened = await saveAndOpenFile(
        bytes: bytes,
        fileName: 'group_${g.id.substring(0, 8)}.$ext',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              opened.ok
                  ? 'ذخیره و باز شد: ${opened.path}'
                  : 'ذخیره شد: ${opened.path}\n${opened.error}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خروجی ناموفق: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _addMembers() async {
    final g = _group;
    if (g == null) return;
    final repo = ref.read(employeeRepositoryProvider);
    final result = await repo.search(const EmployeeQuery(limit: 2000));
    final all = result.fold((_) => <EmployeeEntity>[], (l) => l);
    final existing = g.members.map((e) => e.id).toSet();
    final candidates = all.where((e) => !existing.contains(e.id)).toList();
    if (!mounted) return;

    final selected = <String>{};
    final searchCtrl = TextEditingController();
    var filter = '';

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final filtered = filter.isEmpty
                ? candidates
                : candidates
                    .where(
                      (e) =>
                          e.fullName.contains(filter) ||
                          e.nationalId.contains(filter),
                    )
                    .toList();
            return AlertDialog(
              title: const Text('افزودن عضو'),
              content: SizedBox(
                width: 480,
                height: 420,
                child: Column(
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        hintText: 'فیلتر نام یا کد ملی',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (v) => setLocal(() => filter = v.trim()),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final e = filtered[i];
                          final on = selected.contains(e.id);
                          return CheckboxListTile(
                            value: on,
                            title: Text(e.fullName),
                            subtitle: Text(e.nationalId),
                            onChanged: (v) {
                              setLocal(() {
                                if (v == true) {
                                  selected.add(e.id);
                                } else {
                                  selected.remove(e.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('انصراف'),
                ),
                FilledButton(
                  onPressed: selected.isEmpty
                      ? null
                      : () => Navigator.pop(ctx, true),
                  child: Text('افزودن (${selected.length})'),
                ),
              ],
            );
          },
        );
      },
    );
    searchCtrl.dispose();
    if (ok != true || selected.isEmpty) return;
    final user = ref.read(sessionControllerProvider)?.user;
    await ref.read(employeeGroupRepositoryProvider).addMembers(
          g.id,
          selected.toList(),
          addedBy: user?.username,
        );
    await _load();
    ref.invalidate(groupsListProvider);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null || _group == null) {
      return Center(child: Text(_error ?? 'گروه یافت نشد'));
    }
    final g = _group!;
    final df = DateFormat('yyyy/MM/dd');

    return Padding(
      padding: context.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.go('/groups'),
                icon: const Icon(Icons.arrow_forward),
              ),
              Expanded(
                child: Text(
                  g.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              PermissionGate(
                permission: PermissionCodes.groupsEdit,
                child: TextButton.icon(
                  onPressed: _toggleArchive,
                  icon: Icon(
                    g.status == GroupStatus.active
                        ? Icons.archive_outlined
                        : Icons.unarchive_outlined,
                  ),
                  label: Text(
                    g.status == GroupStatus.active ? 'بایگانی' : 'فعال‌سازی',
                  ),
                ),
              ),
              PermissionGate(
                permission: PermissionCodes.groupsExport,
                child: PopupMenuButton<String>(
                  enabled: !_exporting && g.members.isNotEmpty,
                  onSelected: (v) => _export(excel: v == 'xlsx'),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'pdf', child: Text('خروجی PDF')),
                    PopupMenuItem(value: 'xlsx', child: Text('خروجی اکسل')),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _exporting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.download),
                              SizedBox(width: 4),
                              Text('گزارش اعضا'),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(GazSpacing.md),
              child: Wrap(
                spacing: GazSpacing.lg,
                runSpacing: GazSpacing.sm,
                children: [
                  Text('نوع: ${g.purposeType.labelFa}'),
                  Text('وضعیت: ${g.status.labelFa}'),
                  if (g.startsAt != null)
                    Text('شروع: ${df.format(g.startsAt!.toLocal())}'),
                  if (g.endsAt != null)
                    Text('پایان: ${df.format(g.endsAt!.toLocal())}'),
                  Text('اعضا: ${g.memberCount}'),
                  if (g.description != null && g.description!.isNotEmpty)
                    Text('توضیح: ${g.description}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: GazSpacing.md),
          Row(
            children: [
              Text(
                'اعضا',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              PermissionGate(
                permission: PermissionCodes.groupsEdit,
                child: OutlinedButton.icon(
                  onPressed: _addMembers,
                  icon: const Icon(Icons.person_add),
                  label: const Text('افزودن عضو'),
                ),
              ),
            ],
          ),
          const SizedBox(height: GazSpacing.sm),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: g.members.isEmpty
                  ? const Center(child: Text('عضوی ندارد'))
                  : ListView.separated(
                      itemCount: g.members.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final e = g.members[i];
                        return ListTile(
                          title: Text(e.fullName),
                          subtitle: Text(
                            '${e.nationalId}'
                            '${e.currentPosition != null ? ' · ${e.currentPosition}' : ''}',
                          ),
                          onTap: () => context.push('/employees/${e.id}'),
                          trailing: PermissionGate(
                            permission: PermissionCodes.groupsEdit,
                            child: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () async {
                                await ref
                                    .read(employeeGroupRepositoryProvider)
                                    .removeMember(g.id, e.id);
                                await _load();
                                ref.invalidate(groupsListProvider);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
