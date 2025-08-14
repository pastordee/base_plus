# BaseNavigationDrawer

**Cross-platform Material drawer component that eliminates the need for manual `forceUseMaterial` configuration**

## Overview

BaseNavigationDrawer is a Flutter Base component that automatically provides Material design drawer functionality across all platforms, including iOS. This eliminates the need to manually specify `baseParam: BaseParam(forceUseMaterial: true)` when using drawers on iOS or other platforms.

## Features

- ✅ **Automatic Material Design Enforcement**: Automatically uses Material drawer design on all platforms
- ✅ **Cross-Platform Consistency**: Provides consistent drawer behavior on iOS, Android, and other platforms
- ✅ **iOS 26 Liquid Glass Compatibility**: Seamlessly integrates with iOS 26 Liquid Glass Dynamic Material effects
- ✅ **Zero Configuration**: No need for manual `forceUseMaterial` parameter specification
- ✅ **Full Drawer API Support**: Supports all standard Material Drawer properties
- ✅ **BaseScaffold Integration**: Works seamlessly with BaseScaffold's drawer property

## Usage

### Basic Usage

```dart
BaseScaffold(
  appBar: BaseAppBar(title: Text('My App')),
  drawer: BaseNavigationDrawer(
    child: YourDrawerContent(),
  ),
  body: YourPageContent(),
)
```

### Advanced Usage with Properties

```dart
BaseScaffold(
  drawer: BaseNavigationDrawer(
    width: 280,
    backgroundColor: Colors.white,
    elevation: 8.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(
        right: Radius.circular(16),
      ),
    ),
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('Header'),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () => Navigator.pop(context),
        ),
        // More drawer items...
      ],
    ),
  ),
  endDrawer: BaseNavigationDrawer(
    child: SettingsDrawerContent(),
  ),
)
```

## Before vs After

### Before (Manual Configuration Required)
```dart
// ❌ Required manual forceUseMaterial parameter
BaseScaffold(
  drawer: Material(
    child: YourDrawerContent(),
  ),
  baseParam: BaseParam(forceUseMaterial: true), // Manual configuration
)
```

### After (Automatic Configuration)
```dart
// ✅ Automatic Material design enforcement
BaseScaffold(
  drawer: BaseNavigationDrawer(
    child: YourDrawerContent(),
  ),
  // No baseParam needed!
)
```

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `child` | `Widget` | **Required.** The primary content of the drawer |
| `backgroundColor` | `Color?` | The color to paint the drawer's background |
| `shadowColor` | `Color?` | The color used to paint the drop shadow |
| `surfaceTintColor` | `Color?` | The surface tint color overlay |
| `elevation` | `double?` | The z-coordinate elevation |
| `shape` | `ShapeBorder?` | The shape of the drawer |
| `width` | `double?` | The width of the drawer (default: 304.0) |
| `semanticLabel` | `String?` | Accessibility label for screen readers |
| `clipBehavior` | `Clip` | How to clip the drawer content (default: `Clip.hardEdge`) |

## Implementation Details

BaseNavigationDrawer automatically:

1. **Forces Material Design**: Overrides the `valueOf` method to ensure `forceUseMaterial: true` is always applied
2. **Cross-Platform Rendering**: Uses `buildByMaterial()` for both Cupertino and Material modes
3. **Parameter Inheritance**: Preserves all other `BaseParam` settings while enforcing Material design
4. **Theme Integration**: Automatically inherits Material theme colors and styles

## Typical Drawer Content

```dart
ListView(
  padding: EdgeInsets.zero,
  children: [
    DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.account_circle, size: 64, color: Colors.white),
          SizedBox(height: 8),
          Text(
            'User Name',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            'user@example.com',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ),
    ListTile(
      leading: Icon(Icons.home),
      title: Text('Home'),
      onTap: () => Navigator.pop(context),
    ),
    ListTile(
      leading: Icon(Icons.settings),
      title: Text('Settings'),
      onTap: () => Navigator.pop(context),
    ),
    Divider(),
    ListTile(
      leading: Icon(Icons.logout),
      title: Text('Sign Out'),
      onTap: () => Navigator.pop(context),
    ),
  ],
)
```

## Enhanced: 2025.08.14 for Flutter Base v3.0.0+1
