// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_param.dart';

/// Style for alert buttons.
enum CNAlertActionStyle {
  /// Default style for standard actions.
  defaultStyle,

  /// Style for cancel actions (bold text).
  cancel,

  /// Style for destructive actions (red text).
  destructive,
}

/// Represents an action button in an alert.
class CNAlertAction {
  /// The title displayed on the button.
  final String title;

  /// The style of the button.
  final CNAlertActionStyle style;

  /// Callback when the button is tapped.
  final VoidCallback? onPressed;

  /// Creates an alert action.
  const CNAlertAction({
    required this.title,
    this.style = CNAlertActionStyle.defaultStyle,
    this.onPressed,
  });

  /// Converts the action to a map for platform channel communication.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'style': style.index,
    };
  }
}

/// Base wrapper for CNAlert with cross-platform support
/// 
/// Provides native iOS/macOS alert dialogs with fallback to Material Design
/// alerts on other platforms. Uses the cupertino_native package for true
/// native iOS alert experience when available.
/// 
/// Features:
/// - Native iOS alert dialogs with platform-specific styling
/// - Material Design fallback for non-iOS platforms  
/// - Consistent API across platforms
/// - Support for action styles (default, cancel, destructive)
/// - Preferred action highlighting
/// - Convenience methods for common alert patterns
/// 
/// Example:
/// ```dart
/// await BaseCNAlert.show(
///   context: context,
///   title: 'Delete Photo',
///   message: 'Are you sure you want to delete this photo?',
///   actions: [
///     CNAlertAction(
///       title: 'Cancel',
///       style: CNAlertActionStyle.cancel,
///     ),
///     CNAlertAction(
///       title: 'Delete',
///       style: CNAlertActionStyle.destructive,
///       onPressed: () {
///         // Perform delete action
///       },
///     ),
///   ],
/// );
/// ```
class BaseCNAlert {
  static const MethodChannel _channel =
      MethodChannel('cupertino_native_alert');

  /// Shows a native alert dialog.
  ///
  /// - [context]: The build context for Material fallback dialogs.
  /// - [title]: The title of the alert (required).
  /// - [message]: Optional informative text that adds value.
  /// - [actions]: List of action buttons (up to 3 recommended).
  /// - [preferredActionIndex]: Index of the preferred (default) action.
  /// - [cupertino]: Cupertino-specific parameters.
  /// - [material]: Material-specific parameters.
  ///
  /// Returns the index of the action that was tapped, or null if dismissed.
  static Future<int?> show({
    required BuildContext context,
    required String title,
    String? message,
    required List<CNAlertAction> actions,
    int? preferredActionIndex,
    BaseParam? cupertino,
    BaseParam? material,
  }) async {
    if (actions.isEmpty) {
      throw ArgumentError('Alert must have at least one action');
    }

    if (preferredActionIndex != null &&
        (preferredActionIndex < 0 || preferredActionIndex >= actions.length)) {
      throw ArgumentError('preferredActionIndex out of range');
    }

    // Determine which platform implementation to use
    final bool useCupertino = _shouldUseCupertino(context, cupertino, material);

    if (useCupertino) {
      return _showCupertinoNativeAlert(
        title: title,
        message: message,
        actions: actions,
        preferredActionIndex: preferredActionIndex,
      );
    } else {
      return _showMaterialAlert(
        context: context,
        title: title,
        message: message,
        actions: actions,
        preferredActionIndex: preferredActionIndex,
      );
    }
  }

  /// Shows a native alert using cupertino_native package
  static Future<int?> _showCupertinoNativeAlert({
    required String title,
    String? message,
    required List<CNAlertAction> actions,
    int? preferredActionIndex,
  }) async {
    try {
      final result = await _channel.invokeMethod<int>('showAlert', {
        'title': title,
        'message': message,
        'actions': actions.map((a) => a.toMap()).toList(),
        'preferredActionIndex': preferredActionIndex,
      });

      // Execute the callback for the selected action
      if (result != null && result >= 0 && result < actions.length) {
        actions[result].onPressed?.call();
      }

      return result;
    } catch (e) {
      print('Error showing native alert: $e');
      return null;
    }
  }

  /// Shows a Material Design alert dialog as fallback
  static Future<int?> _showMaterialAlert({
    required BuildContext context,
    required String title,
    String? message,
    required List<CNAlertAction> actions,
    int? preferredActionIndex,
  }) async {
    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: message != null ? Text(message) : null,
          actions: actions.asMap().entries.map((entry) {
            final index = entry.key;
            final action = entry.value;
            
            return TextButton(
              onPressed: () {
                Navigator.of(context).pop(index);
                action.onPressed?.call();
              },
              style: TextButton.styleFrom(
                foregroundColor: _getMaterialColorForStyle(context, action.style),
              ),
              child: Text(
                action.title,
                style: TextStyle(
                  fontWeight: action.style == CNAlertActionStyle.cancel 
                    ? FontWeight.bold 
                    : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        );
      },
    );

    return result;
  }

  /// Gets the appropriate color for Material button based on action style
  static Color? _getMaterialColorForStyle(BuildContext context, CNAlertActionStyle style) {
    final theme = Theme.of(context);
    switch (style) {
      case CNAlertActionStyle.cancel:
        return theme.colorScheme.primary;
      case CNAlertActionStyle.destructive:
        return theme.colorScheme.error;
      case CNAlertActionStyle.defaultStyle:
        return null;
    }
  }

  /// Determines whether to use Cupertino or Material implementation
  static bool _shouldUseCupertino(BuildContext context, BaseParam? cupertino, BaseParam? material) {
    // Force Material if specified
    if (cupertino?.forceUseMaterial == true) return false;
    if (material?.forceUseCupertino == true) return true;
    
    // Default platform behavior - use native on iOS/macOS
    return Theme.of(context).platform == TargetPlatform.iOS ||
           Theme.of(context).platform == TargetPlatform.macOS;
  }

  /// Shows a simple informational alert with an OK button.
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    String? message,
    BaseParam? cupertino,
    BaseParam? material,
  }) async {
    await show(
      context: context,
      title: title,
      message: message,
      actions: [
        CNAlertAction(
          title: 'OK',
          style: CNAlertActionStyle.defaultStyle,
        ),
      ],
      cupertino: cupertino,
      material: material,
    );
  }

  /// Shows a confirmation alert with Cancel and Confirm buttons.
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    String? message,
    String confirmTitle = 'Confirm',
    VoidCallback? onConfirm,
    BaseParam? cupertino,
    BaseParam? material,
  }) async {
    final result = await show(
      context: context,
      title: title,
      message: message,
      actions: [
        CNAlertAction(
          title: 'Cancel',
          style: CNAlertActionStyle.cancel,
        ),
        CNAlertAction(
          title: confirmTitle,
          style: CNAlertActionStyle.defaultStyle,
          onPressed: onConfirm,
        ),
      ],
      preferredActionIndex: 1, // Confirm button is preferred
      cupertino: cupertino,
      material: material,
    );

    return result == 1; // Returns true if Confirm was tapped
  }

  /// Shows a destructive confirmation alert.
  static Future<bool> showDestructiveConfirmation({
    required BuildContext context,
    required String title,
    String? message,
    required String destructiveTitle,
    VoidCallback? onDestroy,
    BaseParam? cupertino,
    BaseParam? material,
  }) async {
    final result = await show(
      context: context,
      title: title,
      message: message,
      actions: [
        CNAlertAction(
          title: 'Cancel',
          style: CNAlertActionStyle.cancel,
        ),
        CNAlertAction(
          title: destructiveTitle,
          style: CNAlertActionStyle.destructive,
          onPressed: onDestroy,
        ),
      ],
      cupertino: cupertino,
      material: material,
    );

    return result == 1; // Returns true if destructive action was tapped
  }
}

/// Navigation service for accessing context when needed
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

/// Legacy CNAlert class for backward compatibility
/// 
/// This maintains the original API while delegating to BaseCNAlert
/// for actual implementation.
class CNAlert {

  /// Shows a native alert dialog.
  static Future<int?> show({
    required String title,
    String? message,
    required List<CNAlertAction> actions,
    int? preferredActionIndex,
  }) async {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) {
      throw StateError('No navigator context available. Make sure NavigationService.navigatorKey is set in your MaterialApp.');
    }

    return await BaseCNAlert.show(
      context: context,
      title: title,
      message: message,
      actions: actions,
      preferredActionIndex: preferredActionIndex,
    );
  }

  /// Shows a simple informational alert with an OK button.
  static Future<void> showInfo({
    required String title,
    String? message,
  }) async {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) {
      throw StateError('No navigator context available. Make sure NavigationService.navigatorKey is set in your MaterialApp.');
    }

    await BaseCNAlert.showInfo(
      context: context,
      title: title,
      message: message,
    );
  }

  /// Shows a confirmation alert with Cancel and Confirm buttons.
  static Future<bool> showConfirmation({
    required String title,
    String? message,
    String confirmTitle = 'Confirm',
    VoidCallback? onConfirm,
  }) async {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) {
      throw StateError('No navigator context available. Make sure NavigationService.navigatorKey is set in your MaterialApp.');
    }

    return await BaseCNAlert.showConfirmation(
      context: context,
      title: title,
      message: message,
      confirmTitle: confirmTitle,
      onConfirm: onConfirm,
    );
  }

  /// Shows a destructive confirmation alert.
  static Future<bool> showDestructiveConfirmation({
    required String title,
    String? message,
    required String destructiveTitle,
    VoidCallback? onDestroy,
  }) async {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) {
      throw StateError('No navigator context available. Make sure NavigationService.navigatorKey is set in your MaterialApp.');
    }

    return await BaseCNAlert.showDestructiveConfirmation(
      context: context,
      title: title,
      message: message,
      destructiveTitle: destructiveTitle,
      onDestroy: onDestroy,
    );
  }
}