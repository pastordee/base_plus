import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

// Re-export cupertino_native classes for convenience
export 'package:cupertino_native/cupertino_native.dart'
    show
        CNPullDownButton,
        CNPullDownMenuItem,
        CNPullDownMenuDivider,
        CNPullDownMenuInlineActions,
        CNPullDownInlineAction,
        CNPullDownMenuEntry,
        CNPullDownMenuSubmenu,
        CNSymbol,
        CNButtonStyle;

/// Base wrapper for CNPullDownButton with cross-platform support
/// 
/// Provides native iOS pull-down button with inline actions and menu items.
/// Falls back to Material PopupMenuButton on other platforms.
/// 
/// Uses CNPullDownButton from cupertino_native on iOS, and PopupMenuButton on Android/other platforms.
/// 
/// Features:
/// - Native iOS pull-down button (UIButton with pull-down menu)
/// - Inline action buttons (horizontal row of buttons at top of menu)
/// - Regular menu items with icons and labels
/// - Dividers for visual organization
/// - Destructive action styling
/// - Material Design popup menu fallback
/// 
/// Example usage:
/// ```dart
/// BaseCNPullDownButton.icon(
///   buttonIcon: CNSymbol('ellipsis.circle', size: 24),
///   size: 44,
///   items: [
///     // Inline actions row
///     CNPullDownMenuInlineActions(
///       actions: [
///         CNPullDownInlineAction(
///           label: 'Crop',
///           icon: CNSymbol('crop', size: 24),
///         ),
///         CNPullDownInlineAction(
///           label: 'Filter',
///           icon: CNSymbol('camera.filters', size: 24),
///         ),
///       ],
///     ),
///     CNPullDownMenuDivider(),
///     // Regular menu items
///     CNPullDownMenuItem(
///       label: 'Save',
///       icon: CNSymbol('square.and.arrow.down'),
///     ),
///     CNPullDownMenuItem(
///       label: 'Delete',
///       icon: CNSymbol('trash'),
///       isDestructive: true,
///     ),
///   ],
///   onSelected: (index) {
///     print('Menu item $index selected');
///   },
///   onInlineActionSelected: (index) {
///     print('Inline action $index selected');
///   },
/// )
/// ```
class BaseCNPullDownButton extends BaseStatelessWidget {
  const BaseCNPullDownButton({
    Key? key,
    required this.items,
    this.onSelected,
    this.onInlineActionSelected,
    this.buttonLabel,
    this.size = 44.0,
    this.enabled = true,
    BaseParam? baseParam,
  })  : buttonIcon = null,
        _isIconButton = false,
        super(key: key, baseParam: baseParam);

  /// Creates an icon-style pull-down button
  const BaseCNPullDownButton.icon({
    Key? key,
    required this.buttonIcon,
    this.size = 44.0,
    required this.items,
    this.onSelected,
    this.onInlineActionSelected,
    this.enabled = true,
    BaseParam? baseParam,
  })  : buttonLabel = null,
        _isIconButton = true,
        super(key: key, baseParam: baseParam);

  /// Icon for the button (icon style) - CNSymbol from cupertino_native
  final CNSymbol? buttonIcon;

  /// Label for the button (text style)
  final String? buttonLabel;

  /// Size of the button
  final double size;

  /// List of menu items and inline actions from cupertino_native
  /// Can contain CNPullDownMenuItem, CNPullDownMenuDivider, or CNPullDownMenuInlineActions
  final List<CNPullDownMenuEntry> items;

  /// Called when a regular menu item is selected
  final ValueChanged<int>? onSelected;

  /// Called when an inline action is selected
  final ValueChanged<int>? onInlineActionSelected;

  /// Whether the button is enabled
  final bool enabled;

  final bool _isIconButton;

  @override
  Widget buildByCupertino(BuildContext context) {
    // Use CNPullDownButton directly from cupertino_native
    if (_isIconButton && buttonIcon != null) {
      return CNPullDownButton.icon(
        buttonIcon: buttonIcon!,
        size: size,
        items: items,
        onSelected: onSelected ?? (_) {},
        onInlineActionSelected: onInlineActionSelected,
      );
    } else if (buttonLabel != null) {
      return CNPullDownButton(
        buttonLabel: buttonLabel!,
        items: items,
        onSelected: onSelected ?? (_) {},
        onInlineActionSelected: onInlineActionSelected,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    // Extract regular menu items (skip inline actions and dividers for Material fallback)
    final menuItems = <PopupMenuEntry<int>>[];
    int menuItemIndex = 0;
    
    for (final item in items) {
      if (item is CNPullDownMenuItem) {
        menuItems.add(
          PopupMenuItem<int>(
            value: menuItemIndex++,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(
                    _getIconData(item.icon!.name),
                    size: 20,
                    color: item.isDestructive 
                      ? Theme.of(context).colorScheme.error 
                      : null,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  item.label,
                  style: TextStyle(
                    color: item.isDestructive 
                      ? Theme.of(context).colorScheme.error 
                      : null,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (item is CNPullDownMenuDivider) {
        menuItems.add(const PopupMenuDivider());
      }
      // Skip CNPullDownMenuInlineActions for Material fallback
    }

    if (_isIconButton && buttonIcon != null) {
      return PopupMenuButton<int>(
        itemBuilder: (context) => menuItems,
        onSelected: (index) => onSelected?.call(index),
        enabled: enabled,
        icon: Icon(
          _getIconData(buttonIcon!.name),
          size: size * 0.5,
        ),
      );
    } else if (buttonLabel != null) {
      return PopupMenuButton<int>(
        itemBuilder: (context) => menuItems,
        onSelected: (index) => onSelected?.call(index),
        enabled: enabled,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(buttonLabel!),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // Helper to map SF Symbol names to Material icons
  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'ellipsis.circle':
        return Icons.more_horiz;
      case 'ellipsis':
        return Icons.more_vert;
      case 'crop':
        return Icons.crop;
      case 'camera.filters':
        return Icons.filter;
      case 'slider.horizontal.3':
        return Icons.tune;
      case 'square.and.arrow.down':
        return Icons.download;
      case 'doc.on.doc':
        return Icons.content_copy;
      case 'xmark.circle':
        return Icons.cancel;
      case 'trash':
        return Icons.delete;
      case 'pencil':
        return Icons.edit;
      case 'photo':
        return Icons.image;
      case 'camera':
        return Icons.camera_alt;
      case 'folder':
        return Icons.folder;
      case 'share':
        return Icons.share;
      case 'heart':
        return Icons.favorite;
      case 'star':
        return Icons.star;
      case 'bookmark':
        return Icons.bookmark;
      case 'gear':
        return Icons.settings;
      case 'bell':
        return Icons.notifications;
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
}
