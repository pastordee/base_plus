import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

// Re-export CNPullDownButtonAnchor and related classes for convenience
export 'package:cupertino_native/cupertino_native.dart' 
    show CNPullDownButtonAnchor, CNPullDownMenuEntry, CNPullDownMenuItem, 
         CNPullDownMenuDivider, CNSymbol, CNButtonStyle;

/// Base wrapper for CNPullDownButtonAnchor with cross-platform support
/// 
/// Provides a native iOS pull-down button with automatic menu anchoring.
/// The menu appears anchored to the button with an arrow pointing to it.
/// 
/// Uses CNPullDownButtonAnchor from cupertino_native on iOS, and PopupMenuButton on Android/other platforms.
/// 
/// Features:
/// - Native UIButton with UIMenu for authentic iOS behavior
/// - Anchors pull-down menu to CNButton styles
/// - Supports all CNButtonStyle options (plain, gray, tinted, filled, bordered, glass)
/// - Custom tint colors for themed buttons
/// - Optional menu title displayed at top of menu
/// - Icon-only buttons with customizable size
/// - Alignment control for menu positioning
/// - Material Design popup menu fallback
/// 
/// Example usage:
/// ```dart
/// BaseCNPullDownButtonAnchor.icon(
///   buttonIcon: const CNSymbol('ellipsis.circle'),
///   buttonStyle: CNButtonStyle.gray,
///   items: const [
///     CNPullDownMenuItem(
///       label: 'Settings',
///       icon: CNSymbol('gear'),
///     ),
///     CNPullDownMenuItem(
///       label: 'Help',
///       icon: CNSymbol('questionmark.circle'),
///     ),
///   ],
///   onSelected: (index) {
///     print('Selected: $index');
///   },
/// )
/// ```
class BaseCNPullDownButtonAnchor extends BaseStatelessWidget {
  /// Creates a text-labeled pull-down button with automatic anchoring
  const BaseCNPullDownButtonAnchor({
    Key? key,
    required this.buttonLabel,
    required this.items,
    required this.onSelected,
    this.tint,
    this.height = 44.0,
    this.width,
    this.buttonStyle = CNButtonStyle.plain,
    this.menuTitle,
    this.alignment = Alignment.center,
    BaseParam? baseParam,
  })  : buttonIcon = null,
        size = 44.0,
        super(key: key, baseParam: baseParam);

  /// Creates a round, icon-only pull-down button with automatic anchoring
  const BaseCNPullDownButtonAnchor.icon({
    Key? key,
    required this.buttonIcon,
    required this.items,
    required this.onSelected,
    this.tint,
    this.size = 44.0,
    this.buttonStyle = CNButtonStyle.glass,
    this.menuTitle,
    this.alignment = Alignment.center,
    BaseParam? baseParam,
  })  : buttonLabel = null,
        height = size,
        width = size,
        super(key: key, baseParam: baseParam);

  /// Text for the button (null when using icon mode)
  final String? buttonLabel;

  /// Icon for the button (non-null in icon mode)
  final CNSymbol? buttonIcon;

  /// Fixed width; if null, uses intrinsic width
  final double? width;

  /// Control height; icon mode uses diameter semantics
  final double height;

  /// Size for icon-only button variant
  final double size;

  /// Entries that populate the pull-down menu
  final List<CNPullDownMenuEntry> items;

  /// Called with the selected index when the user makes a selection
  final ValueChanged<int> onSelected;

  /// Tint color for the control
  final Color? tint;

  /// Visual style to apply to the button
  final CNButtonStyle buttonStyle;

  /// Optional title for the menu
  final String? menuTitle;

  /// Alignment of the button content
  final Alignment alignment;

  @override
  Widget buildByCupertino(BuildContext context) {
    // Use CNPullDownButtonAnchor directly from cupertino_native
    if (buttonIcon != null) {
      return CNPullDownButtonAnchor.icon(
        buttonIcon: buttonIcon!,
        items: items,
        onSelected: onSelected,
        tint: tint,
        size: size,
        buttonStyle: buttonStyle,
        menuTitle: menuTitle,
        alignment: alignment,
      );
    } else {
      return CNPullDownButtonAnchor(
        buttonLabel: buttonLabel!,
        items: items,
        onSelected: onSelected,
        tint: tint,
        height: height,
        width: width,
        buttonStyle: buttonStyle,
        menuTitle: menuTitle,
        alignment: alignment,
      );
    }
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final theme = Theme.of(context);
    
    return PopupMenuButton<int>(
      itemBuilder: (context) {
        final menuItems = <PopupMenuEntry<int>>[];
        int itemIndex = 0;
        
        for (final entry in items) {
          if (entry is CNPullDownMenuItem) {
            menuItems.add(
              PopupMenuItem<int>(
                value: itemIndex++,
                child: Row(
                  children: [
                    if (entry.icon != null) ...[
                      Icon(Icons.circle, size: 20, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                    ],
                    Text(entry.label),
                  ],
                ),
              ),
            );
          } else if (entry is CNPullDownMenuDivider) {
            menuItems.add(const PopupMenuDivider());
          }
        }
        
        return menuItems;
      },
      onSelected: onSelected,
      child: buttonIcon != null
          ? Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: _getBackgroundColor(theme),
                borderRadius: BorderRadius.circular(size / 2),
                border: buttonStyle == CNButtonStyle.bordered
                    ? Border.all(color: tint ?? theme.colorScheme.primary)
                    : null,
              ),
              child: Icon(
                Icons.more_horiz,
                color: _getIconColor(theme),
                size: size * 0.5,
              ),
            )
          : Container(
              height: height,
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getBackgroundColor(theme),
                borderRadius: BorderRadius.circular(8),
                border: buttonStyle == CNButtonStyle.bordered
                    ? Border.all(color: tint ?? theme.colorScheme.primary)
                    : null,
              ),
              child: Row(
                mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonLabel ?? '',
                    style: TextStyle(
                      color: _getTextColor(theme),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: _getTextColor(theme),
                    size: 20,
                  ),
                ],
              ),
            ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (buttonStyle) {
      case CNButtonStyle.plain:
        return Colors.transparent;
      case CNButtonStyle.gray:
        return theme.colorScheme.surfaceVariant;
      case CNButtonStyle.tinted:
        return (tint ?? theme.colorScheme.primary).withOpacity(0.1);
      case CNButtonStyle.filled:
        return tint ?? theme.colorScheme.primary;
      case CNButtonStyle.bordered:
        return Colors.transparent;
      case CNButtonStyle.glass:
      case CNButtonStyle.prominentGlass:
        return theme.colorScheme.surfaceVariant.withOpacity(0.5);
      default:
        return Colors.transparent;
    }
  }

  Color _getTextColor(ThemeData theme) {
    switch (buttonStyle) {
      case CNButtonStyle.filled:
        return theme.colorScheme.onPrimary;
      case CNButtonStyle.tinted:
        return tint ?? theme.colorScheme.primary;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  Color _getIconColor(ThemeData theme) {
    return _getTextColor(theme);
  }
}
