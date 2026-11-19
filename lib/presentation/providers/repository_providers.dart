import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database/app_database.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../data/repositories/employee_group_repository_impl.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/repositories/employee_group_repository.dart';
import '../../domain/repositories/employee_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(openEncryptedConnection());
  ref.onDispose(db.close);
  return db;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(appDatabaseProvider));
});

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return EmployeeRepositoryImpl(ref.watch(appDatabaseProvider));
});

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepositoryImpl(ref.watch(appDatabaseProvider));
});

final employeeGroupRepositoryProvider = Provider<EmployeeGroupRepository>((ref) {
  return EmployeeGroupRepositoryImpl(
    ref.watch(appDatabaseProvider),
    ref.watch(employeeRepositoryProvider),
  );
});
