import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaz_hrms/core/errors/failures.dart';
import 'package:gaz_hrms/core/security/crypto_service.dart';
import 'package:gaz_hrms/domain/entities/employee_entity.dart';
import 'package:gaz_hrms/domain/repositories/employee_repository.dart';
import 'package:gaz_hrms/domain/usecases/employee/employee_usecases.dart';

class _FakeEmployeeRepo implements EmployeeRepository {
  bool nationalExists = false;
  bool empNoExists = false;

  @override
  Future<Result<EmployeeEntity>> create(EmployeeEntity employee) async =>
      Success(employee);

  @override
  Future<Result<bool>> nationalIdExists(String nationalId, {String? excludeId}) async =>
      Success(nationalExists);

  @override
  Future<Result<bool>> employeeNumberExists(String number, {String? excludeId}) async =>
      Success(empNoExists);

  @override
  Future<Result<void>> bulkSoftDelete(List<String> ids) async =>
      const Success(null);

  @override
  Future<Result<void>> bulkUpdate(List<EmployeeEntity> employees) async =>
      const Success(null);

  @override
  Future<Result<int>> count(EmployeeQuery query) async => const Success(0);

  @override
  Future<Result<EmployeeEntity>> getById(String id) async =>
      const Err(NotFoundFailure());

  @override
  Future<Result<List<EmployeeEntity>>> search(EmployeeQuery query) async =>
      const Success([]);

  @override
  Future<Result<void>> softDelete(String id) async => const Success(null);

  @override
  Future<Result<EmployeeEntity>> update(EmployeeEntity employee) async =>
      Success(employee);
}

void main() {
  group('PasswordHasher', () {
    test('hashes and verifies Argon2id password', () {
      final hasher = PasswordHasher.instance;
      final encoded = hasher.hashPassword('Admin@ChangeMe1');
      expect(encoded.startsWith(r'$argon2id$'), isTrue);
      expect(hasher.verifyPassword('Admin@ChangeMe1', encoded), isTrue);
      expect(hasher.verifyPassword('wrong', encoded), isFalse);
    });
  });

  group('AesGcmService', () {
    test('encrypts and decrypts round-trip', () {
      final key = List<int>.generate(32, (i) => i);
      final plain = Uint8List.fromList('secret-document'.codeUnits);
      final payload = AesGcmService.instance.encrypt(
        key: Uint8List.fromList(key),
        plaintext: plain,
      );
      final out = AesGcmService.instance.decrypt(
        key: Uint8List.fromList(key),
        payload: payload,
      );
      expect(String.fromCharCodes(out), 'secret-document');
    });
  });

  group('CreateEmployeeUseCase', () {
    test('rejects invalid national id', () async {
      final useCase = CreateEmployeeUseCase(_FakeEmployeeRepo());
      final result = await useCase(
        const EmployeeEntity(
          id: '',
          firstName: 'علی',
          lastName: 'رضایی',
          nationalId: '123',
        ),
      );
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
    });

    test('rejects duplicate national id', () async {
      final repo = _FakeEmployeeRepo()..nationalExists = true;
      final useCase = CreateEmployeeUseCase(repo);
      // Valid checksum national id sample: 0013542419
      final result = await useCase(
        const EmployeeEntity(
          id: '',
          firstName: 'علی',
          lastName: 'رضایی',
          nationalId: '0013542419',
        ),
      );
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ConflictFailure>());
    });
  });
}
