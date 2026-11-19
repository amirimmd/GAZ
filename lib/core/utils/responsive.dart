import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shared layout breakpoints — use instead of ad-hoc width checks.
abstract final class GazBreakpoints {
  static const double sm = 600;
  static const double md = 700;
  static const double lg = 900;
  static const double xl = 1200;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  bool get isCompact => screenWidth < GazBreakpoints.sm;
  bool get isNarrow => screenWidth < GazBreakpoints.md;
  bool get isMobileLayout => screenWidth < GazBreakpoints.lg;

  /// Standard page padding — tighter on phones.
  EdgeInsets get pagePadding =>
      EdgeInsets.all(isMobileLayout ? GazSpacing.md : GazSpacing.lg);

  /// Clamp system font scaling so buttons stay usable on small screens.
  TextScaler get clampedTextScaler {
    final scaler = MediaQuery.textScalerOf(this);
    final scale = scaler.scale(1).clamp(0.85, 1.15);
    return TextScaler.linear(scale);
  }
}

/// Scrollable tab bar tuned for RTL and narrow screens.
class GazTabBar extends StatelessWidget implements PreferredSizeWidget {
  const GazTabBar({
    required this.controller,
    required this.tabs,
    super.key,
  });

  final TabController controller;
  final List<Tab> tabs;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerHeight: 0,
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
      tabs: tabs,
    );
  }
}
