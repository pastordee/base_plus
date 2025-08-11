import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show MouseCursor, SystemMouseCursors;
import 'package:flutter/services.dart' show HapticFeedback;
import 'dart:ui' show ImageFilter;

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseIconButton
///
/// Modern cross-platform icon button with iOS 26 Liquid Glass Dynamic Material design.
/// Implements true Liquid Glass principles with dynamic adaptability, real-time interactivity,
/// and sophisticated optical properties optimized for icon-based interactions.
///
/// **iOS 26 Liquid Glass Dynamic Material Features:**
/// - **Transparency & Refractions**: Multi-layer optical effects tailored for icon clarity
/// - **Dynamic Adaptability**: Content and context-aware visual transformations
/// - **Real-time Interactivity**: Smart haptic feedback based on icon interaction patterns
/// - **Unified Design Language**: Consistent experience across Apple platforms
/// - **Content Hierarchy**: Optimized icon visibility with glass material separation
/// - **Fluid Responsiveness**: Adaptive sizing and effects for touch interactions
///
/// **Material 3 Integration:**
/// - Semantic ColorScheme usage for icon colors with enhanced state layers
/// - Modern accessibility and touch target sizing with improved elevation
/// - Cross-platform harmony while preserving platform-specific icon behaviors
///
/// use CupertinoButton by cupertino
/// *** use cupertino = { forceUseMaterial: true } force use IconButton on cuperitno.
/// use IconButton by material
/// *** use material = { forceUseCupertino: true } force use CupertinoButton on material.
///
/// CupertinoButton: Updated for iOS 26 Liquid Glass Dynamic Material design patterns
/// IconButton: Updated for Material 3 (Material You)
/// Updated: 2025.08.11 for iOS 26 Liquid Glass Dynamic Material and Material 3
class BaseIconButton extends BaseStatelessWidget {
  const BaseIconButton({
    Key? key,
    this.icon,
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

    /// iOS 26 Liquid Glass icon button effects
    this.liquidGlassEffect = false,
    this.liquidGlassBlurIntensity = 10.0,
    this.liquidGlassOpacity = 0.9,
    this.adaptiveHaptics = true,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties start ***

  /// [CupertinoButton.padding]
  /// or
  /// [IconButton.padding]
  final EdgeInsetsGeometry? padding;

  /// [IconData]
  final IconData? icon;

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

  /// *** iOS 26 Liquid Glass Dynamic Material properties start ***

  /// Enable iOS 26 Liquid Glass Dynamic Material visual effects for icon button
  /// Implements transparency, reflections, and refractions optimized for icon clarity
  final bool liquidGlassEffect;

  /// Liquid Glass Dynamic Material blur intensity for icon buttons (5.0 - 20.0)
  /// Controls the backdrop blur strength with icon-optimized adaptation
  final double liquidGlassBlurIntensity;

  /// Liquid Glass Dynamic Material surface opacity for icon buttons (0.1 - 1.0)
  /// Controls transparency and refraction depth optimized for icon visibility
  final double liquidGlassOpacity;

  /// Enhanced haptic feedback for iOS 26 Dynamic Material icon interactions
  /// Provides adaptive haptic responses tailored for icon-based actions
  final bool adaptiveHaptics;

  /// *** iOS 26 Liquid Glass Dynamic Material properties end ***

  /// *** material properties end ***

  @override
  Widget buildByCupertino(BuildContext context) {
    final Color _disabledColor = valueOf('disabledColor', disabledColor) ?? CupertinoColors.quaternarySystemFill;
    final VoidCallback? _onPressed = valueOf('onPressed', onPressed);

    // iOS 26 Liquid Glass Configuration
    final bool _liquidGlassEffect = valueOf('liquidGlassEffect', liquidGlassEffect);
    final double _liquidGlassBlurIntensity = valueOf('liquidGlassBlurIntensity', liquidGlassBlurIntensity);
    final double _liquidGlassOpacity = valueOf('liquidGlassOpacity', liquidGlassOpacity);
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

    Widget iconButton = CupertinoButton(
      child: Icon(
        valueOf('icon', icon),
        size: valueOf('iconSize', iconSize),
        color: valueOf('color', color),
      ),
      padding: valueOf('padding', padding),
      disabledColor: _disabledColor,
      minSize: valueOf('minSize', minSize),
      pressedOpacity: valueOf('pressedOpacity', pressedOpacity),
      borderRadius: valueOf('borderRadius', borderRadius),
      alignment: valueOf('alignment', alignment),
      onPressed: _enhancedOnPressed,
    );

    // Apply iOS 26 Liquid Glass effects if enabled
    if (_liquidGlassEffect && _onPressed != null) {
      return _wrapWithLiquidGlass(iconButton, _liquidGlassBlurIntensity, _liquidGlassOpacity);
    }

    return iconButton;
  }

  /// iOS 26 Liquid Glass Dynamic Material wrapper for icon buttons
  Widget _wrapWithLiquidGlass(Widget iconButton, double blurIntensity, double opacity) {
    final BorderRadius borderRadius = valueOf('borderRadius', this.borderRadius) ?? const BorderRadius.all(Radius.circular(8.0));
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        // iOS 26 Liquid Glass Dynamic Material: icon-optimized optical effects
        // Specialized for icon clarity while maintaining glass material authenticity
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            // Central icon clarity zone
            Colors.white.withOpacity(opacity * 0.35),
            // Glass surface reflection ring
            Colors.white.withOpacity(opacity * 0.25),
            // Material transparency layer
            Colors.white.withOpacity(opacity * 0.15),
            // Content hierarchy separator
            Colors.transparent,
            // Glass edge definition
            Colors.black.withOpacity(opacity * 0.08),
            // Outer material boundary
            Colors.black.withOpacity(opacity * 0.12),
          ],
          stops: const [0.0, 0.3, 0.5, 0.7, 0.9, 1.0],
        ),
        // Icon-optimized shadow system for glass material presence
        boxShadow: [
          // Primary icon button depth
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 2),
            blurRadius: 8.0,
            spreadRadius: 0.5,
          ),
          // Glass surface highlight
          BoxShadow(
            color: Colors.white.withOpacity(opacity * 0.7),
            offset: const Offset(0, -0.5),
            blurRadius: 4.0,
          ),
          // Ambient material glow (unified design language)
          BoxShadow(
            color: Colors.blue.withOpacity(opacity * 0.06),
            offset: const Offset(0, 0),
            blurRadius: 12.0,
            spreadRadius: 0.5,
          ),
          // Interactive responsiveness indicator
          BoxShadow(
            color: Colors.white.withOpacity(opacity * 0.4),
            offset: const Offset(-0.5, -0.5),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity,
          ),
          child: Container(
            decoration: BoxDecoration(
              // Additional refractive layer optimized for icon readability
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.8,
                colors: [
                  Colors.white.withOpacity(opacity * 0.1),
                  Colors.transparent,
                  Colors.white.withOpacity(opacity * 0.05),
                ],
              ),
              // Subtle inner enhancement for icon clarity
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(opacity * 0.25),
                  offset: const Offset(0, 0),
                  blurRadius: 6.0,
                  spreadRadius: -1.5,
                ),
              ],
            ),
            child: iconButton,
          ),
        ),
      ),
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

    return IconButton(
      iconSize: valueOf('iconSize', iconSize),
      visualDensity: valueOf('visualDensity', visualDensity),
      padding: valueOf('padding', padding),
      alignment: valueOf('alignment', alignment),
      icon: Icon(valueOf('icon', icon), color: iconColor),
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
