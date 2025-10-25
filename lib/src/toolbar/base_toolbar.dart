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
/// 
/// Example:
/// ```dart
/// BaseToolbar(
///   leading: [
///     CNToolbarAction(
///       icon: CNSymbol('chevron.left'),
///       onPressed: () => Navigator.pop(context),
///     ),
///   ],
///   middle: [
///     CNToolbarAction(
///       icon: CNSymbol('pencil', size: 40),
///       onPressed: () => print('Edit'),
///     ),
///   ],
///   trailing: [
///     CNToolbarAction(
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
///     CNToolbarAction(icon: CNSymbol('star.fill'), onPressed: () {}),
///   ],
///   trailing: [
///     CNToolbarAction(icon: CNSymbol('ellipsis.circle'), onPressed: () {}),
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
/// Updated: 2024.10.25 - Renamed from BaseCNToolbar for consistency
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
    List<CNToolbarAction>? leading,
    List<CNToolbarAction>? trailing,
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
  final List<CNToolbarAction>? leading;

  /// Middle toolbar actions (main actions)
  final List<CNToolbarAction>? middle;

  /// Trailing toolbar actions (typically settings, more)
  final List<CNToolbarAction>? trailing;

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
    
    // Check if this is a search toolbar
    final searchConf = valueOf('searchConfig', searchConfig);
    if (searchConf != null) {
      return CNToolbar.search(
        leading: valueOf('leading', leading),
        trailing: valueOf('trailing', trailing),
        searchConfig: searchConf,
        contextIcon: valueOf('contextIcon', contextIcon),
        tint: valueOf('tint', tint),
        transparent: valueOf('transparent', transparent),
        height: valueOf('height', height),
        pillHeight: valueOf('pillHeight', pillHeight),
      );
    }
    
    return CNToolbar(
      leading: valueOf('leading', leading),
      middle: valueOf('middle', middle),
      trailing: valueOf('trailing', trailing),
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
    List<CNToolbarAction> actions,
    Color tintColor,
  ) {
    return actions.map((action) {
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
