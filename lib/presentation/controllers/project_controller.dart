import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hostdeck/domain/entities/project.dart';
import 'package:hostdeck/data/models/project_model.dart';
import 'package:hostdeck/core/constants/app_constants.dart';
import 'package:hostdeck/core/constants/app_keys.dart';
import 'package:hostdeck/presentation/controllers/auth_controller.dart';
import 'package:hostdeck/domain/entities/app_user.dart';

class ProjectController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final RxList<Project> projects = <Project>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    isLoading.value = true;
    try {
      final user = Get.find<AuthController>().appUser.value;
      if (user == null) {
        projects.value = [];
        return;
      }

      if (user.role == UserRole.admin) {
        final snapshot = await _firestore.collection(FirestoreCollections.projects).orderBy(AppKeys.createdAt, descending: true).get();
        projects.value = snapshot.docs.map((doc) {
          return ProjectModel.fromJson(doc.data(), doc.id).toEntity();
        }).toList();
      } else {
        if (user.accessibleProjectIds.isEmpty) {
          projects.value = [];
          return;
        }

        // Firestore 'in' query supports up to 30 elements.
        final chunks = <List<String>>[];
        for (var i = 0; i < user.accessibleProjectIds.length; i += 30) {
          chunks.add(user.accessibleProjectIds.sublist(
            i,
            i + 30 > user.accessibleProjectIds.length ? user.accessibleProjectIds.length : i + 30,
          ));
        }

        final allProjects = <Project>[];
        for (var chunk in chunks) {
          final snapshot = await _firestore.collection(FirestoreCollections.projects)
              .where(FieldPath.documentId, whereIn: chunk)
              .get();
          allProjects.addAll(snapshot.docs.map((doc) {
            return ProjectModel.fromJson(doc.data(), doc.id).toEntity();
          }));
        }

        allProjects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        projects.value = allProjects;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load projects: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createProject(String name, String appName, String description) async {
    if (name.isEmpty || appName.isEmpty) {
      Get.snackbar('Error', 'Project Name and AppHost App Name are required.');
      return;
    }

    try {
      final newDoc = _firestore.collection(FirestoreCollections.projects).doc();
      final projectModel = ProjectModel()
        ..projectId = newDoc.id
        ..name = name
        ..appName = appName
        ..description = description
        ..createdAt = DateTime.now();

      await newDoc.set(projectModel.toJson());
      
      // Refresh list
      fetchProjects();
      Get.back(); // close dialog
      Get.snackbar('Success', 'Project created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create project: $e');
    }
  }
}
