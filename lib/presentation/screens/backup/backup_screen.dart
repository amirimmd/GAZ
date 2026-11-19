import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/security/backup_service.dart';
import '../../../core/security/photo_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../providers/repository_providers.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  String _schedule = 'weekly';
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  String? _status;
  List<File> _backups = [];

  final _service = BackupService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final schedule = prefs.getString('gaz_backup_schedule') ?? 'weekly';
    final seen = <String>{};
    final files = <File>[];
    for (final dir in [
      await _service.visibleBackupsDir(),
      await _service.backupsDir(),
    ]) {
      if (!dir.existsSync()) continue;
      for (final f in dir.listSync().whereType<File>()) {
        if (!f.path.endsWith('.gazbak')) continue;
        if (seen.add(p.basename(f.path))) files.add(f);
      }
    }
    files.sort((a, b) => b.path.compareTo(a.path));
    if (!mounted) return;
    setState(() {
      _schedule = schedule;
      _backups = files;
    });
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<File> _dbFile() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, AppConstants.dbFileName));
  }

  Future<Directory> _docsDir() async {
    final support = await getApplicationSupportDirectory();
    final dir = Directory(p.join(support.path, AppConstants.encryptedDocsDir));
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  Future<Directory> _photosDir() => PhotoStore.rootDir();

  Future<void> _createBackup() async {
    final password = _passwordCtrl.text.trim();
    if (password.length < 6) {
      setState(() => _status = 'رمز پشتیبان حداقل ۶ کاراکتر باشد');
      return;
    }
    setState(() {
      _busy = true;
      _status = null;
    });
    final result = await _service.createBackup(
      databaseFile: await _dbFile(),
      documentsDir: await _docsDir(),
      photosDir: await _photosDir(),
      password: password,
    );
    if (!mounted) return;
    await result.fold<Future<void>>(
      (f) async {
        setState(() {
          _busy = false;
          _status = f.message;
        });
      },
      (file) async {
        setState(() {
          _busy = false;
          _status =
              'پشتیبان ذخیره شد.\nبرای انتقال به گوشی دیگر، فایل را اشتراک بگذارید و همان رمز را وارد کنید.\n${file.path}';
        });
        await _load();
        await _shareBackup(file);
      },
    );
  }

  Future<void> _shareBackup(File file) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/octet-stream')],
        text: 'پشتیبان سامانه قائم‌شهر — با همان رمز پشتیبان بازیابی شود',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'اشتراک ناموفق: $e');
    }
  }

  Future<void> _restore() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['gazbak'],
      withData: false,
    );
    if (picked == null || picked.files.isEmpty) return;
    final path = picked.files.first.path;
    if (path == null) {
      setState(() => _status = 'مسیر فایل نامعتبر است');
      return;
    }
    await _restoreFromFile(path);
  }

  Future<void> _restoreFromFile(String path) async {
    final password = _passwordCtrl.text.trim();
    if (password.isEmpty) {
      setState(() => _status = 'رمز پشتیبان را وارد کنید');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('بازیابی پشتیبان'),
        content: const Text(
          'بازیابی، پایگاه داده فعلی را جایگزین می‌کند. '
          'روی گوشی دیگر هم با همین رمز کار می‌کند. ادامه می‌دهید؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('بازیابی'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final db = ref.read(appDatabaseProvider);
      await db.close();
    } catch (_) {}
    final result = await _service.restoreBackup(
      backupFile: File(path),
      password: password,
      targetDb: await _dbFile(),
      targetDocs: await _docsDir(),
      targetPhotos: await _photosDir(),
    );
    ref.invalidate(appDatabaseProvider);
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _busy = false;
        _status = f.message;
      }),
      (_) => setState(() {
        _busy = false;
        _status =
            'بازیابی موفق بود. برنامه را کامل ببندید و دوباره باز کنید تا داده‌ها بارگذاری شوند.';
      }),
    );
  }

  Future<void> _validate() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['gazbak'],
    );
    if (picked == null || picked.files.isEmpty) return;
    final path = picked.files.first.path;
    if (path == null) return;
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final raw = await File(path).readAsString();
      if (!raw.contains('"manifest"') || !raw.contains('"payload"')) {
        setState(() {
          _busy = false;
          _status = 'ساختار فایل پشتیبان نامعتبر است';
        });
        return;
      }
      final password = _passwordCtrl.text.trim();
      if (password.isEmpty) {
        setState(() {
          _busy = false;
          _status = 'برای اعتبارسنجی کامل، رمز را وارد کنید';
        });
        return;
      }
      // Dry-run restore to temp files
      final tmp = await getTemporaryDirectory();
      final tmpDb = File(p.join(tmp.path, 'validate_db.tmp'));
      final tmpDocs = Directory(p.join(tmp.path, 'validate_docs'));
      final tmpPhotos = Directory(p.join(tmp.path, 'validate_photos'));
      if (tmpDocs.existsSync()) {
        await tmpDocs.delete(recursive: true);
      }
      if (tmpPhotos.existsSync()) {
        await tmpPhotos.delete(recursive: true);
      }
      await tmpDocs.create(recursive: true);
      await tmpPhotos.create(recursive: true);
      final result = await _service.restoreBackup(
        backupFile: File(path),
        password: password,
        targetDb: tmpDb,
        targetDocs: tmpDocs,
        targetPhotos: tmpPhotos,
        applyKeys: false,
      );
      if (!mounted) return;
      result.fold(
        (f) => setState(() {
          _busy = false;
          _status = 'نامعتبر: ${f.message}';
        }),
        (_) => setState(() {
          _busy = false;
          _status =
              'فایل معتبر است (امضا، هش، رمز، اسناد و عکس‌ها تأیید شد)';
        }),
      );
      if (tmpDb.existsSync()) await tmpDb.delete();
      if (tmpDocs.existsSync()) await tmpDocs.delete(recursive: true);
      if (tmpPhotos.existsSync()) await tmpPhotos.delete(recursive: true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = 'خطا در اعتبارسنجی: $e';
      });
    }
  }

  Future<void> _saveSchedule(String value) async {
    setState(() => _schedule = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gaz_backup_schedule', value);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: context.pagePadding,
      child: ListView(
        children: [
          Text(
            'پشتیبان‌گیری و بازیابی',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: GazSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(GazSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'پشتیبان کامل (داده، اسناد و کلیدها) با رمز ساخته می‌شود. '
                    'پس از ساخت، فایل را اشتراک بگذارید و روی گوشی دیگر از «بازیابی» '
                    'همان فایل را با همان رمز باز کنید. '
                    'کپی محلی در Downloads/GAZ_HRMS_Backups هم ذخیره می‌شود.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: GazSpacing.lg),
                  TextField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'رمز پشتیبان',
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: GazSpacing.md),
                  DropdownButtonFormField<String>(
                    value: _schedule,
                    decoration: const InputDecoration(
                      labelText: 'زمان‌بندی پیشنهادی',
                      helperText: 'یادآوری محلی — پشتیبان دستی را فراموش نکنید',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'daily', child: Text('روزانه')),
                      DropdownMenuItem(value: 'weekly', child: Text('هفتگی')),
                      DropdownMenuItem(value: 'monthly', child: Text('ماهانه')),
                    ],
                    onChanged: (v) {
                      if (v != null) _saveSchedule(v);
                    },
                  ),
                  const SizedBox(height: GazSpacing.lg),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: _busy ? null : _createBackup,
                        icon: const Icon(Icons.backup),
                        label: Text(_busy ? 'لطفاً صبر کنید...' : 'پشتیبان دستی'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _busy ? null : _restore,
                        icon: const Icon(Icons.restore),
                        label: const Text('بازیابی'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _busy ? null : _validate,
                        icon: const Icon(Icons.verified_user),
                        label: const Text('اعتبارسنجی فایل'),
                      ),
                    ],
                  ),
                  if (_status != null) ...[
                    const SizedBox(height: GazSpacing.md),
                    Text(
                      _status!,
                      style: TextStyle(color: scheme.primary),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: GazSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(GazSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'فایل‌های پشتیبان محلی',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: GazSpacing.sm),
                  if (_backups.isEmpty)
                    const Text('هنوز پشتیبانی ساخته نشده است')
                  else
                    for (final f in _backups)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.folder_zip_outlined),
                        title: Text(
                          p.basename(f.path),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${(f.lengthSync() / 1024).toStringAsFixed(1)} KB',
                        ),
                        trailing: Wrap(
                          spacing: 0,
                          children: [
                            IconButton(
                              tooltip: 'اشتراک',
                              onPressed: _busy ? null : () => _shareBackup(f),
                              icon: const Icon(Icons.share_outlined),
                            ),
                            IconButton(
                              tooltip: 'بازیابی',
                              onPressed:
                                  _busy ? null : () => _restoreFromFile(f.path),
                              icon: const Icon(Icons.restore),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
