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
    this.largeTitle = false,
    this.tint,
    this.segmentedControlLabels,
    this.segmentedControlSelectedIndex,
    this.onSegmentedControlValueChanged,
    this.segmentedControlHeight,
    this.segmentedControlTint,
    this.segmentedControlLabelSize,
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

  /// *** native iOS properties end ***

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
    final Widget? _title = valueOf('middle', middle) ?? valueOf('title', title);
    // If no backgroundColor, use CupertinoTheme's barBackgroundColor, or use the default
    final Color? _backgroundColor = valueOf('backgroundColor', backgroundColor);
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
    final Widget? _titleWidget =
        valueOf('middle', middle) ?? valueOf('title', title);

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
    final bool _transparent = valueOf('transparent', transparent);
    final bool _largeTitle = valueOf('largeTitle', largeTitle);

    final BaseThemeData baseTheme = BaseTheme.of(context);
    final double effectiveHeight = _height ??
        baseTheme.valueOf('appBarHeight', baseTheme.appBarHeight) ??
        44.0;

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
        baseParam: BaseParam(nativeIOS: true),
      ).build(context),
    );

    return PreferredSize(
      preferredSize: Size.fromHeight(effectiveHeight),
      child: navBar,
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
    // If actions is null and trailing is not null, set trailing = [ trailing ];
    List<Widget>? _actions = valueOf('actions', actions);
    final Widget? _trailing = valueOf('trailing', trailing);
    if (_actions == null && _trailing != null) {
      _actions = <Widget>[_trailing];
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
    final Color? _backgroundColor =
        valueOf('backgroundColor', backgroundColor) ??
            (theme.useMaterial3 ? colorScheme.surface : null);

    // Material 3 Semantic Shadow Color
    final Color? _shadowColor = valueOf('shadowColor', shadowColor) ??
        (theme.useMaterial3 ? colorScheme.shadow : null);

    // Material 3 Foreground Color from Color Scheme
    final Color? _foregroundColor =
        valueOf('foregroundColor', foregroundColor) ??
            (theme.useMaterial3 ? colorScheme.onSurface : null);

    // Material 3 Enhanced Elevation
    final double? _elevation =
        valueOf('elevation', elevation) ?? (theme.useMaterial3 ? 3.0 : 4.0);

    final double? _height = valueOf('height', height) ??
        baseTheme.valueOf('appBarHeight', baseTheme.appBarHeight);
    final bool centerTitle = this.centerTitle ??
        theme.appBarTheme.centerTitle ??
        theme.platform == TargetPlatform.iOS;

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
