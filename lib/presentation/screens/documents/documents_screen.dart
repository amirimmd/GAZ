import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/permission_codes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/open_saved_file.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/document_entity.dart';
import '../../../domain/repositories/document_repository.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/permission_gate.dart';

final documentsFilterProvider = StateProvider<DocumentListQuery>(
  (ref) => const DocumentListQuery(),
);

final documentsListProvider =
    FutureProvider.autoDispose<List<DocumentEntity>>((ref) async {
  final query = ref.watch(documentsFilterProvider);
  final result = await ref.watch(documentRepositoryProvider).listAll(query);
  return result.fold((f) => throw f, (list) => list);
});

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  final _searchCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  void _applyFilter({
    String? searchText,
    String? tag,
    DocumentCategory? category,
    bool clearCategory = false,
  }) {
    final current = ref.read(documentsFilterProvider);
    ref.read(documentsFilterProvider.notifier).state = DocumentListQuery(
      searchText: searchText ?? current.searchText,
      tag: tag ?? current.tag,
      category: clearCategory ? null : (category ?? current.category),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _openDocument(DocumentEntity doc) async {
    final result = await ref.read(documentRepositoryProvider).download(doc.id);
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
        ref.invalidate(documentsListProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('سند حذف شد')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(documentsFilterProvider);
    final asyncList = ref.watch(documentsListProvider);
    final df = DateFormat('yyyy/MM/dd HH:mm');

    return Padding(
      padding: context.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'اسناد',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: GazSpacing.md),
          Wrap(
            spacing: GazSpacing.sm,
            runSpacing: GazSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 260,
                child: TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                    hintText: 'جستجو عنوان / فایل / کارمند',
                    prefixIcon: Icon(Icons.search),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) => _applyFilter(
                    searchText: v.trim().isEmpty ? null : v.trim(),
                  ),
                ),
              ),
              SizedBox(
                width: 160,
                child: TextField(
                  controller: _tagCtrl,
                  decoration: const InputDecoration(
                    hintText: 'تگ دقیق',
                    prefixIcon: Icon(Icons.sell_outlined),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) => _applyFilter(
                    tag: v.trim().isEmpty ? null : v.trim(),
                  ),
                ),
              ),
              DropdownButton<DocumentCategory?>(
                value: filter.category,
                hint: const Text('دسته‌بندی'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('همه')),
                  for (final c in DocumentCategory.values)
                    DropdownMenuItem(value: c, child: Text(c.labelFa)),
                ],
                onChanged: (v) {
                  ref.read(documentsFilterProvider.notifier).state =
                      DocumentListQuery(
                    searchText: filter.searchText,
                    tag: filter.tag,
                    category: v,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: GazSpacing.md),
          Expanded(
            child: asyncList.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('خطا: $e', textAlign: TextAlign.center),
                    const SizedBox(height: GazSpacing.md),
                    FilledButton(
                      onPressed: () => ref.invalidate(documentsListProvider),
                      child: const Text('تلاش مجدد'),
                    ),
                  ],
                ),
              ),
              data: (docs) {
                if (docs.isEmpty) {
                  return const Center(child: Text('سندی یافت نشد'));
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final doc = docs[i];
                      return ListTile(
                        title: Text(doc.title),
                        subtitle: Text(
                          [
                            doc.employeeName ?? doc.employeeId,
                            doc.category.labelFa,
                            _formatSize(doc.fileSize),
                            df.format(doc.uploadedAt.toLocal()),
                            if (doc.tags.isNotEmpty) doc.tags.join('، '),
                          ].join(' · '),
                        ),
                        onTap: () => _openDocument(doc),
                        trailing: Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              tooltip: 'پروفایل کارمند',
                              onPressed: () =>
                                  context.push('/employees/${doc.employeeId}'),
                              icon: const Icon(Icons.person_outline),
                            ),
                            PermissionGate(
                              permission: PermissionCodes.documentsDownload,
                              child: IconButton(
                                tooltip: 'دانلود / باز کردن',
                                onPressed: () => _openDocument(doc),
                                icon: const Icon(Icons.download_outlined),
                              ),
                            ),
                            PermissionGate(
                              permission: PermissionCodes.documentsDelete,
                              child: IconButton(
                                tooltip: 'حذف',
                                onPressed: () => _delete(doc),
                                icon: const Icon(Icons.delete_outline),
                              ),
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
      ),
    );
  }
}
