import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../local/database/app_database.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  EmployeeRepositoryImpl(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  @override
  Future<Result<EmployeeEntity>> getById(String id) async {
    try {
      final row = await (_db.select(_db.employees)
            ..where((e) => e.id.equals(id) & e.deletedAt.isNull()))
          .getSingleOrNull();
      if (row == null) return const Err(NotFoundFailure('کارمند یافت نشد'));
      return Success(await _hydrate(row));
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<List<EmployeeEntity>>> search(EmployeeQuery query) async {
    try {
      final hasBoolean = query.andTerms.isNotEmpty ||
          query.orTerms.isNotEmpty ||
          query.notTerms.isNotEmpty;

      final q = _db.select(_db.employees)
        ..where((e) => e.deletedAt.isNull());

      if (query.employmentStatus != null) {
        q.where((e) => e.employmentStatus.equals(query.employmentStatus!));
      }
      if (query.departmentId != null) {
        q.where((e) => e.departmentId.equals(query.departmentId!));
      }

      // Positive terms: pull candidates via LIKE before boolean filter.
      // When boolean filters are used, skip early LIKE so phone/email matches
      // (loaded via hydrate) are not lost.
      final positive = <String>{
        if (query.searchText != null && query.searchText!.trim().isNotEmpty)
          query.searchText!.trim(),
        if (!hasBoolean) ...query.andTerms,
        if (!hasBoolean) ...query.orTerms,
      }.where((t) => t.isNotEmpty).toList();

      if (positive.isNotEmpty) {
        q.where((e) {
          Expression<bool>? expr;
          for (final raw in positive) {
            final t = '%$raw%';
            final clause = e.firstName.like(t) |
                e.lastName.like(t) |
                e.nationalId.like(t) |
                e.employeeNumber.like(t) |
                e.currentPosition.like(t);
            expr = expr == null ? clause : (expr | clause);
          }
          return expr!;
        });
      }

      // Apply limit only when no boolean filters (simple list/searchText).
      if (!hasBoolean) {
        q.limit(query.limit, offset: query.offset);
      }

      q.orderBy([(e) => OrderingTerm.asc(e.lastName)]);

      final rows = await q.get();
      var list = <EmployeeEntity>[];
      for (final row in rows) {
        list.add(await _hydrate(row));
      }
      if (hasBoolean) {
        list = _applyBooleanFilters(list, query);
        final start = query.offset.clamp(0, list.length);
        final end = (start + query.limit).clamp(0, list.length);
        list = list.sublist(start, end);
      }
      return Success(list);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  List<EmployeeEntity> _applyBooleanFilters(
    List<EmployeeEntity> source,
    EmployeeQuery query,
  ) {
    Iterable<EmployeeEntity> result = source;

    for (final term in query.andTerms) {
      final t = term.toLowerCase();
      result = result.where((e) => _matchesTerm(e, t));
    }
    if (query.orTerms.isNotEmpty) {
      result = result.where(
        (e) => query.orTerms.any((t) => _matchesTerm(e, t.toLowerCase())),
      );
    }
    for (final term in query.notTerms) {
      final t = term.toLowerCase();
      result = result.where((e) => !_matchesTerm(e, t));
    }
    return result.toList();
  }

  bool _matchesTerm(EmployeeEntity e, String t) {
    final hay = [
      e.fullName,
      e.nationalId,
      e.employeeNumber ?? '',
      e.currentPosition ?? '',
      e.contact?.primaryPhone ?? '',
      e.contact?.email ?? '',
    ].join(' ').toLowerCase();
    return hay.contains(t);
  }

  @override
  Future<Result<int>> count(EmployeeQuery query) async {
    final list = await search(query.copyWithLimit(100000));
    return list.fold(
      (f) => Err(f),
      (items) => Success(items.length),
    );
  }

  @override
  Future<Result<EmployeeEntity>> create(EmployeeEntity employee) async {
    try {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      final id = employee.id.isEmpty ? _uuid.v4() : employee.id;
      await _db.into(_db.employees).insert(
            EmployeesCompanion.insert(
              id: id,
              firstName: employee.firstName,
              lastName: employee.lastName,
              nationalId: employee.nationalId,
              fatherName: Value(employee.fatherName),
              birthDate: Value(employee.birthDate),
              birthPlace: Value(employee.birthPlace),
              gender: Value(employee.gender),
              maritalStatus: Value(employee.maritalStatus),
              childrenCount: Value(employee.childrenCount),
              bloodGroup: Value(employee.bloodGroup),
              militaryStatus: Value(employee.militaryStatus),
              personalDescription: Value(employee.personalDescription),
              photoPath: Value(employee.photoPath),
              employeeNumber: Value(employee.employeeNumber),
              subscriptionNumber: Value(employee.subscriptionNumber),
              departmentId: Value(employee.departmentId),
              unitId: Value(employee.unitId),
              currentPosition: Value(employee.currentPosition),
              previousPosition: Value(employee.previousPosition),
              desiredPosition: Value(employee.desiredPosition),
              employmentType: Value(employee.employmentType),
              employmentDate: Value(employee.employmentDate),
              supervisorId: Value(employee.supervisorId),
              employmentStatus: Value(employee.employmentStatus),
              personType: Value(employee.personType),
              retirementDate: Value(employee.retirementDate),
              inactiveReason: Value(employee.inactiveReason),
              jobGroup: Value(employee.jobGroup),
              positionBase: Value(employee.positionBase),
              personalBase: Value(employee.personalBase),
              createdAt: now,
              updatedAt: now,
            ),
          );

      if (employee.contact != null) {
        await _db.into(_db.employeeContacts).insert(
              EmployeeContactsCompanion.insert(
                employeeId: id,
                primaryPhone: Value(employee.contact!.primaryPhone),
                secondaryPhone: Value(employee.contact!.secondaryPhone),
                emergencyPhone: Value(employee.contact!.emergencyPhone),
                email: Value(employee.contact!.email),
                homeAddress: Value(employee.contact!.homeAddress),
                postalCode: Value(employee.contact!.postalCode),
              ),
            );
      }

      if (employee.social != null) {
        await _db.into(_db.employeeSocials).insert(
              EmployeeSocialsCompanion.insert(
                employeeId: id,
                telegram: Value(employee.social!.telegram),
                whatsapp: Value(employee.social!.whatsapp),
                instagram: Value(employee.social!.instagram),
                linkedin: Value(employee.social!.linkedin),
              ),
            );
      }

      return getById(id);
    } catch (e) {
      return Err(StorageFailure('ثبت کارمند ناموفق: $e'));
    }
  }

  @override
  Future<Result<EmployeeEntity>> update(EmployeeEntity employee) async {
    try {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      await (_db.update(_db.employees)
            ..where((e) => e.id.equals(employee.id)))
          .write(
        EmployeesCompanion(
          firstName: Value(employee.firstName),
          lastName: Value(employee.lastName),
          fatherName: Value(employee.fatherName),
          nationalId: Value(employee.nationalId),
          birthDate: Value(employee.birthDate),
          birthPlace: Value(employee.birthPlace),
          gender: Value(employee.gender),
          maritalStatus: Value(employee.maritalStatus),
          childrenCount: Value(employee.childrenCount),
          bloodGroup: Value(employee.bloodGroup),
          militaryStatus: Value(employee.militaryStatus),
          personalDescription: Value(employee.personalDescription),
          photoPath: Value(employee.photoPath),
          employeeNumber: Value(employee.employeeNumber),
          subscriptionNumber: Value(employee.subscriptionNumber),
          departmentId: Value(employee.departmentId),
          unitId: Value(employee.unitId),
          currentPosition: Value(employee.currentPosition),
          previousPosition: Value(employee.previousPosition),
          desiredPosition: Value(employee.desiredPosition),
          employmentType: Value(employee.employmentType),
          employmentDate: Value(employee.employmentDate),
          supervisorId: Value(employee.supervisorId),
          employmentStatus: Value(employee.employmentStatus),
          personType: Value(employee.personType),
          retirementDate: Value(employee.retirementDate),
          inactiveReason: Value(employee.inactiveReason),
          jobGroup: Value(employee.jobGroup),
          positionBase: Value(employee.positionBase),
          personalBase: Value(employee.personalBase),
          updatedAt: Value(now),
        ),
      );

      if (employee.contact != null) {
        await _db.into(_db.employeeContacts).insertOnConflictUpdate(
              EmployeeContactsCompanion.insert(
                employeeId: employee.id,
                primaryPhone: Value(employee.contact!.primaryPhone),
                secondaryPhone: Value(employee.contact!.secondaryPhone),
                emergencyPhone: Value(employee.contact!.emergencyPhone),
                email: Value(employee.contact!.email),
                homeAddress: Value(employee.contact!.homeAddress),
                postalCode: Value(employee.contact!.postalCode),
              ),
            );
      }

      if (employee.social != null) {
        await _db.into(_db.employeeSocials).insertOnConflictUpdate(
              EmployeeSocialsCompanion.insert(
                employeeId: employee.id,
                telegram: Value(employee.social!.telegram),
                whatsapp: Value(employee.social!.whatsapp),
                instagram: Value(employee.social!.instagram),
                linkedin: Value(employee.social!.linkedin),
              ),
            );
      }

      return getById(employee.id);
    } catch (e) {
      return Err(StorageFailure('ویرایش کارمند ناموفق: $e'));
    }
  }

  @override
  Future<Result<void>> softDelete(String id) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await (_db.update(_db.employees)..where((e) => e.id.equals(id))).write(
      EmployeesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
    return const Success(null);
  }

  @override
  Future<Result<void>> bulkUpdate(List<EmployeeEntity> employees) async {
    for (final e in employees) {
      final r = await update(e);
      if (r.isFailure) return Err(r.failureOrNull!);
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> bulkSoftDelete(List<String> ids) async {
    for (final id in ids) {
      final r = await softDelete(id);
      if (r.isFailure) return Err(r.failureOrNull!);
    }
    return const Success(null);
  }

  @override
  Future<Result<bool>> nationalIdExists(
    String nationalId, {
    String? excludeId,
  }) async {
    final q = _db.select(_db.employees)
      ..where(
        (e) => e.nationalId.equals(nationalId) & e.deletedAt.isNull(),
      );
    final rows = await q.get();
    final exists =
        rows.any((r) => excludeId == null || r.id != excludeId);
    return Success(exists);
  }

  @override
  Future<Result<bool>> employeeNumberExists(
    String number, {
    String? excludeId,
  }) async {
    final q = _db.select(_db.employees)
      ..where(
        (e) => e.employeeNumber.equals(number) & e.deletedAt.isNull(),
      );
    final rows = await q.get();
    final exists =
        rows.any((r) => excludeId == null || r.id != excludeId);
    return Success(exists);
  }

  Future<EmployeeEntity> _hydrate(Employee row) async {
    final contact = await (_db.select(_db.employeeContacts)
          ..where((c) => c.employeeId.equals(row.id)))
        .getSingleOrNull();
    final social = await (_db.select(_db.employeeSocials)
          ..where((c) => c.employeeId.equals(row.id)))
        .getSingleOrNull();
    final interests = await (_db.select(_db.employeeInterests)
          ..where((c) => c.employeeId.equals(row.id)))
        .getSingleOrNull();

    return EmployeeEntity(
      id: row.id,
      firstName: row.firstName,
      lastName: row.lastName,
      fatherName: row.fatherName,
      nationalId: row.nationalId,
      birthDate: row.birthDate,
      birthPlace: row.birthPlace,
      gender: row.gender,
      maritalStatus: row.maritalStatus,
      childrenCount: row.childrenCount,
      bloodGroup: row.bloodGroup,
      militaryStatus: row.militaryStatus,
      personalDescription: row.personalDescription,
      photoPath: row.photoPath,
      employeeNumber: row.employeeNumber,
      subscriptionNumber: row.subscriptionNumber,
      departmentId: row.departmentId,
      unitId: row.unitId,
      currentPosition: row.currentPosition,
      previousPosition: row.previousPosition,
      desiredPosition: row.desiredPosition,
      employmentType: row.employmentType,
      employmentDate: row.employmentDate,
      supervisorId: row.supervisorId,
      employmentStatus: row.employmentStatus,
      personType: row.personType,
      retirementDate: row.retirementDate,
      inactiveReason: row.inactiveReason,
      jobGroup: row.jobGroup,
      positionBase: row.positionBase,
      personalBase: row.personalBase,
      contact: contact == null
          ? null
          : ContactInfo(
              primaryPhone: contact.primaryPhone,
              secondaryPhone: contact.secondaryPhone,
              emergencyPhone: contact.emergencyPhone,
              email: contact.email,
              homeAddress: contact.homeAddress,
              postalCode: contact.postalCode,
            ),
      social: social == null
          ? null
          : SocialInfo(
              telegram: social.telegram,
              whatsapp: social.whatsapp,
              instagram: social.instagram,
              linkedin: social.linkedin,
            ),
      interests: interests == null
          ? null
          : InterestsInfo(
              careerInterests: interests.careerInterests,
              technicalInterests: interests.technicalInterests,
              managementInterests: interests.managementInterests,
              personalInterests: interests.personalInterests,
              talentAssessment: interests.talentAssessment,
              behaviorAssessment: interests.behaviorAssessment,
              psychologicalNotes: interests.psychologicalNotes,
              managerNotes: interests.managerNotes,
            ),
    );
  }
}

extension on EmployeeQuery {
  EmployeeQuery copyWithLimit(int limit) => EmployeeQuery(
        searchText: searchText,
        departmentId: departmentId,
        employmentStatus: employmentStatus,
        andTerms: andTerms,
        orTerms: orTerms,
        notTerms: notTerms,
        offset: 0,
        limit: limit,
        sortBy: sortBy,
        ascending: ascending,
      );
}
