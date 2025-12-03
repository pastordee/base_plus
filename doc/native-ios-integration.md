# Native iOS Tab Bar Integration Guide

## Overview

Flutter Base now supports automatic native iOS tab bar integration using the `cupertino_native` package with SF Symbols. When enabled, BaseTabBar automatically detects iOS platform and renders authentic iOS 26 tab bars with SF Symbol icons.

## Features

✅ **Automatic Platform Detection** - BaseTabBar switches between Material Design and native iOS CNTabBar automatically  
✅ **SF Symbols Integration** - Use Apple's SF Symbols for authentic iOS iconography  
✅ **Multiple API Approaches** - Choose the method that best fits your workflow  
✅ **Fallback Icon Mapping** - Automatic conversion of common Material icons to SF Symbols  
✅ **Haptic Feedback** - Native iOS haptic feedback on tab selection  
✅ **30+ Common Symbols** - Pre-defined SF Symbol constants via `SFSymbols` helper class

## Quick Start

### Basic Usage

```dart
BaseTabBar(
  useNativeCupertinoTabBar: true, // Enable native iOS tab bar
  items: [
    BottomNavigationBarItemNativeExtension.withSFSymbol(
      sfSymbolName: SFSymbols.home,
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    // ... more items
  ],
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
)
```

## SF Symbol Specification Methods

### Method 1: Convenience Factory (Recommended)

The easiest approach using the provided extension method:

```dart
BaseTabBar(
  useNativeCupertinoTabBar: true,
  items: [
    BottomNavigationBarItemNativeExtension.withSFSymbol(
      sfSymbolName: SFSymbols.home,
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItemNativeExtension.withSFSymbol(
      sfSymbolName: SFSymbols.search,
      icon: Icon(Icons.search_outlined),
      activeIcon: Icon(Icons.search),
      label: 'Search',
    ),
  ],
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
)
```

### Method 2: KeyedSubtree with Metadata

For more control over the widget tree:

```dart
BottomNavigationBarItem(
  icon: KeyedSubtree(
    key: BaseNativeTabBarItemKey(SFSymbols.profile),
    child: Icon(Icons.person_outline),
  ),
  activeIcon: Icon(Icons.person),
  label: 'Profile',
)
```

### Method 3: Automatic Icon Mapping

Let BaseTabBar automatically convert Material icons to SF Symbols:

```dart
BottomNavigationBarItem(
  icon: Icon(Icons.settings_outlined),
  activeIcon: Icon(Icons.settings),
  label: 'Settings',
)
// BaseTabBar will map Icons.settings to 'gearshape.fill'
```

## SFSymbols Helper Class

The `SFSymbols` class provides constants for 30+ common SF Symbol names:

```dart
// Navigation
SFSymbols.home            // 'house.fill'
SFSymbols.search          // 'magnifyingglass'
SFSymbols.profile         // 'person.crop.circle'
SFSymbols.settings        // 'gearshape.fill'

// Communication
SFSymbols.messages        // 'envelope.fill'
SFSymbols.phone           // 'phone.fill'
SFSymbols.notifications   // 'bell.fill'

// Media
SFSymbols.camera          // 'camera.fill'
SFSymbols.photos          // 'photo.fill'
SFSymbols.videos          // 'video.fill'
SFSymbols.music           // 'music.note'

// Organization
SFSymbols.calendar        // 'calendar'
SFSymbols.folder          // 'folder.fill'
SFSymbols.bookmark        // 'bookmark.fill'
SFSymbols.tag             // 'tag.fill'

// Actions
SFSymbols.add             // 'plus.circle.fill'
SFSymbols.remove          // 'minus.circle.fill'
SFSymbols.edit            // 'pencil'
SFSymbols.share           // 'square.and.arrow.up'
SFSymbols.download        // 'arrow.down.circle.fill'

// And more...
```

See `lib/src/tabbar/base_native_tab_bar_item.dart` for the complete list.

## Complete Example

```dart
import 'package:base_plus/base.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BaseTabBar(
        // Enable native iOS tab bar
        useNativeCupertinoTabBar: true,
        
        items: [
          // Using convenience factory
          BottomNavigationBarItemNativeExtension.withSFSymbol(
            sfSymbolName: SFSymbols.home,
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          
          // Using KeyedSubtree
          BottomNavigationBarItem(
            icon: KeyedSubtree(
              key: BaseNativeTabBarItemKey(SFSymbols.search),
              child: Icon(Icons.search_outlined),
            ),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          
          // Using automatic mapping
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
```

## Icon Mapping Table

BaseTabBar includes automatic mapping for common Material icons to SF Symbols:

| Material Icon | SF Symbol |
|--------------|-----------|
| `Icons.home` / `Icons.home_outlined` | `house.fill` |
| `Icons.search` / `Icons.search_outlined` | `magnifyingglass` |
| `Icons.person` / `Icons.person_outline` | `person.crop.circle` |
| `Icons.settings` / `Icons.settings_outlined` | `gearshape.fill` |
| `Icons.favorite` / `Icons.favorite_outline` | `heart.fill` |
| `Icons.notifications` / `Icons.notifications_outlined` | `bell.fill` |
| `Icons.email` / `Icons.email_outlined` | `envelope.fill` |
| `Icons.phone` / `Icons.phone_outlined` | `phone.fill` |
| `Icons.camera` / `Icons.camera_outlined` | `camera.fill` |
| `Icons.photo` / `Icons.photo_outlined` | `photo.fill` |
| And more... | See source code for complete mappings |

## Configuration Options

### useNativeCupertinoTabBar

Controls whether to use CNTabBar on iOS (default: `true`):

```dart
BaseTabBar(
  useNativeCupertinoTabBar: true, // Use native iOS tab bar
  // ... items
)
```

Set to `false` to force Material Design on all platforms:

```dart
BaseTabBar(
  useNativeCupertinoTabBar: false, // Use Material Design everywhere
  // ... items
)
```

### Liquid Glass Effects

Enable iOS 26 Liquid Glass visual effects:

```dart
BaseTabBar(
  enableLiquidGlass: true,       // Enable liquid glass effects
  glassOpacity: 0.85,            // Glass transparency (0.0 - 1.0)
  reflectionIntensity: 0.6,      // Reflection intensity (0.0 - 1.0)
  adaptiveInteraction: true,     // Dynamic interaction states
  hapticFeedback: true,          // Haptic feedback on selection
  // ... items
)
```

## Platform Behavior

- **iOS with useNativeCupertinoTabBar: true** → Uses CNTabBar with SF Symbols
- **iOS with useNativeCupertinoTabBar: false** → Uses Material Design BottomNavigationBar
- **Android/Other platforms** → Always uses Material Design BottomNavigationBar

## Finding SF Symbol Names

To find SF Symbol names for other icons:

1. **SF Symbols App** (macOS only)
   - Download from Apple: https://developer.apple.com/sf-symbols/
   - Browse and search for symbols
   - Copy symbol names directly

2. **Online Resources**
   - https://sfsymbols.com/
   - https://hotpot.ai/free-icons/sf-symbols

3. **Common Naming Patterns**
   - `.fill` suffix for filled versions: `heart.fill`, `star.fill`
   - `.circle` suffix for circular variants: `info.circle`, `questionmark.circle`
   - Descriptive names: `house`, `magnifyingglass`, `gearshape`

## Demo

See `/example/lib/demos/bottom_navigation_example.dart` for a complete working example demonstrating:
- Material Design approach
- Native iOS CNTabBar direct usage
- Automatic BaseTabBar with SF Symbol metadata

Run the example app and use the menu button to switch between approaches.

## Troubleshooting

### Icons not showing on iOS

Make sure:
1. `cupertino_native` package is properly installed
2. `useNativeCupertinoTabBar` is set to `true`
3. SF Symbol names are correct (check spelling and capitalization)

### Automatic mapping not working

If automatic icon mapping doesn't work for your icon:
- Use Method 1 or Method 2 to explicitly specify the SF Symbol
- Check if the icon has a mapping in `_mapIconToSFSymbol()` method
- Consider adding a custom mapping or using a different SF Symbol

### CNTabBar not appearing

Ensure:
1. Running on iOS device or simulator
2. `cupertino_native` package is uncommented in `pubspec.yaml`
3. No conflicting `baseParam` settings (e.g., `forceUseMaterial: true`)

## API Reference

### Classes

- **BaseTabBar** - Main tab bar widget with automatic platform detection
- **BaseNativeTabBarItemKey** - ValueKey for SF Symbol metadata
- **BottomNavigationBarItemNativeExtension** - Convenience methods for creating items with SF Symbols
- **SFSymbols** - Constants for common SF Symbol names

### Methods

- **BottomNavigationBarItemNativeExtension.withSFSymbol()** - Factory method for creating items with SF Symbols

### Properties

- **useNativeCupertinoTabBar** - Enable/disable native iOS tab bar (default: true)
- **enableLiquidGlass** - Enable iOS 26 Liquid Glass effects (default: true)
- **glassOpacity** - Glass transparency level (default: 0.85)
- **reflectionIntensity** - Reflection intensity (default: 0.6)
- **adaptiveInteraction** - Dynamic interaction states (default: true)
- **hapticFeedback** - Haptic feedback on selection (default: true)

## Dependencies

- `cupertino_native: ^0.1.1` - Native iOS components including CNTabBar and SF Symbols

## Next Steps

Explore other cupertino_native components for additional native iOS features:
- `CNButton` - Native iOS buttons
- `CNIcon` - SF Symbol icons
- `CNPopupMenuButton` - Native popup menus
- `CNSwitch` - Native iOS switches
- `CNSlider` - Native iOS sliders
- `CNSegmentedControl` - Native segmented controls

## Resources

- [SF Symbols Documentation](https://developer.apple.com/sf-symbols/)
- [cupertino_native Package](https://pub.dev/packages/cupertino_native)
- [Flutter Base Documentation](../README.md)
