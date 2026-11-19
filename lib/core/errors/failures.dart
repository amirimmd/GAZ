import 'package:equatable/equatable.dart';

/// Sealed-style failure hierarchy for domain Result types.
sealed class Failure extends Equatable {
  const Failure(this.message, {this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code, this.fieldErrors = const {}});

  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

final class PermissionFailure extends Failure {
  const PermissionFailure([
    String message = 'دسترسی مجاز نیست',
    String? code,
  ]) : super(message, code: code);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([
    String message = 'مورد یافت نشد',
    String? code,
  ]) : super(message, code: code);
}

final class ConflictFailure extends Failure {
  const ConflictFailure(super.message, {super.code});
}

final class SecurityFailure extends Failure {
  const SecurityFailure(super.message, {super.code});
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.code});
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    String message = 'خطای غیرمنتظره',
    String? code,
  ]) : super(message, code: code);
}

/// Functional Result without external package dependency.
sealed class Result<T> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;

  T? get valueOrNull => switch (this) {
        Success(:final value) => value,
        Err() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success() => null,
        Err(:final failure) => failure,
      };

  R fold<R>(R Function(Failure f) onError, R Function(T v) onSuccess) {
    return switch (this) {
      Success(:final value) => onSuccess(value),
      Err(:final failure) => onError(failure),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;

  @override
  List<Object?> get props => [value];
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
