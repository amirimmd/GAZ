import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/document_entity.dart';
import '../../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final statsAsync = ref.watch(dashboardStatsProvider);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: context.pagePadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                'داشبورد',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'نمای کلی منابع انسانی شعبه قائم‌شهر',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: GazSpacing.lg),
              statsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(GazSpacing.xl),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(GazSpacing.lg),
                    child: Text('خطا در بارگذاری داشبورد: $e'),
                  ),
                ),
                data: (stats) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _KpiRow(stats: stats),
                    const SizedBox(height: GazSpacing.lg),
                    _ChartsRow(stats: stats),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.stats});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _KpiCard(
        title: 'کل کارکنان',
        value: '${stats.totalEmployees}',
        icon: Icons.groups_outlined,
        accent: GazColors.primary,
        onTap: () => context.go('/employees'),
      ),
      _KpiCard(
        title: 'فعال',
        value: '${stats.activeEmployees}',
        icon: Icons.check_circle_outline,
        accent: GazColors.success,
        onTap: () => context.go('/employees'),
      ),
      _KpiCard(
        title: 'اسناد',
        value: '${stats.documentCount}',
        icon: Icons.folder_outlined,
        accent: GazColors.info,
        onTap: () => context.go('/documents'),
      ),
      _KpiCard(
        title: 'ارزیابی امسال',
        value: '${stats.evaluationsThisYear}',
        icon: Icons.star_outline,
        accent: GazColors.secondary,
        onTap: () => context.go('/reports'),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 900;
        if (wide) {
          return Row(
            children: [
              for (final c in cards) ...[
                Expanded(child: c),
                if (c != cards.last) const SizedBox(width: GazSpacing.md),
              ],
            ],
          );
        }
        final half =
            ((constraints.maxWidth - GazSpacing.md) / 2).floorToDouble();
        final cardWidth = half < 120 ? constraints.maxWidth : half;
        return Wrap(
          spacing: GazSpacing.md,
          runSpacing: GazSpacing.md,
          children: [
            for (final c in cards)
              SizedBox(width: cardWidth, child: c),
          ],
        );
      },
    );
  }
}

class _ChartsRow extends StatelessWidget {
  const _ChartsRow({required this.stats});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartCard = Card(
          child: Padding(
            padding: const EdgeInsets.all(GazSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'توزیع وضعیت اشتغال',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: GazSpacing.lg),
                SizedBox(
                  height: 220,
                  child: stats.statusCounts.isEmpty
                      ? Center(
                          child: Text(
                            'هنوز کارمندی ثبت نشده',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 48,
                            sections: stats.statusCounts.entries
                                .map(
                                  (e) => PieChartSectionData(
                                    value: e.value.toDouble(),
                                    title: employmentStatusLabelFa(e.key),
                                    titleStyle: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    color: employmentStatusColor(e.key),
                                    radius: 40,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );

        final activityCard = Card(
          child: InkWell(
            onTap: () => context.go('/audit'),
            borderRadius: BorderRadius.circular(GazRadii.md),
            child: Padding(
              padding: const EdgeInsets.all(GazSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'فعالیت اخیر',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        'مشاهده همه',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const Icon(Icons.chevron_left, size: 18),
                    ],
                  ),
                  const SizedBox(height: GazSpacing.md),
                  if (stats.recentActivity.isEmpty)
                    Text(
                      'هنوز رویدادی ثبت نشده',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else
                    for (final log in stats.recentActivity.take(5))
                      _ActivityTile(log: log),
                ],
              ),
            ),
          ),
        );

        if (constraints.maxWidth < 700) {
          return Column(
            children: [
              chartCard,
              const SizedBox(height: GazSpacing.md),
              activityCard,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: chartCard),
            const SizedBox(width: GazSpacing.md),
            Expanded(flex: 2, child: activityCard),
          ],
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(GazSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(GazRadii.md),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: GazSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.log});

  final AuditLogEntity log;

  @override
  Widget build(BuildContext context) {
    final actor = log.actorUsername ?? log.actorUserId ?? '—';
    final when = DateFormat('yyyy/MM/dd HH:mm').format(log.createdAt.toLocal());
    final title = '${auditActionLabelFa(log.action)} — $actor';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(_iconForAction(log.action)),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        when,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  IconData _iconForAction(String action) {
    return switch (action) {
      'login' => Icons.login,
      'logout' => Icons.logout,
      'login_failed' => Icons.error_outline,
      'password_change' => Icons.password,
      _ => Icons.history,
    };
  }
}
