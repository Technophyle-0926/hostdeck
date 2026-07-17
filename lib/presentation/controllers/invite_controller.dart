import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hostdeck/presentation/controllers/auth_controller.dart';
import '../../domain/entities/app_user.dart';

class InviteController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> redeemInvite(String code) async {
    final user = _authController.firebaseUser.value;
    if (user == null) return;

    if (code.trim().isEmpty) {
      errorMessage.value = 'Please enter a valid code.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final firestore = FirebaseFirestore.instance;
      // Fetch the invitation document
      final inviteDoc = await firestore.collection('invitations').doc(code.trim()).get();

      if (!inviteDoc.exists) {
        errorMessage.value = 'Invalid or expired invite code.';
        isLoading.value = false;
        return;
      }

      final data = inviteDoc.data()!;
      final roleString = data['role'] as String? ?? 'client';
      final accessibleProjectIds = List<String>.from(data['accessibleProjectIds'] ?? []);

      // 1. Update the user's document with the new role and projects
      await firestore.collection('users').doc(user.uid).update({
        'role': roleString,
        'accessibleProjectIds': FieldValue.arrayUnion(accessibleProjectIds),
      });

      // 2. Delete the invite code so it can't be reused
      await firestore.collection('invitations').doc(code.trim()).delete();

      // 3. Update local auth state
      _authController.appUser.update((val) {
        if (val != null) {
           final updatedUser = AppUser(
             uid: val.uid,
             email: val.email,
             displayName: val.displayName,
             role: UserRole.fromString(roleString),
             accessibleProjectIds: {...val.accessibleProjectIds, ...accessibleProjectIds}.toList(),
           );
           _authController.appUser.value = updatedUser;
        }
      });

      // Success! AuthController should automatically redirect if we set up the listeners right, 
      // but let's force a redirect to dashboard just in case.
      Get.offAllNamed('/dashboard');
      Get.snackbar('Success', 'Welcome to Hostdeck! Your account has been setup.');
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      Get.log('Redemption error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
