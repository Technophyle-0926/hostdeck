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
              onPressed: () => _showGenerateInviteDialog(context, assignableRoles),
              tooltip: 'Generate Invite Code',
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final visibleUsers = controller.users.where((user) {
          if (isAdmin) return true;
          if (isManager) return user.role == UserRole.tester || user.role == UserRole.client || user.role == UserRole.unassigned;
          if (isTester) return user.role == UserRole.client || user.role == UserRole.unassigned;
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
                            if ((assignableRoles.contains(user.role) || user.role == UserRole.unassigned) && assignableRoles.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              if (user.uid != currentUserId) // Prevent changing own role
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.withAlpha(76)),
                                  ),
                                  child: DropdownButton<UserRole>(
                                    value: assignableRoles.contains(user.role) ? user.role : UserRole.unassigned,
                                    iconSize: 20,
                                    underline: const SizedBox(),
                                    style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color),
                                    items: [
                                      if (!assignableRoles.contains(user.role) && user.role == UserRole.unassigned)
                                        const DropdownMenuItem(value: UserRole.unassigned, child: Text('UNASSIGNED')),
                                      ...assignableRoles.map((r) => DropdownMenuItem(
                                            value: r,
                                            child: Text(r.toString().split('.').last.toUpperCase()),
                                          ))
                                    ],
                                    onChanged: (newRole) {
                                      if (newRole != null && newRole != user.role && newRole != UserRole.unassigned) {
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
                                        Get.back();
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
              TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // close dialog
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

  void _showGenerateInviteDialog(BuildContext context, List<UserRole> assignableRoles) {
    final projectCtrl = Get.find<ProjectController>();
    UserRole selectedRole = assignableRoles.isNotEmpty ? assignableRoles.first : UserRole.client;
    List<String> selectedProjectIds = [];

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Generate Invite Code'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  Get.back(); // close dialog
                  final code = await controller.generateInvite(selectedRole, selectedProjectIds);
                  if (code != null) {
                    _showCodeDialog(code);
                  }
                },
                child: const Text('Generate'),
              )
            ],
          );
        },
      ),
    );
  }

  void _showCodeDialog(String code) {
    Get.dialog(
      AlertDialog(
        title: const Text('Invite Code Generated!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this code with the user. They will enter it upon logging in.', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            SelectableText(
              code, 
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              Get.snackbar('Copied', 'Invite code copied to clipboard');
              Get.back();
            },
            child: const Text('Copy to Clipboard'),
          ),
          ElevatedButton(onPressed: () => Get.back(), child: const Text('Done')),
        ],
      )
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
        onConfirm: () => Get.back(),
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
                onPressed: () => Get.back(),
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
