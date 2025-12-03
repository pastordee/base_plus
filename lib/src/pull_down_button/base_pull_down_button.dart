import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// Abstract base class for all pull-down menu entries
/// Used for type safety in menu construction
abstract class BasePullDownMenuEntry {
  const BasePullDownMenuEntry();
  
  /// Convert to CNPullDownMenuEntry for iOS implementation
  CNPullDownMenuEntry toCNPullDownMenuEntry();
}

/// Regular menu item with icon, label, and optional callback
class BasePullDownMenuItem extends BasePullDownMenuEntry {
  const BasePullDownMenuItem({
    required this.label,
    this.icon,
    this.isDestructive = false,
  });

  final String label;
  final CNSymbol? icon;
  final bool isDestructive;

  @override
  CNPullDownMenuEntry toCNPullDownMenuEntry() {
    return CNPullDownMenuItem(
      label: label,
      icon: icon,
      isDestructive: isDestructive,
    );
  }
}

/// Menu divider for visual separation
class BasePullDownMenuDivider extends BasePullDownMenuEntry {
  const BasePullDownMenuDivider();

  @override
  CNPullDownMenuEntry toCNPullDownMenuEntry() {
    return CNPullDownMenuDivider();
  }
}

/// Inline action for horizontal button row at top of menu
class BasePullDownInlineAction {
  const BasePullDownInlineAction({
    required this.label,
    this.icon,
  });

  final String label;
  final CNSymbol? icon;

  /// Convert to CNPullDownInlineAction for iOS implementation
  CNPullDownInlineAction toCNPullDownInlineAction() {
    return CNPullDownInlineAction(
      label: label,
      icon: icon ?? CNSymbol('circle'), // Provide default if null
    );
  }
}

/// Container for inline actions (horizontal row of buttons)
class BasePullDownMenuInlineActions extends BasePullDownMenuEntry {
  const BasePullDownMenuInlineActions({
    required this.actions,
  });

  final List<BasePullDownInlineAction> actions;

  @override
  CNPullDownMenuEntry toCNPullDownMenuEntry() {
    return CNPullDownMenuInlineActions(
      actions: actions.map((action) => action.toCNPullDownInlineAction()).toList(),
    );
  }
}

/// Submenu with nested menu items
class BasePullDownMenuSubmenu extends BasePullDownMenuEntry {
  const BasePullDownMenuSubmenu({
    required this.title,
    this.subtitle,
    this.icon,
    required this.items,
  });

  final String title;
  final String? subtitle;
  final CNSymbol? icon;
  final List<BasePullDownMenuEntry> items;

  @override
  CNPullDownMenuEntry toCNPullDownMenuEntry() {
    return CNPullDownMenuSubmenu(
      title: title,
      subtitle: subtitle,
      icon: icon,
      items: items.map((item) => item.toCNPullDownMenuEntry()).toList(),
    );
  }
}

/// Internal: CN* classes from cupertino_native package
/// Used only for iOS platform channel communication
/// Public API should use Base* classes instead

/// BasePullDownButton - Cross-platform pull-down button with native iOS support
/// 
/// Uses CNPullDownButton (Cupertino Native) for iOS - provides native iOS pull-down button  
/// with inline actions, menu items, and submenus via UIButton with UIMenu.
/// Uses PopupMenuButton (Material) for Android with submenu support.
/// 
/// *** use cupertino = { forceUseMaterial: true } force use Material popup on iOS
/// *** use material = { forceUseCupertino: true } force use CNPullDownButton on Android
///
/// Features:
/// - Native iOS pull-down button via CNPullDownButton (cupertino_native package)
/// - Material Design popup menu with submenu support for Android
/// - Inline action buttons (horizontal row of buttons at top of menu)
/// - Regular menu items with icons and labels
/// - Submenus with nested menu items (BasePullDownMenuSubmenu)
/// - Dividers for visual organization
/// - Destructive action styling
/// - Built-in liquid glass effects on iOS (no manual wrapper needed)
/// - Automatic platform-specific conversion of menu entries
/// 
/// Example usage with submenu:
/// ```dart
/// BasePullDownButton.icon(
///   buttonIcon: CNSymbol('ellipsis.circle', size: 24),
///   size: 44,
///   items: [
///     // Inline actions row
///     BasePullDownMenuInlineActions(
///       actions: [
///         BasePullDownInlineAction(
///           label: 'Crop',
///           icon: CNSymbol('crop', size: 24),
///         ),
///         BasePullDownInlineAction(
///           label: 'Filter',
///           icon: CNSymbol('camera.filters', size: 24),
///         ),
///       ],
///     ),
///     BasePullDownMenuDivider(),
///     // Regular menu items
///     BasePullDownMenuItem(
///       label: 'Save',
///       icon: CNSymbol('square.and.arrow.down'),
///     ),
///     // Submenu with nested items
///     BasePullDownMenuSubmenu(
///       title: 'Attachment View',
///       icon: CNSymbol('paperclip'),
///       items: [
///         BasePullDownMenuItem(
///           label: 'Gallery View',
///           icon: CNSymbol('square.grid.2x2'),
///         ),
///         BasePullDownMenuItem(
///           label: 'List View',
///           icon: CNSymbol('list.bullet'),
///         ),
///       ],
///     ),
///     BasePullDownMenuDivider(),
///     BasePullDownMenuItem(
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
/// 
/// Updated: 2024.10.25 - Refactored to use Base* menu entry classes in public API
class BasePullDownButton extends BaseStatelessWidget {
  const BasePullDownButton({
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
  const BasePullDownButton.icon({
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

  /// List of menu items and inline actions
  /// Can contain BasePullDownMenuItem, BasePullDownMenuDivider, 
  /// BasePullDownMenuInlineActions, or BasePullDownMenuSubmenu
  final List<BasePullDownMenuEntry> items;

  /// Called when a regular menu item is selected
  final ValueChanged<int>? onSelected;

  /// Called when an inline action is selected
  final ValueChanged<int>? onInlineActionSelected;

  /// Whether the button is enabled
  final bool enabled;

  final bool _isIconButton;

  @override
  Widget buildByCupertino(BuildContext context) {
    // Convert BasePullDownMenuEntry to CNPullDownMenuEntry for iOS
    final cnItems = items.map((item) => item.toCNPullDownMenuEntry()).toList();
    
    // Use CNPullDownButton from cupertino_native
    if (_isIconButton && buttonIcon != null) {
      return CNPullDownButton.icon(
        buttonIcon: buttonIcon!,
        size: size,
        items: cnItems,
        onSelected: onSelected ?? (_) {},
        onInlineActionSelected: onInlineActionSelected,
      );
    } else if (buttonLabel != null) {
      return CNPullDownButton(
        buttonLabel: buttonLabel!,
        items: cnItems,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isIconButton && buttonIcon != null) {
      return PopupMenuButton<int>(
        itemBuilder: (context) => menuItems,
        onSelected: (index) => onSelected?.call(index),
        enabled: enabled,
        icon: Icon(
          _getIconData(buttonIcon!.name),
          size: size * 0.5,
          color: colorScheme.onSurfaceVariant,
        ),
        // Material 3 styling
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        surfaceTintColor: colorScheme.surfaceTint,
      );
    } else if (buttonLabel != null) {
      return PopupMenuButton<int>(
        itemBuilder: (context) => menuItems,
        onSelected: (index) => onSelected?.call(index),
        enabled: enabled,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                buttonLabel!,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        // Material 3 styling
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        surfaceTintColor: colorScheme.surfaceTint,
      );
    }
    return const SizedBox.shrink();
  }

  /// Recursively builds Material menu items from BasePullDownMenuEntry list
  /// Supports submenus, regular items, and dividers with Material 3 styling
  List<PopupMenuEntry<int>> _buildMaterialMenuItems(
    BuildContext context,
    List<BasePullDownMenuEntry> entries,
    _MenuItemIndexCounter indexCounter,
  ) {
    final menuItems = <PopupMenuEntry<int>>[];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    for (final entry in entries) {
      if (entry is BasePullDownMenuItem) {
        menuItems.add(
          PopupMenuItem<int>(
            value: indexCounter.next(),
            // Material 3 padding
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (entry.icon != null) ...[
                  Icon(
                    _getIconData(entry.icon!.name),
                    size: 20,
                    color: entry.isDestructive 
                      ? colorScheme.error 
                      : colorScheme.onSurface,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    entry.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: entry.isDestructive 
                        ? colorScheme.error 
                        : colorScheme.onSurface,
                      fontWeight: entry.isDestructive ? FontWeight.w500 : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (entry is BasePullDownMenuSubmenu) {
        // Create a submenu using PopupMenuButton nested inside PopupMenuItem
        menuItems.add(
          PopupMenuItem<int>(
            enabled: false, // Disable selection on the parent item
            padding: EdgeInsets.zero,
            child: PopupMenuButton<int>(
              offset: const Offset(0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              surfaceTintColor: colorScheme.surfaceTint,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    if (entry.icon != null) ...[
                      Icon(
                        _getIconData(entry.icon!.name),
                        size: 20,
                        color: colorScheme.onSurface,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          if (entry.subtitle != null)
                            Text(
                              entry.subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
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
      } else if (entry is BasePullDownMenuDivider) {
        menuItems.add(const PopupMenuDivider());
      }
      // Skip BasePullDownMenuInlineActions for Material fallback
    }
    
    return menuItems;
  }

  // Helper to map SF Symbol names to Material icons
  static IconData _getIconData(String iconName) {
    switch (iconName) {
      // Navigation
      case 'chevron.left':
        return Icons.chevron_left;
      case 'chevron.right':
        return Icons.chevron_right;
      case 'chevron.up':
        return Icons.keyboard_arrow_up;
      case 'chevron.down':
        return Icons.keyboard_arrow_down;
      case 'arrow.left':
        return Icons.arrow_back;
      case 'arrow.right':
        return Icons.arrow_forward;
      
      // Menu & Ellipsis
      case 'ellipsis.circle':
        return Icons.more_horiz;
      case 'ellipsis':
        return Icons.more_vert;
      
      // Image & Media
      case 'photo':
        return Icons.image;
      case 'camera':
        return Icons.camera_alt;
      case 'camera.filters':
        return Icons.filter;
      case 'crop':
        return Icons.crop;
      case 'play':
        return Icons.play_arrow;
      case 'pause':
        return Icons.pause;
      case 'stop':
        return Icons.stop;
      
      // File & Folder
      case 'doc':
        return Icons.insert_drive_file;
      case 'doc.on.doc':
        return Icons.content_copy;
      case 'folder':
        return Icons.folder;
      case 'folder.badge.plus':
        return Icons.create_new_folder;
      
      // Actions
      case 'square.and.arrow.up':
        return Icons.share;
      case 'square.and.arrow.down':
        return Icons.download;
      case 'pencil':
        return Icons.edit;
      case 'pencil.circle':
        return Icons.edit;
      case 'trash':
        return Icons.delete;
      case 'trash.circle':
        return Icons.delete_outline;
      case 'trash.fill':
        return Icons.delete;
      case 'xmark.circle':
        return Icons.cancel;
      case 'xmark':
        return Icons.close;
      case 'checkmark':
        return Icons.check;
      case 'checkmark.circle':
        return Icons.check_circle;
      
      // Favorites & Interactions
      case 'heart':
        return Icons.favorite_border;
      case 'heart.fill':
        return Icons.favorite;
      case 'star':
        return Icons.star_border;
      case 'star.fill':
        return Icons.star;
      case 'bookmark':
        return Icons.bookmark_border;
      case 'bookmark.fill':
        return Icons.bookmark;
      
      // Communication & Sharing
      case 'share':
        return Icons.share;
      case 'link':
        return Icons.link;
      case 'paperclip':
        return Icons.attach_file;
      case 'envelope':
        return Icons.email;
      case 'message':
        return Icons.message;
      case 'phone':
        return Icons.phone;
      
      // Settings & Options
      case 'gear':
        return Icons.settings;
      case 'gearshape':
        return Icons.settings;
      case 'slider.horizontal.3':
        return Icons.tune;
      case 'bell':
        return Icons.notifications;
      case 'bell.fill':
        return Icons.notifications_active;
      
      // Grid & List
      case 'square.grid.2x2':
        return Icons.grid_view;
      case 'list.bullet':
        return Icons.list;
      
      // Search & Find
      case 'magnifyingglass':
        return Icons.search;
      case 'magnifyingglass.circle':
        return Icons.search;
      
      // Text Formatting
      case 'bold':
        return Icons.format_bold;
      case 'italic':
        return Icons.format_italic;
      case 'underline':
        return Icons.format_underlined;
      case 'strikethrough':
        return Icons.strikethrough_s;
      
      // Time & Date
      case 'clock':
        return Icons.schedule;
      case 'calendar':
        return Icons.calendar_today;
      
      // Others
      case 'plus':
        return Icons.add;
      case 'plus.circle':
        return Icons.add_circle;
      case 'minus':
        return Icons.remove;
      case 'minus.circle':
        return Icons.remove_circle;
      
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
