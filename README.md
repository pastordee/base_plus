<p align="center">
  <img src="https://github.com/pastordee/base_plus/blob/main/screenshot/logo.png?raw=true" alt="logo" width="120">
</p>

# base_plus

> One code, two modes - use Cupertino widgets on iOS, Material widgets on Android or Fuchsia. Supports Material 3 and modern iOS design patterns.
>
> **✨ v0.2.0 Features**: Material 3 support, Native iOS components (UISheetPresentationController, UIButton, UISearchBar), GetX integration, responsive design

## ✨ Key Features

- 🎨 **Adaptive Design**: Automatically uses Cupertino on iOS, Material on Android/Fuchsia
- 🚀 **Material 3 Support**: Latest Material You design system with dynamic colors
- 📱 **Native iOS Components**: Direct integration with UIKit (UISheetPresentationController, UIButton, UISearchBar, UIToolbar, UINavigationBar)
- ⚡ **GetX Integration**: Optional reactive state management and routing system
- 🎯 **Modern Design**: iOS 16+ design patterns and Material You aesthetics
- 🔧 **Backward Compatible**: 100% compatible with existing code, progressive upgrade
- 🌐 **Cross-Platform**: Flutter 3.10+, Dart 3.0+, iOS 12+, Android API 21+

## 🚀 Quick Start

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  base_plus: ^0.2.0
  get: ^4.6.6  # Optional: For GetX features
  cupertino_native_extra: ^0.2.0  # Required for native iOS components
  cupertino_interactive_keyboard:
    git:
      url: https://github.com/pastordee/cupertino_interactive_keyboard.git
      ref: pc
```

### Basic Usage

```dart
import 'package:base_plus/base_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      title: 'My App',
      baseTheme: BaseThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
```

## 🎨 Component Library

### Base Widgets

#### BaseButton
Adaptive button that uses Cupertino style on iOS and Material style on Android:

```dart
BaseButton(
  onPressed: () {},
  child: const Text('Click Me'),
)

// Material 3 Filled Button
BaseButton(
  filledButton: true,
  onPressed: () {},
  child: const Text('Filled'),
)

// Material 3 Tonal Button
BaseButton(
  filledTonalButton: true,
  onPressed: () {},
  child: const Text('Tonal'),
)
```

#### BaseScaffold & BaseAppBar
Platform-aware scaffold and app bar:

```dart
BaseScaffold(
  appBar: BaseAppBar(
    title: const Text('Home'),
    leadingActions: [...],
    trailingActions: [...],
  ),
  body: const Center(child: Text('Content')),
)
```

#### BaseSegmentedControl
Native segmented control / segmented button:

```dart
BaseSegmentedControl(
  labels: const ['Tab 1', 'Tab 2', 'Tab 3'],
  selectedIndex: _selectedIndex,
  onValueChanged: (index) {
    setState(() => _selectedIndex = index);
  },
)
```

#### BaseSlider & BaseSwitch
Platform-native slider and toggle controls:

```dart
BaseSlider(
  value: _value,
  min: 0,
  max: 100,
  onChanged: (value) {
    setState(() => _value = value);
  },
)

BaseSwitch(
  value: _isEnabled,
  onChanged: (value) {
    setState(() => _isEnabled = value);
  },
)
```

### Native iOS Components

#### BaseCNButton (Native UIButton)
Native iOS buttons with system styles:

```dart
CNButton(
  style: CNButtonStyle.filled,
  onPressed: () {},
  child: const Text('Filled Button'),
)

// Button with icon
CNButton.icon(
  icon: const CNSymbol('heart.fill', size: 18),
  style: CNButtonStyle.tinted,
  onPressed: () {},
)
```

#### BaseCNIcon (SF Symbols)
Direct access to Apple's SF Symbols:

```dart
const BaseCNIcon(
  symbol: 'heart.fill',
  size: 32,
  color: Colors.red,
)
```

#### BaseCNSearchBar (Native UISearchBar)
Native iOS search bar with scope filtering:

```dart
BaseSearchBar(
  placeholder: 'Search...',
  showsCancelButton: true,
  showsScopeBar: true,
  scopeButtonTitles: const ['All', 'Images', 'Videos'],
  onTextChanged: (text) {},
  onSearchButtonClicked: (text) {},
  height: 56,
)
```

#### BaseNativeSheet (Native UISheetPresentationController)
Native iOS sheet presentation with resizable detents and inline actions:

```dart
// Basic sheet
await BaseNativeSheet.show(
  context: context,
  title: 'Options',
  items: [
    const CNSheetItem(title: 'Option 1', icon: 'star'),
    const CNSheetItem(title: 'Option 2', icon: 'heart'),
  ],
  onItemSelected: (index) {},
)

// Sheet with custom header and inline actions
await BaseNativeSheet.showWithCustomHeader(
  context: context,
  title: 'Format',
  headerTitleAlignment: 'center',
  inlineActions: [
    CNSheetInlineActions(
      actions: [
        CNSheetInlineAction(
          label: 'B',
          icon: 'bold',
          dismissOnTap: false,
        ),
        CNSheetInlineAction(
          label: 'I',
          icon: 'italic',
          dismissOnTap: false,
        ),
      ],
    ),
  ],
  items: [
    const CNSheetItem(title: 'Font Size', icon: 'textformat.size'),
    const CNSheetItem(title: 'Text Color', icon: 'paintpalette'),
  ],
  onInlineActionSelected: (rowIndex, actionIndex) {},
  onItemSelected: (index) {},
)
```

#### BaseToolbar (Native UIToolbar)
Flexible native iOS toolbar with leading, middle, and trailing actions:

```dart
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
  trailing: [
    BaseToolbarAction(
      label: 'Done',
      onPressed: () {},
    ),
  ],
  transparent: true,
)
```

#### BaseNavigationBar (Native UINavigationBar)
Native iOS navigation bar with leading, title, and trailing actions:

```dart
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

#### BaseCNPullDownButton (Native UIButton with Menu)
Native iOS pull-down menu button:

```dart
BaseCNPullDownButton.icon(
  buttonIcon: const CNSymbol('ellipsis.circle'),
  items: const [
    CNPullDownMenuInlineActions(actions: [...]),
    CNPullDownMenuDivider(),
    CNPullDownMenuItem(
      title: 'Copy',
      icon: CNSymbol('doc.on.doc'),
    ),
    CNPullDownMenuItem(
      title: 'Delete',
      icon: CNSymbol('trash'),
      isDestructive: true,
    ),
  ],
  onSelected: (index) {},
)
```

#### BasePopupButton (Native UIButton with Popup Menu)
Native iOS popup menu button for option selection:

```dart
BasePopupButton(
  options: const ['Small', 'Medium', 'Large'],
  selectedIndex: 1,
  onSelected: (index) {},
  buttonStyle: CNButtonStyle.gray,
  prefix: 'Size:',
)
```

### Popup & Menu Widgets

#### BasePopupMenuButton
Cross-platform popup menu button:

```dart
BasePopupMenuButton.icon(
  items: const [
    BasePopupMenuItem(
      label: 'Edit',
      iosIcon: 'pencil',
      iconData: Icons.edit,
    ),
    BasePopupMenuItem.divider(),
    BasePopupMenuItem(
      label: 'Delete',
      iosIcon: 'trash',
      iconData: Icons.delete,
      isDestructive: true,
    ),
  ],
  onSelected: (index) {},
)
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
| **SF Symbols** | ✅ Native Symbols | ✅ Material Icon Fallback (400+) | ✅ Material Icon Fallback (400+) |

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

### From flutter_base to base_plus

Simply update your imports:

```dart
// Old
import 'package:base/base.dart';

// New
import 'package:base_plus/base_plus.dart';
```

All APIs remain the same - it's a drop-in replacement!

### Enabling Native iOS Components

No extra setup needed! Native components automatically available:

```dart
// Uses native iOS components on iOS, Material fallback on Android
BaseNativeSheet.show(...)
BaseNativeSheet.showWithCustomHeader(...)
BaseToolbar(...)
BaseNavigationBar(...)
BaseCNButton(...)
BaseSearchBar(...)
```

## 🎯 Version Information

### v3.0.8+2 (Current)
- ✅ Complete Material 3 support
- ✅ Native iOS UISheetPresentationController with inline actions and item rows
- ✅ Native iOS UIButton with all system styles
- ✅ Native iOS UISearchBar with scope filtering
- ✅ Native iOS UIToolbar with flexible action positioning
- ✅ Native iOS UINavigationBar with leading/trailing actions
- ✅ Native iOS pull-down and popup menus
- ✅ SF Symbols direct support
- ✅ Flutter 3.10+ and Dart 3.0+ support
- ✅ 100% backward compatibility with flutter_base
- ✅ GetX integration support

### Minimum Requirements
- Flutter 3.10.0+
- Dart 3.0.0+
- iOS 12+ / Android API 21+

## 📚 Documentation

- [Full Documentation](https://github.com/pastordee/base_plus/wiki)
- [Example App](./flutter_base_ex/)
- [Native iOS Components Guide](./lib/src/native_sheet/)
- [Material 3 Integration](./MODERNIZATION_COMPLETE.md)
- [GetX Integration Guide](./GETX_INTEGRATION.md)

## 🎨 Example Application

Run the example app to see all components in action:

```bash
cd flutter_base_ex
flutter run
```

The example includes:
- All BaseButton styles and variations
- Native iOS components demo
- Material 3 theme showcase
- GetX state management examples
- Cross-platform navigation patterns
- Native sheet presentations
- Toolbar and navigation bar examples

## 🤝 Contributing

We welcome issues, bug reports, and pull requests! Please see our contribution guidelines on GitHub.

## 📄 License

MIT License - see LICENSE file for details

## 🙏 Acknowledgments

Built on Flutter's excellent framework and Apple's Human Interface Guidelines. Integrates with:
- [GetX](https://github.com/jonataslaw/getx) - State management
- [cupertino_native](https://github.com/pastordee/cupertino_native) - Native iOS components
- [cupertino_interactive_keyboard](https://github.com/pastordee/cupertino_interactive_keyboard) - iOS keyboard support

---

**Made with ❤️ for Flutter developers who want native iOS design patterns**
