import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show MouseCursor, SystemMouseCursors;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseIconButton
///
/// Modern cross-platform icon button with native SF Symbols support via CNIcon.
/// 
/// **Native SF Symbols Support:**
/// - Use `symbol` parameter for native SF Symbols on iOS (e.g., 'heart.fill', 'star')
/// - Automatic fallback to Material Icons on Android via `icon` or `fallbackIcon`
/// - True native rendering via CNIcon when symbol is provided
/// - CNIcon components include built-in iOS 26 Liquid Glass effects automatically
///
/// **iOS 26 Features (via CNIcon):**
/// - **Liquid Glass Design**: Built-in transparency, refractions, and depth
/// - **Native Rendering**: True iOS platform integration
/// - **Smart Haptic Feedback**: Adaptive haptic responses for icon interactions
/// - **Unified Design Language**: Consistent experience across Apple platforms
///
/// **Material 3 Integration:**
/// - Semantic ColorScheme usage for icon colors with enhanced state layers
/// - Modern accessibility and touch target sizing with improved elevation
/// - Cross-platform harmony while preserving platform-specific icon behaviors
///
/// use CupertinoButton with CNIcon (native SF Symbols with built-in liquid glass) or Icon by cupertino
/// *** use cupertino = { forceUseMaterial: true } force use IconButton on cuperitno.
/// use IconButton by material
/// *** use material = { forceUseCupertino: true } force use CupertinoButton on material.
///
/// Examples:
/// ```dart
/// // Native SF Symbol on iOS
/// BaseIconButton(
///   symbol: 'heart.fill',
///   color: Colors.red,
///   onPressed: () {},
/// )
///
/// // Cross-platform with fallback
/// BaseIconButton(
///   symbol: 'star.fill',
///   fallbackIcon: Icons.star,
///   color: Colors.yellow,
///   onPressed: () {},
/// )
///
/// // Standard Material Icon
/// BaseIconButton(
///   icon: Icons.settings,
///   onPressed: () {},
/// )
/// ```
///
/// CupertinoButton + CNIcon: Native SF Symbols with built-in Liquid Glass effects
/// IconButton: Updated for Material 3 (Material You)
/// Updated: 2025.10.25 for native CN components with built-in liquid glass
class BaseIconButton extends BaseStatelessWidget {
  const BaseIconButton({
    Key? key,
    this.icon,
    this.symbol,
    this.fallbackIcon,
    this.color,
    this.disabledColor,
    this.padding = const EdgeInsets.all(8.0),
    this.onPressed,
    this.minSize = kMinInteractiveDimensionCupertino,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.iconSize = 24.0,
    this.visualDensity,
    this.splashRadius,
    this.alignment = Alignment.center,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.focusNode,
    this.mouseCursor = SystemMouseCursors.click,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback = true,
    this.constraints,

    /// Enhanced haptic feedback for icon interactions
    /// CNIcon components automatically include liquid glass effects
    this.adaptiveHaptics = true,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties start ***

  /// [CupertinoButton.padding]
  /// or
  /// [IconButton.padding]
  final EdgeInsetsGeometry? padding;

  /// [IconData] - Standard Material/Cupertino icon
  /// Use either `icon` or `symbol`, not both
  final IconData? icon;

  /// SF Symbol name for native iOS icons (e.g., 'heart.fill', 'star', 'gearshape')
  /// When provided, uses CNIcon for true native rendering on iOS
  /// Use either `icon` or `symbol`, not both
  final String? symbol;

  /// Fallback Material icon for Android when using `symbol`
  /// If not provided and symbol is used, will use `icon` as fallback
  final IconData? fallbackIcon;

  /// [CupertinoButton.color]
  /// or
  /// [IconButton.color]
  final Color? color;

  /// [CupertinoButton.disabledColor]
  /// or
  /// [IconButton.disabledColor]
  final Color? disabledColor;

  /// [CupertinoButton.onPressed]
  /// or
  /// [IconButton.onPressed]
  final VoidCallback? onPressed;

  /// [CupertinoButton.alignment]
  /// or
  /// [IconButton.alignment]
  final AlignmentGeometry alignment;

  /// *** general properties end ***

  /// *** cupertino properties start ***

  /// [CupertinoButton.minSize]
  final double? minSize;

  /// [CupertinoButton.pressedOpacity]
  final double? pressedOpacity;

  /// [CupertinoButton.borderRadius]
  final BorderRadius? borderRadius;

  /// *** cupertino properties end ***

  /// *** material properties start ***

  /// [IconButton.iconSize]
  final double iconSize;

  /// [IconButton.visualDensity]
  final VisualDensity? visualDensity;

  /// [IconButton.splashRadius]
  final double? splashRadius;

  /// [IconButton.focusColor]
  final Color? focusColor;

  /// [IconButton.hoverColor]
  final Color? hoverColor;

  /// [IconButton.highlightColor]
  final Color? highlightColor;

  /// [IconButton.splashColor]
  final Color? splashColor;

  /// [IconButton.focusNode]
  final FocusNode? focusNode;

  /// [IconButton.mouseCursor]
  final MouseCursor mouseCursor;

  /// [IconButton.autofocus]
  final bool autofocus;

  /// [IconButton.tooltip]
  final String? tooltip;

  /// [IconButton.enableFeedback]
  final bool enableFeedback;

  /// [IconButton.constraints]
  final BoxConstraints? constraints;

  /// Enhanced haptic feedback for icon interactions
  /// Provides adaptive haptic responses tailored for icon-based actions
  /// Note: CNIcon components automatically include liquid glass effects
  final bool adaptiveHaptics;

  /// *** material properties end ***

  @override
  Widget buildByCupertino(BuildContext context) {
    final Color _disabledColor = valueOf('disabledColor', disabledColor) ?? CupertinoColors.quaternarySystemFill;
    final VoidCallback? _onPressed = valueOf('onPressed', onPressed);
    final bool _adaptiveHaptics = valueOf('adaptiveHaptics', adaptiveHaptics);

    // Enhanced onPressed with haptic feedback
    VoidCallback? _enhancedOnPressed;
    if (_onPressed != null) {
      _enhancedOnPressed = () {
        if (_adaptiveHaptics) {
          HapticFeedback.selectionClick(); // Lighter feedback for icon buttons
        }
        _onPressed();
      };
    }

    // Determine which icon to use
    Widget iconWidget;
    final String? _symbol = valueOf('symbol', symbol);
    final IconData? _icon = valueOf('icon', icon);
    final double _iconSize = valueOf('iconSize', iconSize);
    final Color? _color = valueOf('color', color);

    if (_symbol != null && _symbol.isNotEmpty) {
      // Use native SF Symbol via CNIcon (includes built-in liquid glass effects)
      iconWidget = CNIcon(
        symbol: CNSymbol(_symbol, size: _iconSize),
        size: _iconSize,
        color: _color,
      );
    } else if (_icon != null) {
      // Use standard Icon
      iconWidget = Icon(
        _icon,
        size: _iconSize,
        color: _color,
      );
    } else {
      // Fallback to empty icon
      iconWidget = Icon(
        CupertinoIcons.question_circle,
        size: _iconSize,
        color: _color,
      );
    }

    return CupertinoButton(
      child: iconWidget,
      padding: valueOf('padding', padding),
      disabledColor: _disabledColor,
      minSize: valueOf('minSize', minSize),
      pressedOpacity: valueOf('pressedOpacity', pressedOpacity),
      borderRadius: valueOf('borderRadius', borderRadius),
      alignment: valueOf('alignment', alignment),
      onPressed: _enhancedOnPressed,
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final VoidCallback? _onPressed = valueOf('onPressed', onPressed);
    final bool _adaptiveHaptics = valueOf('adaptiveHaptics', adaptiveHaptics);

    // Enhanced onPressed with haptic feedback
    VoidCallback? _enhancedOnPressed;
    if (_onPressed != null) {
      _enhancedOnPressed = () {
        if (_adaptiveHaptics) {
          HapticFeedback.selectionClick(); // Consistent with iOS
        }
        _onPressed();
      };
    }

    // Material 3 enhanced styling
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    
    // Enhanced icon color for Material 3
    Color? iconColor = valueOf('color', color);
    if (theme.useMaterial3 && iconColor == null) {
      iconColor = colorScheme.onSurface;
    }

    // Determine which icon to use (fallback logic for Material)
    IconData? iconData;
    final String? _symbol = valueOf('symbol', symbol);
    final IconData? _icon = valueOf('icon', icon);
    final IconData? _fallbackIcon = valueOf('fallbackIcon', fallbackIcon);

    if (_icon != null) {
      // Use provided icon
      iconData = _icon;
    } else if (_symbol != null && _fallbackIcon != null) {
      // Use fallback icon when symbol is provided on Android
      iconData = _fallbackIcon;
    } else if (_icon == null && _fallbackIcon == null) {
      // If symbol is provided but no fallback, use a default icon
      iconData = Icons.circle_outlined;
    }

    return IconButton(
      iconSize: valueOf('iconSize', iconSize),
      visualDensity: valueOf('visualDensity', visualDensity),
      padding: valueOf('padding', padding),
      alignment: valueOf('alignment', alignment),
      icon: Icon(iconData, color: iconColor),
      splashRadius: valueOf('splashRadius', splashRadius),
      color: iconColor,
      focusColor: valueOf('focusColor', focusColor) ?? (theme.useMaterial3 ? colorScheme.onSurface.withOpacity(0.12) : null),
      hoverColor: valueOf('hoverColor', hoverColor) ?? (theme.useMaterial3 ? colorScheme.onSurface.withOpacity(0.08) : null),
      highlightColor: valueOf('highlightColor', highlightColor) ?? (theme.useMaterial3 ? colorScheme.onSurface.withOpacity(0.12) : null),
      splashColor: valueOf('splashColor', splashColor) ?? (theme.useMaterial3 ? colorScheme.onSurface.withOpacity(0.12) : null),
      disabledColor: valueOf('disabledColor', disabledColor) ?? (theme.useMaterial3 ? colorScheme.onSurface.withOpacity(0.38) : null),
      onPressed: _enhancedOnPressed,
      mouseCursor: valueOf('mouseCursor', mouseCursor),
      focusNode: valueOf('focusNode', focusNode),
      autofocus: valueOf('autofocus', autofocus),
      tooltip: valueOf('tooltip', tooltip),
      enableFeedback: valueOf('enableFeedback', enableFeedback),
      constraints: valueOf('constraints', constraints),
    );
  }
}
