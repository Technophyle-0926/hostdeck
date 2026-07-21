import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hostdeck/data/datasources/local/database_service.dart';
import 'package:hostdeck/data/datasources/local/encryption_service.dart';
import 'package:hostdeck/data/datasources/local/secure_storage_service.dart';
import 'package:hostdeck/presentation/controllers/auth_controller.dart';
import 'package:hostdeck/domain/entities/app_user.dart';
import 'package:hostdeck/data/models/app_user_model.dart';
import 'package:hostdeck/core/constants/app_constants.dart';
import 'package:hostdeck/core/constants/app_keys.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<AppUser> users = <AppUser>[].obs;
  final RxBool isLoading = true.obs;
  final RxString transferStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore.collection(FirestoreCollections.users).get();
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
      await _firestore.collection(FirestoreCollections.users).doc(uid).update({
        AppKeys.role: newRole.name,
      });
      fetchUsers(); // refresh
      Get.snackbar('Success', 'User role updated.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user: $e');
    }
  }

  Future<void> removeUser(String uid) async {
    try {
      final batch = _firestore.batch();

      // 1. Delete all host_accounts subcollection documents to avoid orphaned data
      final accountsSnapshot = await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .collection(FirestoreCollections.hostAccounts)
          .get();
      for (var doc in accountsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // 2. Delete the main user document
      batch.delete(_firestore.collection(FirestoreCollections.users).doc(uid));

      await batch.commit();

      fetchUsers(); // refresh
      Get.snackbar('Success', 'User has been removed from the system.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove user: $e');
    }
  }

  Future<void> updateUserProjects(String uid, List<String> projectIds) async {
    try {
      await _firestore.collection(FirestoreCollections.users).doc(uid).update({
        AppKeys.accessibleProjectIds: projectIds,
      });
      fetchUsers(); // refresh
      Get.snackbar('Success', 'User projects updated.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user projects: $e');
    }
  }

  Future<void> transferAccountsAndRemoveSelf(String targetAdminUid) async {
    final authController = Get.find<AuthController>();
    final currentUid = authController.firebaseUser.value?.uid;
    if (currentUid == null) return;

    try {
      transferStatus.value = 'Preparing to transfer accounts...';

      final dbService = Get.find<DatabaseService>();
      final secureStorage = Get.find<SecureStorageService>();
      final encryptionService = EncryptionService();

      final accounts = await dbService.getHostAccounts();
      final batch = _firestore.batch();
      final targetCollection = _firestore
          .collection(FirestoreCollections.users)
          .doc(targetAdminUid)
          .collection(FirestoreCollections.hostAccounts);

      int count = 0;
      for (var account in accounts) {
        transferStatus.value =
            'Encrypting account ${++count}/${accounts.length}...';
        final password = await secureStorage.getPassword(account.email);
        if (password != null) {
          final encryptedPassword = encryptionService.encrypt(
            password,
            targetUid: targetAdminUid,
          );
          batch.set(targetCollection.doc(account.email), {
            AppKeys.accountName: account.accountName,
            AppKeys.email: account.email,
            AppKeys.encryptedPassword: encryptedPassword,
            AppKeys.updatedAt: FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }

      transferStatus.value = 'Transferring accounts to new Admin...';
      await batch.commit();

      transferStatus.value = 'Cleaning up old data...';
      await removeUser(
        currentUid,
      ); // This already cleans up the old subcollection and document

      transferStatus.value = 'Logging out...';
      await authController.signOut();
    } catch (e) {
      Get.snackbar('Transfer Error', 'Failed to transfer accounts: $e');
      transferStatus.value = '';
    }
  }

  Future<void> preAuthorizeUser(String email, UserRole role, List<String> projectIds) async {
    try {
      final authController = Get.find<AuthController>();
      final currentUserEmail = authController.firebaseUser.value?.email;

      await _firestore.collection(FirestoreCollections.preAuthorizedUsers).doc(email.toLowerCase()).set({
        AppKeys.role: role.name,
        AppKeys.accessibleProjectIds: projectIds,
        AppKeys.addedBy: currentUserEmail,
        AppKeys.createdAt: FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', '$email has been authorized successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to authorize user: $e');
    }
  }
}
