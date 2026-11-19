import 'package:drift/drift.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/audit_repository.dart';
import '../local/database/app_database.dart';

class AuditRepositoryImpl implements AuditRepository {
  AuditRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<Result<void>> log({
    required String action,
    String? actorUserId,
    String? actorUsername,
    String? entityType,
    String? entityId,
    String? detailsJson,
    String? deviceInfo,
  }) async {
    try {
      await _db.into(_db.auditLogs).insert(
            AuditLogsCompanion.insert(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              action: action,
              actorUserId: Value(actorUserId),
              actorUsername: Value(actorUsername),
              entityType: Value(entityType),
              entityId: Value(entityId),
              detailsJson: Value(detailsJson),
              deviceInfo: Value(deviceInfo),
              createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
            ),
          );
      return const Success(null);
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }

  @override
  Future<Result<List<AuditLogEntity>>> query({
    String? actorUserId,
    String? action,
    DateTime? from,
    DateTime? to,
    int offset = 0,
    int limit = 100,
  }) async {
    try {
      final q = _db.select(_db.auditLogs)
        ..orderBy([
          (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
        ])
        ..limit(limit, offset: offset);

      if (actorUserId != null) {
        q.where((t) => t.actorUserId.equals(actorUserId));
      }
      if (action != null) {
        q.where((t) => t.action.equals(action));
      }
      if (from != null) {
        q.where(
          (t) => t.createdAt.isBiggerOrEqualValue(
            from.toUtc().millisecondsSinceEpoch,
          ),
        );
      }
      if (to != null) {
        q.where(
          (t) => t.createdAt.isSmallerOrEqualValue(
            to.toUtc().millisecondsSinceEpoch,
          ),
        );
      }

      final rows = await q.get();
      return Success(
        rows
            .map(
              (r) => AuditLogEntity(
                id: r.id,
                action: r.action,
                actorUserId: r.actorUserId,
                actorUsername: r.actorUsername,
                entityType: r.entityType,
                entityId: r.entityId,
                detailsJson: r.detailsJson,
                deviceInfo: r.deviceInfo,
                createdAt: DateTime.fromMillisecondsSinceEpoch(
                  r.createdAt,
                  isUtc: true,
                ),
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Err(UnexpectedFailure('$e'));
    }
  }
}
