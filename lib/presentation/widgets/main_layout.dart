import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/presentation/controllers/auth_controller.dart';
import 'package:hostdeck/domain/entities/app_user.dart';
import 'package:hostdeck/presentation/screens/dashboard_screen.dart';
import 'package:hostdeck/presentation/screens/user_management_screen.dart';
import 'package:hostdeck/presentation/screens/project_management_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // We filter what screens the user can see based on their role
  List<Widget> _getScreens(UserRole role) {
    if (role == UserRole.admin) {
      return [
        const DashboardScreen(),
        UserManagementScreen(),
        ProjectManagementScreen(),
      ];
    } else if (role == UserRole.manager) {
      return [
        const DashboardScreen(),
        UserManagementScreen(),
        ProjectManagementScreen(),
      ];
    } else if (role == UserRole.tester) {
      return [
        const DashboardScreen(),
        UserManagementScreen(),
      ];
    } else {
      // Tester / Client
      return [
        const DashboardScreen(),
      ];
    }
  }

  List<NavigationDestination> _getDestinations(UserRole role) {
    if (role == UserRole.admin || role == UserRole.manager) {
      return const [
        NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Builds'),
        NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Users'),
        NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Projects'),
      ];
    } else if (role == UserRole.tester) {
      return const [
        NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Builds'),
        NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Users'),
      ];
    } else {
      return const [
        NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Builds'),
      ];
    }
  }

  List<NavigationRailDestination> _getRailDestinations(UserRole role) {
    if (role == UserRole.admin || role == UserRole.manager) {
      return const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Builds')),
        NavigationRailDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: Text('Users')),
        NavigationRailDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: Text('Projects')),
      ];
    } else if (role == UserRole.tester) {
      return const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Builds')),
        NavigationRailDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: Text('Users')),
      ];
    } else {
      return const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Builds')),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final role = authController.appUser.value?.role ?? UserRole.client;
    final screens = _getScreens(role);
    final destinations = _getDestinations(role);
    final railDestinations = _getRailDestinations(role);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile Layout: Bottom Navigation
          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: screens,
            ),
            bottomNavigationBar: destinations.length > 1 
              ? NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
                  destinations: destinations,
                ) 
              : null,
          );
        } else {
          // Web/Desktop Layout: Navigation Rail
          return Scaffold(
            body: Row(
              children: [
                if (railDestinations.length > 1)
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
                    labelType: NavigationRailLabelType.all,
                    destinations: railDestinations,
                    elevation: 4,
                  ),
                if (railDestinations.length > 1)
                  const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: screens,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
