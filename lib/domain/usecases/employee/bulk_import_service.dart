import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/iranian_national_id.dart';
import '../../entities/employee_entity.dart';

class ImportRowResult {
  const ImportRowResult({
    required this.rowIndex,
    required this.employee,
    this.errors = const [],
    this.selected = true,
  });

  final int rowIndex;
  final EmployeeEntity? employee;
  final List<String> errors;
  final bool selected;

  bool get isValid => employee != null && errors.isEmpty;

  ImportRowResult copyWith({
    EmployeeEntity? employee,
    List<String>? errors,
    bool? selected,
  }) {
    return ImportRowResult(
      rowIndex: rowIndex,
      employee: employee ?? this.employee,
      errors: errors ?? this.errors,
      selected: selected ?? this.selected,
    );
  }
}

class BulkImportService {
  static const templateHeadersFa = [
    'نام',
    'نام خانوادگی',
    'نام پدر',
    'کد ملی',
    'تاریخ تولد',
    'محل تولد',
    'جنسیت',
    'وضعیت تأهل',
    'تعداد فرزندان',
    'گروه خونی',
    'وضعیت نظام وظیفه',
    'شماره پرسنلی',
    'شماره اشتراک',
    'سمت فعلی',
    'سمت قبلی',
    'سمت مورد علاقه',
    'نوع استخدام',
    'تاریخ استخدام',
    'وضعیت اشتغال',
    'تلفن اصلی',
    'تلفن دوم',
    'تلفن اضطراری',
    'ایمیل',
    'آدرس',
    'کد پستی',
    'تلگرام',
    'واتساپ',
    'اینستاگرام',
    'لینکدین',
    'توضیحات',
  ];

  static const headerMap = {
    'نام': 'firstName',
    'first_name': 'firstName',
    'نام خانوادگی': 'lastName',
    'last_name': 'lastName',
    'نام پدر': 'fatherName',
    'father_name': 'fatherName',
    'کد ملی': 'nationalId',
    'national_id': 'nationalId',
    'تاریخ تولد': 'birthDate',
    'birth_date': 'birthDate',
    'محل تولد': 'birthPlace',
    'birth_place': 'birthPlace',
    'جنسیت': 'gender',
    'gender': 'gender',
    'وضعیت تأهل': 'maritalStatus',
    'marital_status': 'maritalStatus',
    'تعداد فرزندان': 'childrenCount',
    'children_count': 'childrenCount',
    'گروه خونی': 'bloodGroup',
    'blood_group': 'bloodGroup',
    'وضعیت نظام وظیفه': 'militaryStatus',
    'military_status': 'militaryStatus',
    'شماره پرسنلی': 'employeeNumber',
    'employee_number': 'employeeNumber',
    'شماره اشتراک': 'subscriptionNumber',
    'subscription_number': 'subscriptionNumber',
    'سمت فعلی': 'currentPosition',
    'سمت': 'currentPosition',
    'position': 'currentPosition',
    'سمت قبلی': 'previousPosition',
    'سمت مورد علاقه': 'desiredPosition',
    'نوع استخدام': 'employmentType',
    'تاریخ استخدام': 'employmentDate',
    'وضعیت اشتغال': 'employmentStatus',
    'تلفن اصلی': 'primaryPhone',
    'تلفن': 'primaryPhone',
    'phone': 'primaryPhone',
    'تلفن دوم': 'secondaryPhone',
    'تلفن اضطراری': 'emergencyPhone',
    'ایمیل': 'email',
    'email': 'email',
    'آدرس': 'homeAddress',
    'address': 'homeAddress',
    'کد پستی': 'postalCode',
    'تلگرام': 'telegram',
    'واتساپ': 'whatsapp',
    'اینستاگرام': 'instagram',
    'لینکدین': 'linkedin',
    'توضیحات': 'personalDescription',
  };

  Result<List<ImportRowResult>> parseCsv(String content) {
    try {
      final rows = const CsvToListConverter().convert(content);
      if (rows.isEmpty) {
        return const Err(ValidationFailure('فایل خالی است'));
      }
      return Success(_parseRows(rows));
    } catch (e) {
      return Err(ValidationFailure('CSV نامعتبر: $e'));
    }
  }

  Result<List<ImportRowResult>> parseExcel(List<int> bytes) {
    try {
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables.values.first;
      final rows = sheet.rows
          .map((r) => r.map((c) => c?.value?.toString() ?? '').toList())
          .toList();
      if (rows.isEmpty) {
        return const Err(ValidationFailure('فایل اکسل خالی است'));
      }
      return Success(_parseRows(rows));
    } catch (e) {
      return Err(ValidationFailure('Excel نامعتبر: $e'));
    }
  }

  Set<String> findDuplicateNationalIds(List<ImportRowResult> rows) {
    final seen = <String>{};
    final dups = <String>{};
    for (final r in rows) {
      final id = r.employee?.nationalId;
      if (id == null || id.isEmpty) continue;
      if (!seen.add(id)) dups.add(id);
    }
    return dups;
  }

  List<ImportRowResult> _parseRows(List<List<dynamic>> rows) {
    final headers = rows.first
        .map((e) => e.toString().trim())
        .map((h) => headerMap[h] ?? h)
        .toList();
    final out = <ImportRowResult>[];

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.every((c) => c.toString().trim().isEmpty)) continue;

      final map = <String, String>{};
      for (var c = 0; c < headers.length && c < row.length; c++) {
        map[headers[c]] = row[c].toString().trim();
      }
      if (map['firstName'] == 'الزامی') continue;
      out.add(_fromMap(i + 1, map));
    }
    return out;
  }

  ImportRowResult fromManualMap(int rowIndex, Map<String, String> map) =>
      _fromMap(rowIndex, map);

  ImportRowResult _fromMap(int rowIndex, Map<String, String> map) {
    final errors = <String>[];
    final firstName = map['firstName'] ?? '';
    final lastName = map['lastName'] ?? '';
    final nationalId = map['nationalId'] ?? '';

    if (firstName.isEmpty) errors.add('نام خالی');
    if (lastName.isEmpty) errors.add('نام خانوادگی خالی');
    if (nationalId.isEmpty) {
      errors.add('کد ملی خالی');
    } else if (!IranianNationalId.isValid(nationalId)) {
      errors.add('کد ملی نامعتبر');
    }

    final children = int.tryParse(map['childrenCount'] ?? '') ?? 0;
    final gender = _normalizeGender(map['gender']);
    final status = _normalizeStatus(map['employmentStatus']);

    return ImportRowResult(
      rowIndex: rowIndex,
      errors: errors,
      employee: EmployeeEntity(
        id: '',
        firstName: firstName,
        lastName: lastName,
        fatherName: _nullIfEmpty(map['fatherName']),
        nationalId: nationalId,
        birthDate: _nullIfEmpty(map['birthDate']),
        birthPlace: _nullIfEmpty(map['birthPlace']),
        gender: gender,
        maritalStatus: _nullIfEmpty(map['maritalStatus']),
        childrenCount: children,
        bloodGroup: _nullIfEmpty(map['bloodGroup']),
        militaryStatus: _nullIfEmpty(map['militaryStatus']),
        personalDescription: _nullIfEmpty(map['personalDescription']),
        employeeNumber: _nullIfEmpty(map['employeeNumber']),
        subscriptionNumber: _nullIfEmpty(map['subscriptionNumber']),
        currentPosition: _nullIfEmpty(map['currentPosition']),
        previousPosition: _nullIfEmpty(map['previousPosition']),
        desiredPosition: _nullIfEmpty(map['desiredPosition']),
        employmentType: _nullIfEmpty(map['employmentType']),
        employmentDate: _nullIfEmpty(map['employmentDate']),
        employmentStatus: status,
        contact: ContactInfo(
          primaryPhone: _nullIfEmpty(map['primaryPhone']),
          secondaryPhone: _nullIfEmpty(map['secondaryPhone']),
          emergencyPhone: _nullIfEmpty(map['emergencyPhone']),
          email: _nullIfEmpty(map['email']),
          homeAddress: _nullIfEmpty(map['homeAddress']),
          postalCode: _nullIfEmpty(map['postalCode']),
        ),
        social: SocialInfo(
          telegram: _nullIfEmpty(map['telegram']),
          whatsapp: _nullIfEmpty(map['whatsapp']),
          instagram: _nullIfEmpty(map['instagram']),
          linkedin: _nullIfEmpty(map['linkedin']),
        ),
      ),
    );
  }

  String? _nullIfEmpty(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return v.trim();
  }

  String? _normalizeGender(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final v = raw.trim();
    if (v == 'مرد' || v.toLowerCase() == 'male' || v == 'm') return 'male';
    if (v == 'زن' || v.toLowerCase() == 'female' || v == 'f') return 'female';
    return v;
  }

  String exportCsvTemplate() {
    return withBom(const ListToCsvConverter().convert([templateHeadersFa]));
  }

  String _normalizeStatus(String? raw) {
    if (raw == null || raw.trim().isEmpty) return 'active';
    final v = raw.trim();
    return switch (v) {
      'فعال' || 'active' => 'active',
      'خاتمه' || 'terminated' => 'terminated',
      'مرخصی' || 'leave' => 'leave',
      'مأمور' || 'مامور' || 'mission' => 'mission',
      _ => v,
    };
  }

  Uint8List exportExcelTemplate() {
    final excel = Excel.createExcel();
    final sheet = excel['کارکنان'];
    excel.delete('Sheet1');
    sheet.isRTL = true;

    final hintStyle = CellStyle(
      fontFamily: 'Vazirmatn',
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#FFF8E1'),
    );
    final headerStyle = CellStyle(
      fontFamily: 'Vazirmatn',
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#0F4C5C'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );
    final sampleStyle = CellStyle(
      fontFamily: 'Vazirmatn',
      horizontalAlign: HorizontalAlign.Center,
      textWrapping: TextWrapping.WrapText,
    );

    const hints = <String>[
      'الزامی',
      'الزامی',
      'اختیاری',
      '۱۰ رقم معتبر',
      '1370/01/15 شمسی',
      'مثال: قائمشهر',
      'مرد یا زن',
      'مجرد / متأهل',
      'عدد',
      'A+',
      'پایان خدمت',
      'اختیاری',
      'اختیاری',
      'سمت فعلی',
      'اختیاری',
      'اختیاری',
      'رسمی / قراردادی',
      '1400/06/01 شمسی',
      'فعال / خاتمه / مرخصی / مأمور',
      '09xxxxxxxxx',
      'اختیاری',
      'اختیاری',
      'اختیاری',
      'اختیاری',
      '۱۰ رقم',
      'اختیاری',
      'اختیاری',
      'اختیاری',
      'اختیاری',
      'اختیاری',
    ];

    const sample = <String>[
      'علی',
      'رضایی',
      'محمد',
      '0013542419',
      '1370/01/15',
      'قائمشهر',
      'مرد',
      'متأهل',
      '2',
      'A+',
      'پایان خدمت',
      'E-1024',
      'S-88',
      'کارشناس شبکه',
      'تکنسین',
      'سرپرست شیفت',
      'رسمی',
      '1400/06/01',
      'فعال',
      '09121234567',
      '01133334444',
      '09120000000',
      'ali@example.com',
      'قائمشهر، خیابان امام',
      '4760000000',
      '@ali',
      '09121234567',
      'ali.rezaei',
      '',
      'نمونه ردیف — قبل از ورود واقعی حذف شود',
    ];

    for (var c = 0; c < templateHeadersFa.length; c++) {
      final header = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0),
      );
      header.value = TextCellValue(templateHeadersFa[c]);
      header.cellStyle = headerStyle;

      final hint = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 1),
      );
      hint.value = TextCellValue(hints[c]);
      hint.cellStyle = hintStyle;

      final sampleCell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 2),
      );
      sampleCell.value = TextCellValue(sample[c]);
      sampleCell.cellStyle = sampleStyle;
      sheet.setColumnWidth(c, 18);
    }
    sheet.setRowHeight(0, 22);
    sheet.setRowHeight(1, 20);

    final bytes = excel.encode();
    return Uint8List.fromList(bytes ?? []);
  }
}

String withBom(String csv) => '\uFEFF$csv';

String decodeBytes(List<int> bytes) {
  if (bytes.length >= 3 &&
      bytes[0] == 0xEF &&
      bytes[1] == 0xBB &&
      bytes[2] == 0xBF) {
    return utf8.decode(bytes.sublist(3));
  }
  return utf8.decode(bytes);
}
