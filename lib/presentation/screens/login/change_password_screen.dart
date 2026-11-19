import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/security/session_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gaz_logo.dart';
import '../../providers/auth_provider.dart';
import '../../providers/biometric_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _error;
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _afterPasswordChanged() async {
    final bio = ref.read(biometricAuthServiceProvider);
    final session = ref.read(sessionControllerProvider);
    final username = session?.user.username;

    if (await bio.isEnabled) {
      await bio.updateStoredPassword(_newCtrl.text);
      if (mounted) _leave();
      return;
    }

    if (username != null && await bio.isAvailable && mounted) {
      final enable = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('ورود با اثر انگشت'),
          content: const Text(
            'رمز تغییر کرد. می‌خواهید ورود با اثر انگشت را فعال کنید؟',
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
      if (enable == true) {
        final auth = await bio.authenticate(
          reason: 'تأیید اثر انگشت برای فعال‌سازی',
        );
        if (auth.ok) {
          await bio.enable(username: username, password: _newCtrl.text);
        } else if (mounted && auth.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(auth.message!)),
          );
        }
      }
    }

    if (mounted) _leave();
  }

  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/dashboard');
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_newCtrl.text != _confirmCtrl.text) {
      setState(() => _error = 'رمز جدید و تکرار آن یکسان نیستند');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final result =
        await ref.read(loginViewModelProvider.notifier).changePassword(
              currentPassword: _currentCtrl.text,
              newPassword: _newCtrl.text,
            );

    if (!mounted) return;
    setState(() => _loading = false);

    await result.fold(
      (failure) async => setState(() => _error = failure.message),
      (_) => _afterPasswordChanged(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final mustChange = session?.user.mustChangePassword ?? false;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(GazSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(GazSpacing.xl),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const GazLogo(height: 64),
                        const SizedBox(height: GazSpacing.md),
                        Text(
                          mustChange
                              ? 'تغییر رمز عبور الزامی'
                              : 'تغییر رمز عبور',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mustChange
                              ? 'برای ادامه، رمز عبور پیش‌فرض را تغییر دهید.'
                              : 'رمز عبور جدید باید حداقل ۱۰ کاراکتر و شامل حروف بزرگ، کوچک و عدد باشد.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: GazSpacing.lg),
                        TextFormField(
                          controller: _currentCtrl,
                          obscureText: _obscureCurrent,
                          decoration: InputDecoration(
                            labelText: 'رمز عبور فعلی',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _obscureCurrent = !_obscureCurrent,
                              ),
                              icon: Icon(
                                _obscureCurrent
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'الزامی' : null,
                        ),
                        const SizedBox(height: GazSpacing.md),
                        TextFormField(
                          controller: _newCtrl,
                          obscureText: _obscureNew,
                          decoration: InputDecoration(
                            labelText: 'رمز عبور جدید',
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscureNew = !_obscureNew),
                              icon: Icon(
                                _obscureNew
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.length < 10) {
                              return 'حداقل ۱۰ کاراکتر';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: GazSpacing.md),
                        TextFormField(
                          controller: _confirmCtrl,
                          obscureText: _obscureNew,
                          decoration: const InputDecoration(
                            labelText: 'تکرار رمز عبور جدید',
                            prefixIcon: Icon(Icons.password_outlined),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'الزامی' : null,
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: GazSpacing.sm),
                          Text(
                            _error!,
                            style: TextStyle(color: scheme.error),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: GazSpacing.lg),
                        FilledButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('ذخیره رمز جدید'),
                        ),
                        if (!mustChange) ...[
                          const SizedBox(height: GazSpacing.sm),
                          TextButton(
                            onPressed: _leave,
                            child: const Text('انصراف'),
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
    );
  }
}
