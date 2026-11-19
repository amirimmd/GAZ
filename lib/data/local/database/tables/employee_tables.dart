import 'package:drift/drift.dart';

class Departments extends Table {
  TextColumn get id => text()();
  TextColumn get nameFa => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get code => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Units extends Table {
  TextColumn get id => text()();
  TextColumn get departmentId => text().references(Departments, #id)();
  TextColumn get nameFa => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get code => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Employees extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get fatherName => text().nullable()();
  TextColumn get nationalId => text()();
  TextColumn get birthDate => text().nullable()();
  TextColumn get birthPlace => text().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get maritalStatus => text().nullable()();
  IntColumn get childrenCount => integer().withDefault(const Constant(0))();
  TextColumn get bloodGroup => text().nullable()();
  TextColumn get militaryStatus => text().nullable()();
  TextColumn get personalDescription => text().nullable()();
  TextColumn get photoPath => text().nullable()();

  TextColumn get employeeNumber => text().nullable()();
  TextColumn get subscriptionNumber => text().nullable()();
  TextColumn get departmentId => text().nullable().references(Departments, #id)();
  TextColumn get unitId => text().nullable().references(Units, #id)();
  TextColumn get currentPosition => text().nullable()();
  TextColumn get previousPosition => text().nullable()();
  TextColumn get desiredPosition => text().nullable()();
  TextColumn get employmentType => text().nullable()();
  TextColumn get employmentDate => text().nullable()();
  TextColumn get supervisorId => text().nullable()();
  TextColumn get employmentStatus =>
      text().withDefault(const Constant('active'))();
  /// staff | worker — matches Win7.
  TextColumn get personType =>
      text().withDefault(const Constant('staff'))();
  TextColumn get retirementDate => text().nullable()();
  TextColumn get inactiveReason => text().nullable()();
  TextColumn get jobGroup => text().nullable()();
  RealColumn get positionBase => real().nullable()();
  RealColumn get personalBase => real().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmployeeContacts extends Table {
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get primaryPhone => text().nullable()();
  TextColumn get secondaryPhone => text().nullable()();
  TextColumn get emergencyPhone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get homeAddress => text().nullable()();
  TextColumn get postalCode => text().nullable()();

  @override
  Set<Column> get primaryKey => {employeeId};
}

class EmployeeSocials extends Table {
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get telegram => text().nullable()();
  TextColumn get whatsapp => text().nullable()();
  TextColumn get instagram => text().nullable()();
  TextColumn get linkedin => text().nullable()();
  TextColumn get otherLinksJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {employeeId};
}

class EmployeeEducations extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get educationLevel => text().nullable()();
  TextColumn get major => text().nullable()();
  TextColumn get university => text().nullable()();
  TextColumn get graduationDate => text().nullable()();
  RealColumn get gpa => real().nullable()();
  TextColumn get certificates => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmployeeSkills extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get skillName => text()();
  TextColumn get level => text().nullable()();
  TextColumn get certificate => text().nullable()();
  TextColumn get expiryDate => text().nullable()();
  TextColumn get attachmentPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmployeeInterests extends Table {
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get careerInterests => text().nullable()();
  TextColumn get technicalInterests => text().nullable()();
  TextColumn get managementInterests => text().nullable()();
  TextColumn get personalInterests => text().nullable()();
  TextColumn get talentAssessment => text().nullable()();
  TextColumn get behaviorAssessment => text().nullable()();
  TextColumn get psychologicalNotes => text().nullable()();
  TextColumn get managerNotes => text().nullable()();

  @override
  Set<Column> get primaryKey => {employeeId};
}

class EmployeeInsurances extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get responsibility => text().nullable()();
  TextColumn get insuranceNumber => text().nullable()();
  TextColumn get insuranceType => text().nullable()();
  TextColumn get insuranceStatus => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get effectiveFrom => integer().nullable()();
  IntColumn get effectiveTo => integer().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmployeeEvaluations extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  IntColumn get year => integer()();
  RealColumn get score => real().nullable()();
  TextColumn get evaluator => text().nullable()();
  TextColumn get evaluationDate => text().nullable()();
  TextColumn get strengths => text().nullable()();
  TextColumn get weaknesses => text().nullable()();
  TextColumn get improvementPlan => text().nullable()();
  TextColumn get attachmentPath => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmployeeDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().references(Employees, #id)();
  TextColumn get title => text()();
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  TextColumn get tagsJson => text().nullable()();
  TextColumn get fileName => text()();
  TextColumn get mimeType => text()();
  IntColumn get fileSize => integer()();
  TextColumn get storagePath => text()();
  TextColumn get contentHash => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get uploadedBy => text().nullable()();
  IntColumn get uploadedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmployeeGroups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get purposeType => text()();
  IntColumn get startsAt => integer().nullable()();
  IntColumn get endsAt => integer().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get photoPath => text().nullable()();
  TextColumn get createdBy => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmployeeGroupMembers extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text().references(EmployeeGroups, #id)();
  TextColumn get employeeId => text().references(Employees, #id)();
  IntColumn get addedAt => integer()();
  TextColumn get addedBy => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {groupId, employeeId},
      ];
}
