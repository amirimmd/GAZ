import '../../core/errors/failures.dart';
import '../entities/employee_entity.dart';

class EmployeeQuery {
  const EmployeeQuery({
    this.searchText,
    this.departmentId,
    this.employmentStatus,
    this.andTerms = const [],
    this.orTerms = const [],
    this.notTerms = const [],
    this.offset = 0,
    this.limit = 50,
    this.sortBy = 'lastName',
    this.ascending = true,
  });

  final String? searchText;
  final String? departmentId;
  final String? employmentStatus;
  final List<String> andTerms;
  final List<String> orTerms;
  final List<String> notTerms;
  final int offset;
  final int limit;
  final String sortBy;
  final bool ascending;
}

abstract class EmployeeRepository {
  Future<Result<EmployeeEntity>> getById(String id);
  Future<Result<List<EmployeeEntity>>> search(EmployeeQuery query);
  Future<Result<int>> count(EmployeeQuery query);
  Future<Result<EmployeeEntity>> create(EmployeeEntity employee);
  Future<Result<EmployeeEntity>> update(EmployeeEntity employee);
  Future<Result<void>> softDelete(String id);
  Future<Result<void>> bulkUpdate(List<EmployeeEntity> employees);
  Future<Result<void>> bulkSoftDelete(List<String> ids);
  Future<Result<bool>> nationalIdExists(String nationalId, {String? excludeId});
  Future<Result<bool>> employeeNumberExists(String number, {String? excludeId});
}
