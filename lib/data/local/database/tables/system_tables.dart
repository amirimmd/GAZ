import 'package:drift/drift.dart';

class AuditLogs extends Table {
  TextColumn get id => text()();
  TextColumn get actorUserId => text().nullable()();
  TextColumn get actorUsername => text().nullable()();
  TextColumn get action => text()();
  TextColumn get entityType => text().nullable()();
  TextColumn get entityId => text().nullable()();
  TextColumn get detailsJson => text().nullable()();
  TextColumn get deviceInfo => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {key};
}

class SavedFilters extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get queryJson => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class ReportTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get configJson => text()();
  TextColumn get createdBy => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class BackupJobs extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()(); // manual | daily | weekly | monthly
  TextColumn get schedule => text().nullable()();
  IntColumn get lastRunAt => integer().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get path => text().nullable()();
  TextColumn get signature => text().nullable()();
  TextColumn get contentHash => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
