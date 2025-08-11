import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseActionSheetAction
/// use CupertinoActionSheetAction by cupertino
/// *** use cupertino = { forceUseMaterial: true } force use Material 3 FilledButton/TextButton on cupertino.
/// use Material 3 FilledButton/TextButton by material, with proper ColorScheme integration
/// *** use material = { forceUseCupertino: true } force use CupertinoActionSheetAction on material.
///
/// Modern iOS 16+ design with liquid glass effects
/// Material 3 design with proper semantic colors
/// CupertinoActionSheetAction: 2024.04.03
/// Material 3 Buttons: 2024.04.02
/// Enhanced with iOS 16+ liquid glass effects: 2025.08.11
class BaseActionSheetAction extends BaseStatelessWidget {
  const BaseActionSheetAction({
    Key? key,
    this.onPressed,
    this.child,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties start ***

  /// [CupertinoActionSheetAction.onPressed]
  final VoidCallback? onPressed;

  /// [CupertinoActionSheetAction.isDefaultAction]
  final bool isDefaultAction;

  /// [CupertinoActionSheetAction.isDestructiveAction]
  final bool isDestructiveAction;

  /// [CupertinoActionSheetAction.child]
  final Widget? child;

  /// *** general properties end ***

  @override
  Widget buildByCupertino(BuildContext context) {
    final Widget child = valueOf('child', this.child) ?? const SizedBox.shrink();
    final bool isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;
    
    // iOS 16+ liquid glass effect for action sheet actions
    if (isDefaultAction || isDestructiveAction) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), // iOS 16+ rounded corners
          // Liquid glass effect using backdrop filter and subtle gradients
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              if (isDestructiveAction) ...[
                (isDarkMode ? CupertinoColors.systemRed.darkColor : CupertinoColors.systemRed.color).withOpacity(0.1),
                (isDarkMode ? CupertinoColors.systemRed.darkColor : CupertinoColors.systemRed.color).withOpacity(0.05),
              ] else if (isDefaultAction) ...[
                (isDarkMode ? CupertinoColors.systemBlue.darkColor : CupertinoColors.systemBlue.color).withOpacity(0.1),
                (isDarkMode ? CupertinoColors.systemBlue.darkColor : CupertinoColors.systemBlue.color).withOpacity(0.05),
              ] else ...[
                CupertinoColors.systemGrey6.withOpacity(0.5),
                CupertinoColors.systemGrey6.withOpacity(0.2),
              ]
            ],
          ),
          // Modern iOS shadow with multiple layers for depth
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Liquid glass blur
            child: CupertinoActionSheetAction(
              onPressed: valueOf('onPressed', onPressed),
              isDefaultAction: valueOf('isDefaultAction', isDefaultAction),
              isDestructiveAction: valueOf('isDestructiveAction', isDestructiveAction),
              child: child,
            ),
          ),
        ),
      );
    }
    
    // Standard action without liquid glass effect
    return CupertinoActionSheetAction(
      onPressed: valueOf('onPressed', onPressed),
      isDefaultAction: valueOf('isDefaultAction', isDefaultAction),
      isDestructiveAction: valueOf('isDestructiveAction', isDestructiveAction),
      child: child,
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final Widget child = valueOf('child', this.child) ?? const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    
    // Material 3 semantic color handling
    Color getActionColor() {
      if (isDestructiveAction) {
        return colorScheme.error;
      }
      if (isDefaultAction) {
        return colorScheme.primary;
      }
      return colorScheme.onSurface;
    }
    
    // Material 3 typography
    TextStyle getTextStyle() {
      final baseStyle = textTheme.labelLarge ?? const TextStyle();
      return baseStyle.copyWith(
        fontWeight: isDefaultAction ? FontWeight.w600 : FontWeight.w500,
        color: getActionColor(),
        letterSpacing: 0.1,
      );
    }
    
    // Use different button types based on action importance
    if (isDefaultAction) {
      return FilledButton(
        onPressed: valueOf('onPressed', onPressed),
        style: FilledButton.styleFrom(
          backgroundColor: isDestructiveAction ? colorScheme.error : colorScheme.primary,
          foregroundColor: isDestructiveAction ? colorScheme.onError : colorScheme.onPrimary,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Modern rounded corners
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        child: child,
      );
    } else {
      return TextButton(
        onPressed: valueOf('onPressed', onPressed),
        style: TextButton.styleFrom(
          foregroundColor: getActionColor(),
          textStyle: getTextStyle(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Modern rounded corners
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          overlayColor: getActionColor().withOpacity(0.08), // Material 3 state overlay
        ),
        child: child,
      );
    }
  }
}
