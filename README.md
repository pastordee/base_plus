<p align="center">
  <img src="https://github.com/nillnil/flutter_base/blob/master/screenshot/logo.png?raw=true" alt="logo">
</p>

# flutter_base

> 实现一套代码，2 种模式，ios 使用 Cupertino 风格组件，andriod、fuchsia 使用 Material 风格组件
> 
> **🆕 v3.0.0+1 新功能**: Material 3 支持、GetX 状态管理集成、iOS 16+ 现代设计

## [English](./README-EN.md)

## ✨ 主要特性

- 🎨 **自适应设计**: iOS 自动使用 Cupertino 组件，Android 使用 Material 组件
- 🚀 **Material 3 支持**: 最新的 Material You 设计系统，支持动态颜色
- ⚡ **GetX 集成**: 可选的响应式状态管理和路由系统
- 📱 **现代 iOS 设计**: 支持 iOS 16+ 设计模式
- 🔧 **向后兼容**: 现有代码 100% 兼容，渐进式升级
- 🎯 **Flutter 3.10+**: 支持最新 Flutter SDK 和 Dart 3.0+

## 🚀 快速开始

### 安装

因众所周知的原因，现 https://pub.flutter-io.cn/ 上的版本是旧版本，所以请使用 github 上的版本

在 pubspec.yaml 的 dependencies 加入：

```yaml
dependencies: 
  base:
    git:
      url: git://github.com/pastordee/flutter_base
      ref: v3.0.0+1  # 使用最新版本
  get: ^4.6.6  # 可选：如果需要 GetX 功能
```

### 基础用法

```dart
import 'package:base/base.dart';

BaseApp(
  title: 'My App',
  
  // 启用 Material 3 (推荐)
  baseTheme: BaseThemeData(
    useMaterial3: true,
    materialTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
  ),
  
  home: MyHomePage(),
)
```

### GetX 集成 (可选)

```dart
BaseApp(
  title: 'My GetX App',
  
  // 启用 GetX 功能
  useGetX: true,
  
  // GetX 路由配置
  getPages: [
    GetPage(name: '/', page: () => HomePage()),
    GetPage(name: '/settings', page: () => SettingsPage()),
  ],
  
  // Material 3 主题
  baseTheme: BaseThemeData(useMaterial3: true),
)
```

### 🆕 直接主题配置 (新功能)

现在可以直接在 BaseApp 中设置明暗主题，类似标准 MaterialApp：

```dart
BaseApp(
  title: 'My Themed App',
  
  // 直接设置明暗主题 - 新功能！
  lightTheme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,  // 跟随系统
  
  home: MyHomePage(),
)

// 主题定义
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
    );
  }
}
```

### 传统主题配置 (依然支持)

继续使用 BaseThemeData 进行更高级的主题配置：

```dart
BaseApp(
  title: 'My App',
  
  baseTheme: BaseThemeData(
    useMaterial3: true,
    materialTheme: AppTheme.lightTheme,
    materialDarkTheme: AppTheme.darkTheme,
    // 更多高级配置...
  ),
  
  themeMode: ThemeMode.system,
  home: MyHomePage(),
)
```

### 🆕 底部导航栏支持 (新功能)

现在可以直接在 BaseApp 中设置底部导航栏：

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _pages = [HomePage(), FavoritesPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      title: 'My App with Bottom Navigation',
      
      // 主题配置
      lightTheme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // 页面内容
      home: _pages[_currentIndex],
      
      // 底部导航栏 - 新功能！
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
```

#### 与 GetX 结合使用

```dart
BaseApp(
  title: 'GetX + Bottom Navigation',
  
  // 启用 GetX
  useGetX: true,
  
  // 主题和导航栏
  lightTheme: AppTheme.lightTheme,
  bottomNavigationBar: MyBottomNavigationBar(),
  
  home: HomePage(),
)
```

## 🎨 现代按钮系统

### Material 3 按钮层次结构

```dart
// 主要操作 (最高优先级)
BaseButton(
  child: Text('主要操作'),
  filledButton: true,  // Material 3 填充按钮
  onPressed: () {},
)

// 次要操作 (中等优先级)
BaseButton(
  child: Text('次要操作'),
  filledTonalButton: true,  // Material 3 色调按钮
  onPressed: () {},
)

// 其他操作
BaseButton(elevatedButton: true, ...)  // 浮起按钮
BaseButton(outlinedButton: true, ...)  // 轮廓按钮  
BaseButton(textButton: true, ...)      // 文本按钮
```

## 📱 平台适配效果

| 平台 | 设计系统 | 按钮样式 | 导航方式 |
|------|----------|----------|----------|
| iOS | Cupertino | CupertinoButton (iOS 16+ 样式) | 原生 iOS 导航 |
| Android | Material 3 | FilledButton (Material You) | Material 导航 |
| Web | Material 3 | 响应式设计 | 现代 Web 体验 |

## 🔄 升级指南

### 从 v2.x 升级到 v3.0

现有代码无需修改，新功能为可选启用：

```dart
// 老版本代码继续工作
BaseApp(
  home: MyPage(),
  // 现有配置保持不变
)

// 启用新功能 (可选)
BaseApp(
  baseTheme: BaseThemeData(useMaterial3: true),  // 启用 Material 3
  useGetX: true,  // 启用 GetX (如果需要)
  home: MyPage(),
)
```

## 📚 文档

- [完整文档](https://nillnil.github.io/flutter_base/)
- [GetX 集成指南](./GETX_INTEGRATION.md)
- [现代化升级说明](./MODERNIZATION_COMPLETE.md)
- [示例代码](./example/)

## 🎯 版本信息

### v3.0.0+1 (最新)
- ✅ Material 3 (Material You) 完整支持
- ✅ GetX 状态管理和路由集成
- ✅ iOS 16+ 现代设计模式
- ✅ Flutter 3.10+ 和 Dart 3.0+ 支持
- ✅ 新按钮类型：FilledButton、FilledButton.tonal
- ✅ 自动修复黄色下划线问题
- ✅ 100% 向后兼容

### 最低要求
- Flutter 3.10+
- Dart 3.0+
- iOS 12+ / Android API 21+

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 开源协议

本项目基于 MIT 协议开源。

