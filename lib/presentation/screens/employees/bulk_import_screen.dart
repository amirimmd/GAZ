import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/open_saved_file.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/usecases/employee/bulk_import_service.dart';
import '../../../domain/usecases/employee/employee_usecases.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/gaz_jalali_date_field.dart';
import 'employee_list_screen.dart';

class BulkImportScreen extends ConsumerStatefulWidget {
  const BulkImportScreen({super.key});

  @override
  ConsumerState<BulkImportScreen> createState() => _BulkImportScreenState();
}

class _BulkImportScreenState extends ConsumerState<BulkImportScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _service = BulkImportService();

  List<ImportRowResult> _rows = [];
  List<_ManualRow> _manualRows = [_ManualRow()];
  bool _busy = false;
  String? _status;
  bool _toolsExpanded = true;
  final Set<int> _expandedCards = {0};

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    for (final r in _manualRows) {
      r.dispose();
    }
    super.dispose();
  }

  void _onUserStartedEntry() {
    if (_toolsExpanded) {
      setState(() => _toolsExpanded = false);
    }
  }

  Future<void> _downloadTemplate({required bool excel}) async {
    try {
      if (excel) {
        final opened = await saveAndOpenFile(
          bytes: _service.exportExcelTemplate(),
          fileName: 'employee_import_template.xlsx',
        );
        setState(
          () => _status = opened.ok
              ? 'قالب اکسل ذخیره و باز شد:\n${opened.path}'
              : 'قالب اکسل ذخیره شد:\n${opened.path}\n${opened.error}',
        );
      } else {
        final opened = await saveAndOpenFile(
          bytes: Uint8List.fromList(utf8.encode(_service.exportCsvTemplate())),
          fileName: 'employee_import_template.csv',
          mimeType: 'text/csv',
        );
        setState(
          () => _status = opened.ok
              ? 'قالب CSV ذخیره و باز شد:\n${opened.path}'
              : 'قالب CSV ذخیره شد:\n${opened.path}\n${opened.error}',
        );
      }
    } catch (e) {
      setState(() => _status = 'ذخیره قالب ناموفق: $e');
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['xlsx', 'xls', 'csv'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) {
      setState(() => _status = 'خواندن فایل ممکن نبود');
      return;
    }

    final parsed = file.extension?.toLowerCase() == 'csv'
        ? _service.parseCsv(decodeBytes(bytes))
        : _service.parseExcel(bytes);

    parsed.fold(
      (f) => setState(() {
        _rows = [];
        _status = f.message;
      }),
      (rows) {
        final dups = _service.findDuplicateNationalIds(rows);
        final marked = rows.map((r) {
          final id = r.employee?.nationalId;
          if (id != null && dups.contains(id)) {
            return r.copyWith(
              errors: [...r.errors, 'کد ملی تکراری در فایل'],
              employee: r.employee,
            );
          }
          return r;
        }).toList();
        setState(() {
          _rows = marked;
          _toolsExpanded = false;
          final valid = marked.where((e) => e.isValid).length;
          _status = '${marked.length} ردیف بارگذاری شد — $valid معتبر';
          _tabs.index = 0;
        });
      },
    );
  }

  Future<void> _importSelected() async {
    final selected = _rows.where((r) => r.selected && r.isValid).toList();
    if (selected.isEmpty) {
      setState(() => _status = 'ردیفی انتخاب نشده است');
      return;
    }
    setState(() => _busy = true);
    final useCase =
        BulkCreateEmployeesUseCase(ref.read(employeeRepositoryProvider));
    final result = await useCase(selected.map((r) => r.employee!).toList());
    if (!mounted) return;
    setState(() {
      _busy = false;
      _status =
          'ثبت شد: ${result.successCount} — ناموفق: ${result.failCount}'
          '${result.failures.isEmpty ? '' : '\n${result.failures.take(5).join('\n')}'}';
    });
    ref.invalidate(employeeListProvider);
    if (result.successCount > 0 && result.failCount == 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.successCount} کارمند ذخیره شد')),
      );
    }
  }

  Future<void> _saveManualRows() async {
    final parsed = <ImportRowResult>[];
    for (var i = 0; i < _manualRows.length; i++) {
      final m = _manualRows[i];
      if (m.isBlank) continue;
      parsed.add(
        _service.fromManualMap(i + 1, {
          'firstName': m.firstName.text.trim(),
          'lastName': m.lastName.text.trim(),
          'fatherName': m.fatherName.text.trim(),
          'nationalId': m.nationalId.text.trim(),
          'employeeNumber': m.employeeNumber.text.trim(),
          'currentPosition': m.position.text.trim(),
          'primaryPhone': m.phone.text.trim(),
          'email': m.email.text.trim(),
          'gender': m.gender ?? '',
          'employmentStatus': m.status,
          'birthDate': m.birthDate.text.trim(),
          'employmentDate': m.employmentDate.text.trim(),
        }),
      );
    }

    if (parsed.isEmpty) {
      setState(() => _status = 'حداقل یک ردیف را پر کنید');
      return;
    }

    final valid = parsed.where((r) => r.isValid).map((r) => r.employee!).toList();
    final invalid = parsed.where((r) => !r.isValid).toList();
    if (invalid.isNotEmpty) {
      setState(() {
        _status = invalid
            .map((r) => 'ردیف ${r.rowIndex}: ${r.errors.join('، ')}')
            .join('\n');
      });
      return;
    }

    setState(() => _busy = true);
    final useCase =
        BulkCreateEmployeesUseCase(ref.read(employeeRepositoryProvider));
    final result = await useCase(valid);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _status =
          'ثبت گروهی: ${result.successCount} موفق / ${result.failCount} ناموفق'
          '${result.failures.isEmpty ? '' : '\n${result.failures.take(5).join('\n')}'}';
    });
    ref.invalidate(employeeListProvider);
    if (result.successCount > 0) {
      for (final r in _manualRows) {
        r.dispose();
      }
      setState(() {
        _manualRows = [_ManualRow()];
        _expandedCards
          ..clear()
          ..add(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final validCount = _rows.where((r) => r.selected && r.isValid).length;

    return Padding(
      padding: EdgeInsets.all(context.isNarrow ? GazSpacing.md : GazSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.go('/employees'),
                icon: const Icon(Icons.arrow_forward),
              ),
              Expanded(
                child: Text(
                  'ورود گروهی کارکنان',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: GazSpacing.sm),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              key: ValueKey('tools_$_toolsExpanded'),
              initiallyExpanded: _toolsExpanded,
              onExpansionChanged: (v) => setState(() => _toolsExpanded = v),
              leading: const Icon(Icons.upload_file_outlined),
              title: const Text('ابزار فایل و قالب'),
              subtitle: Text(
                _toolsExpanded
                    ? 'دانلود قالب یا بارگذاری فایل اکسل/CSV'
                    : 'برای نمایش دوباره لمس کنید',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () => _downloadTemplate(excel: true),
                        icon: const Icon(Icons.grid_on),
                        label: const Text('دانلود قالب اکسل'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _downloadTemplate(excel: false),
                        icon: const Icon(Icons.table_rows),
                        label: const Text('دانلود قالب CSV'),
                      ),
                      FilledButton.icon(
                        onPressed: _busy ? null : _pickFile,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('بارگذاری فایل'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: GazSpacing.sm),
          GazTabBar(
            controller: _tabs,
            tabs: const [
              Tab(text: 'پیش‌نمایش فایل'),
              Tab(text: 'ورود سریع'),
            ],
          ),
          const SizedBox(height: GazSpacing.sm),
          if (_status != null)
            Padding(
              padding: const EdgeInsets.only(bottom: GazSpacing.sm),
              child: Text(
                _status!,
                style: TextStyle(color: scheme.primary),
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _FilePreviewTab(
                  rows: _rows,
                  busy: _busy,
                  validCount: validCount,
                  onToggle: (i, v) => setState(() {
                    _rows[i] = _rows[i].copyWith(selected: v);
                  }),
                  onImport: _importSelected,
                ),
                _ManualGridTab(
                  rows: _manualRows,
                  busy: _busy,
                  expanded: _expandedCards,
                  onExpandChanged: (i, open) {
                    setState(() {
                      if (open) {
                        _expandedCards.add(i);
                      } else {
                        _expandedCards.remove(i);
                      }
                    });
                  },
                  onFieldFocus: _onUserStartedEntry,
                  onAdd: () => setState(() {
                    _manualRows.add(_ManualRow());
                    _expandedCards.add(_manualRows.length - 1);
                    _onUserStartedEntry();
                  }),
                  onRemove: (i) {
                    setState(() {
                      _manualRows[i].dispose();
                      _manualRows.removeAt(i);
                      _expandedCards.remove(i);
                      if (_manualRows.isEmpty) {
                        _manualRows.add(_ManualRow());
                        _expandedCards.add(0);
                      }
                    });
                  },
                  onSave: _saveManualRows,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilePreviewTab extends StatelessWidget {
  const _FilePreviewTab({
    required this.rows,
    required this.busy,
    required this.validCount,
    required this.onToggle,
    required this.onImport,
  });

  final List<ImportRowResult> rows;
  final bool busy;
  final int validCount;
  final void Function(int index, bool value) onToggle;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(GazSpacing.xl),
            child: Text(
              'فایلی بارگذاری نشده است.\nقالب را دانلود کنید، در اکسل پر کنید و اینجا بارگذاری کنید.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Text('${rows.length} ردیف — $validCount انتخاب‌شده و معتبر'),
            FilledButton.icon(
              onPressed: busy || validCount == 0 ? null : onImport,
              icon: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_alt),
              label: Text(busy ? 'در حال ثبت...' : 'ثبت انتخاب‌شده‌ها'),
            ),
          ],
        ),
        const SizedBox(height: GazSpacing.sm),
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: ListView.separated(
              itemCount: rows.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final r = rows[i];
                return CheckboxListTile(
                  value: r.selected && r.isValid,
                  onChanged: r.isValid
                      ? (v) => onToggle(i, v ?? false)
                      : null,
                  title: Text(
                    r.employee?.fullName ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    r.isValid
                        ? '${r.employee?.nationalId ?? ''} — ${r.employee?.currentPosition ?? ''}'
                        : r.errors.join('، '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: r.isValid ? null : GazColors.error,
                    ),
                  ),
                  secondary: Text('${r.rowIndex}'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ManualGridTab extends StatelessWidget {
  const _ManualGridTab({
    required this.rows,
    required this.busy,
    required this.expanded,
    required this.onExpandChanged,
    required this.onFieldFocus,
    required this.onAdd,
    required this.onRemove,
    required this.onSave,
  });

  final List<_ManualRow> rows;
  final bool busy;
  final Set<int> expanded;
  final void Function(int index, bool open) onExpandChanged;
  final VoidCallback onFieldFocus;
  final VoidCallback onAdd;
  final void Function(int index) onRemove;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            const Text('هر کارت قابل جمع شدن است'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('کارت جدید'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: busy ? null : onSave,
                  icon: const Icon(Icons.group_add),
                  label: Text(busy ? 'در حال ثبت...' : 'ثبت همه'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: GazSpacing.sm),
        Expanded(
          child: ListView.separated(
            itemCount: rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: GazSpacing.sm),
            itemBuilder: (context, i) {
              final r = rows[i];
              final open = expanded.contains(i);
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  key: ValueKey('manual_${i}_$open'),
                  initiallyExpanded: open,
                  onExpansionChanged: (v) => onExpandChanged(i, v),
                  leading: CircleAvatar(
                    child: Text('${i + 1}'),
                  ),
                  title: Text(
                    r.summaryTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    open ? 'برای جمع کردن لمس کنید' : 'برای ویرایش باز کنید',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    tooltip: 'حذف',
                    onPressed: () => onRemove(i),
                    icon: const Icon(Icons.delete_outline),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Focus(
                        onFocusChange: (has) {
                          if (has) onFieldFocus();
                        },
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final gap = GazSpacing.md;
                            final w = constraints.maxWidth > 700
                                ? (constraints.maxWidth - gap) / 2
                                : constraints.maxWidth;
                            Widget box(Widget child) =>
                                SizedBox(width: w, child: child);
                            return Wrap(
                              spacing: gap,
                              runSpacing: gap,
                              children: [
                                box(_tf(r.firstName, 'نام *')),
                                box(_tf(r.lastName, 'نام خانوادگی *')),
                                box(_tf(r.fatherName, 'نام پدر')),
                                box(_tf(r.nationalId, 'کد ملی *')),
                                box(
                                  GazJalaliDateField(
                                    controller: r.birthDate,
                                    label: 'تاریخ تولد',
                                  ),
                                ),
                                box(
                                  GazJalaliDateField(
                                    controller: r.employmentDate,
                                    label: 'تاریخ استخدام',
                                  ),
                                ),
                                box(_tf(r.employeeNumber, 'شماره پرسنلی')),
                                box(_tf(r.position, 'سمت')),
                                box(_tf(r.phone, 'تلفن')),
                                box(_tf(r.email, 'ایمیل')),
                                box(
                                  DropdownButtonFormField<String>(
                                    value: r.gender,
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      labelText: 'جنسیت',
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'male',
                                        child: Text('مرد'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'female',
                                        child: Text('زن'),
                                      ),
                                    ],
                                    onChanged: (v) => r.gender = v,
                                  ),
                                ),
                                box(
                                  DropdownButtonFormField<String>(
                                    value: r.status,
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      labelText: 'وضعیت',
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'active',
                                        child: Text('فعال'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'leave',
                                        child: Text('مرخصی'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'terminated',
                                        child: Text('خاتمه'),
                                      ),
                                    ],
                                    onChanged: (v) =>
                                        r.status = v ?? 'active',
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _tf(TextEditingController c, String label) {
    return TextField(
      controller: c,
      onTap: onFieldFocus,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _ManualRow {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final fatherName = TextEditingController();
  final nationalId = TextEditingController();
  final employeeNumber = TextEditingController();
  final position = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final birthDate = TextEditingController();
  final employmentDate = TextEditingController();
  String? gender;
  String status = 'active';

  String get summaryTitle {
    final name =
        '${firstName.text.trim()} ${lastName.text.trim()}'.trim();
    if (name.isNotEmpty) return name;
    if (nationalId.text.trim().isNotEmpty) return nationalId.text.trim();
    return 'کارمند جدید';
  }

  bool get isBlank =>
      firstName.text.trim().isEmpty &&
      lastName.text.trim().isEmpty &&
      nationalId.text.trim().isEmpty;

  void dispose() {
    firstName.dispose();
    lastName.dispose();
    fatherName.dispose();
    nationalId.dispose();
    employeeNumber.dispose();
    position.dispose();
    phone.dispose();
    email.dispose();
    birthDate.dispose();
    employmentDate.dispose();
  }
}
