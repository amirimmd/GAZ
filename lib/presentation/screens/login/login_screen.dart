import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/security/session_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/gaz_logo.dart';
import '../../providers/auth_provider.dart';
import '../../providers/biometric_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _remember = false;
  bool _obscure = true;
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(_fade);
    _anim.forward();
    _loadBiometric();
  }

  Future<void> _loadBiometric() async {
    final bio = ref.read(biometricAuthServiceProvider);
    final available = await bio.isAvailable;
    final enabled = await bio.isEnabled;
    final username = await bio.savedUsername;
    if (!mounted) return;
    setState(() {
      _biometricAvailable = available;
      _biometricEnabled = enabled;
      if (username != null && username.isNotEmpty) {
        _userCtrl.text = username;
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _offerBiometricEnable({
    required String username,
    required String password,
  }) async {
    final bio = ref.read(biometricAuthServiceProvider);
    if (!(await bio.isAvailable) || await bio.isEnabled) return;
    if (!mounted) return;

    final enable = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('ورود با اثر انگشت'),
        content: const Text(
          'برای ورودهای بعدی می‌توانید اثر انگشت را فعال کنید. فعال شود؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('بعداً'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('فعال‌سازی'),
          ),
        ],
      ),
    );
    if (enable != true || !mounted) return;

    final auth = await bio.authenticate(
      reason: 'تأیید اثر انگشت برای فعال‌سازی',
    );
    if (!auth.ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(auth.message ?? 'فعال‌سازی ناموفق')),
        );
      }
      return;
    }
    final saved = await bio.enable(username: username, password: password);
    if (!mounted) return;
    if (!saved.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(saved.message ?? 'ذخیره ناموفق')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ورود با اثر انگشت فعال شد')),
    );
  }

  Future<void> _goAfterLogin() async {
    final session = ref.read(sessionControllerProvider);
    if (session?.user.mustChangePassword == true) {
      ref.read(pendingBiometricSetupProvider.notifier).state = false;
      if (mounted) context.go('/change-password');
      return;
    }

    ref.read(pendingBiometricSetupProvider.notifier).state = true;
    try {
      await _offerBiometricEnable(
        username: _userCtrl.text.trim(),
        password: _passCtrl.text,
      );
    } finally {
      ref.read(pendingBiometricSetupProvider.notifier).state = false;
    }

    if (mounted) context.go('/dashboard');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    // Block redirect until biometric opt-in finishes.
    ref.read(pendingBiometricSetupProvider.notifier).state = true;
    final ok = await ref.read(loginViewModelProvider.notifier).submit(
          username: _userCtrl.text,
          password: _passCtrl.text,
          rememberMe: _remember,
        );
    if (!ok) {
      ref.read(pendingBiometricSetupProvider.notifier).state = false;
      return;
    }
    if (mounted) await _goAfterLogin();
  }

  Future<void> _biometricLogin() async {
    final bio = ref.read(biometricAuthServiceProvider);
    final creds = await bio.unlockCredentials();
    if (creds == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('احراز هویت بیومتریک ناموفق بود')),
        );
      }
      return;
    }
    final ok = await ref.read(loginViewModelProvider.notifier).submit(
          username: creds.username,
          password: creds.password,
          rememberMe: true,
        );
    if (ok && mounted) {
      context.go(
        ref.read(sessionControllerProvider)?.user.mustChangePassword == true
            ? '/change-password'
            : '/dashboard',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final scheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);
    final pad = context.isCompact ? GazSpacing.md : GazSpacing.lg;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              scheme.primary.withValues(alpha: 0.92),
              const Color(0xFF06262F),
              scheme.surface,
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: pad,
                  vertical: GazSpacing.lg,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slide,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: size.width > 600 ? 420 : 360,
                          ),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(
                                size.width < 400
                                    ? GazSpacing.lg
                                    : GazSpacing.xl,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const GazLogo(height: 88),
                                    const SizedBox(height: GazSpacing.md),
                                    Text(
                                      AppConstants.appNameFa,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppConstants.organizationNameFa,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                    ),
                                    const SizedBox(height: GazSpacing.xl),
                                    TextFormField(
                                      controller: _userCtrl,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        labelText: 'نام کاربری',
                                        prefixIcon: Icon(Icons.person_outline),
                                      ),
                                      validator: (v) =>
                                          (v == null || v.trim().isEmpty)
                                              ? 'الزامی'
                                              : null,
                                    ),
                                    const SizedBox(height: GazSpacing.md),
                                    TextFormField(
                                      controller: _passCtrl,
                                      obscureText: _obscure,
                                      onFieldSubmitted: (_) => _submit(),
                                      decoration: InputDecoration(
                                        labelText: 'رمز عبور',
                                        prefixIcon:
                                            const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                          onPressed: () => setState(
                                            () => _obscure = !_obscure,
                                          ),
                                          icon: Icon(
                                            _obscure
                                                ? Icons.visibility_outlined
                                                : Icons
                                                    .visibility_off_outlined,
                                          ),
                                        ),
                                      ),
                                      validator: (v) =>
                                          (v == null || v.isEmpty)
                                              ? 'الزامی'
                                              : null,
                                    ),
                                    const SizedBox(height: GazSpacing.sm),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                              value: _remember,
                                              onChanged: (v) => setState(
                                                () => _remember = v ?? false,
                                              ),
                                            ),
                                            const Text('مرا به خاطر بسپار'),
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            showDialog<void>(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: const Text(
                                                  'بازیابی رمز عبور',
                                                ),
                                                content: const Text(
                                                  'برای بازنشانی رمز عبور با مدیر سیستم تماس بگیرید.',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(ctx),
                                                    child: const Text('بستن'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: const Text('فراموشی رمز'),
                                        ),
                                      ],
                                    ),
                                    if (state.error != null) ...[
                                      const SizedBox(height: GazSpacing.sm),
                                      Text(
                                        state.error!,
                                        style: TextStyle(color: scheme.error),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                    const SizedBox(height: GazSpacing.lg),
                                    FilledButton(
                                      onPressed:
                                          state.isLoading ? null : _submit,
                                      child: state.isLoading
                                          ? const SizedBox(
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text('ورود'),
                                    ),
                                    if (_biometricAvailable &&
                                        _biometricEnabled) ...[
                                      const SizedBox(height: GazSpacing.md),
                                      OutlinedButton.icon(
                                        onPressed: state.isLoading
                                            ? null
                                            : _biometricLogin,
                                        icon: const Icon(Icons.fingerprint),
                                        label: const Text('ورود با اثر انگشت'),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
