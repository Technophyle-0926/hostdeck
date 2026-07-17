import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hostdeck/domain/entities/app_user.dart';
import 'package:hostdeck/data/models/app_user_model.dart';
import 'dart:math';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final RxList<AppUser> users = <AppUser>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore.collection('users').get();
      users.value = snapshot.docs.map((doc) {
        return AppUserModel.fromJson(doc.data()).toEntity();
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRole(String uid, UserRole newRole) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'role': newRole.toString().split('.').last,
      });
      fetchUsers(); // refresh
      Get.snackbar('Success', 'User role updated.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user: $e');
    }
  }

  Future<void> removeUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      fetchUsers(); // refresh
      Get.snackbar('Success', 'User has been removed from the system.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove user: $e');
    }
  }

  Future<void> updateUserProjects(String uid, List<String> projectIds) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'accessibleProjectIds': projectIds,
      });
      fetchUsers(); // refresh
      Get.snackbar('Success', 'User projects updated.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user projects: $e');
    }
  }

  Future<String?> generateInvite(UserRole role, List<String> projectIds) async {
    try {
      // Generate a short 6 character invite code
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final rnd = Random();
      final code = 'HD-${String.fromCharCodes(Iterable.generate(5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))))}';

      await _firestore.collection('invitations').doc(code).set({
        'role': role.toString().split('.').last,
        'accessibleProjectIds': projectIds,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      return code;
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate invite: $e');
      return null;
    }
  }
}
