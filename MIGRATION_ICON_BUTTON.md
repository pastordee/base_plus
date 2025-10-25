# Icon Button Migration Guide

## Summary of Changes

The icon button functionality has been consolidated into a single, more powerful component. **BaseIconButton** now includes native SF Symbols support that was previously in `BaseCNIcon`.

### What Changed:

- ✅ **`BaseIconButton`** - Now supports native SF Symbols via `symbol` parameter
- ✅ **Native CNIcon integration** - True native iOS SF Symbols rendering
- ✅ **Automatic fallback** - Smart fallback to Material Icons on Android
- ⚠️ **`BaseCNIcon`** - Deprecated, use `BaseIconButton` instead

## Why This Change?

`BaseCNIcon` provided native SF Symbols but lacked interactivity and modern features. By consolidating into `BaseIconButton`, you get:

- ✅ **Native SF Symbols** - Same native rendering as BaseCNIcon
- ✅ **Interactive buttons** - Full button functionality with onPressed
- ✅ **iOS 26 Liquid Glass effects** - Modern visual design
- ✅ **Haptic feedback** - Enhanced user experience
- ✅ **Material 3 support** - Better Android integration
- ✅ **Better fallback** - Smarter handling of cross-platform icons
- ✅ **Unified API** - One component for all icon button needs

## Migration Examples

### Simple Icon Display

**Old Code (BaseCNIcon):**
```dart
BaseCNIcon(
  symbol: 'heart.fill',
  size: 24,
  color: Colors.red,
)
```

**New Code (BaseIconButton):**
```dart
BaseIconButton(
  symbol: 'heart.fill',
  iconSize: 24,
  color: Colors.red,
  onPressed: null, // Non-interactive icon
)
```

### Interactive Icon Button

**Old Code (combining BaseCNIcon with gesture detector):**
```dart
GestureDetector(
  onTap: () => likePost(),
  child: BaseCNIcon(
    symbol: 'heart.fill',
    size: 24,
    color: Colors.red,
  ),
)
```

**New Code (BaseIconButton):**
```dart
BaseIconButton(
  symbol: 'heart.fill',
  iconSize: 24,
  color: Colors.red,
  onPressed: () => likePost(),
)
```

### Cross-Platform Icons

**Old Code (BaseCNIcon with fallback):**
```dart
BaseCNIcon(
  symbol: 'star.fill',
  size: 24,
  color: Colors.yellow,
  fallbackIcon: Icons.star,
)
```

**New Code (BaseIconButton):**
```dart
BaseIconButton(
  symbol: 'star.fill',
  fallbackIcon: Icons.star,
  iconSize: 24,
  color: Colors.yellow,
  onPressed: null,
)
```

### With iOS 26 Liquid Glass Effects

**New capability not available in BaseCNIcon:**
```dart
BaseIconButton(
  symbol: 'gearshape.fill',
  iconSize: 28,
  color: Colors.blue,
  liquidGlassEffect: true,
  liquidGlassBlurIntensity: 10.0,
  liquidGlassOpacity: 0.9,
  adaptiveHaptics: true,
  onPressed: () => openSettings(),
)
```

## Key API Differences

| Feature | BaseCNIcon (Old) | BaseIconButton (New) |
|---------|------------------|----------------------|
| **Native SF Symbols** | ✅ via CNIcon | ✅ via CNIcon |
| **Parameter** | `symbol` | `symbol` |
| **Size parameter** | `size` | `iconSize` |
| **Interactivity** | ❌ None | ✅ `onPressed` |
| **Haptic Feedback** | ❌ None | ✅ Adaptive |
| **Liquid Glass** | ❌ None | ✅ Optional |
| **Material Icons** | ❌ Limited | ✅ Full support |
| **Fallback** | `fallbackIcon` | `fallbackIcon` or `icon` |
| **Padding** | ❌ None | ✅ Customizable |
| **Button styles** | ❌ None | ✅ Full CupertinoButton |

## Using Native SF Symbols

### SF Symbol Priority

BaseIconButton supports three ways to specify icons:

1. **`symbol`** - Native SF Symbol (iOS only, highest priority)
2. **`icon`** - Standard Material/Cupertino IconData
3. **`fallbackIcon`** - Fallback for Android when using symbol

**iOS behavior:**
- If `symbol` is provided → uses native CNIcon
- If `icon` is provided → uses standard Icon widget
- Priority: `symbol` > `icon`

**Android behavior:**
- If `symbol` is provided → uses `fallbackIcon` or `icon`
- If only `icon` is provided → uses `icon`
- Priority: `icon` > `fallbackIcon` > default

### Example Patterns

**Cross-platform with smart fallback:**
```dart
BaseIconButton(
  symbol: 'heart.fill',      // iOS: native SF Symbol
  fallbackIcon: Icons.favorite, // Android: Material Icon
  color: Colors.red,
  onPressed: () {},
)
```

**iOS native, Android standard:**
```dart
BaseIconButton(
  symbol: 'star.fill',       // iOS: native SF Symbol
  icon: Icons.star,          // Android: Material Icon
  color: Colors.yellow,
  onPressed: () {},
)
```

**Material Icon only (both platforms):**
```dart
BaseIconButton(
  icon: Icons.settings,      // Both: standard Icon
  onPressed: () {},
)
```

## Common SF Symbols

Here are some commonly used SF Symbols:

| Symbol Name | Description | Material Fallback |
|-------------|-------------|-------------------|
| `heart.fill` | Filled heart | `Icons.favorite` |
| `star.fill` | Filled star | `Icons.star` |
| `gearshape.fill` | Filled gear | `Icons.settings` |
| `house.fill` | Filled house | `Icons.home` |
| `person.fill` | Filled person | `Icons.person` |
| `magnifyingglass` | Search | `Icons.search` |
| `plus` | Plus sign | `Icons.add` |
| `minus` | Minus sign | `Icons.remove` |
| `trash.fill` | Filled trash | `Icons.delete` |
| `paperplane.fill` | Send | `Icons.send` |
| `bell.fill` | Bell | `Icons.notifications` |
| `envelope.fill` | Email | `Icons.email` |
| `camera.fill` | Camera | `Icons.camera_alt` |
| `photo.fill` | Photo | `Icons.photo` |
| `location.fill` | Location | `Icons.location_on` |

## Advanced Features

### Liquid Glass Effects

```dart
BaseIconButton(
  symbol: 'heart.fill',
  liquidGlassEffect: true,
  liquidGlassBlurIntensity: 10.0,  // 5.0 - 20.0
  liquidGlassOpacity: 0.9,          // 0.1 - 1.0
  onPressed: () {},
)
```

### Haptic Feedback

```dart
BaseIconButton(
  symbol: 'trash.fill',
  adaptiveHaptics: true,  // Enables smart haptic feedback
  onPressed: () => deleteItem(),
)
```

### Custom Styling

```dart
BaseIconButton(
  symbol: 'gearshape.fill',
  iconSize: 32,
  padding: EdgeInsets.all(16),
  borderRadius: BorderRadius.circular(12),
  color: Colors.blue,
  minSize: 50,
  pressedOpacity: 0.6,
  onPressed: () {},
)
```

## Breaking Changes

### None for most users!

If you were using `BaseIconButton`, it works exactly the same with NEW features added.

### For BaseCNIcon users:

1. Change `BaseCNIcon` → `BaseIconButton`
2. Change `size` → `iconSize`
3. Add `onPressed: null` if you want a non-interactive icon (or provide a callback)
4. Everything else stays the same!

## Timeline

- **Current (3.0.5)**: Both available, `BaseCNIcon` deprecated with warnings
- **Next Minor (3.1.0)**: `BaseCNIcon` still available but strongly deprecated
- **Future Major (4.0.0)**: `BaseCNIcon` will be removed

## Additional Resources

- SF Symbols Browser: https://developer.apple.com/sf-symbols/
- Apple HIG Icons: https://developer.apple.com/design/human-interface-guidelines/sf-symbols
- Material Icons: https://fonts.google.com/icons
