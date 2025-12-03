import 'dart:ui';
import 'package:flutter/cupertino.dart' hide CupertinoTabScaffold, CupertinoTabBar, CupertinoTabController;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// iOS 26 Liquid Glass Dynamic Material Native Implementation
// import 'package:cupertino_native_extra/cupertino_native.dart';
// import 'package:liquid_glass_texture/liquid_glass_texture.dart';

import '../base_param.dart';
import '../base_stateful_widget.dart';
import '../appbar/base_app_bar.dart';
import '../flutter/cupertino/bottom_tab_bar.dart';
import '../flutter/cupertino/tab_scaffold.dart';
import '../tabbar/base_tab_bar.dart';

/// BaseTabScaffold
/// use CupertinoTabScaffold by cupertino
/// *** use cupertino = { forceUseMaterial: true } to force use Scaffold
/// material，use Scaffold by material
/// *** use material = { forceUseCupertino: true } to force use CupertinoTabScaffold
///
/// CupertinoTabScaffold: 2021.04.01
/// Scaffold: 2021.04.03
/// modify 2021.06.25 by flutter 2.2.2
class BaseTabScaffold extends BaseStatefulWidget { 
  const BaseTabScaffold({
    Key? key,
    this.appBar,
    this.backgroundColor,
    this.tabBar,
    this.tabViews,
    this.resizeToAvoidBottomInset = true,
    this.controller,
    this.routes = const <String, WidgetBuilder>{},
    this.restorationId,
    this.restorationScopeIds,
    this.navigatorKeys,
    this.onGenerateRoute,
    this.defaultTitle,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.tabViewKeys,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties start ***

  /// AppBar for the tab scaffold
  /// Will use CNNavigationBar when nativeIOS is enabled
  final BaseAppBar? appBar;

  /// [CupertinoTabScaffold.backgroundColor]
  /// or
  /// [Scaffold.backgroundColor]
  final Color? backgroundColor;

  /// [CupertinoTabBar]
  /// or
  /// [BottomNavigationBar]
  final BaseTabBar? tabBar;

  /// [CupertinoTabView.builder]
  /// or
  /// [Scaffold.body]
  final List<Widget>? tabViews;

  /// [CupertinoTabView.restorationScopeId]
  final List<String?>? restorationScopeIds;

  /// [CupertinoTabScaffold.resizeToAvoidBottomInset]
  /// or
  /// [Scaffold.resizeToAvoidBottomInset]
  final bool resizeToAvoidBottomInset;

  /// [CupertinoTabScaffold.restorationId]
  /// or
  /// [Scaffold.restorationId]
  final String? restorationId;

  /// *** general properties end ***

  /// *** cupertino properties start ***

  /// [CupertinoTabScaffold.controller]
  final CupertinoTabController? controller;

  /// [CupertinoTabView.tabViewKey]
  final List<Key?>? tabViewKeys;

  /// [CupertinoTabView.routes]
  final Map<String, WidgetBuilder>? routes;

  /// [CupertinoTabView.navigatorKey]
  final List<GlobalKey<NavigatorState>?>? navigatorKeys;

  /// [CupertinoTabView.defaultTitle]
  final String? defaultTitle;

  /// [CupertinoTabView.onGenerateRoute]
  final RouteFactory? onGenerateRoute;

  /// [CupertinoTabView.onUnknownRoute]
  final RouteFactory? onUnknownRoute;

  /// [CupertinoTabView.navigatorObservers]
  final List<NavigatorObserver> navigatorObservers;

  /// *** cupertino properties end ***

  /// *** material properties start ***

  /// [Scaffold.floatingActionButton]
  final Widget? floatingActionButton;

  /// [Scaffold.floatingActionButtonLocation]
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// [Scaffold.floatingActionButtonAnimator]
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// [Scaffold.persistentFooterButtons]
  final List<Widget>? persistentFooterButtons;

  /// [Scaffold.drawer]
  final Widget? drawer;

  /// [Scaffold.onDrawerChanged]
  final DrawerCallback? onDrawerChanged;

  /// [Scaffold.endDrawer]
  final Widget? endDrawer;

  /// [Scaffold.onEndDrawerChanged]
  final DrawerCallback? onEndDrawerChanged;

  /// [Scaffold.bottomSheet]
  final Widget? bottomSheet;

  /// [Scaffold.primary]
  final bool primary;

  /// [Scaffold.drawerDragStartBehavior]
  final DragStartBehavior drawerDragStartBehavior;

  /// [Scaffold.extendBody]
  final bool extendBody;

  /// [Scaffold.extendBodyBehindAppBar]
  final bool extendBodyBehindAppBar;

  /// [Scaffold.drawerScrimColor]
  final Color? drawerScrimColor;

  /// [Scaffold.drawerEdgeDragWidth]
  final double? drawerEdgeDragWidth;

  /// [Scaffold.drawerEnableOpenDragGesture]
  final bool drawerEnableOpenDragGesture;

  /// [Scaffold.endDrawerEnableOpenDragGesture]
  final bool endDrawerEnableOpenDragGesture;

  /// *** material properties end ***

  @override
  State<BaseTabScaffold> createState() => _BaseTabScaffoldState();
}

class _BaseTabScaffoldState extends BaseState<BaseTabScaffold> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final BaseTabBar? tabBar = widget.tabBar;
    if (tabBar != null) {
      _currentIndex = tabBar.currentIndex;
    }
  }  

  @override
  Widget buildByCupertino(BuildContext context) {
    // Flutter-based Cupertino implementation (backward compatible)
    // Uses CupertinoTabScaffold with CupertinoTabBar
    final BaseTabBar? tabBar = valueOf('tabBar', widget.tabBar);
    final Color? backgroundColor = valueOf('backgroundColor', widget.backgroundColor);
    final bool? resizeToAvoidBottomInset = valueOf('resizeToAvoidBottomInset', widget.resizeToAvoidBottomInset);
    final String? restorationId = valueOf('restorationId', widget.restorationId);
    
    // Get the raw CupertinoTabBar without Liquid Glass wrapping
    final CupertinoTabBar rawTabBar = tabBar?.buildCupertinoTabBar(context) ?? 
      CupertinoTabBar(items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
      ]);
    
    Widget scaffold = CupertinoTabScaffold(
      tabBar: rawTabBar,
      tabBuilder: _buildTabView,
      controller: valueOf('controller', widget.controller),
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? false,
      restorationId: restorationId,
    );
    
    // Apply iOS 26 Liquid Glass effects at scaffold level if enabled
    if (tabBar != null && valueOf('enableLiquidGlass', tabBar.enableLiquidGlass)) {
      scaffold = _wrapScaffoldWithLiquidGlass(context, scaffold);
    }
    
    return scaffold;
  }

  @override
  Widget buildByCupertinoNative(BuildContext context) {
    // Native iOS implementation using manual scaffold construction
    // This allows BaseTabBar to use CNTabBar when nativeIOS is enabled
    // Similar to Material's approach but with Cupertino styling
    
    final BaseTabBar? tabBar = valueOf('tabBar', widget.tabBar);
    final List<Widget>? tabViews = valueOf('tabViews', widget.tabViews);
    final Color? backgroundColor = valueOf('backgroundColor', widget.backgroundColor);
    final BaseAppBar? appBar = valueOf('appBar', widget.appBar);
    
    if (tabBar == null || tabViews == null || tabViews.isEmpty) {
      // Fallback to standard implementation if required data is missing
      return buildByCupertino(context);
    }
    
    // Build scaffold with body and bottom navigation bar
    // This approach allows the BaseTabBar to render natively with CNTabBar
    // Using Stack with Positioned to overlay tab bar (like BottomNavigationExample)
    
    // Calculate tab bar height (standard iOS tab bar height)
    final double tabBarHeight = 49.0 + MediaQuery.of(context).padding.bottom;
    
    Widget content = Stack(
      children: [
        // Tab content fills the screen but leaves space for tab bar
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: tabBarHeight, // Leave space for tab bar
          child: IndexedStack(
            index: _currentIndex, // Use state instead of reading from tabBar
            children: tabViews.asMap().entries.map((entry) {
              return _buildTabViewForNative(context, entry.key, entry.value);
            }).toList(),
          ),
        ),
        // Bottom tab bar overlaid at the bottom - will use CNTabBar when nativeIOS is enabled
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: tabBar.copyWith(
            baseParam: widget.baseParam, // Pass the nativeIOS flag to tab bar
            onTap: (int index) {
              print('🟢 BaseTabScaffold onTap called with index: $index, current: $_currentIndex');
              // Update scaffold state
              setState(() {
                _currentIndex = index;
              });
              print('🟢 Updated _currentIndex to: $_currentIndex');
              // Call the original onTap callback if provided
              if (tabBar.onTap != null) {
                print('🟢 Calling original tabBar.onTap');
                tabBar.onTap!(index);
              }
            },
            currentIndex: _currentIndex, // Use state
          ),
        ),
      ],
    );
    
    // If appBar is provided, wrap content in Column with appBar on top
    if (appBar != null) {
      content = Column(
        children: [
          appBar,
          Expanded(child: content),
        ],
      );
    }
    
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: valueOf('resizeToAvoidBottomInset', widget.resizeToAvoidBottomInset) ?? false,
      child: content,
    );
  }
  
  /// Builds individual tab view for native implementation
  /// Wraps content in CupertinoTabView if navigation is needed
  Widget _buildTabViewForNative(BuildContext context, int index, Widget content) {
    final List<String?>? restorationScopeIds = valueOf('restorationScopeIds', widget.restorationScopeIds);
    final Map<String, WidgetBuilder>? routes = valueOf('routes', widget.routes);
    final List<GlobalKey<NavigatorState>?>? navigatorKeys = valueOf('navigatorKeys', widget.navigatorKeys);
    final String? defaultTitle = valueOf('defaultTitle', widget.defaultTitle);
    final RouteFactory? onGenerateRoute = valueOf('onGenerateRoute', widget.onGenerateRoute);
    final RouteFactory? onUnknownRoute = valueOf('onUnknownRoute', widget.onUnknownRoute);
    final List<NavigatorObserver> navigatorObservers = valueOf('navigatorObservers', widget.navigatorObservers);
    
    // If routes or navigation is configured, wrap in CupertinoTabView
    if (routes != null || navigatorKeys != null) {
      return CupertinoTabView(
        builder: (context) => content,
        navigatorKey: navigatorKeys?[index],
        defaultTitle: defaultTitle,
        routes: routes ?? const <String, WidgetBuilder>{},
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers,
        restorationScopeId: restorationScopeIds?[index],
      );
    }
    
    // Otherwise return content directly
    return content;
  }
  
  /// Builds individual tab views for CupertinoTabScaffold
  Widget _buildTabView(BuildContext context, int index) {
    final List<Widget>? tabViews = valueOf('tabViews', widget.tabViews);
    final List<String?>? restorationScopeIds = valueOf('restorationScopeIds', widget.restorationScopeIds);
    final Map<String, WidgetBuilder>? routes = valueOf('routes', widget.routes);
    final List<GlobalKey<NavigatorState>?>? navigatorKeys = valueOf('navigatorKeys', widget.navigatorKeys);
    final String? defaultTitle = valueOf('defaultTitle', widget.defaultTitle);
    final RouteFactory? onGenerateRoute = valueOf('onGenerateRoute', widget.onGenerateRoute);
    final RouteFactory? onUnknownRoute = valueOf('onUnknownRoute', widget.onUnknownRoute);
    final List<NavigatorObserver> navigatorObservers = valueOf('navigatorObservers', widget.navigatorObservers);

    if (tabViews != null && index < tabViews.length) {
      return CupertinoTabView(
        builder: (context) => tabViews[index],
        navigatorKey: navigatorKeys?[index],
        defaultTitle: defaultTitle,
        routes: routes ?? const <String, WidgetBuilder>{},
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers,
        restorationScopeId: restorationScopeIds?[index],
      );
    }

    // Fallback widget
    return Container(
      child: Center(
        child: Text('Tab $index'),
      ),
    );
  }
  
  /// Wraps the entire tab scaffold with iOS 26 Liquid Glass effects
  /// Provides environmental awareness and dynamic transparency
  /// Enhanced iOS 26 Liquid Glass Dynamic Material wrapper for tab scaffolds
  Widget _wrapScaffoldWithLiquidGlass(BuildContext context, Widget scaffold) {
    return Container(
      decoration: BoxDecoration(
        // Enhanced iOS 26 Liquid Glass Dynamic Material gradient with improved physics
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Primary glass reflection layer with enhanced luminosity
            Colors.white.withOpacity(0.15),
            // Secondary transparency layer with improved color temperature
            Colors.white.withOpacity(0.08),
            // Refraction transition zone with realistic light behavior
            Colors.white.withOpacity(0.03),
            // Content hierarchy separator with depth perception
            Colors.transparent,
            // Depth shadow for glass thickness with enhanced falloff
            Colors.black.withOpacity(0.03),
            // Edge definition with subtle rim lighting
            Colors.white.withOpacity(0.05),
          ],
          stops: const [0.0, 0.2, 0.4, 0.6, 0.85, 1.0],
        ),
        // Enhanced multi-layer shadows for realistic glass depth and lighting
        boxShadow: [
          // Primary glass depth shadow - enhanced with realistic physics
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: -3,
            offset: const Offset(-8, -8),
          ),
          // Secondary glass reflection - improved light bounce
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: -1,
            offset: const Offset(8, 8),
          ),
          // Ambient glass glow with color temperature
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
          // Additional rim lighting for glass edge definition
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: -2,
            offset: const Offset(0, -2),
          ),
        ],
        // Enhanced border radius with subtle curvature for realistic glass edges
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          // Enhanced blur with dynamic intensity for iOS 26 effects
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              // Additional refractive layer for optical complexity
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.transparent,
                  Colors.white.withOpacity(0.04),
                  Colors.blue.withOpacity(0.02),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
              // Enhanced border for glass edge definition
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: scaffold,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final BaseTabBar tabBar = valueOf('tabBar', widget.tabBar);
    final List<Widget> tabViews = valueOf('tabViews', widget.tabViews);
    return Scaffold(
      key: valueOf('key', widget.key),
      body: tabViews[_currentIndex],
      bottomNavigationBar: tabBar.copyWith(
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          final ValueChanged<int> onTap = tabBar.valueOf('onTap', tabBar.onTap);
          if (onTap != null) {
            onTap(index);
          }
        },
        currentIndex: _currentIndex,
      ),
      floatingActionButton: valueOf('floatingActionButton', widget.floatingActionButton),
      floatingActionButtonLocation: valueOf('floatingActionButtonLocation', widget.floatingActionButtonLocation),
      floatingActionButtonAnimator: valueOf('floatingActionButtonAnimator', widget.floatingActionButtonAnimator),
      persistentFooterButtons: valueOf('persistentFooterButtons', widget.persistentFooterButtons),
      drawer: valueOf('drawer', widget.drawer),
      onDrawerChanged: valueOf('onDrawerChanged', widget.onDrawerChanged),
      endDrawer: valueOf('endDrawer', widget.endDrawer),
      onEndDrawerChanged: valueOf('onEndDrawerChanged', widget.onEndDrawerChanged),
      bottomSheet: valueOf('bottomSheet', widget.bottomSheet),
      backgroundColor: valueOf('backgroundColor', widget.backgroundColor),
      resizeToAvoidBottomInset: valueOf('resizeToAvoidBottomInset', widget.resizeToAvoidBottomInset),
      primary: valueOf('primary', widget.primary),
      drawerDragStartBehavior: valueOf('drawerDragStartBehavior', widget.drawerDragStartBehavior),
      extendBody: valueOf('extendBody', widget.extendBody),
      extendBodyBehindAppBar: valueOf('extendBodyBehindAppBar', widget.extendBodyBehindAppBar),
      drawerScrimColor: valueOf('drawerScrimColor', widget.drawerScrimColor),
      drawerEdgeDragWidth: valueOf('drawerEdgeDragWidth', widget.drawerEdgeDragWidth),
      drawerEnableOpenDragGesture: valueOf('drawerEnableOpenDragGesture', widget.drawerEnableOpenDragGesture),
      endDrawerEnableOpenDragGesture: valueOf('endDrawerEnableOpenDragGesture', widget.endDrawerEnableOpenDragGesture),
      restorationId: valueOf('restorationId', widget.restorationId),
    );
  }
}
