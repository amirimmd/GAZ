import 'package:flutter_test/flutter_test.dart';
import 'package:gaz_hrms/core/constants/app_constants.dart';
import 'package:gaz_hrms/domain/entities/employee_entity.dart';
import 'package:gaz_hrms/domain/usecases/report/report_builder_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('normalizePersianForPdf removes ZWNJ from قائم‌شهر', () {
    const raw = 'قائم‌شهر';
    expect(raw.contains('\u200C'), isTrue);
    final clean = normalizePersianForPdf(raw);
    expect(clean.contains('\u200C'), isFalse);
    expect(clean, 'قائمشهر');
    expect(normalizePersianForPdf(AppConstants.appNameFa).contains('\u200C'), isFalse);
  });

  test('normalizePersianForPdf strips LRM and isolates', () {
    expect(normalizePersianForPdf('\u200E1234567890\u200E'), '1234567890');
    expect(normalizePersianForPdf('\u2066abc\u2069'), 'abc');
  });

  test('default headers are complete and not ellipsized', () {
    for (final c in ReportColumnCatalog.all
        .where((c) => ReportColumnCatalog.defaultKeys.contains(c.key))) {
      expect(c.titleFa.contains('…'), isFalse);
      expect(c.titleFa.trim().isNotEmpty, isTrue);
    }
  });

  test('all catalog headers are complete and not ellipsized', () {
    expect(ReportColumnCatalog.all.length, 31);
    for (final c in ReportColumnCatalog.all) {
      expect(c.titleFa.contains('…'), isFalse);
      expect(c.titleFa.trim().isNotEmpty, isTrue);
    }
  });

  test('formatJalaliDateTime uses Shamsi year', () {
    final stamp = formatJalaliDateTime(DateTime(2026, 8, 30, 22, 11));
    expect(stamp.startsWith('1405/'), isTrue);
    expect(stamp.endsWith('22:11'), isTrue);
    expect(stamp.contains('2026'), isFalse);
  });

  test('formatReportDate keeps Jalali and converts Gregorian', () {
    expect(formatReportDate('1402/01/15'), '1402/01/15');
    expect(formatReportDate('2024/03/20'), '1403/01/01');
    expect(formatReportDate(''), '');
    expect(formatReportDate(null), '');
  });

  test('dense layout scales font and weights for all columns', () {
    expect(cellFontForColumnCount(6), 9);
    expect(cellFontForColumnCount(12), 8);
    expect(cellFontForColumnCount(20), 6.5);
    expect(cellFontForColumnCount(31), 5.5);
    expect(columnFlexWeight('address'), greaterThan(columnFlexWeight('gender')));
  });

  test('builds centered PDF without throwing', () async {
    final employees = [
      EmployeeEntity(
        id: '1',
        firstName: 'علی',
        lastName: 'محمدی',
        nationalId: '0012345678',
        employeeNumber: 'E001',
        currentPosition: 'مهندس گاز',
        employmentStatus: 'active',
        contact: const ContactInfo(primaryPhone: '09121234567'),
      ),
    ];
    final bytes = await ReportBuilderService().buildEmployeeReport(
      config: ReportConfig(
        title: 'گزارش کارکنان ${AppConstants.appNameFa}',
        columns: ReportColumnCatalog.all
            .where((c) => ReportColumnCatalog.defaultKeys.contains(c.key))
            .toList(),
        headerText: AppConstants.organizationNameFa,
        generatedBy: AppConstants.appNameFa,
      ),
      employees: employees,
    );
    expect(bytes.length, greaterThan(2000));
    expect(bytes[0], 0x25); // %PDF
    expect(bytes[1], 0x50);

    final xlsx = await ReportBuilderService().buildEmployeeExcel(
      config: ReportConfig(
        title: 'گزارش کارکنان',
        columns: ReportColumnCatalog.all
            .where((c) => ReportColumnCatalog.defaultKeys.contains(c.key))
            .toList(),
      ),
      employees: employees,
    );
    expect(xlsx.length, greaterThan(500));
  });

  test('builds all-column PDF and Excel without throwing', () async {
    final employees = [
      EmployeeEntity(
        id: '1',
        firstName: 'علی',
        lastName: 'محمدی',
        nationalId: '0012345678',
        employeeNumber: 'E001',
        currentPosition: 'مهندس گاز',
        employmentStatus: 'active',
        birthDate: '2024/03/20',
        employmentDate: '1400/06/01',
        birthPlace: 'قائم‌شهر',
        contact: const ContactInfo(
          primaryPhone: '09121234567',
          homeAddress: 'قائم‌شهر خیابان امام',
          email: 'ali@example.com',
        ),
        personalDescription: 'توضیحات کامل بدون قطع شدن متن',
      ),
    ];
    final bytes = await ReportBuilderService().buildEmployeeReport(
      config: ReportConfig(
        title: 'گزارش کامل کارکنان',
        columns: ReportColumnCatalog.all,
        headerText: AppConstants.organizationNameFa,
        generatedBy: AppConstants.appNameFa,
      ),
      employees: employees,
    );
    expect(bytes.length, greaterThan(2000));
    expect(bytes[0], 0x25);
    expect(bytes[1], 0x50);

    final xlsx = await ReportBuilderService().buildEmployeeExcel(
      config: const ReportConfig(
        title: 'گزارش کامل',
        columns: ReportColumnCatalog.all,
      ),
      employees: employees,
    );
    expect(xlsx.length, greaterThan(500));
  });

  test('showLogo false still builds PDF', () async {
    final bytes = await ReportBuilderService().buildEmployeeReport(
      config: ReportConfig(
        title: 'بدون لوگو',
        columns: ReportColumnCatalog.all
            .where((c) => ReportColumnCatalog.defaultKeys.contains(c.key))
            .toList(),
        showLogo: false,
        watermarkMode: ReportWatermarkMode.text,
        watermark: 'محرمانه',
      ),
      employees: const [
        EmployeeEntity(
          id: '1',
          firstName: 'علی',
          lastName: 'محمدی',
          nationalId: '0012345678',
        ),
      ],
    );
    expect(bytes[0], 0x25);
    expect(bytes.length, greaterThan(1500));
  });
}
