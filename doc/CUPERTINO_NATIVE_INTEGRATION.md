# Cupertino Native Components Integration

## Overview
This document outlines the enhancements made to `flutter_base` to integrate native iOS components from the `cupertino_native` package, providing a better iOS user experience with SF Symbols, native glass effects, and platform-aware widgets.

## Components Added

### 1. BaseButton Enhancements
**File:** `/lib/src/button/base_button.dart`

**New Properties:**
- `useCNButton` (bool): Enable CNButton from cupertino_native
- `cnButtonStyle` (CNButtonStyle): Button style (plain, gray, filled, tinted, bordered, prominentGlass)
- `shrinkWrap` (bool): Shrink button to fit content

**Usage Example:**
```dart
BaseButton(
  useCNButton: true,
  cnButtonStyle: CNButtonStyle.prominentGlass,
  onPressed: () => print('Tapped'),
  shrinkWrap: true,
  child: const Text('Glass Button'),
)
```

**Supported CNButton Styles:**
- `CNButtonStyle.plain` - Plain button with no background
- `CNButtonStyle.gray` - Gray background button
- `CNButtonStyle.filled` - Filled with primary color
- `CNButtonStyle.tinted` - Tinted background
- `CNButtonStyle.bordered` - Bordered button
- `CNButtonStyle.prominentGlass` - Premium glass effect

### 2. BaseCNIcon
**File:** `/lib/src/components/base_cn_icon.dart`

Native iOS icon component using SF Symbols via CNIcon.

**Properties:**
- `symbol` (String): SF Symbol name (e.g., 'heart.fill', 'star')
- `size` (double): Icon size (default: 24)
- `color` (Color?): Icon color
- `fallbackIcon` (IconData?): Material icon for Android

**Usage Example:**
```dart
BaseCNIcon(
  symbol: 'heart.fill',
  size: 32,
  color: Colors.red,
  fallbackIcon: Icons.favorite,
)
```

**Popular SF Symbols:**
- `heart`, `heart.fill` - Heart icons
- `star`, `star.fill` - Star icons
- `bolt.fill` - Lightning bolt
- `flame.fill` - Flame
- `gearshape` - Settings gear
- `trash` - Delete
- `pencil` - Edit
- `folder`, `folder.fill` - Folder icons
- `doc` - Document
- `paperplane.fill` - Send

### 3. BaseCNSlider
**File:** `/lib/src/components/base_cn_slider.dart`

Native iOS slider component using CNSlider.

**Properties:**
- `value` (double): Current value
- `onChanged` (ValueChanged<double>): Value change callback
- `min` (double): Minimum value (default: 0.0)
- `max` (double): Maximum value (default: 1.0)
- `enabled` (bool): Whether slider is enabled (default: true)
- `activeColor` (Color?): Active track color
- `inactiveColor` (Color?): Inactive track color (Material only)
- `divisions` (int?): Discrete divisions (Material only)
- `label` (String?): Label text (Material only)

**Usage Example:**
```dart
BaseCNSlider(
  value: _sliderValue,
  min: 0,
  max: 100,
  onChanged: (v) => setState(() => _sliderValue = v),
)
```

### 4. BaseCNSwitch
**File:** `/lib/src/components/base_cn_switch.dart`

Native iOS switch component using CNSwitch.

**Properties:**
- `value` (bool): Current value
- `onChanged` (ValueChanged<bool>): Value change callback
- `color` (Color?): Switch color
- `activeColor` (Color?): Active color (Material only)
- `inactiveTrackColor` (Color?): Inactive track color (Material only)
- `thumbColor` (MaterialStateProperty<Color?>?): Thumb color (Material only)

**Usage Example:**
```dart
BaseCNSwitch(
  value: _switchValue,
  color: CupertinoColors.systemPink,
  onChanged: (v) => setState(() => _switchValue = v),
)
```

### 5. BaseCNSegmentedControl
**File:** `/lib/src/components/base_cn_segmented_control.dart`

Native iOS segmented control using CNSegmentedControl.

**Properties:**
- `labels` (List<String>): Segment labels
- `selectedIndex` (int): Currently selected index
- `onValueChanged` (ValueChanged<int>): Selection change callback

**Usage Example:**
```dart
BaseCNSegmentedControl(
  labels: const ['One', 'Two', 'Three'],
  selectedIndex: _selectedIndex,
  onValueChanged: (i) => setState(() => _selectedIndex = i),
)
```

### 6. BasePopupMenuButton
**File:** `/lib/src/components/base_popup_menu_button.dart`

Cross-platform popup menu that uses CNPopupMenuButton on iOS and Material PopupMenuButton on Android.

**Properties:**
- `items` (List<BasePopupMenuItem>): Menu items
- `onSelected` (ValueChanged<int>): Selection callback
- `buttonLabel` (String?): Button label (text style)
- `materialIcon` (IconData?): Material icon (Android)
- `iosIcon` (String?): SF Symbol name (iOS)
- `size` (double): Button size (default: 44.0)
- `useCNPopupMenuButton` (bool): Use native iOS menu (default: true)

**Usage Example:**
```dart
// Icon button
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
    ),
  ],
  onSelected: (index) => print('Selected: $index'),
)

// Label button
BasePopupMenuButton(
  buttonLabel: 'Actions',
  items: [...],
  onSelected: (index) => print('Selected: $index'),
)
```

## Demo Application
**File:** `/example/lib/demos/cupertino_native_demo.dart`

A comprehensive demo showcasing all native components with:
- CNButton with all styles (plain, gray, filled, tinted, bordered, prominentGlass)
- CNButton with icons
- CNIcon with SF Symbols
- CNIcon with colors
- CNSegmentedControl
- CNSlider
- CNSwitch (basic and colored)
- BasePopupMenuButton (icon and label variants)
- BaseCNNavigationBar (navigation bar with large title support)
- BaseCNToolbar (top and bottom toolbars with multiple actions)

### 7. BaseCNNavigationBar
**File:** `/lib/src/components/base_cn_navigation_bar.dart`

Native iOS navigation bar component using CNNavigationBar with leading, title, and trailing actions.

**Properties:**
- `leading` (List<CNNavigationBarAction>?): Leading actions (typically back button)
- `title` (String?): Navigation bar title
- `trailing` (List<CNNavigationBarAction>?): Trailing actions (settings, add, etc.)
- `tint` (Color?): Tint color for icons and text
- `transparent` (bool): Transparent with blur effect (default: false)
- `largeTitle` (bool): iOS 11+ style large title (default: false)
- `height` (double?): Custom navigation bar height

**Usage Example:**
```dart
BaseCNNavigationBar(
  leading: [
    CNNavigationBarAction(
      icon: CNSymbol('chevron.left'),
      onPressed: () => Navigator.pop(context),
    ),
    CNNavigationBarAction(
      label: 'Back',
      onPressed: () => Navigator.pop(context),
    ),
  ],
  title: 'Native Nav Bar',
  trailing: [
    CNNavigationBarAction(
      icon: CNSymbol('gear'),
      onPressed: () => print('Settings'),
    ),
    CNNavigationBarAction(
      icon: CNSymbol('plus'),
      onPressed: () => print('Add'),
    ),
  ],
  tint: CupertinoColors.label,
  transparent: false,
  largeTitle: false,
)
```

**CNNavigationBarAction Properties:**
- `icon` (CNSymbol?): SF Symbol icon
- `label` (String?): Text label
- `onPressed` (VoidCallback): Action callback

**Features:**
- Native iOS navigation bar appearance
- Large title support (iOS 11+ style)
- Transparent mode with blur effects
- SF Symbols with Material fallback
- Flexible leading/trailing actions
- Material AppBar fallback on Android

### 8. BaseCNToolbar
**File:** `/lib/src/components/base_cn_toolbar.dart`

Native iOS toolbar component using CNToolbar with flexible leading, middle, and trailing action groups.

**Properties:**
- `leading` (List<CNToolbarAction>?): Leading actions (typically back, share)
- `middle` (List<CNToolbarAction>?): Middle actions (main actions)
- `trailing` (List<CNToolbarAction>?): Trailing actions (settings, more)
- `title` (String?): Optional title text
- `tint` (Color?): Tint color for icons and text
- `transparent` (bool): Transparent with blur effect (default: false)
- `height` (double?): Custom toolbar height
- `pillHeight` (double?): Custom pill button height (iOS only)
- `middleAlignment` (BaseToolbarAlignment): Middle section alignment (leading, center, trailing)
- `backgroundColor` (Color?): Background color (Material only)

**Usage Example:**
```dart
// Top toolbar
BaseCNToolbar(
  leading: [
    CNToolbarAction(
      icon: CNSymbol('chevron.left'),
      onPressed: () => Navigator.pop(context),
    ),
  ],
  middle: [
    CNToolbarAction(
      icon: CNSymbol('pencil', size: 40),
      onPressed: () => print('Edit'),
    ),
    CNToolbarAction(
      icon: CNSymbol('trash', size: 40),
      onPressed: () => print('Delete'),
    ),
  ],
  trailing: [
    CNToolbarAction(
      icon: CNSymbol('gear'),
      onPressed: () => print('Settings'),
    ),
  ],
  transparent: true,
  tint: CupertinoColors.label,
)

// Bottom toolbar with labels
BaseCNToolbar(
  leading: [
    CNToolbarAction(
      label: 'Download',
      icon: CNSymbol('square.and.arrow.down', size: 40),
      onPressed: () => print('Download'),
    ),
  ],
  transparent: true,
)
```

**CNToolbarAction:**
- `icon` (CNSymbol?): SF Symbol icon
- `label` (String?): Optional label text
- `onPressed` (VoidCallback?): Action callback

**BaseToolbarAlignment:**
- `BaseToolbarAlignment.leading` - Align to left
- `BaseToolbarAlignment.center` - Center alignment (default)
- `BaseToolbarAlignment.trailing` - Align to right

## Material Icon → SF Symbol Mapping

BaseButton and BasePopupMenuButton include automatic icon mapping:

| Material Icon | SF Symbol | Description |
|--------------|-----------|-------------|
| `Icons.favorite` | `heart.fill` | Filled heart |
| `Icons.favorite_border` | `heart` | Outlined heart |
| `Icons.star` | `star.fill` | Filled star |
| `Icons.star_border` | `star` | Outlined star |
| `Icons.add` | `plus` | Plus/Add |
| `Icons.check` | `checkmark` | Checkmark |
| `Icons.close` | `xmark` | Close/X |
| `Icons.more_horiz` | `ellipsis` | More (horizontal) |
| `Icons.more_vert` | `ellipsis` | More (vertical) |
| `Icons.settings` | `gearshape` | Settings |
| `Icons.info` | `info.circle` | Information |
| `Icons.share` | `square.and.arrow.up` | Share |
| `Icons.delete` | `trash` | Delete |
| `Icons.edit` | `pencil` | Edit |

## Benefits

### 1. Native iOS Appearance
- Uses Apple's SF Symbols for consistent iconography
- Native glass effects with CNButton
- iOS-style controls (slider, switch, segmented control)

### 2. Cross-Platform Compatibility
- Automatic platform detection
- Falls back to Material Design on Android
- Single API for both platforms

### 3. Enhanced User Experience
- Liquid glass effects for premium appearance
- Haptic feedback support
- Smooth animations and transitions

### 4. Developer Convenience
- Unified API across platforms
- Automatic icon mapping
- Easy-to-use wrapper components

## Usage in Your App

1. **Import the package:**
```dart
import 'package:base/base_widgets.dart';
import 'package:cupertino_native/cupertino_native.dart';
```

2. **Use native components:**
```dart
// Native button
BaseButton(
  useCNButton: true,
  cnButtonStyle: CNButtonStyle.filled,
  onPressed: () {},
  child: const Text('Tap Me'),
)

// Native icon
BaseCNIcon(
  symbol: 'heart.fill',
  size: 24,
  color: Colors.red,
)

// Native slider
BaseCNSlider(
  value: _value,
  min: 0,
  max: 100,
  onChanged: (v) => setState(() => _value = v),
)
```

3. **Run the demo:**
```bash
cd example
flutter run
```

## Future Enhancements

- Add more SF Symbol mappings
- Support for SF Symbol weights (ultraLight, thin, light, regular, medium, semibold, bold, heavy, black)
- Additional CNButton customization options
- More native iOS components (CNPicker, CNDatePicker, etc.)
- Enhanced glass effects with custom shaders

## Resources

- [SF Symbols Browser](https://developer.apple.com/sf-symbols/)
- [cupertino_native Package](https://github.com/pastordee/cupertino_native)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
