// Theme Example with Flutter Base
// This demonstrates how to use BaseApp with direct theme parameters

import 'package:flutter/material.dart';
import 'package:base/base.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

class ThemeExampleApp extends StatelessWidget {
  const ThemeExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      title: 'Flutter Base - Theme Example',
      // Direct theme parameters - new feature!
      lightTheme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const ThemeExampleHome(),
    );
  }
}

class ThemeExampleHome extends StatefulWidget {
  const ThemeExampleHome({Key? key}) : super(key: key);

  @override
  State<ThemeExampleHome> createState() => _ThemeExampleHomeState();
}

class _ThemeExampleHomeState extends State<ThemeExampleHome> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('Theme Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Demo',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            
            // Theme Mode Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme Mode',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildThemeButton('System', ThemeMode.system),
                        const SizedBox(width: 8),
                        _buildThemeButton('Light', ThemeMode.light),
                        const SizedBox(width: 8),
                        _buildThemeButton('Dark', ThemeMode.dark),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Component Examples
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Component Examples',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    // Buttons
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Elevated Button'),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Outlined Button'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Text Button'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Color Indicators
                    Text(
                      'Color Scheme',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildColorIndicator(
                          'Primary',
                          Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        _buildColorIndicator(
                          'Secondary',
                          Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        _buildColorIndicator(
                          'Surface',
                          Theme.of(context).colorScheme.surface,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Theme Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current Brightness: ${Theme.of(context).brightness.toString().split('.').last}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Material 3: ${Theme.of(context).useMaterial3}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Current Theme Mode: ${_themeMode.toString().split('.').last}',
                      style: Theme.of(context).textTheme.bodyMedium,
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

  Widget _buildThemeButton(String title, ThemeMode mode) {
    final isSelected = _themeMode == mode;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _themeMode = mode;
        });
        // Note: In a real app, you'd need to rebuild the BaseApp with the new themeMode
        // This could be done using state management like GetX, Provider, or inherited widgets
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected 
            ? Theme.of(context).colorScheme.primary 
            : Theme.of(context).colorScheme.surface,
        foregroundColor: isSelected 
            ? Theme.of(context).colorScheme.onPrimary 
            : Theme.of(context).colorScheme.onSurface,
      ),
      child: Text(title),
    );
  }

  Widget _buildColorIndicator(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

// Alternative BaseApp usage with BaseThemeData (existing method)
class AlternativeThemeApp extends StatelessWidget {
  const AlternativeThemeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      title: 'Flutter Base - BaseTheme Example',
      // Using BaseThemeData (existing method)
      baseTheme: BaseThemeData(
        materialTheme: AppTheme.lightTheme,
        materialDarkTheme: AppTheme.darkTheme,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const ThemeExampleHome(),
    );
  }
}

void main() {
  runApp(const ThemeExampleApp());
}
