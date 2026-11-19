import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/router/app_router.dart';
import 'presentation/widgets/common/session_lifecycle.dart';

class GazHrmsApp extends ConsumerWidget {
  const GazHrmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(appRouterProvider);

    return SessionLifecycle(
      child: MaterialApp.router(
        title: AppConstants.appNameFa,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        locale: const Locale('fa', 'IR'),
        supportedLocales: const [
          Locale('fa', 'IR'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router,
        builder: (context, child) {
          final media = MediaQuery.of(context);
          final scale = media.textScaler.scale(1).clamp(0.85, 1.15);
          final keyboardOpen = media.viewInsets.bottom > 0 ||
              (FocusManager.instance.primaryFocus?.hasFocus ?? false);

          return MediaQuery(
            data: media.copyWith(
              textScaler: TextScaler.linear(scale),
            ),
            child: PopScope(
              canPop: !keyboardOpen,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (media.viewInsets.bottom > 0 ||
                    (FocusManager.instance.primaryFocus?.hasFocus ?? false)) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  return;
                }
                final r = GoRouter.maybeOf(context);
                if (r != null && r.canPop()) {
                  r.pop(result);
                }
              },
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
