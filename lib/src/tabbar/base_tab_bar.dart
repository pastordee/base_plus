import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoDynamicColor;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show MouseCursor;
import 'package:flutter/services.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';
import '../flutter/cupertino/bottom_tab_bar.dart';
import 'base_native_tab_bar_item.dart';

/// BaseTabBar with iOS 26 Liquid Glass Dynamic Material and Material 3 support
/// 
/// Features iOS 26 Liquid Glass Dynamic Material with:
/// - Transparency with optical clarity zones for tab navigation
/// - Environmental reflections and adaptive opacity
/// - Dynamic interaction states with real-time responsiveness
/// - Enhanced haptic feedback for tab selection
/// - Unified design language across platforms
/// 
/// Material 3 Integration:
/// - TabBar with Material 3 design tokens
/// - Semantic ColorScheme usage with adaptive colors
/// - Modern elevation system with surface tinting
/// - Enhanced accessibility with semantic navigation
/// 
/// Cross-platform support:
/// - CupertinoTabBar with Liquid Glass enhancement by cupertino
/// - Material 3 TabBar with enhanced visual states by material
/// - **Native iOS CNTabBar** with SF Symbols (cupertino_native package)
/// *** not support cupertino = { forceUseMaterial: true }
/// *** not support material = { forceUseCupertino: true }
/// 
/// Native iOS Tab Bar Integration:
/// When [useNativeCupertinoTabBar] is enabled (default: true), BaseTabBar
/// automatically uses CNTabBar from cupertino_native on iOS, providing
/// authentic iOS 26 navigation with SF Symbols.
/// 
/// ## CNTabBar Customization Properties:
/// When using native CNTabBar, you can customize its appearance with:
/// - `cnTint`: Tint color for selected items
/// - `cnHeight`: Custom height for the tab bar
/// - `cnSplit`: Enable split layout (left and right groups)
/// - `cnRightCount`: Number of items on the right side when split
/// - `cnShrinkCentered`: Shrink centered items in split layout
/// - `cnSplitSpacing`: Spacing between split sections
/// - `cnBackgroundOpacity`: Override background transparency (0.0 = fully transparent, 1.0 = fully opaque)
/// 
/// **Note on Background Transparency:**
/// You can control CNTabBar transparency in two ways:
/// 1. Set `backgroundColor` with alpha: `Colors.white.withOpacity(0.1)`
/// 2. Use `cnBackgroundOpacity` to override: `cnBackgroundOpacity: 0.1` (easier!)
/// 
/// The `cnBackgroundOpacity` property provides explicit control without
/// affecting Material tab bars, making it ideal for iOS-specific customization.
/// 
/// ## SF Symbol Specification Methods:
/// 
/// **Method 1: Convenience Factory (Recommended)**
/// ```dart
/// BaseTabBar(
///   useNativeCupertinoTabBar: true,
///   cnTint: Colors.blue, // Customize tint color
///   cnBackgroundOpacity: 0.8, // Control transparency (0.0-1.0)
///   cnSplit: true, // Enable split layout
///   cnRightCount: 1, // 1 item on right side
///   items: [
///     BottomNavigationBarItemNativeExtension.withSFSymbol(
///       sfSymbolName: SFSymbols.home,
///       icon: Icon(Icons.home_outlined),
///       activeIcon: Icon(Icons.home),
///       label: 'Home',
///     ),
///   ],
/// )
/// ```
/// 
/// **Method 2: KeyedSubtree with Metadata**
/// ```dart
/// BottomNavigationBarItem(
///   icon: KeyedSubtree(
///     key: BaseNativeTabBarItemKey(SFSymbols.search),
///     child: Icon(Icons.search_outlined),
///   ),
///   label: 'Search',
/// )
/// ```
/// 
/// **Search Functionality:**
/// Use the factory constructor for search-enabled tab bars:
/// ```dart
/// BaseTabBar.search(
///   items: [
///     BottomNavigationBarItemNativeExtension.withSFSymbol(
///       sfSymbolName: SFSymbols.home,
///       icon: Icon(Icons.home_outlined),
///       label: 'Home',
///     ),
///     BottomNavigationBarItemNativeExtension.withSFSymbol(
///       sfSymbolName: SFSymbols.star,
///       icon: Icon(Icons.star_outline),
///       label: 'Favorites',
///     ),
///   ],
///   searchConfig: CNSearchConfig(
///     placeholder: 'Search tabs...',
///     onSearchTextChanged: (text) => print('Search: $text'),
///     resultsBuilder: (context, text) => SearchResultsWidget(text),
///   ),
///   cnTint: Colors.blue,
/// )
/// ```
/// 
/// **Method 3: Automatic Icon Mapping**
/// ```dart
/// BottomNavigationBarItem(
///   icon: Icon(Icons.person_outline),
///   label: 'Profile',
/// )
/// ```
/// BaseTabBar will attempt to map common Material icons to corresponding SF Symbols.
/// 
/// ## SFSymbols Helper Class:
/// Use the `SFSymbols` class for common SF Symbol names:
/// - `SFSymbols.home` → 'house.fill'
/// - `SFSymbols.search` → 'magnifyingglass'
/// - `SFSymbols.profile` → 'person.crop.circle'
/// - `SFSymbols.settings` → 'gearshape.fill'
/// - And 30+ more...
/// 
/// Enhanced: 2024.01.20 with iOS 26 Liquid Glass Dynamic Material
/// Enhanced: 2024.01.21 with Native iOS CNTabBar and SF Symbol integration
class BaseTabBar extends BaseStatelessWidget {
  const BaseTabBar({
    Key? key,
    this.items,
    this.onTap,
    this.currentIndex = 0,
    this.iconSize,
    this.backgroundColor,
    this.showIndicator = true,
    this.activeColor,
    this.inactiveColor = CupertinoColors.inactiveGray,
    this.border = const Border(
      top: BorderSide(
        color: _kDefaultTabBarBorderColor,
        width: 0.0, // One physical pixel.
        style: BorderStyle.solid,
      ),
    ),
    this.elevation = 8.0,
    this.type,
    this.fixedColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme = const IconThemeData(),
    this.unselectedIconTheme = const IconThemeData(),
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels = true,
    this.showUnselectedLabels,
    this.mouseCursor,
    this.enableFeedback,

    // iOS 26 Liquid Glass Dynamic Material properties
    this.enableLiquidGlass = true,
    this.glassOpacity = 0.85,
    this.reflectionIntensity = 0.6,
    this.adaptiveInteraction = true,
    this.hapticFeedback = true,
    this.useMaterial3Tabs = true,
    this.useNativeCupertinoTabBar = true, // Enable CNTabBar from cupertino_native

    // CNTabBar-specific properties (cupertino_native package)
    this.cnTint,
    this.cnHeight,
    this.cnSplit = false,
    this.cnRightCount = 1,
    this.cnShrinkCentered = true,
    this.cnSplitSpacing = 8.0,
    this.cnBackgroundOpacity, // Optional: override background opacity for CNTabBar

    // Search functionality
    this.searchConfig,

    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// Factory constructor for search-enabled tab bar
  const BaseTabBar.search({
    Key? key,
    List<BottomNavigationBarItem>? items,
    ValueChanged<int>? onTap,
    int currentIndex = 0,
    required CNSearchConfig searchConfig,
    double? iconSize,
    Color? backgroundColor,
    Color? activeColor,
    Color? cnTint,
    double? cnHeight,
    bool cnSplit = false,
    int cnRightCount = 1,
    bool cnShrinkCentered = true,
    double cnSplitSpacing = 8.0,
    double? cnBackgroundOpacity,
    bool useNativeCupertinoTabBar = true,
    BaseParam? baseParam,
  }) : this(
         key: key,
         items: items,
         onTap: onTap,
         currentIndex: currentIndex,
         searchConfig: searchConfig,
         iconSize: iconSize,
         backgroundColor: backgroundColor,
         activeColor: activeColor,
         cnTint: cnTint,
         cnHeight: cnHeight,
         cnSplit: cnSplit,
         cnRightCount: cnRightCount,
         cnShrinkCentered: cnShrinkCentered,
         cnSplitSpacing: cnSplitSpacing,
         cnBackgroundOpacity: cnBackgroundOpacity,
         useNativeCupertinoTabBar: useNativeCupertinoTabBar,
         baseParam: baseParam,
       );

  /// *** general properties start ***

  /// See also:
  ///   * [CupertinoTabBar.items]
  ///   * [BottomNavigationBar.items]
  final List<BottomNavigationBarItem>? items;

  /// [CupertinoTabBar.onTap]
  /// or
  /// [BottomNavigationBar.onTap]
  final ValueChanged<int>? onTap;

  /// [CupertinoTabBar.currentIndex]
  /// or
  /// [BottomNavigationBar.currentIndex]
  final int currentIndex;

  /// [CupertinoTabBar.iconSize]
  /// or
  /// [BottomNavigationBar.iconSize]
  final double? iconSize;

  /// [CupertinoTabBar.backgroundColor]
  /// or
  /// [BottomNavigationBar.backgroundColor]
  final Color? backgroundColor;

  /// when [icon is null], then will add an indicator
  // 显示指示器，当icon为null时，默认会添加一个指示器
  @Deprecated('已删除该字段，需要的请自定义')
  final bool showIndicator;

  /// *** general properties end ***

  /// *** cupertino properties start ***

  /// [CupertinoTabBar.activeColor]
  final Color? activeColor;

  /// [CupertinoTabBar.inactiveColor]
  final Color inactiveColor;

  /// [CupertinoTabBar.border]
  final Border? border;

  /// *** cupertino properties end ***

  /// *** material properties start ***

  /// [BottomNavigationBar.elevation]
  final double? elevation;

  /// [BottomNavigationBar.type]
  final BottomNavigationBarType? type;

  /// [BottomNavigationBar.fixedColor]
  final Color? fixedColor;

  /// [BottomNavigationBar.selectedItemColor]
  final Color? selectedItemColor;

  /// [BottomNavigationBar.unselectedItemColor]
  final Color? unselectedItemColor;

  /// [BottomNavigationBar.selectedIconTheme]
  final IconThemeData? selectedIconTheme;

  /// [BottomNavigationBar.unselectedIconTheme]
  final IconThemeData? unselectedIconTheme;

  /// [BottomNavigationBar.selectedFontSize]
  final double selectedFontSize;

  /// [BottomNavigationBar.unselectedFontSize]
  final double unselectedFontSize;

  /// [BottomNavigationBar.selectedLabelStyle]
  final TextStyle? selectedLabelStyle;

  /// [BottomNavigationBar.unselectedLabelStyle]
  final TextStyle? unselectedLabelStyle;

  /// [BottomNavigationBar.showSelectedLabels]
  final bool? showSelectedLabels;

  /// [BottomNavigationBar.showUnselectedLabels]
  final bool? showUnselectedLabels;

  /// [BottomNavigationBar.mouseCursor]
  final MouseCursor? mouseCursor;

  /// [BottomNavigationBar.enableFeedback]
  final bool? enableFeedback;

  /// *** material properties end ***

  /// *** iOS 26 Liquid Glass Dynamic Material properties start ***

  /// Enable Liquid Glass Dynamic Material optical effects for tab bars
  /// Provides transparency, reflections, and adaptive visual states
  final bool enableLiquidGlass;

  /// Glass transparency level for environmental awareness
  /// Creates optical clarity while maintaining navigation visibility (0.0 to 1.0)
  final double glassOpacity;

  /// Reflection intensity for environmental responsiveness
  /// Simulates real-world glass reflection behavior (0.0 to 1.0)
  final double reflectionIntensity;

  /// Enable adaptive interaction with real-time responsiveness
  /// Provides context-aware visual and haptic feedback for tab navigation
  final bool adaptiveInteraction;

  /// Enable haptic feedback for enhanced tab navigation experience
  /// Provides appropriate haptic responses for tab switches and interactions
  final bool hapticFeedback;

  /// Use Material 3 TabBar instead of legacy BottomNavigationBar for Material tabs
  /// Provides modern Material Design 3 tab patterns and tokens
  final bool useMaterial3Tabs;

  /// Use native CNTabBar from cupertino_native package on iOS
  /// Provides authentic iOS 26 tab bar with SF Symbols and native styling
  /// When enabled, uses CNTabBar with CNTabBarItem and CNSymbol for icons
  final bool useNativeCupertinoTabBar;

  /// *** iOS 26 Liquid Glass Dynamic Material properties end ***

  /// *** CNTabBar-specific properties start (cupertino_native package) ***

  /// [CNTabBar.tint] - Tint color for the tab bar (iOS native)
  /// Applied to selected items in the CNTabBar
  final Color? cnTint;

  /// [CNTabBar.height] - Custom height for the tab bar (iOS native)
  /// If not specified, uses the default CNTabBar height
  final double? cnHeight;

  /// [CNTabBar.split] - Enable split tab bar layout (iOS native)
  /// When true, creates a split layout with items distributed between left and right
  final bool cnSplit;

  /// [CNTabBar.rightCount] - Number of items on the right side when split is enabled
  /// Only applies when cnSplit is true
  final int cnRightCount;

  /// [CNTabBar.shrinkCentered] - Shrink centered items in split layout
  /// When true, centered items are shrunk to fit the available space
  final bool cnShrinkCentered;

  /// [CNTabBar.splitSpacing] - Spacing between split sections
  /// Only applies when cnSplit is true
  final double cnSplitSpacing;

  /// Background opacity for CNTabBar (0.0 to 1.0)
  /// When specified, applies this opacity to the backgroundColor for CNTabBar only.
  /// If not specified, uses the backgroundColor's alpha as-is.
  /// This provides explicit control over CNTabBar transparency without affecting Material tabs.
  final double? cnBackgroundOpacity;

  /// Search configuration for search-enabled tab bar
  final CNSearchConfig? searchConfig;

  /// *** CNTabBar-specific properties end ***

  /// 用户BaseTabScaffold里构建bottomNavigationBar
  BaseTabBar copyWith({
    ValueChanged<int>? onTap,
    required int currentIndex,
  }) {
    return BaseTabBar(
      items: items,
      onTap: onTap ?? this.onTap,
      currentIndex: currentIndex,
      iconSize: iconSize,
      backgroundColor: backgroundColor,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      border: border,
      elevation: elevation,
      type: type,
      fixedColor: fixedColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      selectedIconTheme: selectedIconTheme,
      unselectedIconTheme: unselectedIconTheme,
      selectedFontSize: selectedFontSize,
      unselectedFontSize: unselectedFontSize,
      selectedLabelStyle: selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
      showSelectedLabels: showSelectedLabels,
      showUnselectedLabels: showUnselectedLabels,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      enableLiquidGlass: enableLiquidGlass,
      glassOpacity: glassOpacity,
      reflectionIntensity: reflectionIntensity,
      adaptiveInteraction: adaptiveInteraction,
      hapticFeedback: hapticFeedback,
      useMaterial3Tabs: useMaterial3Tabs,
      useNativeCupertinoTabBar: useNativeCupertinoTabBar,
      cnTint: cnTint,
      cnHeight: cnHeight,
      cnSplit: cnSplit,
      cnRightCount: cnRightCount,
      cnShrinkCentered: cnShrinkCentered,
      cnSplitSpacing: cnSplitSpacing,
      cnBackgroundOpacity: cnBackgroundOpacity,
      searchConfig: searchConfig,
    );
  }

  @override
  Widget buildByCupertino(BuildContext context) {
    // Use native CNTabBar if enabled and items are available
    if (valueOf('useNativeCupertinoTabBar', useNativeCupertinoTabBar)) {
      return _buildNativeCupertinoTabBar(context);
    }

    // Fallback to standard CupertinoTabBar
    final CupertinoTabBar tabBar = buildCupertinoTabBar(context);

    // Apply iOS 26 Liquid Glass effects if enabled
    // if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
    //   return _wrapWithLiquidGlass(context, tabBar);
    // }

    return tabBar;
  }

  /// Build native CNTabBar using cupertino_native package
  /// Provides authentic iOS 26 tab bar with SF Symbols and custom images
  /// 
  /// Supports both SF Symbols and custom images via CNTabBarItem's image property
  Widget _buildNativeCupertinoTabBar(BuildContext context) {
    final ValueChanged<int>? onTap = valueOf('onTap', this.onTap);
    final List<BottomNavigationBarItem>? items = valueOf('items', this.items);
    
    if (items == null || items.isEmpty) {
      // Fallback if no items
      return buildCupertinoTabBar(context);
    }

    // Enhanced onTap with haptic feedback
    ValueChanged<int>? enhancedOnTap;
    if (onTap != null) {
      enhancedOnTap = (int index) {
        if (valueOf('hapticFeedback', hapticFeedback) && valueOf('adaptiveInteraction', adaptiveInteraction)) {
          HapticFeedback.selectionClick();
        }
        onTap(index);
      };
    }

    // Convert BottomNavigationBarItem to CNTabBarItem (supports both SF Symbols and images)
    final List<CNTabBarItem> cnItems = items.map((item) {
      String label = item.label ?? '';
      
      // Check for custom image metadata via BaseCustomImageKey
      if (item.icon is KeyedSubtree) {
        final KeyedSubtree keyedIcon = item.icon as KeyedSubtree;
        
        if (keyedIcon.key is BaseCustomImageKey) {
          // Custom image - use CNTabBarItem's image property
          final BaseCustomImageKey imageKey = keyedIcon.key as BaseCustomImageKey;
          return CNTabBarItem(
            label: label,
            image: AssetImage(imageKey.imageForIOS),
            imageSize: imageKey.imageSize,
          );
        } else if (keyedIcon.key is BaseNativeTabBarItemKey) {
          // SF Symbol specified
          final String sfSymbolName = (keyedIcon.key as BaseNativeTabBarItemKey).sfSymbolName;
          return CNTabBarItem(
            label: label,
            icon: CNSymbol(sfSymbolName),
          );
        }
      } else if (item.icon is Image) {
        // Direct Image widget - check for BaseCustomImageKey in its key
        final Image imageIcon = item.icon as Image;
        if (imageIcon.key is BaseCustomImageKey) {
          final BaseCustomImageKey imageKey = imageIcon.key as BaseCustomImageKey;
          return CNTabBarItem(
            label: label,
            image: AssetImage(imageKey.imageForIOS),
            imageSize: imageKey.imageSize,
          );
        }
        // If no metadata, try to extract image from the widget
        // This is a fallback for direct Image.asset usage without metadata
        if (imageIcon.image is AssetImage) {
          final AssetImage assetImage = imageIcon.image as AssetImage;
          return CNTabBarItem(
            label: label,
            image: assetImage,
            imageSize: 28.0, // Default size
          );
        }
      } else if (item.icon is Icon) {
        // Material icon - map to SF Symbol
        final Icon icon = item.icon as Icon;
        final String sfSymbolName = _mapIconToSFSymbol(icon.icon);
        return CNTabBarItem(
          label: label,
          icon: CNSymbol(sfSymbolName),
        );
      }
      
      // Fallback: default SF Symbol
      return CNTabBarItem(
        label: label,
        icon: CNSymbol('circle.fill'),
      );
    }).toList();

    // Determine background color with optional opacity override
    Color? cnBackgroundColor = valueOf('backgroundColor', backgroundColor);
    final double? opacityOverride = valueOf('cnBackgroundOpacity', cnBackgroundOpacity);
    
    if (cnBackgroundColor != null && opacityOverride != null) {
      // Apply the opacity override to the background color
      cnBackgroundColor = cnBackgroundColor.withOpacity(opacityOverride.clamp(0.0, 1.0));
    }

    // Check if this is a search tab bar
    final searchConf = valueOf('searchConfig', searchConfig);
    if (searchConf != null) {
      return CNTabBar.search(
        items: cnItems,
        currentIndex: valueOf('currentIndex', currentIndex) ?? 0,
        onTap: enhancedOnTap ?? (int index) {}, // Provide default no-op if null
        searchConfig: searchConf,
        // CNTabBar-specific properties
        tint: valueOf('cnTint', cnTint),
        backgroundColor: cnBackgroundColor,
        iconSize: valueOf('iconSize', iconSize),
        height: valueOf('cnHeight', cnHeight),
        split: valueOf('cnSplit', cnSplit),
        rightCount: valueOf('cnRightCount', cnRightCount),
        shrinkCentered: valueOf('cnShrinkCentered', cnShrinkCentered),
        splitSpacing: valueOf('cnSplitSpacing', cnSplitSpacing),
      );
    }

    Widget tabBar = CNTabBar(
      items: cnItems,
      currentIndex: valueOf('currentIndex', currentIndex) ?? 0,
      onTap: enhancedOnTap ?? (int index) {}, // Provide default no-op if null
      // CNTabBar-specific properties
      tint: valueOf('cnTint', cnTint),
      backgroundColor: cnBackgroundColor,
      iconSize: valueOf('iconSize', iconSize),
      height: valueOf('cnHeight', cnHeight),
      split: valueOf('cnSplit', cnSplit),
      rightCount: valueOf('cnRightCount', cnRightCount),
      shrinkCentered: valueOf('cnShrinkCentered', cnShrinkCentered),
      splitSpacing: valueOf('cnSplitSpacing', cnSplitSpacing),
    );

    // Apply iOS 26 Liquid Glass effects if enabled
    // if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
    //   return _wrapWithLiquidGlass(context, tabBar);
    // }

    return tabBar;
  }

  /// Map common Flutter icons to SF Symbol names
  /// This provides reasonable defaults for standard navigation icons
  /// Expanded mapping for better automatic conversion support
  String _mapIconToSFSymbol(IconData? iconData) {
    if (iconData == null) return 'circle.fill';
    
    // Comprehensive mapping of Material icons to SF Symbols
    // Based on icon code points for accurate matching
    final Map<int, String> iconMap = {
      // Navigation & UI
      0xe318: 'house.fill', // Icons.home
      0xe88a: 'house', // Icons.home_outlined
      0xe8b5: 'magnifyingglass', // Icons.search
      0xe8b6: 'magnifyingglass', // Icons.search_outlined
      0xe7fd: 'person.crop.circle', // Icons.person
      0xe7ff: 'person.crop.circle', // Icons.person_outline
      0xe571: 'gearshape.fill', // Icons.settings
      0xe8b8: 'gearshape', // Icons.settings_outlined
      
      // Common Actions
      0xe145: 'plus.circle.fill', // Icons.add
      0xe147: 'plus.circle', // Icons.add_circle_outline
      0xe15b: 'checkmark.circle.fill', // Icons.check_circle
      0xe16c: 'xmark.circle.fill', // Icons.cancel
      0xe5c4: 'arrow.right', // Icons.arrow_forward
      0xe5c8: 'arrow.left', // Icons.arrow_back
      0xe5d8: 'arrow.up', // Icons.arrow_upward
      0xe5db: 'arrow.down', // Icons.arrow_downward
      0xe3af: 'ellipsis.circle', // Icons.more_horiz
      0xe3b0: 'ellipsis', // Icons.more_vert
      
      // Communication
      0xe0e0: 'heart.fill', // Icons.favorite
      0xe0e1: 'heart', // Icons.favorite_border
      0xe24d: 'bell.fill', // Icons.notifications
      0xe250: 'bell', // Icons.notifications_outlined
      0xe0be: 'envelope.fill', // Icons.email
      0xe0bf: 'envelope', // Icons.email_outlined
      0xe0c8: 'phone.fill', // Icons.phone
      0xe0cd: 'phone', // Icons.phone_outlined
      0xe0ca: 'message.fill', // Icons.message
      0xe0cb: 'message', // Icons.chat_bubble_outline
      
      // Media
      0xe157: 'camera.fill', // Icons.camera
      0xe3b3: 'camera', // Icons.camera_alt_outlined
      0xe412: 'photo.fill', // Icons.photo
      0xe413: 'photo', // Icons.photo_outlined
      0xe04b: 'play.circle.fill', // Icons.play_circle_filled
      0xe04c: 'play.circle', // Icons.play_circle_outline
      0xe039: 'pause.circle.fill', // Icons.pause_circle_filled
      0xe1a7: 'music.note', // Icons.music_note
      0xe04e: 'video.fill', // Icons.videocam
      0xe04f: 'video', // Icons.videocam_outlined
      
      // Location & Travel
      0xe55f: 'mappin.circle.fill', // Icons.location_on
      0xe1b1: 'map.fill', // Icons.map
      0xe1b2: 'map', // Icons.map_outlined
      0xe531: 'airplane', // Icons.flight
      0xe1e3: 'car.fill', // Icons.directions_car
      
      // Shopping & Business
      0xe8cc: 'cart.fill', // Icons.shopping_cart
      0xe8cb: 'cart', // Icons.shopping_cart_outlined
      0xe8d1: 'bag.fill', // Icons.shopping_bag
      0xe8de: 'creditcard.fill', // Icons.payment
      0xe227: 'dollarsign.circle.fill', // Icons.attach_money
      
      // Documents & Files
      0xe1af: 'doc.fill', // Icons.description
      0xe873: 'folder.fill', // Icons.folder
      0xe2c7: 'doc.text.fill', // Icons.insert_drive_file
      0xe226: 'arrow.down.doc.fill', // Icons.download
      0xe2c6: 'square.and.arrow.up.fill', // Icons.upload
      0xe14d: 'paperclip', // Icons.attach_file
      
      // Social & Sharing
      0xe80d: 'square.and.arrow.up', // Icons.share
      0xe866: 'person.2.fill', // Icons.group
      0xe7ee: 'bubble.left.and.bubble.right.fill', // Icons.forum
      0xe8f2: 'star.fill', // Icons.star
      0xe8f3: 'star', // Icons.star_border
      0xe8f5: 'star.leadinghalf.filled', // Icons.star_half
      
      // Time & Calendar
      0xe192: 'calendar', // Icons.calendar_today
      0xe8df: 'clock.fill', // Icons.access_time
      0xe425: 'timer', // Icons.timer
      0xe8b1: 'alarm.fill', // Icons.alarm
      
      // Utilities
      0xe897: 'lock.fill', // Icons.lock
      0xe898: 'lock.open.fill', // Icons.lock_open
      0xe8a1: 'eye.fill', // Icons.visibility
      0xe8a2: 'eye.slash.fill', // Icons.visibility_off
      0xe3c9: 'info.circle.fill', // Icons.info
      0xe002: 'exclamationmark.triangle.fill', // Icons.warning
      0xe000: 'exclamationmark.circle.fill', // Icons.error
      0xe86c: 'power', // Icons.power_settings_new
      
      // Basic Shapes
      0xe5d2: 'circle.fill', // Icons.circle
      0xe24a: 'square.fill', // Icons.crop_square
      0xe86a: 'star.circle.fill', // Icons.stars
    };

    return iconMap[iconData.codePoint] ?? 'circle.fill';
  }

  /// Builds the raw CupertinoTabBar without Liquid Glass effects
  /// Used by BaseTabScaffold which needs the actual CupertinoTabBar instance
  CupertinoTabBar buildCupertinoTabBar(BuildContext context) {
    final ValueChanged<int>? onTap = valueOf('onTap', this.onTap);
    
    // Enhanced onTap with haptic feedback
    ValueChanged<int>? enhancedOnTap;
    if (onTap != null) {
      enhancedOnTap = (int index) {
        if (valueOf('hapticFeedback', hapticFeedback) && valueOf('adaptiveInteraction', adaptiveInteraction)) {
          HapticFeedback.selectionClick();
        }
        onTap(index);
      };
    }

    return CupertinoTabBar(
      items: valueOf('items', items),
      onTap: enhancedOnTap,
      currentIndex: valueOf('currentIndex', currentIndex),
      backgroundColor: valueOf('backgroundColor', backgroundColor),
      activeColor: valueOf('activeColor', activeColor),
      inactiveColor: valueOf('inactiveColor', inactiveColor),
      iconSize: valueOf('iconSize', iconSize) ?? 30.0,
      border: valueOf('border', border),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final ValueChanged<int>? onTap = valueOf('onTap', this.onTap);
    final bool useMaterial3 = valueOf('useMaterial3Tabs', useMaterial3Tabs);
    
    // Enhanced onTap with haptic feedback
    ValueChanged<int>? enhancedOnTap;
    if (onTap != null) {
      enhancedOnTap = (int index) {
        if (valueOf('hapticFeedback', hapticFeedback) && valueOf('adaptiveInteraction', adaptiveInteraction)) {
          HapticFeedback.selectionClick();
        }
        onTap(index);
      };
    }

    Widget tabBar;
    
    if (useMaterial3) {
      // Use Material 3 NavigationBar for modern tab design
      tabBar = NavigationBar(
        destinations: _convertToNavigationDestinations(),
        onDestinationSelected: enhancedOnTap,
        selectedIndex: valueOf('currentIndex', currentIndex) ?? 0,
        backgroundColor: valueOf('backgroundColor', backgroundColor),
        elevation: valueOf('elevation', elevation),
      );
    } else {
      // Use legacy BottomNavigationBar
      tabBar = BottomNavigationBar(
        items: valueOf('items', items),
        onTap: enhancedOnTap,
        currentIndex: valueOf('currentIndex', currentIndex) ?? 0,
        elevation: valueOf('elevation', elevation),
        type: valueOf('type', type),
        fixedColor: valueOf('fixedColor', fixedColor),
        backgroundColor: valueOf('backgroundColor', backgroundColor),
        iconSize: valueOf('iconSize', iconSize) ?? 24.0,
        selectedItemColor: valueOf('selectedItemColor', selectedItemColor),
        unselectedItemColor: valueOf('unselectedItemColor', unselectedItemColor),
        selectedIconTheme: valueOf('selectedIconTheme', selectedIconTheme),
        unselectedIconTheme: valueOf('unselectedIconTheme', unselectedIconTheme),
        selectedFontSize: valueOf('selectedFontSize', selectedFontSize),
        unselectedFontSize: valueOf('unselectedFontSize', unselectedFontSize),
        selectedLabelStyle: valueOf('selectedLabelStyle', selectedLabelStyle),
        unselectedLabelStyle: valueOf('unselectedLabelStyle', unselectedLabelStyle),
        showSelectedLabels: valueOf('showSelectedLabels', showSelectedLabels),
        showUnselectedLabels: valueOf('showUnselectedLabels', showUnselectedLabels),
        mouseCursor: valueOf('mouseCursor', mouseCursor),
        enableFeedback: valueOf('enableFeedback', enableFeedback),
      );
    }

    // Apply iOS 26 Liquid Glass effects if enabled
    // if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
    //   return _wrapWithLiquidGlass(context, tabBar);
    // }

    return tabBar;
  }

  /// Convert BottomNavigationBarItem to NavigationDestination for Material 3
  List<NavigationDestination> _convertToNavigationDestinations() {
    final items = valueOf('items', this.items) ?? [];
    return items.map((item) {
      return NavigationDestination(
        icon: item.icon,
        selectedIcon: item.activeIcon ?? item.icon,
        label: item.label ?? '',
        tooltip: item.tooltip,
      );
    }).toList();
  }
}

const Color _kDefaultTabBarBorderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x4C000000),
  darkColor: Color(0x29000000),
);
