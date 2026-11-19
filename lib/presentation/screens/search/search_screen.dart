import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/permission_codes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/repositories/employee_repository.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/permission_gate.dart';
import '../groups/groups_screen.dart';

/// Parses a single search box into AND / OR / NOT terms.
///
/// - Plain words → AND
/// - `OR word` or `| word` → OR
/// - `-word` → NOT
({List<String> andTerms, List<String> orTerms, List<String> notTerms})
    parseAdvancedQuery(String raw) {
  final andTerms = <String>[];
  final orTerms = <String>[];
  final notTerms = <String>[];

  final tokens = raw
      .split(RegExp(r'[,،\s]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  var nextOr = false;
  for (final token in tokens) {
    final upper = token.toUpperCase();
    if (upper == 'OR' || token == '|') {
      nextOr = true;
      continue;
    }
    if (token.startsWith('-') && token.length > 1) {
      notTerms.add(token.substring(1));
      nextOr = false;
      continue;
    }
    if (token.startsWith('|') && token.length > 1) {
      orTerms.add(token.substring(1));
      nextOr = false;
      continue;
    }
    if (nextOr) {
      orTerms.add(token);
      nextOr = false;
    } else {
      andTerms.add(token);
    }
  }
  return (andTerms: andTerms, orTerms: orTerms, notTerms: notTerms);
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _queryCtrl = TextEditingController();
  List<EmployeeEntity> _results = [];
  final Set<String> _selected = {};
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    setState(() {
      _loading = true;
      _error = null;
      _selected.clear();
    });
    final parsed = parseAdvancedQuery(_queryCtrl.text);
    final repo = ref.read(employeeRepositoryProvider);
    final result = await repo.search(
      EmployeeQuery(
        andTerms: parsed.andTerms,
        orTerms: parsed.orTerms,
        notTerms: parsed.notTerms,
        limit: 2000,
      ),
    );
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _loading = false;
        _error = f.message;
        _results = [];
      }),
      (list) => setState(() {
        _loading = false;
        _results = list;
      }),
    );
  }

  void _insertChip(String prefix) {
    final t = _queryCtrl.text.trim();
    final addition = switch (prefix) {
      'OR' => t.isEmpty ? 'OR ' : ' OR ',
      'NOT' => t.isEmpty ? '-' : ' -',
      _ => t.isEmpty ? '' : ' ',
    };
    _queryCtrl.text = '$t$addition';
    _queryCtrl.selection = TextSelection.collapsed(
      offset: _queryCtrl.text.length,
    );
    setState(() {});
  }

  Future<void> _createGroupFromSelection() async {
    final ids = _selected.isEmpty
        ? _results.map((e) => e.id).toList()
        : _selected.toList();
    if (ids.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('نتیجه‌ای برای گروه وجود ندارد')),
      );
      return;
    }
    final createdId = await showCreateGroupDialog(
      context,
      ref,
      memberIds: ids,
      suggestedName: 'گروه جستجو',
    );
    if (createdId != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('گروه ایجاد شد')),
      );
      context.go('/groups/$createdId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(GazSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'جستجوی پیشرفته',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: GazSpacing.sm),
          Text(
            MediaQuery.sizeOf(context).width < 600
                ? 'واژه = AND   |  OR واژه   |  -واژه = NOT'
                : 'واژه‌های معمولی = AND ·  OR واژه  یا  |واژه = OR ·  -واژه = NOT',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: GazSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(GazSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _queryCtrl,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _run(),
                    decoration: const InputDecoration(
                      labelText: 'عبارت جستجو',
                      hintText: 'مثال: مهندس OR گاز -بازنشسته',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: GazSpacing.sm),
                  Wrap(
                    spacing: GazSpacing.sm,
                    children: [
                      ActionChip(
                        label: const Text('AND'),
                        onPressed: () => _insertChip('AND'),
                      ),
                      ActionChip(
                        label: const Text('OR'),
                        onPressed: () => _insertChip('OR'),
                      ),
                      ActionChip(
                        label: const Text('NOT'),
                        onPressed: () => _insertChip('NOT'),
                      ),
                    ],
                  ),
                  const SizedBox(height: GazSpacing.md),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final narrow = constraints.maxWidth < 520;
                      final searchBtn = FilledButton.icon(
                        onPressed: _loading ? null : _run,
                        icon: const Icon(Icons.search, size: 20),
                        label: const Text(
                          'اجرای جستجو',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                      final groupBtn = PermissionGate(
                        permission: PermissionCodes.groupsCreate,
                        child: OutlinedButton.icon(
                          onPressed: _loading || _results.isEmpty
                              ? null
                              : _createGroupFromSelection,
                          icon: const Icon(Icons.group_add, size: 20),
                          label: Text(
                            _selected.isEmpty
                                ? 'ایجاد گروه از نتایج'
                                : 'گروه از ${_selected.length} نفر',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                      if (narrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 48, child: searchBtn),
                            const SizedBox(height: GazSpacing.sm),
                            SizedBox(height: 48, child: groupBtn),
                          ],
                        );
                      }
                      return Wrap(
                        spacing: GazSpacing.sm,
                        runSpacing: GazSpacing.sm,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 48,
                              maxWidth: 220,
                            ),
                            child: searchBtn,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 48,
                              maxWidth: 260,
                            ),
                            child: groupBtn,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: GazSpacing.md),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: GazSpacing.sm),
              child: Text('خطا: $_error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? const Center(child: Text('نتیجه‌ای نیست'))
                      : Column(
                          children: [
                            CheckboxListTile(
                              value: _selected.length == _results.length &&
                                  _results.isNotEmpty,
                              title: Text('انتخاب همه (${_results.length})'),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    _selected
                                      ..clear()
                                      ..addAll(_results.map((e) => e.id));
                                  } else {
                                    _selected.clear();
                                  }
                                });
                              },
                            ),
                            const Divider(height: 1),
                            Expanded(
                              child: ListView.separated(
                                itemCount: _results.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, i) {
                                  final e = _results[i];
                                  final on = _selected.contains(e.id);
                                  return ListTile(
                                    leading: Checkbox(
                                      value: on,
                                      onChanged: (v) {
                                        setState(() {
                                          if (v == true) {
                                            _selected.add(e.id);
                                          } else {
                                            _selected.remove(e.id);
                                          }
                                        });
                                      },
                                    ),
                                    title: Text(e.fullName),
                                    subtitle: Text(
                                      [
                                        e.nationalId,
                                        if (e.employeeNumber != null)
                                          e.employeeNumber!,
                                        if (e.currentPosition != null)
                                          e.currentPosition!,
                                      ].join(' · '),
                                    ),
                                    onTap: () =>
                                        context.push('/employees/${e.id}'),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
