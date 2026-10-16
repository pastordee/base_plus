import 'package:flutter/foundation.dart' show kIsWeb;
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
// Prefixed: fluent_ui re-exports the SDK's material library.
import 'package:fluent_ui/fluent_ui.dart' as fl;

import '../base_param.dart';
import '../mode/base_mode.dart';

/// Action style for alert actions (cross-platform)
enum BaseAlertActionStyle {
  /// Default style for standard actions.
  defaultStyle,

  /// Style for cancel actions (bold text).
  cancel,

  /// Style for destructive actions (red text).
  destructive,
}

/// Represents an action button in an alert (cross-platform data model)
/// 
/// This is the primary class to use when creating alert actions.
/// It will be automatically converted to platform-specific implementations:
/// - iOS/macOS: Native UIAlertController actions via platform channels
/// - Android/Other: Material Design TextButton in AlertDialog
class BaseAlertAction {
  /// The title displayed on the button.
  final String title;

  /// The style of the button.
  final BaseAlertActionStyle style;

  /// Callback when the button is tapped.
  final VoidCallback? onPressed;

  /// Creates an alert action.
  const BaseAlertAction({
    required this.title,
    this.style = BaseAlertActionStyle.defaultStyle,
    this.onPressed,
  });

  /// Converts to CNAlertAction for iOS native implementation
  CNAlertAction toCNAlertAction() {
    return CNAlertAction(
      title: title,
      style: _convertToCNStyle(style),
      onPressed: onPressed,
    );
  }

  /// Converts BaseAlertActionStyle to CNAlertActionStyle
  static CNAlertActionStyle _convertToCNStyle(BaseAlertActionStyle style) {
    switch (style) {
      case BaseAlertActionStyle.defaultStyle:
        return CNAlertActionStyle.defaultStyle;
      case BaseAlertActionStyle.cancel:
        return CNAlertActionStyle.cancel;
      case BaseAlertActionStyle.destructive:
        return CNAlertActionStyle.destructive;
    }
  }
}

/// iOS-specific alert action style (internal use only)
enum CNAlertActionStyle {
  /// Default style for standard actions.
  defaultStyle,

  /// Style for cancel actions (bold text).
  cancel,

  /// Style for destructive actions (red text).
  destructive,
}

/// iOS-specific alert action (internal use only)
/// 
/// This class is used internally for iOS native implementation.
/// External code should use [BaseAlertAction] instead.
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

/// BaseAlert - Cross-platform native alert dialogs
/// 
/// Uses native iOS UIAlertController via platform channels for iOS - provides authentic
/// iOS alert dialogs with native styling and behavior.
/// Uses Material AlertDialog for Android and other platforms.
/// 
/// Features:
/// - Native iOS/macOS alert dialogs via UIAlertController (platform channels)
/// - Material Design fallback for non-iOS platforms  
/// - Consistent API across platforms
/// - Support for action styles (default, cancel, destructive)
/// - Preferred action highlighting
/// - Convenience methods for common alert patterns
/// - Automatic platform-specific conversion of actions
/// 
/// Example:
/// ```dart
/// await BaseAlert.show(
///   context: context,
///   title: 'Delete Photo',
///   message: 'Are you sure you want to delete this photo?',
///   actions: [
///     BaseAlertAction(
///       title: 'Cancel',
///       style: BaseAlertActionStyle.cancel,
///     ),
///     BaseAlertAction(
///       title: 'Delete',
///       style: BaseAlertActionStyle.destructive,
///       onPressed: () {
///         // Perform delete action
///       },
///     ),
///   ],
/// );
/// ```
/// 
/// Updated: 2024.10.25 - Renamed from BaseCNAlert for consistency
class BaseAlert {
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
    required List<BaseAlertAction> actions,
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

    // Windows (BaseMode.fluent): a ContentDialog, as Windows apps ask.
    if (!kIsWeb && isFluentMode && cupertino?.forceUseMaterial != true &&
        material?.forceUseCupertino != true) {
      return _showFluentAlert(
        context: context,
        title: title,
        message: message,
        actions: actions,
        preferredActionIndex: preferredActionIndex,
      );
    }

    // Determine which platform implementation to use
    final bool useCupertino = _shouldUseCupertino(context, cupertino, material);

    if (useCupertino) {
      // Convert BaseAlertAction to CNAlertAction for iOS
      final cnActions = actions.map((action) => action.toCNAlertAction()).toList();
      
      return _showCupertinoNativeAlert(
        title: title,
        message: message,
        actions: cnActions,
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
    required List<BaseAlertAction> actions,
    int? preferredActionIndex,
  }) async {
    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        final ColorScheme colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          // Explicit surface + text colours so the dialog stays legible over
          // any ambient theme (e.g. shown via Get.overlayContext) — otherwise
          // the title/content inherited a colour that was invisible in light
          // mode against the dialog background.
          backgroundColor: colorScheme.surface,
          title: Text(
            title,
            style: TextStyle(color: colorScheme.onSurface),
          ),
          content: message != null
              ? Text(
                  message,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                )
              : null,
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
                  fontWeight: action.style == BaseAlertActionStyle.cancel 
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

  /// Windows' red for a destructive command (the "critical" system colour).
  static const Color _fluentCritical = Color(0xFFC42B1C);

  /// A Fluent ContentDialog (Windows, 2026-10-16). Windows conventions: the
  /// commit actions first and Cancel last; the preferred action — or the first
  /// that isn't Cancel — is the accent FilledButton; a destructive one is red.
  static Future<int?> _showFluentAlert({
    required BuildContext context,
    required String title,
    String? message,
    required List<BaseAlertAction> actions,
    int? preferredActionIndex,
  }) async {
    final List<int> order = <int>[
      for (int i = 0; i < actions.length; i++)
        if (actions[i].style != BaseAlertActionStyle.cancel) i,
      for (int i = 0; i < actions.length; i++)
        if (actions[i].style == BaseAlertActionStyle.cancel) i,
    ];
    int? primary = preferredActionIndex;
    if (primary == null) {
      for (final int i in order) {
        if (actions[i].style != BaseAlertActionStyle.cancel) {
          primary = i;
          break;
        }
      }
    }
    final int? result = await fl.showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => fl.ContentDialog(
        title: Text(title),
        content: message != null ? Text(message) : null,
        actions: <Widget>[
          for (final int i in order)
            _fluentAction(
              actions[i],
              primary: i == primary,
              onPressed: () => Navigator.of(dialogContext).pop(i),
            ),
        ],
      ),
    );
    if (result != null && result >= 0 && result < actions.length) {
      actions[result].onPressed?.call();
    }
    return result;
  }

  static Widget _fluentAction(
    BaseAlertAction action, {
    required bool primary,
    required VoidCallback onPressed,
  }) {
    final Widget label = Text(action.title);
    if (action.style == BaseAlertActionStyle.destructive) {
      return fl.FilledButton(
        style: const fl.ButtonStyle(
          backgroundColor: fl.WidgetStatePropertyAll<Color?>(_fluentCritical),
        ),
        onPressed: onPressed,
        child: label,
      );
    }
    return primary
        ? fl.FilledButton(onPressed: onPressed, child: label)
        : fl.Button(onPressed: onPressed, child: label);
  }

  /// Gets the appropriate color for Material button based on action style
  static Color? _getMaterialColorForStyle(BuildContext context, BaseAlertActionStyle style) {
    final theme = Theme.of(context);
    switch (style) {
      case BaseAlertActionStyle.cancel:
        return theme.colorScheme.primary;
      case BaseAlertActionStyle.destructive:
        return theme.colorScheme.error;
      case BaseAlertActionStyle.defaultStyle:
        // Explicit so default buttons stay legible on the dialog surface in
        // both themes (null inherited an invisible ambient colour).
        return theme.colorScheme.primary;
    }
  }

  /// Determines whether to use Cupertino or Material implementation
  static bool _shouldUseCupertino(BuildContext context, BaseParam? cupertino, BaseParam? material) {
    // Never in a browser: the native alert/sheet doesn't exist on the web.
    if (kIsWeb) return false;
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
        BaseAlertAction(
          title: 'OK',
          style: BaseAlertActionStyle.defaultStyle,
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
        BaseAlertAction(
          title: 'Cancel',
          style: BaseAlertActionStyle.cancel,
        ),
        BaseAlertAction(
          title: confirmTitle,
          style: BaseAlertActionStyle.defaultStyle,
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
        BaseAlertAction(
          title: 'Cancel',
          style: BaseAlertActionStyle.cancel,
        ),
        BaseAlertAction(
          title: destructiveTitle,
          style: BaseAlertActionStyle.destructive,
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
/// This maintains the original API while delegating to BaseAlert
/// for actual implementation.
/// 
/// Note: This still uses CNAlertAction for backward compatibility,
/// but internally converts to BaseAlertAction.
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

    // Convert CNAlertAction to BaseAlertAction
    final baseActions = actions.map((action) => BaseAlertAction(
      title: action.title,
      style: _convertToBaseStyle(action.style),
      onPressed: action.onPressed,
    )).toList();

    return await BaseAlert.show(
      context: context,
      title: title,
      message: message,
      actions: baseActions,
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

    await BaseAlert.showInfo(
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

    return await BaseAlert.showConfirmation(
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

    return await BaseAlert.showDestructiveConfirmation(
      context: context,
      title: title,
      message: message,
      destructiveTitle: destructiveTitle,
      onDestroy: onDestroy,
    );
  }
  
  /// Converts CNAlertActionStyle to BaseAlertActionStyle
  static BaseAlertActionStyle _convertToBaseStyle(CNAlertActionStyle style) {
    switch (style) {
      case CNAlertActionStyle.defaultStyle:
        return BaseAlertActionStyle.defaultStyle;
      case CNAlertActionStyle.cancel:
        return BaseAlertActionStyle.cancel;
      case CNAlertActionStyle.destructive:
        return BaseAlertActionStyle.destructive;
    }
  }
}