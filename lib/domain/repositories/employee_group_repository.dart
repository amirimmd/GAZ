import '../../core/errors/failures.dart';
import '../entities/employee_entity.dart';
import '../entities/employee_group_entity.dart';

abstract class EmployeeGroupRepository {
  Future<Result<List<EmployeeGroupEntity>>> list(GroupQuery query);
  Future<Result<EmployeeGroupEntity>> getById(String id, {bool withMembers = true});
  Future<Result<EmployeeGroupEntity>> create({
    required String name,
    required GroupPurposeType purposeType,
    String? description,
    DateTime? startsAt,
    DateTime? endsAt,
    GroupStatus status = GroupStatus.active,
    required String createdBy,
    List<String> memberIds = const [],
  });
  Future<Result<EmployeeGroupEntity>> update(EmployeeGroupEntity group);
  Future<Result<void>> softDelete(String id);
  Future<Result<void>> setStatus(String id, GroupStatus status);
  Future<Result<void>> addMembers(
    String groupId,
    List<String> employeeIds, {
    String? addedBy,
  });
  Future<Result<void>> removeMember(String groupId, String employeeId);
  Future<Result<List<EmployeeEntity>>> listMembers(String groupId);
}
