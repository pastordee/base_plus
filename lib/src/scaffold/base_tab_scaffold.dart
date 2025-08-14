import 'dart:ui';
import 'package:flutter/cupertino.dart' hide CupertinoTabScaffold, CupertinoTabBar, CupertinoTabController;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../base_param.dart';
import '../base_stateful_widget.dart';
import '../flutter/cupertino/bottom_tab_bar.dart';
import '../flutter/cupertino/tab_scaffold.dart';
import '../mode/base_mode.dart';
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
    if (isMaterialMode) {
      final BaseTabBar tabBar = valueOf('tabBar', widget.tabBar);
      _currentIndex = tabBar.valueOf(
        'currentIndex',
        tabBar.currentIndex,
      );
    }
  }

  @override
  Widget buildByCupertino(BuildContext context) {
    final BaseTabBar? tabBar = valueOf('tabBar', widget.tabBar);
    final Color? backgroundColor = valueOf('backgroundColor', widget.backgroundColor);
    final bool? resizeToAvoidBottomInset = valueOf('resizeToAvoidBottomInset', widget.resizeToAvoidBottomInset);
    final String? restorationId = valueOf('restorationId', widget.restorationId);
    
    // Get the raw CupertinoTabBar without Liquid Glass wrapping
    final CupertinoTabBar rawTabBar = tabBar?.buildCupertinoTabBar(context) ?? 
      CupertinoTabBar(items: [
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
  Widget _wrapScaffoldWithLiquidGlass(BuildContext context, Widget scaffold) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
            Colors.black.withOpacity(0.02),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(-5, -5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: -2,
            offset: const Offset(5, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: scaffold,
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
