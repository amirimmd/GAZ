import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import '../../../core/constants/permission_codes.dart';
import '../../../core/security/session_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/open_saved_file.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/document_entity.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/permission_gate.dart';

final employeeDocumentsProvider = FutureProvider.autoDispose
    .family<List<DocumentEntity>, String>((ref, employeeId) async {
  if (employeeId.isEmpty || employeeId == 'new') return const [];
  final result =
      await ref.watch(documentRepositoryProvider).listByEmployee(employeeId);
  return result.fold((f) => throw f, (list) => list);
});

class EmployeeDocumentsTab extends ConsumerStatefulWidget {
  const EmployeeDocumentsTab({required this.employeeId, super.key});

  final String employeeId;

  @override
  ConsumerState<EmployeeDocumentsTab> createState() =>
      _EmployeeDocumentsTabState();
}

class _EmployeeDocumentsTabState extends ConsumerState<EmployeeDocumentsTab> {
  bool get _canUpload =>
      widget.employeeId.isNotEmpty && widget.employeeId != 'new';

  Future<void> _showUploadDialog() async {
    if (!_canUpload) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ابتدا کارمند را ذخیره کنید، سپس سند آپلود کنید'),
        ),
      );
      return;
    }

    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final tagCtrl = TextEditingController();
    var category = DocumentCategory.other;
    PlatformFile? picked;
    var uploading = false;
    final tags = <String>[];

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return AlertDialog(
              title: const Text('آپلود سند'),
              content: SizedBox(
                width: 460,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'عنوان سند *',
                        ),
                      ),
                      const SizedBox(height: GazSpacing.md),
                      DropdownButtonFormField<DocumentCategory>(
                        value: category,
                        decoration:
                            const InputDecoration(labelText: 'دسته‌بندی'),
                        items: [
                          for (final c in DocumentCategory.values)
                            DropdownMenuItem(
                              value: c,
                              child: Text(c.labelFa),
                            ),
                        ],
                        onChanged: (v) {
                          if (v != null) setLocal(() => category = v);
                        },
                      ),
                      const SizedBox(height: GazSpacing.md),
                      TextField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(labelText: 'توضیحات'),
                      ),
                      const SizedBox(height: GazSpacing.md),
                      TextField(
                        controller: tagCtrl,
                        decoration: InputDecoration(
                          labelText: 'تگ',
                          hintText: 'Enter برای افزودن',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              final t = tagCtrl.text.trim();
                              if (t.isEmpty || tags.contains(t)) return;
                              setLocal(() {
                                tags.add(t);
                                tagCtrl.clear();
                              });
                            },
                          ),
                        ),
                        onSubmitted: (v) {
                          final t = v.trim();
                          if (t.isEmpty || tags.contains(t)) return;
                          setLocal(() {
                            tags.add(t);
                            tagCtrl.clear();
                          });
                        },
                      ),
                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: [
                            for (final t in tags)
                              InputChip(
                                label: Text(t),
                                onDeleted: () =>
                                    setLocal(() => tags.remove(t)),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: GazSpacing.md),
                      OutlinedButton.icon(
                        onPressed: uploading
                            ? null
                            : () async {
                                final result =
                                    await FilePicker.platform.pickFiles(
                                  withData: true,
                                  type: FileType.custom,
                                  allowedExtensions: const [
                                    'pdf',
                                    'doc',
                                    'docx',
                                    'xls',
                                    'xlsx',
                                    'jpg',
                                    'jpeg',
                                    'png',
                                    'webp',
                                    'zip',
                                    'mp4',
                                    'avi',
                                    'mov',
                                  ],
                                );
                                if (result != null &&
                                    result.files.isNotEmpty) {
                                  setLocal(() {
                                    picked = result.files.first;
                                    if (titleCtrl.text.trim().isEmpty) {
                                      titleCtrl.text =
                                          p.basenameWithoutExtension(
                                        picked!.name,
                                      );
                                    }
                                  });
                                }
                              },
                        icon: const Icon(Icons.attach_file),
                        label: Text(
                          picked == null ? 'انتخاب فایل' : picked!.name,
                        ),
                      ),
                      if (picked != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _formatSize(picked!.size),
                          style: Theme.of(ctx).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: uploading ? null : () => Navigator.pop(ctx),
                  child: const Text('انصراف'),
                ),
                FilledButton(
                  onPressed: uploading
                      ? null
                      : () async {
                          var title = titleCtrl.text.trim();
                          if (picked == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('فایل را انتخاب کنید'),
                              ),
                            );
                            return;
                          }
                          Uint8List? bytes = picked!.bytes != null
                              ? Uint8List.fromList(picked!.bytes!)
                              : null;
                          if ((bytes == null || bytes.isEmpty) &&
                              picked!.path != null) {
                            try {
                              bytes = await File(picked!.path!).readAsBytes();
                            } catch (_) {}
                          }
                          if (bytes == null || bytes.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'خواندن فایل ممکن نشد؛ فایل کوچک‌تر انتخاب کنید',
                                ),
                              ),
                            );
                            return;
                          }
                          if (title.isEmpty) {
                            title = p.basenameWithoutExtension(picked!.name);
                          }
                          setLocal(() => uploading = true);
                          final session = ref.read(sessionControllerProvider);
                          final mime = lookupMimeType(picked!.name) ??
                              'application/octet-stream';
                          final result =
                              await ref.read(documentRepositoryProvider).upload(
                                    employeeId: widget.employeeId,
                                    title: title,
                                    category: category,
                                    fileName: picked!.name,
                                    mimeType: mime,
                                    bytes: bytes,
                                    uploadedBy:
                                        session?.user.username ?? 'unknown',
                                    description: descCtrl.text.trim().isEmpty
                                        ? null
                                        : descCtrl.text.trim(),
                                    tags: List.of(tags),
                                  );
                          if (!ctx.mounted) return;
                          setLocal(() => uploading = false);
                          result.fold(
                            (f) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(f.message)),
                              );
                            },
                            (_) {
                              Navigator.pop(ctx);
                              ref.invalidate(
                                employeeDocumentsProvider(widget.employeeId),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'سند با موفقیت آپلود و رمزنگاری شد',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                  child: uploading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('آپلود'),
                ),
              ],
            );
          },
        );
      },
    );

    titleCtrl.dispose();
    descCtrl.dispose();
    tagCtrl.dispose();
  }

  Future<void> _download(DocumentEntity doc) async {
    final result =
        await ref.read(documentRepositoryProvider).download(doc.id);
    await result.fold(
      (f) async {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(f.message)),
        );
      },
      (bytes) async {
        final opened = await saveAndOpenFile(
          bytes: bytes,
          fileName: doc.fileName,
          mimeType: doc.mimeType,
        );
        if (!mounted) return;
        if (!opened.ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(opened.error ?? 'باز کردن سند ناموفق بود')),
          );
        }
      },
    );
  }

  Future<void> _delete(DocumentEntity doc) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف سند'),
        content: Text('سند «${doc.title}» حذف شود؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final result =
        await ref.read(documentRepositoryProvider).softDelete(doc.id);
    if (!mounted) return;
    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(f.message)),
      ),
      (_) {
        ref.invalidate(employeeDocumentsProvider(widget.employeeId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('سند حذف شد')),
        );
      },
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _iconFor(String mime) {
    if (mime.startsWith('image/')) return Icons.image_outlined;
    if (mime.startsWith('video/')) return Icons.videocam_outlined;
    if (mime.contains('pdf')) return Icons.picture_as_pdf_outlined;
    if (mime.contains('sheet') || mime.contains('excel')) {
      return Icons.table_chart_outlined;
    }
    if (mime.contains('word') || mime.contains('document')) {
      return Icons.description_outlined;
    }
    if (mime.contains('zip')) return Icons.folder_zip_outlined;
    return Icons.insert_drive_file_outlined;
  }

  @override
  Widget build(BuildContext context) {
    if (!_canUpload) {
      return Card(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(GazSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.folder_off_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: GazSpacing.md),
                Text(
                  'ابتدا کارمند را ذخیره کنید تا بتوانید اسناد را آپلود کنید.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final asyncDocs =
        ref.watch(employeeDocumentsProvider(widget.employeeId));

    final canView = hasSessionPermission(ref, PermissionCodes.documentsView);
    final canUpload =
        hasSessionPermission(ref, PermissionCodes.documentsUpload);
    final canDownload =
        hasSessionPermission(ref, PermissionCodes.documentsDownload);
    final canDelete =
        hasSessionPermission(ref, PermissionCodes.documentsDelete);

    if (!canView) {
      return const Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(GazSpacing.xl),
            child: Text('دسترسی مشاهده اسناد ندارید'),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (context.isNarrow)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'اسناد کارمند',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (canUpload) ...[
                const SizedBox(height: GazSpacing.sm),
                FilledButton.icon(
                  onPressed: _showUploadDialog,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('آپلود سند'),
                ),
              ],
            ],
          )
        else
          Row(
            children: [
              Text(
                'اسناد کارمند',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (canUpload)
                FilledButton.icon(
                  onPressed: _showUploadDialog,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('آپلود سند'),
                ),
            ],
          ),
        const SizedBox(height: GazSpacing.sm),
        Text(
          'فایل‌ها به‌صورت AES-256 رمزنگاری و ذخیره می‌شوند.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: GazSpacing.md),
        Expanded(
          child: asyncDocs.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطا: $e')),
            data: (docs) {
              if (docs.isEmpty) {
                return Card(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_upload_outlined, size: 48),
                        const SizedBox(height: GazSpacing.md),
                        const Text('سندی ثبت نشده است'),
                        if (canUpload) ...[
                          const SizedBox(height: GazSpacing.md),
                          FilledButton.tonalIcon(
                            onPressed: _showUploadDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('اولین سند را آپلود کنید'),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }

              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final doc = docs[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.4),
                        child: Icon(_iconFor(doc.mimeType)),
                      ),
                      title: Text(doc.title),
                      subtitle: Text(
                        [
                          doc.category.labelFa,
                          doc.fileName,
                          _formatSize(doc.fileSize),
                          if (doc.tags.isNotEmpty) doc.tags.join('، '),
                        ].join(' • '),
                      ),
                      onTap: canDownload ? () => _download(doc) : null,
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          if (canDownload)
                            IconButton(
                              tooltip: 'دانلود / باز کردن',
                              onPressed: () => _download(doc),
                              icon: const Icon(Icons.download_outlined),
                            ),
                          if (canDelete)
                            IconButton(
                              tooltip: 'حذف',
                              onPressed: () => _delete(doc),
                              icon: const Icon(Icons.delete_outline),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
