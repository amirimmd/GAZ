import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';

/// Session timeout + auto-lock orchestration.
class SessionController extends Notifier<AuthSession?> {
  Timer? _idleTimer;
  Timer? _sessionTimer;
  Duration autoLock = const Duration(minutes: 5);
  Duration sessionTimeout = const Duration(minutes: 15);
  VoidCallback? onAutoLock;
  VoidCallback? onSessionExpired;

  @override
  AuthSession? build() {
    ref.onDispose(_cancelTimers);
    return null;
  }

  void start(AuthSession session) {
    state = session;
    _armTimers();
  }

  void clear() {
    _cancelTimers();
    state = null;
  }

  void touch() {
    if (state == null) return;
    // Only reset idle timers — do not update state (avoids GoRouter rebuild).
    _armTimers();
  }

  void lock() {
    onAutoLock?.call();
  }

  void _armTimers() {
    _cancelTimers();
    _idleTimer = Timer(autoLock, () => onAutoLock?.call());
    _sessionTimer = Timer(sessionTimeout, () {
      clear();
      onSessionExpired?.call();
    });
  }

  void _cancelTimers() {
    _idleTimer?.cancel();
    _sessionTimer?.cancel();
    _idleTimer = null;
    _sessionTimer = null;
  }

  bool hasPermission(String code) =>
      state?.user.hasPermission(code) ?? false;
}

final sessionControllerProvider =
    NotifierProvider<SessionController, AuthSession?>(SessionController.new);
