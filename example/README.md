# base_plus Example Application

A comprehensive example application demonstrating all features and capabilities of the base_plus library.

## Overview

The example showcases:
- **Platform-Adaptive Design**: Cupertino on iOS, Material on Android/Fuchsia
- **Material 3 Support**: Modern Material You design with dynamic colors
- **Native iOS Components**: UIKit integration for iOS-specific features
- **GetX Integration**: Reactive state management and routing
- **Theme Management**: Light/dark theme switching with Provider
- **Component Library**: Comprehensive demonstrations of all base_plus widgets

## Project Structure

```
example/lib/
├── main.dart                      # Application entry point
├── app.dart                       # Root app widget with theme configuration
├── home.dart                      # Main demo screen with component navigation
├── settings.dart                  # Settings screen example
├── theme_example.dart             # Theme configuration patterns
├── modern_examples.dart           # Modern Material 3 design patterns
├── getx_example.dart              # GetX state management integration
├── bottom_nav_test.dart           # Bottom navigation test app
├── standalone_bottom_nav_test.dart # Material-specific navigation test
├── provider/                      # Provider-based state management
│   └── app_provider.dart          # Theme and app state provider
├── demos/                         # Feature demonstrations
│   ├── demos.dart                 # Demo navigation
│   ├── appbar/                    # App bar variations
│   ├── action_sheet/              # Action sheet patterns
│   ├── dialog/                    # Dialog implementations
│   ├── button/                    # Button variants
│   ├── section/                   # List and section widgets
│   ├── refresh/                   # Pull-to-refresh patterns
│   ├── scaffold/                  # Scaffold layouts
│   └── ... (other component demos)
├── iconfont/                      # Custom icon font definitions
└── provider/                      # State management utilities
```

## Running the App

### Default Entry Point
```bash
flutter run
```

This runs the main app with all demos and features accessible from the home screen.

### Alternative Entry Points

For focused testing, you can modify `lib/main.dart` to use these alternative entry points:

#### Bottom Navigation Test
```dart
import 'bottom_nav_test.dart';

void main() {
  runApp(const BottomNavTestApp());
}
```

#### Material-Specific Navigation Test
```dart
import 'standalone_bottom_nav_test.dart';

void main() {
  runApp(const StandaloneBottomNavTest());
}
```

#### GetX Integration
```dart
import 'getx_example.dart';

void main() {
  runApp(const GetXApp());
}
```

#### Theme Configuration Example
```dart
import 'theme_example.dart';

void main() {
  runApp(const ThemeExampleApp());
}
```

## Key Features Demonstrated

### 1. Adaptive UI Components
- **BaseButton**: Material 3 buttons with automatic platform adaptation
- **BaseNavigationBar**: Platform-aware navigation with bottom tabs
- **BaseAppBar**: Adaptive app bar for iOS and Android
- **BaseScaffold**: Platform-specific scaffold implementations
- **BaseIcon**: Cross-platform icon rendering

### 2. Native iOS Components
- **BaseNativeSheet**: UISheetPresentationController integration
- **BaseCNToolbar**: Native UIToolbar for iOS
- **BaseCNSearchBar**: Native UISearchBar implementation
- **BaseCNPullDownButton**: Native UIButton with pull-down menus

### 3. Material 3 Components
- **BasePopupMenuButton**: Material 3 popup menus
- **BaseSegmentedControl**: Segmented control widgets
- **BaseSlider**: Modern slider implementations
- **BaseSwitch**: Platform-aware toggle switches
- **BaseTabBar**: Adaptive tab bar

### 4. State Management
The example demonstrates:
- **Provider**: Theme and app state management (default)
- **GetX**: Reactive state with GetX controllers and routing
- **Integration**: How to combine base_plus with state management solutions

### 5. Theme Configuration
- Material 3 with semantic colors
- Light and dark theme variants
- Dynamic color schemes with seed colors
- Cross-platform theme consistency

## Demo Features

### Home Screen
- Comprehensive component showcase
- Navigation to all feature demonstrations
- Real-time theme switching
- Platform mode toggling

### Component Demos
Each demo directory contains examples of specific widgets:
- **appbar**: Various app bar configurations
- **action_sheet**: iOS-style action sheets
- **button**: Button variants (filled, tonal, outlined, text)
- **dialog**: Alert dialogs and custom dialogs
- **section**: List items and section layouts
- **refresh**: Pull-to-refresh implementations
- **bottom_navigation**: Navigation patterns
- **scaffold**: Layout structures
- **toolbar**: iOS toolbar implementations
- **navigation_bar**: Bottom navigation examples

## Building for Production

```bash
# iOS
flutter build ios

# Android
flutter build apk
flutter build appbundle

# Web
flutter build web
```

## Dependencies

See `pubspec.yaml` for a complete list. Key dependencies:
- **base_plus**: The main package being demonstrated
- **provider**: State management
- **get**: Alternative state management (optional)
- **flutter_localizations**: Localization support
- **webview_flutter**: WebView widget
- **url_launcher**: URL handling
- **cached_network_image**: Image caching

## Troubleshooting

### Build Issues
If you encounter build issues:
1. Clean the project: `flutter clean`
2. Get dependencies: `flutter pub get`
3. Rebuild: `flutter pub get && flutter run`

### Platform-Specific Issues

#### iOS
- Ensure iOS deployment target is 12.0 or higher
- Update pods: `cd ios && pod update`

#### Android
- Minimum API level: 21
- Update gradle: `./gradlew wrapper --gradle-version=7.x.x`

## Development Tips

### Adding New Demos
1. Create a new file in `example/lib/demos/feature_name/`
2. Add a demo widget that demonstrates the feature
3. Update `demos/demos.dart` to include the new demo
4. Add a navigation item in `home.dart`

### Testing Themes
1. Use device settings to toggle light/dark mode
2. Use the settings screen in the app to switch themes
3. Test on both iOS and Android simulators/devices

### Debugging
- Use `flutter run -v` for verbose output
- Check IDE console for detailed error messages
- Use Flutter DevTools: `flutter pub global run devtools`

## Additional Resources

- [base_plus Documentation](../README.md)
- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [Cupertino Design](https://developer.apple.com/design/human-interface-guidelines/)

## Support

For issues or questions about the example:
1. Check the [base_plus repository](https://github.com/pastordee/base_plus)
2. Review existing issues and discussions
3. File a new issue with detailed information