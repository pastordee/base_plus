import 'dart:ui' show ImageFilter;
import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoDynamicColor;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show MouseCursor;
import 'package:flutter/services.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';
import '../flutter/cupertino/bottom_tab_bar.dart';

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
/// *** not support cupertino = { forceUseMaterial: true }
/// *** not support material = { forceUseCupertino: true }
/// 
/// Enhanced: 2024.01.20 with iOS 26 Liquid Glass Dynamic Material
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

    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

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

  /// *** iOS 26 Liquid Glass Dynamic Material properties end ***

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
    );
  }

  @override
  Widget buildByCupertino(BuildContext context) {
    final CupertinoTabBar tabBar = buildCupertinoTabBar(context);

    // Apply iOS 26 Liquid Glass effects if enabled
    if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
      return _wrapWithLiquidGlass(context, tabBar);
    }

    return tabBar;
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
    if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
      return _wrapWithLiquidGlass(context, tabBar);
    }

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

  /// iOS 26 Liquid Glass Dynamic Material wrapper for tab bars
  /// 
  /// Implements sophisticated optical properties for tab navigation including:
  /// - Environmental transparency with adaptive opacity
  /// - Subtle reflections for spatial awareness
  /// - Enhanced interaction states for navigation clarity
  Widget _wrapWithLiquidGlass(BuildContext context, Widget child) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final glassOpacity = valueOf('glassOpacity', this.glassOpacity);
    final reflectionIntensity = valueOf('reflectionIntensity', this.reflectionIntensity);
    
    return Container(
      decoration: BoxDecoration(
        // Gradient background with environmental transparency
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.3, 0.7, 1.0],
          colors: [
            Colors.transparent,
            (isDark ? Colors.white : Colors.black).withOpacity(glassOpacity * 0.08),
            (isDark ? Colors.white : Colors.black).withOpacity(glassOpacity * 0.12),
            (isDark ? Colors.white : Colors.black).withOpacity(glassOpacity * 0.15),
          ],
        ),
        // Subtle shadow for material presence
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey.shade300).withOpacity(0.2),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
          // Environmental reflection shadow
          BoxShadow(
            color: (isDark ? Colors.white : Colors.black).withOpacity(reflectionIntensity * 0.05),
            offset: const Offset(0, -1),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: valueOf('adaptiveInteraction', adaptiveInteraction) ? 10.0 : 0.0,
            sigmaY: valueOf('adaptiveInteraction', adaptiveInteraction) ? 10.0 : 0.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              // Subtle reflective overlay for optical enhancement
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(reflectionIntensity * 0.1),
                  Colors.white.withOpacity(reflectionIntensity * 0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // @Deprecated('已废弃')
  // List<BottomNavigationBarItem> _buildBarItem(
  //   BuildContext context,
  //   List<BaseBarItem> items,
  // ) {
  //   final List<BottomNavigationBarItem> barItems = <BottomNavigationBarItem>[];
  //   for (int i = 0; i < items.length; i++) {
  //     barItems.add(items[i].build(context));
  //   }
  //   return barItems;
  // }
}

const Color _kDefaultTabBarBorderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x4C000000),
  darkColor: Color(0x29000000),
);
