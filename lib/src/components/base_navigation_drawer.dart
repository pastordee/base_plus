import 'package:flutter/material.dart';
import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseNavigationDrawer - Cross-platform drawer that automatically uses Material design
/// 
/// This component eliminates the need to specify `BaseParam(forceUseMaterial: true)`
/// when using a drawer on iOS or other platforms. It automatically forces Material
/// design for optimal drawer functionality across all platforms.
/// 
/// Features:
/// - Automatic Material design enforcement for consistent drawer behavior
/// - iOS 26 Liquid Glass compatibility with optimal visual integration  
/// - Cross-platform drawer functionality without manual parameter specification
/// - Seamless integration with BaseScaffold drawer property
/// 
/// Usage:
/// ```dart
/// BaseScaffold(
///   drawer: BaseNavigationDrawer(
///     child: YourDrawerContent(),
///   ),
/// )
/// ```
/// 
/// Enhanced: 2025.08.14 for Flutter Base v3.0.0+1
class BaseNavigationDrawer extends BaseStatelessWidget {
  const BaseNavigationDrawer({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.width,
    this.semanticLabel,
    this.clipBehavior = Clip.hardEdge,
    BaseParam? baseParam,
  }) : super(
         key: key, 
         baseParam: baseParam,
       );

  /// The primary content of the drawer.
  /// 
  /// Typically a [ListView] whose first child is a [DrawerHeader]
  /// that displays account information.
  final Widget child;

  /// The color to paint the drawer's background.
  /// 
  /// If this is null, then [DrawerThemeData.backgroundColor] is used. If that
  /// is also null, then the [ColorScheme.surface] color is used.
  final Color? backgroundColor;

  /// The color used to paint a drop shadow under the drawer's [Material],
  /// which reflects the drawer's [elevation].
  /// 
  /// If null and [ThemeData.useMaterial3] is true then [ColorScheme.shadow]
  /// will be used. If [ThemeData.useMaterial3] is false then the default is null.
  final Color? shadowColor;

  /// The color used as a surface tint overlay on the drawer's background color.
  /// 
  /// This is not recommended for use. [Material 3 spec](https://m3.material.io/styles/color/the-color-system/color-roles)
  /// introduced a set of tone-based surfaces and surface containers in its [ColorScheme],
  /// which provide more flexibility. The intention is to eventually remove surface tint color from
  /// the framework.
  final Color? surfaceTintColor;

  /// The z-coordinate at which to place this drawer relative to its parent.
  /// 
  /// This controls the size of the shadow below the drawer.
  final double? elevation;

  /// The shape of the drawer.
  /// 
  /// Defines the drawer's [Material.shape].
  final ShapeBorder? shape;

  /// The width of the drawer.
  /// 
  /// If this is null, then the default width is used, which is 304.0 logical pixels.
  final double? width;

  /// The semantic label of the dialog used by accessibility frameworks to
  /// announce screen transitions when the drawer is opened and closed.
  /// 
  /// If this label is not provided, it will default to
  /// [MaterialLocalizations.drawerLabel].
  final String? semanticLabel;

  /// {@macro flutter.material.Material.clipBehavior}
  /// 
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  @override
  Widget buildByCupertino(BuildContext context) {
    // On Cupertino, we force Material design for drawer functionality
    return buildByMaterial(context);
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    return Drawer(
      backgroundColor: valueOf('backgroundColor', backgroundColor),
      shadowColor: valueOf('shadowColor', shadowColor),
      surfaceTintColor: valueOf('surfaceTintColor', surfaceTintColor),
      elevation: valueOf('elevation', elevation),
      shape: valueOf('shape', shape),
      width: valueOf('width', width),
      semanticLabel: valueOf('semanticLabel', semanticLabel),
      clipBehavior: valueOf('clipBehavior', clipBehavior),
      child: valueOf('child', child),
    );
  }

  @override
  dynamic valueOf(String key, dynamic value) {
    // Create a BaseParam that forces Material design for drawer functionality
    final BaseParam effectiveParam = BaseParam(
      cupertino: baseParam?.cupertino,
      material: baseParam?.material,
      android: baseParam?.android,
      fuchsia: baseParam?.fuchsia,
      iOS: baseParam?.iOS,
      linux: baseParam?.linux,
      macOS: baseParam?.macOS,
      windows: baseParam?.windows,
      web: baseParam?.web,
      others: baseParam?.others,
      forceUseMaterial: true, // Always force Material design
      forceUseCupertino: false,
      disabledOnMaterial: baseParam?.disabledOnMaterial ?? false,
      disabledOnCupertino: baseParam?.disabledOnCupertino ?? false,
      disabledOnAndroid: baseParam?.disabledOnAndroid ?? false,
      disabledOnFuchsia: baseParam?.disabledOnFuchsia ?? false,
      disabledOnIOS: baseParam?.disabledOnIOS ?? false,
      disabledOnLinux: baseParam?.disabledOnLinux ?? false,
      disabledOnMacOS: baseParam?.disabledOnMacOS ?? false,
      disabledOnWindows: baseParam?.disabledOnWindows ?? false,
      disabledOnWeb: baseParam?.disabledOnWeb ?? false,
      disabledOnOthers: baseParam?.disabledOnOthers ?? false,
      withoutSplashOnCupertino: baseParam?.withoutSplashOnCupertino,
    );
    
    return valueOfBaseParam(effectiveParam, key, value);
  }
}
