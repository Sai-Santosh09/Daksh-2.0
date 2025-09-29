import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_routes.dart';
import '../../generated/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  const HomePage({
    super.key,
    required this.child,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      label: AppConstants.learnTab,
      icon: AppConstants.learnIcon,
      route: AppRoutes.learn,
    ),
    NavigationItem(
      label: AppConstants.practiceTab,
      icon: AppConstants.practiceIcon,
      route: AppRoutes.practice,
    ),
    NavigationItem(
      label: AppConstants.assessTab,
      icon: AppConstants.assessIcon,
      route: AppRoutes.assess,
    ),
    NavigationItem(
      label: AppConstants.downloadsTab,
      icon: AppConstants.downloadsIcon,
      route: AppRoutes.downloads,
    ),
    NavigationItem(
      label: AppConstants.settingsTab,
      icon: AppConstants.settingsIcon,
      route: AppRoutes.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          context.go(_navigationItems[index].route);
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(AppConstants.learnIcon),
            label: l10n.learn,
          ),
          BottomNavigationBarItem(
            icon: const Icon(AppConstants.practiceIcon),
            label: l10n.practice,
          ),
          BottomNavigationBarItem(
            icon: const Icon(AppConstants.assessIcon),
            label: l10n.assess,
          ),
          BottomNavigationBarItem(
            icon: const Icon(AppConstants.downloadsIcon),
            label: l10n.downloads,
          ),
          BottomNavigationBarItem(
            icon: const Icon(AppConstants.settingsIcon),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;
  final String route;

  NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}
