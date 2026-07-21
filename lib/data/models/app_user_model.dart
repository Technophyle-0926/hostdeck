import 'package:isar_community/isar.dart';
import '../../domain/entities/app_user.dart';
import '../../core/constants/app_keys.dart';

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
      ..uid = json[AppKeys.uid] ?? ''
      ..email = json[AppKeys.email] ?? ''
      ..displayName = json[AppKeys.displayName] ?? ''
      ..role = json[AppKeys.role] ?? UserRole.client.name
      ..accessibleProjectIds = List<String>.from(
        json[AppKeys.accessibleProjectIds] ?? [],
      );
  }

  // Convert Model to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      AppKeys.uid: uid,
      AppKeys.email: email,
      AppKeys.displayName: displayName,
      AppKeys.role: role,
      AppKeys.accessibleProjectIds: accessibleProjectIds,
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
