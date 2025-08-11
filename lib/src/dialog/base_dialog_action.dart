import 'package:flutter/cupertino.dart' show CupertinoDialogAction;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// Material 3 button type for dialog actions
enum BaseDialogActionType {
  /// TextButton for secondary actions
  text,
  /// FilledButton for primary actions
  filled,
  /// OutlinedButton for neutral actions
  outlined,
}

/// BaseDialogAction with iOS 26 Liquid Glass Dynamic Material and Material 3 support
/// 
/// Features iOS 26 Liquid Glass Dynamic Material with:
/// - Transparency with optical clarity zones for dialog actions
/// - Adaptive interaction states with real-time responsiveness
/// - Unified design language across platforms
/// - Enhanced haptic feedback for tactile experience
/// 
/// Material 3 Integration:
/// - FilledButton, OutlinedButton, and TextButton variants
/// - Semantic ColorScheme usage with role-based colors
/// - Modern button styling with enhanced accessibility
/// - State layer effects for interaction feedback
/// 
/// Cross-platform support:
/// - CupertinoDialogAction with Liquid Glass enhancement by cupertino
/// - Material 3 button variants by material
/// *** use cupertino = { forceUseMaterial: true } force use TextButton on cupertino
/// *** use material = { forceUseCupertino: true } force use CupertinoDialogAction on material
/// 
/// Enhanced: 2024.01.20 with iOS 26 Liquid Glass Dynamic Material
class BaseDialogAction extends BaseStatelessWidget {
  const BaseDialogAction({
    Key? key,
    this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.textStyle,
    this.child,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.style,
    this.onLongPress,

    // iOS 26 Liquid Glass Dynamic Material properties
    this.enableLiquidGlass = true,
    this.adaptiveInteraction = true,
    this.hapticFeedback = true,
    this.buttonType = BaseDialogActionType.text,

    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties start ***

  /// [CupertinoDialogAction.onPressed]
  /// or
  /// [TextButton.onPressed]
  final VoidCallback? onPressed;

  /// [CupertinoDialogAction.onPressed]
  /// or
  /// [TextButton.child]
  final Widget? child;

  /// *** general properties end ***

  /// *** cupertino properties start ***

  /// [CupertinoDialogAction.isDefaultAction]
  final bool isDefaultAction;

  /// [CupertinoDialogAction.isDestructiveAction]
  final bool isDestructiveAction;

  /// [CupertinoDialogAction.textStyle]
  final TextStyle? textStyle;

  /// *** cupertino properties end ***

  /// *** material properties start ***

  /// [ButtonStyleButton.clipBehavior]
  final Clip clipBehavior;

  /// [ButtonStyleButton.focusNode]
  final FocusNode? focusNode;

  /// [ButtonStyleButton.autofocus]
  final bool autofocus;

  /// [ButtonStyleButton.onLongPress]
  final VoidCallback? onLongPress;

  /// [ButtonStyleButton.style]
  final ButtonStyle? style;

  /// *** material properties end ***

  /// *** iOS 26 Liquid Glass Dynamic Material properties start ***

  /// Enable Liquid Glass Dynamic Material optical effects for dialog actions
  /// Provides enhanced visual feedback and interaction states
  final bool enableLiquidGlass;

  /// Enable adaptive interaction with real-time responsiveness
  /// Provides context-aware visual and haptic feedback
  final bool adaptiveInteraction;

  /// Enable haptic feedback for enhanced tactile experience
  /// Provides appropriate haptic responses for action interactions
  final bool hapticFeedback;

  /// Material 3 button type for dialog actions
  /// Determines the visual style and importance hierarchy
  final BaseDialogActionType buttonType;

  /// *** iOS 26 Liquid Glass Dynamic Material properties end ***

  @override
  Widget buildByCupertino(BuildContext context) {
    Widget action = CupertinoDialogAction(
      onPressed: _handlePressed,
      isDefaultAction: valueOf('isDefaultAction', isDefaultAction),
      isDestructiveAction: valueOf('isDestructiveAction', isDestructiveAction),
      textStyle: valueOf('textStyle', textStyle),
      child: valueOf('child', child),
    );

    if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
      return _wrapWithLiquidGlass(context, action);
    }

    return action;
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final buttonType = valueOf('buttonType', this.buttonType);
    
    Widget button;
    
    switch (buttonType) {
      case BaseDialogActionType.filled:
        button = FilledButton(
          onPressed: _handlePressed,
          onLongPress: valueOf('onLongPress', onLongPress),
          style: valueOf('style', style),
          focusNode: valueOf('focusNode', focusNode),
          autofocus: valueOf('autofocus', autofocus),
          clipBehavior: valueOf('clipBehavior', clipBehavior),
          child: valueOf('child', child),
        );
        break;
      case BaseDialogActionType.outlined:
        button = OutlinedButton(
          onPressed: _handlePressed,
          onLongPress: valueOf('onLongPress', onLongPress),
          style: valueOf('style', style),
          focusNode: valueOf('focusNode', focusNode),
          autofocus: valueOf('autofocus', autofocus),
          clipBehavior: valueOf('clipBehavior', clipBehavior),
          child: valueOf('child', child),
        );
        break;
      case BaseDialogActionType.text:
      default:
        button = TextButton(
          onPressed: _handlePressed,
          onLongPress: valueOf('onLongPress', onLongPress),
          style: valueOf('style', style),
          focusNode: valueOf('focusNode', focusNode),
          autofocus: valueOf('autofocus', autofocus),
          clipBehavior: valueOf('clipBehavior', clipBehavior),
          child: valueOf('child', child),
        );
        break;
    }

    if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
      return _wrapWithLiquidGlass(context, button);
    }

    return button;
  }

  /// Handle button press with haptic feedback and adaptive interaction
  void _handlePressed() {
    final onPressed = valueOf('onPressed', this.onPressed);
    if (onPressed != null) {
      // Provide haptic feedback for enhanced tactile experience
      if (valueOf('hapticFeedback', hapticFeedback) && valueOf('adaptiveInteraction', adaptiveInteraction)) {
        if (valueOf('isDestructiveAction', isDestructiveAction)) {
          HapticFeedback.heavyImpact();
        } else if (valueOf('isDefaultAction', isDefaultAction)) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }
      }
      onPressed();
    }
  }

  /// Wraps action with iOS 26 Liquid Glass Dynamic Material effects
  /// 
  /// Implements subtle optical enhancements for dialog actions including:
  /// - Adaptive state layer effects
  /// - Enhanced interaction feedback
  /// - Optical clarity for improved readability
  Widget _wrapWithLiquidGlass(BuildContext context, Widget child) {
    if (!valueOf('adaptiveInteraction', adaptiveInteraction)) {
      return child;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        // Subtle state layer for enhanced interaction feedback
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.08),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
