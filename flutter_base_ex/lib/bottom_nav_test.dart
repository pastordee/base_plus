import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'demos/bottom_navigation_example.dart';

/// Simple test app to demonstrate bottom navigation with BaseScaffold
void main() {
  runApp(const BottomNavTestApp());
}

class BottomNavTestApp extends StatelessWidget {
  const BottomNavTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      title: 'Bottom Navigation Test',
      home: const BottomNavigationExample(),
      // Use Material 3 design with seed color
      lightTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
