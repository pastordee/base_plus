import 'package:material_ui/material_ui.dart';
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';
import '../icon/sf_symbol_fluent_icons.dart';
// Prefixed: fluent_ui re-exports the SDK's material library.
import 'package:fluent_ui/fluent_ui.dart' as fl;

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
    this.iconSize = 18.0,
    this.enabled = true,
    this.tooltip,
    this.useCNPopupMenuButton = true,
    BaseParam? baseParam,
  })  : _isIconButton = false,
        iconColor = null,
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
    this.iconSize = 18.0,
    this.enabled = true,
    this.tooltip,
    this.useCNPopupMenuButton = true,
    this.iconColor,
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

  /// Size of the icon itself (icon button). 18 is the default; a smaller one
  /// matches a row of compact controls, where 18 stood out.
  final double iconSize;

  /// Whether the button is enabled
  final bool enabled;

  /// Tooltip text for the button
  final String? tooltip;

  /// Use CNPopupMenuButton on iOS/macOS (default: true)
  /// Set to false to force Material PopupMenuButton on all platforms
  final bool useCNPopupMenuButton;

  /// The icon's colour on Material (the iOS menu is native and ignores it).
  /// Set it here rather than with an IconTheme around the button: the
  /// PopupMenuButton draws its icon through an IconButton, which takes its
  /// colour from the app bar's button theme and ignores the IconTheme above.
  final Color? iconColor;

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
        selected: item.selected,
        subtitle: item.subtitle,
      );
    }).toList();

    if (_isIconButton) {
      return CNPopupMenuButton.icon(
        buttonIcon: CNSymbol(
          valueOf('iosIcon', iosIcon) ?? 'ellipsis',
          size: valueOf('iconSize', iconSize),
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

  /// Windows (base_plus fluent mode, 2026-10-16): the button opens a Fluent
  /// MenuFlyout — Segoe Fluent icons, separators, the current choice ticked,
  /// disabled items greyed. Without a Fluent theme above it stays material.
  @override
  Widget buildByFluent(BuildContext context) {
    if (fl.FluentTheme.maybeOf(context) == null) {
      return _buildMaterialPopupMenu(context);
    }
    final String? _ios = valueOf('iosIcon', iosIcon);
    final IconData? _material = valueOf('materialIcon', materialIcon);
    return _FluentMenuButton(
      items: items,
      onSelected: valueOf('onSelected', onSelected),
      icon: _isIconButton
          ? (_ios != null
              ? sfSymbolToFluentIcon(_ios, fallback: _material ?? fl.FluentIcons.more)
              : (_material ?? fl.FluentIcons.more))
          : null,
      iconSize: valueOf('iconSize', iconSize),
      iconColor: valueOf('iconColor', iconColor),
      label: _isIconButton ? null : (valueOf('buttonLabel', buttonLabel) ?? 'Menu'),
      tooltip: valueOf('tooltip', tooltip),
      enabled: valueOf('enabled', enabled),
    );
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.label),
                      if (item.subtitle != null)
                        Text(
                          item.subtitle!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                if (item.selected) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.check, size: item.iconSize ?? 18),
                ],
              ],
            ),
          ),
        );
      }
    }

    if (_isIconButton) {
      return PopupMenuButton<int>(
        icon: Icon(
          valueOf('materialIcon', materialIcon),
          size: valueOf('iconSize', iconSize),
        ),
        iconColor: valueOf('iconColor', iconColor),
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
    this.selected = false,
    this.subtitle,
    this.children,
  }) : isDivider = false;

  /// Creates a divider item
  const BasePopupMenuItem.divider()
      : label = '',
        iconData = null,
        iosIcon = null,
        iconSize = null,
        enabled = true,
        selected = false,
        subtitle = null,
        children = null,
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

  /// Whether this item is the choice currently in effect.
  ///
  /// Shown as a checkmark on iOS. Use it in a menu of alternatives — text
  /// size, reading layout — so the menu says which one is already on rather
  /// than offering them all as if none were.
  final bool selected;

  /// A quieter second line under the label, saying what the item does.
  ///
  /// Shown natively on iOS 15+. Where a row cannot carry one it is ignored,
  /// so the label has to stand on its own either way.
  final String? subtitle;

  /// Whether this item is a divider
  final bool isDivider;

  /// When non-null, this item is a SUBMENU: tapping it opens a child menu
  /// (native chevron row) built from these entries. Honoured by the nav-bar
  /// popup/pull-down actions on iOS.
  final List<BasePopupMenuItem>? children;

  /// Whether this item opens a submenu.
  bool get hasChildren => children != null && children!.isNotEmpty;
}


/// The Fluent menu button: owns the [fl.FlyoutController] the flyout needs.
class _FluentMenuButton extends StatefulWidget {
  const _FluentMenuButton({
    required this.items,
    required this.onSelected,
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.label,
    required this.tooltip,
    required this.enabled,
  });

  final List<BasePopupMenuItem> items;
  final ValueChanged<int>? onSelected;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final String? label;
  final String? tooltip;
  final bool enabled;

  @override
  State<_FluentMenuButton> createState() => _FluentMenuButtonState();
}

class _FluentMenuButtonState extends State<_FluentMenuButton> {
  final fl.FlyoutController _flyout = fl.FlyoutController();

  @override
  void dispose() {
    _flyout.dispose();
    super.dispose();
  }

  IconData? _itemIcon(BasePopupMenuItem item) {
    if (item.iosIcon != null) {
      return sfSymbolToFluentIcon(item.iosIcon!, fallback: item.iconData ?? fl.FluentIcons.more);
    }
    return item.iconData;
  }

  List<fl.MenuFlyoutItemBase> _entries() => <fl.MenuFlyoutItemBase>[
        for (int i = 0; i < widget.items.length; i++)
          if (widget.items[i].isDivider)
            const fl.MenuFlyoutSeparator()
          else
            // Submenus (children) are shown as plain items here: nothing on
            // Windows uses them yet, and their selection has no index of its
            // own in onSelected.
            fl.MenuFlyoutItem(
              leading: _itemIcon(widget.items[i]) != null
                  ? Icon(_itemIcon(widget.items[i]), size: 16)
                  : null,
              text: widget.items[i].subtitle == null
                  ? Text(widget.items[i].label)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(widget.items[i].label),
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            widget.items[i].subtitle!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
              trailing: widget.items[i].selected
                  ? const Icon(fl.FluentIcons.check_mark, size: 12)
                  : null,
              selected: widget.items[i].selected,
              onPressed: widget.items[i].enabled
                  ? () => widget.onSelected?.call(i)
                  : null,
            ),
      ];

  void _open() {
    _flyout.showFlyout<void>(
      builder: (BuildContext context) => fl.MenuFlyout(items: _entries()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final VoidCallback? onPressed = widget.enabled ? _open : null;
    final Widget button = widget.icon != null
        ? fl.IconButton(
            icon: Icon(
              widget.icon,
              size: widget.iconSize != null
                  ? (widget.iconSize! < 18 ? widget.iconSize : 16)
                  : 16,
              color: widget.iconColor,
            ),
            onPressed: onPressed,
          )
        : fl.Button(
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(widget.label ?? 'Menu'),
                const SizedBox(width: 6),
                const Icon(fl.FluentIcons.chevron_down, size: 10),
              ],
            ),
          );
    return fl.FlyoutTarget(
      controller: _flyout,
      child: widget.tooltip != null
          ? fl.Tooltip(message: widget.tooltip!, child: button)
          : button,
    );
  }
}
