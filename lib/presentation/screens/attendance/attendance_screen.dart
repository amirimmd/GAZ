import 'package:drift/drift.dart' show Variable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../core/theme/app_theme.dart';
import '../../providers/repository_providers.dart';

/// حضور و غیاب — داده‌های بازیابی‌شده از بکاپ Win7 را نمایش می‌دهد.
class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  late String _month;
  bool _loading = true;
  String? _error;
  List<_AttRow> _rows = [];

  @override
  void initState() {
    super.initState();
    final j = Jalali.now();
    _month =
        '${j.year.toString().padLeft(4, '0')}/${j.month.toString().padLeft(2, '0')}';
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
SELECT a.id, a.employee_id, a.work_date, a.status, a.check_in, a.check_out, a.hours, a.note,
       e.first_name, e.last_name, e.national_id
FROM attendance_records a
JOIN employees e ON e.id = a.employee_id
WHERE a.work_date LIKE ?
ORDER BY a.work_date DESC, e.last_name COLLATE NOCASE
LIMIT 500
''',
        variables: [Variable.withString('$_month%')],
        readsFrom: {db.attendanceRecords, db.employees},
      ).get();

      _rows = records
          .map(
            (r) => _AttRow(
              id: r.read<String>('id'),
              employeeId: r.read<String>('employee_id'),
              name:
                  '${r.read<String>('first_name')} ${r.read<String>('last_name')}',
              nationalId: r.read<String>('national_id'),
              workDate: r.read<String>('work_date'),
              status: r.read<String>('status'),
              checkIn: r.readNullable<String>('check_in'),
              checkOut: r.readNullable<String>('check_out'),
              hours: r.readNullable<double>('hours'),
              note: r.readNullable<String>('note'),
            ),
          )
          .toList();
    } catch (e) {
      _error = '$e';
      _rows = [];
    }
    if (mounted) setState(() => _loading = false);
  }

  String _statusFa(String s) {
    switch (s) {
      case 'present':
        return 'حاضر';
      case 'absent':
        return 'غایب';
      case 'leave':
        return 'مرخصی';
      case 'mission':
        return 'مأموریت';
      case 'holiday':
        return 'تعطیل';
      default:
        return s;
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
              'حضور و غیاب',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: GazColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'رکوردهای ماه $_month — سازگار با بکاپ ویندوز',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _month,
                    decoration: const InputDecoration(
                      labelText: 'ماه (مثل 1404/06)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => _month = v.trim(),
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
                  child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                ),
              )
            else if (_rows.isEmpty)
              const Expanded(
                child: Center(child: Text('برای این ماه رکوردی نیست')),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: _rows.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = _rows[i];
                    return ListTile(
                      title: Text(r.name),
                      subtitle: Text(
                        '${r.workDate} · ${_statusFa(r.status)}'
                        '${r.checkIn != null ? ' · ورود ${r.checkIn}' : ''}'
                        '${r.checkOut != null ? ' · خروج ${r.checkOut}' : ''}',
                      ),
                      trailing: r.hours == null
                          ? null
                          : Text('${r.hours!.toStringAsFixed(1)} س'),
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

class _AttRow {
  _AttRow({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.nationalId,
    required this.workDate,
    required this.status,
    this.checkIn,
    this.checkOut,
    this.hours,
    this.note,
  });

  final String id;
  final String employeeId;
  final String name;
  final String nationalId;
  final String workDate;
  final String status;
  final String? checkIn;
  final String? checkOut;
  final double? hours;
  final String? note;
}
