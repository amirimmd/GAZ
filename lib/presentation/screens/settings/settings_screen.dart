import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/security/session_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/gaz_logo.dart';
import '../../providers/auth_provider.dart';
import '../../providers/biometric_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _bioAvailable = false;
  bool _bioEnabled = false;
  int _sessionMinutes = AppConstants.defaultSessionTimeoutMinutes;
  int _autoLockMinutes = AppConstants.defaultAutoLockMinutes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final bio = ref.read(biometricAuthServiceProvider);
    final available = await bio.isAvailable;
    final enabled = await bio.isEnabled;

    final themeName = prefs.getString('gaz_theme_mode');
    if (themeName != null) {
      final mode = ThemeMode.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => ThemeMode.system,
      );
      ref.read(themeModeProvider.notifier).state = mode;
    }

    if (!mounted) return;
    setState(() {
      _bioAvailable = available;
      _bioEnabled = enabled;
      _sessionMinutes = prefs.getInt('gaz_session_timeout_minutes') ??
          AppConstants.defaultSessionTimeoutMinutes;
      _autoLockMinutes = prefs.getInt('gaz_auto_lock_minutes') ??
          AppConstants.defaultAutoLockMinutes;
      _loading = false;
    });
    _applyTimers();
  }

  void _applyTimers() {
    final ctrl = ref.read(sessionControllerProvider.notifier);
    ctrl.sessionTimeout = Duration(minutes: _sessionMinutes);
    ctrl.autoLock = Duration(minutes: _autoLockMinutes);
    ctrl.touch();
  }

  Future<void> _saveTimers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gaz_session_timeout_minutes', _sessionMinutes);
    await prefs.setInt('gaz_auto_lock_minutes', _autoLockMinutes);
    _applyTimers();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('زمان‌بندی نشست ذخیره شد')),
      );
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    final bio = ref.read(biometricAuthServiceProvider);
    if (!value) {
      await bio.disable();
      setState(() => _bioEnabled = false);
      return;
    }

    final session = ref.read(sessionControllerProvider);
    if (session == null) return;

    final password = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('فعال‌سازی اثر انگشت'),
          content: TextField(
            controller: ctrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'رمز عبور فعلی برای ذخیره امن',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('ادامه'),
            ),
          ],
        );
      },
    );
    if (password == null || password.isEmpty) return;

    final okPass =
        await ref.read(loginViewModelProvider.notifier).unlock(password);
    if (!okPass) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('رمز عبور نادرست است')),
        );
      }
      return;
    }

    final okBio = await bio.authenticate(reason: 'تأیید اثر انگشت');
    if (!okBio.ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(okBio.message ?? 'اثر انگشت ناموفق')),
        );
      }
      return;
    }
    final saved =
        await bio.enable(username: session.user.username, password: password);
    if (!mounted) return;
    if (!saved.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(saved.message ?? 'ذخیره ناموفق')),
      );
      return;
    }
    setState(() => _bioEnabled = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ورود با اثر انگشت فعال شد')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: context.pagePadding,
      child: ListView(
        children: [
          Text(
            'تنظیمات',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: GazSpacing.md),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('لوگوی سازمان'),
                  subtitle: Text(
                    AppConstants.organizationNameFa,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: const SizedBox(
                    width: 40,
                    height: 40,
                    child: GazLogo(height: 40, width: 40, fit: BoxFit.contain),
                  ),
                ),
                const Divider(height: 1),
                const ListTile(
                  title: Text('نام برنامه'),
                  subtitle: Text(AppConstants.appNameFa),
                  leading: Icon(Icons.badge_outlined),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('پوسته'),
                  subtitle: Text(switch (themeMode) {
                    ThemeMode.light => 'روشن',
                    ThemeMode.dark => 'تاریک',
                    ThemeMode.system => 'سیستم',
                  }),
                  leading: const Icon(Icons.palette_outlined),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode),
                        label: Text('روشن'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode),
                        label: Text('تاریک'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto),
                        label: Text('سیستم'),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (s) async {
                      final mode = s.first;
                      ref.read(themeModeProvider.notifier).state = mode;
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('gaz_theme_mode', mode.name);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: GazSpacing.md),
          Card(
            child: Column(
              children: [
                if (_bioAvailable)
                  SwitchListTile(
                    title: const Text('ورود با اثر انگشت'),
                    subtitle: Text(
                      _bioEnabled
                          ? 'فعال — در صفحه ورود و قفل قابل استفاده است'
                          : 'پس از تأیید رمز عبور فعال می‌شود',
                    ),
                    secondary: const Icon(Icons.fingerprint),
                    value: _bioEnabled,
                    onChanged: _toggleBiometric,
                  )
                else
                  const ListTile(
                    title: Text('ورود با اثر انگشت'),
                    subtitle: Text(
                      'این دستگاه اثر انگشت ندارد یا پشتیبانی نمی‌کند',
                    ),
                    leading: Icon(Icons.fingerprint),
                  ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('تغییر رمز عبور'),
                  subtitle: const Text('رمز فعلی را عوض کنید'),
                  leading: const Icon(Icons.password),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () => context.push('/change-password'),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('مدت نشست'),
                  subtitle: Text('$_sessionMinutes دقیقه'),
                  leading: const Icon(Icons.timer_outlined),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Slider(
                    value: _sessionMinutes.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    label: '$_sessionMinutes دقیقه',
                    onChanged: (v) =>
                        setState(() => _sessionMinutes = v.round()),
                  ),
                ),
                ListTile(
                  title: const Text('قفل خودکار'),
                  subtitle: Text('$_autoLockMinutes دقیقه بی‌فعالیتی'),
                  leading: const Icon(Icons.lock_clock),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Slider(
                    value: _autoLockMinutes.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: '$_autoLockMinutes دقیقه',
                    onChanged: (v) =>
                        setState(() => _autoLockMinutes = v.round()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FilledButton.tonal(
                      onPressed: _saveTimers,
                      child: const Text('ذخیره زمان‌بندی'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
