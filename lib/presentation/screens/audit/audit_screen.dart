import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../providers/app_data_providers.dart';
import '../../providers/dashboard_provider.dart';

class AuditScreen extends ConsumerWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(auditLogsProvider);

    return Padding(
      padding: context.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'گزارش ممیزی (Audit Log)',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'تمام رویدادهای امنیتی و عملیاتی به‌صورت فقط‌افزودنی ثبت می‌شوند.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: GazSpacing.md),
          Expanded(
            child: Card(
              child: logsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('خطا: $e')),
                data: (logs) {
                  if (logs.isEmpty) {
                    return const Center(child: Text('هنوز رویدادی ثبت نشده'));
                  }
                  return ListView.separated(
                    itemCount: logs.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final log = logs[i];
                      final actor =
                          log.actorUsername ?? log.actorUserId ?? '—';
                      final when = DateFormat('yyyy/MM/dd HH:mm')
                          .format(log.createdAt.toLocal());
                      final actionFa = auditActionLabelFa(log.action);
                      final details = log.detailsJson;
                      final subtitle = details != null && details.isNotEmpty
                          ? '$actor — $details'
                          : actor;

                      return ListTile(
                        leading: Icon(_iconForAction(log.action)),
                        title: Text(actionFa),
                        subtitle: Text('$subtitle\n$when'),
                        isThreeLine: true,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForAction(String action) {
    return switch (action) {
      'login' => Icons.login,
      'logout' => Icons.logout,
      'login_failed' => Icons.error_outline,
      'password_change' => Icons.password,
      _ => Icons.security,
    };
  }
}
