import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/presentation/controllers/project_controller.dart';

class ProjectManagementScreen extends StatelessWidget {
  ProjectManagementScreen({super.key});

  final ProjectController controller = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Management'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: () => _showCreateProjectDialog(context),
            tooltip: 'Create New Project',
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.projects.isEmpty) {
          return const Center(child: Text('No projects found. Create one to get started!'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.projects.length,
          itemBuilder: (context, index) {
            final project = controller.projects[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.folder),
                ),
                title: Text(project.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('App Name: ${project.appName} \n${project.description}'),
                isThreeLine: project.description.isNotEmpty,
                trailing: SelectableText(project.id, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ),
            );
          },
        );
      }),
    );
  }

  void _showCreateProjectDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final appNameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Create New Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Project Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: appNameCtrl,
                decoration: const InputDecoration(labelText: 'AppHost App Name (e.g. hostdeck-ios)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.createProject(nameCtrl.text, appNameCtrl.text, descCtrl.text);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
