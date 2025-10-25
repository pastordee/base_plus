import 'package:flutter/material.dart';

import '../base_param.dart';
import '../alert/base_alert.dart';

// Re-export Base* classes (new public API) and CN* classes (for backward compatibility)
export '../alert/base_alert.dart' show BaseAlertAction, BaseAlertActionStyle, CNAlertAction, CNAlertActionStyle;

/// @Deprecated - Use BaseAlert instead
/// 
/// BaseCNAlert has been renamed to BaseAlert for consistency.
/// BaseAlert provides the same native iOS UIAlertController rendering
/// via platform channels and Material AlertDialog fallback.
/// 
/// Additionally, the public API now uses BaseAlertAction instead of CNAlertAction.
/// 
/// Migration:
/// ```dart
/// // Old
/// await BaseCNAlert.show(
///   context: context,
///   title: 'Delete',
///   message: 'Are you sure?',
///   actions: [
///     CNAlertAction(title: 'Cancel', style: CNAlertActionStyle.cancel),
///     CNAlertAction(title: 'Delete', style: CNAlertActionStyle.destructive),
///   ],
/// )
/// 
/// // New
/// await BaseAlert.show(
///   context: context,
///   title: 'Delete',
///   message: 'Are you sure?',
///   actions: [
///     BaseAlertAction(title: 'Cancel', style: BaseAlertActionStyle.cancel),
///     BaseAlertAction(title: 'Delete', style: BaseAlertActionStyle.destructive),
///   ],
/// )
/// ```
/// 
/// Rename classes:
/// - BaseCNAlert → BaseAlert
/// - CNAlertAction → BaseAlertAction
/// - CNAlertActionStyle → BaseAlertActionStyle
@Deprecated('Use BaseAlert with BaseAlertAction instead. BaseCNAlert will be removed in a future version.')
class BaseCNAlert {
  /// Shows a native alert dialog.
  static Future<int?> show({
    required BuildContext context,
    required String title,
    String? message,
    required List<CNAlertAction> actions,
    int? preferredActionIndex,
    BaseParam? cupertino,
    BaseParam? material,
  }) async {
    // Convert CNAlertAction to BaseAlertAction
    final baseActions = actions.map((action) => BaseAlertAction(
      title: action.title,
      style: _convertStyle(action.style),
      onPressed: action.onPressed,
    )).toList();
    
    return await BaseAlert.show(
      context: context,
      title: title,
      message: message,
      actions: baseActions,
      preferredActionIndex: preferredActionIndex,
      cupertino: cupertino,
      material: material,
    );
  }
  
  /// Convert CNAlertActionStyle to BaseAlertActionStyle
  static BaseAlertActionStyle _convertStyle(CNAlertActionStyle style) {
    switch (style) {
      case CNAlertActionStyle.defaultStyle:
        return BaseAlertActionStyle.defaultStyle;
      case CNAlertActionStyle.cancel:
        return BaseAlertActionStyle.cancel;
      case CNAlertActionStyle.destructive:
        return BaseAlertActionStyle.destructive;
    }
  }

  /// Shows an informational alert with a single OK button.
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    String? message,
  }) async {
    return await BaseAlert.showInfo(
      context: context,
      title: title,
      message: message,
    );
  }

  /// Shows a confirmation alert with Cancel and Confirm buttons.
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    String? message,
    String confirmTitle = 'Confirm',
    VoidCallback? onConfirm,
  }) async {
    return await BaseAlert.showConfirmation(
      context: context,
      title: title,
      message: message,
      confirmTitle: confirmTitle,
      onConfirm: onConfirm,
    );
  }

  /// Shows a destructive confirmation alert with Cancel and destructive action.
  static Future<bool> showDestructiveConfirmation({
    required BuildContext context,
    required String title,
    String? message,
    String destructiveTitle = 'Delete',
    VoidCallback? onDestroy,
  }) async {
    return await BaseAlert.showDestructiveConfirmation(
      context: context,
      title: title,
      message: message,
      destructiveTitle: destructiveTitle,
      onDestroy: onDestroy,
    );
  }
}
