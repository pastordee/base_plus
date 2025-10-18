import 'package:flutter/material.dart';
import 'package:base/base.dart';

/// Demo showcasing BaseScaffold theme-aware background color with forceUseMaterial
class BaseScaffoldThemeDemo extends StatefulWidget {
  const BaseScaffoldThemeDemo({Key? key}) : super(key: key);

  @override
  State<BaseScaffoldThemeDemo> createState() => _BaseScaffoldThemeDemoState();
}

class _BaseScaffoldThemeDemoState extends State<BaseScaffoldThemeDemo> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BaseScaffold Theme Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50], // Light theme background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900], // Dark theme background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: _themeMode,
      home: BaseScaffold(
        // This BaseScaffold will now automatically use theme colors
        // when forceUseMaterial is true and no backgroundColor is specified
        baseParam: BaseParam(
          forceUseMaterial: true, // Force Material mode (important for iOS)
        ),
        appBar: BaseAppBar(
          title: const Text('Theme-Aware BaseScaffold'),
          actions: [
            PopupMenuButton<ThemeMode>(
              icon: const Icon(Icons.brightness_6),
              onSelected: (ThemeMode mode) {
                setState(() {
                  _themeMode = mode;
                });
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: ThemeMode.system,
                  child: Text('Follow System'),
                ),
                const PopupMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                const PopupMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BaseScaffold Theme Integration',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'This BaseScaffold automatically uses the current theme\'s '
                        'scaffold background color when:\n\n'
                        '• forceUseMaterial: true is set\n'
                        '• No explicit backgroundColor is provided\n'
                        '• Supports both light and dark themes',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Theme Info',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Theme Mode: ${_themeMode.toString().split('.').last}'),
                      Text('Brightness: ${Theme.of(context).brightness.toString().split('.').last}'),
                      Text('Scaffold Background: ${Theme.of(context).scaffoldBackgroundColor}'),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Instructions',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1. Use the brightness icon in the app bar to switch themes\n'
                        '2. Notice how the scaffold background automatically adapts\n'
                        '3. The background color changes between light and dark themes\n'
                        '4. No explicit backgroundColor was set in the BaseScaffold',
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Theme Integration Working!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'BaseScaffold automatically uses theme colors',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Entry point for the demo
void main() {
  runApp(const BaseScaffoldThemeDemo());
}
