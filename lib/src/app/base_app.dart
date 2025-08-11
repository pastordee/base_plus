import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';
import '../config/base_config.dart' as config;
import '../mode/base_mode.dart';
import '../theme/base_theme.dart';
import '../theme/base_theme_data.dart';

/// BaseApp
/// theme, use cupertinoTheme by cupertino，use materialTheme by material.
/// use CupertinoApp by cupertino
/// not support CupertinoApp.router yet.
/// *** use cupertino = { forceUseMaterial: true } force use MaterialApp/GetMaterialApp on cupertino.
/// use MaterialApp or GetMaterialApp by material (controlled by useGetX parameter)
/// not support MaterialApp.router yet.
/// *** use material = { forceUseCupertino: true } force use CupertinoApp on material.
/// 
/// GetX Support: Set useGetX: true to enable GetMaterialApp with state management and routing
///
/// CupertinoApp: 2021.04.03
/// MaterialApp: 2021.04.02
/// GetMaterialApp: Added 2025.08.09 for GetX support
/// modify 2021.06.25 by flutter 2.2.2
class BaseApp extends BaseStatelessWidget {
  const BaseApp({
    Key? key,
    this.navigatorKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.restorationScopeId,
    this.scrollBehavior,
    this.baseTheme,
    this.lightTheme,
    this.darkTheme,
    this.shortcuts,
    this.actions,
    this.withoutSplashOnCupertino = true,
    this.scaffoldMessengerKey,
    this.themeMode = ThemeMode.system,
    this.useMaterial3 = true,
    this.useGetX = false,
    this.getPages,
    this.unknownRoute,
    this.routingCallback,
    this.defaultTransition,
    this.getxLocale,
    this.fallbackLocale,
    this.translations,
    this.initialBinding,
    this.smartManagement = SmartManagement.full,
    this.enableLog = kDebugMode,
    this.logWriterCallback,
    this.debugShowMaterialGrid = false,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties start ***

  /// [CupertinoApp.navigatorKey]
  /// or
  /// [MaterialApp.navigatorKey]
  final GlobalKey<NavigatorState>? navigatorKey;

  /// [CupertinoApp.home]
  /// or
  /// [Material.home]
  final Widget? home;

  /// [CupertinoApp.routes]
  /// or
  /// [MaterialApp.routes]
  final Map<String, WidgetBuilder>? routes;

  /// [CupertinoApp.initialRoute]
  /// or
  /// [MaterialApp.initialRoute]
  final String? initialRoute;

  /// [CupertinoApp.onGenerateRoute]
  /// or
  /// [MaterialApp.onGenerateRoute]
  final RouteFactory? onGenerateRoute;

  /// [CupertinoApp.onGenerateInitialRoutes]
  /// or
  /// [MaterialApp.onGenerateInitialRoutes]
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// [CupertinoApp.onUnknownRoute]
  /// or
  /// [MaterialApp.onUnknownRoute]
  final RouteFactory? onUnknownRoute;

  /// [CupertinoApp.navigatorObservers]
  /// or
  /// [MaterialApp.navigatorObservers]
  final List<NavigatorObserver>? navigatorObservers;

  /// [CupertinoApp.builder]
  /// or
  /// [MaterialApp.builder]
  final TransitionBuilder? builder;

  /// [CupertinoApp.title]
  /// or
  /// [MaterialApp.title]
  final String title;

  /// [CupertinoApp.onGenerateTitle]
  /// or
  /// [MaterialApp.onGenerateTitle]
  final GenerateAppTitle? onGenerateTitle;

  /// [CupertinoApp.color]
  /// or
  /// [MaterialApp.color]
  final Color? color;

  /// [CupertinoApp.locale]
  /// or
  /// [MaterialApp.locale]
  final Locale? locale;

  /// [CupertinoApp.localizationsDelegates]
  /// or
  /// [MaterialApp.localizationsDelegates]
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// [CupertinoApp.localeListResolutionCallback]
  /// or
  /// [MaterialApp.localeListResolutionCallback]
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// [CupertinoApp.localeResolutionCallback]
  /// or
  /// [MaterialApp.localeResolutionCallback]
  final LocaleResolutionCallback? localeResolutionCallback;

  /// [CupertinoApp.supportedLocales]
  /// or
  /// [MaterialApp.supportedLocales]
  final Iterable<Locale> supportedLocales;

  /// [CupertinoApp.showPerformanceOverlay]
  /// or
  /// [MaterialApp.showPerformanceOverlay]
  final bool showPerformanceOverlay;

  /// [CupertinoApp.checkerboardRasterCacheImages]
  /// or
  /// [MaterialApp.checkerboardRasterCacheImages]
  final bool checkerboardRasterCacheImages;

  /// [CupertinoApp.checkerboardOffscreenLayers]
  /// or
  /// [MaterialApp.checkerboardOffscreenLayers]
  final bool checkerboardOffscreenLayers;

  /// [CupertinoApp.showSemanticsDebugger]
  /// or
  /// [MaterialApp.showSemanticsDebugger]
  final bool showSemanticsDebugger;

  /// [CupertinoApp.debugShowCheckedModeBanner]
  /// or
  /// [MaterialApp.debugShowCheckedModeBanner]
  final bool debugShowCheckedModeBanner;

  /// [BaseThemeData]
  final BaseThemeData? baseTheme;

  /// [MaterialApp.theme] - Light theme for Material Design
  /// Can be used as an alternative to baseTheme.materialTheme
  final ThemeData? lightTheme;

  /// [MaterialApp.darkTheme] - Dark theme for Material Design  
  /// Can be used as an alternative to baseTheme.materialDarkTheme
  final ThemeData? darkTheme;

  /// [CupertinoApp.shortcuts]
  /// or
  /// [MaterialApp.shortcuts]
  final Map<LogicalKeySet, Intent>? shortcuts;

  /// [CupertinoApp.actions]
  /// or
  /// [MaterialApp.actions]
  final Map<LocalKey, Action<Intent>>? actions;

  /// [CupertinoApp.restorationScopeId]
  /// or
  /// [MaterialApp.restorationScopeId]
  final String? restorationScopeId;

  /// [CupertinoApp.scrollBehavior]
  /// or
  /// [MaterialApp.scrollBehavior]
  final ScrollBehavior? scrollBehavior;

  /// *** general properties end ***

  /// *** cupertino properties start ***

  /// [withoutSplashOnCupertino], default is true
  ///
  /// forbidden ripple effect on cupertino mode
  ///
  /// Whether to disable ripple effects in cupertino mode
  final bool withoutSplashOnCupertino;

  /// *** cupertino properties end ***

  /// *** material properties start ***

  /// [MaterialApp.scaffoldMessengerKey]
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// [MaterialApp.themeMode]
  final ThemeMode? themeMode;

  /// [MaterialApp.useMaterial3] - Enable Material 3 design
  final bool useMaterial3;

  /// [MaterialApp.debugShowMaterialGrid]
  final bool debugShowMaterialGrid;

  /// *** material properties end ***

  /// *** GetX properties start ***

  /// Enable GetX functionality (GetMaterialApp instead of MaterialApp)
  final bool useGetX;

  /// [GetMaterialApp.getPages]
  final List<GetPage>? getPages;

  /// [GetMaterialApp.unknownRoute]
  final GetPage? unknownRoute;

  /// [GetMaterialApp.routingCallback]
  final ValueChanged<Routing?>? routingCallback;

  /// [GetMaterialApp.defaultTransition]
  final Transition? defaultTransition;

  /// [GetMaterialApp.locale]
  final Locale? getxLocale;

  /// [GetMaterialApp.fallbackLocale]
  final Locale? fallbackLocale;

  /// [GetMaterialApp.translations]
  final Translations? translations;

  /// [GetMaterialApp.initialBinding]
  final Bindings? initialBinding;

  /// [GetMaterialApp.smartManagement]
  final SmartManagement smartManagement;

  /// [GetMaterialApp.enableLog]
  final bool enableLog;

  /// [GetMaterialApp.logWriterCallback]
  final LogWriterCallback? logWriterCallback;

  /// *** GetX properties end ***

  @override
  void beforeBuild(BuildContext context) {
    /// Set whether to disable ripple effects
    if (baseTheme != null) {
      config.withoutSplashOnCupertino = baseTheme!.withoutSplashOnCupertino;
    }

    /// Set platform mode
    setBasePlatformMode(
      basePlatformMode: baseTheme?.platformMode ?? const BasePlatformMode(),
    );
  }

  /// Resolves the effective BaseThemeData by merging direct theme parameters with baseTheme
  BaseThemeData _resolveBaseTheme() {
    final BaseThemeData _baseTheme = valueOf('baseTheme', baseTheme) ?? BaseThemeData();
    final ThemeData? _lightTheme = valueOf('lightTheme', lightTheme);
    final ThemeData? _darkTheme = valueOf('darkTheme', darkTheme);
    
    // If direct theme parameters are provided, merge them with baseTheme
    if (_lightTheme != null || _darkTheme != null) {
      return _baseTheme.copyWith(
        materialTheme: _lightTheme ?? _baseTheme.materialTheme,
        materialDarkTheme: _darkTheme ?? _baseTheme.materialDarkTheme,
      );
    }
    
    return _baseTheme;
  }

  @override
  Widget buildByCupertino(BuildContext context) {
    final BaseThemeData _baseTheme = _resolveBaseTheme();
    final bool _useGetX = valueOf('useGetX', useGetX);
    
    // If GetX is enabled, use GetMaterialApp even on iOS
    if (_useGetX) {
      return BaseTheme(
        data: _baseTheme,
        child: _buildGetMaterialApp(_baseTheme),
      );
    }
    
    // Otherwise use traditional CupertinoApp
    return BaseTheme(
      data: _baseTheme,
      child: CupertinoApp(
        navigatorKey: valueOf('navigatorKey', navigatorKey),
        home: valueOf('home', home),
        theme: _baseTheme.cupertinoTheme,
        routes: valueOf('routes', routes),
        initialRoute: valueOf('initialRoute', initialRoute),
        onGenerateRoute: valueOf('onGenerateRoute', onGenerateRoute),
        onGenerateInitialRoutes: valueOf('onGenerateInitialRoutes', onGenerateInitialRoutes),
        onUnknownRoute: valueOf('onUnknownRoute', onUnknownRoute),
        navigatorObservers: valueOf(
          'navigatorObservers',
          navigatorObservers,
        ),
        builder: valueOf('builder', builder),
        title: valueOf('title', title),
        onGenerateTitle: valueOf('onGenerateTitle', onGenerateTitle),
        color: valueOf('color', color),
        locale: valueOf('locale', locale),
        localizationsDelegates: valueOf(
          'localizationsDelegates',
          localizationsDelegates,
        ),
        localeListResolutionCallback: valueOf(
          'localeListResolutionCallback',
          localeListResolutionCallback,
        ),
        localeResolutionCallback: valueOf(
          'localeResolutionCallback',
          localeResolutionCallback,
        ),
        supportedLocales: valueOf(
          'supportedLocales',
          supportedLocales,
        ),
        showPerformanceOverlay: valueOf(
          'showPerformanceOverlay',
          showPerformanceOverlay,
        ),
        checkerboardRasterCacheImages: valueOf(
          'checkerboardRasterCacheImages',
          checkerboardRasterCacheImages,
        ),
        checkerboardOffscreenLayers: valueOf(
          'checkerboardOffscreenLayers',
          checkerboardOffscreenLayers,
        ),
        showSemanticsDebugger: valueOf(
          'showSemanticsDebugger',
          showSemanticsDebugger,
        ),
        debugShowCheckedModeBanner: valueOf(
          'debugShowCheckedModeBanner',
          debugShowCheckedModeBanner,
        ),
        shortcuts: valueOf('shortcuts', shortcuts),
        actions: valueOf('actions', actions),
        restorationScopeId: valueOf('restorationScopeId', restorationScopeId),
        scrollBehavior: valueOf('scrollBehavior', scrollBehavior),
      ),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final BaseThemeData _baseTheme = _resolveBaseTheme();
    final bool _useGetX = valueOf('useGetX', useGetX);
    
    return BaseTheme(
      data: _baseTheme,
      child: _useGetX ? _buildGetMaterialApp(_baseTheme) : _buildMaterialApp(_baseTheme),
    );
  }

  /// Build traditional MaterialApp
  Widget _buildMaterialApp(BaseThemeData baseTheme) {
    return MaterialApp(
      navigatorKey: valueOf('navigatorKey', navigatorKey),
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: valueOf('home', home),
      routes: valueOf('routes', routes),
      initialRoute: valueOf('initialRoute', initialRoute),
      onGenerateRoute: valueOf('onGenerateRoute', onGenerateRoute),
      onGenerateInitialRoutes: valueOf('onGenerateInitialRoutes', onGenerateInitialRoutes),
      onUnknownRoute: valueOf('onUnknownRoute', onUnknownRoute),
      navigatorObservers: valueOf(
        'navigatorObservers',
        navigatorObservers,
      ),
      builder: valueOf('builder', builder),
      title: valueOf('title', title),
      onGenerateTitle: valueOf('onGenerateTitle', onGenerateTitle),
      color: valueOf('color', color),
      theme: baseTheme.materialTheme,
      darkTheme: baseTheme.materialDarkTheme,
      highContrastTheme: baseTheme.materialHighContrastTheme,
      highContrastDarkTheme: baseTheme.materialHighContrastDarkTheme,
      themeMode: valueOf('themeMode', themeMode),
      locale: valueOf('locale', locale),
      localizationsDelegates: valueOf(
        'localizationsDelegates',
        localizationsDelegates,
      ),
      localeListResolutionCallback: valueOf(
        'localeListResolutionCallback',
        localeListResolutionCallback,
      ),
      localeResolutionCallback: valueOf(
        'localeResolutionCallback',
        localeResolutionCallback,
      ),
      supportedLocales: valueOf(
        'supportedLocales',
        supportedLocales,
      ),
      debugShowMaterialGrid: valueOf(
        'debugShowMaterialGrid',
        debugShowMaterialGrid,
      ),
      showPerformanceOverlay: valueOf(
        'showPerformanceOverlay',
        showPerformanceOverlay,
      ),
      checkerboardRasterCacheImages: valueOf(
        'checkerboardRasterCacheImages',
        checkerboardRasterCacheImages,
      ),
      checkerboardOffscreenLayers: valueOf(
        'checkerboardOffscreenLayers',
        checkerboardOffscreenLayers,
      ),
      showSemanticsDebugger: valueOf(
        'showSemanticsDebugger',
        showSemanticsDebugger,
      ),
      debugShowCheckedModeBanner: valueOf(
        'debugShowCheckedModeBanner',
        debugShowCheckedModeBanner,
      ),
      shortcuts: valueOf('shortcuts', shortcuts),
      actions: valueOf('actions', actions),
      restorationScopeId: valueOf('restorationScopeId', restorationScopeId),
      scrollBehavior: valueOf('scrollBehavior', scrollBehavior),
    );
  }

  /// Build GetMaterialApp for GetX functionality
  Widget _buildGetMaterialApp(BaseThemeData baseTheme) {
    return GetMaterialApp(
      navigatorKey: valueOf('navigatorKey', navigatorKey),
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: valueOf('home', home),
      routes: valueOf('routes', routes),
      getPages: valueOf('getPages', getPages),
      unknownRoute: valueOf('unknownRoute', unknownRoute),
      initialRoute: valueOf('initialRoute', initialRoute),
      onGenerateRoute: valueOf('onGenerateRoute', onGenerateRoute),
      onGenerateInitialRoutes: valueOf('onGenerateInitialRoutes', onGenerateInitialRoutes),
      onUnknownRoute: valueOf('onUnknownRoute', onUnknownRoute),
      navigatorObservers: valueOf(
        'navigatorObservers',
        navigatorObservers,
      ),
      routingCallback: valueOf('routingCallback', routingCallback),
      defaultTransition: valueOf('defaultTransition', defaultTransition),
      builder: valueOf('builder', builder),
      title: valueOf('title', title),
      onGenerateTitle: valueOf('onGenerateTitle', onGenerateTitle),
      color: valueOf('color', color),
      theme: baseTheme.materialTheme,
      darkTheme: baseTheme.materialDarkTheme,
      highContrastTheme: baseTheme.materialHighContrastTheme,
      highContrastDarkTheme: baseTheme.materialHighContrastDarkTheme,
      themeMode: valueOf('themeMode', themeMode),
      locale: valueOf('getxLocale', getxLocale) ?? valueOf('locale', locale),
      fallbackLocale: valueOf('fallbackLocale', fallbackLocale),
      localizationsDelegates: valueOf(
        'localizationsDelegates',
        localizationsDelegates,
      ),
      localeListResolutionCallback: valueOf(
        'localeListResolutionCallback',
        localeListResolutionCallback,
      ),
      localeResolutionCallback: valueOf(
        'localeResolutionCallback',
        localeResolutionCallback,
      ),
      supportedLocales: valueOf(
        'supportedLocales',
        supportedLocales,
      ),
      debugShowMaterialGrid: valueOf(
        'debugShowMaterialGrid',
        debugShowMaterialGrid,
      ),
      showPerformanceOverlay: valueOf(
        'showPerformanceOverlay',
        showPerformanceOverlay,
      ),
      checkerboardRasterCacheImages: valueOf(
        'checkerboardRasterCacheImages',
        checkerboardRasterCacheImages,
      ),
      checkerboardOffscreenLayers: valueOf(
        'checkerboardOffscreenLayers',
        checkerboardOffscreenLayers,
      ),
      showSemanticsDebugger: valueOf(
        'showSemanticsDebugger',
        showSemanticsDebugger,
      ),
      debugShowCheckedModeBanner: valueOf(
        'debugShowCheckedModeBanner',
        debugShowCheckedModeBanner,
      ),
      shortcuts: valueOf('shortcuts', shortcuts),
      actions: valueOf('actions', actions),
      scrollBehavior: valueOf('scrollBehavior', scrollBehavior),
      translations: valueOf('translations', translations),
      initialBinding: valueOf('initialBinding', initialBinding),
      smartManagement: valueOf('smartManagement', smartManagement),
      enableLog: valueOf('enableLog', enableLog),
      logWriterCallback: valueOf('logWriterCallback', logWriterCallback),
    );
  }
}
