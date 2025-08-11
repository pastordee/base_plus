# BaseBottomNavigationBar and BaseCrossPlatformTabScaffold

## Overview

We've created two new cross-platform components that provide unified bottom navigation across iOS and Android platforms:

1. **BaseBottomNavigationBar** - A platform-adaptive bottom navigation bar component
2. **BaseCrossPlatformTabScaffold** - A complete scaffold solution with integrated bottom navigation

Note: This is separate from the existing `BaseTabScaffold` in the scaffold directory, which uses a different API.

## BaseBottomNavigationBar

### Purpose
Provides a unified API for bottom navigation that automatically adapts to the platform:
- **iOS/Cupertino**: Returns `CupertinoTabBar`
- **Android/Material**: Returns `BottomNavigationBar`

### Usage
```dart
BaseScaffold(
  bottomNavigationBar: BaseBottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    ],
    currentIndex: currentIndex,
    onTap: (index) => setState(() => currentIndex = index),
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
  ),
)
```

### Properties
- **Cross-platform**: `items`, `currentIndex`, `onTap`, `selectedItemColor`, `unselectedItemColor`
- **Material-specific**: `type`, `elevation`, `showSelectedLabels`, `landscapeLayout`
- **Cupertino-specific**: `activeColor`, `inactiveColor`, `border`, `height`

## BaseCrossPlatformTabScaffold

### Purpose
A complete scaffold solution that handles the entire tab structure:
- **iOS/Cupertino**: Uses `CupertinoTabScaffold` with `CupertinoTabBar`
- **Android/Material**: Uses `Scaffold` with `BottomNavigationBar`

### Key Advantage
Unlike `BaseBottomNavigationBar` which only provides the navigation bar, `BaseCrossPlatformTabScaffold` handles:
- Complete scaffold structure
- Tab content management
- Platform-specific navigation patterns
- App bar integration (Material only)

### Usage
```dart
BaseCrossPlatformTabScaffold(
  appBar: BaseAppBar(title: Text('My App')), // Material only
  currentIndex: currentIndex,
  onTap: (index) => setState(() => currentIndex = index),
  tabs: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
  ],
  tabBuilder: (context, index) {
    return pages[index]; // Return page content for each tab
  },
)
```

## When to Use Which

### Use BaseBottomNavigationBar when:
- You want to integrate with existing `BaseScaffold` structure
- You need fine control over the scaffold body
- You're adding navigation to an existing page structure

### Use BaseCrossPlatformTabScaffold when:
- You want a complete tab-based application structure
- You want automatic platform adaptation without configuration
- You're building a new tabbed application from scratch
- You want the most native experience on each platform

## Platform Behavior

### iOS/Cupertino Mode
- **BaseBottomNavigationBar**: Returns `CupertinoTabBar` that must be used with `CupertinoTabScaffold`
- **BaseCrossPlatformTabScaffold**: Uses `CupertinoTabScaffold` which provides native iOS tab behavior

### Android/Material Mode
- **BaseBottomNavigationBar**: Returns standard `BottomNavigationBar`
- **BaseCrossPlatformTabScaffold**: Uses `Scaffold` with `BottomNavigationBar` and optional `AppBar`

## Examples

See the demo applications:
- `bottom_navigation_example.dart` - Shows `BaseBottomNavigationBar` with `BaseScaffold`
- `base_tab_scaffold_example.dart` - Shows complete `BaseTabScaffold` implementation

Both examples demonstrate:
- Cross-platform adaptation
- Platform-specific styling
- Proper state management
- Responsive design patterns

## Migration

If you're currently using:
```dart
// Old approach - forces Material mode
BaseScaffold(
  baseParam: BaseParam(forceUseMaterial: true),
  bottomNavigationBar: BottomNavigationBar(...),
)
```

You can now use:
```dart
// New approach - automatic platform adaptation
BaseCrossPlatformTabScaffold(
  tabs: [...],
  tabBuilder: (context, index) => pages[index],
)
```

This provides true cross-platform behavior without forcing a specific design language.
