# GetX Integration with Flutter Base

Flutter Base now supports **GetX** state management and routing through the `useGetX` parameter in `BaseApp`.

## 🚀 Quick Setup

### 1. Add GetX Dependency
```yaml
dependencies:
  get: ^4.6.6
  base: ^3.0.0
```

### 2. Enable GetX in BaseApp
```dart
BaseApp(
  title: 'My GetX App',
  useGetX: true,  // Enable GetMaterialApp instead of MaterialApp
  
  // GetX routing
  getPages: [
    GetPage(name: '/', page: () => HomePage()),
    GetPage(name: '/settings', page: () => SettingsPage()),
  ],
  
  // GetX configuration
  initialRoute: '/',
  defaultTransition: Transition.cupertino,
  
  // Standard BaseApp features still work
  baseTheme: BaseThemeData(
    useMaterial3: true,
    materialTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
  ),
)
```

## 🎯 Features Available

### GetX State Management
```dart
class CounterController extends GetxController {
  var count = 0.obs;
  void increment() => count++;
}

// In your widget
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounterController());
    
    return BaseScaffold(
      body: Column(
        children: [
          // Reactive UI
          Obx(() => Text('Count: ${controller.count}')),
          
          // Material 3 button with GetX
          BaseButton(
            child: Text('Increment'),
            filledButton: true,
            onPressed: controller.increment,
          ),
        ],
      ),
    );
  }
}
```

### GetX Navigation
```dart
// Navigate with GetX
BaseButton(
  child: Text('Go to Settings'),
  outlinedButton: true,
  onPressed: () => Get.toNamed('/settings'),
)

// Back navigation
BaseIconButton(
  icon: Icons.arrow_back,
  onPressed: () => Get.back(),
)
```

### GetX Dependency Injection
```dart
// Initialize in BaseApp
BaseApp(
  useGetX: true,
  initialBinding: AppBinding(), // Your initial bindings
)

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.put<UserController>(UserController());
  }
}
```

## 🎨 Design System Integration

GetX works seamlessly with Flutter Base's adaptive design:

```dart
// This button adapts to platform AND works with GetX
BaseButton(
  child: Text('Save'),
  filledButton: true,  // Material 3 style
  onPressed: () {
    // GetX state management
    controller.saveData();
    
    // GetX navigation
    Get.back();
    
    // GetX snackbar
    Get.snackbar('Success', 'Data saved!');
  },
)
```

**Platform Behavior:**
- **iOS**: CupertinoButton with iOS styling + GetX functionality
- **Android**: Material 3 FilledButton + GetX functionality
- **Both**: Same GetX state management and routing

## 🔄 Migration from Standard BaseApp

Existing code works unchanged. To add GetX:

### Before (Standard)
```dart
BaseApp(
  home: HomePage(),
  routes: {
    '/settings': (context) => SettingsPage(),
  },
)
```

### After (GetX Enabled)
```dart
BaseApp(
  useGetX: true,  // Add this line
  getPages: [     // Replace routes with getPages
    GetPage(name: '/', page: () => HomePage()),
    GetPage(name: '/settings', page: () => SettingsPage()),
  ],
)
```

## 📋 Available GetX Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `useGetX` | `bool` | Enable GetMaterialApp (default: false) |
| `getPages` | `List<GetPage>?` | GetX route definitions |
| `unknownRoute` | `GetPage?` | Fallback route for unknown routes |
| `initialBinding` | `Bindings?` | Initial dependency bindings |
| `defaultTransition` | `Transition?` | Default page transition |
| `translations` | `Translations?` | Internationalization |
| `getxLocale` | `Locale?` | GetX-specific locale |
| `fallbackLocale` | `Locale?` | Fallback locale |
| `smartManagement` | `SmartManagement` | Memory management strategy |
| `enableLog` | `bool` | Enable GetX logging |

## 🏗️ Architecture Benefits

### 1. **Adaptive UI + Reactive State**
- Platform-appropriate widgets (iOS/Android)
- Reactive state management with GetX
- Material 3 design system

### 2. **Unified Routing**
- GetX navigation across platforms
- Maintains platform-specific animations
- Type-safe route definitions

### 3. **Performance**
- GetX's lightweight reactivity
- Flutter Base's efficient platform detection
- Smart memory management

## 🎯 Best Practices

### 1. **Controller Organization**
```dart
// Feature-based controllers
class HomeController extends GetxController { }
class SettingsController extends GetxController { }
class UserController extends GetxController { }
```

### 2. **Route Structure**
```dart
// Organized route definitions
class AppPages {
  static const HOME = '/';
  static const SETTINGS = '/settings';
  static const PROFILE = '/profile';
  
  static final pages = [
    GetPage(name: HOME, page: () => HomePage()),
    GetPage(name: SETTINGS, page: () => SettingsPage()),
    GetPage(name: PROFILE, page: () => ProfilePage()),
  ];
}
```

### 3. **Platform-Aware GetX Usage**
```dart
// Use BaseParam for platform-specific GetX behavior
BaseButton(
  child: Text('Action'),
  filledButton: true,
  onPressed: () {
    controller.performAction();
    
    // Platform-aware feedback
    if (Platform.isIOS) {
      // iOS-style feedback
    } else {
      Get.snackbar('Done', 'Action completed');
    }
  },
  baseParam: BaseParam(
    // GetX respects platform overrides
    cupertino: {'forceUseMaterial': false},
  ),
)
```

## 🔧 Troubleshooting

### Common Issues

1. **GetX not working**: Ensure `useGetX: true` is set
2. **Routes not found**: Check `getPages` configuration
3. **Controllers not found**: Verify dependency injection setup
4. **Platform styling issues**: GetX works with existing BaseParam overrides

### Performance Tips

1. Use `Get.lazyPut()` for heavy services
2. Implement proper controller disposal
3. Use `smartManagement` appropriately
4. Keep reactive variables minimal

---

**Result**: Flutter Base + GetX = Adaptive UI + Reactive State Management + Modern Routing 🚀
