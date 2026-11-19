import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/usecases/report/report_builder_service.dart';

const _kColumnsPref = 'gaz_report_columns';
const _kShowLogoPref = 'gaz_report_show_logo';
const _kWatermarkModePref = 'gaz_report_watermark_mode';
const _kOrientationPref = 'gaz_report_orientation';
const _kPageNumbersPref = 'gaz_report_page_numbers';

Future<Set<String>> loadSavedReportColumns() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_kColumnsPref);
  if (raw == null || raw.trim().isEmpty) {
    return {...ReportColumnCatalog.defaultKeys};
  }
  final valid = ReportColumnCatalog.all.map((c) => c.key).toSet();
  final keys = raw
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty && valid.contains(e))
      .toSet();
  if (keys.isEmpty) return {...ReportColumnCatalog.defaultKeys};
  return keys;
}

Future<void> saveReportColumns(Set<String> keys) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kColumnsPref, keys.join(','));
}

class SavedReportLayout {
  const SavedReportLayout({
    required this.columns,
    required this.showLogo,
    required this.watermarkMode,
    required this.orientation,
    required this.pageNumbers,
  });

  final Set<String> columns;
  final bool showLogo;
  final ReportWatermarkMode watermarkMode;
  final ReportOrientation orientation;
  final bool pageNumbers;
}

Future<SavedReportLayout> loadSavedReportLayout() async {
  final prefs = await SharedPreferences.getInstance();
  final modeName = prefs.getString(_kWatermarkModePref);
  final orientName = prefs.getString(_kOrientationPref);
  return SavedReportLayout(
    columns: await loadSavedReportColumns(),
    showLogo: prefs.getBool(_kShowLogoPref) ?? true,
    watermarkMode: ReportWatermarkMode.values.firstWhere(
      (e) => e.name == modeName,
      orElse: () => ReportWatermarkMode.none,
    ),
    orientation: ReportOrientation.values.firstWhere(
      (e) => e.name == orientName,
      orElse: () => ReportOrientation.auto,
    ),
    pageNumbers: prefs.getBool(_kPageNumbersPref) ?? true,
  );
}

Future<void> saveReportLayout({
  required Set<String> columns,
  required bool showLogo,
  required ReportWatermarkMode watermarkMode,
  required ReportOrientation orientation,
  required bool pageNumbers,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kColumnsPref, columns.join(','));
  await prefs.setBool(_kShowLogoPref, showLogo);
  await prefs.setString(_kWatermarkModePref, watermarkMode.name);
  await prefs.setString(_kOrientationPref, orientation.name);
  await prefs.setBool(_kPageNumbersPref, pageNumbers);
}

class ReportColumnPicker extends StatelessWidget {
  const ReportColumnPicker({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  void _replace(Iterable<String> keys) {
    onChanged({...keys});
  }

  void _toggle(String key, bool value) {
    final next = {...selected};
    if (value) {
      next.add(key);
    } else {
      next.remove(key);
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ستون‌ها (${selected.length})',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            TextButton(
              onPressed: () =>
                  _replace(ReportColumnCatalog.all.map((c) => c.key)),
              child: const Text('همه'),
            ),
            TextButton(
              onPressed: () => _replace(const []),
              child: const Text('هیچ‌کدام'),
            ),
            TextButton(
              onPressed: () => _replace(ReportColumnCatalog.defaultKeys),
              child: const Text('پیش‌فرض'),
            ),
          ],
        ),
        for (final group in ReportColumnCatalog.groups) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              group,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          for (final c
              in ReportColumnCatalog.all.where((c) => c.group == group))
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(c.titleFa),
              value: selected.contains(c.key),
              onChanged: (v) => _toggle(c.key, v ?? false),
            ),
        ],
      ],
    );
  }
}

Future<Set<String>?> showReportColumnPickerDialog(
  BuildContext context, {
  Set<String>? initial,
}) async {
  var selected = {...(initial ?? await loadSavedReportColumns())};
  if (!context.mounted) return null;
  return showDialog<Set<String>>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setSt) {
          return AlertDialog(
            title: const Text('ستون‌های خروجی'),
            content: SizedBox(
              width: 420,
              height: 480,
              child: SingleChildScrollView(
                child: ReportColumnPicker(
                  selected: selected,
                  onChanged: (s) => setSt(() => selected = s),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('انصراف'),
              ),
              TextButton(
                onPressed: selected.isEmpty
                    ? null
                    : () async {
                        await saveReportColumns(selected);
                        if (ctx.mounted) Navigator.pop(ctx, selected);
                      },
                child: const Text('ذخیره'),
              ),
              FilledButton(
                onPressed: selected.isEmpty
                    ? null
                    : () => Navigator.pop(ctx, selected),
                child: const Text('ادامه'),
              ),
            ],
          );
        },
      );
    },
  );
}
