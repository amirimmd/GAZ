import 'package:drift/drift.dart' show Variable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../core/theme/app_theme.dart';
import '../../providers/repository_providers.dart';

/// عناوین نمونه / معرفی‌های فرابخشی — داده از بکاپ Win7.
class SampleTitlesScreen extends ConsumerStatefulWidget {
  const SampleTitlesScreen({super.key});

  @override
  ConsumerState<SampleTitlesScreen> createState() => _SampleTitlesScreenState();
}

class _SampleTitlesScreenState extends ConsumerState<SampleTitlesScreen> {
  late int _year;
  bool _loading = true;
  String? _error;
  List<_SampleRow> _rows = [];

  @override
  void initState() {
    super.initState();
    _year = Jalali.now().year;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final db = ref.read(appDatabaseProvider);
      final records = await db.customSelect(
        '''
SELECT t.id, t.year, t.kind, t.note,
       e.first_name, e.last_name, e.national_id,
       (SELECT COUNT(*) FROM employee_sample_introductions i WHERE i.sample_title_id = t.id) AS intro_count
FROM employee_sample_titles t
JOIN employees e ON e.id = t.employee_id
WHERE t.year = ?
ORDER BY t.kind, e.last_name COLLATE NOCASE
''',
        variables: [Variable.withInt(_year)],
        readsFrom: {
          db.employeeSampleTitles,
          db.employeeSampleIntroductions,
          db.employees,
        },
      ).get();

      _rows = records
          .map(
            (r) => _SampleRow(
              id: r.read<String>('id'),
              name:
                  '${r.read<String>('first_name')} ${r.read<String>('last_name')}',
              nationalId: r.read<String>('national_id'),
              year: r.read<int>('year'),
              kind: r.read<String>('kind'),
              note: r.readNullable<String>('note'),
              introCount: r.read<int>('intro_count'),
            ),
          )
          .toList();
    } catch (e) {
      _error = '$e';
      _rows = [];
    }
    if (mounted) setState(() => _loading = false);
  }

  String _kindFa(String k) {
    switch (k) {
      case 'exemplary':
        return 'نمونه';
      case 'extra_org':
        return 'فرابخشی';
      default:
        return k;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'عناوین نمونه',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: GazColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'سال $_year — سازگار با بکاپ ویندوز',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: '$_year',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'سال شمسی',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) {
                      final n = int.tryParse(v.trim());
                      if (n != null) _year = n;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _loading ? null : _load,
                  icon: const Icon(Icons.refresh),
                  label: const Text('بارگذاری'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_error != null)
              Expanded(
                child: Center(
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              )
            else if (_rows.isEmpty)
              const Expanded(
                child: Center(child: Text('عنوان نمونه‌ای برای این سال نیست')),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: _rows.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = _rows[i];
                    return ListTile(
                      leading: Icon(
                        r.kind == 'exemplary'
                            ? Icons.military_tech
                            : Icons.handshake_outlined,
                        color: GazColors.primary,
                      ),
                      title: Text(r.name),
                      subtitle: Text(
                        '${_kindFa(r.kind)}'
                        '${r.introCount > 0 ? ' · ${r.introCount} معرفی' : ''}'
                        '${r.note != null && r.note!.isNotEmpty ? ' · ${r.note}' : ''}',
                      ),
                      trailing: Text('${r.year}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SampleRow {
  _SampleRow({
    required this.id,
    required this.name,
    required this.nationalId,
    required this.year,
    required this.kind,
    this.note,
    this.introCount = 0,
  });

  final String id;
  final String name;
  final String nationalId;
  final int year;
  final String kind;
  final String? note;
  final int introCount;
}
