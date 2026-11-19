import 'package:equatable/equatable.dart';

/// Admin user row for users management screen.
class UserAccountSummary extends Equatable {
  const UserAccountSummary({
    required this.id,
    required this.username,
    required this.displayName,
    required this.isActive,
    required this.roleCodes,
    required this.permissions,
  });

  final String id;
  final String username;
  final String displayName;
  final bool isActive;
  final List<String> roleCodes;
  final Set<String> permissions;

  @override
  List<Object?> get props =>
      [id, username, displayName, isActive, roleCodes, permissions];
}
