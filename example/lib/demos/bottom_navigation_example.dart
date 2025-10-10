import 'package:base/base.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/material.dart';

import 'cupertino_native_demo.dart';

/// Example demonstrating proper bottom navigation implementation using BaseScaffold
/// 
/// This example shows three approaches:
/// 1. **Material Design**: BaseBottomNavigationBar in bottomNavigationBar property (traditional)
/// 2. **Native iOS (CNTabBar)**: Direct CNTabBar overlay using Stack (transparent, no background blocking)
/// 3. **Auto (BaseTabBar)**: BaseTabBar overlay using Stack (matches CNTabBar approach)
/// 
/// ## Key Architectural Insight:
/// 
/// ### Material Approach (Traditional):
/// Uses the scaffold's `bottomNavigationBar` property. The scaffold creates a container
/// with background, which is fine for Material Design's opaque bottom navigation.
/// 
/// ### Native iOS & Auto Approaches (Stack Overlay):
/// Both use a Stack to overlay the tab bar on top of the content without any scaffold
/// container. This ensures:
/// - No background blocking from scaffold container
/// - Transparent tab bar with blur effects
/// - Touch events work correctly without interference
/// - Consistent behavior between CNTabBar and BaseTabBar
/// 
/// The Auto approach now matches the Native iOS implementation pattern, ensuring
/// BaseTabBar behaves identically to CNTabBar when used on iOS platforms.
/// 
/// ## Material Design Approach:
/// BaseScaffold properly handles bottomNavigationBar for Material Design.
/// Use baseParam: BaseParam(forceUseMaterial: true) to ensure
/// bottom navigation shows on iOS/macOS platforms.
/// 
/// ## Cupertino Native Approach (Direct):
/// When cupertino_native package is available, you can use CNTabBar directly:
/// ```dart
/// Stack(
///   children: [
///     pageContent,
///     Positioned(
///       left: 0, right: 0, bottom: 0,
///       child: CNTabBar(
///         items: const [
///           CNTabBarItem(label: 'Home', icon: CNSymbol('house.fill')),
///           CNTabBarItem(label: 'Profile', icon: CNSymbol('person.crop.circle')),
///           CNTabBarItem(label: 'Settings', icon: CNSymbol('gearshape.fill')),
///         ],
///         currentIndex: _tabIndex,
///         onTap: (i) => setState(() => _tabIndex = i),
///       ),
///     ),
///   ],
/// )
/// ```
/// 
/// ## BaseTabBar with Automatic Native iOS Switching:
/// Use BaseTabBar with SF Symbol metadata for automatic platform detection.
/// **Important**: Use the same Stack overlay pattern as CNTabBar:
/// ```dart
/// Stack(
///   children: [
///     pageContent,
///     Positioned(
///       left: 0, right: 0, bottom: 0,
///       child: BaseTabBar(
///         useNativeCupertinoTabBar: true, // Enable native iOS tab bar
///         items: [
///           BottomNavigationBarItem(
///             icon: KeyedSubtree(
///               key: BaseNativeTabBarItemKey(SFSymbols.home), // SF Symbol metadata
///               child: Icon(Icons.home_outlined),
///             ),
///             activeIcon: Icon(Icons.home),
///             label: 'Home',
///           ),
///           // ... more items
///         ],
///         currentIndex: _tabIndex,
///         onTap: (i) => setState(() => _tabIndex = i),
///       ),
///     ),
///   ],
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
    const CupertinoNativeDemo(),
    const _ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine which page to show based on the selected approach
    Widget bodyContent;
    if (_selectedApproach == 'native') {
      bodyContent = _buildNativeTabBody();
    } else if (_selectedApproach == 'auto') {
      // Use Stack approach for Auto mode to overlay BaseTabBar like CNTabBar
      bodyContent = _buildAutoTabBody();
    } else {
      bodyContent = _pages[_currentIndex];
    }
    
    return BaseScaffold(
      // Force Material mode for Material approach, but Auto uses Cupertino mode with Stack overlay
      baseParam: BaseParam(forceUseMaterial: _selectedApproach == 'material'),
      appBar: BaseAppBar(
        title: const Text('Bottom Navigation'),
        centerTitle: true,
        actions: [
          // Toggle between three approaches using BasePopupMenuButton
          BasePopupMenuButton.icon(
            items: const [
              BasePopupMenuItem(
                label: 'Material Design',
                iosIcon: 'square.grid.2x2',
                iconData: Icons.grid_view,
              ),
              BasePopupMenuItem(
                label: 'Native iOS (CNTabBar)',
                iosIcon: 'apple.logo',
                iconData: Icons.phone_iphone,
              ),
              BasePopupMenuItem(
                label: 'Auto (BaseTabBar)',
                iosIcon: 'iphone',
                iconData: Icons.smartphone,
              ),
            ],
            onSelected: (index) {
              final approaches = ['material', 'native', 'auto'];
              setState(() => _selectedApproach = approaches[index]);
            },
            iosIcon: _selectedApproach == 'material' 
                ? 'square.grid.2x2' 
                : (_selectedApproach == 'native' ? 'apple.logo' : 'iphone'),
            materialIcon: _selectedApproach == 'material'
                ? Icons.grid_view
                : (_selectedApproach == 'native' ? Icons.phone_iphone : Icons.smartphone),
          ),
        ],
      ),
      body: bodyContent,
      // Show bottom navigation only for Material approach
      // Native and Auto approaches use Stack overlay in body
      bottomNavigationBar: _selectedApproach == 'material' 
          ? _buildMaterialBottomNav(context)
          : null,
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
        BottomNavigationBarItem(
          icon: Icon(Icons.apple),
          activeIcon: Icon(Icons.apple),
          label: 'Native',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
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

  /// Auto BaseTabBar Body with Stack overlay (same approach as Native)
  /// This ensures no background container blocks the tab bar
  Widget _buildAutoTabBody() {
    return Stack(
      children: [
        // Page content
        _pages[_autoTabIndex],
        // BaseTabBar overlay at the bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildAutoBaseTabBar(),
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
        CNTabBarItem(label: 'Native', icon: CNSymbol('apple.logo')),
        CNTabBarItem(label: 'Settings', icon: CNSymbol('gearshape.fill')),
      ],
      currentIndex: _tabIndex,
      onTap: (i) => setState(() => _tabIndex = i),
    );
  }

  /// Automatic BaseTabBar with Native iOS Detection
  /// This demonstrates the recommended approach using BaseTabBar with SF Symbol metadata
  Widget _buildAutoBaseTabBar() {
    return BaseTabBar(
      // Enable native iOS tab bar (will use CNTabBar on iOS with SF Symbols, Material elsewhere)
      useNativeCupertinoTabBar: true,
      items: [
        // Approach 1: Using convenience factory method with SF Symbols
        BottomNavigationBarItemNativeExtension.withSFSymbol(
          sfSymbolName: SFSymbols.home,
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: 'Home',
        ),

        // Approach 2: Using KeyedSubtree manually for more control
        const BottomNavigationBarItem(
          icon: KeyedSubtree(
            key: BaseNativeTabBarItemKey(SFSymbols.search),
            child: Icon(Icons.search_outlined),
          ),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
                
        // Approach 3: Let BaseTabBar automatically map icon to SF Symbol
        // BaseTabBar will attempt to map Icons.person_outline to 'person.crop.circle'
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),

        // Approach 4: Native Components demo with Apple logo
        const BottomNavigationBarItem(
          icon: KeyedSubtree(
            key: BaseNativeTabBarItemKey('apple.logo'),
            child: Icon(Icons.apple),
          ),
          activeIcon: Icon(Icons.apple),
          label: 'Native',
        ),

        // Approach 5: Settings with gear icon
        BottomNavigationBarItemNativeExtension.withSFSymbol(
          sfSymbolName: SFSymbols.settings,
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          label: 'Settings',
        ),
        
        // Custom Image Examples (commented for reference):
        // BottomNavigationBarItem(
        //   icon: Image.asset(
        //     'assets/custom.png',
        //     key: const BaseCustomImageKey(
        //       materialImage: 'assets/pray_new.png',
        //       imageSize: 28.0,
        //     ),
        //   ),
        //   label: 'Custom',
        // ),
        //
        // BottomNavigationBarItemNativeExtension.withImage(
        //   materialImage: 'assets/custom.png',
        //   imageSize: 28.0,
        //   label: 'Custom',
        // ),
        
        // More custom image examples:
        // BottomNavigationBarItemNativeExtension.withImage(
        //   materialImage: 'assets/icons/custom_settings.png',
        //   iosImage: 'assets/icons/custom_settings_ios.png', // Optional iOS-specific
        //   imageSize: 28.0,  // iOS size in points
        //   width: 24.0,      // Material size
        //   height: 24.0,
        //   label: 'Settings',
        // ),
        //
        // Alternative: Manual approach with BaseCustomImageKey
        // BottomNavigationBarItem(
        //   icon: Image.asset(
        //     'assets/icons/custom.png',
        //     key: const BaseCustomImageKey(
        //       materialImage: 'assets/icons/custom.png',
        //       iosImage: 'assets/icons/custom_ios.png',
        //       imageSize: 28.0,
        //       width: 24.0,
        //       height: 24.0,
        //     ),
        //   ),
        //   label: 'Custom',
        // ),
      ],
      currentIndex: _autoTabIndex,
      onTap: (index) {
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
      child: SingleChildScrollView(
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
                      Text(
                        '📱 5 Tabs Available:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('• Home - This page'),
                      Text('• Search - Search functionality'),
                      Text('• Profile - User profile'),
                      Text('• Native - Cupertino Native Components Demo'),
                      Text('• Settings - App settings'),
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
