## [0.2.2+1] - 2025-12-17

### Added
- Added `labelSize` parameter to `BaseSegmentedControl` for controlling segment text size
- Added `segmentedControlLabelSize` parameter to `BaseAppBar` for native iOS segmented control
- Added `segmentedControlLabelSize` parameter to `BaseNavigationBar` for native iOS segmented control

### Changed
- Updated `cupertino_native_extra` dependency to ^0.2.0+3 for segmented control label size support

### Fixed
- Fixed iOS code signing configuration for simulator debug builds in example app

## [0.2.2] - 2025-12-12

### Fixed
- Improved code formatting and FAB detection in BaseScaffold
- Enhanced automatic Material mode switching for FloatingActionButton

## [0.2.1] - Previous Release

# v3.0.0+2 - 2025.01.21 🍎 Native iOS Integration Release

## 🎯 **New Features**

### Native iOS Tab Bar with SF Symbols
- ✅ **CNTabBar Integration**: Automatic native iOS tab bar using cupertino_native package
- ✅ **SF Symbols Support**: Full SF Symbols icon system integration for authentic iOS icons
- ✅ **Automatic Platform Detection**: BaseTabBar switches between Material and native iOS automatically
- ✅ **Multiple API Approaches**: Three ways to specify SF Symbols (convenience factory, metadata, automatic)
- ✅ **SFSymbols Helper Class**: 30+ pre-defined SF Symbol constants for common icons
- ✅ **Haptic Feedback**: Native iOS haptic feedback on tab selection
- ✅ **Icon Mapping**: Automatic conversion of common Material icons to SF Symbols

### New Components
- ✅ **BaseNativeTabBarItemKey**: Metadata key for SF Symbol specification
- ✅ **BottomNavigationBarItemNativeExtension**: Convenience methods for creating items with SF Symbols
- ✅ **SFSymbols**: Constants class with 30+ common SF Symbol names

### Enhanced BaseTabBar
- ✅ **useNativeCupertinoTabBar**: Enable/disable native iOS tab bar (default: true)
- ✅ **SF Symbol Metadata**: Extract SF Symbol names from KeyedSubtree metadata
- ✅ **Fallback Icon Mapping**: Automatic Material icon to SF Symbol conversion
- ✅ **iOS 26 Liquid Glass**: Enhanced visual effects for tab navigation

## 📚 **Documentation**

### New Guides
- ✅ **Native iOS Integration Guide**: Complete documentation with examples
- ✅ **Quick Reference**: Fast lookup for common patterns and SF Symbol names
- ✅ **API Reference**: Detailed documentation of all new classes and methods

### Enhanced Examples
- ✅ **BottomNavigationExample**: Three-way demo (Material, Native iOS, Auto)
- ✅ **Code Comments**: Comprehensive inline documentation
- ✅ **Usage Patterns**: Multiple approaches demonstrated

## 🔧 **Technical Improvements**

### Architecture
- ✅ **Modular Design**: Clean separation of native iOS helpers
- ✅ **Type Safety**: ValueKey-based metadata system
- ✅ **Performance**: Efficient icon mapping with code point lookup

### Code Quality
- ✅ **No Compilation Errors**: All files pass static analysis
- ✅ **Clean Exports**: Proper module exposure via base_widgets.dart
- ✅ **Consistent Naming**: Following Flutter/iOS naming conventions

## 📦 **Dependencies**
- `cupertino_native: ^0.1.1` - Native iOS components and SF Symbols support

## 🎨 **SF Symbols Coverage**

### Navigation (5)
- home, search, profile, settings, favorites

### Communication (3)
- messages, phone, notifications

### Media (4)
- camera, photos, videos, music

### Organization (5)
- calendar, clock, location, folder, bookmark

### Actions (8)
- add, remove, edit, share, download, upload, check, close

### System (5+)
- info, help, menu, more, trash, tag, document, cloud

**Total**: 30+ common SF Symbols with room for expansion

## 💡 **Usage Examples**

### Convenience Factory (Recommended)
```dart
BaseTabBar(
  useNativeCupertinoTabBar: true,
  items: [
    BottomNavigationBarItemNativeExtension.withSFSymbol(
      sfSymbolName: SFSymbols.home,
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
  ],
)
```

### KeyedSubtree Metadata
```dart
BottomNavigationBarItem(
  icon: KeyedSubtree(
    key: BaseNativeTabBarItemKey(SFSymbols.search),
    child: Icon(Icons.search_outlined),
  ),
  label: 'Search',
)
```

### Automatic Mapping
```dart
BottomNavigationBarItem(
  icon: Icon(Icons.person_outline),
  label: 'Profile',
)
// Automatically maps to 'person.crop.circle'
```

## 🚀 **Platform Behavior**

| Platform | useNativeCupertinoTabBar | Result |
|----------|-------------------------|--------|
| iOS | true | CNTabBar with SF Symbols |
| iOS | false | Material Design |
| Android | any | Material Design |

## ⚠️ **Breaking Changes**
- None - 100% backward compatible
- New features are opt-in via `useNativeCupertinoTabBar` parameter

## 🔮 **Future Enhancements**
- Additional cupertino_native components (CNButton, CNSwitch, CNSlider, etc.)
- More SF Symbol mappings
- Enhanced liquid glass effects
- Custom SF Symbol rendering

---

# v3.0.0+1 - 2025.08.10 🚀 Major Modernization Release

## 🎯 **New Features**

### Material 3 (Material You) Support
- ✅ **New Button Types**: Added `FilledButton` and `FilledButton.tonal` support to BaseButton
- ✅ **Dynamic Theming**: Integrated `ColorScheme.fromSeed` for automatic theme generation  
- ✅ **useMaterial3 Parameter**: Added to BaseThemeData for easy Material 3 enablement
- ✅ **Default Themes**: Automatic Material 3 theme creation when enabled

### GetX State Management Integration
- ✅ **GetMaterialApp Support**: Added `useGetX` parameter to BaseApp
- ✅ **Reactive State Management**: Full GetX controller and observable support
- ✅ **GetX Navigation**: Complete routing system with named routes and transitions
- ✅ **Dependency Injection**: Bindings and service management
- ✅ **GetX Workers**: Support for ever, debounce, and other reactive patterns
- ✅ **Platform Compatibility**: GetX works seamlessly with adaptive design

### Modern iOS Design
- ✅ **iOS 16+ Patterns**: Updated CupertinoButton styling to match modern iOS
- ✅ **Preserved Interactions**: Maintained native iOS feel and animations
- ✅ **Adaptive Behavior**: Automatic platform detection unchanged

## 🔧 **Technical Improvements**

### SDK Modernization
- ✅ **Flutter 3.10+**: Updated minimum Flutter version
- ✅ **Dart 3.0+**: Updated minimum Dart SDK version
- ✅ **Dependencies**: Updated all package dependencies to latest versions

### Bug Fixes
- ✅ **Yellow Underline Fix**: Automatic text styling to prevent debug styling issues with GetX
- ✅ **Platform Routing**: GetX navigation works correctly on both iOS and Android
- ✅ **Theme Context**: Proper Material theme context for GetX apps

## ⚠️ **Breaking Changes**
- **Flutter 3.10+**: Projects must update to Flutter 3.10 or higher
- **Dart 3.0+**: Projects must update to Dart 3.0 or higher
- **API Changes**: None - 100% backward compatible for existing APIs

## 📦 **New Dependencies**
- `get: ^4.6.6` - GetX state management (optional, only if useGetX is enabled)

---

# 2.2.2+3 - 2021.07.25

- add: 添加BaseParam类，用于在模式与平台中个性化参数
- add: Base组件添加baseParam参数
- remove: 移除Base组件中的material, cupertino参数，转移到baseParam参数中
- doc 重命名为 docs，为了使用github pages
- 不兼容旧版，要从旧版升级请看BaseParam类的介绍及使用

## 2.2.2+1 - 2021.07.18

- Refactor some widgets
- Not compatible with the old version
- Re edit document

## 2.2.2 - 2021.06.24

- change flutter version to 2.2.2

## 2.0.3 - 2021.03.22

- change flutter version to 2.0.3

- delete all baseKey

- incompatible with older versions

## 0.6.0 - 2020.08.20

- change flutter version to 1.22.5

## 0.5.0 - 2020.08.20

- change flutter version to 1.20.2

## 0.4.0 - 2020.06.04

- change flutter version to 1.17.2
- incompatible with older versions

## 0.3.3 - 2020.01.09

- BaseTile add child property

## 0.3.2 - 2019.12.30

- format files

## 0.3.1 - 2019.12.30

- fix example's bugs

## 0.3.0 - 2019.12.29

- Release v0.3.0
- incompatible with older versions
- rename package utils to tools
- remove base_theme's tileBackgroundColor
- update flutter version to 1.13.5
- fix bugs
- the example instead provider to flutter_redux
- the example support iOS13 dart mode

## 0.2.1 - 2019.11.14

- Release v0.2.1
- update flutter version to 1.11.0

## 0.2.0 - 2019.07.16

- Release v0.2.0
- add BaseTheme
- add general components, like custom drawer
- modify the CupertinoPageRoute, let BaseRoute's CupertinoPageRoute can custom the backGestureWidth
- fix code format
- update document
- update flutter version to 1.8.1

## 0.1.9 - 2019.05.02

- Release v0.1.9
- modify CupertinoTabBar, CupertinoTabScaffold, BottomNavigationBar, BottomNavigationBarItem
- BottomNavigationBarItem's icon can be null.

## 0.1.8 - 2019.04.28

- Release v0.1.8
- add BaseTextField
- add example's screenshot

## 0.1.7 - 2019.04.26

- Release v0.1.7
- add BaseActionSheet
- fix BaseTabScaffold

## 0.1.6 - 2019.04.25

- Release v0.1.6
- change cupertino,material to Map<String, dynamic>

## 0.1.5 - 2019.04.24

- Release v0.1.5

## 0.1.4 - 2019.04.24

- Release v0.1.4

## 0.1.3 - 2019.04.23

- Release v0.1.3
- add routes demo
- add refresh demo
- improve the document
- change the default README.md to Chinese

## 0.1.2 - 2019.04.23

- Release v0.1.2
- fix BaseAppBar's bug
- add alert dialog demo
- add button demo

## 0.1.1 - 2019.04.21

- Release v0.1.1
- add analysis_options.yaml

## 0.1.0 - 2019.04.20

- Release v0.1.0

## 0.0.3 - 2019.04.19

- Release v0.0.3

## 0.0.2 - 2019.04.19

- Release v0.0.2

## 0.0.1 - 2019.04.16

- Release v0.0.1
