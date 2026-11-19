import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaz_hrms/data/local/database/app_database.dart';
import 'package:gaz_hrms/data/repositories/employee_group_repository_impl.dart';
import 'package:gaz_hrms/data/repositories/employee_repository_impl.dart';
import 'package:gaz_hrms/domain/entities/employee_entity.dart';
import 'package:gaz_hrms/domain/entities/employee_group_entity.dart';
import 'package:gaz_hrms/domain/repositories/employee_repository.dart';
import 'package:gaz_hrms/domain/usecases/report/report_builder_service.dart';

/// Scale smoke test: 500 employees must insert, list, search, group, and export.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late EmployeeRepositoryImpl employees;
  late EmployeeGroupRepositoryImpl groups;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    employees = EmployeeRepositoryImpl(db);
    groups = EmployeeGroupRepositoryImpl(db, employees);
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'handles 500 employees: insert, count, search, group, report',
    () async {
      const total = 500;
      final sw = Stopwatch()..start();

      for (var i = 0; i < total; i++) {
        final n = (i + 1).toString().padLeft(3, '0');
        final nationalId = (1000000000 + i).toString();
        final result = await employees.create(
          EmployeeEntity(
            id: '',
            firstName: 'کارمند$n',
            lastName: 'تست$n',
            nationalId: nationalId,
            employeeNumber: 'E$n',
            currentPosition: i.isEven ? 'مهندس گاز' : 'اپراتور',
            employmentStatus: 'active',
            contact: ContactInfo(
              primaryPhone: '0912${(1000000 + i).toString().substring(1)}',
              email: 'user$i@gaz.local',
            ),
          ),
        );
        expect(result.isSuccess, isTrue, reason: 'create failed at $i');
      }

      final insertMs = sw.elapsedMilliseconds;
      // Soft budget for CI/dev machines (Android uses same Drift path).
      expect(insertMs, lessThan(180000), reason: 'insert took ${insertMs}ms');

      final count = await employees.count(const EmployeeQuery(limit: 0));
      expect(count.valueOrNull, total);

      final all = await employees.search(const EmployeeQuery(limit: 2000));
      expect(all.isSuccess, isTrue);
      expect(all.valueOrNull!.length, total);

      final andSearch = await employees.search(
        const EmployeeQuery(andTerms: ['مهندس', 'گاز'], limit: 2000),
      );
      expect(andSearch.isSuccess, isTrue);
      expect(andSearch.valueOrNull!.length, 250);

      final orSearch = await employees.search(
        const EmployeeQuery(
          orTerms: ['مهندس', 'اپراتور'],
          limit: 2000,
        ),
      );
      expect(orSearch.valueOrNull!.length, total);

      final notSearch = await employees.search(
        const EmployeeQuery(
          andTerms: ['تست'],
          notTerms: ['اپراتور'],
          limit: 2000,
        ),
      );
      expect(notSearch.valueOrNull!.length, 250);

      final memberIds =
          all.valueOrNull!.take(80).map((e) => e.id).toList(growable: false);
      final groupResult = await groups.create(
        name: 'گروه مقیاس ۵۰۰',
        purposeType: GroupPurposeType.training,
        createdBy: 'tester',
        memberIds: memberIds,
      );
      expect(groupResult.isSuccess, isTrue);
      expect(groupResult.valueOrNull!.memberCount, 80);

      final reportEmployees = groupResult.valueOrNull!.members;
      final report = await ReportBuilderService().buildEmployeeReport(
        config: ReportConfig(
          title: 'گزارش مقیاس',
          columns: ReportColumnCatalog.all
              .where((c) => ReportColumnCatalog.defaultKeys.contains(c.key))
              .toList(),
        ),
        employees: reportEmployees,
      );
      expect(report.length, greaterThan(1000));

      final excel = await ReportBuilderService().buildEmployeeExcel(
        config: ReportConfig(
          title: 'گزارش مقیاس',
          columns: ReportColumnCatalog.all
              .where((c) => ReportColumnCatalog.defaultKeys.contains(c.key))
              .toList(),
        ),
        employees: all.valueOrNull!,
      );
      expect(excel.length, greaterThan(1000));

      // ignore: avoid_print
      print(
        'SCALE_OK insert=${insertMs}ms total=$total '
        'searchAnd=${andSearch.valueOrNull!.length} '
        'group=${groupResult.valueOrNull!.memberCount} '
        'pdfBytes=${report.length} xlsxBytes=${excel.length}',
      );
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
