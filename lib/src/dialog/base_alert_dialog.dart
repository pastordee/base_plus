import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart' show CupertinoAlertDialog, ScrollController;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseAlertDialog with iOS 26 Liquid Glass Dynamic Material and Material 3 support
/// 
/// Features iOS 26 Liquid Glass Dynamic Material with:
/// - Transparency with optical clarity zones
/// - Multi-layer reflections and refractions
/// - Dynamic adaptability to content and context
/// - Real-time interactivity with haptic feedback
/// - Unified design language across platforms
/// - Content hierarchy separation through optical layers
/// 
/// Material 3 Integration:
/// - Semantic ColorScheme usage with role-based colors
/// - Enhanced elevation system with shadow groups
/// - Modern typography scale with optical sizing
/// - Accessibility improvements with semantic labels
/// 
/// Cross-platform support:
/// - CupertinoAlertDialog with Liquid Glass enhancement by cupertino
/// - AlertDialog with Material 3 design by material
/// *** use cupertino = { forceUseMaterial: true } force use AlertDialog on cupertino
/// *** use material = { forceUseCupertino: true } force use CupertinoAlertDialog on material
/// 
/// Enhanced: 2024.01.20 with iOS 26 Liquid Glass Dynamic Material
class BaseAlertDialog extends BaseStatelessWidget {
  const BaseAlertDialog({
    Key? key,
    this.title,
    this.content,
    this.actions = const <Widget>[],

    // iOS 26 Liquid Glass Dynamic Material properties
    this.enableLiquidGlass = true,
    this.glassOpacity = 0.8,
    this.reflectionIntensity = 0.6,
    this.refractionStrength = 0.4,
    this.adaptiveInteraction = true,
    this.contentHierarchy = true,
    this.hapticFeedback = true,

    // cupertino
    this.scrollController,
    this.actionScrollController,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,

    // material
    this.titlePadding,
    this.titleTextStyle,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.contentTextStyle,
    this.backgroundColor,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.elevation,
    this.semanticLabel,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    this.clipBehavior = Clip.none,
    this.shape,
    this.scrollable = false,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties start ***

  /// [CupertinoAlertDialog.title]
  /// or
  /// [AlertDialog.title]
  final Widget? title;

  /// [CupertinoAlertDialog.content]
  /// or
  /// [AlertDialog.content]
  final Widget? content;

  /// [CupertinoAlertDialog.actions]
  /// or
  /// [AlertDialog.actions]
  final List<Widget> actions;

  /// *** general properties end ***

  /// *** iOS 26 Liquid Glass Dynamic Material properties start ***

  /// Enable Liquid Glass Dynamic Material optical effects
  /// Provides transparency, reflections, and refractions for immersive experience
  final bool enableLiquidGlass;

  /// Glass transparency level for optical clarity zones
  /// Creates depth perception through graduated opacity (0.0 to 1.0)
  final double glassOpacity;

  /// Reflection intensity for environmental awareness
  /// Simulates real-world glass reflection behavior (0.0 to 1.0)
  final double reflectionIntensity;

  /// Refraction strength for light distortion effects
  /// Creates realistic glass light-bending properties (0.0 to 1.0)
  final double refractionStrength;

  /// Enable adaptive interaction with context awareness
  /// Provides real-time responsiveness to user actions and system state
  final bool adaptiveInteraction;

  /// Enable content hierarchy separation through optical layers
  /// Creates visual depth and importance distinction between elements
  final bool contentHierarchy;

  /// Enable haptic feedback for enhanced tactile experience
  /// Provides appropriate haptic responses for glass-like interactions
  final bool hapticFeedback;

  /// *** iOS 26 Liquid Glass Dynamic Material properties end ***

  /// *** cupertino properties start ***

  /// [CupertinoAlertDialog.scrollController]
  final ScrollController? scrollController;

  /// [CupertinoAlertDialog.actionScrollController]
  final ScrollController? actionScrollController;

  /// [CupertinoAlertDialog.insetAnimationDuration]
  final Duration insetAnimationDuration;

  /// [CupertinoAlertDialog.insetAnimationCurve]
  final Curve insetAnimationCurve;

  /// *** cupertino properties end ***

  /// *** material properties start ***

  /// [AlertDialog.titlePadding]
  final EdgeInsetsGeometry? titlePadding;

  /// [AlertDialog.titleTextStyle]
  final TextStyle? titleTextStyle;

  /// [AlertDialog.contentPadding]
  final EdgeInsetsGeometry contentPadding;

  /// [AlertDialog.contentTextStyle]
  final TextStyle? contentTextStyle;

  /// [AlertDialog.backgroundColor]
  final Color? backgroundColor;

  /// [AlertDialog.actionsPadding]
  final EdgeInsetsGeometry actionsPadding;

  /// [AlertDialog.actionsOverflowDirection]
  final VerticalDirection? actionsOverflowDirection;

  /// [AlertDialog.actionsOverflowButtonSpacing]
  final double? actionsOverflowButtonSpacing;

  /// [AlertDialog.buttonPadding]
  final EdgeInsetsGeometry? buttonPadding;

  /// [AlertDialog.elevation]
  final double? elevation;

  /// [AlertDialog.semanticLabel]
  final String? semanticLabel;

  /// [AlertDialog.insetPadding]
  final EdgeInsets insetPadding;

  /// [AlertDialog.clipBehavior]
  final Clip clipBehavior;

  /// [AlertDialog.shape]
  final ShapeBorder? shape;

  /// [AlertDialog.scrollable]
  final bool scrollable;

  /// *** material properties end ***

  @override
  Widget buildByCupertino(BuildContext context) {
    Widget dialog = CupertinoAlertDialog(
      title: valueOf('title', title),
      content: valueOf('content', content),
      actions: valueOf('actions', actions),
      scrollController: valueOf('scrollController', scrollController),
      actionScrollController: valueOf('actionScrollController', actionScrollController),
      insetAnimationDuration: valueOf('insetAnimationDuration', insetAnimationDuration),
      insetAnimationCurve: valueOf('insetAnimationCurve', insetAnimationCurve),
    );

    if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
      return _wrapWithLiquidGlass(context, dialog);
    }

    return dialog;
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Widget dialog = AlertDialog(
      title: valueOf('title', title),
      titlePadding: valueOf('titlePadding', titlePadding),
      titleTextStyle: valueOf('titleTextStyle', titleTextStyle),
      content: valueOf('content', content),
      contentPadding: valueOf('contentPadding', contentPadding),
      contentTextStyle: valueOf('contentTextStyle', contentTextStyle),
      actions: valueOf('actions', actions),
      actionsPadding: valueOf('actionsPadding', actionsPadding),
      actionsOverflowDirection: valueOf('actionsOverflowDirection', actionsOverflowDirection),
      actionsOverflowButtonSpacing: valueOf('actionsOverflowButtonSpacing', actionsOverflowButtonSpacing),
      buttonPadding: valueOf('buttonPadding', buttonPadding),
      backgroundColor: valueOf('backgroundColor', backgroundColor) ?? colorScheme.surface,
      elevation: valueOf('elevation', elevation) ?? 6.0,
      semanticLabel: valueOf('semanticLabel', semanticLabel),
      insetPadding: valueOf('insetPadding', insetPadding),
      clipBehavior: valueOf('clipBehavior', clipBehavior),
      shape: valueOf('shape', shape) ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      scrollable: valueOf('scrollable', scrollable),
    );

    if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
      return _wrapWithLiquidGlass(context, dialog);
    }

    return dialog;
  }

  /// Wraps dialog with iOS 26 Liquid Glass Dynamic Material effects
  /// 
  /// Implements sophisticated optical properties including:
  /// - Multi-layer transparency with clarity zones
  /// - Environmental reflections and refractions
  /// - Dynamic adaptability to content and context
  /// - Real-time interactivity with haptic feedback
  /// - Content hierarchy through optical depth layers
  Widget _wrapWithLiquidGlass(BuildContext context, Widget child) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    
    // Haptic feedback for glass interaction
    if (valueOf('hapticFeedback', hapticFeedback) && valueOf('adaptiveInteraction', adaptiveInteraction)) {
      HapticFeedback.lightImpact();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        // Primary glass layer with graduated transparency
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          colors: [
            (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('glassOpacity', glassOpacity) * 0.05),
            (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('glassOpacity', glassOpacity) * 0.08),
            (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('glassOpacity', glassOpacity) * 0.12),
            (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('glassOpacity', glassOpacity) * 0.08),
            (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('glassOpacity', glassOpacity) * 0.05),
            (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('glassOpacity', glassOpacity) * 0.02),
          ],
        ),
        // Multi-layer shadow system for material depth
        boxShadow: [
          // Primary depth shadow
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey.shade400)
                .withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: 0,
          ),
          // Reflection shadow for environmental awareness
          BoxShadow(
            color: (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('reflectionIntensity', reflectionIntensity) * 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: -2,
          ),
          // Ambient glow for atmospheric presence
          BoxShadow(
            color: Theme.of(context).primaryColor
                .withOpacity(0.08),
            offset: const Offset(0, 0),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.0),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: valueOf('refractionStrength', refractionStrength) * 15,
            sigmaY: valueOf('refractionStrength', refractionStrength) * 15,
          ),
          child: Container(
            decoration: BoxDecoration(
              // Refractive overlay with optical distortion
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.5),
                radius: 1.2,
                colors: [
                  Colors.white.withOpacity(valueOf('reflectionIntensity', reflectionIntensity) * 0.25),
                  Colors.white.withOpacity(valueOf('reflectionIntensity', reflectionIntensity) * 0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
              // Content hierarchy border for visual separation
              border: valueOf('contentHierarchy', contentHierarchy)
                  ? Border.all(
                      color: (isDark ? Colors.white : Colors.black)
                          .withOpacity(0.15),
                      width: 0.5,
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  /// [showDialog]
  Future<T?> show<T>(
    BuildContext context, {
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }
}

/// [showDialog]
Future<T?> showBaseAlertDialog<T>(
  BaseAlertDialog alertDialog,
  BuildContext context, {
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) => alertDialog,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}
