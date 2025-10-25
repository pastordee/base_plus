// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_param.dart';

/// Action style for action sheet actions (cross-platform)
enum BaseActionSheetActionStyle {
  /// Default style
  defaultStyle,

  /// Cancel style (bold text, typically at bottom)
  cancel,

  /// Destructive style (red text, typically at top)
  destructive,
}

/// Represents a single action in an action sheet (cross-platform data model)
/// 
/// This is the primary class to use when creating action sheet actions.
/// It will be automatically converted to platform-specific implementations:
/// - iOS/macOS: Native UIAlertController actions via platform channels
/// - Android/Other: Material Design ListTile in bottom sheet
class BaseActionSheetAction {
  /// The title of the action
  final String title;

  /// The style of the action
  final BaseActionSheetActionStyle style;

  /// Callback when the action is tapped
  final VoidCallback? onPressed;

  const BaseActionSheetAction({
    required this.title,
    this.style = BaseActionSheetActionStyle.defaultStyle,
    this.onPressed,
  });

  /// Converts to CNActionSheetAction for iOS native implementation
  CNActionSheetAction toCNActionSheetAction() {
    return CNActionSheetAction(
      title: title,
      style: _convertToCNStyle(style),
      onPressed: onPressed,
    );
  }

  /// Converts BaseActionSheetActionStyle to CNActionSheetButtonStyle
  static CNActionSheetButtonStyle _convertToCNStyle(BaseActionSheetActionStyle style) {
    switch (style) {
      case BaseActionSheetActionStyle.defaultStyle:
        return CNActionSheetButtonStyle.defaultStyle;
      case BaseActionSheetActionStyle.cancel:
        return CNActionSheetButtonStyle.cancel;
      case BaseActionSheetActionStyle.destructive:
        return CNActionSheetButtonStyle.destructive;
    }
  }
}

/// iOS-specific action sheet button style (internal use only)
enum CNActionSheetButtonStyle {
  /// Default style
  defaultStyle,

  /// Cancel style (bold text, typically at bottom)
  cancel,

  /// Destructive style (red text, typically at top)
  destructive,
}

/// iOS-specific action sheet action (internal use only)
/// 
/// This class is used internally for iOS native implementation.
/// External code should use [BaseActionSheetAction] instead.
class CNActionSheetAction {
  /// The title of the action
  final String title;

  /// The style of the action
  final CNActionSheetButtonStyle style;

  /// Callback when the action is tapped
  final VoidCallback? onPressed;

  const CNActionSheetAction({
    required this.title,
    this.style = CNActionSheetButtonStyle.defaultStyle,
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

/// Base wrapper for ActionSheet with native iOS support and cross-platform compatibility
/// 
/// Provides **true native iOS action sheets** via platform channels with fallback to Material Design
/// bottom sheets on other platforms. Uses the cupertino_native package for authentic
/// native iOS action sheet experience.
/// 
/// Features:
/// - **Native iOS action sheets** with platform-specific styling
/// - Material Design bottom sheet fallback for non-iOS platforms  
/// - Consistent API across platforms
/// - Support for action styles (default, cancel, destructive)
/// - Cancel button handling
/// - Follows Apple HIG guidelines for action sheets
/// - Automatic platform-specific conversion of actions
/// 
/// Apple HIG best practices:
/// - Use action sheets to offer choices related to an intentional action
/// - Keep titles short (single line when possible)
/// - Provide a message only if necessary
/// - Make destructive choices visually prominent (place at top)
/// - Always provide a Cancel button that lets people reject destructive actions
/// - Place Cancel button at the bottom
/// - Avoid letting action sheets scroll (too many buttons)
/// 
/// Updated: 2024.10.25
/// 
/// Example:
/// ```dart
/// BaseActionSheet.show(
///   context: context,
///   title: 'Delete Draft?',
///   message: 'This action cannot be undone.',
///   actions: [
///     BaseActionSheetAction(
///       title: 'Delete Draft',
///       style: BaseActionSheetActionStyle.destructive,
///       onPressed: () => deleteDraft(),
///     ),
///     BaseActionSheetAction(
///       title: 'Save Draft',
///       onPressed: () => saveDraft(),
///     ),
///   ],
///   cancelAction: BaseActionSheetAction(
///     title: 'Cancel',
///     style: BaseActionSheetActionStyle.cancel,
///   ),
/// );
/// ```
class BaseActionSheet {
  static const MethodChannel _channel = MethodChannel('cupertino_native_action_sheet');

  /// Shows a native action sheet
  ///
  /// - [context]: Build context for showing the sheet
  /// - [title]: Title text (keep short, ideally single line)
  /// - [message]: Optional message for additional context
  /// - [actions]: List of actions to display (destructive actions should be first)
  /// - [cancelAction]: Optional cancel action (recommended, especially for destructive actions)
  /// - [cupertino]: Cupertino-specific parameters
  /// - [material]: Material-specific parameters
  ///
  /// Returns the index of the action that was tapped, or null if cancelled
  static Future<int?> show({
    required BuildContext context,
    String? title,
    String? message,
    required List<BaseActionSheetAction> actions,
    BaseActionSheetAction? cancelAction,
    BaseParam? cupertino,
    BaseParam? material,
  }) async {
    if (actions.isEmpty) {
      throw ArgumentError('Actions list cannot be empty');
    }

    // Determine which platform implementation to use
    final useCupertino = _shouldUseCupertino(context, cupertino, material);

    if (useCupertino) {
      // Convert BaseActionSheetAction to CNActionSheetAction for iOS
      final cnActions = actions.map((action) => action.toCNActionSheetAction()).toList();
      final cnCancelAction = cancelAction?.toCNActionSheetAction();
      
      return await _showCupertinoNativeActionSheet(
        title: title,
        message: message,
        actions: cnActions,
        cancelAction: cnCancelAction,
      );
    } else {
      return await _showMaterialBottomSheet(
        context: context,
        title: title,
        message: message,
        actions: actions,
        cancelAction: cancelAction,
      );
    }
  }

  /// Shows a native action sheet using cupertino_native package
  static Future<int?> _showCupertinoNativeActionSheet({
    String? title,
    String? message,
    required List<CNActionSheetAction> actions,
    CNActionSheetAction? cancelAction,
  }) async {
    // Build the action list for native side
    final List<Map<String, dynamic>> actionMaps = actions.map((action) {
      return {
        'title': action.title,
        'style': action.style.index,
      };
    }).toList();

    // Add cancel action if provided
    Map<String, dynamic>? cancelMap;
    if (cancelAction != null) {
      cancelMap = {
        'title': cancelAction.title,
        'style': CNActionSheetButtonStyle.cancel.index,
      };
    }

    try {
      final result = await _channel.invokeMethod('showActionSheet', {
        'title': title,
        'message': message,
        'actions': actionMaps,
        'cancelAction': cancelMap,
      });

      // Handle the result
      if (result == null) {
        // User cancelled
        return null;
      }

      final int index = result as int;

      // If cancel button was tapped, call its callback
      if (index == -1) {
        cancelAction?.onPressed?.call();
        return null;
      }

      // Call the appropriate action callback
      if (index >= 0 && index < actions.length) {
        actions[index].onPressed?.call();
        return index;
      }

      return null;
    } on PlatformException catch (e) {
      debugPrint('Error showing native action sheet: ${e.message}');
      return null;
    }
  }

  /// Shows a Material Design bottom sheet as fallback
  static Future<int?> _showMaterialBottomSheet({
    required BuildContext context,
    String? title,
    String? message,
    required List<BaseActionSheetAction> actions,
    BaseActionSheetAction? cancelAction,
  }) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and message
              if (title != null || message != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (title != null && message != null)
                        const SizedBox(height: 8),
                      if (message != null)
                        Text(
                          message,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                    ],
                  ),
                ),
              
              // Actions
              ...actions.asMap().entries.map((entry) {
                final index = entry.key;
                final action = entry.value;
                
                return ListTile(
                  title: Text(
                    action.title,
                    style: TextStyle(
                      color: _getMaterialColorForStyle(context, action.style),
                      fontWeight: action.style == BaseActionSheetActionStyle.cancel 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(index);
                    action.onPressed?.call();
                  },
                );
              }).toList(),
              
              // Cancel action (if provided)
              if (cancelAction != null) ...[
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    cancelAction.title,
                    style: TextStyle(
                      color: _getMaterialColorForStyle(context, cancelAction.style),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(-1);
                    cancelAction.onPressed?.call();
                  },
                ),
              ],
            ],
          ),
        );
      },
    );

    return result;
  }

  /// Gets the appropriate color for Material action based on action style
  static Color? _getMaterialColorForStyle(BuildContext context, BaseActionSheetActionStyle style) {
    final theme = Theme.of(context);
    switch (style) {
      case BaseActionSheetActionStyle.cancel:
        return theme.colorScheme.primary;
      case BaseActionSheetActionStyle.destructive:
        return theme.colorScheme.error;
      case BaseActionSheetActionStyle.defaultStyle:
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

  /// Shows a simple confirmation action sheet with delete/cancel options
  ///
  /// Common pattern for destructive actions like deleting drafts, removing items, etc.
  ///
  /// Example:
  /// ```dart
  /// final confirmed = await BaseActionSheet.showConfirmation(
  ///   context: context,
  ///   title: 'Delete Message?',
  ///   message: 'This action cannot be undone.',
  ///   confirmTitle: 'Delete',
  ///   onConfirm: () => deleteMessage(),
  /// );
  /// ```
  static Future<bool> showConfirmation({
    required BuildContext context,
    String? title,
    String? message,
    String confirmTitle = 'Delete',
    String cancelTitle = 'Cancel',
    VoidCallback? onConfirm,
    BaseParam? cupertino,
    BaseParam? material,
  }) async {
    final result = await show(
      context: context,
      title: title,
      message: message,
      actions: [
        BaseActionSheetAction(
          title: confirmTitle,
          style: BaseActionSheetActionStyle.destructive,
          onPressed: onConfirm,
        ),
      ],
      cancelAction: BaseActionSheetAction(
        title: cancelTitle,
        style: BaseActionSheetActionStyle.cancel,
      ),
      cupertino: cupertino,
      material: material,
    );

    return result != null && result == 0;
  }
}

/// Navigation service for accessing context when needed
class ActionSheetNavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

/// Legacy alias for backward compatibility
/// 
/// @deprecated Use [BaseActionSheet] directly instead
@Deprecated('Use BaseActionSheet instead')
class BaseCNActionSheet {
  /// Shows a native action sheet
  @Deprecated('Use BaseActionSheet.show instead')
  static Future<int?> show({
    required BuildContext context,
    String? title,
    String? message,
    required List<BaseActionSheetAction> actions,
    BaseActionSheetAction? cancelAction,
    BaseParam? cupertino,
    BaseParam? material,
  }) async {
    return await BaseActionSheet.show(
      context: context,
      title: title,
      message: message,
      actions: actions,
      cancelAction: cancelAction,
      cupertino: cupertino,
      material: material,
    );
  }

  /// Shows a simple confirmation action sheet with delete/cancel options
  @Deprecated('Use BaseActionSheet.showConfirmation instead')
  static Future<bool> showConfirmation({
    required BuildContext context,
    String? title,
    String? message,
    String confirmTitle = 'Delete',
    String cancelTitle = 'Cancel',
    VoidCallback? onConfirm,
    BaseParam? cupertino,
    BaseParam? material,
  }) async {
    return await BaseActionSheet.showConfirmation(
      context: context,
      title: title,
      message: message,
      confirmTitle: confirmTitle,
      cancelTitle: cancelTitle,
      onConfirm: onConfirm,
      cupertino: cupertino,
      material: material,
    );
  }
}

/// Legacy CNActionSheet class for backward compatibility
/// 
/// This maintains the original API while delegating to BaseActionSheet
/// for actual implementation.
/// 
/// Note: This still uses CNActionSheetAction for backward compatibility,
/// but internally converts to BaseActionSheetAction.
@Deprecated('Use BaseActionSheet instead')
class CNActionSheet {
  /// Shows a native iOS action sheet
  static Future<int?> show({
    required BuildContext context,
    String? title,
    String? message,
    required List<CNActionSheetAction> actions,
    CNActionSheetAction? cancelAction,
  }) async {
    // Convert CNActionSheetAction to BaseActionSheetAction
    final baseActions = actions.map((action) => BaseActionSheetAction(
      title: action.title,
      style: _convertToBaseStyle(action.style),
      onPressed: action.onPressed,
    )).toList();
    
    final baseCancelAction = cancelAction != null 
      ? BaseActionSheetAction(
          title: cancelAction.title,
          style: _convertToBaseStyle(cancelAction.style),
          onPressed: cancelAction.onPressed,
        )
      : null;
    
    return await BaseActionSheet.show(
      context: context,
      title: title,
      message: message,
      actions: baseActions,
      cancelAction: baseCancelAction,
    );
  }

  /// Shows a simple confirmation action sheet with delete/cancel options
  @Deprecated('Use BaseActionSheet.showConfirmation instead')
  static Future<bool> showConfirmation({
    required BuildContext context,
    String? title,
    String? message,
    String confirmTitle = 'Delete',
    String cancelTitle = 'Cancel',
    VoidCallback? onConfirm,
  }) async {
    return await BaseActionSheet.showConfirmation(
      context: context,
      title: title,
      message: message,
      confirmTitle: confirmTitle,
      cancelTitle: cancelTitle,
      onConfirm: onConfirm,
    );
  }
  
  /// Converts CNActionSheetButtonStyle to BaseActionSheetActionStyle
  static BaseActionSheetActionStyle _convertToBaseStyle(CNActionSheetButtonStyle style) {
    switch (style) {
      case CNActionSheetButtonStyle.defaultStyle:
        return BaseActionSheetActionStyle.defaultStyle;
      case CNActionSheetButtonStyle.cancel:
        return BaseActionSheetActionStyle.cancel;
      case CNActionSheetButtonStyle.destructive:
        return BaseActionSheetActionStyle.destructive;
    }
  }
}