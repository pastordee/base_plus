// GetX Integration Example with Flutter Base
// This demonstrates how to use BaseApp with GetX state management

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:base/base.dart';

// Sample Controller with more GetX patterns
class CounterController extends GetxController {
  var count = 0.obs;
  var isLoading = false.obs;
  
  void increment() => count++;
  void decrement() => count--;
  
  // Async operation example
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
    print('CounterController initialized');
    
    // GetX Worker example - reacts to count changes
    ever(count, (value) {
      if (value != null && value as int > 5) {
        Get.snackbar(
          'Achievement!', 
          'You reached $value clicks!',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );
      }
    });
    
    // Debounce example - only triggers after 1 second of no changes
    debounce(count, (value) {
      print('Count stabilized at: $value');
    }, time: Duration(seconds: 1));
  }
  
  @override
  void onClose() {
    print('CounterController disposed');
    super.onClose();
  }
}

// User Service example for dependency injection
class UserService extends GetxService {
  var username = 'Guest'.obs;
  
  void login(String name) {
    username.value = name;
    Get.snackbar('Welcome', 'Hello $name!');
  }
  
  void logout() {
    username.value = 'Guest';
    Get.snackbar('Goodbye', 'See you later!');
  }
}

// Bindings for dependency injection
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounterController>(() => CounterController());
    Get.put<UserService>(UserService(), permanent: true);
  }
}

// Sample GetX Page
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final CounterController controller = Get.put(CounterController());
    final UserService userService = Get.find<UserService>();
    
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Obx(() => Text('Hello, ${userService.username}')),
        actions: [
          BaseIconButton(
            icon: Icons.info,
            onPressed: () => Get.to(() => InfoPage()),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GetX Reactive Counter',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),
            
            // Reactive UI with Obx - shows computed property
            Obx(() => Text(
              controller.countText,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: controller.count > 10 ? Colors.red : null,
              ) ?? TextStyle(fontSize: 24),
            )),
            
            SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Material 3 Buttons that work with GetX
                BaseButton(
                  child: Icon(Icons.remove),
                  filledTonalButton: true,
                  onPressed: controller.decrement,
                ),
                
                // Async operation with loading state
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
            
            SizedBox(height: 20),
            
            // Standard increment button
            BaseButton(
              child: Text('Quick Add'),
              elevatedButton: true,
              onPressed: controller.increment,
            ),
            
            SizedBox(height: 40),
            
            // User login example
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BaseButton(
                  child: Text('Login as John'),
                  textButton: true,
                  onPressed: () => userService.login('John'),
                ),
                BaseButton(
                  child: Text('Logout'),
                  textButton: true,
                  onPressed: userService.logout,
                ),
              ],
            ),
            
            SizedBox(height: 40),
            
            // Navigation with GetX
            BaseButton(
              child: Text('Go to Settings'),
              outlinedButton: true,
              onPressed: () => Get.toNamed('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text('Info'),
        leading: BaseIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GetX Features Enabled:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Text('✅ Reactive State Management'),
            Text('✅ Route Management'),
            Text('✅ Dependency Injection'),
            Text('✅ Internationalization'),
            Text('✅ Material 3 Design'),
            Text('✅ Adaptive iOS/Android UI'),
            SizedBox(height: 20),
            
            // Demonstrate reactive Workers
            Text(
              'GetX Advanced Features:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text('• Workers (ever, once, debounce, interval)'),
            Text('• Computed properties'),
            Text('• Async state management'),
            Text('• Dialog and Snackbar integration'),
            Text('• Platform-aware adaptive UI'),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.find<CounterController>();
    final UserService userService = Get.find<UserService>();
    
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current User:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Obx(() => Text(
              userService.username.value,
              style: Theme.of(context).textTheme.headlineMedium,
            )),
            
            SizedBox(height: 20),
            
            Text(
              'Counter Value (shared state):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Obx(() => Text(
              controller.countText,
              style: Theme.of(context).textTheme.headlineMedium,
            )),
            
            SizedBox(height: 30),
            
            // Reset counter with confirmation
            BaseButton(
              child: Text('Reset Counter'),
              filledTonalButton: true,
              onPressed: () {
                Get.defaultDialog(
                  title: 'Reset Counter',
                  middleText: 'Are you sure you want to reset the counter?',
                  textConfirm: 'Reset',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    controller.count.value = 0;
                    Get.back();
                    Get.snackbar(
                      'Reset',
                      'Counter has been reset!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                );
              },
            ),
            
            SizedBox(height: 20),
            
            // Platform-specific demonstration
            Text(
              'Platform-Adaptive Buttons:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            
            // Force Material button on iOS
            BaseButton(
              child: Text('Force Material Style'),
              filledButton: true,
              onPressed: () => Get.snackbar('Material', 'This uses Material design'),
              baseParam: BaseParam(
                cupertino: {'forceUseMaterial': true},
              ),
            ),
            
            SizedBox(height: 10),
            
            // Native platform button
            BaseButton(
              child: Text('Native Platform Style'),
              elevatedButton: true,
              onPressed: () => Get.snackbar('Native', 'This uses platform-native design'),
            ),
          ],
        ),
      ),
    );
  }
}

// Main App with GetX
class GetXApp extends StatelessWidget {
  const GetXApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      title: 'GetX + Flutter Base Example',
      
      // Enable GetX functionality
      useGetX: true,
      
      // GetX-specific configuration
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/settings', page: () => SettingsPage()),
        GetPage(name: '/info', page: () => InfoPage()),
      ],
      
      // Dependency injection
      initialBinding: AppBindings(),
      
      // Optional: Custom GetX configuration
      defaultTransition: Transition.cupertino,
      enableLog: true,
      
      // Standard BaseApp configuration with Material 3
      baseTheme: BaseThemeData(
        useMaterial3: true,
        materialTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
        ),
      ),
      
      // Initial route
      initialRoute: '/',
    );
  }
}

// Alternative: Traditional MaterialApp (without GetX)
class StandardApp extends StatelessWidget {
  const StandardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      title: 'Standard Flutter Base Example',
      
      // Disable GetX (default behavior)
      useGetX: false,
      
      // Traditional routing
      home: HomePage(),
      
      baseTheme: BaseThemeData(
        useMaterial3: true,
      ),
    );
  }
}

void main() {
  runApp(
    // Choose which app to run:
    GetXApp(),  // For GetX features
    // StandardApp(),  // For traditional Flutter
  );
}
