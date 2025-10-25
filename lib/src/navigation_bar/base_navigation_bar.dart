import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseNavigationBar - Cross-platform navigation bar with native iOS support
/// 
/// Uses CNNavigationBar (Cupertino Native) for iOS - provides native iOS navigation bar
/// with large title mode, transparency, and flexible actions via UINavigationBar.
/// Uses Material AppBar for Android.
/// 
/// *** use cupertino = { forceUseMaterial: true } force use Material AppBar on iOS
/// *** use material = { forceUseCupertino: true } force use CNNavigationBar on Android
///
/// Features:
/// - Native iOS UINavigationBar via CNNavigationBar (cupertino_native package)
/// - Material Design AppBar for Android
/// - Leading, title, and trailing actions
/// - Large title mode support
/// - Transparency with blur effects
/// - Search functionality via factory constructor
/// - Built-in liquid glass effects on iOS (no manual wrapper needed)
/// 
/// Example:
/// ```dart
/// BaseNavigationBar(
///   leading: [
///     CNNavigationBarAction(
///       icon: CNSymbol('chevron.left'),
///       onPressed: () => Navigator.pop(context),
///     ),
///     CNNavigationBarAction(
///       label: 'Back',
///       onPressed: () => Navigator.pop(context),
///     ),
///   ],
///   title: 'Navigation Bar',
///   trailing: [
///     CNNavigationBarAction(
///       icon: CNSymbol('gear'),
///       onPressed: () => print('Settings'),
///     ),
///     CNNavigationBarAction(
///       icon: CNSymbol('plus'),
///       onPressed: () => print('Add'),
///     ),
///   ],
///   tint: CupertinoColors.label,
///   transparent: false,
///   largeTitle: false,
/// )
/// ```
/// 
/// For search functionality, use the factory constructor:
/// ```dart
/// BaseNavigationBar.search(
///   leading: [
///     CNNavigationBarAction(icon: CNSymbol('chevron.left'), onPressed: () {}),
///   ],
///   trailing: [
///     CNNavigationBarAction(icon: CNSymbol('ellipsis.circle'), onPressed: () {}),
///   ],
///   searchConfig: CNSearchConfig(
///     placeholder: 'Search',
///     onSearchTextChanged: (text) => print(text),
///     resultsBuilder: (context, text) => SearchResults(text),
///   ),
/// )
/// ```
/// 
/// Available action types:
/// - `CNNavigationBarAction()` - Regular action with icon/label
/// - `CNNavigationBarAction.fixedSpace(5)` - Fixed spacing
/// - `CNNavigationBarAction.flexibleSpace()` - Flexible spacing
/// 
/// Updated: 2024.10.25 - Renamed from BaseCNNavigationBar for consistency
class BaseNavigationBar extends BaseStatelessWidget {
  const BaseNavigationBar({
    Key? key,
    this.leading,
    this.title,
    this.trailing,
    this.tint,
    this.transparent = false,
    this.largeTitle = false,
    this.height,
    this.titleSize,
    this.onTitlePressed,
    this.searchConfig,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// Factory constructor for search-enabled navigation bar
  const BaseNavigationBar.search({
    Key? key,
    List<CNNavigationBarAction>? leading,
    List<CNNavigationBarAction>? trailing,
    required CNSearchConfig searchConfig,
    Color? tint,
    bool transparent = false,
    bool largeTitle = false,
    double? height,
    double? titleSize,
    VoidCallback? onTitlePressed,
    BaseParam? baseParam,
  }) : this(
         key: key,
         leading: leading,
         trailing: trailing,
         searchConfig: searchConfig,
         tint: tint,
         transparent: transparent,
         largeTitle: largeTitle,
         height: height,
         titleSize: titleSize,
         onTitlePressed: onTitlePressed,
         baseParam: baseParam,
       );

  /// Leading navigation actions
  final List<CNNavigationBarAction>? leading;

  /// Navigation bar title
  final String? title;

  /// Trailing navigation actions
  final List<CNNavigationBarAction>? trailing;

  /// Tint color for icons and text
  final Color? tint;

  /// Whether the navigation bar should be transparent
  final bool transparent;

  /// Whether to use large title style
  final bool largeTitle;

  /// Custom height for the navigation bar
  final double? height;

  /// Title text size
  final double? titleSize;

  /// Callback when title is tapped
  final VoidCallback? onTitlePressed;

  /// Search configuration for search-enabled navigation bar
  final CNSearchConfig? searchConfig;

  @override
  Widget buildByCupertino(BuildContext context) {
    // Check if this is a search navigation bar
    final searchConf = valueOf('searchConfig', searchConfig);
    if (searchConf != null) {
      return CNNavigationBar.search(
        leading: valueOf('leading', leading),
        trailing: valueOf('trailing', trailing),
        searchConfig: searchConf,
        tint: valueOf('tint', tint),
        transparent: valueOf('transparent', transparent),
        largeTitle: valueOf('largeTitle', largeTitle),
        height: valueOf('height', height),
        titleSize: valueOf('titleSize', titleSize),
        onTitlePressed: valueOf('onTitlePressed', onTitlePressed),
      );
    }

    return CNNavigationBar(
      leading: valueOf('leading', leading),
      title: valueOf('title', title),
      trailing: valueOf('trailing', trailing),
      tint: valueOf('tint', tint),
      transparent: valueOf('transparent', transparent),
      largeTitle: valueOf('largeTitle', largeTitle),
      height: valueOf('height', height),
      titleSize: valueOf('titleSize', titleSize),
      onTitlePressed: valueOf('onTitlePressed', onTitlePressed),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = valueOf('tint', tint) ?? theme.colorScheme.primary;
    final textColor = valueOf('tint', tint) ?? theme.colorScheme.onSurface;

    // Check if this is a search navigation bar
    final searchConf = valueOf('searchConfig', searchConfig);
    if (searchConf != null) {
      return _buildMaterialSearchNavBar(context, theme, iconColor, textColor, searchConf);
    }

    return Container(
      height: valueOf('height', height) ?? (valueOf('largeTitle', largeTitle) ? 96 : 56),
      decoration: valueOf('transparent', transparent)
          ? null
          : BoxDecoration(
              color: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: valueOf('largeTitle', largeTitle)
              ? _buildLargeTitleLayout(textColor, iconColor)
              : _buildRegularLayout(textColor, iconColor),
        ),
      ),
    );
  }

  /// Build Material search navigation bar
  Widget _buildMaterialSearchNavBar(
    BuildContext context,
    ThemeData theme,
    Color iconColor,
    Color textColor,
    CNSearchConfig searchConfig,
  ) {
    return Container(
      height: valueOf('height', height) ?? 56,
      decoration: valueOf('transparent', transparent)
          ? null
          : BoxDecoration(
              color: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Leading actions
              if (valueOf('leading', leading) != null) ...[
                ..._buildMaterialActions(valueOf('leading', leading)!, iconColor),
                const SizedBox(width: 12),
              ],
              
              // Search field
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: searchConfig.onSearchTextChanged,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: searchConfig.placeholder,
                      hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      prefixIcon: Icon(Icons.search, color: iconColor.withOpacity(0.7), size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ),
              
              // Trailing actions
              if (valueOf('trailing', trailing) != null) ...[
                const SizedBox(width: 12),
                ..._buildMaterialActions(valueOf('trailing', trailing)!, iconColor),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeTitleLayout(Color textColor, Color iconColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row with actions
        SizedBox(
          height: 44,
          child: Row(
            children: [
              if (valueOf('leading', leading) != null) ...[
                ..._buildMaterialActions(valueOf('leading', leading)!, iconColor),
                const Spacer(),
              ] else
                const Spacer(),
              if (valueOf('trailing', trailing) != null)
                ..._buildMaterialActions(valueOf('trailing', trailing)!, iconColor),
            ],
          ),
        ),
        // Large title
        if (valueOf('title', title) != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              valueOf('title', title)!,
              style: TextStyle(
                color: textColor,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRegularLayout(Color textColor, Color iconColor) {
    return Row(
      children: [
        // Leading actions
        if (valueOf('leading', leading) != null) ...[
          ..._buildMaterialActions(valueOf('leading', leading)!, iconColor),
          const SizedBox(width: 12),
        ],
        
        // Title
        if (valueOf('title', title) != null)
          Expanded(
            child: Text(
              valueOf('title', title)!,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          const Spacer(),
        
        // Trailing actions
        if (valueOf('trailing', trailing) != null) ...[
          const SizedBox(width: 12),
          ..._buildMaterialActions(valueOf('trailing', trailing)!, iconColor),
        ],
      ],
    );
  }

  List<Widget> _buildMaterialActions(List<CNNavigationBarAction> actions, Color iconColor) {
    return actions.map((action) {
      // Handle special action types
      if (action.runtimeType.toString().contains('FixedSpace')) {
        // This is a fixed space action - extract width if possible
        // For now, default to 8px spacing
        return const SizedBox(width: 8);
      }
      
      if (action.runtimeType.toString().contains('FlexibleSpace')) {
        // This is a flexible space action
        return const Expanded(child: SizedBox());
      }
      
      // Regular action with icon/label
      if (action.icon != null && action.label != null) {
        // Both icon and label
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: action.onPressed,
              icon: _buildMaterialIcon(action.icon!),
              color: iconColor,
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            Text(
              action.label!,
              style: TextStyle(color: iconColor, fontSize: 10),
            ),
          ],
        );
      } else if (action.icon != null) {
        // Icon only
        return IconButton(
          onPressed: action.onPressed,
          icon: _buildMaterialIcon(action.icon!),
          color: iconColor,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        );
      } else if (action.label != null) {
        // Label only
        return TextButton(
          onPressed: action.onPressed,
          child: Text(action.label!, style: TextStyle(color: iconColor)),
        );
      }
      
      return const SizedBox.shrink();
    }).toList();
  }

  Widget _buildMaterialIcon(CNSymbol symbol) {
    // Map SF Symbol to Material icon
    final iconData = _mapSFSymbolToMaterialIcon(symbol.name);
    return Icon(iconData, size: symbol.size);
  }

  IconData _mapSFSymbolToMaterialIcon(String sfSymbol) {
    final Map<String, IconData> iconMap = {
      'chevron.left': Icons.chevron_left,
      'chevron.right': Icons.chevron_right,
      'plus': Icons.add,
      'gear': Icons.settings,
      'gearshape': Icons.settings,
      'ellipsis.circle': Icons.more_vert,
      'star.fill': Icons.star,
      'star': Icons.star_border,
      'magnifyingglass': Icons.search,
      'apps.iphone': Icons.apps,
      // Add more mappings as needed
    };
    return iconMap[sfSymbol] ?? Icons.circle;
  }
}
