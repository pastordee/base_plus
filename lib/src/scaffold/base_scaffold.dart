import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';

import '../appbar/base_app_bar.dart';
import '../base_param.dart';
import '../base_stateless_widget.dart';
import '../theme/base_theme.dart';

/// BaseScaffold
/// use CupertinoPageScaffold by cupertino, tab's scaffold use CupertinoTabScaffold
/// *** use cupertino = { forceUseMaterial: true } force use Scaffold on cuperitno.
/// use Scaffold by material
/// *** use material = { forceUseCupertino: true } force use CupertinoPageScaffold/CupertinoTabScaffold on material.
///
/// CupertinoPageScaffold: 2021.03.12
/// Scaffold: 2021.04.03
/// modify 2021.06.25 by flutter 2.2.2
class BaseScaffold extends BaseStatelessWidget {
  const BaseScaffold({
    Key? key,
    this.appBar,
    this.navBar,
    this.backgroundColor,
    this.body,
    this.resizeToAvoidBottomInset = true,
    this.safeAreaTop = false,
    this.safeAreaBottom = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar,
    this.autoSafeArea = true,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.restorationId,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties start ***

  /// [CupertinoPageScaffold.navigationBar]
  /// or
  /// [Scaffold.appBar]
  /// If this properties is null, then [navBar] is use.
  ///
  /// If this parameter is null, then [navBar] will be used
  final BaseAppBar? appBar;

  /// [CupertinoPageScaffold.navigationBar]
  /// or
  /// [Scaffold.appBar]
  ///
  /// If this properties is null, then [appBar] is use.
  ///
  /// If this parameter is null, then [appBar] will be used
  final BaseAppBar? navBar;

  /// [CupertinoPageScaffold.backgroundColor]
  /// or
  /// [Scaffold.backgroundColor]
  final Color? backgroundColor;

  /// [CupertinoPageScaffold.body]
  /// or
  /// [Scaffold.body]
  final Widget? body;

  /// [CupertinoPageScaffold.resizeToAvoidBottomInset]
  /// or
  /// [Scaffold.resizeToAvoidBottomInset]
  final bool resizeToAvoidBottomInset;

  /// *** general properties end ***

  /// *** cupertino properties start ***

  /// [SafeArea.top], default is false
  /// Equivalent to SafeArea's top, defaults to false
  /// When the navigation bar background is transparent, set to true to make the page start below the navigation bar
  final bool safeAreaTop;

  /// [SafeArea.bottom], default is false
  /// Equivalent to SafeArea's bottom, defaults to false
  /// Set to true to prevent the page from being covered by the iPhone's Home Indicator at the bottom
  final bool safeAreaBottom;

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

  /// [Scaffold.bottomNavigationBar]
  final Widget? bottomNavigationBar;

  /// [Scaffold.bottomSheet]
  final Widget? bottomSheet;

  /// [Scaffold.primary]
  final bool primary;

  /// [Scaffold.drawerDragStartBehavior]
  final DragStartBehavior drawerDragStartBehavior;

  /// [Scaffold.extendBody]
  final bool extendBody;

  /// [Scaffold.extendBodyBehindAppBar]
  /// When null, automatically determined based on app bar transparency
  final bool? extendBodyBehindAppBar;

  /// Automatically wrap body with SafeArea when app bar is transparent
  /// Default is true for intelligent spacing management
  final bool autoSafeArea;

  /// [Scaffold.drawerScrimColor]
  final Color? drawerScrimColor;

  /// [Scaffold.drawerEdgeDragWidth]
  final double? drawerEdgeDragWidth;

  /// [Scaffold.drawerEnableOpenDragGesture]
  final bool drawerEnableOpenDragGesture;

  /// [Scaffold.endDrawerEnableOpenDragGesture]
  final bool endDrawerEnableOpenDragGesture;

  /// [Scaffold.restorationId]
  final String? restorationId;

  /// *** material properties end ***

  /// Determines if the app bar has transparency or custom colors that require special handling
  bool _shouldExtendBodyBehindAppBar(BaseAppBar? appBar) {
    if (appBar == null) {
      return false;
    }
    
    // Check if backgroundColor is transparent or has opacity < 1.0
    final Color? bgColor = appBar.backgroundColor;
    if (bgColor != null) {
      // If background color is explicitly transparent or has opacity
      if (bgColor == Colors.transparent || bgColor.alpha < 255) {
        return true;
      }
    }
    
    // Check for iOS 26 Liquid Glass properties
    if (appBar.liquidGlassBlurIntensity != null || 
        appBar.liquidGlassGradientOpacity != null ||
        appBar.liquidGlassDynamicBlur == true) {
      return true;
    }
    
    // Default to false for solid app bars
    return false;
  }

  /// Intelligently wraps body with SafeArea when needed
  Widget _wrapBodyWithSafeArea(Widget body, BaseAppBar? appBar) {
    if (!autoSafeArea) {
      return body;
    }
    
    final bool needsSafeArea = _shouldExtendBodyBehindAppBar(appBar) || safeAreaTop || safeAreaBottom;
    
    if (!needsSafeArea) {
      return body;
    }
    
    return SafeArea(
      top: _shouldExtendBodyBehindAppBar(appBar) || safeAreaTop,
      bottom: safeAreaBottom,
      child: body,
    );
  }

  @override
  Widget buildByCupertino(BuildContext context) {
    // Check if drawers are present - if so, automatically use Material design
    // This ensures Scaffold.of(context).openDrawer() works without manual forceUseMaterial
    final Widget? drawer = valueOf('drawer', this.drawer);
    final Widget? endDrawer = valueOf('endDrawer', this.endDrawer);
    
    if (drawer != null || endDrawer != null) {
      // Automatically use Material design when drawers are present
      // This provides the proper Scaffold context for drawer functionality
      return buildByMaterial(context);
    }
    
    final Widget body = valueOf('body', this.body);
    assert(body != null, 'body can\'t be null');
    final Color? backgroundColor = valueOf('backgroundColor', this.backgroundColor);
    final BaseAppBar? appBar = valueOf('appBar', this.appBar) ?? valueOf('navBar', navBar);
    final double? appBarHeight = BaseTheme.of(context).valueOf('appBarHeight', BaseTheme.of(context).appBarHeight);
    Widget? navigationBar;
    if (appBarHeight != null && appBar != null) {
      navigationBar = appBar.build(context);
    } else {
      navigationBar = appBar;
    }
    
    // Intelligent body wrapping with SafeArea
    final Widget _child = _wrapBodyWithSafeArea(body, appBar);
    
    return CupertinoPageScaffold(
      navigationBar: navigationBar != null ? navigationBar as ObstructingPreferredSizeWidget : null,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: valueOf('resizeToAvoidBottomInset', resizeToAvoidBottomInset),
      child: _child,
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    BaseAppBar? appBar = valueOf('appBar', this.appBar) ?? valueOf('navBar', navBar);
    final double? appBarHeight = BaseTheme.of(context).valueOf('appBarHeight', BaseTheme.of(context).appBarHeight);
    
    // Check if drawers are present and automatically inject menu icon if needed
    final Widget? drawer = valueOf('drawer', this.drawer);
    final Widget? endDrawer = valueOf('endDrawer', this.endDrawer);
    
    // Auto-inject drawer menu icon when drawer is present and no leading widget specified
    if (appBar != null && drawer != null && appBar.leading == null && appBar.automaticallyImplyLeading) {
      // Create a new BaseAppBar instance with drawer menu icon
      appBar = BaseAppBar(
        key: appBar.key,
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
        trailing: appBar.trailing,
        automaticallyImplyLeading: appBar.automaticallyImplyLeading,
        automaticallyImplyMiddle: appBar.automaticallyImplyMiddle,
        backgroundColor: appBar.backgroundColor,
        brightness: appBar.brightness,
        previousPageTitle: appBar.previousPageTitle,
        middle: appBar.middle,
        border: appBar.border,
        padding: appBar.padding,
        transitionBetweenRoutes: appBar.transitionBetweenRoutes,
        heroTag: appBar.heroTag,
        backdropFilter: appBar.backdropFilter,
        height: appBar.height,
        title: appBar.title,
        actions: appBar.actions,
        flexibleSpace: appBar.flexibleSpace,
        bottom: appBar.bottom,
        elevation: appBar.elevation,
        iconTheme: appBar.iconTheme,
        shadowColor: appBar.shadowColor,
        shape: appBar.shape,
        actionsIconTheme: appBar.actionsIconTheme,
        textTheme: appBar.textTheme,
        primary: appBar.primary,
        centerTitle: appBar.centerTitle,
        titleSpacing: appBar.titleSpacing,
        excludeHeaderSemantics: appBar.excludeHeaderSemantics,
        toolbarOpacity: appBar.toolbarOpacity,
        bottomOpacity: appBar.bottomOpacity,
        foregroundColor: appBar.foregroundColor,
        leadingWidth: appBar.leadingWidth,
        backwardsCompatibility: appBar.backwardsCompatibility,
        toolbarTextStyle: appBar.toolbarTextStyle,
        titleTextStyle: appBar.titleTextStyle,
        systemOverlayStyle: appBar.systemOverlayStyle,
        liquidGlassBlurIntensity: appBar.liquidGlassBlurIntensity,
        liquidGlassGradientOpacity: appBar.liquidGlassGradientOpacity,
        liquidGlassDynamicBlur: appBar.liquidGlassDynamicBlur,
        baseParam: appBar.baseParam,
      );
    }
    
    Widget? _appBar;
    if (appBarHeight != null && appBar != null) {
      _appBar = appBar.build(context);
    } else {
      _appBar = appBar;
    }
    
    // Determine if body should extend behind app bar
    final bool shouldExtendBehindAppBar = extendBodyBehindAppBar ?? _shouldExtendBodyBehindAppBar(appBar);
    
    // Intelligent body wrapping with SafeArea
    final Widget? bodyWidget = valueOf('body', body);
    final Widget? wrappedBody = bodyWidget != null ? _wrapBodyWithSafeArea(bodyWidget, appBar) : null;
    
    // Get theme-aware background color for Material mode
    Color? effectiveBackgroundColor = valueOf('backgroundColor', backgroundColor);
    if (effectiveBackgroundColor == null) {
      // Use theme's scaffold background color when no explicit color is provided
      effectiveBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    }
    
    return Scaffold(
      appBar: _appBar != null ? _appBar as PreferredSizeWidget : null,
      body: wrappedBody,
      floatingActionButton: valueOf('floatingActionButton', floatingActionButton),
      floatingActionButtonLocation: valueOf('floatingActionButtonLocation', floatingActionButtonLocation),
      floatingActionButtonAnimator: valueOf('floatingActionButtonAnimator', floatingActionButtonAnimator),
      persistentFooterButtons: valueOf('persistentFooterButtons', persistentFooterButtons),
      drawer: valueOf('drawer', drawer),
      onDrawerChanged: valueOf('onDrawerChanged', onDrawerChanged),
      endDrawer: valueOf('endDrawer', endDrawer),
      onEndDrawerChanged: valueOf('onEndDrawerChanged', onEndDrawerChanged),
      bottomNavigationBar: valueOf('bottomNavigationBar', bottomNavigationBar),
      bottomSheet: valueOf('bottomSheet', bottomSheet),
      backgroundColor: effectiveBackgroundColor,
      resizeToAvoidBottomInset: valueOf('resizeToAvoidBottomInset', resizeToAvoidBottomInset),
      primary: valueOf('primary', primary),
      drawerDragStartBehavior: valueOf('drawerDragStartBehavior', drawerDragStartBehavior),
      extendBody: valueOf('extendBody', extendBody),
      extendBodyBehindAppBar: shouldExtendBehindAppBar,
      drawerScrimColor: valueOf('drawerScrimColor', drawerScrimColor),
      drawerEdgeDragWidth: valueOf('drawerEdgeDragWidth', drawerEdgeDragWidth),
      drawerEnableOpenDragGesture: valueOf('drawerEnableOpenDragGesture', drawerEnableOpenDragGesture),
      endDrawerEnableOpenDragGesture: valueOf('endDrawerEnableOpenDragGesture', endDrawerEnableOpenDragGesture),
      restorationId: valueOf('restorationId', restorationId),
    );
  }
}
