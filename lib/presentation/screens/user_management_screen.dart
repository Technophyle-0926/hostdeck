import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hostdeck/presentation/controllers/auth_controller.dart';
import 'package:hostdeck/presentation/controllers/user_controller.dart';
import 'package:hostdeck/presentation/controllers/project_controller.dart';
import 'package:hostdeck/domain/entities/app_user.dart';

class UserManagementScreen extends StatelessWidget {
  UserManagementScreen({super.key});

  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final currentUserId = Get.find<AuthController>().firebaseUser.value?.uid;
    final role = Get.find<AuthController>().appUser.value?.role;
    final isAdmin = role == UserRole.admin;
    final isManager = role == UserRole.manager;
    final isTester = role == UserRole.tester;
    // ensure projects are loaded for the invite dialog
    Get.put(ProjectController());

    List<UserRole> getAssignableRoles() {
      if (isAdmin) return UserRole.values;
      if (isManager) return [UserRole.tester, UserRole.client];
      if (isTester) return [UserRole.client];
      return [];
    }

    final assignableRoles = getAssignableRoles(); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        elevation: 0,
        actions: [
          if (assignableRoles.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => _showPreAuthorizeDialog(context, assignableRoles),
              tooltip: 'Pre-authorize User',
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final visibleUsers = controller.users.where((user) {
          if (isAdmin) return true;
          if (isManager) return user.role == UserRole.tester || user.role == UserRole.client;
          if (isTester) return user.role == UserRole.client;
          return false;
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: visibleUsers.length,
          itemBuilder: (context, index) {
            final user = visibleUsers[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: user.role == UserRole.admin ? Colors.redAccent : Colors.blueAccent,
                          child: Text(user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName.isNotEmpty ? user.displayName : 'Unknown User',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(
                            user.role.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.role == UserRole.admin 
                              ? 'Projects: All Access' 
                              : 'Projects: ${user.accessibleProjectIds.length}',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            if ((isAdmin || isManager) && user.role != UserRole.admin)
                              IconButton(
                                icon: const Icon(Icons.folder_shared, size: 20),
                                tooltip: 'Edit Projects',
                                onPressed: () => _showEditProjectsDialog(context, user),
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(8),
                              ),
                            if (assignableRoles.contains(user.role) && assignableRoles.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              if (user.uid != currentUserId) // Prevent changing own role
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.withAlpha(76)),
                                  ),
                                  child: DropdownButton<UserRole>(
                                    value: user.role,
                                    iconSize: 20,
                                    underline: const SizedBox(),
                                    style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color),
                                    items: assignableRoles.map((r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(r.toString().split('.').last.toUpperCase()),
                                    )).toList(),
                                    onChanged: (newRole) {
                                      if (newRole != null && newRole != user.role) {
                                        controller.updateRole(user.uid, newRole);
                                      }
                                    },
                                  ),
                                ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.person_remove, color: Colors.red, size: 20),
                                tooltip: user.uid == currentUserId ? 'Leave Hostdeck' : 'Remove User',
                                onPressed: () {
                                  if (user.uid == currentUserId) {
                                    _showSelfRemovalDialog(context, controller, currentUserId!);
                                  } else {
                                    Get.defaultDialog(
                                      title: 'Remove User',
                                      middleText: 'Are you sure you want to completely remove ${user.displayName.isNotEmpty ? user.displayName : 'this user'}? They will lose all access.',
                                      textCancel: 'Cancel',
                                      textConfirm: 'Remove',
                                      confirmTextColor: Colors.white,
                                      buttonColor: Colors.red,
                                      onConfirm: () {
                                        Navigator.of(context).pop();
                                        controller.removeUser(user.uid);
                                      },
                                    );
                                  }
                                },
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(8),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showEditProjectsDialog(BuildContext context, AppUser user) {
    final projectCtrl = Get.find<ProjectController>();
    List<String> selectedProjectIds = List.from(user.accessibleProjectIds);

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit Projects for ${user.displayName}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Assign Projects:'),
                  Obx(() {
                    if (projectCtrl.projects.isEmpty) {
                      return const Text('No projects available.', style: TextStyle(color: Colors.grey));
                    }
                    return Column(
                      children: projectCtrl.projects.map((p) {
                        return CheckboxListTile(
                          title: Text(p.name),
                          value: selectedProjectIds.contains(p.id),
                          onChanged: (bool? checked) {
                            setState(() {
                              if (checked == true) {
                                selectedProjectIds.add(p.id);
                              } else {
                                selectedProjectIds.remove(p.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  })
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  controller.updateUserProjects(user.uid, selectedProjectIds);
                },
                child: const Text('Save'),
              )
            ],
          );
        },
      ),
    );
  }

  void _showPreAuthorizeDialog(BuildContext context, List<UserRole> assignableRoles) {
    final projectCtrl = Get.find<ProjectController>();
    UserRole selectedRole = assignableRoles.isNotEmpty ? assignableRoles.first : UserRole.client;
    List<String> selectedProjectIds = [];
    final emailController = TextEditingController();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Pre-authorize User'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Email Address:'),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'user@example.com',
                      isDense: true,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const Text('Role:'),
                  DropdownButton<UserRole>(
                    isExpanded: true,
                    value: selectedRole,
                    items: assignableRoles.map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(r.toString().split('.').last.toUpperCase()),
                    )).toList(),
                    onChanged: (val) => setState(() => selectedRole = val!),
                  ),
                  const SizedBox(height: 16),
                  const Text('Assign Projects:'),
                  Obx(() {
                    if (projectCtrl.projects.isEmpty) {
                      return const Text('No projects available.', style: TextStyle(color: Colors.grey));
                    }
                    return Column(
                      children: projectCtrl.projects.map((p) {
                        return CheckboxListTile(
                          title: Text(p.name),
                          value: selectedProjectIds.contains(p.id),
                          onChanged: (bool? checked) {
                            setState(() {
                              if (checked == true) {
                                selectedProjectIds.add(p.id);
                              } else {
                                selectedProjectIds.remove(p.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  })
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  if (email.isEmpty) {
                    Get.snackbar('Error', 'Please enter an email address');
                    return;
                  }
                  Navigator.of(context).pop(); // close dialog
                  await controller.preAuthorizeUser(email, selectedRole, selectedProjectIds);
                },
                child: const Text('Authorize'),
              )
            ],
          );
        },
      ),
    );
  }

  void _showSelfRemovalDialog(BuildContext context, UserController controller, String currentUserId) {
    final otherAdmins = controller.users.where((u) => u.role == UserRole.admin && u.uid != currentUserId).toList();

    if (otherAdmins.isEmpty) {
      Get.defaultDialog(
        title: 'Cannot Leave',
        middleText: 'You are the only Admin in the system. You must promote someone else to Admin before you can transfer your accounts and leave.',
        textConfirm: 'Okay',
        confirmTextColor: Colors.white,
        onConfirm: () => Navigator.of(context).pop(),
      );
      return;
    }

    String selectedTargetUid = otherAdmins.first.uid;

    Get.defaultDialog(
      title: 'Leave Hostdeck',
      barrierDismissible: false,
      content: StatefulBuilder(
        builder: (context, setState) {
          return Obx(() {
            if (controller.transferStatus.value.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      controller.transferStatus.value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('To remove yourself, you must transfer your encrypted AppHost accounts to another Admin.'),
                  const SizedBox(height: 16),
                  const Text('Select Target Admin:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: selectedTargetUid,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: otherAdmins.map((admin) {
                      return DropdownMenuItem(
                        value: admin.uid,
                        child: Text(admin.displayName.isNotEmpty ? admin.displayName : admin.email),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedTargetUid = val);
                    },
                  ),
                ],
              ),
            );
          });
        },
      ),
      actions: [
        Obx(() {
          if (controller.transferStatus.value.isNotEmpty) return const SizedBox();
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                onPressed: () {
                  controller.transferAccountsAndRemoveSelf(selectedTargetUid);
                },
                child: const Text('Transfer & Leave'),
              ),
            ],
          );
        }),
      ],
    );
  }
}
