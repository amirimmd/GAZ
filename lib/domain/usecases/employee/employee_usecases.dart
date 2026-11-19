import '../../../core/errors/failures.dart';
import '../../../core/utils/iranian_national_id.dart';
import '../../entities/employee_entity.dart';
import '../../repositories/employee_repository.dart';

class CreateEmployeeUseCase {
  CreateEmployeeUseCase(this._repo);
  final EmployeeRepository _repo;

  Future<Result<EmployeeEntity>> call(EmployeeEntity employee) async {
    final validation = _validate(employee);
    if (validation != null) return Err(validation);

    final dupNational = await _repo.nationalIdExists(employee.nationalId);
    if (dupNational.isFailure) return Err(dupNational.failureOrNull!);
    if (dupNational.valueOrNull == true) {
      return const Err(ConflictFailure('کد ملی تکراری است'));
    }

    if (employee.employeeNumber != null &&
        employee.employeeNumber!.trim().isNotEmpty) {
      final dupEmp = await _repo.employeeNumberExists(employee.employeeNumber!);
      if (dupEmp.isFailure) return Err(dupEmp.failureOrNull!);
      if (dupEmp.valueOrNull == true) {
        return const Err(ConflictFailure('شماره پرسنلی تکراری است'));
      }
    }

    return _repo.create(employee);
  }

  ValidationFailure? _validate(EmployeeEntity e) {
    final errors = <String, String>{};
    if (e.firstName.trim().isEmpty) errors['firstName'] = 'نام الزامی است';
    if (e.lastName.trim().isEmpty) errors['lastName'] = 'نام خانوادگی الزامی است';
    if (!IranianNationalId.isValid(e.nationalId)) {
      errors['nationalId'] = 'کد ملی نامعتبر است';
    }
    if (errors.isEmpty) return null;
    return ValidationFailure('اعتبارسنجی ناموفق', fieldErrors: errors);
  }
}

class UpdateEmployeeUseCase {
  UpdateEmployeeUseCase(this._repo);
  final EmployeeRepository _repo;

  Future<Result<EmployeeEntity>> call(EmployeeEntity employee) async {
    if (employee.id.isEmpty) {
      return const Err(ValidationFailure('شناسه کارمند نامعتبر است'));
    }
    if (!IranianNationalId.isValid(employee.nationalId)) {
      return const Err(ValidationFailure('کد ملی نامعتبر است'));
    }
    final dupNational = await _repo.nationalIdExists(
      employee.nationalId,
      excludeId: employee.id,
    );
    if (dupNational.valueOrNull == true) {
      return const Err(ConflictFailure('کد ملی تکراری است'));
    }
    return _repo.update(employee);
  }
}

class SearchEmployeesUseCase {
  SearchEmployeesUseCase(this._repo);
  final EmployeeRepository _repo;

  Future<Result<List<EmployeeEntity>>> call(EmployeeQuery query) =>
      _repo.search(query);
}

class DeleteEmployeeUseCase {
  DeleteEmployeeUseCase(this._repo);
  final EmployeeRepository _repo;

  Future<Result<void>> call(String id) => _repo.softDelete(id);
}

/// Batch create with per-row results — used by group import.
class BulkCreateEmployeesUseCase {
  BulkCreateEmployeesUseCase(this._repo);
  final EmployeeRepository _repo;

  Future<BulkCreateResult> call(List<EmployeeEntity> employees) async {
    final create = CreateEmployeeUseCase(_repo);
    var success = 0;
    final failures = <String>[];

    for (final e in employees) {
      final result = await create(e);
      result.fold(
        (f) => failures.add('${e.fullName} (${e.nationalId}): ${f.message}'),
        (_) => success++,
      );
    }

    return BulkCreateResult(successCount: success, failures: failures);
  }
}

class BulkCreateResult {
  const BulkCreateResult({
    required this.successCount,
    required this.failures,
  });

  final int successCount;
  final List<String> failures;

  int get failCount => failures.length;
}
