import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/audit_repository_impl.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/entities/user_account_summary.dart';
import '../../domain/repositories/audit_repository.dart';
import 'repository_providers.dart';

final auditRepositoryProvider = Provider<AuditRepository>((ref) {
  return AuditRepositoryImpl(ref.watch(appDatabaseProvider));
});

final usersListProvider =
    FutureProvider.autoDispose<List<UserAccountSummary>>((ref) async {
  final result = await ref.watch(authRepositoryProvider).listUsers();
  return result.fold((f) => throw f, (list) => list);
});

final auditLogsProvider =
    FutureProvider.autoDispose<List<AuditLogEntity>>((ref) async {
  final result = await ref.watch(auditRepositoryProvider).query(limit: 50);
  return result.fold((f) => throw f, (list) => list);
});
