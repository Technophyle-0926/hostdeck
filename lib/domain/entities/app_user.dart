enum UserRole {
  admin,
  manager,
  tester,
  client;

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'manager':
        return UserRole.manager;
      case 'tester':
        return UserRole.tester;
      case 'client':
        return UserRole.client;
      default:
        return UserRole.client;
    }
  }
}

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final List<String> accessibleProjectIds;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.accessibleProjectIds = const [],
  });
}
