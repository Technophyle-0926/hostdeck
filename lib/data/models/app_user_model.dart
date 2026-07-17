import 'package:isar_community/isar.dart';
import '../../domain/entities/app_user.dart';

part 'app_user_model.g.dart';

@collection
class AppUserModel {
  Id id = Isar.autoIncrement;

  late String uid;
  late String email;
  late String displayName;
  late String role;
  late List<String> accessibleProjectIds;

  AppUserModel();

  // Factory to create a Model from our pure Entity
  factory AppUserModel.fromEntity(AppUser entity) {
    return AppUserModel()
      ..uid = entity.uid
      ..email = entity.email
      ..displayName = entity.displayName
      ..role = entity.role.name
      ..accessibleProjectIds = entity.accessibleProjectIds;
  }

  // Factory to parse Firestore JSON into our Model
  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel()
      ..uid = json['uid'] ?? ''
      ..email = json['email'] ?? ''
      ..displayName = json['displayName'] ?? ''
      ..role = json['role'] ?? 'unassigned'
      ..accessibleProjectIds = List<String>.from(
        json['accessibleProjectIds'] ?? [],
      );
  }

  // Convert Model to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'accessibleProjectIds': accessibleProjectIds,
    };
  }

  // Convert Model back to pure Entity for the UI to use
  AppUser toEntity() {
    return AppUser(
      uid: uid,
      email: email,
      displayName: displayName,
      role: UserRole.fromString(role),
      accessibleProjectIds: accessibleProjectIds,
    );
  }
}
