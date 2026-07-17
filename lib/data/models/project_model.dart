import 'package:isar_community/isar.dart';
import '../../domain/entities/project.dart';

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
      ..name = json['name'] ?? ''
      ..appName = json['appName'] ?? json['hostAccountId'] ?? ''
      ..description = json['description'] ?? ''
      ..createdAt = json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'appName': appName,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
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
