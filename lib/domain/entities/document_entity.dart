import 'package:equatable/equatable.dart';

enum DocumentCategory {
  employmentOrders,
  contracts,
  nationalCard,
  birthCertificate,
  educationDocuments,
  certificates,
  awards,
  letters,
  insuranceDocuments,
  other,
}

extension DocumentCategoryX on DocumentCategory {
  String get code => name;

  String get labelFa => switch (this) {
        DocumentCategory.employmentOrders => 'احکام کارگزینی',
        DocumentCategory.contracts => 'قراردادها',
        DocumentCategory.nationalCard => 'کارت ملی',
        DocumentCategory.birthCertificate => 'شناسنامه',
        DocumentCategory.educationDocuments => 'مدارک تحصیلی',
        DocumentCategory.certificates => 'گواهینامه‌ها',
        DocumentCategory.awards => 'تشویق‌ها',
        DocumentCategory.letters => 'نامه‌ها',
        DocumentCategory.insuranceDocuments => 'مدارک بیمه',
        DocumentCategory.other => 'سایر',
      };
}

class DocumentEntity extends Equatable {
  const DocumentEntity({
    required this.id,
    required this.employeeId,
    required this.title,
    required this.category,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
    required this.storagePath,
    required this.contentHash,
    required this.version,
    required this.uploadedAt,
    this.description,
    this.tags = const [],
    this.uploadedBy,
    this.employeeName,
  });

  final String id;
  final String employeeId;
  final String title;
  final DocumentCategory category;
  final String? description;
  final List<String> tags;
  final String fileName;
  final String mimeType;
  final int fileSize;
  final String storagePath;
  final String contentHash;
  final int version;
  final String? uploadedBy;
  final DateTime uploadedAt;
  final String? employeeName;

  @override
  List<Object?> get props => [id, employeeId, contentHash, version];
}

class AuditLogEntity extends Equatable {
  const AuditLogEntity({
    required this.id,
    required this.action,
    required this.createdAt,
    this.actorUserId,
    this.actorUsername,
    this.entityType,
    this.entityId,
    this.detailsJson,
    this.deviceInfo,
  });

  final String id;
  final String? actorUserId;
  final String? actorUsername;
  final String action;
  final String? entityType;
  final String? entityId;
  final String? detailsJson;
  final String? deviceInfo;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, action, createdAt];
}
