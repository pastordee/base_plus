// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// Detent heights for resizable sheets (iOS only)
class CNSheetDetent {
  final String type;
  final double? height;
  
  const CNSheetDetent._(this.type, this.height);
  
  /// Medium height (~50% of screen)
  static const medium = CNSheetDetent._('medium', null);
  
  /// Large height (~100% of screen)
  static const large = CNSheetDetent._('large', null);
  
  /// Custom fixed height in points
  /// Example: CNSheetDetent.custom(300) for a 300pt tall sheet
  static CNSheetDetent custom(double height) => CNSheetDetent._('custom', height);
  
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      if (height != null) 'height': height,
    };
  }
}

/// An item to display in a native sheet
class CNSheetItem {
  final String? title;
  final String? icon;
  final bool dismissOnTap;
  
  /// Creates a simple sheet item with title and optional icon.
  /// This will be rendered natively using UISheetPresentationController.
  const CNSheetItem({
    required this.title,
    this.icon,
    this.dismissOnTap = true,
  });
  
  Map<String, dynamic> toMap() {
    return {
      if (title != null) 'title': title,
      if (icon != null) 'icon': icon,
      'dismissOnTap': dismissOnTap,
    };
  }
}

/// Base wrapper for CNNativeSheet with cross-platform support
/// 
/// Provides native iOS UISheetPresentationController with fallback to Material Design
/// bottom sheets on other platforms. Uses the cupertino_native package for true
/// native iOS sheet presentation when available.
/// 
/// Features:
/// - Native iOS sheet presentation with UISheetPresentationController
/// - Resizable sheets with detents (medium, large, custom heights)
/// - Nonmodal sheet support for background interaction
/// - Custom header with title and close button
/// - Material Design bottom sheet fallback
/// - Apple HIG compliant sheet behavior
/// 
/// Apple HIG implementation:
/// - Modal and nonmodal sheet presentations
/// - Grabber handle for resizable sheets
/// - Edge attachment in compact height
/// - Preferred corner radius customization
/// - Native item rendering with SF Symbols
/// 
/// Example usage:
/// ```dart
/// // Standard modal sheet
/// final selectedIndex = await BaseCNNativeSheet.show(
///   context: context,
///   title: 'Settings',
///   items: [
///     CNSheetItem(title: 'Brightness', icon: 'sun.max'),
///     CNSheetItem(title: 'Appearance', icon: 'moon'),
///   ],
///   detents: [CNSheetDetent.medium],
/// );
/// 
/// // Nonmodal sheet (allows background interaction)
/// await BaseCNNativeSheet.show(
///   context: context,
///   title: 'Format',
///   items: [
///     CNSheetItem(title: 'Bold', icon: 'bold', dismissOnTap: false),
///     CNSheetItem(title: 'Italic', icon: 'italic', dismissOnTap: false),
///   ],
///   isModal: false,
/// );
/// 
/// // Custom header sheet
/// await BaseCNNativeSheet.showWithCustomHeader(
///   context: context,
///   title: 'Format',
///   headerTitleWeight: FontWeight.w600,
///   items: [
///     CNSheetItem(title: 'Bold', icon: 'bold'),
///   ],
///   isModal: false,
/// );
/// ```
class BaseCNNativeSheet extends BaseStatelessWidget {
  /// Creates a base native sheet wrapper
  /// 
  /// This class is primarily used as a static interface and doesn't typically
  /// need to be instantiated as a widget.
  const BaseCNNativeSheet({
    Key? key,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  @override
  Widget buildByCupertino(BuildContext context) {
    // This is primarily a static utility class
    return const SizedBox.shrink();
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    // This is primarily a static utility class
    return const SizedBox.shrink();
  }

  /// Shows a native sheet with the given content.
  /// 
  /// Uses native UISheetPresentationController for rendering on iOS/iPadOS/macOS.
  /// Falls back to Material bottom sheet on other platforms.
  /// 
  /// [context] - Build context for presentation
  /// [title] - Optional title for the sheet (displays in content area with close button)
  /// [message] - Optional message below the title
  /// [items] - List of items to display in the sheet
  /// [detents] - Heights at which the sheet can rest (iOS only, defaults to [large])
  /// [prefersGrabberVisible] - Whether to show the grabber handle (iOS only)
  /// [isModal] - Whether the sheet is modal (blocks interaction with parent view).
  ///            Default is true. Set to false for nonmodal sheets that allow
  ///            background interaction (iOS/iPadOS only, always modal on macOS/visionOS/watchOS).
  /// [prefersEdgeAttachedInCompactHeight] - Whether sheet attaches to edge in compact height
  /// [widthFollowsPreferredContentSizeWhenEdgeAttached] - Whether width follows preferred content size
  /// [preferredCornerRadius] - Custom corner radius for the sheet
  /// [itemBackgroundColor] - Background color for sheet item buttons (default: clear)
  /// [itemTextColor] - Text color for sheet item buttons (default: system label)
  /// [itemTintColor] - Tint color for icons in sheet item buttons (default: system tint)
  /// [baseParam] - Platform override parameter
  static Future<int?> show({
    required BuildContext context,
    String? title,
    String? message,
    List<CNSheetItem> items = const [],
    List<CNSheetDetent> detents = const [CNSheetDetent.large],
    bool prefersGrabberVisible = true,
    bool isModal = true,
    bool prefersEdgeAttachedInCompactHeight = false,
    bool widthFollowsPreferredContentSizeWhenEdgeAttached = false,
    double? preferredCornerRadius,
    Color? itemBackgroundColor,
    Color? itemTextColor,
    Color? itemTintColor,
    BaseParam? baseParam,
  }) async {
    final param = baseParam ?? BaseParam();
    
    // Determine if we should use Cupertino or Material implementation
    final useCupertino = param.forceUseCupertino || 
                        (!param.forceUseMaterial && _shouldUseCupertino());
    
    if (useCupertino) {
      return await _CNNativeSheetCupertino.show(
        context: context,
        title: title,
        message: message,
        items: items,
        detents: detents,
        prefersGrabberVisible: prefersGrabberVisible,
        isModal: isModal,
        prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
        widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
        preferredCornerRadius: preferredCornerRadius,
        itemBackgroundColor: itemBackgroundColor,
        itemTextColor: itemTextColor,
        itemTintColor: itemTintColor,
      );
    } else {
      return await _CNNativeSheetMaterial.show(
        context: context,
        title: title,
        message: message,
        items: items,
        detents: detents,
        prefersGrabberVisible: prefersGrabberVisible,
        isModal: isModal,
        prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
        widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
        preferredCornerRadius: preferredCornerRadius,
        itemBackgroundColor: itemBackgroundColor,
        itemTextColor: itemTextColor,
        itemTintColor: itemTintColor,
      );
    }
  }

  /// Shows a native sheet with custom header (title + close button).
  /// 
  /// This is like the Apple Notes formatting sheet - it has a custom header bar
  /// with the title on the left and a close button (X) on the right.
  /// 
  /// **Key differences from `show()`:**
  /// - Custom header with title and close button (like Notes app)
  /// - Title is displayed in the header bar, not in the content area
  /// - Close button allows manual dismissal
  /// - Still supports nonmodal behavior with `isModal: false`
  /// - Full control over header styling
  /// 
  /// **Example:**
  /// ```dart
  /// await BaseCNNativeSheet.showWithCustomHeader(
  ///   context: context,
  ///   title: 'Format',
  ///   headerTitleSize: 20,
  ///   headerTitleWeight: FontWeight.w600,
  ///   headerHeight: 56,
  ///   items: [
  ///     CNSheetItem(title: 'Bold', icon: 'bold'),
  ///     CNSheetItem(title: 'Italic', icon: 'italic'),
  ///   ],
  ///   detents: [CNSheetDetent.custom(280)],
  ///   isModal: false, // Nonmodal - can interact with background
  /// );
  /// ```
  /// 
  /// [context] - Build context for presentation
  /// [title] - Title displayed in the header (required for custom header)
  /// [message] - Optional message below the header
  /// [items] - List of items to display
  /// [detents] - Heights at which the sheet can rest
  /// [prefersGrabberVisible] - Whether to show the grabber handle
  /// [isModal] - Whether the sheet blocks background interaction
  /// 
  /// **Header Styling Options:**
  /// [headerTitleSize] - Font size for the title (default: 20)
  /// [headerTitleWeight] - Font weight for the title (default: semibold/600)
  /// [headerTitleColor] - Color for the title (default: label color)
  /// [headerHeight] - Height of the header bar (default: 56)
  /// [headerBackgroundColor] - Background color of the header (default: system background)
  /// [showHeaderDivider] - Whether to show divider below header (default: true)
  /// [headerDividerColor] - Color of the header divider (default: separator color)
  /// [closeButtonPosition] - Position of close button: 'leading' or 'trailing' (default: 'trailing')
  /// [closeButtonIcon] - SF Symbol name for close button (default: 'xmark')
  /// [closeButtonSize] - Size of the close button icon (default: 17)
  /// [closeButtonColor] - Color of the close button (default: label color)
  /// [itemBackgroundColor] - Background color for sheet item buttons (default: clear)
  /// [itemTextColor] - Text color for sheet item buttons (default: system label)
  /// [itemTintColor] - Tint color for icons in sheet item buttons (default: system tint)
  /// [baseParam] - Platform override parameter
  static Future<int?> showWithCustomHeader({
    required BuildContext context,
    required String title,
    String? message,
    List<CNSheetItem> items = const [],
    List<CNSheetDetent> detents = const [CNSheetDetent.large],
    bool prefersGrabberVisible = true,
    bool isModal = true,
    bool prefersEdgeAttachedInCompactHeight = false,
    bool widthFollowsPreferredContentSizeWhenEdgeAttached = false,
    double? preferredCornerRadius,
    // Header styling
    double? headerTitleSize,
    FontWeight? headerTitleWeight,
    Color? headerTitleColor,
    double? headerHeight,
    Color? headerBackgroundColor,
    bool showHeaderDivider = true,
    Color? headerDividerColor,
    String closeButtonPosition = 'trailing',
    String closeButtonIcon = 'xmark',
    double? closeButtonSize,
    Color? closeButtonColor,
    // Item styling
    Color? itemBackgroundColor,
    Color? itemTextColor,
    Color? itemTintColor,
    BaseParam? baseParam,
  }) async {
    final param = baseParam ?? BaseParam();
    
    // Determine if we should use Cupertino or Material implementation
    final useCupertino = param.forceUseCupertino || 
                        (!param.forceUseMaterial && _shouldUseCupertino());
    
    if (useCupertino) {
      return await _CNNativeSheetCupertino.showWithCustomHeader(
        context: context,
        title: title,
        message: message,
        items: items,
        detents: detents,
        prefersGrabberVisible: prefersGrabberVisible,
        isModal: isModal,
        prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
        widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
        preferredCornerRadius: preferredCornerRadius,
        headerTitleSize: headerTitleSize,
        headerTitleWeight: headerTitleWeight,
        headerTitleColor: headerTitleColor,
        headerHeight: headerHeight,
        headerBackgroundColor: headerBackgroundColor,
        showHeaderDivider: showHeaderDivider,
        headerDividerColor: headerDividerColor,
        closeButtonPosition: closeButtonPosition,
        closeButtonIcon: closeButtonIcon,
        closeButtonSize: closeButtonSize,
        closeButtonColor: closeButtonColor,
        itemBackgroundColor: itemBackgroundColor,
        itemTextColor: itemTextColor,
        itemTintColor: itemTintColor,
      );
    } else {
      return await _CNNativeSheetMaterial.showWithCustomHeader(
        context: context,
        title: title,
        message: message,
        items: items,
        detents: detents,
        prefersGrabberVisible: prefersGrabberVisible,
        isModal: isModal,
        prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
        widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
        preferredCornerRadius: preferredCornerRadius,
        headerTitleSize: headerTitleSize,
        headerTitleWeight: headerTitleWeight,
        headerTitleColor: headerTitleColor,
        headerHeight: headerHeight,
        headerBackgroundColor: headerBackgroundColor,
        showHeaderDivider: showHeaderDivider,
        headerDividerColor: headerDividerColor,
        closeButtonPosition: closeButtonPosition,
        closeButtonIcon: closeButtonIcon,
        closeButtonSize: closeButtonSize,
        closeButtonColor: closeButtonColor,
        itemBackgroundColor: itemBackgroundColor,
        itemTextColor: itemTextColor,
        itemTintColor: itemTintColor,
      );
    }
  }

  /// Helper method to determine if Cupertino should be used
  static bool _shouldUseCupertino() {
    if (kIsWeb) return false;
    
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
      default:
        return false;
    }
  }
}

/// Cupertino implementation using native UISheetPresentationController
class _CNNativeSheetCupertino {
  static const MethodChannel _channel = MethodChannel('cupertino_native_sheet');
  static const MethodChannel _customChannel = MethodChannel('cupertino_native_custom_sheet');

  /// Shows a native sheet with the given content.
  /// 
  /// Uses native UISheetPresentationController for rendering. All items are
  /// rendered as native UIKit components for optimal performance and true
  /// nonmodal behavior.
  static Future<int?> show({
    required BuildContext context,
    String? title,
    String? message,
    List<CNSheetItem> items = const [],
    List<CNSheetDetent> detents = const [CNSheetDetent.large],
    bool prefersGrabberVisible = true,
    bool isModal = true,
    bool prefersEdgeAttachedInCompactHeight = false,
    bool widthFollowsPreferredContentSizeWhenEdgeAttached = false,
    double? preferredCornerRadius,
    Color? itemBackgroundColor,
    Color? itemTextColor,
    Color? itemTintColor,
  }) async {
    try {
      final result = await _channel.invokeMethod('showSheet', {
        'title': title,
        'message': message,
        'items': items.map((item) => item.toMap()).toList(),
        'detents': detents.map((d) => d.toMap()).toList(),
        'prefersGrabberVisible': prefersGrabberVisible,
        'isModal': isModal,
        'prefersEdgeAttachedInCompactHeight': prefersEdgeAttachedInCompactHeight,
        'widthFollowsPreferredContentSizeWhenEdgeAttached': widthFollowsPreferredContentSizeWhenEdgeAttached,
        'preferredCornerRadius': preferredCornerRadius,
        if (itemBackgroundColor != null) 'itemBackgroundColor': itemBackgroundColor.value,
        if (itemTextColor != null) 'itemTextColor': itemTextColor.value,
        if (itemTintColor != null) 'itemTintColor': itemTintColor.value,
      });
      
      if (result is Map) {
        return result['selectedIndex'] as int?;
      }
      return null;
    } catch (e) {
      debugPrint('Error showing native sheet: $e');
      return null;
    }
  }

  /// Shows a native sheet with custom header (title + close button).
  static Future<int?> showWithCustomHeader({
    required BuildContext context,
    required String title,
    String? message,
    List<CNSheetItem> items = const [],
    List<CNSheetDetent> detents = const [CNSheetDetent.large],
    bool prefersGrabberVisible = true,
    bool isModal = true,
    bool prefersEdgeAttachedInCompactHeight = false,
    bool widthFollowsPreferredContentSizeWhenEdgeAttached = false,
    double? preferredCornerRadius,
    // Header styling
    double? headerTitleSize,
    FontWeight? headerTitleWeight,
    Color? headerTitleColor,
    double? headerHeight,
    Color? headerBackgroundColor,
    bool showHeaderDivider = true,
    Color? headerDividerColor,
    String closeButtonPosition = 'trailing',
    String closeButtonIcon = 'xmark',
    double? closeButtonSize,
    Color? closeButtonColor,
    // Item styling
    Color? itemBackgroundColor,
    Color? itemTextColor,
    Color? itemTintColor,
  }) async {
    try {
      final result = await _customChannel.invokeMethod('showSheet', {
        'title': title,
        'message': message,
        'items': items.map((item) => item.toMap()).toList(),
        'detents': detents.map((d) => d.toMap()).toList(),
        'prefersGrabberVisible': prefersGrabberVisible,
        'isModal': isModal,
        'prefersEdgeAttachedInCompactHeight': prefersEdgeAttachedInCompactHeight,
        'widthFollowsPreferredContentSizeWhenEdgeAttached': widthFollowsPreferredContentSizeWhenEdgeAttached,
        'preferredCornerRadius': preferredCornerRadius,
        // Header styling parameters
        if (headerTitleSize != null) 'headerTitleSize': headerTitleSize,
        if (headerTitleWeight != null) 'headerTitleWeight': _fontWeightToString(headerTitleWeight),
        if (headerTitleColor != null) 'headerTitleColor': headerTitleColor.value,
        if (headerHeight != null) 'headerHeight': headerHeight,
        if (headerBackgroundColor != null) 'headerBackgroundColor': headerBackgroundColor.value,
        'showHeaderDivider': showHeaderDivider,
        if (headerDividerColor != null) 'headerDividerColor': headerDividerColor.value,
        'closeButtonPosition': closeButtonPosition,
        'closeButtonIcon': closeButtonIcon,
        if (closeButtonSize != null) 'closeButtonSize': closeButtonSize,
        if (closeButtonColor != null) 'closeButtonColor': closeButtonColor.value,
        // Item styling parameters
        if (itemBackgroundColor != null) 'itemBackgroundColor': itemBackgroundColor.value,
        if (itemTextColor != null) 'itemTextColor': itemTextColor.value,
        if (itemTintColor != null) 'itemTintColor': itemTintColor.value,
      });
      
      if (result is Map) {
        return result['selectedIndex'] as int?;
      }
      return null;
    } catch (e) {
      debugPrint('Error showing native custom header sheet: $e');
      return null;
    }
  }

  // Helper to convert FontWeight to string for native side
  static String _fontWeightToString(FontWeight weight) {
    if (weight == FontWeight.w100) return 'ultraLight';
    if (weight == FontWeight.w200) return 'thin';
    if (weight == FontWeight.w300) return 'light';
    if (weight == FontWeight.w400) return 'regular';
    if (weight == FontWeight.w500) return 'medium';
    if (weight == FontWeight.w600) return 'semibold';
    if (weight == FontWeight.w700) return 'bold';
    if (weight == FontWeight.w800) return 'heavy';
    if (weight == FontWeight.w900) return 'black';
    return 'regular';
  }
}

/// Material implementation using bottom sheets
class _CNNativeSheetMaterial {
  /// Shows a Material bottom sheet with the given content.
  static Future<int?> show({
    required BuildContext context,
    String? title,
    String? message,
    List<CNSheetItem> items = const [],
    List<CNSheetDetent> detents = const [CNSheetDetent.large],
    bool prefersGrabberVisible = true,
    bool isModal = true,
    bool prefersEdgeAttachedInCompactHeight = false,
    bool widthFollowsPreferredContentSizeWhenEdgeAttached = false,
    double? preferredCornerRadius,
    Color? itemBackgroundColor,
    Color? itemTextColor,
    Color? itemTintColor,
  }) async {
    final theme = Theme.of(context);
    
    int? selectedIndex;
    
    await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.bottomSheetTheme.backgroundColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(preferredCornerRadius ?? 20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Grabber handle (if enabled)
            if (prefersGrabberVisible)
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            
            // Title and message
            if (title != null || message != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (title != null)
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (title != null && message != null)
                      const SizedBox(height: 8),
                    if (message != null)
                      Text(
                        message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            
            // Items
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              
              return ListTile(
                title: Text(
                  item.title ?? '',
                  style: TextStyle(
                    color: itemTextColor ?? theme.colorScheme.onSurface,
                  ),
                ),
                leading: item.icon != null
                  ? Icon(
                      _getIconData(item.icon!),
                      color: itemTintColor ?? theme.colorScheme.primary,
                    )
                  : null,
                onTap: () {
                  selectedIndex = index;
                  if (item.dismissOnTap) {
                    Navigator.of(context).pop();
                  }
                },
                tileColor: itemBackgroundColor,
              );
            }).toList(),
            
            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
    
    return selectedIndex;
  }

  /// Shows a Material bottom sheet with custom header.
  static Future<int?> showWithCustomHeader({
    required BuildContext context,
    required String title,
    String? message,
    List<CNSheetItem> items = const [],
    List<CNSheetDetent> detents = const [CNSheetDetent.large],
    bool prefersGrabberVisible = true,
    bool isModal = true,
    bool prefersEdgeAttachedInCompactHeight = false,
    bool widthFollowsPreferredContentSizeWhenEdgeAttached = false,
    double? preferredCornerRadius,
    // Header styling
    double? headerTitleSize,
    FontWeight? headerTitleWeight,
    Color? headerTitleColor,
    double? headerHeight,
    Color? headerBackgroundColor,
    bool showHeaderDivider = true,
    Color? headerDividerColor,
    String closeButtonPosition = 'trailing',
    String closeButtonIcon = 'xmark',
    double? closeButtonSize,
    Color? closeButtonColor,
    // Item styling
    Color? itemBackgroundColor,
    Color? itemTextColor,
    Color? itemTintColor,
  }) async {
    final theme = Theme.of(context);
    
    int? selectedIndex;
    
    await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: headerBackgroundColor ?? theme.bottomSheetTheme.backgroundColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(preferredCornerRadius ?? 20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Grabber handle (if enabled)
            if (prefersGrabberVisible)
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            
            // Custom header
            Container(
              height: headerHeight ?? 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: headerBackgroundColor ?? theme.colorScheme.surface,
                border: showHeaderDivider
                  ? Border(
                      bottom: BorderSide(
                        color: headerDividerColor ?? theme.dividerColor,
                        width: 1,
                      ),
                    )
                  : null,
              ),
              child: Row(
                children: [
                  if (closeButtonPosition == 'leading')
                    IconButton(
                      icon: Icon(
                        _getCloseIcon(closeButtonIcon),
                        size: closeButtonSize ?? 17,
                        color: closeButtonColor ?? theme.colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: headerTitleSize ?? 20,
                        fontWeight: headerTitleWeight ?? FontWeight.w600,
                        color: headerTitleColor ?? theme.colorScheme.onSurface,
                      ),
                      textAlign: closeButtonPosition == 'leading' 
                        ? TextAlign.center 
                        : TextAlign.left,
                    ),
                  ),
                  
                  if (closeButtonPosition == 'trailing')
                    IconButton(
                      icon: Icon(
                        _getCloseIcon(closeButtonIcon),
                        size: closeButtonSize ?? 17,
                        color: closeButtonColor ?? theme.colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                ],
              ),
            ),
            
            // Message (if provided)
            if (message != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            // Items
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              
              return ListTile(
                title: Text(
                  item.title ?? '',
                  style: TextStyle(
                    color: itemTextColor ?? theme.colorScheme.onSurface,
                  ),
                ),
                leading: item.icon != null
                  ? Icon(
                      _getIconData(item.icon!),
                      color: itemTintColor ?? theme.colorScheme.primary,
                    )
                  : null,
                onTap: () {
                  selectedIndex = index;
                  if (item.dismissOnTap) {
                    Navigator.of(context).pop();
                  }
                },
                tileColor: itemBackgroundColor,
              );
            }).toList(),
            
            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
    
    return selectedIndex;
  }

  // Helper to map SF Symbol names to Material icons
  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'sun.max':
        return Icons.wb_sunny;
      case 'moon':
        return Icons.brightness_2;
      case 'bold':
        return Icons.format_bold;
      case 'italic':
        return Icons.format_italic;
      case 'underline':
        return Icons.format_underlined;
      case 'textformat':
        return Icons.text_format;
      case 'paintbrush':
        return Icons.brush;
      case 'photo':
        return Icons.photo;
      case 'camera':
        return Icons.camera_alt;
      case 'gear':
        return Icons.settings;
      case 'bell':
        return Icons.notifications;
      case 'heart':
        return Icons.favorite;
      case 'star':
        return Icons.star;
      case 'bookmark':
        return Icons.bookmark;
      case 'share':
        return Icons.share;
      case 'trash':
        return Icons.delete;
      case 'folder':
        return Icons.folder;
      case 'doc':
        return Icons.description;
      case 'link':
        return Icons.link;
      case 'plus':
        return Icons.add;
      case 'minus':
        return Icons.remove;
      case 'checkmark':
        return Icons.check;
      case 'xmark':
        return Icons.close;
      default:
        return Icons.circle;
    }
  }

  // Helper to map close button icon names
  static IconData _getCloseIcon(String iconName) {
    switch (iconName) {
      case 'xmark':
        return Icons.close;
      case 'multiply':
        return Icons.clear;
      case 'arrow.down':
        return Icons.keyboard_arrow_down;
      default:
        return Icons.close;
    }
  }
}

/// Legacy CNNativeSheet class for backward compatibility
/// 
/// This maintains the original API while delegating to BaseCNNativeSheet
/// for actual implementation.
class CNNativeSheet {
  /// Shows a native sheet with the given content.
  /// 
  /// Uses native UISheetPresentationController for rendering. All items are
  /// rendered as native UIKit components for optimal performance and true
  /// nonmodal behavior.
  static Future<int?> show({
    required BuildContext context,
    String? title,
    String? message,
    List<CNSheetItem> items = const [],
    List<CNSheetDetent> detents = const [CNSheetDetent.large],
    bool prefersGrabberVisible = true,
    bool isModal = true,
    bool prefersEdgeAttachedInCompactHeight = false,
    bool widthFollowsPreferredContentSizeWhenEdgeAttached = false,
    double? preferredCornerRadius,
    Color? itemBackgroundColor,
    Color? itemTextColor,
    Color? itemTintColor,
  }) async {
    return await BaseCNNativeSheet.show(
      context: context,
      title: title,
      message: message,
      items: items,
      detents: detents,
      prefersGrabberVisible: prefersGrabberVisible,
      isModal: isModal,
      prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
      widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
      preferredCornerRadius: preferredCornerRadius,
      itemBackgroundColor: itemBackgroundColor,
      itemTextColor: itemTextColor,
      itemTintColor: itemTintColor,
    );
  }

  /// Shows a native sheet with custom header (title + close button).
  static Future<int?> showWithCustomHeader({
    required BuildContext context,
    required String title,
    String? message,
    List<CNSheetItem> items = const [],
    List<CNSheetDetent> detents = const [CNSheetDetent.large],
    bool prefersGrabberVisible = true,
    bool isModal = true,
    bool prefersEdgeAttachedInCompactHeight = false,
    bool widthFollowsPreferredContentSizeWhenEdgeAttached = false,
    double? preferredCornerRadius,
    // Header styling
    double? headerTitleSize,
    FontWeight? headerTitleWeight,
    Color? headerTitleColor,
    double? headerHeight,
    Color? headerBackgroundColor,
    bool showHeaderDivider = true,
    Color? headerDividerColor,
    String closeButtonPosition = 'trailing',
    String closeButtonIcon = 'xmark',
    double? closeButtonSize,
    Color? closeButtonColor,
    // Item styling
    Color? itemBackgroundColor,
    Color? itemTextColor,
    Color? itemTintColor,
  }) async {
    return await BaseCNNativeSheet.showWithCustomHeader(
      context: context,
      title: title,
      message: message,
      items: items,
      detents: detents,
      prefersGrabberVisible: prefersGrabberVisible,
      isModal: isModal,
      prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
      widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
      preferredCornerRadius: preferredCornerRadius,
      headerTitleSize: headerTitleSize,
      headerTitleWeight: headerTitleWeight,
      headerTitleColor: headerTitleColor,
      headerHeight: headerHeight,
      headerBackgroundColor: headerBackgroundColor,
      showHeaderDivider: showHeaderDivider,
      headerDividerColor: headerDividerColor,
      closeButtonPosition: closeButtonPosition,
      closeButtonIcon: closeButtonIcon,
      closeButtonSize: closeButtonSize,
      closeButtonColor: closeButtonColor,
      itemBackgroundColor: itemBackgroundColor,
      itemTextColor: itemTextColor,
      itemTintColor: itemTintColor,
    );
  }
}