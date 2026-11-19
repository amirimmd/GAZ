import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../core/theme/app_theme.dart';

/// Read-only text field that opens a Jalali date picker on tap.
class GazJalaliDateField extends StatefulWidget {
  const GazJalaliDateField({
    required this.controller,
    required this.label,
    this.requiredField = false,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool requiredField;

  static String format(Jalali j) {
    final m = j.month.toString().padLeft(2, '0');
    final d = j.day.toString().padLeft(2, '0');
    return '${j.year}/$m/$d';
  }

  static Jalali? tryParse(String? raw) {
    if (raw == null) return null;
    final t = raw.trim().replaceAll('-', '/');
    if (t.isEmpty) return null;
    final parts = t.split('/');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    try {
      return Jalali(y, m, d);
    } catch (_) {
      return null;
    }
  }

  @override
  State<GazJalaliDateField> createState() => _GazJalaliDateFieldState();
}

class _GazJalaliDateFieldState extends State<GazJalaliDateField> {
  Future<void> _pick() async {
    final initial =
        GazJalaliDateField.tryParse(widget.controller.text) ?? Jalali.now();
    final picked = await showModalBottomSheet<Jalali>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _JalaliPickerSheet(initial: initial),
    );
    if (picked != null) {
      setState(() {
        widget.controller.text = GazJalaliDateField.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      onTap: _pick,
      validator: widget.requiredField
          ? (v) => (v == null || v.trim().isEmpty) ? 'الزامی' : null
          : null,
      decoration: InputDecoration(
        labelText: widget.requiredField ? '${widget.label} *' : widget.label,
        prefixIcon: const Icon(Icons.calendar_month_outlined),
        suffixIcon: widget.controller.text.isEmpty
            ? IconButton(
                tooltip: 'انتخاب',
                onPressed: _pick,
                icon: const Icon(Icons.edit_calendar_outlined),
              )
            : IconButton(
                tooltip: 'پاک کردن',
                onPressed: () => setState(() => widget.controller.clear()),
                icon: const Icon(Icons.clear),
              ),
      ),
    );
  }
}

class _JalaliPickerSheet extends StatefulWidget {
  const _JalaliPickerSheet({required this.initial});

  final Jalali initial;

  @override
  State<_JalaliPickerSheet> createState() => _JalaliPickerSheetState();
}

class _JalaliPickerSheetState extends State<_JalaliPickerSheet> {
  late int _year;
  late int _month;
  late int _day;

  static const _monthNames = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.initial.year;
    _month = widget.initial.month;
    _day = widget.initial.day;
  }

  int get _daysInMonth {
    try {
      return Jalali(_year, _month, 1).monthLength;
    } catch (_) {
      return 30;
    }
  }

  void _clampDay() {
    final max = _daysInMonth;
    if (_day > max) _day = max;
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(120, (i) => Jalali.now().year - i + 1);
    _clampDay();
    final days = List.generate(_daysInMonth, (i) => i + 1);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: GazSpacing.lg,
          right: GazSpacing.lg,
          bottom: MediaQuery.viewInsetsOf(context).bottom + GazSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'انتخاب تاریخ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GazSpacing.md),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<int>(
                    value: _year,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'سال'),
                    items: [
                      for (final y in years)
                        DropdownMenuItem(value: y, child: Text('$y')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _year = v;
                        _clampDay();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<int>(
                    value: _month,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'ماه'),
                    items: [
                      for (var m = 1; m <= 12; m++)
                        DropdownMenuItem(
                          value: m,
                          child: Text(
                            _monthNames[m - 1],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _month = v;
                        _clampDay();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _day.clamp(1, _daysInMonth),
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'روز'),
                    items: [
                      for (final d in days)
                        DropdownMenuItem(value: d, child: Text('$d')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _day = v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: GazSpacing.lg),
            FilledButton(
              onPressed: () {
                try {
                  Navigator.pop(context, Jalali(_year, _month, _day));
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تاریخ نامعتبر است')),
                  );
                }
              },
              child: const Text('تأیید'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('انصراف'),
            ),
          ],
        ),
      ),
    );
  }
}
