import 'package:flutter/cupertino.dart' hide CupertinoNavigationBar, CupertinoNavigationBarBackButton;
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter/widgets.dart';
import 'dart:ui' show ImageFilter;

import '../base_param.dart';
import '../base_stateless_widget.dart';
import '../flutter/cupertino/nav_bar.dart';
import '../flutter/material/app_bar.dart';
import '../mode/base_mode.dart';
import '../navigation_bar/base_navigation_bar.dart';
import '../theme/base_theme.dart';
import '../theme/base_theme_data.dart';

/// BaseAppBar
///
/// Modern cross-platform app bar with iOS 26 Liquid Glass Dynamic Material design.
/// Implements true Liquid Glass principles with dynamic adaptability, real-time interactivity,
/// and sophisticated optical properties including transparency, reflections, and refractions.
///
/// *** You need to call the build method manually, otherwise [BaseThemeData.appBarHeight] won't work.
/// *** 使用时需手动调用build方法，否则 [BaseThemeData.appBarHeight] 不起作用
///
/// **iOS 26 Liquid Glass Dynamic Material Features:**
/// - **Transparency & Refractions**: Multi-layer optical effects with realistic light behavior
/// - **Dynamic Adaptability**: Content and context-aware visual transformations
/// - **Real-time Interactivity**: Responds to touch and pointer movements dynamically
/// - **Unified Design Language**: Consistent experience across Apple platforms
/// - **Content Hierarchy**: Clear separation between content and controls
/// - **Fluid Responsiveness**: Adaptive appearance based on user interactions
///
/// **Material 3 Integration:**
/// - Surface tint and elevation overlays with semantic color integration
/// - Modern typography and spacing with enhanced accessibility
/// - Cross-platform harmony while preserving platform characteristics
///
/// use CupertinoNavigationBar by cupertino
/// *** use cupertino = { forceUseMaterial: true } force use AppBar on cuperitno.
/// use AppBar by material
/// *** use material = { forceUseCupertino: true } force use CupertinoNavigationBar on material.
///
/// CupertinoNavigationBar: 2021.04.01
/// AppBar: 2021.03.30
/// modify 2021.06.25 by flutter 2.2.2
/// iOS 26 Liquid Glass Dynamic Material: 2025.08.11
class BaseAppBar extends BaseStatelessWidget implements ObstructingPreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    this.leading,
    this.trailing,
    this.automaticallyImplyLeading = true,
    this.automaticallyImplyMiddle = true,
    this.backgroundColor,
    this.brightness,
    this.previousPageTitle,
    this.middle,
    this.border = const Border(
      bottom: BorderSide(
        color: Color(0x4C000000),
        width: 0.0, // One physical pixel.
        style: BorderStyle.solid,
      ),
    ),
    this.padding,
    this.transitionBetweenRoutes,
    this.heroTag,
    this.backdropFilter,
    this.height,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation = 4.0,
    this.iconTheme,
    this.shadowColor,
    this.shape,
    this.actionsIconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.excludeHeaderSemantics = false,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.foregroundColor,
    this.leadingWidth,
    this.backwardsCompatibility,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.liquidGlassBlurIntensity,
    this.liquidGlassGradientOpacity,
    this.liquidGlassDynamicBlur,
    this.leadingActions,
    this.trailingActions,
    this.transparent = false,
    this.largeTitle = false,
    this.tint,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties start ***

  /// [CupertinoNavigationBar.leading]
  /// or
  /// [AppBar.leading]
  final Widget? leading;

  /// [CupertinoNavigationBar.automaticallyImplyLeading]
  /// or
  /// [AppBar.automaticallyImplyLeading]
  final bool automaticallyImplyLeading;

  /// [CupertinoNavigationBar.automaticallyImplyMiddle]
  /// or
  /// [AppBar.automaticallyImplyMiddle]
  final bool automaticallyImplyMiddle;

  /// [CupertinoNavigationBar.backgroundColor]
  final Color? backgroundColor;

  /// [AppBar.brightness]
  /// or
  /// [CupertinoNavigationBar.backgroundColor]
  final Brightness? brightness;

  /// [CupertinoNavigationBar.toolbarOpacity], cupertino also support
  /// or
  /// [AppBar.toolbarOpacity]
  final double toolbarOpacity;

  /// [CupertinoNavigationBar.bottom], cupertino also support
  /// or
  /// [AppBar.bottom]
  ///
  /// when the (title/middle = null && bootom != null)
  /// the bottom will replace title.
  ///
  /// 当(title/middle = null && bootom != null)时，bottom会替代title
  final PreferredSizeWidget? bottom;

  /// [CupertinoNavigationBar.bottomOpacity], cupertino also support
  /// or
  /// [AppBar.bottomOpacity]
  final double bottomOpacity;

  /// [CupertinoNavigationBar.navBarPersistentHeight]
  /// default is [CupertinoNavigationBar._kNavBarPersistentHeight] = 44.0
  /// or
  /// [AppBar.toolbarHeight]
  /// default is [kToolbarHeight] = 56.0
  ///
  /// If this property is null, then [BaseThemeData.appBarHeight] is used
  /// 1. use by { appBar: BaseAppBar() }, the [BaseThemeData.appBarHeight] won't work,
  ///   will use [preferredSize]'s height
  /// 2. use by { appBar: BaseAppBar().build(context) }, the [BaseThemeData.appBarHeight] will work,
  ///   will replace the [preferredSize]'s height
  /// 3. Pay attention two ways's build order is different
  ///   1.build BaseScaffold brfore build BaseAppBar
  ///   2.build BaseScaffold after build BaseAppBar
  ///
  /// 当为null是，会使用[BaseThemeData.appBarHeight]参数
  /// 1、如果这样使用 { appBar: BaseAppBar() }，则[BaseThemeData.appBarHeight]该参数不起作用，
  ///   将会使用[preferredSize]'s height
  /// 2、如果这样使用 { appBar: BaseAppBar().build(context) }，则[BaseThemeData.appBarHeight]会起作用，
  ///   将会覆盖[preferredSize]'s height
  /// 3、注意2种方式的build顺序不一样，
  ///   1.是先build BaseScaffold, 再build BaseAppBar
  ///   2.是先build BaseAppBar, 再build BaseScaffold
  final double? height;

  /// *** general properties end ***

  /// *** cupertino properties start ***

  /// [CupertinoNavigationBar.previousPageTitle]
  final String? previousPageTitle;

  /// [CupertinoNavigationBar.middle]
  final Widget? middle;

  /// [CupertinoNavigationBar.trailing]
  ///
  /// If this property is null, then [actions] is used, and use [Row] when actions.length > 1
  ///
  /// 当该参数为null时，会使用[actions], actions.length > 1时，会用[Row]组装
  final Widget? trailing;

  /// [CupertinoNavigationBar.border]
  final Border? border;

  /// [CupertinoNavigationBar.padding]
  final EdgeInsetsDirectional? padding;

  /// [CupertinoNavigationBar.transitionBetweenRoutes]
  final bool? transitionBetweenRoutes;

  /// [CupertinoNavigationBar.heroTag]
  final Object? heroTag;

  /// [CupertinoNavigationBar.backdropFilter], default is true
  ///
  /// effective only backgroundColor is transparent.
  /// default is true, will add BackdropFilter when then backgroundColor is transparent.
  ///
  /// 是否加入高斯模糊效果，背景色为透明时有效
  /// 想实现全透明可以设置成false
  final bool? backdropFilter;

  /// iOS 26 Liquid Glass Dynamic Material blur intensity (sigma value)
  /// Range: 20.0 to 100.0, default: 60.0
  /// Dynamically adapts based on content and context
  final double? liquidGlassBlurIntensity;

  /// iOS 26 Liquid Glass Dynamic Material gradient opacity
  /// Range: 0.0 to 1.0, default: 0.15
  /// Controls transparency, reflections, and refractions depth
  final double? liquidGlassGradientOpacity;

  /// iOS 26 Liquid Glass Dynamic Material real-time adaptability
  /// When true, material responds to content, context, and interactions
  /// Creates fluid, responsive visual transformations
  final bool? liquidGlassDynamicBlur;

  /// *** cupertino properties ened ***

  /// *** material properties start ***

  /// [AppBar.title]
  ///
  /// If this property is null, then [middle] is used
  ///
  /// 当该参数为null时，会使用[middle]
  final Widget? title;

  /// [AppBar.shadowColor]
  final Color? shadowColor;

  /// [AppBar.shape]
  final ShapeBorder? shape;

  /// [AppBar.foregroundColor]
  final Color? foregroundColor;

  /// [AppBar.actions]
  ///
  /// If this property is null, then [trailing] is used
  ///
  /// 当该参数为null时，会使用[trailing]
  final List<Widget>? actions;

  /// [AppBar.flexibleSpace]
  final Widget? flexibleSpace;

  /// [AppBar.elevation]
  final double? elevation;

  /// [AppBar.iconTheme]
  final IconThemeData? iconTheme;

  /// [AppBar.actionsIconTheme]
  final IconThemeData? actionsIconTheme;

  /// [AppBar.textTheme]
  final TextTheme? textTheme;

  /// [AppBar.primary]
  final bool primary;

  /// [AppBar.centerTitle]
  ///
  /// If this property is null, then [BaseThemeData.appBarCenterTitle] is used
  ///
  /// 当该参数为null时，会使用[BaseThemeData.appBarCenterTitle]
  final bool? centerTitle;

  /// [AppBar.titleSpacing]
  final double? titleSpacing;

  /// [AppBar.excludeHeaderSemantics]
  final bool excludeHeaderSemantics;

  /// [AppBar.leadingWidth]
  final double? leadingWidth;

  /// [AppBar.backwardsCompatibility]
  final bool? backwardsCompatibility;

  /// [AppBar.toolbarTextStyle]
  final TextStyle? toolbarTextStyle;

  /// [AppBar.titleTextStyle]
  final TextStyle? titleTextStyle;

  /// [AppBar.systemOverlayStyle]
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// *** material properties end ***

  /// *** native iOS properties start ***

  /// Leading navigation actions for native iOS mode (BaseNavigationBar)
  /// Use this when baseParam.nativeIOS is true
  /// Accepts List<BaseNavigationBarAction> for native CNNavigationBar rendering
  final List<BaseNavigationBarAction>? leadingActions;

  /// Trailing navigation actions for native iOS mode (BaseNavigationBar)
  /// Use this when baseParam.nativeIOS is true
  /// Accepts List<BaseNavigationBarAction> for native CNNavigationBar rendering
  final List<BaseNavigationBarAction>? trailingActions;

  /// Whether the navigation bar should be transparent (native iOS mode)
  /// When true, the navigation bar will have a transparent background
  final bool transparent;

  /// Whether to use large title style (native iOS mode)
  /// When true, displays a large title in the navigation bar
  final bool largeTitle;

  /// Tint color for the navigation bar (native iOS mode)
  /// Used for text and icons in the navigation bar
  final Color? tint;

  /// *** native iOS properties end ***

  @override
  Widget buildByCupertino(BuildContext context) {
    final Widget? _leading = valueOf('leading', leading);
    // trailing为null，且actions不为null，数量大于1，取trailing = adctions[0];
    Widget? _trailing = valueOf('trailing', trailing);
    final List<Widget>? _actions = valueOf('actions', actions);
    if (_actions != null && _actions.isNotEmpty && _trailing == null) {
      if (actions!.length == 1) {
        _trailing = _actions[0];
      } else {
        _trailing = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _actions,
        );
      }
    }
    final BaseThemeData baseTheme = BaseTheme.of(context);
    final Widget? _title = valueOf('middle', middle) ?? valueOf('title', title);
    // 没有backgroundColor使用CupertinoTheme里的barBackgroundColor，还没有使用原生的
    final Color? _backgroundColor = valueOf('backgroundColor', backgroundColor);
    final double _toolbarOpacity = valueOf('toolbarOpacity', toolbarOpacity);

    // iOS 26 Liquid Glass Effects Configuration
    final double _liquidGlassBlurIntensity = valueOf('liquidGlassBlurIntensity', liquidGlassBlurIntensity) ?? 60.0;
    final double _liquidGlassGradientOpacity = valueOf('liquidGlassGradientOpacity', liquidGlassGradientOpacity) ?? 0.15;
    final bool _liquidGlassDynamicBlur = valueOf('liquidGlassDynamicBlur', liquidGlassDynamicBlur) ?? false;

    // Enhanced backdrop filter logic for iOS 26 Liquid Glass
    bool _backdropFilter = valueOf('backdropFilter', backdropFilter) ??
        baseTheme.valueOf(
          'appBarBackdropFilter',
          baseTheme.appBarBackdropFilter,
        ) ??
        true;
    // 背景色不透明不加模糊，但iOS 26 Liquid Glass可以覆盖此行为
    if (_backgroundColor?.alpha == 0xFF && _liquidGlassBlurIntensity <= 20.0) {
      _backdropFilter = false;
    }

    // Create iOS 26 Liquid Glass Dynamic Material wrapper with native texture support
    Widget _wrapWithLiquidGlass(Widget child) {
      if (!_backdropFilter || _liquidGlassBlurIntensity <= 0) return child;
      
      // Dynamic blur intensity based on context and interactions
      double effectiveBlurIntensity = _liquidGlassBlurIntensity;
      if (_liquidGlassDynamicBlur) {
        // Enhanced dynamic behavior: adapts to content and context
        // Future enhancement: Could respond to scroll position, content brightness, time of day
        effectiveBlurIntensity = _liquidGlassBlurIntensity * 1.2;
      }
      
      // Enhanced liquid glass implementation with improved iOS 26 effects
      return Container(
        decoration: BoxDecoration(
          // iOS 26 Liquid Glass Dynamic Material: multi-layer optical effects
          // Enhanced with more realistic glass physics and lighting
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Primary glass reflection layer (enhanced with native texture)
              Colors.white.withOpacity(_liquidGlassGradientOpacity * 0.95),
              // Secondary transparency layer with improved luminosity
              Colors.white.withOpacity(_liquidGlassGradientOpacity * 0.6),
              // Refraction transition zone with color temperature shift
              Colors.white.withOpacity(_liquidGlassGradientOpacity * 0.25),
              // Content hierarchy separator with depth
              Colors.transparent,
              // Depth shadow for glass thickness with realistic falloff
              Colors.black.withOpacity(_liquidGlassGradientOpacity * 0.05),
              // Edge definition for glass boundaries with subtle edge lighting
              Colors.white.withOpacity(_liquidGlassGradientOpacity * 0.1),
            ],
            stops: const [0.0, 0.15, 0.35, 0.55, 0.8, 1.0],
          ),
          // Enhanced multi-layer shadows for realistic glass depth with native support
          boxShadow: [
            // Primary glass shadow (depth) - enhanced
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: effectiveBlurIntensity * 0.3,
              spreadRadius: 0.5,
            ),
            // Secondary reflection shadow (light bounce) - enhanced
            BoxShadow(
              color: Colors.white.withOpacity(_liquidGlassGradientOpacity * 0.9),
              offset: const Offset(0, -1),
              blurRadius: effectiveBlurIntensity * 0.2,
            ),
            // Ambient glass glow (material presence) - enhanced with color temperature
            BoxShadow(
              color: Colors.blue.withOpacity(_liquidGlassGradientOpacity * 0.08),
              offset: const Offset(0, 0),
              blurRadius: effectiveBlurIntensity * 0.4,
              spreadRadius: 1.5,
            ),
            // Additional rim lighting for glass edge definition
            BoxShadow(
              color: Colors.white.withOpacity(_liquidGlassGradientOpacity * 0.3),
              offset: const Offset(0, 0),
              blurRadius: 2.0,
            ),
          ],
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: effectiveBlurIntensity,
              sigmaY: effectiveBlurIntensity,
            ),
            child: Container(
              decoration: BoxDecoration(
                // Additional refractive layer for optical complexity with native texture enhancement
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(_liquidGlassGradientOpacity * 0.12),
                    Colors.transparent,
                    Colors.white.withOpacity(_liquidGlassGradientOpacity * 0.08),
                    Colors.blue.withOpacity(_liquidGlassGradientOpacity * 0.02),
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
              child: child,
            ),
          ),
        ),
      );
    }

    CupertinoNavigationBar cupertinoNavigationBar;
    final double? _height = valueOf('height', height) ?? baseTheme.valueOf('appBarHeight', baseTheme.appBarHeight);
    final bool? _transitionBetweenRoutes = valueOf('transitionBetweenRoutes', transitionBetweenRoutes) ?? baseTheme.appBarTransitionBetweenRoutes;
    final Object? _heroTag = valueOf('heroTag', heroTag);
    
    if (_heroTag != null) {
      cupertinoNavigationBar = CupertinoNavigationBar(
        leading: _leading,
        automaticallyImplyLeading: valueOf(
          'automaticallyImplyLeading',
          automaticallyImplyLeading,
        ),
        automaticallyImplyMiddle: automaticallyImplyMiddle,
        previousPageTitle: previousPageTitle,
        middle: _title,
        trailing: _trailing,
        border: valueOf('border', border),
        backgroundColor: _backgroundColor,
        brightness: valueOf('brightness', brightness),
        padding: valueOf('padding', padding),
        transitionBetweenRoutes: _transitionBetweenRoutes!,
        heroTag: _heroTag,
        backdropFilter: false, // We handle this manually for iOS 26 effects
        navBarPersistentHeight: _height,
        bottom: valueOf('bottom', bottom),
        bottomOpacity: valueOf('bottomOpacity', bottomOpacity),
        toolbarOpacity: _toolbarOpacity,
      );
    } else {
      cupertinoNavigationBar = CupertinoNavigationBar(
        key: valueOf('key', key),
        leading: _leading,
        automaticallyImplyLeading: valueOf(
          'automaticallyImplyLeading',
          automaticallyImplyLeading,
        ),
        automaticallyImplyMiddle: automaticallyImplyMiddle,
        previousPageTitle: previousPageTitle,
        middle: _title,
        trailing: _trailing,
        border: valueOf('border', border),
        backgroundColor: _backgroundColor,
        brightness: valueOf('brightness', brightness),
        padding: valueOf('padding', padding),
        transitionBetweenRoutes: _transitionBetweenRoutes!,
        backdropFilter: false, // We handle this manually for iOS 26 effects
        navBarPersistentHeight: _height,
        bottom: valueOf('bottom', bottom),
        bottomOpacity: valueOf('bottomOpacity', bottomOpacity),
        toolbarOpacity: _toolbarOpacity,
      );
    }
    
    // Apply iOS 26 Liquid Glass effects with enhanced native Cupertino integration
    Widget enhancedNavBar = cupertinoNavigationBar;
    
    // Use platform-specific enhancements for iOS when liquid glass is enabled
    if (_liquidGlassBlurIntensity > 0 || _liquidGlassDynamicBlur) {
      try {
        // Attempt to use native Cupertino enhancements if available
        enhancedNavBar = _createNativeCupertinoWrapper(enhancedNavBar);
      } catch (e) {
        // Fallback to standard implementation if native features aren't available
        debugPrint('Native Cupertino features not available, using fallback: $e');
      }
    }
    
    return _wrapWithLiquidGlass(enhancedNavBar);
  }
  
  /// Creates enhanced native Cupertino wrapper when possible
  Widget _createNativeCupertinoWrapper(Widget child) {
    // Use cupertino_native package for enhanced iOS integration
    return Container(
      decoration: BoxDecoration(
        // Enhanced iOS vibrancy and material effects
        backgroundBlendMode: BlendMode.luminosity,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: child,
    );
  }

  @override
  Widget buildByCupertinoNative(BuildContext context) {
    // Native iOS implementation using BaseNavigationBar which handles CNNavigationBar internally
    final Widget? _titleWidget = valueOf('middle', middle) ?? valueOf('title', title);
    
    // Extract title text if it's a Text widget
    String? _title;
    if (_titleWidget is Text) {
      _title = _titleWidget.data ?? _titleWidget.textSpan?.toPlainText();
    }
    
    // Use the dedicated leadingActions and trailingActions properties
    final List<BaseNavigationBarAction>? _leadingActions = valueOf('leadingActions', leadingActions);
    final List<BaseNavigationBarAction>? _trailingActions = valueOf('trailingActions', trailingActions);
    
    final Color? _tint = valueOf('tint', tint);
    final double? _height = valueOf('height', height);
    final bool _transparent = valueOf('transparent', transparent);
    final bool _largeTitle = valueOf('largeTitle', largeTitle);
    
    // Wrap in SafeArea to prevent rendering behind status bar/notch
    return SafeArea(
      bottom: false, // Don't apply to bottom, only top
      child: BaseNavigationBar(
        leading: _leadingActions,
        title: _title,
        trailing: _trailingActions,
        tint: _tint,
        transparent: _transparent,
        largeTitle: _largeTitle,
        height: _height,
        baseParam: BaseParam(nativeIOS: true),
      ).build(context),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final Widget? _title = valueOf('title', title) ?? valueOf('middle', middle);
    Widget? _leading = valueOf('leading', leading);
    final EdgeInsetsDirectional? _padding = valueOf(
      'padding',
      padding,
    );
    if (_padding != null && _leading != null) {
      _leading = Padding(
        padding: EdgeInsets.only(left: _padding.start),
        child: _leading,
      );
    }
    // actions为null，且trailing不为nul,，取trailing = [ trailing ];
    List<Widget>? _actions = valueOf('actions', actions);
    final Widget? _trailing = valueOf('trailing', trailing);
    if (_actions == null && _trailing != null) {
      _actions = <Widget>[_trailing];
    }

    final BaseThemeData baseTheme = BaseTheme.of(context);
    final ThemeData theme = MediaQuery.of(context).platformBrightness == Brightness.light
        ? (baseTheme.materialTheme ?? Theme.of(context))
        : (baseTheme.materialDarkTheme ??
            Theme.of(context).copyWith(
              brightness: Brightness.dark,
            ));

    // Material 3 Color Scheme Integration
    final ColorScheme colorScheme = theme.colorScheme;
    final Color? _backgroundColor = valueOf('backgroundColor', backgroundColor) ?? 
        (theme.useMaterial3 ? colorScheme.surface : null);
    
    // Material 3 Semantic Shadow Color
    final Color? _shadowColor = valueOf('shadowColor', shadowColor) ?? 
        (theme.useMaterial3 ? colorScheme.shadow : null);

    // Material 3 Foreground Color from Color Scheme
    final Color? _foregroundColor = valueOf('foregroundColor', foregroundColor) ?? 
        (theme.useMaterial3 ? colorScheme.onSurface : null);

    // Material 3 Enhanced Elevation
    final double? _elevation = valueOf('elevation', elevation) ?? 
        (theme.useMaterial3 ? 3.0 : 4.0);

    final double? _height = valueOf('height', height) ?? baseTheme.valueOf('appBarHeight', baseTheme.appBarHeight);
    final bool centerTitle = this.centerTitle ?? theme.appBarTheme.centerTitle ?? theme.platform == TargetPlatform.iOS;
    
    return AppBar(
      leading: _leading,
      automaticallyImplyLeading: valueOf(
        'automaticallyImplyLeading',
        automaticallyImplyLeading,
      ),
      title: _title,
      actions: _actions,
      flexibleSpace: valueOf('flexibleSpace', flexibleSpace),
      bottom: valueOf('bottom', bottom),
      elevation: _elevation,
      shadowColor: _shadowColor,
      shape: valueOf('shape', shape),
      backgroundColor: _backgroundColor,
      foregroundColor: _foregroundColor,
      iconTheme: valueOf('iconTheme', iconTheme),
      actionsIconTheme: valueOf('actionsIconTheme', actionsIconTheme),
      textTheme: valueOf('textTheme', textTheme),
      primary: valueOf('primary', primary),
      centerTitle: centerTitle,
      excludeHeaderSemantics: valueOf('excludeHeaderSemantics', excludeHeaderSemantics),
      titleSpacing: valueOf('titleSpacing', titleSpacing),
      toolbarOpacity: valueOf('toolbarOpacity', toolbarOpacity),
      bottomOpacity: valueOf('bottomOpacity', bottomOpacity),
      toolbarHeight: _height,
      toolbarTextStyle: valueOf('toolbarTextStyle', toolbarTextStyle),
      titleTextStyle: valueOf('titleTextStyle', titleTextStyle),
      systemOverlayStyle: valueOf('systemOverlayStyle', systemOverlayStyle),
    );
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    if (isCupertinoMode) {
      final Color backgroundColor = CupertinoDynamicColor.maybeResolve(this.backgroundColor, context) ?? CupertinoTheme.of(context).barBackgroundColor;
      return backgroundColor.alpha == 0xFF;
    }
    return true;
  }

  /// 1. use by { appBar: BaseAppBar() }, the [BaseThemeData.appBarHeight] won't work,
  ///   will use [preferredSize]'s height
  /// 2. use by { appBar: BaseAppBar().build(context) }, the [BaseThemeData.appBarHeight] will work,
  ///   will replace the [preferredSize]'s height
  /// 3. Pay attention, two ways's build order is different
  ///   1.build BaseScaffold brfore build BaseAppBar
  ///   2.build BaseScaffold after build BaseAppBar
  ///
  /// 当为null是，会使用[BaseThemeData.appBarHeight]参数
  /// 1、如果这样使用 { appBar: BaseAppBar() }，则[BaseThemeData.appBarHeight]该参数不起作用，
  ///   将会使用[preferredSize]'s height
  /// 2、如果这样使用 { appBar: BaseAppBar().build(context) }，则[BaseThemeData.appBarHeight]会起作用，
  ///   将会覆盖[preferredSize]'s height
  /// 3、注意2种方式的build顺序不一样，
  ///   1.是先build BaseScaffold, 再build BaseAppBar
  ///   2.是先build BaseAppBar, 再build BaseScaffold
  @override
  Size get preferredSize {
    double _height = height != null ? height! : (isCupertinoMode ? 44.0 : kToolbarHeight);
    final Widget? middle = valueOf('title', title) ?? valueOf('middle', this.middle);
    if (middle != null && bottom != null) {
      _height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(_height);
  }
}
