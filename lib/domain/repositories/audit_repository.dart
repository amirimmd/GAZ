import '../../core/errors/failures.dart';
import '../entities/document_entity.dart';

abstract class AuditRepository {
  Future<Result<void>> log({
    required String action,
    String? actorUserId,
    String? actorUsername,
    String? entityType,
    String? entityId,
    String? detailsJson,
    String? deviceInfo,
  });

  Future<Result<List<AuditLogEntity>>> query({
    String? actorUserId,
    String? action,
    DateTime? from,
    DateTime? to,
    int offset = 0,
    int limit = 100,
  });
}
