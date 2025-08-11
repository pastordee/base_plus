import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Example demonstrating BaseCrossPlatformTabScaffold that automatically adapts to platform
/// 
/// iOS/Cupertino: Uses CupertinoTabScaffold with CupertinoTabBar
/// Android/Material: Uses Scaffold with BottomNavigationBar
/// 
/// This provides a truly cross-platform bottom navigation experience.
class BaseCrossPlatformTabScaffoldExample extends StatefulWidget {
  const BaseCrossPlatformTabScaffoldExample({Key? key}) : super(key: key);

  @override
  State<BaseCrossPlatformTabScaffoldExample> createState() => _BaseCrossPlatformTabScaffoldExampleState();
}

class _BaseCrossPlatformTabScaffoldExampleState extends State<BaseCrossPlatformTabScaffoldExample> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseCrossPlatformTabScaffold(
      // For Material mode, we can provide an app bar
      appBar: const BaseAppBar(
        title: Text('Cross-Platform Tabs'),
        centerTitle: true,
      ),
      // Tab configuration
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      
      // Styling
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      // Cupertino specific colors
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: CupertinoColors.inactiveGray,
      
      // Tab items (same for both platforms)
      tabs: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          activeIcon: Icon(CupertinoIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          activeIcon: Icon(CupertinoIcons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          activeIcon: Icon(CupertinoIcons.heart_fill),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          activeIcon: Icon(CupertinoIcons.person_fill),
          label: 'Profile',
        ),
      ],
      
      // Tab content builder
      tabBuilder: (context, index) {
        return _buildTabContent(context, index);
      },
    );
  }

  Widget _buildTabContent(BuildContext context, int index) {
    final bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS ||
                             Theme.of(context).platform == TargetPlatform.macOS;
    
    // Content for each tab
    final List<Widget> pages = [
      _TabPage(
        title: 'Home',
        icon: isCupertino ? CupertinoIcons.home : Icons.home,
        color: Colors.blue,
        description: 'Welcome to the home page!\n\nPlatform: ${Theme.of(context).platform}',
      ),
      _TabPage(
        title: 'Search',
        icon: isCupertino ? CupertinoIcons.search : Icons.search,
        color: Colors.green,
        description: 'Search for anything you need!\n\nThis tab demonstrates cross-platform navigation.',
      ),
      _TabPage(
        title: 'Favorites',
        icon: isCupertino ? CupertinoIcons.heart_fill : Icons.favorite,
        color: Colors.red,
        description: 'Your favorite items!\n\nNotice how the UI adapts to the platform.',
      ),
      _TabPage(
        title: 'Profile',
        icon: isCupertino ? CupertinoIcons.person_fill : Icons.person,
        color: Colors.orange,
        description: 'Manage your profile!\n\nBaseCrossPlatformTabScaffold handles platform differences automatically.',
      ),
    ];

    if (index >= 0 && index < pages.length) {
      return pages[index];
    }
    return pages[0];
  }
}

class _TabPage extends StatelessWidget {
  const _TabPage({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String description;

  @override
  Widget build(BuildContext context) {
    final bool isCupertino = Theme.of(context).platform == TargetPlatform.iOS ||
                             Theme.of(context).platform == TargetPlatform.macOS;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isCupertino ? CupertinoColors.secondaryLabel : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'Platform Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Running on: ${Theme.of(context).platform}\n'
                    'Material 3: ${Theme.of(context).useMaterial3}\n'
                    'Mode: ${isCupertino ? "Cupertino" : "Material"}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
