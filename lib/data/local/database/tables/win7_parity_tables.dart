import 'package:drift/drift.dart';

import 'employee_tables.dart';

/// Win7 schema parity tables (versions 3–12).

class EmployeePerformanceReviews extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  IntColumn get year => integer()();
  IntColumn get season => integer()();
  TextColumn get track => text()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get evaluatorName => text().nullable()();
  TextColumn get evaluatorUserId => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get checkIn => text().nullable()();
  TextColumn get checkOut => text().nullable()();
  RealColumn get presenceHours => real().nullable()();
  RealColumn get dutyHours => real().nullable()();
  IntColumn get worksheetCount => integer().withDefault(const Constant(0))();
  IntColumn get worksheetQuota => integer().withDefault(const Constant(0))();
  IntColumn get complaintsFiled => integer().withDefault(const Constant(0))();
  IntColumn get complaintsValid => integer().withDefault(const Constant(0))();
  IntColumn get complaintsAnswered =>
      integer().withDefault(const Constant(0))();
  IntColumn get responseQuality => integer().withDefault(const Constant(5))();
  IntColumn get socialParticipation =>
      integer().withDefault(const Constant(3))();
  IntColumn get extraEffort => integer().withDefault(const Constant(3))();
  IntColumn get extraHumanCapital =>
      integer().withDefault(const Constant(3))();
  IntColumn get extraOrgRelations =>
      integer().withDefault(const Constant(3))();
  IntColumn get extraClub => integer().withDefault(const Constant(3))();
  TextColumn get extraEvidence => text().nullable()();
  IntColumn get expectedProjects => integer().withDefault(const Constant(0))();
  RealColumn get expectedVolume => real().withDefault(const Constant(0))();
  IntColumn get expectedChecklists =>
      integer().withDefault(const Constant(0))();
  RealColumn get mainScore => real().nullable()();
  RealColumn get extraScore => real().nullable()();
  TextColumn get lightCode => text().nullable()();
  BoolColumn get safetyRedFlag =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get exemplary => boolean().withDefault(const Constant(false))();
  BoolColumn get extraOrgBadge =>
      boolean().withDefault(const Constant(false))();
  IntColumn get approvedAt => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {employeeId, year, season, track},
      ];
}

class EmployeeWorkerProjects extends Table {
  TextColumn get id => text()();
  TextColumn get reviewId =>
      text().references(EmployeePerformanceReviews, #id)();
  TextColumn get title => text()();
  IntColumn get level => integer()();
  RealColumn get hours => real()();
  RealColumn get progressPercent => real()();
  IntColumn get checklistCount => integer().withDefault(const Constant(0))();
  IntColumn get incidentsDirect => integer().withDefault(const Constant(0))();
  IntColumn get incidentsIndirect =>
      integer().withDefault(const Constant(0))();
  BoolColumn get severe => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class AttendanceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get workDate => text()();
  TextColumn get status => text()();
  TextColumn get checkIn => text().nullable()();
  TextColumn get checkOut => text().nullable()();
  RealColumn get hours => real().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get createdBy => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {employeeId, workDate},
      ];
}

class FieldSuggestions extends Table {
  TextColumn get category => text()();
  TextColumn get value => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {category, value};
}

class EmployeeSampleTitles extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  IntColumn get year => integer()();
  TextColumn get kind => text()();
  TextColumn get note => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get createdBy => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {employeeId, year, kind},
      ];
}

class EmployeeSampleIntroductions extends Table {
  TextColumn get id => text()();
  TextColumn get sampleTitleId =>
      text().references(EmployeeSampleTitles, #id)();
  TextColumn get organization => text()();
  TextColumn get note => text().nullable()();
  IntColumn get createdAt => integer()();
  TextColumn get createdBy => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmployeeGroupActivities extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(EmployeeGroups, #id)();
  TextColumn get title => text()();
  TextColumn get note => text().nullable()();
  TextColumn get activityDate => text().nullable()();
  TextColumn get createdBy => text().nullable()();
  TextColumn get createdByName => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
