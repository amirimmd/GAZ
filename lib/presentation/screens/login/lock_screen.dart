import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/security/session_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/gaz_logo.dart';
import '../../providers/auth_provider.dart';
import '../../providers/biometric_provider.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _passCtrl = TextEditingController();
  String? _error;
  bool _loading = false;
  bool _obscure = true;
  bool _biometricReady = false;

  @override
  void initState() {
    super.initState();
    _initBio();
  }

  Future<void> _initBio() async {
    final bio = ref.read(biometricAuthServiceProvider);
    final ready = await bio.isEnabled && await bio.isAvailable;
    if (!mounted) return;
    setState(() => _biometricReady = ready);
    if (ready) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (mounted) await _unlockBiometric();
    }
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  void _navigateUnlocked() {
    final session = ref.read(sessionControllerProvider);
    if (session?.user.mustChangePassword == true) {
      context.go('/change-password');
    } else {
      context.go('/dashboard');
    }
  }

  Future<void> _unlock() async {
    final session = ref.read(sessionControllerProvider);
    if (session == null) {
      context.go('/login');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final ok = await ref.read(loginViewModelProvider.notifier).unlock(
          _passCtrl.text,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      _navigateUnlocked();
    } else {
      setState(() => _error = 'رمز عبور نادرست است');
    }
  }

  Future<void> _unlockBiometric() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final bio = ref.read(biometricAuthServiceProvider);
    final result = await bio.authenticate(reason: 'باز کردن قفل قائم‌شهر');
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.ok) {
      ref.read(sessionControllerProvider.notifier).touch();
      _navigateUnlocked();
    } else {
      setState(() => _error = result.message ?? 'اثر انگشت ناموفق بود');
    }
  }

  Future<void> _fullLogout() async {
    await ref.read(authActionsProvider).logout();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: context.pagePadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(GazSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const GazLogo(height: 64),
                      const SizedBox(height: GazSpacing.md),
                      Text(
                        'صفحه قفل شده',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session?.user.displayName ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: GazSpacing.lg),
                      TextField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'رمز عبور',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => _unlock(),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: GazSpacing.lg),
                      FilledButton(
                        onPressed: _loading ? null : _unlock,
                        child: _loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('باز کردن'),
                      ),
                      if (_biometricReady) ...[
                        const SizedBox(height: GazSpacing.sm),
                        OutlinedButton.icon(
                          onPressed: _loading ? null : _unlockBiometric,
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('اثر انگشت'),
                        ),
                      ],
                      const SizedBox(height: GazSpacing.sm),
                      TextButton(
                        onPressed: _loading ? null : _fullLogout,
                        child: const Text('خروج از حساب'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
