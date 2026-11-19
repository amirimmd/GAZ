import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/failures.dart';
import '../../core/security/document_crypto_store.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../local/database/app_database.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  DocumentRepositoryImpl(this._db, {DocumentCryptoStore? store})
      : _store = store ?? DocumentCryptoStore();

  final AppDatabase _db;
  final DocumentCryptoStore _store;
  static const _uuid = Uuid();
  static const maxUploadBytes = 50 * 1024 * 1024;

  @override
  Future<Result<List<DocumentEntity>>> listByEmployee(String employeeId) async {
    try {
      final rows = await (_db.select(_db.employeeDocuments)
            ..where(
              (d) => d.employeeId.equals(employeeId) & d.deletedAt.isNull(),
            )
            ..orderBy([(d) => OrderingTerm.desc(d.uploadedAt)]))
          .get();
      return Success(rows.map(_map).toList());
    } catch (e) {
      return Err(StorageFailure('خواندن اسناد ناموفق: $e'));
    }
  }

  @override
  Future<Result<List<DocumentEntity>>> listAll([
    DocumentListQuery query = const DocumentListQuery(),
  ]) async {
    try {
      final q = _db.select(_db.employeeDocuments).join([
        innerJoin(
          _db.employees,
          _db.employees.id.equalsExp(_db.employeeDocuments.employeeId),
        ),
      ])
        ..where(_db.employeeDocuments.deletedAt.isNull())
        ..where(_db.employees.deletedAt.isNull())
        ..orderBy([OrderingTerm.desc(_db.employeeDocuments.uploadedAt)]);

      if (query.employeeId != null && query.employeeId!.isNotEmpty) {
        q.where(_db.employeeDocuments.employeeId.equals(query.employeeId!));
      }
      if (query.category != null) {
        q.where(_db.employeeDocuments.category.equals(query.category!.code));
      }
      if (query.fromUploadedAt != null) {
        q.where(
          _db.employeeDocuments.uploadedAt.isBiggerOrEqualValue(
            query.fromUploadedAt!.toUtc().millisecondsSinceEpoch,
          ),
        );
      }
      if (query.toUploadedAt != null) {
        q.where(
          _db.employeeDocuments.uploadedAt.isSmallerOrEqualValue(
            query.toUploadedAt!.toUtc().millisecondsSinceEpoch,
          ),
        );
      }

      final rows = await q.get();
      var list = rows.map((row) {
        final doc = row.readTable(_db.employeeDocuments);
        final emp = row.readTable(_db.employees);
        return _map(
          doc,
          employeeName: '${emp.firstName} ${emp.lastName}'.trim(),
        );
      }).toList();

      if (query.searchText != null && query.searchText!.trim().isNotEmpty) {
        final t = query.searchText!.trim().toLowerCase();
        list = list
            .where(
              (d) =>
                  d.title.toLowerCase().contains(t) ||
                  d.fileName.toLowerCase().contains(t) ||
                  (d.employeeName ?? '').toLowerCase().contains(t) ||
                  d.tags.any((tag) => tag.toLowerCase().contains(t)),
            )
            .toList();
      }
      if (query.tag != null && query.tag!.trim().isNotEmpty) {
        final tag = query.tag!.trim().toLowerCase();
        list = list
            .where((d) => d.tags.any((x) => x.toLowerCase() == tag))
            .toList();
      }
      return Success(list);
    } catch (e) {
      return Err(StorageFailure('خواندن اسناد ناموفق: $e'));
    }
  }

  @override
  Future<Result<DocumentEntity>> upload({
    required String employeeId,
    required String title,
    required DocumentCategory category,
    required String fileName,
    required String mimeType,
    required Uint8List bytes,
    required String uploadedBy,
    String? description,
    List<String> tags = const [],
  }) async {
    try {
      if (employeeId.isEmpty || employeeId == 'new') {
        return const Err(
          ValidationFailure('ابتدا کارمند را ذخیره کنید'),
        );
      }
      if (title.trim().isEmpty) {
        return const Err(ValidationFailure('عنوان سند الزامی است'));
      }
      if (bytes.isEmpty) {
        return const Err(ValidationFailure('فایل خالی است'));
      }
      if (bytes.length > maxUploadBytes) {
        return const Err(
          ValidationFailure('حجم فایل بیش از ۵۰ مگابایت است'),
        );
      }

      final stored = await _store.store(
        employeeId: employeeId,
        fileName: fileName,
        plaintext: bytes,
      );
      if (stored.isFailure) return Err(stored.failureOrNull!);

      final id = _uuid.v4();
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      final cleanTags =
          tags.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      await _db.into(_db.employeeDocuments).insert(
            EmployeeDocumentsCompanion.insert(
              id: id,
              employeeId: employeeId,
              title: title.trim(),
              category: category.code,
              description: Value(description),
              tagsJson: Value(jsonEncode(cleanTags)),
              fileName: fileName,
              mimeType: mimeType,
              fileSize: bytes.length,
              storagePath: stored.valueOrNull!.storagePath,
              contentHash: stored.valueOrNull!.contentHash,
              uploadedBy: Value(uploadedBy),
              uploadedAt: now,
            ),
          );

      final row = await (_db.select(_db.employeeDocuments)
            ..where((d) => d.id.equals(id)))
          .getSingle();
      return Success(_map(row));
    } catch (e) {
      return Err(StorageFailure('آپلود سند ناموفق: $e'));
    }
  }

  @override
  Future<Result<Uint8List>> download(String documentId) async {
    try {
      final row = await (_db.select(_db.employeeDocuments)
            ..where((d) => d.id.equals(documentId) & d.deletedAt.isNull()))
          .getSingleOrNull();
      if (row == null) {
        return const Err(NotFoundFailure('سند یافت نشد'));
      }
      return _store.read(
        employeeId: row.employeeId,
        storagePath: row.storagePath,
        expectedHash: row.contentHash,
      );
    } catch (e) {
      return Err(StorageFailure('دانلود سند ناموفق: $e'));
    }
  }

  @override
  Future<Result<void>> softDelete(String documentId) async {
    try {
      final row = await (_db.select(_db.employeeDocuments)
            ..where((d) => d.id.equals(documentId) & d.deletedAt.isNull()))
          .getSingleOrNull();
      if (row == null) {
        return const Err(NotFoundFailure('سند یافت نشد'));
      }

      final del = await _store.deleteFile(row.storagePath);
      if (del.isFailure) return Err(del.failureOrNull!);

      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      await (_db.update(_db.employeeDocuments)
            ..where((d) => d.id.equals(documentId)))
          .write(EmployeeDocumentsCompanion(deletedAt: Value(now)));
      return const Success(null);
    } catch (e) {
      return Err(StorageFailure('حذف سند ناموفق: $e'));
    }
  }

  DocumentEntity _map(EmployeeDocument row, {String? employeeName}) {
    List<String> tags = const [];
    if (row.tagsJson != null && row.tagsJson!.isNotEmpty) {
      try {
        tags = (jsonDecode(row.tagsJson!) as List).cast<String>();
      } catch (_) {}
    }
    return DocumentEntity(
      id: row.id,
      employeeId: row.employeeId,
      title: row.title,
      category: DocumentCategory.values.firstWhere(
        (c) => c.code == row.category,
        orElse: () => DocumentCategory.other,
      ),
      description: row.description,
      tags: tags,
      fileName: row.fileName,
      mimeType: row.mimeType,
      fileSize: row.fileSize,
      storagePath: row.storagePath,
      contentHash: row.contentHash,
      version: row.version,
      uploadedBy: row.uploadedBy,
      uploadedAt:
          DateTime.fromMillisecondsSinceEpoch(row.uploadedAt, isUtc: true),
      employeeName: employeeName,
    );
  }
}
