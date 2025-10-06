# Custom Images in Tab Bars

This guide explains how to use custom images (PNG, SVG, etc.) in your tab bar icons with `BaseTabBar` and native iOS integration.

## Overview

`BaseTabBar` supports multiple icon types:
1. **Material Icons** → Auto-mapped to SF Symbols on iOS
2. **SF Symbols** → Explicit SF Symbol specification  
3. **Custom Images** → Your own image assets

## Custom Image Support

### How It Works

- **iOS with CNTabBar**: CNTabBar (native iOS tab bar) **only supports SF Symbols**
- **Custom images on iOS**: BaseTabBar **automatically falls back** to standard `CupertinoTabBar` which supports any widget
- **Android/Material**: Custom images work seamlessly with `BottomNavigationBar`

### Platform-Specific Images

Use `BaseCustomImageKey` to specify different images for Material and iOS:

```dart
BottomNavigationBarItem(
  icon: Image.asset(
    'assets/icons/home.png',
    key: const BaseCustomImageKey(
      materialImage: 'assets/icons/home_material.png',
      iosImage: 'assets/icons/home_ios.png',
      width: 24,
      height: 24,
    ),
  ),
  label: 'Home',
)
```

### Single Image for All Platforms

If you don't need platform-specific images, just specify `materialImage`:

```dart
BottomNavigationBarItem(
  icon: Image.asset(
    'assets/icons/home.png',
    key: const BaseCustomImageKey(
      materialImage: 'assets/icons/home.png',
      width: 24,
      height: 24,
    ),
  ),
  label: 'Home',
)
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_base/base_widgets.dart';

class CustomImageTabBar extends StatefulWidget {
  @override
  State<CustomImageTabBar> createState() => _CustomImageTabBarState();
}

class _CustomImageTabBarState extends State<CustomImageTabBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseTabBar(
      useNativeCupertinoTabBar: true,
      items: [
        // Mix SF Symbols and custom images
        BottomNavigationBarItemNativeExtension.withSFSymbol(
          sfSymbolName: SFSymbols.home,
          icon: const Icon(Icons.home_outlined),
          label: 'Home',
        ),
        
        // Custom image with platform-specific assets
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/analytics.png',
            key: const BaseCustomImageKey(
              materialImage: 'assets/icons/analytics.png',
              iosImage: 'assets/icons/analytics_ios.png',
              width: 24,
              height: 24,
            ),
          ),
          label: 'Analytics',
        ),
        
        // Custom image (same for all platforms)
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/custom_profile.png',
            key: const BaseCustomImageKey(
              materialImage: 'assets/icons/custom_profile.png',
              width: 24,
              height: 24,
            ),
          ),
          label: 'Profile',
        ),
        
        // Auto-mapped Material icon
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }
}
```

## BaseCustomImageKey API

```dart
class BaseCustomImageKey {
  const BaseCustomImageKey({
    required String materialImage,  // Required: Asset path for Material design
    String? iosImage,                // Optional: iOS-specific asset path
    double width = 24.0,             // Icon width in the tab bar
    double height = 24.0,            // Icon height in the tab bar
  });
}
```

### Properties

- **`materialImage`** (required): Path to the image asset used on Android/Material design
- **`iosImage`** (optional): Path to iOS-specific image. If not provided, `materialImage` is used
- **`width`**: Width of the image in logical pixels (default: 24.0)
- **`height`**: Height of the image in logical pixels (default: 24.0)

## Asset Setup

### 1. Add images to your project

```
your_app/
  assets/
    icons/
      home.png
      home@2x.png
      home@3x.png
      analytics_material.png
      analytics_ios.png
```

### 2. Declare in pubspec.yaml

```yaml
flutter:
  assets:
    - assets/icons/
```

## Best Practices

### Icon Design

1. **Size**: Design at 24x24 dp (48x48px @2x, 72x72px @3x)
2. **Format**: PNG with transparency or SVG
3. **Style**: Match platform guidelines
   - Material: 24dp icons with 2dp stroke
   - iOS: Centered, clear at small sizes

### Platform Consistency

#### Option 1: Different Images Per Platform
```dart
BaseCustomImageKey(
  materialImage: 'assets/material_style_icon.png',
  iosImage: 'assets/ios_style_icon.png',
)
```

#### Option 2: Universal Image
```dart
BaseCustomImageKey(
  materialImage: 'assets/universal_icon.png',
)
```

### Performance

- **Preload images** in app initialization to avoid loading delays
- Use **asset bundles** for better performance than network images
- Consider **vector assets** (SVG) for resolution independence

## Behavior Matrix

| Icon Type | Material (Android) | iOS (useNativeCupertinoTabBar: true) |
|-----------|-------------------|-------------------------------------|
| Material Icon | BottomNavigationBar | CNTabBar (auto-mapped to SF Symbol) |
| SF Symbol (explicit) | BottomNavigationBar (shows Material icon) | CNTabBar (SF Symbol) |
| Custom Image | BottomNavigationBar (image) | CupertinoTabBar (image) ⚠️ |
| Mixed | BottomNavigationBar | CupertinoTabBar (if any custom images) |

⚠️ **Important**: If **any** tab item uses a custom image, `BaseTabBar` falls back from `CNTabBar` to standard `CupertinoTabBar` because CNTabBar only supports SF Symbols.

## Automatic Fallback

When `useNativeCupertinoTabBar: true` and custom images are detected:

```dart
// BaseTabBar internally:
bool hasCustomImages = items.any((item) => 
  item.icon is Image || 
  (item.icon has BaseCustomImageKey)
);

if (hasCustomImages) {
  return buildCupertinoTabBar(context); // Standard tab bar with image support
} else {
  return CNTabBar(...); // Native iOS tab bar with SF Symbols only
}
```

## Combining Approaches

You can mix different icon specification methods:

```dart
BaseTabBar(
  items: [
    // SF Symbol (CNTabBar on iOS)
    BottomNavigationBarItemNativeExtension.withSFSymbol(
      sfSymbolName: 'house.fill',
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    
    // Custom image (triggers fallback to CupertinoTabBar)
    BottomNavigationBarItem(
      icon: Image.asset('assets/custom.png'),
      label: 'Custom',
    ),
  ],
)
```

**Result**: BaseTabBar uses standard `CupertinoTabBar` to support the custom image.

## SVG Support

To use SVG images, add `flutter_svg` package:

```yaml
dependencies:
  flutter_svg: ^2.0.0
```

Then use `SvgPicture.asset`:

```dart
BottomNavigationBarItem(
  icon: SvgPicture.asset(
    'assets/icons/custom.svg',
    key: const BaseCustomImageKey(
      materialImage: 'assets/icons/custom.svg',
      width: 24,
      height: 24,
    ),
  ),
  label: 'Custom',
)
```

## Migration Guide

### From Material Icons

**Before:**
```dart
BottomNavigationBarItem(
  icon: Icon(Icons.dashboard),
  label: 'Dashboard',
)
```

**After (with custom image):**
```dart
BottomNavigationBarItem(
  icon: Image.asset(
    'assets/icons/dashboard.png',
    key: const BaseCustomImageKey(
      materialImage: 'assets/icons/dashboard.png',
      width: 24,
      height: 24,
    ),
  ),
  label: 'Dashboard',
)
```

### From Direct Image.asset

**Before:**
```dart
BottomNavigationBarItem(
  icon: Image.asset('assets/home.png', width: 24, height: 24),
  label: 'Home',
)
```

**After (with platform detection):**
```dart
BottomNavigationBarItem(
  icon: Image.asset(
    'assets/home.png',
    key: const BaseCustomImageKey(
      materialImage: 'assets/home_material.png',
      iosImage: 'assets/home_ios.png',
      width: 24,
      height: 24,
    ),
  ),
  label: 'Home',
)
```

## Troubleshooting

### Images not showing

1. **Check asset declaration** in `pubspec.yaml`
2. **Verify file paths** match exactly
3. **Run** `flutter clean` and rebuild

### Wrong platform image

- Ensure `BaseCustomImageKey` is set correctly
- Check that `materialImage` is always specified
- Verify `iosImage` path exists in assets

### CNTabBar not used

- If **any** item has a custom image, BaseTabBar falls back to `CupertinoTabBar`
- This is expected behavior since CNTabBar only supports SF Symbols
- To use CNTabBar, all icons must be Material Icons or SF Symbols

## See Also

- [iOS Native Tab Bar Guide](ios-native-tabbar-guide.md)
- [SF Symbols Reference](sf-symbols-reference.md)
- [Architecture Diagram](architecture-diagram.md)
- [Migration Guide](migration-guide.md)
