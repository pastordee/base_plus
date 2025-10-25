import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// Toolbar middle alignment options
enum BaseToolbarAlignment {
  leading,
  center,
  trailing,
}

/// Cross-platform toolbar action
/// 
/// Represents an action button in the toolbar with icon and/or label.
/// Also supports spacing actions for layout control.
/// 
/// Automatically converts to platform-specific formats:
/// - iOS: Uses CNToolbarAction with SF Symbols
/// - Material: Uses IconButton/TextButton with Material icons
class BaseToolbarAction {
  const BaseToolbarAction({
    this.icon,
    this.label,
    this.onPressed,
    this.padding,
    this.labelSize = 15,
    this.iconSize = 16,
  }) : popupMenuItems = null,
       onPopupMenuSelected = null,
       _isFixedSpace = false,
       _isFlexibleSpace = false,
       _usePopupMenuButton = false,
       _spaceWidth = null,
       assert(icon != null || label != null, 'Either icon or label must be provided');

  const BaseToolbarAction._fixedSpace(this._spaceWidth)
      : icon = null,
        label = null,
        onPressed = null,
        padding = null,
        labelSize = null,
        iconSize = null,
        popupMenuItems = null,
        onPopupMenuSelected = null,
        _isFixedSpace = true,
        _isFlexibleSpace = false,
        _usePopupMenuButton = false;

  const BaseToolbarAction._flexibleSpace()
      : icon = null,
        label = null,
        onPressed = null,
        padding = null,
        labelSize = null,
        iconSize = null,
        popupMenuItems = null,
        onPopupMenuSelected = null,
        _isFixedSpace = false,
        _isFlexibleSpace = true,
        _usePopupMenuButton = false,
        _spaceWidth = null;

  const BaseToolbarAction._popupMenu({
    required this.icon,
    required this.label,
    required this.popupMenuItems,
    required this.onPopupMenuSelected,
    this.padding,
    this.labelSize = 15,
    this.iconSize = 16,
    bool usePopupMenuButton = false,
  }) : onPressed = null,
       _isFixedSpace = false,
       _isFlexibleSpace = false,
       _usePopupMenuButton = usePopupMenuButton,
       _spaceWidth = null;

  /// Icon for the action (CNSymbol on iOS, Material icon elsewhere)
  final CNSymbol? icon;

  /// Optional text label
  final String? label;

  /// Callback when action is pressed
  final VoidCallback? onPressed;

  /// Padding around the action (iOS only)
  final double? padding;

  /// Label text size (iOS only)
  final double? labelSize;

  /// Icon size (iOS only)
  final double? iconSize;

  /// Popup menu items to display when the action is pressed
  final List<CNPopupMenuEntry>? popupMenuItems;

  /// Called when a popup menu item is selected
  final ValueChanged<int>? onPopupMenuSelected;

  /// Internal flag for fixed space action
  final bool _isFixedSpace;

  /// Internal flag for flexible space action
  final bool _isFlexibleSpace;

  /// Internal flag for popup menu button usage
  final bool _usePopupMenuButton;

  /// Internal space width
  final double? _spaceWidth;

  /// Creates a fixed space action
  factory BaseToolbarAction.fixedSpace(double width) {
    return BaseToolbarAction._fixedSpace(width);
  }

  /// Creates a flexible space action
  factory BaseToolbarAction.flexibleSpace() {
    return const BaseToolbarAction._flexibleSpace();
  }

  /// Creates a toolbar action with a popup menu
  factory BaseToolbarAction.popupMenu({
    CNSymbol? icon,
    String? label,
    required List<CNPopupMenuEntry> popupMenuItems,
    required ValueChanged<int> onPopupMenuSelected,
    double? padding,
    double? labelSize = 15,
    double? iconSize = 16,
  }) {
    return BaseToolbarAction._popupMenu(
      icon: icon,
      label: label,
      popupMenuItems: popupMenuItems,
      onPopupMenuSelected: onPopupMenuSelected,
      padding: padding,
      labelSize: labelSize,
      iconSize: iconSize,
      usePopupMenuButton: false,
    );
  }

  /// Creates a toolbar action with a CNPopupMenuButton
  factory BaseToolbarAction.popupMenuButton({
    CNSymbol? icon,
    String? label,
    required List<CNPopupMenuEntry> popupMenuItems,
    required ValueChanged<int> onPopupMenuSelected,
    double? padding,
    double? labelSize = 15,
    double? iconSize = 16,
  }) {
    return BaseToolbarAction._popupMenu(
      icon: icon,
      label: label,
      popupMenuItems: popupMenuItems,
      onPopupMenuSelected: onPopupMenuSelected,
      padding: padding,
      labelSize: labelSize,
      iconSize: iconSize,
      usePopupMenuButton: true,
    );
  }

  /// Check if this is a fixed space action
  bool get isFixedSpace => _isFixedSpace;

  /// Check if this is a flexible space action
  bool get isFlexibleSpace => _isFlexibleSpace;

  /// Get the space width (for fixed space actions)
  double? get spaceWidth => _spaceWidth;

  /// Convert to CNToolbarAction for iOS implementation
  CNToolbarAction toCNToolbarAction() {
    if (_isFixedSpace) {
      return CNToolbarAction.fixedSpace(_spaceWidth ?? 8);
    }
    if (_isFlexibleSpace) {
      return CNToolbarAction.flexibleSpace();
    }
    // Handle popup menu actions
    if (popupMenuItems != null && onPopupMenuSelected != null) {
      if (_usePopupMenuButton) {
        return CNToolbarAction.popupMenuButton(
          icon: icon,
          label: label,
          popupMenuItems: popupMenuItems!,
          onPopupMenuSelected: onPopupMenuSelected!,
          padding: padding,
          labelSize: labelSize,
          iconSize: iconSize,
        );
      } else {
        return CNToolbarAction.popupMenu(
          icon: icon,
          label: label,
          popupMenuItems: popupMenuItems!,
          onPopupMenuSelected: onPopupMenuSelected!,
          padding: padding,
          labelSize: labelSize,
          iconSize: iconSize,
        );
      }
    }
    // Regular action
    return CNToolbarAction(
      icon: icon,
      label: label,
      onPressed: onPressed,
      padding: padding,
      labelSize: labelSize,
      iconSize: iconSize,
    );
  }
}

/// Internal: CNToolbarAction from cupertino_native package
/// Used only for iOS platform channel communication
/// Public API should use BaseToolbarAction instead

/// BaseToolbar - Cross-platform toolbar with native iOS support
/// 
/// Uses CNToolbar (Cupertino Native) for iOS - provides true native iOS appearance
/// with built-in liquid glass effects and native rendering.
/// Uses Material AppBar-style toolbar for Android and other platforms.
/// 
/// *** use cupertino = { forceUseMaterial: true } force use Material toolbar on iOS
/// *** use material = { forceUseCupertino: true } force use CNToolbar on Android
///
/// Features:
/// - Native iOS toolbar via CNToolbar (cupertino_native package)
/// - Material Design toolbar for Android
/// - Flexible leading, middle, and trailing actions
/// - Search functionality with expandable search field
/// - Built-in liquid glass effects on iOS (no manual wrapper needed)
/// - Automatic platform-specific conversion of actions
/// 
/// Example:
/// ```dart
/// BaseToolbar(
///   leading: [
///     BaseToolbarAction(
///       icon: CNSymbol('chevron.left'),
///       onPressed: () => Navigator.pop(context),
///     ),
///   ],
///   middle: [
///     BaseToolbarAction(
///       icon: CNSymbol('pencil', size: 40),
///       onPressed: () => print('Edit'),
///     ),
///   ],
///   trailing: [
///     BaseToolbarAction(
///       icon: CNSymbol('gear'),
///       onPressed: () => print('Settings'),
///     ),
///   ],
/// )
/// ```
/// 
/// For search functionality, use the factory constructor:
/// ```dart
/// BaseToolbar.search(
///   leading: [
///     BaseToolbarAction(icon: CNSymbol('star.fill'), onPressed: () {}),
///   ],
///   trailing: [
///     BaseToolbarAction(icon: CNSymbol('ellipsis.circle'), onPressed: () {}),
///   ],
///   searchConfig: CNSearchConfig(
///     placeholder: 'Search',
///     onSearchTextChanged: (text) => print(text),
///     resultsBuilder: (context, text) => SearchResults(text),
///   ),
///   contextIcon: CNSymbol('apps.iphone'),
/// )
/// ```
/// 
/// Updated: 2024.10.25 - Refactored to use BaseToolbarAction in public API
class BaseToolbar extends BaseStatelessWidget {
  const BaseToolbar({
    Key? key,
    this.leading,
    this.middle,
    this.trailing,
    this.title,
    this.tint,
    this.transparent = false,
    this.height,
    this.pillHeight,
    this.middleAlignment = BaseToolbarAlignment.center,
    this.backgroundColor,
    this.searchConfig,
    this.contextIcon,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// Factory constructor for search-enabled toolbar
  const BaseToolbar.search({
    Key? key,
    List<BaseToolbarAction>? leading,
    List<BaseToolbarAction>? trailing,
    required CNSearchConfig searchConfig,
    CNSymbol? contextIcon,
    Color? tint,
    bool transparent = false,
    double? height,
    double? pillHeight,
    Color? backgroundColor,
    BaseParam? baseParam,
  }) : this(
         key: key,
         leading: leading,
         trailing: trailing,
         searchConfig: searchConfig,
         contextIcon: contextIcon,
         tint: tint,
         transparent: transparent,
         height: height,
         pillHeight: pillHeight,
         backgroundColor: backgroundColor,
         baseParam: baseParam,
       );

  /// Leading toolbar actions (typically back button, share)
  final List<BaseToolbarAction>? leading;

  /// Middle toolbar actions (main actions)
  final List<BaseToolbarAction>? middle;

  /// Trailing toolbar actions (typically settings, more)
  final List<BaseToolbarAction>? trailing;

  /// Optional title text
  final String? title;

  /// Tint color for icons and text
  final Color? tint;

  /// Whether the toolbar should be transparent with blur effect
  final bool transparent;

  /// Custom toolbar height
  final double? height;

  /// Custom pill button height (iOS only)
  final double? pillHeight;

  /// Alignment for middle section
  final BaseToolbarAlignment middleAlignment;

  /// Background color (Material only)
  final Color? backgroundColor;

  /// Search configuration for search-enabled toolbar
  final CNSearchConfig? searchConfig;

  /// Context icon for search toolbar
  final CNSymbol? contextIcon;

  @override
  Widget buildByCupertino(BuildContext context) {
    // Convert our alignment to CNToolbarMiddleAlignment
    final alignment = _toCNToolbarAlignment(valueOf('middleAlignment', middleAlignment));
    
    // Convert BaseToolbarAction to CNToolbarAction for iOS
    final leadingActions = valueOf('leading', leading);
    final middleActions = valueOf('middle', middle);
    final trailingActions = valueOf('trailing', trailing);
    
    List<CNToolbarAction>? cnLeading;
    List<CNToolbarAction>? cnMiddle;
    List<CNToolbarAction>? cnTrailing;
    
    if (leadingActions != null) {
      cnLeading = (leadingActions as List).map((action) => (action as BaseToolbarAction).toCNToolbarAction()).toList();
    }
    
    if (middleActions != null) {
      cnMiddle = (middleActions as List).map((action) => (action as BaseToolbarAction).toCNToolbarAction()).toList();
    }
    
    if (trailingActions != null) {
      cnTrailing = (trailingActions as List).map((action) => (action as BaseToolbarAction).toCNToolbarAction()).toList();
    }
    
    // Check if this is a search toolbar
    final searchConf = valueOf('searchConfig', searchConfig);
    if (searchConf != null) {
      return CNToolbar.search(
        leading: cnLeading,
        trailing: cnTrailing,
        searchConfig: searchConf,
        contextIcon: valueOf('contextIcon', contextIcon),
        tint: valueOf('tint', tint),
        transparent: valueOf('transparent', transparent),
        height: valueOf('height', height),
        pillHeight: valueOf('pillHeight', pillHeight),
      );
    }
    
    return CNToolbar(
      leading: cnLeading,
      middle: cnMiddle,
      trailing: cnTrailing,
      tint: valueOf('tint', tint),
      transparent: valueOf('transparent', transparent),
      height: valueOf('height', height),
      pillHeight: valueOf('pillHeight', pillHeight),
      middleAlignment: alignment,
    );
  }

  /// Convert BaseToolbarAlignment to CNToolbarMiddleAlignment
  CNToolbarMiddleAlignment _toCNToolbarAlignment(BaseToolbarAlignment alignment) {
    switch (alignment) {
      case BaseToolbarAlignment.leading:
        return CNToolbarMiddleAlignment.leading;
      case BaseToolbarAlignment.center:
        return CNToolbarMiddleAlignment.center;
      case BaseToolbarAlignment.trailing:
        return CNToolbarMiddleAlignment.trailing;
    }
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    // Build Material-style toolbar
    final bgColor = valueOf('backgroundColor', backgroundColor) ?? 
                    Theme.of(context).appBarTheme.backgroundColor ??
                    Theme.of(context).primaryColor;
    
    final tintColor = valueOf('tint', tint) ?? Colors.white;
    final toolbarHeight = valueOf('height', height) ?? 56.0;
    
    // Check if this is a search toolbar
    final searchConf = valueOf('searchConfig', searchConfig);
    if (searchConf != null) {
      return _buildMaterialSearchToolbar(context, bgColor, tintColor, toolbarHeight, searchConf);
    }
    
    return Container(
      height: toolbarHeight,
      color: valueOf('transparent', transparent) 
          ? Colors.transparent 
          : bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          // Leading actions
          if (valueOf('leading', leading) != null) ...[
            ..._buildMaterialActions(
              valueOf('leading', leading)!,
              tintColor,
            ),
            const SizedBox(width: 8),
          ],
          
          // Title or middle actions
          if (valueOf('title', title) != null)
            Expanded(
              child: Text(
                valueOf('title', title)!,
                style: TextStyle(
                  color: tintColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else if (valueOf('middle', middle) != null)
            Expanded(
              child: Row(
                mainAxisAlignment: _getMainAxisAlignment(
                  valueOf('middleAlignment', middleAlignment),
                ),
                children: _buildMaterialActions(
                  valueOf('middle', middle)!,
                  tintColor,
                ),
              ),
            )
          else
            const Spacer(),
          
          // Trailing actions
          if (valueOf('trailing', trailing) != null) ...[
            const SizedBox(width: 8),
            ..._buildMaterialActions(
              valueOf('trailing', trailing)!,
              tintColor,
            ),
          ],
        ],
      ),
    );
  }

  /// Build Material search toolbar
  Widget _buildMaterialSearchToolbar(
    BuildContext context,
    Color bgColor,
    Color tintColor,
    double toolbarHeight,
    CNSearchConfig searchConfig,
  ) {
    return Container(
      height: toolbarHeight,
      color: valueOf('transparent', transparent) 
          ? Colors.transparent 
          : bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          // Leading actions
          if (valueOf('leading', leading) != null) ...[
            ..._buildMaterialActions(
              valueOf('leading', leading)!,
              tintColor,
            ),
            const SizedBox(width: 8),
          ],
          
          // Search field
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: searchConfig.onSearchTextChanged,
                style: TextStyle(color: tintColor),
                decoration: InputDecoration(
                  hintText: searchConfig.placeholder,
                  hintStyle: TextStyle(color: tintColor.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.search, color: tintColor.withOpacity(0.7)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          ),
          
          // Trailing actions
          if (valueOf('trailing', trailing) != null) ...[
            const SizedBox(width: 8),
            ..._buildMaterialActions(
              valueOf('trailing', trailing)!,
              tintColor,
            ),
          ],
        ],
      ),
    );
  }

  /// Convert BaseToolbarAlignment to MainAxisAlignment
  MainAxisAlignment _getMainAxisAlignment(BaseToolbarAlignment alignment) {
    switch (alignment) {
      case BaseToolbarAlignment.leading:
        return MainAxisAlignment.start;
      case BaseToolbarAlignment.center:
        return MainAxisAlignment.center;
      case BaseToolbarAlignment.trailing:
        return MainAxisAlignment.end;
    }
  }
  List<Widget> _buildMaterialActions(
    List<BaseToolbarAction> actions,
    Color tintColor,
  ) {
    return actions.map((action) {
      // Handle special action types
      if (action.isFixedSpace) {
        // This is a fixed space action
        return SizedBox(width: action.spaceWidth ?? 8);
      }
      
      if (action.isFlexibleSpace) {
        // This is a flexible space action
        return const Expanded(child: SizedBox());
      }
      
      // Extract icon from CNSymbol if possible
      IconData? iconData;
      if (action.icon != null) {
        // Try to map SF Symbol to Material icon
        iconData = _mapSFSymbolToMaterialIcon(action.icon!.name);
      }
      
      if (action.label != null && iconData != null) {
        // Button with both icon and label
        return TextButton.icon(
          onPressed: action.onPressed,
          icon: Icon(iconData, color: tintColor, size: 20),
          label: Text(
            action.label!,
            style: TextStyle(color: tintColor, fontSize: 12),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 40),
          ),
        );
      } else if (action.label != null) {
        // Text-only button
        return TextButton(
          onPressed: action.onPressed,
          child: Text(
            action.label!,
            style: TextStyle(color: tintColor, fontSize: 14),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 40),
          ),
        );
      } else if (iconData != null) {
        // Icon-only button
        return IconButton(
          onPressed: action.onPressed,
          icon: Icon(iconData, color: tintColor),
          iconSize: action.icon?.size ?? 24,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
        );
      }
      
      // Fallback: just a small container
      return const SizedBox(width: 8);
    }).toList();
  }

  /// Map SF Symbol names to Material icons
  IconData? _mapSFSymbolToMaterialIcon(String sfSymbol) {
    final Map<String, IconData> iconMap = {
      // Navigation
      'chevron.left': Icons.chevron_left,
      'chevron.right': Icons.chevron_right,
      'chevron.up': Icons.keyboard_arrow_up,
      'chevron.down': Icons.keyboard_arrow_down,
      'arrow.left': Icons.arrow_back,
      'arrow.right': Icons.arrow_forward,
      
      // Actions
      'square.and.arrow.up': Icons.share,
      'square.and.arrow.down': Icons.download,
      'plus': Icons.add,
      'minus': Icons.remove,
      'xmark': Icons.close,
      'checkmark': Icons.check,
      
      // Common
      'gear': Icons.settings,
      'gearshape': Icons.settings,
      'ellipsis': Icons.more_horiz,
      'pencil': Icons.edit,
      'trash': Icons.delete,
      'star': Icons.star_border,
      'star.fill': Icons.star,
      'heart': Icons.favorite_border,
      'heart.fill': Icons.favorite,
      
      // Media
      'play': Icons.play_arrow,
      'pause': Icons.pause,
      'stop': Icons.stop,
      'backward': Icons.skip_previous,
      'forward': Icons.skip_next,
      
      // Communication
      'envelope': Icons.email,
      'phone': Icons.phone,
      'message': Icons.message,
      
      // UI
      'magnifyingglass': Icons.search,
      'camera': Icons.camera_alt,
      'photo': Icons.photo,
      'doc': Icons.insert_drive_file,
      'folder': Icons.folder,
    };

    return iconMap[sfSymbol];
  }
}
