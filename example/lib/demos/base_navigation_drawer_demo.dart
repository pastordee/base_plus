import 'package:flutter/material.dart';
import 'package:base/base.dart';

/// Demo showcasing BaseNavigationDrawer - Cross-platform Material drawer
class BaseNavigationDrawerDemo extends StatelessWidget {
  const BaseNavigationDrawerDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('BaseNavigationDrawer Demo'),
        // automaticallyImplyLeading: false,
        // backgroundColor: Colors.blue,
        // leading: Builder(
        //   builder: (context) => BaseIconButton(
        //     icon: Icons.menu,
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //     tooltip: 'Open Navigation Drawer',
        //   ),
        // ),
        actions: [
          Builder(
            builder: (context) => BaseIconButton(
              icon: Icons.settings,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: 'Open Settings Drawer',
            ),
          ),
        ],
      ),
      drawer: BaseNavigationDrawer(
        child: _DrawerContent(),
      ),
      endDrawer: BaseNavigationDrawer(
        width: 280,
        child: _EndDrawerContent(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BaseNavigationDrawer Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This demo showcases BaseNavigationDrawer which automatically uses Material design on all platforms. BaseScaffold now automatically provides Material Scaffold context when drawers are present, making Scaffold.of(context).openDrawer() work seamlessly without any configuration.',
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.menu, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Tap the menu icon in the app bar to open the drawer'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.settings, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Tap the settings icon in the app bar to open the end drawer'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) => ElevatedButton.icon(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu),
                      label: const Text('Open Drawer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Builder(
                    builder: (context) => ElevatedButton.icon(
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      icon: const Icon(Icons.settings),
                      label: const Text('Open End Drawer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '✅ Cross-platform Material drawer functionality',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '✅ No need for forceUseMaterial parameter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '✅ Works consistently on iOS and Android',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.account_circle,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                'BaseNavigationDrawer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Cross-platform Material drawer',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('Favorites'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () => Navigator.pop(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          subtitle: const Text('Automatically uses Material design'),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _EndDrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.settings,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                'Settings Drawer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'End drawer example',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const ListTile(
          leading: Icon(Icons.brightness_6),
          title: Text('Theme'),
          subtitle: Text('Light/Dark mode'),
        ),
        const ListTile(
          leading: Icon(Icons.language),
          title: Text('Language'),
          subtitle: Text('App language settings'),
        ),
        const ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notifications'),
          subtitle: Text('Notification preferences'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
