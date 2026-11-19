import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shamsi_date/shamsi_date.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/xlsx_logo_embed.dart';
import '../../entities/employee_entity.dart';

enum ReportPaperSize { a4, letter, a3 }

enum ReportOrientation { portrait, landscape, auto }

enum ReportWatermarkMode { none, logo, text }

class ReportColumn {
  const ReportColumn({
    required this.key,
    required this.titleFa,
    required this.group,
  });
  final String key;
  final String titleFa;
  final String group;
}

class ReportColumnCatalog {
  static const identity = 'هویت';
  static const org = 'سازمانی';
  static const contact = 'تماس';
  static const social = 'شبکه‌ها';

  static const all = <ReportColumn>[
    ReportColumn(key: 'firstName', titleFa: 'نام', group: identity),
    ReportColumn(key: 'lastName', titleFa: 'نام خانوادگی', group: identity),
    ReportColumn(key: 'fullName', titleFa: 'نام کامل', group: identity),
    ReportColumn(key: 'fatherName', titleFa: 'نام پدر', group: identity),
    ReportColumn(key: 'nationalId', titleFa: 'کد ملی', group: identity),
    ReportColumn(key: 'birthDate', titleFa: 'تاریخ تولد', group: identity),
    ReportColumn(key: 'birthPlace', titleFa: 'محل تولد', group: identity),
    ReportColumn(key: 'gender', titleFa: 'جنسیت', group: identity),
    ReportColumn(key: 'maritalStatus', titleFa: 'تأهل', group: identity),
    ReportColumn(key: 'childrenCount', titleFa: 'تعداد فرزند', group: identity),
    ReportColumn(key: 'bloodGroup', titleFa: 'گروه خون', group: identity),
    ReportColumn(key: 'militaryStatus', titleFa: 'نظام‌وظیفه', group: identity),
    ReportColumn(
      key: 'personalDescription',
      titleFa: 'توضیحات',
      group: identity,
    ),
    ReportColumn(key: 'employeeNumber', titleFa: 'شماره پرسنلی', group: org),
    ReportColumn(key: 'subscriptionNumber', titleFa: 'شماره اشتراک', group: org),
    ReportColumn(key: 'position', titleFa: 'سمت فعلی', group: org),
    ReportColumn(key: 'previousPosition', titleFa: 'سمت قبلی', group: org),
    ReportColumn(key: 'desiredPosition', titleFa: 'سمت موردعلاقه', group: org),
    ReportColumn(key: 'employmentType', titleFa: 'نوع استخدام', group: org),
    ReportColumn(key: 'employmentDate', titleFa: 'تاریخ استخدام', group: org),
    ReportColumn(key: 'status', titleFa: 'وضعیت اشتغال', group: org),
    ReportColumn(key: 'phone', titleFa: 'تلفن اصلی', group: contact),
    ReportColumn(key: 'secondaryPhone', titleFa: 'تلفن دوم', group: contact),
    ReportColumn(key: 'emergencyPhone', titleFa: 'تلفن اضطراری', group: contact),
    ReportColumn(key: 'email', titleFa: 'ایمیل', group: contact),
    ReportColumn(key: 'address', titleFa: 'آدرس', group: contact),
    ReportColumn(key: 'postalCode', titleFa: 'کد پستی', group: contact),
    ReportColumn(key: 'telegram', titleFa: 'تلگرام', group: social),
    ReportColumn(key: 'whatsapp', titleFa: 'واتساپ', group: social),
    ReportColumn(key: 'instagram', titleFa: 'اینستاگرام', group: social),
    ReportColumn(key: 'linkedin', titleFa: 'لینکدین', group: social),
  ];

  static const defaultKeys = {
    'fullName',
    'nationalId',
    'employeeNumber',
    'position',
    'status',
    'phone',
  };

  static const groups = [identity, org, contact, social];
}

class ReportConfig {
  const ReportConfig({
    required this.title,
    required this.columns,
    this.headerText,
    this.footerText,
    this.watermark,
    this.watermarkMode = ReportWatermarkMode.none,
    this.showLogo = true,
    this.showPageNumbers = true,
    this.showGeneratedMeta = true,
    this.generatedBy,
    this.paperSize = ReportPaperSize.a4,
    this.orientation = ReportOrientation.auto,
    this.groupBy,
  });

  final String title;
  final List<ReportColumn> columns;
  final String? headerText;
  final String? footerText;
  final String? watermark;
  final ReportWatermarkMode watermarkMode;
  final bool showLogo;
  final bool showPageNumbers;
  final bool showGeneratedMeta;
  final String? generatedBy;
  final ReportPaperSize paperSize;
  final ReportOrientation orientation;
  final String? groupBy;
}

/// Strip bidi/ZWNJ marks that dart_pdf shapes incorrectly (e.g. قائم‌شهر).
String normalizePersianForPdf(String value) {
  return value
      .replaceAll('\u200C', '')
      .replaceAll('\u200D', '')
      .replaceAll('\u200E', '')
      .replaceAll('\u200F', '')
      .replaceAll('\u2066', '')
      .replaceAll('\u2067', '')
      .replaceAll('\u2068', '')
      .replaceAll('\u2069', '')
      .replaceAll('\u202A', '')
      .replaceAll('\u202B', '')
      .replaceAll('\u202C', '')
      .trim();
}

String _jalaliYmd(Jalali j) {
  final m = j.month.toString().padLeft(2, '0');
  final d = j.day.toString().padLeft(2, '0');
  return '${j.year}/$m/$d';
}

/// Header/footer timestamp as Shamsi `yyyy/MM/dd HH:mm`.
String formatJalaliDateTime(DateTime dt) {
  final j = Jalali.fromDateTime(dt);
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '${_jalaliYmd(j)} $h:$m';
}

/// Employee date cells: keep Jalali, convert Gregorian `yyyy/MM/dd` if needed.
String formatReportDate(String? raw) {
  if (raw == null) return '';
  final t = raw.trim();
  if (t.isEmpty) return '';
  final datePart = t.replaceAll('-', '/').split(RegExp(r'\s+')).first;
  final parts = datePart.split('/');
  if (parts.length != 3) return t;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return t;
  try {
    if (y >= 1600) {
      return _jalaliYmd(Gregorian(y, m, d).toJalali());
    }
    return _jalaliYmd(Jalali(y, m, d));
  } catch (_) {
    return t;
  }
}

double columnFlexWeight(String key) {
  return switch (key) {
    'nationalId' ||
    'employeeNumber' ||
    'gender' ||
    'childrenCount' ||
    'bloodGroup' ||
    'status' ||
    'postalCode' =>
      0.7,
    'birthDate' || 'employmentDate' || 'phone' || 'secondaryPhone' => 0.9,
    'fullName' ||
    'position' ||
    'previousPosition' ||
    'desiredPosition' ||
    'email' =>
      1.4,
    'address' || 'personalDescription' => 1.8,
    _ => 1.0,
  };
}

double cellFontForColumnCount(int colCount) {
  if (colCount <= 6) return 9;
  if (colCount <= 12) return 8;
  if (colCount <= 20) return 6.5;
  return 5.5;
}

String _statusFa(String status) => switch (status) {
      'active' => 'فعال',
      'terminated' => 'خاتمه',
      'leave' => 'مرخصی',
      'mission' => 'مأمور',
      _ => status,
    };

String _genderFa(String? g) => switch (g) {
      'male' => 'مرد',
      'female' => 'زن',
      _ => g ?? '',
    };

String _maritalFa(String? m) => switch (m) {
      'single' => 'مجرد',
      'married' => 'متأهل',
      'divorced' => 'مطلقه',
      'widowed' => 'بیوه',
      _ => m ?? '',
    };

/// Professional PDF / Excel report generator with Persian fonts + logo.
class ReportBuilderService {
  pw.Font? _cachedFont;
  pw.Font? _cachedFontBold;

  Future<pw.Font> _loadFont({bool bold = false}) async {
    if (bold) {
      if (_cachedFontBold != null) return _cachedFontBold!;
      final data = await rootBundle.load('assets/fonts/Vazirmatn-Bold.ttf');
      return _cachedFontBold = pw.Font.ttf(data);
    }
    if (_cachedFont != null) return _cachedFont!;
    final data = await rootBundle.load('assets/fonts/Vazirmatn-Regular.ttf');
    return _cachedFont = pw.Font.ttf(data);
  }

  Future<Uint8List?> _defaultLogo() async {
    try {
      final data = await rootBundle.load(AppConstants.organizationLogoAsset);
      return data.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  pw.Widget _pdfCell(
    String text,
    pw.TextStyle style, {
    bool header = false,
    double padH = 4,
    double padV = 5,
  }) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: pw.EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      color: header ? const PdfColor.fromInt(0xFF0F4C5C) : null,
      child: pw.Text(
        normalizePersianForPdf(text),
        textAlign: pw.TextAlign.center,
        softWrap: false,
        overflow: pw.TextOverflow.clip,
        style: style,
      ),
    );
  }

  Future<Uint8List> buildEmployeeReport({
    required ReportConfig config,
    required List<EmployeeEntity> employees,
    Uint8List? logoBytes,
  }) async {
    final font = await _loadFont();
    final fontBold = await _loadFont(bold: true);
    final logo = logoBytes ?? await _defaultLogo();
    final headerLogo = config.showLogo ? logo : null;
    final theme = pw.ThemeData.withFont(base: font, bold: fontBold);

    // First logical column on the right (RTL). pw.Table column 0 is left.
    final columns = config.columns.reversed.toList();
    final colCount = columns.length;
    final useWidePaper =
        config.orientation == ReportOrientation.auto && colCount > 12;
    final useLandscape = config.orientation == ReportOrientation.landscape ||
        (config.orientation == ReportOrientation.auto && colCount > 4);

    final pageFormat = useWidePaper
        ? PdfPageFormat.a3
        : switch (config.paperSize) {
            ReportPaperSize.a4 => PdfPageFormat.a4,
            ReportPaperSize.letter => PdfPageFormat.letter,
            ReportPaperSize.a3 => PdfPageFormat.a3,
          };
    final format = useLandscape ? pageFormat.landscape : pageFormat;

    final cellFont = cellFontForColumnCount(colCount);
    final headerFont = cellFont + 0.8;
    final nowFa = formatJalaliDateTime(DateTime.now());
    final padH = colCount > 20 ? 1.5 : (colCount > 12 ? 2.0 : 4.0);
    final padV = colCount > 20 ? 3.0 : (colCount > 12 ? 3.5 : 5.0);
    final baseStyle = pw.TextStyle(font: font, fontSize: cellFont);
    final boldStyle = pw.TextStyle(
      font: fontBold,
      fontSize: cellFont,
      fontWeight: pw.FontWeight.bold,
    );
    final headerStyle = pw.TextStyle(
      font: fontBold,
      fontSize: headerFont,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    final doc = pw.Document(theme: theme);

    pw.TableRow headerRow() => pw.TableRow(
          children: [
            for (final c in columns)
              _pdfCell(
                c.titleFa,
                headerStyle,
                header: true,
                padH: padH,
                padV: padV,
              ),
          ],
        );

    final table = pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blueGrey300, width: 0.6),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      columnWidths: {
        for (var i = 0; i < colCount; i++)
          i: pw.FlexColumnWidth(columnFlexWeight(columns[i].key)),
      },
      children: [
        headerRow(),
        for (var i = 0; i < employees.length; i++)
          pw.TableRow(
            decoration: i.isOdd
                ? const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF4F7F8))
                : null,
            children: [
              for (final c in columns)
                _pdfCell(
                  _cell(employees[i], c.key),
                  baseStyle,
                  padH: padH,
                  padV: padV,
                ),
            ],
          ),
      ],
    );

    final pageMargin = colCount > 20
        ? const pw.EdgeInsets.fromLTRB(12, 14, 12, 16)
        : const pw.EdgeInsets.fromLTRB(22, 20, 22, 24);

    pw.Widget watermarkLayer() {
      switch (config.watermarkMode) {
        case ReportWatermarkMode.none:
          return pw.SizedBox();
        case ReportWatermarkMode.logo:
          if (logo == null) return pw.SizedBox();
          return pw.Center(
            child: pw.Opacity(
              opacity: 0.08,
              child: pw.Image(
                pw.MemoryImage(logo),
                width: 280,
                height: 280,
                fit: pw.BoxFit.contain,
              ),
            ),
          );
        case ReportWatermarkMode.text:
          final t = config.watermark?.trim() ?? '';
          if (t.isEmpty) return pw.SizedBox();
          return pw.Center(
            child: pw.Transform.rotate(
              angle: -0.5,
              child: pw.Opacity(
                opacity: 0.12,
                child: pw.Text(
                  normalizePersianForPdf(t),
                  textAlign: pw.TextAlign.center,
                  style: boldStyle.copyWith(
                    fontSize: 42,
                    color: PdfColors.blueGrey400,
                  ),
                ),
              ),
            ),
          );
      }
    }

    final pageTheme = pw.PageTheme(
      pageFormat: format,
      margin: pageMargin,
      theme: theme,
      textDirection: pw.TextDirection.rtl,
      buildBackground: (_) => pw.FullPage(
        ignoreMargins: true,
        child: watermarkLayer(),
      ),
    );

    doc.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            padding: const pw.EdgeInsets.only(bottom: 10),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  color: PdfColor.fromInt(0xFF0F4C5C),
                  width: 1.4,
                ),
              ),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                if (headerLogo != null)
                  pw.Container(
                    width: 46,
                    height: 46,
                    child: pw.Image(
                      pw.MemoryImage(headerLogo),
                      fit: pw.BoxFit.contain,
                    ),
                  )
                else
                  pw.SizedBox(width: 12, height: 46),
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        normalizePersianForPdf(AppConstants.organizationNameFa),
                        textAlign: pw.TextAlign.center,
                        style: boldStyle.copyWith(
                          fontSize: 11,
                          color: const PdfColor.fromInt(0xFF0F4C5C),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        normalizePersianForPdf(config.title),
                        textAlign: pw.TextAlign.center,
                        style: boldStyle.copyWith(fontSize: 15),
                      ),
                      if (config.headerText != null &&
                          config.headerText!.trim().isNotEmpty)
                        pw.Text(
                          normalizePersianForPdf(config.headerText!),
                          textAlign: pw.TextAlign.center,
                          style: baseStyle.copyWith(
                            fontSize: 8,
                            color: PdfColors.blueGrey700,
                          ),
                        ),
                    ],
                  ),
                ),
                pw.SizedBox(
                  width: 88,
                  child: pw.Text(
                    nowFa,
                    textAlign: pw.TextAlign.center,
                    style: baseStyle.copyWith(fontSize: 8),
                  ),
                ),
              ],
            ),
          ),
        ),
        footer: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            children: [
              pw.Divider(color: PdfColors.blueGrey300, thickness: 0.6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      normalizePersianForPdf(
                        config.footerText ?? AppConstants.organizationNameFa,
                      ),
                      textAlign: pw.TextAlign.center,
                      style: baseStyle.copyWith(fontSize: 8),
                    ),
                  ),
                  if (config.showPageNumbers)
                    pw.Text(
                      normalizePersianForPdf(
                        'صفحه ${context.pageNumber} از ${context.pagesCount}',
                      ),
                      style: baseStyle.copyWith(fontSize: 8),
                    ),
                ],
              ),
              if (config.showGeneratedMeta)
                pw.Text(
                  normalizePersianForPdf(
                    'تولید توسط ${config.generatedBy ?? AppConstants.appNameFa} — $nowFa',
                  ),
                  textAlign: pw.TextAlign.center,
                  style: baseStyle.copyWith(fontSize: 7),
                ),
            ],
          ),
        ),
        build: (context) {
          return [
            table,
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                normalizePersianForPdf(
                  'تعداد رکورد: ${employees.length} — ستون‌ها: $colCount'
                  '${useLandscape ? ' — افقی' : ''}',
                ),
                style: baseStyle.copyWith(fontSize: 8),
              ),
            ),
          ];
        },
      ),
    );

    return doc.save();
  }

  Future<Uint8List> buildEmployeeExcel({
    required ReportConfig config,
    required List<EmployeeEntity> employees,
    Uint8List? logoBytes,
  }) async {
    final excel = Excel.createExcel();
    final defaultName = excel.getDefaultSheet() ?? 'Sheet1';
    excel.rename(defaultName, 'گزارش');
    final report = excel['گزارش'];
    report.isRTL = true;

    final columns = config.columns.toList();
    final span = columns.isEmpty ? 1 : columns.length;
    final nowFa = formatJalaliDateTime(DateTime.now());

    final brandStyle = CellStyle(
      fontFamily: 'Vazirmatn',
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#0F4C5C'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );
    final titleStyle = CellStyle(
      fontFamily: 'Vazirmatn',
      bold: true,
      fontSize: 14,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#146C80'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );
    final metaStyle = CellStyle(
      fontFamily: 'Vazirmatn',
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#E8F1F3'),
    );
    final headerStyle = CellStyle(
      fontFamily: 'Vazirmatn',
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#0F4C5C'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );
    final evenStyle = CellStyle(
      fontFamily: 'Vazirmatn',
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      textWrapping: TextWrapping.WrapText,
    );
    final oddStyle = CellStyle(
      fontFamily: 'Vazirmatn',
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      textWrapping: TextWrapping.WrapText,
      backgroundColorHex: ExcelColor.fromHexString('#F4F7F8'),
    );
    final footerStyle = CellStyle(
      fontFamily: 'Vazirmatn',
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#E8F1F3'),
    );

    void mergeRow(int rowIndex, String value, CellStyle style, double height) {
    if (span <= 1) {
      final cell = report.cell(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex),
      );
      cell.value = TextCellValue(normalizePersianForPdf(value));
      cell.cellStyle = style;
    } else {
      report.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex),
        CellIndex.indexByColumnRow(columnIndex: span - 1, rowIndex: rowIndex),
        customValue: TextCellValue(normalizePersianForPdf(value)),
      );
      for (var c = 0; c < span; c++) {
        report
            .cell(
              CellIndex.indexByColumnRow(columnIndex: c, rowIndex: rowIndex),
            )
            .cellStyle = style;
      }
    }
    report.setRowHeight(rowIndex, height);
    }

    var row = 0;
    mergeRow(row, AppConstants.organizationNameFa, brandStyle, 28);
    row++;
    mergeRow(row, config.title, titleStyle, 24);
    row++;
    mergeRow(row, nowFa, metaStyle, 18);
    row++;
    if (config.headerText != null && config.headerText!.trim().isNotEmpty) {
      mergeRow(row, config.headerText!.trim(), metaStyle, 18);
      row++;
    }
    if (config.watermarkMode == ReportWatermarkMode.text &&
        (config.watermark ?? '').trim().isNotEmpty) {
      mergeRow(row, 'واترمارک: ${config.watermark!.trim()}', metaStyle, 16);
      row++;
    }
    row++;

    for (var c = 0; c < columns.length; c++) {
      final cell = report.cell(
        CellIndex.indexByColumnRow(columnIndex: c, rowIndex: row),
      );
      cell.value = TextCellValue(normalizePersianForPdf(columns[c].titleFa));
      cell.cellStyle = headerStyle;
    }
    report.setRowHeight(row, 22);
    final headerRow = row;
    row++;

    for (var i = 0; i < employees.length; i++) {
      final rowStyle = i.isOdd ? oddStyle : evenStyle;
      for (var c = 0; c < columns.length; c++) {
        final cell = report.cell(
          CellIndex.indexByColumnRow(columnIndex: c, rowIndex: row),
        );
        cell.value = TextCellValue(
          normalizePersianForPdf(_cell(employees[i], columns[c].key)),
        );
        cell.cellStyle = rowStyle;
      }
      row++;
    }
    row++;
    mergeRow(
      row,
      'تعداد رکورد: ${employees.length}',
      footerStyle,
      20,
    );

    for (var c = 0; c < columns.length; c++) {
      final key = columns[c].key;
      if (key == 'address' || key == 'personalDescription') {
        report.setColumnWidth(c, 28);
      } else if (key == 'email' || key == 'fullName') {
        report.setColumnWidth(c, 22);
      } else {
        report.setColumnAutoFit(c);
      }
    }
    report.setRowHeight(headerRow, 22);

    final encoded = excel.encode();
    var bytes = Uint8List.fromList(encoded ?? []);
    if (config.showLogo) {
      final logo = logoBytes ?? await _defaultLogo();
      if (logo != null && logo.isNotEmpty) {
        bytes = embedPngLogoInXlsx(bytes, logo);
      }
    }
    return bytes;
  }

  String _cell(EmployeeEntity e, String key) {
    return switch (key) {
      'firstName' => e.firstName,
      'lastName' => e.lastName,
      'fullName' => e.fullName,
      'fatherName' => e.fatherName ?? '',
      'nationalId' => e.nationalId,
      'birthDate' => formatReportDate(e.birthDate),
      'birthPlace' => e.birthPlace ?? '',
      'gender' => _genderFa(e.gender),
      'maritalStatus' => _maritalFa(e.maritalStatus),
      'childrenCount' => '${e.childrenCount}',
      'bloodGroup' => e.bloodGroup ?? '',
      'militaryStatus' => e.militaryStatus ?? '',
      'personalDescription' => e.personalDescription ?? '',
      'employeeNumber' => e.employeeNumber ?? '',
      'subscriptionNumber' => e.subscriptionNumber ?? '',
      'position' => e.currentPosition ?? '',
      'previousPosition' => e.previousPosition ?? '',
      'desiredPosition' => e.desiredPosition ?? '',
      'employmentType' => e.employmentType ?? '',
      'employmentDate' => formatReportDate(e.employmentDate),
      'status' => _statusFa(e.employmentStatus),
      'phone' => e.contact?.primaryPhone ?? '',
      'secondaryPhone' => e.contact?.secondaryPhone ?? '',
      'emergencyPhone' => e.contact?.emergencyPhone ?? '',
      'email' => e.contact?.email ?? '',
      'address' => e.contact?.homeAddress ?? '',
      'postalCode' => e.contact?.postalCode ?? '',
      'telegram' => e.social?.telegram ?? '',
      'whatsapp' => e.social?.whatsapp ?? '',
      'instagram' => e.social?.instagram ?? '',
      'linkedin' => e.social?.linkedin ?? '',
      _ => '',
    };
  }
}
