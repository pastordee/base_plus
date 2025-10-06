import 'package:base/base.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/material.dart';

/// Example demonstrating proper bottom navigation implementation using BaseScaffold
/// 
/// This example shows three approaches:
/// 1. Material Design BaseBottomNavigationBar (cross-platform)
/// 2. Native iOS CNTabBar using cupertino_native package directly
/// 3. BaseTabBar with automatic iOS/Material switching using SF Symbol metadata
/// 
/// ## Material Design Approach:
/// BaseScaffold properly handles bottomNavigationBar for Material Design.
/// Use baseParam: BaseParam(forceUseMaterial: true) to ensure
/// bottom navigation shows on iOS/macOS platforms.
/// 
/// ## Cupertino Native Approach (Direct):
/// When cupertino_native package is available, you can use CNTabBar directly:
/// ```dart
/// CNTabBar(
///   items: const [
///     CNTabBarItem(label: 'Home', icon: CNSymbol('house.fill')),
///     CNTabBarItem(label: 'Profile', icon: CNSymbol('person.crop.circle')),
///     CNTabBarItem(label: 'Settings', icon: CNSymbol('gearshape.fill')),
///   ],
///   currentIndex: _tabIndex,
///   onTap: (i) => setState(() => _tabIndex = i),
/// )
/// ```
/// 
/// ## BaseTabBar with Automatic Native iOS Switching:
/// Use BaseTabBar with SF Symbol metadata for automatic platform detection:
/// ```dart
/// BaseTabBar(
///   useNativeCupertinoTabBar: true, // Enable native iOS tab bar
///   tabs: [
///     BottomNavigationBarItem(
///       icon: KeyedSubtree(
///         key: BaseNativeTabBarItemKey(SFSymbols.home), // SF Symbol metadata
///         child: Icon(Icons.home_outlined),
///       ),
///       activeIcon: Icon(Icons.home),
///       label: 'Home',
///     ),
///     // ... more items
///   ],
///   currentIndex: _tabIndex,
///   onTap: (i) => setState(() => _tabIndex = i),
/// )
/// ```
/// 
/// Or use the convenience factory:
/// ```dart
/// BottomNavigationBarItem.withSFSymbol(
///   sfSymbolName: SFSymbols.search,
///   icon: Icon(Icons.search_outlined),
///   activeIcon: Icon(Icons.search),
///   label: 'Search',
/// )
/// ```
/// 
/// Toggle between approaches using the app bar buttons.
class BottomNavigationExample extends StatefulWidget {
  const BottomNavigationExample({Key? key}) : super(key: key);

  @override
  State<BottomNavigationExample> createState() => _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State<BottomNavigationExample> {
  int _currentIndex = 0;
  int _tabIndex = 0; // For cupertino_native CNTabBar
  int _autoTabIndex = 0; // For automatic BaseTabBar switching
  String _selectedApproach = 'material'; // 'material', 'native', or 'auto'

  final List<Widget> _pages = [
    const _HomePage(),
    const _SearchPage(),
    const _ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine which page to show based on the selected approach
    Widget bodyContent;
    if (_selectedApproach == 'native') {
      bodyContent = _buildNativeTabBody();
    } else if (_selectedApproach == 'auto') {
      bodyContent = _pages[_autoTabIndex];
    } else {
      bodyContent = _pages[_currentIndex];
    }
    
    return BaseScaffold(
      // Force Material mode for Material and Auto approaches to ensure bottom navigation shows
      // Auto approach needs Material mode so BaseTabBar can render as bottomNavigationBar
      baseParam: BaseParam(forceUseMaterial: _selectedApproach != 'native'),
      appBar: BaseAppBar(
        title: const Text('Bottom Navigation'),
        centerTitle: true,
        actions: [
          // Toggle between three approaches
          PopupMenuButton<String>(
            icon: Icon(_selectedApproach == 'material' 
                ? Icons.android 
                : (_selectedApproach == 'native' ? Icons.apple : Icons.phonelink)),
            onSelected: (value) => setState(() => _selectedApproach = value),
            tooltip: 'Switch Navigation Style',
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'material',
                child: Row(
                  children: [
                    Icon(Icons.android),
                    SizedBox(width: 8),
                    Text('Material Design'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'native',
                child: Row(
                  children: [
                    Icon(Icons.apple),
                    SizedBox(width: 8),
                    Text('Native iOS (CNTabBar)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'auto',
                child: Row(
                  children: [
                    Icon(Icons.phonelink),
                    SizedBox(width: 8),
                    Text('Auto (BaseTabBar)'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: bodyContent,
      // Show bottom navigation based on selected approach
      bottomNavigationBar: _selectedApproach == 'material' 
          ? _buildMaterialBottomNav(context)
          : (_selectedApproach == 'auto' 
              ? _buildAutoBaseTabBar() 
              : null),
    );
  }

  /// Material Design Bottom Navigation Bar
  Widget _buildMaterialBottomNav(BuildContext context) {
    return BaseBottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
    );
  }

  /// Native iOS Tab Bar Body with CNTabBar overlay
  Widget _buildNativeTabBody() {
    return Stack(
      children: [
        // Page content
        _pages[_tabIndex],
        // CNTabBar overlay at the bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildCupertinoNativeTabBar(),
        ),
      ],
    );
  }

  /// Cupertino Native Tab Bar Implementation
  /// This demonstrates how to use CNTabBar from cupertino_native package
  Widget _buildCupertinoNativeTabBar() {
    return CNTabBar(
      items: const [
        CNTabBarItem(label: 'Home', icon: CNSymbol('house.fill')),
        CNTabBarItem(label: 'Search', icon: CNSymbol('magnifyingglass')),
        CNTabBarItem(label: 'Profile', icon: CNSymbol('person.crop.circle')),
      ],
      currentIndex: _tabIndex,
      onTap: (i) => setState(() => _tabIndex = i),
    );
  }

  /// Automatic BaseTabBar with Native iOS Detection
  /// This demonstrates the recommended approach using BaseTabBar with SF Symbol metadata
  Widget _buildAutoBaseTabBar() {
    print('Building Auto BaseTabBar - currentIndex: $_autoTabIndex'); // Debug
    
    return BaseTabBar(
      // Enable native iOS tab bar (will use CNTabBar on iOS, Material elsewhere)
      useNativeCupertinoTabBar: true,
      useMaterial3Tabs: false, // Use legacy BottomNavigationBar for better tap handling
      // enableLiquidGlass is true by default and now fixed to allow tap events
      items:  [
        // Approach 1: Using convenience factory method
        BottomNavigationBarItemNativeExtension.withSFSymbol(
          sfSymbolName: SFSymbols.home,
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),

        
        // Approach 2: Using KeyedSubtree manually for more control
        BottomNavigationBarItem(
          icon: KeyedSubtree(
            key: BaseNativeTabBarItemKey(SFSymbols.search),
            child: Icon(Icons.search_outlined),
          ),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
        // Approach 3: Let BaseTabBar automatically map icon to SF Symbol
        // BaseTabBar will attempt to map Icons.person_outline to a corresponding SF Symbol
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _autoTabIndex,
      onTap: (index) {
        print('BaseTabBar onTap called with index: $index'); // Debug
        setState(() => _autoTabIndex = index);
      },
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Home Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Welcome to the home page!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 24),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Navigation Demo',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Use the menu button in the app bar to switch between:',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text('• Material Design Bottom Navigation'),
                    Text('• Native iOS (CNTabBar Direct)'),
                    Text('• Auto (BaseTabBar with SF Symbols)'),
                    SizedBox(height: 12),
                    Divider(),
                    SizedBox(height: 12),
                    Text(
                      '💡 Recommended: Auto Approach',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'The Auto approach uses BaseTabBar which automatically detects iOS and renders CNTabBar with SF Symbols, while using Material Design on other platforms.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchPage extends StatelessWidget {
  const _SearchPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Search Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Search for anything you need!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'Profile Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Manage your profile settings!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
