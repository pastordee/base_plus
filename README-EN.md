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

## 📱 Platform Adaptation

| Platform | Design System | Button Style | Navigation |
|----------|---------------|--------------|------------|
| iOS | Cupertino | CupertinoButton (iOS 16+ style) | Native iOS navigation |
| Android | Material 3 | FilledButton (Material You) | Material navigation |
| Web | Material 3 | Responsive design | Modern web experience |

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
- ✅ GetX state management and routing integration
- ✅ iOS 16+ modern design patterns
- ✅ Flutter 3.10+ and Dart 3.0+ support
- ✅ New button types: FilledButton, FilledButton.tonal
- ✅ Automatic yellow underline fixes
- ✅ 100% backward compatibility

### Minimum Requirements
- Flutter 3.10+
- Dart 3.0+
- iOS 12+ / Android API 21+

## 🤝 Contributing

Issues and Pull Requests are welcome!

## 📄 License

This project is licensed under the MIT License.

