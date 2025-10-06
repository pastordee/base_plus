# Native iOS Tab Bar - Quick Reference

## 🚀 Quick Setup

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
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
)
```

## 📋 Three Ways to Specify SF Symbols

### 1. Convenience Factory (Easiest) ⭐

```dart
BottomNavigationBarItemNativeExtension.withSFSymbol(
  sfSymbolName: SFSymbols.search,
  icon: Icon(Icons.search_outlined),
  label: 'Search',
)
```

### 2. KeyedSubtree (More Control)

```dart
BottomNavigationBarItem(
  icon: KeyedSubtree(
    key: BaseNativeTabBarItemKey(SFSymbols.profile),
    child: Icon(Icons.person_outline),
  ),
  label: 'Profile',
)
```

### 3. Automatic (No Configuration)

```dart
BottomNavigationBarItem(
  icon: Icon(Icons.settings_outlined),
  label: 'Settings',
)
// Automatically maps to 'gearshape.fill'
```

## 🎨 Common SF Symbols

```dart
// Navigation
SFSymbols.home            // house.fill
SFSymbols.search          // magnifyingglass
SFSymbols.profile         // person.crop.circle
SFSymbols.settings        // gearshape.fill
SFSymbols.favorites       // heart.fill

// Communication
SFSymbols.messages        // envelope.fill
SFSymbols.phone           // phone.fill
SFSymbols.notifications   // bell.fill

// Media
SFSymbols.camera          // camera.fill
SFSymbols.photos          // photo.fill
SFSymbols.music           // music.note

// Actions
SFSymbols.add             // plus.circle.fill
SFSymbols.edit            // pencil
SFSymbols.share           // square.and.arrow.up
```

## ⚙️ Configuration Options

```dart
BaseTabBar(
  useNativeCupertinoTabBar: true,  // Enable native iOS (default: true)
  enableLiquidGlass: true,         // iOS 26 effects (default: true)
  hapticFeedback: true,            // Haptic on tap (default: true)
  // ... items
)
```

## 🎯 Platform Behavior

| Platform | useNativeCupertinoTabBar | Result |
|----------|-------------------------|--------|
| iOS | `true` | CNTabBar with SF Symbols |
| iOS | `false` | Material Design |
| Android | any | Material Design |

## 📱 Complete Example

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: _pages[_index],
      bottomNavigationBar: BaseTabBar(
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
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
```

## 🔧 Troubleshooting

**Icons not showing?**
- Check SF Symbol name spelling
- Ensure `cupertino_native` is installed
- Verify `useNativeCupertinoTabBar: true`

**CNTabBar not appearing?**
- Must run on iOS device/simulator
- Check for `forceUseMaterial: true` conflict

**Need custom symbol?**
- Use SF Symbols app (macOS)
- Visit https://sfsymbols.com/
- Use Method 1 or 2 to specify name

## 📚 More Info

See [native-ios-integration.md](./native-ios-integration.md) for complete documentation.
