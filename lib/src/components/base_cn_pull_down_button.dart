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
/// Provides native iOS pull-down button with inline actions, menu items, and submenus.
/// Falls back to Material PopupMenuButton on other platforms.
/// 
/// Uses CNPullDownButton from cupertino_native on iOS, and PopupMenuButton on Android/other platforms.
/// 
/// Features:
/// - Native iOS pull-down button (UIButton with pull-down menu)
/// - Inline action buttons (horizontal row of buttons at top of menu)
/// - Regular menu items with icons and labels
/// - Submenus with nested menu items (CNPullDownMenuSubmenu)
/// - Dividers for visual organization
/// - Destructive action styling
/// - Material Design popup menu fallback with submenu support
/// 
/// Example usage with submenu:
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
///     // Submenu with nested items
///     CNPullDownMenuSubmenu(
///       title: 'Attachment View',
///       icon: CNSymbol('paperclip'),
///       items: [
///         CNPullDownMenuItem(
///           label: 'Gallery View',
///           icon: CNSymbol('square.grid.2x2'),
///         ),
///         CNPullDownMenuItem(
///           label: 'List View',
///           icon: CNSymbol('list.bullet'),
///         ),
///       ],
///     ),
///     CNPullDownMenuDivider(),
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
    // Build menu items with submenu support for Material fallback
    final menuItemIndex = _MenuItemIndexCounter();
    final menuItems = _buildMaterialMenuItems(context, items, menuItemIndex);

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

  /// Recursively builds Material menu items from CNPullDownMenuEntry list
  /// Supports submenus, regular items, and dividers
  List<PopupMenuEntry<int>> _buildMaterialMenuItems(
    BuildContext context,
    List<CNPullDownMenuEntry> entries,
    _MenuItemIndexCounter indexCounter,
  ) {
    final menuItems = <PopupMenuEntry<int>>[];
    
    for (final entry in entries) {
      if (entry is CNPullDownMenuItem) {
        menuItems.add(
          PopupMenuItem<int>(
            value: indexCounter.next(),
            child: Row(
              children: [
                if (entry.icon != null) ...[
                  Icon(
                    _getIconData(entry.icon!.name),
                    size: 20,
                    color: entry.isDestructive 
                      ? Theme.of(context).colorScheme.error 
                      : null,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  entry.label,
                  style: TextStyle(
                    color: entry.isDestructive 
                      ? Theme.of(context).colorScheme.error 
                      : null,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (entry is CNPullDownMenuSubmenu) {
        // Create a submenu using PopupMenuButton nested inside PopupMenuItem
        menuItems.add(
          PopupMenuItem<int>(
            enabled: false, // Disable selection on the parent item
            padding: EdgeInsets.zero,
            child: PopupMenuButton<int>(
              offset: const Offset(0, 0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    if (entry.icon != null) ...[
                      Icon(
                        _getIconData(entry.icon!.name),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.title),
                          if (entry.subtitle != null)
                            Text(
                              entry.subtitle!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_right, size: 20),
                  ],
                ),
              ),
              itemBuilder: (context) => _buildMaterialMenuItems(
                context,
                entry.items,
                indexCounter,
              ),
              onSelected: (index) => onSelected?.call(index),
            ),
          ),
        );
      } else if (entry is CNPullDownMenuDivider) {
        menuItems.add(const PopupMenuDivider());
      }
      // Skip CNPullDownMenuInlineActions for Material fallback
    }
    
    return menuItems;
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
      case 'paperclip':
        return Icons.attach_file;
      case 'square.grid.2x2':
        return Icons.grid_view;
      case 'list.bullet':
        return Icons.list;
      default:
        return Icons.circle;
    }
  }
}

/// Helper class to track menu item indices across recursive submenu building
class _MenuItemIndexCounter {
  int _index = 0;
  
  int next() => _index++;
  
  int get current => _index;
}
