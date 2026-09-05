import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoApp, CupertinoThemeData;
import 'package:flutter/foundation.dart' show Diagnosticable, immutable;
import 'package:material_ui/material_ui.dart' show Brightness, Color, Colors, ColorScheme, MaterialApp, TextDecoration, ThemeData;

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
    double? appBarContentMaxWidth,
    double? sheetMaxWidth,
    bool appBarBackdropFilter = true,
    bool appBarTransitionBetweenRoutes = true,
    double appBarGlassBlur = 18.0,
    Color? appBarGlassColor,
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
      appBarContentMaxWidth: appBarContentMaxWidth,
      sheetMaxWidth: sheetMaxWidth,
      appBarBackdropFilter: appBarBackdropFilter,
      appBarTransitionBetweenRoutes: appBarTransitionBetweenRoutes,
      appBarGlassBlur: appBarGlassBlur,
      appBarGlassColor: appBarGlassColor,
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
    this.appBarContentMaxWidth,
    this.sheetMaxWidth,
    this.appBarBackdropFilter,
    this.appBarTransitionBetweenRoutes,
    this.appBarGlassBlur = 18.0,
    this.appBarGlassColor,
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

  /// App-wide default for [BaseAppBar.contentMaxWidth] — the widest every app
  /// bar draws, centred in the space it is given. Null (the default) leaves
  /// bars edge-to-edge. Set it once for tablet-class devices and every bar in
  /// the app lines up with its content column; an individual bar can still pass
  /// its own [BaseAppBar.contentMaxWidth] to override this.
  final double? appBarContentMaxWidth;

  /// App-wide default for [BaseNonModalSheet.maxWidth] — the widest a sheet
  /// draws, centred. Null leaves sheets edge-to-edge. Set it for tablet-class
  /// devices so a sheet doesn't stretch its controls across the whole window.
  final double? sheetMaxWidth;

  /// [BaseAppBar.appBarBackdropFilter]
  final bool? appBarBackdropFilter;

  /// [BaseAppBar.appBarTransitionBetweenRoutes]
  final bool? appBarTransitionBetweenRoutes;

  /// [BaseAppBar.glass] blur sigma for the frosted-glass app bar (Material).
  final double appBarGlassBlur;

  /// [BaseAppBar.glass] translucent tint painted over the blur.
  /// When null, falls back to `colorScheme.surface` at ~60% opacity.
  final Color? appBarGlassColor;

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
    double? appBarContentMaxWidth,
    double? sheetMaxWidth,
    bool? appBarBackdropFilter,
    bool? appBarTransitionBetweenRoutes,
    double? appBarGlassBlur,
    Color? appBarGlassColor,
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
      appBarContentMaxWidth:
          appBarContentMaxWidth ?? this.appBarContentMaxWidth,
      sheetMaxWidth: sheetMaxWidth ?? this.sheetMaxWidth,
      appBarBackdropFilter: appBarBackdropFilter ?? this.appBarBackdropFilter,
      appBarTransitionBetweenRoutes: appBarTransitionBetweenRoutes ?? this.appBarTransitionBetweenRoutes,
      appBarGlassBlur: appBarGlassBlur ?? this.appBarGlassBlur,
      appBarGlassColor: appBarGlassColor ?? this.appBarGlassColor,
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
