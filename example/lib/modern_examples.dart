/// Modern design pattern examples using base_plus
///
/// Demonstrates the latest Material 3 design patterns and iOS design conventions
/// including updated button hierarchies, colors, and component styling.

// Modern Flutter Base Usage Examples
// This file demonstrates the updated Material 3 and iOS design patterns

import 'package:flutter/material.dart';
import 'package:base_plus/base.dart';

class ModernButtonExamples extends StatelessWidget {
  const ModernButtonExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text('Modern Design Patterns'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Material 3 Button Hierarchy',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            
            // Primary action - Filled Button (Material 3)
            BaseButton(
              child: Text('Primary Action'),
              filledButton: true,
              onPressed: () {},
            ),
            SizedBox(height: 8),
            
            // Secondary action - Filled Tonal Button (Material 3)
            BaseButton(
              child: Text('Secondary Action'),
              filledTonalButton: true,
              onPressed: () {},
            ),
            SizedBox(height: 8),
            
            // Tertiary action - Outlined Button
            BaseButton(
              child: Text('Tertiary Action'),
              outlinedButton: true,
              onPressed: () {},
            ),
            SizedBox(height: 8),
            
            // Low emphasis - Text Button
            BaseButton(
              child: Text('Low Emphasis'),
              textButton: true,
              onPressed: () {},
            ),
            
            SizedBox(height: 32),
            
            Text(
              'Icon Buttons',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            
            // Modern icon buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BaseButton.icon(
                  icon: Icon(Icons.download),
                  label: Text('Download'),
                  filledButton: true,
                  onPressed: () {},
                ),
                BaseButton.icon(
                  icon: Icon(Icons.share),
                  label: Text('Share'),
                  filledTonalButton: true,
                  onPressed: () {},
                ),
              ],
            ),
            
            SizedBox(height: 32),
            
            Text(
              'Adaptive Design',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            
            Text(
              'These buttons automatically adapt:\n'
              '• iOS: CupertinoButton with iOS 16+ styling\n'
              '• Android: Material 3 FilledButton\n'
              '• Maintains platform-appropriate feel',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            SizedBox(height: 16),
            
            // Force Material on Cupertino example
            BaseButton(
              child: Text('Force Material on iOS'),
              filledButton: true,
              baseParam: BaseParam(
                cupertino: {'forceUseMaterial': true},
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// Material 3 Theme Setup Example
class ModernAppSetup extends StatelessWidget {
  const ModernAppSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      title: 'Modern Flutter Base App',
      baseTheme: BaseThemeData(
        // Enable Material 3 by default
        useMaterial3: true,
        
        // Custom Material 3 theme with brand colors
        materialTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
        ),
        
        // Dark theme with same seed color
        materialDarkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        
        // Support theme switching
        brightness: Brightness.light,
      ),
      home: ModernButtonExamples(),
    );
  }
}
