import 'package:base_plus/base.dart';
import 'package:flutter/material.dart';

/// Standalone test app specifically for testing bottom navigation
void main() {
  runApp(const StandaloneBottomNavTest());
}

class StandaloneBottomNavTest extends StatelessWidget {
  const StandaloneBottomNavTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      title: 'Bottom Nav Test',
      home: const TestBottomNavigation(),
      // Force Material design with explicit theme
      baseTheme: BaseThemeData(
        platformMode: const BasePlatformMode(
          iOS: BaseMode.material,
          macOS: BaseMode.material,
          android: BaseMode.material,
        ),
        materialTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TestBottomNavigation extends StatefulWidget {
  const TestBottomNavigation({Key? key}) : super(key: key);

  @override
  State<TestBottomNavigation> createState() => _TestBottomNavigationState();
}

class _TestBottomNavigationState extends State<TestBottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text('Home Page', style: TextStyle(fontSize: 24)),
          Text('Bottom navigation should be visible!'),
        ],
      ),
    ),
    const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text('Search Page', style: TextStyle(fontSize: 24)),
          Text('Tab 2 - Bottom nav working!'),
        ],
      ),
    ),
    const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text('Profile Page', style: TextStyle(fontSize: 24)),
          Text('Tab 3 - Navigation success!'),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      // Explicitly force Material mode
      baseParam: BaseParam(forceUseMaterial: true),
      appBar: BaseAppBar(
        title: const Text('Bottom Navigation Test'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Debug information
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.yellow.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Platform: ${Theme.of(context).platform}'),
                Text('Material3: ${Theme.of(context).useMaterial3}'),
                Text('Current Tab: $_currentIndex'),
                const Text('Bottom navigation should appear below'),
              ],
            ),
          ),
          Expanded(child: _pages[_currentIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          print('Tapped tab: $index'); // Debug print
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
