import 'package:flutter/cupertino.dart' show CupertinoApp, CupertinoThemeData;
import 'package:flutter/foundation.dart' show Diagnosticable, immutable;
import 'package:flutter/material.dart' show Brightness, Color, Colors, ColorScheme, MaterialApp, TextDecoration, ThemeData;

import '../app/base_app.dart';
import '../appbar/base_app_bar.dart';
import '../base_param.dart';
import '../mode/base_mode.dart';
import '../route/base_route.dart';

/// BaseThemeData
/// Special properties values global setting
/// Reference [ThemeData]
@immutable
class BaseThemeData with Diagnosticable {
  factory BaseThemeData({
    Brightness? brightness,
    double? appBarHeight,
    bool appBarBackdropFilter = true,
    bool appBarTransitionBetweenRoutes = true,
    ThemeData? materialTheme,
    ThemeData? materialDarkTheme,
    ThemeData? materialHighContrastTheme,
    ThemeData? materialHighContrastDarkTheme,
    CupertinoThemeData? cupertinoTheme,
    bool useMaterial3 = true,
    bool routeFullscreenGackGesture = false,
    Color? sectionDividerColor,
    Color? tileBackgroundColor,
    BasePlatformMode? platformMode = const BasePlatformMode(),
    bool withoutSplashOnCupertino = true,
    BaseParam? baseParam,
  }) {
    brightness ??= Brightness.light;
    final bool isDark = brightness == Brightness.dark;
    
    // Create default Material 3 themes if not provided and useMaterial3 is true
    if (useMaterial3 && materialTheme == null) {
      materialTheme = ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        // Ensure proper default text styling to prevent yellow underlines
        textTheme: ThemeData.light().textTheme,
      );
    }
    
    if (useMaterial3 && materialDarkTheme == null) {
      materialDarkTheme = ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        // Ensure proper default text styling to prevent yellow underlines
        textTheme: ThemeData.dark().textTheme,
      );
    }
    
    // Ensure any provided themes have proper text styling
    if (materialTheme != null) {
      // Only modify if the theme doesn't already have a complete textTheme
      if (materialTheme.textTheme.bodyMedium?.decoration != TextDecoration.none) {
        materialTheme = materialTheme.copyWith(
          textTheme: ThemeData.light().textTheme,
        );
      }
    }
    
    if (materialDarkTheme != null) {
      // Only modify if the theme doesn't already have a complete textTheme
      if (materialDarkTheme.textTheme.bodyMedium?.decoration != TextDecoration.none) {
        materialDarkTheme = materialDarkTheme.copyWith(
          textTheme: ThemeData.dark().textTheme,
        );
      }
    }
    
    return BaseThemeData.raw(
      brightness: brightness,
      appBarHeight: appBarHeight,
      appBarBackdropFilter: appBarBackdropFilter,
      appBarTransitionBetweenRoutes: appBarTransitionBetweenRoutes,
      materialTheme: materialTheme,
      materialDarkTheme: materialDarkTheme,
      materialHighContrastTheme: materialHighContrastTheme,
      materialHighContrastDarkTheme: materialHighContrastDarkTheme,
      cupertinoTheme: cupertinoTheme,
      useMaterial3: useMaterial3,
      routeFullscreenGackGesture: routeFullscreenGackGesture,
      sectionDividerColor: sectionDividerColor ?? (isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000)),
      tileBackgroundColor: tileBackgroundColor,
      platformMode: platformMode,
      withoutSplashOnCupertino: withoutSplashOnCupertino,
      baseParam: baseParam,
    );
  }
  const BaseThemeData.raw({
    this.brightness,
    this.appBarHeight,
    this.appBarBackdropFilter,
    this.appBarTransitionBetweenRoutes,
    this.materialTheme,
    this.materialDarkTheme,
    this.materialHighContrastTheme,
    this.materialHighContrastDarkTheme,
    this.cupertinoTheme,
    this.useMaterial3 = true,
    this.routeFullscreenGackGesture = false,
    this.sectionDividerColor,
    this.tileBackgroundColor,
    this.platformMode = const BasePlatformMode(),
    this.withoutSplashOnCupertino = true,
    this.baseParam,
  });

  final Brightness? brightness;

  /// [BaseAppBar.height]
  final double? appBarHeight;

  /// [BaseAppBar.appBarBackdropFilter]
  final bool? appBarBackdropFilter;

  /// [BaseAppBar.appBarTransitionBetweenRoutes]
  final bool? appBarTransitionBetweenRoutes;

  /// [BaseRoute.fullscreenGackGesture]
  final bool routeFullscreenGackGesture;

  /// [MaterialApp.theme]
  /// When using Material components in Cupertino mode,
  /// you can use Theme.of(context) to get [BaseApp.materialTheme]
  ///
  /// null in Material mode
  final ThemeData? materialTheme;

  /// [MaterialApp.materialDarkTheme]
  /// When using Material components in Cupertino mode,
  /// you can use Theme.of(context) to get [BaseApp.materialDarkTheme]
  ///
  /// null in Material mode
  final ThemeData? materialDarkTheme;

  /// [MaterialApp.highContrastTheme]
  /// When using Material components in Cupertino mode,
  /// you can use Theme.of(context) to get [BaseApp.highContrastTheme]
  ///
  /// null in Material mode
  final ThemeData? materialHighContrastTheme;

  /// [MaterialApp.highContrastDarkTheme]
  /// When using Material components in Cupertino mode,
  /// you can use Theme.of(context) to get [BaseApp.highContrastDarkTheme]
  ///
  /// null in Material mode
  final ThemeData? materialHighContrastDarkTheme;

  /// [CupertinoApp.theme]
  /// When using Cupertino components in Material mode,
  /// you can use CupertinoTheme.of(context) to get [BaseApp.cupertinoTheme]
  ///
  /// null in Cupertino mode
  final CupertinoThemeData? cupertinoTheme;

  /// Enable Material 3 design system
  /// Enable Material 3 design system
  final bool useMaterial3;

  /// BaseSection's divider's color
  /// BaseSection's divider color
  final Color? sectionDividerColor;

  /// BaseTile's BackgroundColor
  /// BaseTile's background color
  /// Recommended to use BaseColor().build(context) to build 2 colors
  final Color? tileBackgroundColor;

  /// Platform mode
  /// base platform mode
  final BasePlatformMode? platformMode;

  /// Whether to remove ripple effects when using Material components in Cupertino mode
  /// Use Material Widget without splash on Cupertino's mode
  final bool withoutSplashOnCupertino;

  /// See also:
  ///
  ///  * [BaseStatelessWidget.baseParam], special parameters values on cupertino mode or target platform.
  ///  * [BaseStatelessWidget.baseParam], special parameters values on material mode or target platform.
  final BaseParam? baseParam;

  BaseThemeData copyWith({
    Brightness? brightness,
    double? appBarHeight,
    bool? appBarBackdropFilter,
    bool? appBarTransitionBetweenRoutes,
    ThemeData? materialTheme,
    ThemeData? materialDarkTheme,
    ThemeData? materialHighContrastTheme,
    ThemeData? materialHighContrastDarkTheme,
    CupertinoThemeData? cupertinoTheme,
    bool? routeFullscreenGackGesture,
    Color? sectionDividerColor,
    Color? tileBackgroundColor,
    BasePlatformMode? platformMode,
    bool? withoutSplashOnCupertino,
    BaseParam? baseParam,
  }) {
    return BaseThemeData.raw(
      brightness: brightness ?? this.brightness,
      appBarHeight: appBarHeight ?? this.appBarHeight,
      appBarBackdropFilter: appBarBackdropFilter ?? this.appBarBackdropFilter,
      appBarTransitionBetweenRoutes: appBarTransitionBetweenRoutes ?? this.appBarTransitionBetweenRoutes,
      materialTheme: materialTheme ?? this.materialTheme,
      materialDarkTheme: materialDarkTheme ?? this.materialDarkTheme,
      materialHighContrastTheme: materialHighContrastTheme ?? this.materialHighContrastTheme,
      materialHighContrastDarkTheme: materialHighContrastDarkTheme ?? this.materialHighContrastDarkTheme,
      cupertinoTheme: cupertinoTheme ?? this.cupertinoTheme,
      routeFullscreenGackGesture: routeFullscreenGackGesture ?? this.routeFullscreenGackGesture,
      sectionDividerColor: sectionDividerColor ?? this.sectionDividerColor,
      tileBackgroundColor: tileBackgroundColor ?? this.tileBackgroundColor,
      platformMode: platformMode ?? this.platformMode,
      withoutSplashOnCupertino: withoutSplashOnCupertino ?? this.withoutSplashOnCupertino,
      baseParam: baseParam ?? this.baseParam,
    );
  }

  dynamic valueOf(String key, dynamic value) {
    return baseParam != null ? baseParam!.valueOf(key, value) ?? value : value;
  }
}
