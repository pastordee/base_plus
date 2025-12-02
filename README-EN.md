<p align="center">
  <img src="https://github.com/nillnil/flutter_base/blob/master/screenshot/logo.png?raw=true" alt="logo">
</p>

# flutter_base

> One code, two modes, use cupertino's widgets on iOS, use material's widgets on Android or fuchsia.
> 
> **🆕 v3.0.0+1 New Features**: Material 3 support, GetX state management integration, iOS 16+ modern design

## [简体中文](./README.md)

## ✨ Key Features

- 🎨 **Adaptive Design**: Automatically uses Cupertino on iOS, Material on Android
- 🚀 **Material 3 Support**: Latest Material You design system with dynamic colors
- ⚡ **GetX Integration**: Optional reactive state management and routing system  
- 📱 **Modern iOS Design**: Support for iOS 16+ design patterns
- 🔧 **Backward Compatible**: 100% compatible with existing code, progressive upgrade
- 🎯 **Flutter 3.10+**: Support for latest Flutter SDK and Dart 3.0+

## 🚀 Quick Start

### Installing

For some reasons, the version on https://pub.dev/ is older, please use the GitHub version:

```yaml
dependencies: 
  base:
    git:
      url: git://github.com/pastordee/flutter_base
      ref: v3.0.0+1  # Use latest version
  get: ^4.6.6  # Optional: If you need GetX features
```

### Basic Usage

```dart
import 'package:base_plus/base.dart';

BaseApp(
  title: 'My App',
  
  // Enable Material 3 (Recommended)
  baseTheme: BaseThemeData(
    useMaterial3: true,
    materialTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
  ),
  
  home: MyHomePage(),
)
```

### GetX Integration (Optional)

```dart
BaseApp(
  title: 'My GetX App',
  
  // Enable GetX features
  useGetX: true,
  
  // GetX routing configuration
  getPages: [
    GetPage(name: '/', page: () => HomePage()),
    GetPage(name: '/settings', page: () => SettingsPage()),
  ],
  
  // Material 3 theming
  baseTheme: BaseThemeData(useMaterial3: true),
)
```

## 🎨 Modern Button System

### Material 3 Button Hierarchy

```dart
// Primary action (highest emphasis)
BaseButton(
  child: Text('Primary Action'),
  filledButton: true,  // Material 3 filled button
  onPressed: () {},
)

// Secondary action (medium emphasis)
BaseButton(
  child: Text('Secondary Action'),
  filledTonalButton: true,  // Material 3 tonal button
  onPressed: () {},
)

// Other actions
BaseButton(elevatedButton: true, ...)  // Elevated button
BaseButton(outlinedButton: true, ...)  // Outlined button  
BaseButton(textButton: true, ...)      // Text button
```

## 🌐 Native Components with Platform Adaptation

### BaseNativeSheet
Cross-platform sheet presentation with iOS UISheetPresentationController:

```dart
// iOS: Native UISheetPresentationController
// Android/Web: Material BottomSheet fallback
await BaseNativeSheet.show(
  context: context,
  title: 'Settings',
  items: [
    CNSheetItem(title: 'Brightness', icon: 'sun.max'),
    CNSheetItem(title: 'Appearance', icon: 'moon'),
  ],
  detents: [CNSheetDetent.medium],
)
```

### BaseToolbar
Flexible native iOS toolbar with Material fallback:

```dart
// iOS: Native UIToolbar (cupertino_native)
// Android/Web: Material AppBar-style toolbar
BaseToolbar(
  leading: [
    BaseToolbarAction(
      label: 'Back',
      onPressed: () {},
    ),
  ],
  middle: [
    BaseToolbarAction(
      icon: const CNSymbol('pencil'),
      onPressed: () {},
    ),
  ],
)
```

### BaseNavigationBar
Native iOS navigation bar with Material support:

```dart
// iOS: Native UINavigationBar
// Android/Web: Material AppBar
BaseNavigationBar(
  leadingActions: [
    BaseNavigationBarAction(
      icon: const CNSymbol('chevron.left'),
      onPressed: () {},
    ),
  ],
  title: 'My Page',
  trailingActions: [
    BaseNavigationBarAction(
      icon: const CNSymbol('gear'),
      onPressed: () {},
    ),
  ],
)
```

### BasePullDownButton
Cross-platform pull-down menu with platform-specific rendering:

```dart
// iOS: Native UIButton.menu (iOS 16+)
// Android/Web: Material 3 PopupMenuButton
BasePullDownButton.icon(
  buttonIcon: CNSymbol('ellipsis.circle'),
  items: [
    BasePullDownMenuItem(label: 'Edit', icon: CNSymbol('pencil')),
    BasePullDownMenuDivider(),
    BasePullDownMenuItem(
      label: 'Delete',
      icon: CNSymbol('trash'),
      isDestructive: true,
    ),
  ],
  onSelected: (index) {},
)
```

## 🎨 Modern Button System

### Material 3 Button Hierarchy

```dart
// Primary action (highest emphasis)
BaseButton(
  child: Text('Primary Action'),
  filledButton: true,  // Material 3 filled button
  onPressed: () {},
)

// Secondary action (medium emphasis)
BaseButton(
  child: Text('Secondary Action'),
  filledTonalButton: true,  // Material 3 tonal button
  onPressed: () {},
)

// Other actions
BaseButton(elevatedButton: true, ...)  // Elevated button
BaseButton(outlinedButton: true, ...)  // Outlined button  
BaseButton(textButton: true, ...)      // Text button
```

## 📱 Platform Adaptation

### Complete Cross-Platform Support

| Component | iOS | Android | Web |
|-----------|-----|---------|-----|
| **BaseButton** | ✅ CupertinoButton | ✅ Material 3 FilledButton | ✅ Material 3 FilledButton |
| **Native Sheets** | ✅ UISheetPresentationController | ✅ Material BottomSheet | ✅ Material BottomSheet |
| **Native Toolbar** | ✅ UIToolbar | ✅ Material AppBar | ✅ Material AppBar |
| **Native Navigation** | ✅ UINavigationBar | ✅ Material AppBar | ✅ Material AppBar |
| **Pull-down Menu** | ✅ Native UIButton Menu | ✅ Material 3 PopupMenu | ✅ Material 3 PopupMenu |
| **SF Symbols** | ✅ Native Symbols | ✅ Material Icon Fallback | ✅ Material Icon Fallback |

### Design System Details

| Platform | Design System | Button Style | Navigation | Icons |
|----------|---------------|--------------|------------|-------|
| iOS | Cupertino + iOS 16+ | CupertinoButton (iOS 16+ style) | Native iOS navigation | SF Symbols (Native) |
| Android | Material 3 (Material You) | FilledButton (Material You) | Material navigation | Material Icons (400+ mappings) |
| Web | Material 3 (Responsive) | Responsive design | Modern web experience | Material Icons (400+ mappings) |

### SF Symbol Fallback System
All SF Symbols used on iOS automatically fallback to Material Icons on Android and Web:
- **400+ Symbol Mappings**: Comprehensive coverage of common SF Symbols
- **Smart Fallbacks**: Intelligent matching of iOS symbols to Material equivalents
- **Automatic Conversion**: No manual mapping needed, works transparently

**Supported Symbol Categories:**
- Navigation (chevron, arrow variants)
- Media & Editing (camera, photo, pencil, trash)
- Communication (envelope, phone, message, bell)
- File Management (doc, folder variants)
- Text Formatting (bold, italic, underline, strikethrough)
- Layout (grid, list variants)
- Time & Date (clock, calendar)
- Favorites (star, heart, bookmark)

## 🔄 Migration Guide

### Upgrading from v2.x to v3.0

Existing code works unchanged, new features are opt-in:

```dart
// Old version code continues to work
BaseApp(
  home: MyPage(),
  // Existing configuration remains unchanged
)

// Enable new features (optional)
BaseApp(
  baseTheme: BaseThemeData(useMaterial3: true),  // Enable Material 3
  useGetX: true,  // Enable GetX (if needed)
  home: MyPage(),
)
```

## 📚 Documentation

- [Full Documentation](https://nillnil.github.io/flutter_base/#/en/)
- [GetX Integration Guide](./GETX_INTEGRATION.md)
- [Modernization Guide](./MODERNIZATION_COMPLETE.md)
- [Example Code](./example/)

## 🎯 Version Information

### v3.0.0+1 (Latest)
- ✅ Complete Material 3 (Material You) support
- ✅ Complete Platform Adaptation for all major components
- ✅ GetX state management and routing integration
- ✅ iOS 16+ modern design patterns with native components
- ✅ 400+ SF Symbol to Material Icon mappings for Android/Web fallback
- ✅ Native sheets, toolbars, and navigation bars with cross-platform support
- ✅ Material 3 PopupMenu for Android/Web with full feature parity
- ✅ New button types: FilledButton, FilledButton.tonal
- ✅ Automatic yellow underline fixes
- ✅ 100% backward compatibility

**Platform Adaptation Features:**
- 🍎 iOS: Native components (UISheetPresentationController, UIToolbar, UINavigationBar, UIButton.menu)
- 🤖 Android: Material 3 components with proper theming and elevation
- 🌐 Web: Material 3 responsive design with full feature support
- 📱 Cross-platform: Seamless SF Symbol to Material Icon conversion

### Minimum Requirements
- Flutter 3.10+
- Dart 3.0+
- iOS 12+ / Android API 21+

## 🤝 Contributing

Issues and Pull Requests are welcome!

## 📄 License

This project is licensed under the MIT License.

