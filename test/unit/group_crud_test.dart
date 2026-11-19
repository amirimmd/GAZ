import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaz_hrms/data/local/database/app_database.dart';
import 'package:gaz_hrms/data/repositories/employee_group_repository_impl.dart';
import 'package:gaz_hrms/data/repositories/employee_repository_impl.dart';
import 'package:gaz_hrms/domain/entities/employee_entity.dart';
import 'package:gaz_hrms/domain/entities/employee_group_entity.dart';

void main() {
  late AppDatabase db;
  late EmployeeRepositoryImpl employees;
  late EmployeeGroupRepositoryImpl groups;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    employees = EmployeeRepositoryImpl(db);
    groups = EmployeeGroupRepositoryImpl(db, employees);
  });

  tearDown(() async {
    await db.close();
  });

  test('create group then list shows it', () async {
    final emp = await employees.create(
      const EmployeeEntity(
        id: '',
        firstName: 'رضا',
        lastName: 'احمدی',
        nationalId: '1111111111',
      ),
    );
    expect(emp.isSuccess, isTrue);

    final created = await groups.create(
      name: 'کمیته ایمنی',
      purposeType: GroupPurposeType.committee,
      createdBy: 'tester',
      memberIds: [emp.valueOrNull!.id],
    );
    expect(created.isSuccess, isTrue);
    expect(created.valueOrNull!.memberCount, 1);

    final list = await groups.list(const GroupQuery(status: GroupStatus.active));
    expect(list.isSuccess, isTrue);
    expect(list.valueOrNull!.length, 1);
    expect(list.valueOrNull!.first.name, 'کمیته ایمنی');

    final emptyArchived =
        await groups.list(const GroupQuery(status: GroupStatus.archived));
    expect(emptyArchived.valueOrNull, isEmpty);

    await groups.setStatus(created.valueOrNull!.id, GroupStatus.archived);
    final archived =
        await groups.list(const GroupQuery(status: GroupStatus.archived));
    expect(archived.valueOrNull!.length, 1);
  });

  test('GroupQuery equality is stable', () {
    const a = GroupQuery(status: GroupStatus.active, searchText: 'x');
    const b = GroupQuery(status: GroupStatus.active, searchText: 'x');
    const c = GroupQuery(status: GroupStatus.archived, searchText: 'x');
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a == c, isFalse);
  });
}
