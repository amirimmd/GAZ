import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  const EmployeeEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nationalId,
    this.fatherName,
    this.birthDate,
    this.birthPlace,
    this.gender,
    this.maritalStatus,
    this.childrenCount = 0,
    this.bloodGroup,
    this.militaryStatus,
    this.personalDescription,
    this.photoPath,
    this.employeeNumber,
    this.subscriptionNumber,
    this.departmentId,
    this.unitId,
    this.currentPosition,
    this.previousPosition,
    this.desiredPosition,
    this.employmentType,
    this.employmentDate,
    this.supervisorId,
    this.employmentStatus = 'active',
    this.personType = 'staff',
    this.retirementDate,
    this.inactiveReason,
    this.jobGroup,
    this.positionBase,
    this.personalBase,
    this.contact,
    this.social,
    this.interests,
    this.educations = const [],
    this.skills = const [],
    this.insurances = const [],
    this.evaluations = const [],
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? fatherName;
  final String nationalId;
  final String? birthDate;
  final String? birthPlace;
  final String? gender;
  final String? maritalStatus;
  final int childrenCount;
  final String? bloodGroup;
  final String? militaryStatus;
  final String? personalDescription;
  final String? photoPath;
  final String? employeeNumber;
  final String? subscriptionNumber;
  final String? departmentId;
  final String? unitId;
  final String? currentPosition;
  final String? previousPosition;
  final String? desiredPosition;
  final String? employmentType;
  final String? employmentDate;
  final String? supervisorId;
  final String employmentStatus;
  final String personType;
  final String? retirementDate;
  final String? inactiveReason;
  final String? jobGroup;
  final double? positionBase;
  final double? personalBase;
  final ContactInfo? contact;
  final SocialInfo? social;
  final InterestsInfo? interests;
  final List<EducationInfo> educations;
  final List<SkillInfo> skills;
  final List<InsuranceInfo> insurances;
  final List<EvaluationInfo> evaluations;

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, nationalId, employeeNumber, fullName];
}

class ContactInfo extends Equatable {
  const ContactInfo({
    this.primaryPhone,
    this.secondaryPhone,
    this.emergencyPhone,
    this.email,
    this.homeAddress,
    this.postalCode,
  });

  final String? primaryPhone;
  final String? secondaryPhone;
  final String? emergencyPhone;
  final String? email;
  final String? homeAddress;
  final String? postalCode;

  @override
  List<Object?> get props =>
      [primaryPhone, secondaryPhone, emergencyPhone, email, homeAddress, postalCode];
}

class SocialInfo extends Equatable {
  const SocialInfo({
    this.telegram,
    this.whatsapp,
    this.instagram,
    this.linkedin,
    this.otherLinks = const [],
  });

  final String? telegram;
  final String? whatsapp;
  final String? instagram;
  final String? linkedin;
  final List<String> otherLinks;

  @override
  List<Object?> get props =>
      [telegram, whatsapp, instagram, linkedin, otherLinks];
}

class InterestsInfo extends Equatable {
  const InterestsInfo({
    this.careerInterests,
    this.technicalInterests,
    this.managementInterests,
    this.personalInterests,
    this.talentAssessment,
    this.behaviorAssessment,
    this.psychologicalNotes,
    this.managerNotes,
  });

  final String? careerInterests;
  final String? technicalInterests;
  final String? managementInterests;
  final String? personalInterests;
  final String? talentAssessment;
  final String? behaviorAssessment;
  final String? psychologicalNotes;
  final String? managerNotes;

  @override
  List<Object?> get props => [
        careerInterests,
        technicalInterests,
        managementInterests,
        personalInterests,
        talentAssessment,
        behaviorAssessment,
        psychologicalNotes,
        managerNotes,
      ];
}

class EducationInfo extends Equatable {
  const EducationInfo({
    required this.id,
    this.educationLevel,
    this.major,
    this.university,
    this.graduationDate,
    this.gpa,
    this.certificates,
  });

  final String id;
  final String? educationLevel;
  final String? major;
  final String? university;
  final String? graduationDate;
  final double? gpa;
  final String? certificates;

  @override
  List<Object?> get props => [id];
}

class SkillInfo extends Equatable {
  const SkillInfo({
    required this.id,
    required this.skillName,
    this.level,
    this.certificate,
    this.expiryDate,
    this.attachmentPath,
  });

  final String id;
  final String skillName;
  final String? level;
  final String? certificate;
  final String? expiryDate;
  final String? attachmentPath;

  @override
  List<Object?> get props => [id, skillName];
}

class InsuranceInfo extends Equatable {
  const InsuranceInfo({
    required this.id,
    this.responsibility,
    this.insuranceNumber,
    this.insuranceType,
    this.insuranceStatus,
    this.notes,
  });

  final String id;
  final String? responsibility;
  final String? insuranceNumber;
  final String? insuranceType;
  final String? insuranceStatus;
  final String? notes;

  @override
  List<Object?> get props => [id];
}

class EvaluationInfo extends Equatable {
  const EvaluationInfo({
    required this.id,
    required this.year,
    this.score,
    this.evaluator,
    this.evaluationDate,
    this.strengths,
    this.weaknesses,
    this.improvementPlan,
    this.attachmentPath,
  });

  final String id;
  final int year;
  final double? score;
  final String? evaluator;
  final String? evaluationDate;
  final String? strengths;
  final String? weaknesses;
  final String? improvementPlan;
  final String? attachmentPath;

  @override
  List<Object?> get props => [id, year];
}
