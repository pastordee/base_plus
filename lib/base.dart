/// # base_plus
///
/// An adaptive UI library for Flutter that provides one codebase with two design modes:
/// - **Cupertino Design** for iOS with iOS 16+ native component integration
/// - **Material 3 Design** for Android and Fuchsia with dynamic colors and modern aesthetics
///
/// ## Key Features
///
/// - 🎨 **Adaptive Design**: Automatically uses Cupertino on iOS, Material on Android/Fuchsia
/// - 🚀 **Material 3 Support**: Full Material You design system with semantic colors
/// - 📱 **Native iOS Components**: Direct UIKit integration (UISheetPresentationController, UIButton, UISearchBar, UIToolbar, UINavigationBar)
/// - ⚡ **GetX Integration**: Optional reactive state management and routing
/// - 🎯 **Modern Design**: iOS 16+ design patterns with Liquid Glass effects
/// - 🔧 **Backward Compatible**: Progressive upgrade path for existing projects
/// - 🌐 **Cross-Platform**: Flutter 3.10+, Dart 3.0+, iOS 12+, Android API 21+
///
/// ## Getting Started
///
/// Import the main library:
/// ```dart
/// import 'package:base_plus/base_plus.dart';
/// ```
///
/// Use [BaseApp] as your root widget, [BaseScaffold] for layouts, and adaptive widgets like
/// [BaseButton], [BaseNavigationBar], [BaseAppBar], and more.
///
/// ## Platform Modes
///
/// Control platform behavior with [BaseConfig]:
/// ```dart
/// BaseConfig.instance
///   ..cupertino = const BaseCupertinoConfig(forceUseMaterial: true)  // Use Material on iOS
///   ..material = const BaseMaterialConfig(forceUseCupertino: true);  // Use Cupertino on Android
/// ```
///
/// ## Documentation
///
/// See individual component documentation for detailed API references and examples.
/// Visit https://github.com/pastordee/base_plus for more information.

library base;

export 'base_common.dart';
export 'base_components.dart';
export 'base_theme.dart';
export 'base_tools.dart';
export 'base_widgets.dart';
