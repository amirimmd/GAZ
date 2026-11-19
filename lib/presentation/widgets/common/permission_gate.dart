import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/security/session_controller.dart';

/// Hides [child] when the current user lacks [permission].
class PermissionGate extends ConsumerWidget {
  const PermissionGate({
    required this.permission,
    required this.child,
    this.fallback,
    super.key,
  });

  final String permission;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final allowed = session?.user.hasPermission(permission) ?? false;
    if (allowed) return child;
    return fallback ?? const SizedBox.shrink();
  }
}

/// Returns whether the current session has [permission].
bool hasSessionPermission(WidgetRef ref, String permission) {
  final session = ref.watch(sessionControllerProvider);
  return session?.user.hasPermission(permission) ?? false;
}
