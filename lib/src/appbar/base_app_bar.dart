import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/cupertino.dart'
    hide CupertinoNavigationBar, CupertinoNavigationBarBackButton;
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter/widgets.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';
import '../flutter/cupertino/nav_bar.dart';
import '../flutter/material/app_bar.dart';
import '../mode/base_mode.dart';
import '../navigation_bar/base_navigation_bar.dart';
import '../theme/base_theme.dart';
import '../theme/base_theme_data.dart';
import 'base_large_title.dart';

/// BaseAppBar
///
/// Modern cross-platform app bar with native iOS support.
///
/// *** You need to call the build method manually, otherwise [BaseThemeData.appBarHeight] won't work.
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
class BaseAppBar extends BaseStatelessWidget
    implements ObstructingPreferredSizeWidget {
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
    this.titleAlignment,
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
    this.leadingActions,
    this.trailingActions,
    this.transparent = false,
    this.glass = true,
    this.largeTitle = false,
    this.largeTitleController,
    this.tint,
    this.segmentedControlLabels,
    this.segmentedControlSelectedIndex,
    this.onSegmentedControlValueChanged,
    this.segmentedControlHeight,
    this.segmentedControlTint,
    this.segmentedControlLabelSize,
    this.segmentedControlSelectedColor,
    this.segmentedControlLabelColor,
    this.segmentedControlSelectedLabelColor,
    this.tabController,
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
  /// when the (title/middle = null && bottom != null)
  /// the bottom will replace title.
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
  ///   1.build BaseScaffold before build BaseAppBar
  ///   2.build BaseAppBar before build BaseScaffold
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
  /// To achieve full transparency, set this to false
  final bool? backdropFilter;

  /// *** cupertino properties ened ***

  /// *** material properties start ***

  /// [AppBar.title]
  ///
  /// If this property is null, then [middle] is used
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
  final bool? centerTitle;

  /// [AppBar.titleSpacing]
  final double? titleSpacing;

  /// Alignment of a **custom widget** title/middle on the native iOS bar.
  ///
  /// Only applies when the title/middle is a non-[Text] widget (which the native
  /// `CNNavigationBar` can't render, so base_plus overlays it). Defaults to
  /// [Alignment.centerLeft] (matches a chat-header / Android layout). Set to
  /// [Alignment.center] for a centered title; when centered, the leading/trailing
  /// insets are balanced so the widget stays visually centered in the bar.
  ///
  /// Has no effect on plain [Text] titles (rendered natively) or on Material.
  final Alignment? titleAlignment;

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

  /// Frosted "glass" app bar (cross-platform, single [BaseAppBar] API).
  ///
  /// When true:
  /// - **Android (material):** the [AppBar] is transparent (elevation 0) and
  ///   backed by a [BackdropFilter] blur with a translucent fill.
  /// - **iOS (cupertino / native):** forces a transparent background so the
  ///   nav bar's backdrop blur shows — the native glass look.
  ///
  /// The content behind the bar must be able to scroll under it — pair with
  /// `BaseScaffold(extendBodyBehindAppBar: true)` (auto-enabled when the bar's
  /// background is translucent).
  ///
  /// Blur amount / tint come from [BaseThemeData.appBarGlassBlur] /
  /// [BaseThemeData.appBarGlassColor] (sensible defaults otherwise).
  final bool glass;

  /// Whether to use large title style (native iOS mode)
  /// When true, displays a large title in the navigation bar
  final bool largeTitle;

  /// Cross-fades this bar's [title]/[middle] with a [BaseLargeTitle] in the
  /// scroll body, iOS-style: the large title in the body fades out as the
  /// compact title here fades in.
  ///
  /// Hand the *same* [BaseLargeTitleController] to the body's [BaseLargeTitle]
  /// and to the scroll view's `controller`:
  ///
  /// ```dart
  /// BaseAppBar(
  ///   glass: true,
  ///   title: Text(event.title),
  ///   largeTitleController: _handoff,
  /// )
  /// ```
  ///
  /// Unlike [largeTitle] — which asks the *native* iOS nav bar for its own
  /// large-title treatment — this works identically on iOS and Android, because
  /// both titles are Flutter widgets. Note the title is wrapped in an [Opacity],
  /// so on native iOS it is painted as an overlay rather than by the native
  /// `UILabel`; [titleAlignment] then defaults to [Alignment.center] instead of
  /// [Alignment.centerLeft], matching the iOS compact-title convention.
  ///
  /// Pairs with `BaseScaffold(extendBodyBehindAppBar: true)` and [glass].
  final BaseLargeTitleController? largeTitleController;

  /// Wraps a title/middle widget in the hand-off fade when
  /// [largeTitleController] is set. Returns [child] untouched otherwise, so
  /// bars that don't opt in keep their existing (native) title rendering.
  Widget? _applyLargeTitleHandoff(Widget? child) {
    final BaseLargeTitleController? controller =
        valueOf('largeTitleController', largeTitleController);
    if (controller == null || child == null) {
      return child;
    }
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: controller.appBarOpacity,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Tint color for the navigation bar (native iOS mode)
  /// Used for text and icons in the navigation bar
  final Color? tint;

  /// Labels for the segmented control in native iOS navigation bar
  /// Use this when baseParam.nativeIOS is true
  /// Example: ['Notifications', 'Buddy Requests']
  final List<String>? segmentedControlLabels;

  /// Currently selected index in the segmented control
  /// Use this when baseParam.nativeIOS is true
  final int? segmentedControlSelectedIndex;

  /// Callback when segmented control value changes
  /// Use this when baseParam.nativeIOS is true
  /// Provides the newly selected index
  final ValueChanged<int>? onSegmentedControlValueChanged;

  /// Height of the segmented control in the navigation bar
  /// Use this when baseParam.nativeIOS is true
  final double? segmentedControlHeight;

  /// Tint color for the segmented control
  /// Use this when baseParam.nativeIOS is true
  final Color? segmentedControlTint;

  /// Label size for the segmented control text
  /// Use this when baseParam.nativeIOS is true
  /// Controls the font size of segment labels
  final double? segmentedControlLabelSize;

  /// Background color of the *selected* segment (the sliding "thumb"/bubble).
  ///
  /// - **Android (Material):** sets the `thumbColor` of the sliding control.
  /// - **iOS (native):** sets `selectedSegmentTintColor`.
  ///
  /// If null, falls back to [segmentedControlTint] then the platform default
  /// (which is why a white bubble on a white surface could make the selected
  /// label vanish — set this to give the selected tab a distinct background).
  final Color? segmentedControlSelectedColor;

  /// Text color for *unselected* segment labels.
  /// If null, uses the platform default label color.
  final Color? segmentedControlLabelColor;

  /// Text color for the *selected* segment label.
  /// If null, falls back to [segmentedControlLabelColor] then the platform
  /// default. Set this so the selected label stays readable against
  /// [segmentedControlSelectedColor].
  final Color? segmentedControlSelectedLabelColor;

  /// Optional [TabController] for the segmented control (Material/Android).
  ///
  /// When provided, the Android segmented control (rendered from
  /// [segmentedControlLabels] as the title) stays in sync with this controller:
  /// its selection follows body swipes, and tapping a segment drives
  /// `animateTo`. This replaces having to also pass a separate `TabController`-
  /// backed tab bar as the title. iOS continues to use
  /// [segmentedControlSelectedIndex] / [onSegmentedControlValueChanged].
  final TabController? tabController;

  /// *** native iOS properties end ***

  /// Auto-enable native iOS rendering on Apple platforms when the caller hasn't
  /// provided a [baseParam] — so screens no longer need to pass
  /// `BaseParam(nativeIOS: Platform.isIOS || Platform.isMacOS)` themselves.
  /// An explicitly-provided [baseParam] is always respected as-is.
  @override
  Widget build(BuildContext context) {
    if (baseParam == null) {
      final bool _apple = defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS;
      if (_apple) {
        return commonBuild(context, BaseParam(nativeIOS: true));
      }
    }
    return commonBuild(context, baseParam);
  }

  @override
  Widget buildByCupertino(BuildContext context) {
    final Widget? _leading = valueOf('leading', leading);
    // If trailing is null and actions is not null, with length > 1, set trailing = actions[0];
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
    final Widget? _title = _applyLargeTitleHandoff(
      valueOf('middle', middle) ?? valueOf('title', title),
    );
    // `glass` → transparent background so the nav bar's backdrop blur shows.
    final bool _glass = valueOf('glass', glass);
    // If no backgroundColor, use CupertinoTheme's barBackgroundColor, or use the default
    final Color? _backgroundColor = _glass
        ? const Color(0x00000000)
        : valueOf('backgroundColor', backgroundColor);
    final double _toolbarOpacity = valueOf('toolbarOpacity', toolbarOpacity);

    // Enhanced backdrop filter logic
    bool _backdropFilter = valueOf('backdropFilter', backdropFilter) ??
        baseTheme.valueOf(
          'appBarBackdropFilter',
          baseTheme.appBarBackdropFilter,
        ) ??
        true;
    // No blur when background color is opaque
    if (_backgroundColor?.alpha == 0xFF) {
      _backdropFilter = false;
    }

    CupertinoNavigationBar cupertinoNavigationBar;
    final double? _height = valueOf('height', height) ??
        baseTheme.valueOf('appBarHeight', baseTheme.appBarHeight);
    final bool? _transitionBetweenRoutes =
        valueOf('transitionBetweenRoutes', transitionBetweenRoutes) ??
            baseTheme.appBarTransitionBetweenRoutes;
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
        backdropFilter: _backdropFilter,
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
        backdropFilter: _backdropFilter,
        navBarPersistentHeight: _height,
        bottom: valueOf('bottom', bottom),
        bottomOpacity: valueOf('bottomOpacity', bottomOpacity),
        toolbarOpacity: _toolbarOpacity,
      );
    }

    return cupertinoNavigationBar;
  }

  @override
  Widget buildByCupertinoNative(BuildContext context) {
    // Native iOS implementation using BaseNavigationBar which handles CNNavigationBar internally
    // Liquid Glass effects are not applicable here as CNNavigationBar handles its own native rendering
    // A hand-off title is wrapped in an Opacity, so it is no longer a plain
    // `Text` — it falls through to the custom-title overlay path below, which
    // is what lets the fade actually render over the native bar.
    final Widget? _titleWidget = _applyLargeTitleHandoff(
      valueOf('middle', middle) ?? valueOf('title', title),
    );

    // Extract title text if it's a Text widget
    String? _title;
    if (_titleWidget is Text) {
      _title = _titleWidget.data ?? _titleWidget.textSpan?.toPlainText();
    }

    // Use the dedicated leadingActions and trailingActions properties
    final List<BaseNavigationBarAction>? _leadingActions =
        valueOf('leadingActions', leadingActions);
    final List<BaseNavigationBarAction>? _trailingActions =
        valueOf('trailingActions', trailingActions);

    final Color? _tint = valueOf('tint', tint);
    final double? _height = valueOf('height', height);
    // `glass` implies a transparent (blurred) native nav bar on iOS.
    final bool _transparent =
        valueOf('transparent', transparent) || valueOf('glass', glass);
    final bool _largeTitle = valueOf('largeTitle', largeTitle);

    final BaseThemeData baseTheme = BaseTheme.of(context);
    final double effectiveHeight = _height ??
        baseTheme.valueOf('appBarHeight', baseTheme.appBarHeight) ??
        44.0;

    // The native CNNavigationBar renders its title as a native UILabel, so only
    // a plain `Text` title survives (extracted to `_title` above). When the
    // caller passes any other widget as the title/middle (e.g. a chat header
    // with an avatar + name), it would silently vanish on iOS. Detect that case
    // so we can overlay the Flutter widget on top of the native bar below.
    final List<String>? _segLabels =
        valueOf('segmentedControlLabels', segmentedControlLabels);
    final bool _hasCustomTitleWidget = _titleWidget != null &&
        _titleWidget is! Text &&
        (_segLabels == null || _segLabels.isEmpty);

    // BaseNavigationBar.build() returns CNNavigationBar which doesn't implement PreferredSizeWidget
    // Wrap it in PreferredSize to make it compatible with ObstructingPreferredSizeWidget
    final Widget navBar = SafeArea(
      child: BaseNavigationBar(
        key: valueOf(
            'key', key), // Pass through the key for proper rebuild behavior
        leading: _leadingActions,
        title: _title,
        trailing: _trailingActions,
        tint: _tint,
        transparent: _transparent,
        largeTitle: _largeTitle,
        height: _height,
        segmentedControlLabels:
            valueOf('segmentedControlLabels', segmentedControlLabels),
        segmentedControlSelectedIndex: valueOf(
            'segmentedControlSelectedIndex', segmentedControlSelectedIndex),
        onSegmentedControlValueChanged: valueOf(
            'onSegmentedControlValueChanged', onSegmentedControlValueChanged),
        segmentedControlHeight:
            valueOf('segmentedControlHeight', segmentedControlHeight),
        segmentedControlTint:
            valueOf('segmentedControlTint', segmentedControlTint),
        segmentedControlLabelSize:
            valueOf('segmentedControlLabelSize', segmentedControlLabelSize),
        segmentedControlSelectedColor: valueOf(
            'segmentedControlSelectedColor', segmentedControlSelectedColor),
        segmentedControlLabelColor: valueOf(
            'segmentedControlLabelColor', segmentedControlLabelColor),
        segmentedControlSelectedLabelColor: valueOf(
            'segmentedControlSelectedLabelColor',
            segmentedControlSelectedLabelColor),
        baseParam: BaseParam(nativeIOS: true),
      ).build(context),
    );

    // Overlay the custom Flutter title widget on top of the native bar. The
    // native bar still supplies the background/blur, the leading (back button),
    // and any trailing actions; we just paint the widget the native title can't
    // render into the middle. Flutter widgets draw above platform views, so this
    // stays tappable.
    Widget child = navBar;
    if (_hasCustomTitleWidget) {
      // A hand-off title is the screen's *compact* title, which iOS centers —
      // so default to centre there rather than to the chat-header start-align.
      final Alignment _align = valueOf('titleAlignment', titleAlignment) ??
          (valueOf('largeTitleController', largeTitleController) != null
              ? Alignment.center
              : Alignment.centerLeft);

      // Reserve horizontal room for the native leading/trailing so the overlay
      // doesn't sit under the back button or trailing actions. iOS bar buttons
      // are ~44pt wide.
      double _startInset =
          (_leadingActions != null && _leadingActions.isNotEmpty) ? 44.0 : 8.0;
      double _endInset = ((_trailingActions?.length ?? 0) * 44.0) + 8.0;

      // For a horizontally-centered title, balance the insets to the larger side
      // so the widget stays centered in the bar rather than being pushed off by
      // an asymmetric leading/trailing.
      if (_align.x == 0.0) {
        final double _max = _startInset > _endInset ? _startInset : _endInset;
        _startInset = _max;
        _endInset = _max;
      }

      child = Stack(
        children: <Widget>[
          navBar,
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: _startInset,
                  end: _endInset,
                ),
                child: Align(
                  alignment: _align,
                  child: _titleWidget,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return PreferredSize(
      preferredSize: Size.fromHeight(effectiveHeight),
      child: child,
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final Widget? _title = _applyLargeTitleHandoff(
      valueOf('title', title) ?? valueOf('middle', middle),
    );
    Widget? _leading = valueOf('leading', leading);
    // Reuse leadingActions as the Material leading when no explicit `leading`
    // was given, so callers configure the bar's buttons ONCE for both platforms
    // (leadingActions on iOS, converted to a Material widget here on Android).
    if (_leading == null) {
      final List<BaseNavigationBarAction>? _leadingActions =
          valueOf('leadingActions', leadingActions);
      if (_leadingActions != null && _leadingActions.isNotEmpty) {
        final List<Widget> _lw = _leadingActions
            .map((BaseNavigationBarAction a) => a.toMaterialWidget(context))
            .toList();
        _leading = _lw.length == 1
            ? _lw.first
            : Row(mainAxisSize: MainAxisSize.min, children: _lw);
      }
    }
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
    // If actions is null and trailing is not null, set trailing = [ trailing ];
    List<Widget>? _actions = valueOf('actions', actions);
    final Widget? _trailing = valueOf('trailing', trailing);
    if (_actions == null && _trailing != null) {
      _actions = <Widget>[_trailing];
    }
    // Reuse trailingActions as the Material actions when none were given.
    if (_actions == null) {
      final List<BaseNavigationBarAction>? _trailingActions =
          valueOf('trailingActions', trailingActions);
      if (_trailingActions != null && _trailingActions.isNotEmpty) {
        _actions = _trailingActions
            .map((BaseNavigationBarAction a) => a.toMaterialWidget(context))
            .toList();
      }
    }

    final BaseThemeData baseTheme = BaseTheme.of(context);
    final ThemeData theme =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? (baseTheme.materialTheme ?? Theme.of(context))
            : (baseTheme.materialDarkTheme ??
                Theme.of(context).copyWith(
                  brightness: Brightness.dark,
                ));

    // Material 3 Color Scheme Integration
    final ColorScheme colorScheme = theme.colorScheme;

    // Frosted "glass" mode: transparent bar + BackdropFilter blur, matching the
    // iOS glass look through the single BaseAppBar API.
    final bool _glass = valueOf('glass', glass);

    final Color? _backgroundColor = _glass
        ? Colors.transparent
        : (valueOf('backgroundColor', backgroundColor) ??
            (theme.useMaterial3 ? colorScheme.surface : null));

    // Material 3 Semantic Shadow Color
    final Color? _shadowColor = valueOf('shadowColor', shadowColor) ??
        (theme.useMaterial3 ? colorScheme.shadow : null);

    // Material 3 Foreground Color from Color Scheme
    final Color? _foregroundColor =
        valueOf('foregroundColor', foregroundColor) ??
            (theme.useMaterial3 ? colorScheme.onSurface : null);

    // Material 3 Enhanced Elevation (no shadow/elevation for glass)
    final double? _elevation = _glass
        ? 0.0
        : (valueOf('elevation', elevation) ?? (theme.useMaterial3 ? 3.0 : 4.0));

    final double? _height = valueOf('height', height) ??
        baseTheme.valueOf('appBarHeight', baseTheme.appBarHeight);
    final bool centerTitle = this.centerTitle ??
        theme.appBarTheme.centerTitle ??
        theme.platform == TargetPlatform.iOS;

    // Glass flexibleSpace: a full-bleed BackdropFilter blur with a translucent
    // tint, drawn behind the bar's title/actions. Only injected when the caller
    // didn't supply their own flexibleSpace.
    Widget? _flexibleSpace = valueOf('flexibleSpace', flexibleSpace);
    if (_glass && _flexibleSpace == null) { 
      final double _blur =
          baseTheme.valueOf('appBarGlassBlur', baseTheme.appBarGlassBlur) ??
              18.0;
      final Color _tint =
          baseTheme.valueOf('appBarGlassColor', baseTheme.appBarGlassColor) ??
              colorScheme.surface.withValues(alpha: 0.4);
      _flexibleSpace = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
          child: Container(color: _tint),
        ),
      );
    }

    // Reuse the segmentedControl* config as the Material title when no explicit
    // title/middle was given — so callers configure the tab switcher ONCE for
    // both platforms (native segmented control on iOS, a segmented control here
    // on Android) instead of also passing a separate title tab bar.
    Widget? _materialTitle = _title;
    if (_materialTitle == null) {
      final List<String>? _segLabels =
          valueOf('segmentedControlLabels', segmentedControlLabels);
      if (_segLabels != null && _segLabels.isNotEmpty) {
        _materialTitle =
            _buildMaterialSegmentedControl(context, colorScheme, _segLabels);
      }
    }

    return AppBar(
      leading: _leading,
      automaticallyImplyLeading: valueOf(
        'automaticallyImplyLeading',
        automaticallyImplyLeading,
      ),
      title: _materialTitle,
      actions: _actions,
      flexibleSpace: _flexibleSpace,
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
      excludeHeaderSemantics:
          valueOf('excludeHeaderSemantics', excludeHeaderSemantics),
      titleSpacing: valueOf('titleSpacing', titleSpacing),
      toolbarOpacity: valueOf('toolbarOpacity', toolbarOpacity),
      bottomOpacity: valueOf('bottomOpacity', bottomOpacity),
      toolbarHeight: _height,
      toolbarTextStyle: valueOf('toolbarTextStyle', toolbarTextStyle),
      titleTextStyle: valueOf('titleTextStyle', titleTextStyle),
      systemOverlayStyle: valueOf('systemOverlayStyle', systemOverlayStyle),
    );
  }

  /// Material rendering of the `segmentedControl*` config (used as the title on
  /// Android so callers don't also pass a separate tab bar). A sliding segmented
  /// control keeps it visually consistent with the native iOS segmented control.
  Widget _buildMaterialSegmentedControl(
    BuildContext context,
    ColorScheme colorScheme,
    List<String> labels,
  ) {
    final double? h =
        valueOf('segmentedControlHeight', segmentedControlHeight);
    final double labelSize =
        valueOf('segmentedControlLabelSize', segmentedControlLabelSize) ?? 13.0;
    final Color? bg = valueOf('segmentedControlTint', segmentedControlTint);
    // Selected-segment ("thumb") background, and per-state label colors.
    final Color thumb =
        valueOf('segmentedControlSelectedColor', segmentedControlSelectedColor) ??
            colorScheme.surface;
    final Color? labelColor =
        valueOf('segmentedControlLabelColor', segmentedControlLabelColor);
    final Color? selectedLabelColor = valueOf(
          'segmentedControlSelectedLabelColor',
          segmentedControlSelectedLabelColor,
        ) ??
        labelColor;
    final ValueChanged<int>? onChanged = valueOf(
      'onSegmentedControlValueChanged',
      onSegmentedControlValueChanged,
    );
    final TabController? _tabController =
        valueOf('tabController', tabController);

    // CupertinoSlidingSegmentedControl renders the same child regardless of
    // selection, so per-state text color has to be applied by rebuilding the
    // children against the current selection.
    Map<int, Widget> buildChildren(int selected) => <int, Widget>{
          for (int i = 0; i < labels.length; i++)
            i: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: labelSize,
                  fontWeight: FontWeight.w500,
                  color: i == selected ? selectedLabelColor : labelColor,
                ),
              ),
            ),
        };

    Widget buildControl(int selected) {
      final int clamped = selected.clamp(0, labels.length - 1);
      final Widget control = CupertinoSlidingSegmentedControl<int>(
        groupValue: clamped,
        backgroundColor: bg ?? CupertinoColors.tertiarySystemFill,
        thumbColor: thumb,
        children: buildChildren(clamped),
        onValueChanged: (int? v) {
          if (v == null) {
            return;
          }
          // Drive the TabController (if any) so the body switches, and still
          // fire the value-changed callback for callers that rely on it.
          _tabController?.animateTo(v);
          onChanged?.call(v);
        },
      );
      return h != null
          ? SizedBox(height: h, child: Center(child: control))
          : control;
    }

    // With a TabController, rebuild on swipe/animation so the selected segment
    // follows the body (this is what the old TabController-backed tab bar did).
    if (_tabController != null) {
      return AnimatedBuilder(
        animation: _tabController.animation ?? _tabController,
        builder: (BuildContext context, Widget? _) =>
            buildControl(_tabController.index),
      );
    }

    final int selected =
        valueOf('segmentedControlSelectedIndex', segmentedControlSelectedIndex) ??
            0;
    return buildControl(selected);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    if (isCupertinoMode) {
      final Color backgroundColor =
          CupertinoDynamicColor.maybeResolve(this.backgroundColor, context) ??
              CupertinoTheme.of(context).barBackgroundColor;
      return backgroundColor.alpha == 0xFF;
    }
    return true;
  }

  /// 1. use by { appBar: BaseAppBar() }, the [BaseThemeData.appBarHeight] won't work,
  ///   will use [preferredSize]'s height
  /// 2. use by { appBar: BaseAppBar().build(context) }, the [BaseThemeData.appBarHeight] will work,
  ///   will replace the [preferredSize]'s height
  /// 3. Pay attention, two ways's build order is different
  ///   1.build BaseScaffold before build BaseAppBar
  ///   2.build BaseScaffold after build BaseAppBar
  @override
  Size get preferredSize {
    double _height =
        height != null ? height! : (isCupertinoMode ? 44.0 : kToolbarHeight);
    final Widget? middle =
        valueOf('title', title) ?? valueOf('middle', this.middle);
    if (middle != null && bottom != null) {
      _height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(_height);
  }
}
