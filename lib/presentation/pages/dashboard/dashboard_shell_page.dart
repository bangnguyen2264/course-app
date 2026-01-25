import 'package:course/app/constants/app_routes.dart';
import 'package:course/presentation/pages/dashboard/dashboard_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardShellPage extends StatelessWidget {
  const DashboardShellPage({super.key, required this.child});

  final Widget child;

  static const List<DashboardTab> _tabs = [
    DashboardTab(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      location: AppRoutes.home,
    ),
    DashboardTab(
      label: 'Exam',
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment,
      location: AppRoutes.exam,
    ),
    DashboardTab(
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      location: AppRoutes.profile,
    ),
  ];

  int _locationToTabIndex(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].location)) {
        return i;
      }
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    final target = _tabs[index].location;
    if (GoRouterState.of(context).uri.toString() != target) {
      context.go(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToTabIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
        items: _tabs
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                activeIcon: Icon(tab.selectedIcon),
                label: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
