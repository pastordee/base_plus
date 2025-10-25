import 'package:flutter/material.dart';

import '../base_param.dart';
import '../alert/base_alert.dart';

// Re-export CNAlertAction and CNAlertActionStyle for convenience
export '../alert/base_alert.dart' show CNAlertAction, CNAlertActionStyle;

/// @Deprecated - Use BaseAlert instead
/// 
/// BaseCNAlert has been renamed to BaseAlert for consistency.
/// BaseAlert provides the same native iOS UIAlertController rendering
/// via platform channels and Material AlertDialog fallback.
/// 
/// Migration:
/// ```dart
/// // Old
/// await BaseCNAlert.show(
///   context: context,
///   title: 'Delete',
///   message: 'Are you sure?',
///   actions: [...],
/// )
/// 
/// // New
/// await BaseAlert.show(
///   context: context,
///   title: 'Delete',
///   message: 'Are you sure?',
///   actions: [...],
/// )
/// ```
/// 
/// The API is identical - just rename the class from BaseCNAlert to BaseAlert.
@Deprecated('Use BaseAlert instead. BaseCNAlert will be removed in a future version.')
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
    return await BaseAlert.show(
      context: context,
      title: title,
      message: message,
      actions: actions,
      preferredActionIndex: preferredActionIndex,
      cupertino: cupertino,
      material: material,
    );
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
