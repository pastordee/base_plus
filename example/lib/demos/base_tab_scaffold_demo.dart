import 'package:flutter/material.dart';
import 'package:base_plus/base.dart';

/// Demo showcasing BaseTabScaffold with iOS 26 Liquid Glass Dynamic Material
class BaseCrossPlatformTabScaffoldDemo extends StatefulWidget {
  const BaseCrossPlatformTabScaffoldDemo({Key? key}) : super(key: key);

  @override
  State<BaseCrossPlatformTabScaffoldDemo> createState() => _BaseCrossPlatformTabScaffoldDemoState();
}

class _BaseCrossPlatformTabScaffoldDemoState extends State<BaseCrossPlatformTabScaffoldDemo> {
  bool _enableLiquidGlass = true;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BaseTabScaffold Demo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Switch(
            value: _enableLiquidGlass,
            onChanged: (value) {
              setState(() {
                _enableLiquidGlass = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text('Liquid Glass'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BaseTabScaffold with iOS 26 Liquid Glass',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This demo showcases the fixed BaseTabScaffold that properly handles iOS 26 Liquid Glass effects without type casting errors.',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Liquid Glass: ${_enableLiquidGlass ? "Enabled" : "Disabled"}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _enableLiquidGlass ? Colors.blue : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BaseTabScaffold(
              backgroundColor: Colors.grey[100],
              tabBar: BaseTabBar(
                enableLiquidGlass: _enableLiquidGlass,
                hapticFeedback: true,
                adaptiveInteraction: true,
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Favorites',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
              tabViews: [
                _buildTabContent('Home', Icons.home, Colors.blue),
                _buildTabContent('Search', Icons.search, Colors.green),
                _buildTabContent('Favorites', Icons.favorite, Colors.red),
                _buildTabContent('Profile', Icons.person, Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tab content with iOS 26 effects',
              style: TextStyle(
                fontSize: 16,
                color: color.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _enableLiquidGlass ? 'iOS 26 Liquid Glass Active' : 'Standard Mode',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
