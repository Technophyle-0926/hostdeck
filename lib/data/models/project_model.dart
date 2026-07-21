import 'package:isar_community/isar.dart';
import '../../domain/entities/project.dart';
import '../../core/constants/app_keys.dart';

part 'project_model.g.dart';

@collection
class ProjectModel {
  Id id = Isar.autoIncrement;

  late String projectId; // Firestore ID
  late String name;
  late String appName;
  late String description;
  late DateTime createdAt;

  ProjectModel();

  factory ProjectModel.fromEntity(Project entity) {
    return ProjectModel()
      ..projectId = entity.id
      ..name = entity.name
      ..appName = entity.appName
      ..description = entity.description
      ..createdAt = entity.createdAt;
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ProjectModel()
      ..projectId = documentId
      ..name = json[AppKeys.name] ?? ''
      ..appName = json[AppKeys.appName] ?? json[AppKeys.hostAccountId] ?? ''
      ..description = json[AppKeys.description] ?? ''
      ..createdAt = json[AppKeys.createdAt] != null
          ? DateTime.parse(json[AppKeys.createdAt])
          : DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      AppKeys.name: name,
      AppKeys.appName: appName,
      AppKeys.description: description,
      AppKeys.createdAt: createdAt.toIso8601String(),
    };
  }

  Project toEntity() {
    return Project(
      id: projectId,
      name: name,
      appName: appName,
      description: description,
      createdAt: createdAt,
    );
  }
}
