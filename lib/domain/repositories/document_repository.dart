import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../core/errors/failures.dart';
import '../entities/document_entity.dart';

class DocumentListQuery extends Equatable {
  const DocumentListQuery({
    this.employeeId,
    this.category,
    this.tag,
    this.searchText,
    this.fromUploadedAt,
    this.toUploadedAt,
  });

  final String? employeeId;
  final DocumentCategory? category;
  final String? tag;
  final String? searchText;
  final DateTime? fromUploadedAt;
  final DateTime? toUploadedAt;

  @override
  List<Object?> get props =>
      [employeeId, category, tag, searchText, fromUploadedAt, toUploadedAt];
}

abstract class DocumentRepository {
  Future<Result<List<DocumentEntity>>> listByEmployee(String employeeId);

  Future<Result<List<DocumentEntity>>> listAll([
    DocumentListQuery query = const DocumentListQuery(),
  ]);

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
  });

  Future<Result<Uint8List>> download(String documentId);

  Future<Result<void>> softDelete(String documentId);
}
