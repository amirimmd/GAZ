import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/security/session_controller.dart';
import '../../providers/auth_provider.dart';
import '../../providers/repository_providers.dart';

/// Restores persisted sessions, wires auto-lock timers, and tracks user activity.
class SessionLifecycle extends ConsumerStatefulWidget {
  const SessionLifecycle({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SessionLifecycle> createState() => _SessionLifecycleState();
}

class _SessionLifecycleState extends ConsumerState<SessionLifecycle> {
  bool _initialized = false;
  bool _restoreStarted = false;
  bool _wired = false;

  Future<void> _restoreSession() async {
    final result = await ref.read(authRepositoryProvider).restoreSession();
    result.fold(
      (_) {},
      (session) {
        if (session != null) {
          ref.read(sessionControllerProvider.notifier).start(session);
        }
      },
    );
    if (mounted) setState(() => _initialized = true);
  }

  void _wireSessionCallbacks() {
    final notifier = ref.read(sessionControllerProvider.notifier);
    notifier.autoLock =
        Duration(minutes: AppConstants.defaultAutoLockMinutes);
    notifier.sessionTimeout =
        Duration(minutes: AppConstants.defaultSessionTimeoutMinutes);
    notifier.onAutoLock = () {
      if (mounted) context.go('/lock');
    };
    notifier.onSessionExpired = () async {
      await ref.read(authActionsProvider).logout();
      if (mounted) context.go('/login');
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_restoreStarted) {
      _restoreStarted = true;
      _restoreSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Material(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_wired) {
      _wired = true;
      _wireSessionCallbacks();
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) =>
          ref.read(sessionControllerProvider.notifier).touch(),
      child: widget.child,
    );
  }
}
