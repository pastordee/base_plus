import 'package:flutter/material.dart';
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// A cross-platform popup menu button that adapts to the platform
/// 
/// Uses CNPopupMenuButton on iOS/macOS for native appearance with SF Symbols
/// Uses Material PopupMenuButton on Android and other platforms
/// 
/// Example with icon button:
/// ```dart
/// BasePopupMenuButton.icon(
///   items: [
///     BasePopupMenuItem(label: 'Edit', iconData: Icons.edit),
///     BasePopupMenuItem(label: 'Delete', iconData: Icons.delete),
///   ],
///   onSelected: (index) => print('Selected item $index'),
///   iosIcon: 'ellipsis',
///   materialIcon: Icons.more_vert,
/// )
/// ```
/// 
/// Example with label button:
/// ```dart
/// BasePopupMenuButton(
///   buttonLabel: 'Actions',
///   items: [
///     BasePopupMenuItem(label: 'New File', iconData: Icons.insert_drive_file),
///     BasePopupMenuItem(label: 'New Folder', iconData: Icons.folder),
///   ],
///   onSelected: (index) => print('Selected item $index'),
/// )
/// ```
class BasePopupMenuButton extends BaseStatelessWidget {
  const BasePopupMenuButton({
    Key? key,
    required this.items,
    required this.onSelected,
    this.buttonLabel,
    this.materialIcon,
    this.iosIcon,
    this.buttonStyle,
    this.size = 44.0,
    this.enabled = true,
    this.tooltip,
    this.useCNPopupMenuButton = true,
    BaseParam? baseParam,
  })  : _isIconButton = false,
        super(key: key, baseParam: baseParam);

  /// Creates an icon-style popup menu button
  const BasePopupMenuButton.icon({
    Key? key,
    required this.items,
    required this.onSelected,
    this.materialIcon = Icons.more_vert,
    this.iosIcon = 'ellipsis',
    this.buttonStyle,
    this.size = 44.0,
    this.enabled = true,
    this.tooltip,
    this.useCNPopupMenuButton = true,
    BaseParam? baseParam,
  })  : buttonLabel = null,
        _isIconButton = true,
        super(key: key, baseParam: baseParam);

  /// List of menu items to display
  final List<BasePopupMenuItem> items;

  /// Called when a menu item is selected, provides the index
  final ValueChanged<int> onSelected;

  /// Label for the button (text style button)
  final String? buttonLabel;

  /// Material Design icon (used on Android)
  final IconData? materialIcon;

  /// iOS SF Symbol name (used on iOS/macOS)
  final String? iosIcon;

  /// Button style for CNPopupMenuButton (iOS only)
  /// Options: CNButtonStyle.plain, CNButtonStyle.glass, CNButtonStyle.filled
  final CNButtonStyle? buttonStyle;

  /// Size of the button (used for icon button)
  final double size;

  /// Whether the button is enabled
  final bool enabled;

  /// Tooltip text for the button
  final String? tooltip;

  /// Use CNPopupMenuButton on iOS/macOS (default: true)
  /// Set to false to force Material PopupMenuButton on all platforms
  final bool useCNPopupMenuButton;

  /// Internal flag to track if this is an icon button
  final bool _isIconButton;

  @override
  Widget buildByCupertino(BuildContext context) {
    if (!valueOf('useCNPopupMenuButton', useCNPopupMenuButton)) {
      return _buildMaterialPopupMenu(context);
    }

    // Convert BasePopupMenuItem to CNPopupMenuItem
    final cnItems = items.map((item) {
      if (item.isDivider) {
        return const CNPopupMenuDivider();
      }
      
      CNSymbol? icon;
      if (item.iosIcon != null) {
        icon = CNSymbol(item.iosIcon!, size: item.iconSize ?? 18);
      } else if (item.iconData != null) {
        // Try to map Material icon to SF Symbol
        final sfSymbol = _mapIconToSFSymbol(item.iconData);
        if (sfSymbol != null) {
          icon = CNSymbol(sfSymbol, size: item.iconSize ?? 18);
        }
      }

      return CNPopupMenuItem(
        label: item.label,
        icon: icon,
        enabled: item.enabled,
      );
    }).toList();

    if (_isIconButton) {
      return CNPopupMenuButton.icon(
        buttonIcon: CNSymbol(
          valueOf('iosIcon', iosIcon) ?? 'ellipsis',
          size: 18,
        ),
        size: valueOf('size', size),
        items: cnItems,
        onSelected: valueOf('onSelected', onSelected),
        buttonStyle: valueOf('buttonStyle', buttonStyle) ?? CNButtonStyle.plain,
      );
    } else {
      return CNPopupMenuButton(
        buttonLabel: valueOf('buttonLabel', buttonLabel) ?? 'Menu',
        items: cnItems,
        onSelected: valueOf('onSelected', onSelected),
        buttonStyle: valueOf('buttonStyle', buttonStyle) ?? CNButtonStyle.plain,
      );
    }
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    return _buildMaterialPopupMenu(context);
  }

  Widget _buildMaterialPopupMenu(BuildContext context) {
    final popupMenuItems = <PopupMenuEntry<int>>[];
    
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      
      if (item.isDivider) {
        popupMenuItems.add(const PopupMenuDivider());
      } else {
        popupMenuItems.add(
          PopupMenuItem<int>(
            value: i,
            enabled: item.enabled,
            child: Row(
              children: [
                if (item.iconData != null) ...[
                  Icon(
                    item.iconData,
                    size: item.iconSize ?? 18,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(item.label),
              ],
            ),
          ),
        );
      }
    }

    if (_isIconButton) {
      return PopupMenuButton<int>(
        icon: Icon(valueOf('materialIcon', materialIcon)),
        tooltip: valueOf('tooltip', tooltip),
        enabled: valueOf('enabled', enabled),
        itemBuilder: (context) => popupMenuItems,
        onSelected: (index) => valueOf('onSelected', onSelected)?.call(index),
      );
    } else {
      return PopupMenuButton<int>(
        tooltip: valueOf('tooltip', tooltip),
        enabled: valueOf('enabled', enabled),
        itemBuilder: (context) => popupMenuItems,
        onSelected: (index) => valueOf('onSelected', onSelected)?.call(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(valueOf('buttonLabel', buttonLabel) ?? 'Menu'),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      );
    }
  }

  /// Map common Material icons to SF Symbols
  String? _mapIconToSFSymbol(IconData? iconData) {
    if (iconData == null) return null;
    
    final Map<int, String> iconMap = {
      // Common actions
      0xe3c9: 'info.circle',         // Icons.info
      0xe3ca: 'info.circle.fill',    // Icons.info_outline
      0xe571: 'gearshape',           // Icons.settings
      0xe8b8: 'gearshape',           // Icons.settings_outlined
      0xe3e4: 'doc',                 // Icons.insert_drive_file
      0xe2c7: 'doc',                 // Icons.description
      0xe2c8: 'folder',              // Icons.folder
      0xe2c9: 'folder.fill',         // Icons.folder_open
      0xe14d: 'paperclip',           // Icons.attach_file
      0xe3af: 'ellipsis',            // Icons.more_horiz
      0xe3b0: 'ellipsis',            // Icons.more_vert
      0xe3c3: 'pencil',              // Icons.edit
      0xe1fe: 'trash',               // Icons.delete
      0xe1ff: 'trash.fill',          // Icons.delete_forever
      0xe145: 'plus.circle',         // Icons.add
      0xe15b: 'checkmark.circle',    // Icons.check_circle
      0xe5cd: 'xmark.circle',        // Icons.cancel
      0xe80d: 'square.and.arrow.up', // Icons.share
      0xe161: 'doc.on.doc',          // Icons.content_copy
      0xe14e: 'scissors',            // Icons.content_cut
      0xe14f: 'doc.on.clipboard',    // Icons.content_paste
      0xe5d4: 'arrow.clockwise',     // Icons.refresh
      0xe163: 'arrow.uturn.backward',// Icons.undo
      0xe15a: 'arrow.uturn.forward', // Icons.redo
      0xe8e8: 'star',                // Icons.star_border
      0xe838: 'star.fill',           // Icons.star
      0xe0e0: 'heart',               // Icons.favorite_border
      0xe87d: 'heart.fill',          // Icons.favorite
      0xe1b4: 'bookmark',            // Icons.bookmark_border
      0xe866: 'bookmark.fill',       // Icons.bookmark
    };

    return iconMap[iconData.codePoint];
  }
}

/// Data class representing a popup menu item
class BasePopupMenuItem {
  const BasePopupMenuItem({
    required this.label,
    this.iconData,
    this.iosIcon,
    this.iconSize,
    this.enabled = true,
  }) : isDivider = false;

  /// Creates a divider item
  const BasePopupMenuItem.divider()
      : label = '',
        iconData = null,
        iosIcon = null,
        iconSize = null,
        enabled = true,
        isDivider = true;

  /// Label text for the menu item
  final String label;

  /// Material Design icon
  final IconData? iconData;

  /// iOS SF Symbol name (overrides automatic mapping)
  final String? iosIcon;

  /// Size of the icon
  final double? iconSize;

  /// Whether the item is enabled
  final bool enabled;

  /// Whether this item is a divider
  final bool isDivider;
}
