import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/employee_group_entity.dart';
import '../../domain/repositories/employee_group_repository.dart';
import '../../domain/repositories/employee_repository.dart';
import '../local/database/app_database.dart';

class EmployeeGroupRepositoryImpl implements EmployeeGroupRepository {
  EmployeeGroupRepositoryImpl(this._db, this._employees);

  final AppDatabase _db;
  final EmployeeRepository _employees;
  static const _uuid = Uuid();

  @override
  Future<Result<List<EmployeeGroupEntity>>> list(GroupQuery query) async {
    try {
      final q = _db.select(_db.employeeGroups)
        ..where((g) => g.deletedAt.isNull())
        ..orderBy([(g) => OrderingTerm.desc(g.updatedAt)]);

      if (query.status != null) {
        q.where((g) => g.status.equals(query.status!.code));
      }
      if (query.purposeType != null) {
        q.where((g) => g.purposeType.equals(query.purposeType!.code));
      }
      if (query.searchText != null && query.searchText!.trim().isNotEmpty) {
        final t = '%${query.searchText!.trim()}%';
        q.where((g) => g.name.like(t) | g.description.like(t));
      }

      final rows = await q.get();
      final list = <EmployeeGroupEntity>[];
      for (final row in rows) {
        final count = await _memberCount(row.id);
        list.add(_map(row, memberCount: count));
      }
      return Success(list);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<EmployeeGroupEntity>> getById(
    String id, {
    bool withMembers = true,
  }) async {
    try {
      final row = await (_db.select(_db.employeeGroups)
            ..where((g) => g.id.equals(id) & g.deletedAt.isNull()))
          .getSingleOrNull();
      if (row == null) {
        return const Err(NotFoundFailure('گروه یافت نشد'));
      }
      final members = withMembers
          ? (await listMembers(id)).fold((f) => <EmployeeEntity>[], (m) => m)
          : const <EmployeeEntity>[];
      return Success(
        _map(row, memberCount: members.length, members: members),
      );
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<EmployeeGroupEntity>> create({
    required String name,
    required GroupPurposeType purposeType,
    String? description,
    DateTime? startsAt,
    DateTime? endsAt,
    GroupStatus status = GroupStatus.active,
    required String createdBy,
    List<String> memberIds = const [],
  }) async {
    try {
      if (name.trim().isEmpty) {
        return const Err(ValidationFailure('نام گروه الزامی است'));
      }
      final id = _uuid.v4();
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      await _db.into(_db.employeeGroups).insert(
            EmployeeGroupsCompanion.insert(
              id: id,
              name: name.trim(),
              description: Value(description?.trim()),
              purposeType: purposeType.code,
              startsAt: Value(startsAt?.toUtc().millisecondsSinceEpoch),
              endsAt: Value(endsAt?.toUtc().millisecondsSinceEpoch),
              status: Value(status.code),
              createdBy: Value(createdBy),
              createdAt: now,
              updatedAt: now,
            ),
          );
      if (memberIds.isNotEmpty) {
        await addMembers(id, memberIds, addedBy: createdBy);
      }
      return getById(id);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<EmployeeGroupEntity>> update(EmployeeGroupEntity group) async {
    try {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      final n = await (_db.update(_db.employeeGroups)
            ..where((g) => g.id.equals(group.id) & g.deletedAt.isNull()))
          .write(
        EmployeeGroupsCompanion(
          name: Value(group.name.trim()),
          description: Value(group.description),
          purposeType: Value(group.purposeType.code),
          startsAt: Value(group.startsAt?.toUtc().millisecondsSinceEpoch),
          endsAt: Value(group.endsAt?.toUtc().millisecondsSinceEpoch),
          status: Value(group.status.code),
          photoPath: Value(group.photoPath),
          updatedAt: Value(now),
        ),
      );
      if (n == 0) return const Err(NotFoundFailure('گروه یافت نشد'));
      return getById(group.id);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<void>> softDelete(String id) async {
    try {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      await (_db.update(_db.employeeGroups)..where((g) => g.id.equals(id)))
          .write(
        EmployeeGroupsCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      return const Success(null);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<void>> setStatus(String id, GroupStatus status) async {
    try {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      await (_db.update(_db.employeeGroups)
            ..where((g) => g.id.equals(id) & g.deletedAt.isNull()))
          .write(
        EmployeeGroupsCompanion(
          status: Value(status.code),
          updatedAt: Value(now),
        ),
      );
      return const Success(null);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<void>> addMembers(
    String groupId,
    List<String> employeeIds, {
    String? addedBy,
  }) async {
    try {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      final existing = await (_db.select(_db.employeeGroupMembers)
            ..where((m) => m.groupId.equals(groupId)))
          .get();
      final have = existing.map((e) => e.employeeId).toSet();
      for (final eid in employeeIds.toSet()) {
        if (have.contains(eid)) continue;
        await _db.into(_db.employeeGroupMembers).insert(
              EmployeeGroupMembersCompanion.insert(
                id: _uuid.v4(),
                groupId: groupId,
                employeeId: eid,
                addedAt: now,
                addedBy: Value(addedBy),
              ),
            );
      }
      await (_db.update(_db.employeeGroups)
            ..where((g) => g.id.equals(groupId)))
          .write(EmployeeGroupsCompanion(updatedAt: Value(now)));
      return const Success(null);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<void>> removeMember(String groupId, String employeeId) async {
    try {
      await (_db.delete(_db.employeeGroupMembers)
            ..where(
              (m) =>
                  m.groupId.equals(groupId) & m.employeeId.equals(employeeId),
            ))
          .go();
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      await (_db.update(_db.employeeGroups)
            ..where((g) => g.id.equals(groupId)))
          .write(EmployeeGroupsCompanion(updatedAt: Value(now)));
      return const Success(null);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<List<EmployeeEntity>>> listMembers(String groupId) async {
    try {
      final rows = await (_db.select(_db.employeeGroupMembers)
            ..where((m) => m.groupId.equals(groupId))
            ..orderBy([(m) => OrderingTerm.asc(m.addedAt)]))
          .get();
      final list = <EmployeeEntity>[];
      for (final row in rows) {
        final r = await _employees.getById(row.employeeId);
        r.fold((_) {}, list.add);
      }
      return Success(list);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  Future<int> _memberCount(String groupId) async {
    final rows = await (_db.select(_db.employeeGroupMembers)
          ..where((m) => m.groupId.equals(groupId)))
        .get();
    return rows.length;
  }

  EmployeeGroupEntity _map(
    EmployeeGroup row, {
    int memberCount = 0,
    List<EmployeeEntity> members = const [],
  }) {
    return EmployeeGroupEntity(
      id: row.id,
      name: row.name,
      description: row.description,
      purposeType: GroupPurposeTypeX.fromCode(row.purposeType),
      startsAt: row.startsAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.startsAt!, isUtc: true),
      endsAt: row.endsAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.endsAt!, isUtc: true),
      status: GroupStatusX.fromCode(row.status),
      createdBy: row.createdBy,
      photoPath: row.photoPath,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(row.createdAt, isUtc: true),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(row.updatedAt, isUtc: true),
      memberCount: memberCount,
      members: members,
    );
  }
}
