import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'search_components_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Base Search Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainDemoPage(),
    );
  }
}

class MainDemoPage extends StatelessWidget {
  const MainDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Base Search Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Search Components Demo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This demo showcases the search functionality added to CNToolbar, CNNavigationBar, and CNTabBar components.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchComponentsDemo(),
                ),
              );
            },
            child: const Text('Open Search Components Demo'),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features Demonstrated:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• CNToolbar.search() with fruit search example'),
                  Text('• CNNavigationBar.search() with contact search'),
                  Text('• CNTabBar.search() with category search'),
                  Text('• Real-time search results with text highlighting'),
                  Text('• Cross-platform Material Design fallbacks'),
                  Text('• Native iOS SF Symbol integration'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}