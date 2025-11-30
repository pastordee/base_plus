// ignore_for_file: avoid_classes_with_only_static_members

import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseNativeSheet - Cross-platform native sheet with iOS UISheetPresentationController support
/// 
/// Uses native iOS UISheetPresentationController for true native sheet presentation
/// with built-in liquid glass effects and native rendering.
/// Uses Material Design bottom sheets for Android and other platforms.
/// 
/// Features:
/// - Native iOS sheet presentation via UISheetPresentationController
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
/// final selectedIndex = await BaseNativeSheet.show(
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
/// await BaseNativeSheet.show(
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
/// await BaseNativeSheet.showWithCustomHeader(
///   context: context,
///   title: 'Format',
///   headerTitleWeight: FontWeight.w600,
///   items: [
///     CNSheetItem(title: 'Bold', icon: 'bold'),
///   ],
///   isModal: false,
/// );
/// ```
/// 
/// Updated: 2024.10.25 - Renamed from BaseCNNativeSheet for consistency
class BaseNativeSheet extends BaseStatelessWidget {
  /// Creates a base native sheet wrapper
  /// 
  /// This class is primarily used as a static interface and doesn't typically
  /// need to be instantiated as a widget.
  const BaseNativeSheet({
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
    void Function(int index)? onItemSelected,
    BaseParam? baseParam,
  }) async {
    final param = baseParam ?? BaseParam();
    
    // Determine if we should use Cupertino or Material implementation
    final useCupertino = param.forceUseCupertino || 
                        (!param.forceUseMaterial && _shouldUseCupertino());
    
    if (useCupertino) {
      // Delegate directly to cupertino_native's CNSheet
      return await CNSheet.show(
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
        onItemSelected: onItemSelected,
      );
    } else {
      return await _NativeSheetMaterial.show(
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
        onItemSelected: onItemSelected,
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
  /// - Supports inline action buttons (horizontal rows of buttons)
  /// - Supports item rows (side-by-side items with equal width)
  /// 
  /// **Example:**
  /// ```dart
  /// await BaseNativeSheet.showWithCustomHeader(
  ///   context: context,
  ///   title: 'Format',
  ///   headerTitleSize: 20,
  ///   headerTitleWeight: FontWeight.w600,
  ///   headerHeight: 56,
  ///   inlineActions: [
  ///     CNSheetInlineActions(
  ///       actions: [
  ///         CNSheetInlineAction(label: 'B', icon: 'bold', isToggled: true),
  ///         CNSheetInlineAction(label: 'I', icon: 'italic'),
  ///       ],
  ///     ),
  ///   ],
  ///   items: [
  ///     CNSheetItem(title: 'Bold', icon: 'bold'),
  ///     CNSheetItem(title: 'Italic', icon: 'italic'),
  ///   ],
  ///   onInlineActionSelected: (rowIndex, actionIndex) {
  ///     print('Inline action: row $rowIndex, action $actionIndex');
  ///   },
  ///   onItemSelected: (index) {
  ///     print('Item selected: $index');
  ///   },
  ///   detents: [CNSheetDetent.custom(280)],
  ///   isModal: false, // Nonmodal - can interact with background
  /// );
  /// ```
  /// 
  /// [context] - Build context for presentation
  /// [title] - Title displayed in the header (required for custom header)
  /// [subtitle] - Optional subtitle below the title in header
  /// [message] - Optional message below the header
  /// [items] - List of items to display (full width, vertical list)
  /// [itemRows] - List of item rows (side-by-side items with equal width)
  /// [inlineActions] - List of inline action button rows
  /// [detents] - Heights at which the sheet can rest
  /// [prefersGrabberVisible] - Whether to show the grabber handle
  /// [isModal] - Whether the sheet blocks background interaction
  /// 
  /// **Callbacks:**
  /// [onItemSelected] - Callback for when a vertical list item is tapped (receives index)
  /// [onInlineActionSelected] - Callback for inline action buttons (receives rowIndex, actionIndex)
  /// 
  /// **Header Styling Options:**
  /// [headerTitleSize] - Font size for the title (default: 20)
  /// [headerTitleWeight] - Font weight for the title (default: semibold/600)
  /// [headerTitleColor] - Color for the title (default: label color)
  /// [headerTitleAlignment] - Alignment of title: 'left', 'center', 'right' (default: 'left')
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
    String? subtitle,
    double? subtitleSize,
    Color? subtitleColor,
    String? message,
    List<CNSheetItem> items = const [],
    List<CNSheetItemRow> itemRows = const [],
    List<CNSheetInlineActions> inlineActions = const [],
    List<CNSheetDetent> detents = const [CNSheetDetent.large],
    bool prefersGrabberVisible = true,
    bool isModal = true,
    bool prefersEdgeAttachedInCompactHeight = false,
    bool widthFollowsPreferredContentSizeWhenEdgeAttached = false,
    double? preferredCornerRadius,
    // Callbacks
    void Function(int rowIndex, int actionIndex)? onInlineActionSelected,
    void Function(int index)? onItemSelected,
    void Function(int rowIndex, int itemIndex)? onItemRowSelected,
    
    // Header styling
    double? headerTitleSize,
    FontWeight? headerTitleWeight,
    Color? headerTitleColor,
    String headerTitleAlignment = 'left',
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
      return await CNSheet.showWithCustomHeader(
        context: context,
        title: title,
        subtitle: subtitle,
        subtitleSize: subtitleSize,
        subtitleColor: subtitleColor,
        message: message,
        items: items,
        itemRows: itemRows,
        inlineActions: inlineActions,
        detents: detents,
        prefersGrabberVisible: prefersGrabberVisible,
        isModal: isModal,
        prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
        widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
        preferredCornerRadius: preferredCornerRadius,
        onInlineActionSelected: onInlineActionSelected,
        onItemSelected: onItemSelected,
        onItemRowSelected: onItemRowSelected,
        headerTitleSize: headerTitleSize,
        headerTitleWeight: headerTitleWeight,
        headerTitleColor: headerTitleColor,
        headerTitleAlignment: headerTitleAlignment,
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
      return await _NativeSheetMaterial.showWithCustomHeader(
        context: context,
        title: title,
        subtitle: subtitle,
        subtitleSize: subtitleSize,
        subtitleColor: subtitleColor,
        message: message,
        items: items,
        itemRows: itemRows,
        inlineActions: inlineActions,
        detents: detents,
        prefersGrabberVisible: prefersGrabberVisible,
        isModal: isModal,
        prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
        widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
        preferredCornerRadius: preferredCornerRadius,
        onInlineActionSelected: onInlineActionSelected,
        onItemSelected: onItemSelected,
        onItemRowSelected: onItemRowSelected,
        headerTitleSize: headerTitleSize,
        headerTitleWeight: headerTitleWeight,
        headerTitleColor: headerTitleColor,
        headerTitleAlignment: headerTitleAlignment,
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

/// Material implementation as fallback for non-iOS platforms
class _NativeSheetMaterial {
  /// Shows a native sheet with the given content (Material fallback).
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
    void Function(int index)? onItemSelected,
  }) async {
    int? selectedIndex;
    final theme = Theme.of(context);
    
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
                      _MaterialSheetHelper._getIconData(item.icon!),
                      color: itemTintColor ?? theme.colorScheme.primary,
                    )
                  : null,
                onTap: () {
                  selectedIndex = index;
                  onItemSelected?.call(index);
                  if (item.dismissOnTap) {
                    Navigator.of(context).pop();
                  }
                },
                tileColor: itemBackgroundColor,
              );
            }).toList(),
            
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
    
    return selectedIndex;
  }

  /// Shows a native sheet with custom header (title + close button - Material fallback).
  static Future<int?> showWithCustomHeader({
    required BuildContext context,
    required String title,
    String? subtitle,
    double? subtitleSize,
    Color? subtitleColor,
    String? message,
    List<CNSheetItem> items = const [],
    List<CNSheetItemRow> itemRows = const [],
    List<CNSheetInlineActions> inlineActions = const [],
    List<CNSheetDetent> detents = const [CNSheetDetent.large],
    bool prefersGrabberVisible = true,
    bool isModal = true,
    bool prefersEdgeAttachedInCompactHeight = false,
    bool widthFollowsPreferredContentSizeWhenEdgeAttached = false,
    double? preferredCornerRadius,
    void Function(int rowIndex, int actionIndex)? onInlineActionSelected,
    void Function(int index)? onItemSelected,
    void Function(int rowIndex, int itemIndex)? onItemRowSelected,
    double? headerTitleSize,
    FontWeight? headerTitleWeight,
    Color? headerTitleColor,
    String headerTitleAlignment = 'left',
    double? headerHeight,
    Color? headerBackgroundColor,
    bool showHeaderDivider = true,
    Color? headerDividerColor,
    String closeButtonPosition = 'trailing',
    String closeButtonIcon = 'xmark',
    double? closeButtonSize,
    Color? closeButtonColor,
    Color? itemBackgroundColor,
    Color? itemTextColor,
    Color? itemTintColor,
  }) async {
    int? selectedIndex;
    final theme = Theme.of(context);
    
    await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      isDismissible: !isModal,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: headerBackgroundColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(preferredCornerRadius ?? 20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              
              // Header with title, subtitle, and close button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: headerBackgroundColor ?? theme.colorScheme.surface,
                  border: showHeaderDivider
                      ? Border(
                          bottom: BorderSide(
                            color: headerDividerColor ?? theme.colorScheme.outlineVariant,
                          ),
                        )
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: closeButtonPosition == 'leading' ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                  children: [
                    if (closeButtonPosition == 'leading')
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          _MaterialSheetHelper._getIconData(closeButtonIcon),
                          size: closeButtonSize ?? 24,
                          color: closeButtonColor ?? theme.colorScheme.onSurface,
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: closeButtonPosition == 'leading' ? const EdgeInsets.only(left: 16) : EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: headerTitleAlignment == 'center' ? CrossAxisAlignment.center : (headerTitleAlignment == 'right' ? CrossAxisAlignment.end : CrossAxisAlignment.start),
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: headerTitleSize ?? 18,
                                fontWeight: headerTitleWeight ?? FontWeight.bold,
                                color: headerTitleColor ?? theme.colorScheme.onSurface,
                              ),
                            ),
                            if (subtitle != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: subtitleSize ?? 14,
                                    color: subtitleColor ?? theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (closeButtonPosition == 'trailing')
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          _MaterialSheetHelper._getIconData(closeButtonIcon),
                          size: closeButtonSize ?? 24,
                          color: closeButtonColor ?? theme.colorScheme.onSurface,
                        ),
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
                        _MaterialSheetHelper._getIconData(item.icon!),
                        color: itemTintColor ?? theme.colorScheme.primary,
                      )
                    : null,
                  tileColor: itemBackgroundColor,
                  onTap: () {
                    selectedIndex = index;
                    onItemSelected?.call(index);
                    if (item.dismissOnTap) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              }).toList(),
              
              // Item Rows
              ...itemRows.asMap().entries.map((rowEntry) {
                final rowIndex = rowEntry.key;
                final row = rowEntry.value;
                return Wrap(
                  children: row.items.asMap().entries.map((itemEntry) {
                    final itemIndex = itemEntry.key;
                    final item = itemEntry.value;
                    return Expanded(
                      child: ListTile(
                        title: Text(
                          item.title ?? '',
                          style: TextStyle(
                            color: itemTextColor ?? theme.colorScheme.onSurface,
                          ),
                        ),
                        leading: item.icon != null
                          ? Icon(
                              _MaterialSheetHelper._getIconData(item.icon!),
                              color: itemTintColor ?? theme.colorScheme.primary,
                            )
                          : null,
                        tileColor: itemBackgroundColor,
                        onTap: () {
                          selectedIndex = rowIndex;
                          onItemRowSelected?.call(rowIndex, itemIndex);
                          if (item.dismissOnTap) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
              
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
      ),
    );
    
    return selectedIndex;
  }
}

/// Helper class for Material sheet icon mapping
class _MaterialSheetHelper {
  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'sun.max': return Icons.wb_sunny;
      case 'moon': return Icons.brightness_2;
      case 'bold': return Icons.format_bold;
      case 'italic': return Icons.format_italic;
      case 'underline': return Icons.format_underlined;
      case 'strikethrough': return Icons.strikethrough_s;
      case 'star': return Icons.star;
      case 'heart': return Icons.favorite;
      case 'bookmark': return Icons.bookmark;
      case 'pencil': return Icons.edit;
      case 'trash': return Icons.delete;
      case 'gear': return Icons.settings;
      default: return Icons.circle;
    }
  }
}
