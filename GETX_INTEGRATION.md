# GetX Integration with Flutter Base

Flutter Base v3.0.0+1 now supports **GetX** state management and routing through the `useGetX` parameter in `BaseApp`. This integration provides reactive state management while maintaining the library's core strength: adaptive, platform-appropriate UI.

## 🚀 Quick Setup

### 1. Add Dependencies
```yaml
dependencies:
  base:
    git:
      url: git://github.com/pastordee/flutter_base
      ref: v3.0.0+1
  get: ^4.6.6
```

### 2. Enable GetX in BaseApp
```dart
import 'package:base/base.dart';
import 'package:get/get.dart';

BaseApp(
  title: 'My GetX App',
  
  // Enable GetX functionality
  useGetX: true,  // This switches to GetMaterialApp
  
  // GetX routing
  getPages: [
    GetPage(name: '/', page: () => HomePage()),
    GetPage(name: '/settings', page: () => SettingsPage()),
    GetPage(name: '/profile', page: () => ProfilePage()),
  ],
  
  // GetX configuration
  initialRoute: '/',
  defaultTransition: Transition.cupertino,
  initialBinding: AppBindings(),
  
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

### Enhanced State Management with Loading States
```dart
class CounterController extends GetxController {
  var count = 0.obs;
  var isLoading = false.obs;
  
  void increment() => count++;
  void decrement() => count--;
  
  // Async operation with loading state
  Future<void> asyncIncrement() async {
    isLoading(true);
    await Future.delayed(Duration(seconds: 1));
    count++;
    isLoading(false);
  }
  
  // Computed property
  String get countText => count > 10 ? 'High: ${count}' : 'Count: ${count}';
  
  @override
  void onInit() {
    super.onInit();
    
    // GetX Worker - reacts to count changes
    ever(count, (value) {
      if (value > 5) {
        Get.snackbar(
          'Achievement!', 
          'You reached $value clicks!',
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }
}

// In your widget - Advanced reactive UI
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounterController());
    
    return BaseScaffold(
      appBar: BaseAppBar(title: Text('GetX Counter')),
      body: Column(
        children: [
          // Reactive computed property
          Obx(() => Text(
            controller.countText,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: controller.count > 10 ? Colors.red : null,
            ),
          )),
          
          // Material 3 buttons with GetX state
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BaseButton(
                child: Icon(Icons.remove),
                filledTonalButton: true,
                onPressed: controller.decrement,
              ),
              
              // Async button with loading state
              Obx(() => BaseButton(
                child: controller.isLoading.value 
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.add),
                filledButton: true,
                onPressed: controller.isLoading.value 
                  ? null 
                  : controller.asyncIncrement,
              )),
            ],
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

### 3. **Performance**
- GetX's lightweight reactivity
- Flutter Base's efficient platform detection
- Smart memory management

### 4. **Automatic Fixes**
- **Yellow Underline Fix**: v3.0.0+1 automatically prevents yellow underlines that can occur when using GetX on iOS
- **Text Styling**: Proper Material theme styling applied automatically
- **Platform Detection**: Works seamlessly with BaseApp's platform override system

## 🔧 Troubleshooting

### Common Issues & Solutions

1. **GetX not working**: Ensure `useGetX: true` is set in BaseApp
2. **Routes not found**: Check `getPages` configuration matches route names
3. **Controllers not found**: Verify dependency injection in `initialBinding`
4. **Platform styling issues**: GetX respects existing `BaseParam` overrides

### Yellow Underline Fix (Automatic)
Flutter Base v3.0.0+1 automatically fixes yellow underlines that can occur when using GetX:
- **Problem**: When using GetX on iOS, Text widgets without explicit styling could show yellow underlines
- **Solution**: BaseApp now automatically provides proper Material theme styling
- **Result**: All Text widgets work correctly without manual styling

### Performance Tips

1. Use `Get.lazyPut()` for heavy services
2. Implement proper controller disposal with `onClose()`
3. Use `smartManagement` appropriately
4. Keep reactive variables minimal

## 📊 Feature Comparison

| Feature | Standard BaseApp | GetX BaseApp |
|---------|------------------|--------------|
| Adaptive UI | ✅ | ✅ |
| Material 3 Support | ✅ | ✅ |
| Platform Overrides | ✅ | ✅ |
| Traditional Navigation | ✅ | ✅ |
| Reactive State | ❌ | ✅ |
| Type-safe Routing | ❌ | ✅ |
| Dependency Injection | ❌ | ✅ |
| Performance | Good | Excellent |
| Yellow Underline Fix | ✅ | ✅ |

## 🎉 Real-World Example

Check out the complete GetX integration example in the repository:
- **File**: `example/lib/getx_example.dart`
- **Features**: Counter app with reactive state, navigation, services, workers
- **Demonstrates**: All GetX patterns working with adaptive UI

```bash
cd example
flutter run
```

---

**Result**: Flutter Base + GetX = Adaptive UI + Reactive State Management + Modern Routing 🚀
