import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/open_saved_file.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/repositories/employee_repository.dart';
import '../../../domain/usecases/report/report_builder_service.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/report_column_picker.dart';

class ReportBuilderScreen extends ConsumerStatefulWidget {
  const ReportBuilderScreen({super.key});

  @override
  ConsumerState<ReportBuilderScreen> createState() =>
      _ReportBuilderScreenState();
}

class _ReportBuilderScreenState extends ConsumerState<ReportBuilderScreen> {
  final _titleCtrl = TextEditingController(text: 'گزارش کارکنان');
  final _headerCtrl = TextEditingController(
    text: AppConstants.organizationNameFa,
  );
  final _footerCtrl = TextEditingController(text: AppConstants.appNameFa);
  final _watermarkCtrl = TextEditingController(text: AppConstants.appNameFa);
  bool _pageNumbers = true;
  bool _showLogo = true;
  ReportWatermarkMode _watermarkMode = ReportWatermarkMode.none;
  ReportOrientation _orientation = ReportOrientation.auto;
  bool _busy = false;
  String? _status;

  final _selectedColumns = <String>{...ReportColumnCatalog.defaultKeys};

  @override
  void initState() {
    super.initState();
    _restoreLayout();
  }

  Future<void> _restoreLayout() async {
    final saved = await loadSavedReportLayout();
    if (!mounted) return;
    setState(() {
      _selectedColumns
        ..clear()
        ..addAll(saved.columns);
      _showLogo = saved.showLogo;
      _watermarkMode = saved.watermarkMode;
      _orientation = saved.orientation;
      _pageNumbers = saved.pageNumbers;
    });
  }

  Future<void> _saveLayout() async {
    if (_selectedColumns.isEmpty) {
      setState(() => _status = 'حداقل یک ستون انتخاب کنید');
      return;
    }
    await saveReportLayout(
      columns: _selectedColumns,
      showLogo: _showLogo,
      watermarkMode: _watermarkMode,
      orientation: _orientation,
      pageNumbers: _pageNumbers,
    );
    if (!mounted) return;
    setState(() => _status = 'حالت گزارش ذخیره شد');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _headerCtrl.dispose();
    _footerCtrl.dispose();
    _watermarkCtrl.dispose();
    super.dispose();
  }

  ReportConfig _config() => ReportConfig(
        title: _titleCtrl.text.trim().isEmpty
            ? 'گزارش کارکنان'
            : _titleCtrl.text.trim(),
        columns: ReportColumnCatalog.all
            .where((c) => _selectedColumns.contains(c.key))
            .toList(),
        headerText:
            _headerCtrl.text.trim().isEmpty ? null : _headerCtrl.text.trim(),
        footerText:
            _footerCtrl.text.trim().isEmpty ? null : _footerCtrl.text.trim(),
        watermark: _watermarkCtrl.text.trim().isEmpty
            ? null
            : _watermarkCtrl.text.trim(),
        watermarkMode: _watermarkMode,
        showLogo: _showLogo,
        showPageNumbers: _pageNumbers,
        generatedBy: AppConstants.appNameFa,
        orientation: _orientation,
      );

  Future<List<EmployeeEntity>> _loadEmployees() async {
    final repo = ref.read(employeeRepositoryProvider);
    final listResult = await repo.search(const EmployeeQuery(limit: 5000));
    return listResult.valueOrNull ?? <EmployeeEntity>[];
  }

  Future<void> _exportPdf({required bool preview}) async {
    if (_selectedColumns.isEmpty) {
      setState(() => _status = 'حداقل یک ستون انتخاب کنید');
      return;
    }
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final employees = await _loadEmployees();
      final logo = _showLogo || _watermarkMode == ReportWatermarkMode.logo
          ? await _loadLogo()
          : null;
      final bytes = await ReportBuilderService().buildEmployeeReport(
        config: _config(),
        employees: employees,
        logoBytes: logo,
      );

      if (preview) {
        await Printing.layoutPdf(onLayout: (_) async => bytes);
        if (!mounted) return;
        setState(() {
          _busy = false;
          _status =
              'پیش‌نمایش PDF باز شد — ${employees.length} رکورد / ${_selectedColumns.length} ستون';
        });
        return;
      }

      final opened = await saveAndOpenFile(
        bytes: bytes,
        fileName: 'report_${DateTime.now().millisecondsSinceEpoch}.pdf',
        mimeType: 'application/pdf',
      );
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = opened.ok
            ? 'PDF ذخیره و باز شد:\n${opened.path}'
            : 'PDF ذخیره شد:\n${opened.path}\n${opened.error}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = 'خطا در PDF: $e';
      });
    }
  }

  Future<Uint8List?> _loadLogo() async {
    try {
      final data = await rootBundle.load(AppConstants.organizationLogoAsset);
      return data.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<void> _exportExcel() async {
    if (_selectedColumns.isEmpty) {
      setState(() => _status = 'حداقل یک ستون انتخاب کنید');
      return;
    }
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final employees = await _loadEmployees();
      final bytes = await ReportBuilderService().buildEmployeeExcel(
        config: _config(),
        employees: employees,
        logoBytes: _showLogo ? await _loadLogo() : null,
      );
      final opened = await saveAndOpenFile(
        bytes: bytes,
        fileName: 'report_${DateTime.now().millisecondsSinceEpoch}.xlsx',
      );
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = opened.ok
            ? 'اکسل ذخیره و باز شد:\n${opened.path}'
            : 'اکسل ذخیره شد:\n${opened.path}\n${opened.error}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = 'خطا در اکسل: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.pagePadding,
      child: ListView(
        children: [
          Text(
            'سازنده گزارش',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'خروجی PDF و اکسل — ستون‌ها، لوگو و واترمارک را انتخاب کنید',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: GazSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(GazSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(labelText: 'عنوان گزارش'),
                  ),
                  const SizedBox(height: GazSpacing.md),
                  TextField(
                    controller: _headerCtrl,
                    decoration: const InputDecoration(labelText: 'سربرگ'),
                  ),
                  const SizedBox(height: GazSpacing.md),
                  TextField(
                    controller: _footerCtrl,
                    decoration: const InputDecoration(labelText: 'پاورقی'),
                  ),
                  const SizedBox(height: GazSpacing.md),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('لوگو در سربرگ'),
                    value: _showLogo,
                    onChanged: (v) => setState(() => _showLogo = v),
                  ),
                  const SizedBox(height: GazSpacing.sm),
                  const Text('واترمارک'),
                  const SizedBox(height: 8),
                  SegmentedButton<ReportWatermarkMode>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: ReportWatermarkMode.none,
                        label: Text('هیچ'),
                      ),
                      ButtonSegment(
                        value: ReportWatermarkMode.logo,
                        label: Text('لوگو'),
                      ),
                      ButtonSegment(
                        value: ReportWatermarkMode.text,
                        label: Text('متن'),
                      ),
                    ],
                    selected: {_watermarkMode},
                    onSelectionChanged: (s) =>
                        setState(() => _watermarkMode = s.first),
                  ),
                  if (_watermarkMode == ReportWatermarkMode.text) ...[
                    const SizedBox(height: GazSpacing.md),
                    TextField(
                      controller: _watermarkCtrl,
                      decoration: const InputDecoration(
                        labelText: 'متن واترمارک',
                      ),
                    ),
                  ],
                  const SizedBox(height: GazSpacing.md),
                  ReportColumnPicker(
                    selected: _selectedColumns,
                    onChanged: (s) => setState(() {
                      _selectedColumns
                        ..clear()
                        ..addAll(s);
                    }),
                  ),
                  const SizedBox(height: GazSpacing.md),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text('جهت صفحه:'),
                      SegmentedButton<ReportOrientation>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: ReportOrientation.auto,
                            label: Text('خودکار'),
                          ),
                          ButtonSegment(
                            value: ReportOrientation.portrait,
                            label: Text('عمودی'),
                          ),
                          ButtonSegment(
                            value: ReportOrientation.landscape,
                            label: Text('افقی'),
                          ),
                        ],
                        selected: {_orientation},
                        onSelectionChanged: (s) =>
                            setState(() => _orientation = s.first),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: _pageNumbers,
                            onChanged: (v) =>
                                setState(() => _pageNumbers = v),
                          ),
                          const Text('شماره صفحه'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: GazSpacing.lg),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed:
                            _busy ? null : () => _exportPdf(preview: true),
                        icon: const Icon(Icons.print_outlined),
                        label: Text(
                          _busy ? 'در حال ساخت...' : 'پیش‌نمایش / چاپ PDF',
                        ),
                      ),
                      FilledButton.tonalIcon(
                        onPressed:
                            _busy ? null : () => _exportPdf(preview: false),
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('ذخیره PDF'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _busy ? null : _exportExcel,
                        icon: const Icon(Icons.grid_on),
                        label: const Text('خروجی اکسل'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _busy ? null : _saveLayout,
                        icon: const Icon(Icons.bookmark_add_outlined),
                        label: const Text('ذخیره حالت'),
                      ),
                    ],
                  ),
                  if (_status != null) ...[
                    const SizedBox(height: GazSpacing.md),
                    SelectableText(
                      _status!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
