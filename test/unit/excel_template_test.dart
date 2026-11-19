import 'package:flutter_test/flutter_test.dart';
import 'package:gaz_hrms/domain/usecases/employee/bulk_import_service.dart';

void main() {
  test('excel template has Persian headers and skips hint row', () {
    final svc = BulkImportService();
    final bytes = svc.exportExcelTemplate();
    expect(bytes.length, greaterThan(500));
    expect(bytes[0], 0x50); // PK zip

    final parsed = svc.parseExcel(bytes);
    expect(parsed.isSuccess, isTrue);
    final rows = parsed.valueOrNull!;
    expect(rows, isNotEmpty);
    expect(rows.every((r) => r.employee?.firstName != 'الزامی'), isTrue);
    expect(rows.first.employee?.firstName, 'علی');
    expect(rows.first.employee?.employmentStatus, 'active');
    expect(rows.first.employee?.gender, 'male');
  });
}
