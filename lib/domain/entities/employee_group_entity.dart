import 'package:equatable/equatable.dart';

import 'employee_entity.dart';

enum GroupPurposeType {
  mission,
  training,
  committee,
  project,
  other,
}

extension GroupPurposeTypeX on GroupPurposeType {
  String get code => name;

  String get labelFa => switch (this) {
        GroupPurposeType.mission => 'مأموریت',
        GroupPurposeType.training => 'آموزش',
        GroupPurposeType.committee => 'کمیته',
        GroupPurposeType.project => 'پروژه',
        GroupPurposeType.other => 'سایر',
      };

  static GroupPurposeType fromCode(String code) =>
      GroupPurposeType.values.firstWhere(
        (e) => e.name == code,
        orElse: () => GroupPurposeType.other,
      );
}

enum GroupStatus { active, archived }

extension GroupStatusX on GroupStatus {
  String get code => name;

  String get labelFa => switch (this) {
        GroupStatus.active => 'فعال',
        GroupStatus.archived => 'بایگانی',
      };

  static GroupStatus fromCode(String code) => GroupStatus.values.firstWhere(
        (e) => e.name == code,
        orElse: () => GroupStatus.active,
      );
}

class EmployeeGroupEntity extends Equatable {
  const EmployeeGroupEntity({
    required this.id,
    required this.name,
    required this.purposeType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.startsAt,
    this.endsAt,
    this.createdBy,
    this.photoPath,
    this.memberCount = 0,
    this.members = const [],
  });

  final String id;
  final String name;
  final String? description;
  final GroupPurposeType purposeType;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final GroupStatus status;
  final String? createdBy;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int memberCount;
  final List<EmployeeEntity> members;

  EmployeeGroupEntity copyWith({
    String? id,
    String? name,
    String? description,
    GroupPurposeType? purposeType,
    DateTime? startsAt,
    DateTime? endsAt,
    GroupStatus? status,
    String? createdBy,
    String? photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? memberCount,
    List<EmployeeEntity>? members,
  }) {
    return EmployeeGroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      purposeType: purposeType ?? this.purposeType,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      memberCount: memberCount ?? this.memberCount,
      members: members ?? this.members,
    );
  }

  @override
  List<Object?> get props => [id, name, status, updatedAt, memberCount];
}

class GroupQuery extends Equatable {
  const GroupQuery({
    this.searchText,
    this.status,
    this.purposeType,
  });

  final String? searchText;
  final GroupStatus? status;
  final GroupPurposeType? purposeType;

  @override
  List<Object?> get props => [searchText, status, purposeType];
}
