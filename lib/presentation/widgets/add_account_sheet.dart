import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../controllers/settings_controller.dart';

import '../../domain/entities/host_account.dart';

class AddAccountSheet {
  static void show(BuildContext context, SettingsController controller, {HostAccount? existingAccount}) {
    final isEditing = existingAccount != null;
    final nameController = TextEditingController(text: existingAccount?.accountName);
    final emailController = TextEditingController(text: existingAccount?.email);
    final passwordController = TextEditingController();
    final isPasswordVisible = false.obs;
    
    if (isEditing) {
      controller.getPassword(existingAccount.email).then((pass) {
        if (pass != null) {
          passwordController.text = pass;
        }
      });
    }
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isEditing ? 'Edit Account' : AppStrings.addAccount, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppStrings.accountName,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: AppStrings.email,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: AppStrings.password,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible.value ? Icons.visibility : Icons.visibility_off),
                    onPressed: () async {
                      if (isEditing && !isPasswordVisible.value) {
                        final storedPass = await controller.retrievePassword(existingAccount.email);
                        if (storedPass != null) {
                          isPasswordVisible.value = true;
                        }
                      } else {
                        isPasswordVisible.value = !isPasswordVisible.value;
                      }
                    },
                  ),
                ),
              )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: controller.isAddingAccount.value
                        ? null
                        : () async {
                            final name = nameController.text.trim();
                            final email = emailController.text.trim();
                            final password = passwordController.text;
                            if (name.isEmpty || email.isEmpty || password.isEmpty) {
                              Get.snackbar(AppStrings.error, AppStrings.fillAllFields);
                              return;
                            }
                            
                            final success = isEditing 
                                ? await controller.updateAccount(existingAccount, name, email, password)
                                : await controller.addAccount(name, email, password);
                            if (success) {
                              Get.back();
                            }
                          },
                    child: controller.isAddingAccount.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(isEditing ? 'Update Account' : AppStrings.connectAccount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
