import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import 'app_data_providers.dart';
import 'repository_providers.dart';

class DashboardStats extends Equatable {
  const DashboardStats({
    required this.totalEmployees,
    required this.activeEmployees,
    required this.documentCount,
    required this.evaluationsThisYear,
    required this.statusCounts,
    required this.recentActivity,
  });

  final int totalEmployees;
  final int activeEmployees;
  final int documentCount;
  final int evaluationsThisYear;
  final Map<String, int> statusCounts;
  final List<AuditLogEntity> recentActivity;

  @override
  List<Object?> get props => [
        totalEmployees,
        activeEmployees,
        documentCount,
        evaluationsThisYear,
        statusCounts,
        recentActivity,
      ];
}

final dashboardStatsProvider = FutureProvider.autoDispose<DashboardStats>(
  (ref) async {
    final db = ref.watch(appDatabaseProvider);
    final empRepo = ref.watch(employeeRepositoryProvider);
    final auditRepo = ref.watch(auditRepositoryProvider);

    final totalResult = await empRepo.count(const EmployeeQuery(limit: 0));
    final activeResult = await empRepo.count(
      const EmployeeQuery(employmentStatus: 'active', limit: 0),
    );

    final totalEmployees = totalResult.fold((_) => 0, (c) => c);
    final activeEmployees = activeResult.fold((_) => 0, (c) => c);

    final docRow = await db.customSelect(
      'SELECT COUNT(*) AS c FROM employee_documents WHERE deleted_at IS NULL',
      readsFrom: {db.employeeDocuments},
    ).getSingle();
    final documentCount = docRow.read<int>('c');

    final year = DateTime.now().year;
    final evalRow = await db.customSelect(
      'SELECT COUNT(*) AS c FROM employee_evaluations WHERE year = ?',
      variables: [Variable.withInt(year)],
      readsFrom: {db.employeeEvaluations},
    ).getSingle();
    final evaluationsThisYear = evalRow.read<int>('c');

    final statusRows = await db.customSelect(
      '''
      SELECT employment_status AS status, COUNT(*) AS c
      FROM employees
      WHERE deleted_at IS NULL
      GROUP BY employment_status
      ''',
      readsFrom: {db.employees},
    ).get();

    final statusCounts = <String, int>{};
    for (final row in statusRows) {
      statusCounts[row.read<String>('status')] = row.read<int>('c');
    }

    final activityResult = await auditRepo.query(limit: 8);
    final recentActivity = activityResult.fold(
      (_) => <AuditLogEntity>[],
      (list) => list,
    );

    return DashboardStats(
      totalEmployees: totalEmployees,
      activeEmployees: activeEmployees,
      documentCount: documentCount,
      evaluationsThisYear: evaluationsThisYear,
      statusCounts: statusCounts,
      recentActivity: recentActivity,
    );
  },
);

String employmentStatusLabelFa(String status) {
  return switch (status) {
    'active' => 'فعال',
    'terminated' => 'خاتمه',
    'leave' => 'مرخصی',
    'mission' => 'مأمور',
    _ => status,
  };
}

Color employmentStatusColor(String status) {
  return switch (status) {
    'active' => GazColors.success,
    'terminated' => GazColors.error,
    'leave' => GazColors.warning,
    'mission' => GazColors.info,
    _ => GazColors.primary,
  };
}

String auditActionLabelFa(String action) {
  return switch (action) {
    'login' => 'ورود',
    'logout' => 'خروج',
    'login_failed' => 'ورود ناموفق',
    'password_change' => 'تغییر رمز',
    _ => action,
  };
}
