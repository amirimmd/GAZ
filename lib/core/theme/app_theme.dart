import 'package:flutter/material.dart';

/// Institutional gas/energy palette — Material 3 tokens.
abstract final class GazColors {
  static const Color primary = Color(0xFF0B3D4A);
  static const Color primaryContainer = Color(0xFF1A5C6B);
  static const Color secondary = Color(0xFFC45C26);
  static const Color secondaryContainer = Color(0xFFF0D5C4);
  static const Color tertiary = Color(0xFF2E6B5A);

  static const Color lightSurface = Color(0xFFF7F9FA);
  static const Color lightBackground = Color(0xFFEEF3F5);
  static const Color lightOnSurface = Color(0xFF1A2428);

  static const Color darkSurface = Color(0xFF0E1A1F);
  static const Color darkBackground = Color(0xFF081217);
  static const Color darkOnSurface = Color(0xFFE8EEF0);

  static const Color success = Color(0xFF1B7A4E);
  static const Color warning = Color(0xFFB7791F);
  static const Color error = Color(0xFFB42318);
  static const Color info = Color(0xFF1D6B8A);
}

abstract final class GazRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

abstract final class GazSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

abstract final class GazFonts {
  static const String family = 'Vazirmatn';
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ColorScheme.fromSeed(
      seedColor: GazColors.primary,
      brightness: Brightness.light,
      primary: GazColors.primary,
      secondary: GazColors.secondary,
      surface: GazColors.lightSurface,
      error: GazColors.error,
    );
    return _build(base, Brightness.light);
  }

  static ThemeData get dark {
    final base = ColorScheme.fromSeed(
      seedColor: GazColors.primary,
      brightness: Brightness.dark,
      primary: const Color(0xFF4FA3B5),
      secondary: const Color(0xFFE08A5A),
      surface: GazColors.darkSurface,
      error: const Color(0xFFF97066),
    );
    return _build(base, Brightness.dark);
  }

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    const family = GazFonts.family;
    final textTheme = ThemeData(brightness: brightness).textTheme.apply(
          fontFamily: family,
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      textTheme: textTheme,
      fontFamily: family,
      scaffoldBackgroundColor:
          isDark ? GazColors.darkBackground : GazColors.lightBackground,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: family,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GazRadii.lg),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GazRadii.md),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GazRadii.md),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GazRadii.md),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GazRadii.md),
          ),
          textStyle: const TextStyle(
            fontFamily: family,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GazRadii.md),
          ),
          textStyle: const TextStyle(
            fontFamily: family,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GazRadii.md),
          ),
          textStyle: const TextStyle(
            fontFamily: family,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(36, 36),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(
            fontFamily: family,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(40, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      tabBarTheme: TabBarThemeData(
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontFamily: family,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: family,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surface,
        selectedIconTheme: IconThemeData(color: scheme.primary),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        indicatorColor: scheme.primaryContainer.withValues(alpha: 0.35),
        labelType: NavigationRailLabelType.all,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GazRadii.xl),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
        space: 1,
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: TextStyle(
          fontFamily: family,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        dataTextStyle: TextStyle(
          fontFamily: family,
          fontSize: 14,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}
