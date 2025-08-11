import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseBottomNavigationBar with iOS 26 Liquid Glass Dynamic Material and Material 3 support
/// 
/// Features iOS 26 Liquid Glass Dynamic Material with:
/// - Transparency with optical clarity zones for navigation bars
/// - Environmental reflections and adaptive opacity
/// - Dynamic interaction states with real-time responsiveness
/// - Unified design language across platforms
/// - Enhanced haptic feedback for navigation actions
/// 
/// Material 3 Integration:
/// - NavigationBar with Material 3 design tokens
/// - Semantic ColorScheme usage with adaptive colors
/// - Modern elevation system with surface tinting
/// - Enhanced accessibility with semantic navigation
/// 
/// Cross-platform support:
/// - CupertinoTabBar with Liquid Glass enhancement by cupertino
/// - Material 3 NavigationBar and BottomNavigationBar by material
/// 
/// Enhanced: 2024.01.20 with iOS 26 Liquid Glass Dynamic Material
class BaseBottomNavigationBar extends BaseStatelessWidget {
  const BaseBottomNavigationBar({
    Key? key,
    required this.items,
    required this.onTap,
    this.currentIndex = 0,

    // iOS 26 Liquid Glass Dynamic Material properties
    this.enableLiquidGlass = true,
    this.glassOpacity = 0.85,
    this.reflectionIntensity = 0.6,
    this.adaptiveInteraction = true,
    this.hapticFeedback = true,
    this.useMaterial3Navigation = true,

    // Navigation bar properties
    this.type,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.iconSize = 24.0,
    this.elevation,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
    this.useLegacyColorScheme = false,
    // Cupertino specific
    this.activeColor,
    this.inactiveColor,
    this.border,
    this.height = 50.0,
    this.resizeToAvoidBottomInset = true,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// The interactive items laid out within the bottom navigation bar
  final List<BottomNavigationBarItem> items;

  /// Called when one of the [items] is tapped
  final ValueChanged<int>? onTap;

  /// The index into [items] for the current active item
  final int currentIndex;

  /// *** iOS 26 Liquid Glass Dynamic Material properties start ***

  /// Enable Liquid Glass Dynamic Material optical effects for navigation bars
  /// Provides transparency, reflections, and adaptive visual states
  final bool enableLiquidGlass;

  /// Glass transparency level for environmental awareness
  /// Creates optical clarity while maintaining navigation visibility (0.0 to 1.0)
  final double glassOpacity;

  /// Reflection intensity for environmental responsiveness
  /// Simulates real-world glass reflection behavior (0.0 to 1.0)
  final double reflectionIntensity;

  /// Enable adaptive interaction with real-time responsiveness
  /// Provides context-aware visual and haptic feedback for navigation actions
  final bool adaptiveInteraction;

  /// Enable haptic feedback for enhanced navigation experience
  /// Provides appropriate haptic responses for tab switches and interactions
  final bool hapticFeedback;

  /// Use Material 3 NavigationBar instead of legacy BottomNavigationBar
  /// Provides modern Material Design 3 navigation patterns and tokens
  final bool useMaterial3Navigation;

  /// *** iOS 26 Liquid Glass Dynamic Material properties end ***

  /// Defines the layout and behavior of a [BottomNavigationBar]
  final BottomNavigationBarType? type;

  /// The color of the [BottomNavigationBar] itself
  final Color? backgroundColor;

  /// The color of the selected [BottomNavigationBarItem.icon] and [BottomNavigationBarItem.label]
  final Color? selectedItemColor;

  /// The color of the unselected [BottomNavigationBarItem.icon] and [BottomNavigationBarItem.label]
  final Color? unselectedItemColor;

  /// The font size of the [BottomNavigationBarItem] labels when they are selected
  final double selectedFontSize;

  /// The font size of the [BottomNavigationBarItem] labels when they are not selected
  final double unselectedFontSize;

  /// The size of all of the [BottomNavigationBarItem] icons
  final double iconSize;

  /// The z-coordinate of this [BottomNavigationBar]
  final double? elevation;

  /// Whether the labels are shown for the selected [BottomNavigationBarItem]
  final bool showSelectedLabels;

  /// Whether the labels are shown for the unselected [BottomNavigationBarItem]
  final bool showUnselectedLabels;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget
  final MouseCursor? mouseCursor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback
  final bool? enableFeedback;

  /// Defines the layout of the [BottomNavigationBar] when [Orientation.landscape]
  final BottomNavigationBarLandscapeLayout? landscapeLayout;

  /// Whether the [BottomNavigationBar] should use the legacy color scheme
  final bool useLegacyColorScheme;

  // Cupertino specific properties
  /// The foreground color of the icon and title for the [CupertinoTabBar]'s selected tab
  final Color? activeColor;

  /// The foreground color of the icon and title for the [CupertinoTabBar]'s unselected tabs
  final Color? inactiveColor;

  /// The border of the [CupertinoTabBar]
  final Border? border;

  /// The height of the [CupertinoTabBar]
  final double height;

  /// Whether the body should resize when the keyboard appears
  final bool resizeToAvoidBottomInset;

  @override
  Widget buildByCupertino(BuildContext context) {
    // For Cupertino, we need to return the tab bar only since CupertinoTabScaffold
    // handles the entire scaffold structure
    Widget tabBar = CupertinoTabBar(
      items: valueOf('items', items),
      onTap: _handleTap,
      currentIndex: valueOf('currentIndex', currentIndex),
      backgroundColor: valueOf('backgroundColor', backgroundColor),
      activeColor: valueOf('activeColor', activeColor) ?? 
                   valueOf('selectedItemColor', selectedItemColor),
      inactiveColor: valueOf('inactiveColor', inactiveColor) ?? 
                     valueOf('unselectedItemColor', unselectedItemColor),
      iconSize: valueOf('iconSize', iconSize),
      border: valueOf('border', border),
      height: valueOf('height', height),
    );

    if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
      return _wrapWithLiquidGlass(context, tabBar);
    }

    return tabBar;
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final useMaterial3 = valueOf('useMaterial3Navigation', useMaterial3Navigation);
    
    if (useMaterial3) {
      // Use Material 3 NavigationBar for modern design
      Widget navigationBar = NavigationBar(
        destinations: _convertToNavigationDestinations(),
        onDestinationSelected: _handleTap,
        selectedIndex: valueOf('currentIndex', currentIndex),
        backgroundColor: valueOf('backgroundColor', backgroundColor),
        elevation: valueOf('elevation', elevation),
        height: valueOf('height', height),
        labelBehavior: _getLabelBehavior(),
      );

      if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
        return _wrapWithLiquidGlass(context, navigationBar);
      }

      return navigationBar;
    } else {
      // Use legacy BottomNavigationBar for backward compatibility
      Widget bottomNavBar = BottomNavigationBar(
        items: valueOf('items', items),
        onTap: _handleTap,
        currentIndex: valueOf('currentIndex', currentIndex),
        type: valueOf('type', type),
        backgroundColor: valueOf('backgroundColor', backgroundColor),
        selectedItemColor: valueOf('selectedItemColor', selectedItemColor),
        unselectedItemColor: valueOf('unselectedItemColor', unselectedItemColor),
        selectedFontSize: valueOf('selectedFontSize', selectedFontSize),
        unselectedFontSize: valueOf('unselectedFontSize', unselectedFontSize),
        iconSize: valueOf('iconSize', iconSize),
        elevation: valueOf('elevation', elevation),
        showSelectedLabels: valueOf('showSelectedLabels', showSelectedLabels),
        showUnselectedLabels: valueOf('showUnselectedLabels', showUnselectedLabels),
        mouseCursor: valueOf('mouseCursor', mouseCursor),
        enableFeedback: valueOf('enableFeedback', enableFeedback),
        landscapeLayout: valueOf('landscapeLayout', landscapeLayout),
        useLegacyColorScheme: valueOf('useLegacyColorScheme', useLegacyColorScheme),
      );

      if (valueOf('enableLiquidGlass', enableLiquidGlass)) {
        return _wrapWithLiquidGlass(context, bottomNavBar);
      }

      return bottomNavBar;
    }
  }

  /// Handle tab selection with haptic feedback and adaptive interaction
  void _handleTap(int index) {
    final onTap = valueOf('onTap', this.onTap);
    if (onTap != null) {
      // Provide haptic feedback for enhanced navigation experience
      if (valueOf('hapticFeedback', hapticFeedback) && valueOf('adaptiveInteraction', adaptiveInteraction)) {
        HapticFeedback.selectionClick();
      }
      onTap(index);
    }
  }

  /// Convert BottomNavigationBarItem to NavigationDestination for Material 3
  List<NavigationDestination> _convertToNavigationDestinations() {
    return valueOf('items', items).map((item) {
      return NavigationDestination(
        icon: item.icon,
        selectedIcon: item.activeIcon ?? item.icon,
        label: item.label ?? '',
        tooltip: item.tooltip,
      );
    }).toList();
  }

  /// Get appropriate label behavior for Material 3 NavigationBar
  NavigationDestinationLabelBehavior _getLabelBehavior() {
    final showSelected = valueOf('showSelectedLabels', showSelectedLabels);
    final showUnselected = valueOf('showUnselectedLabels', showUnselectedLabels);
    
    if (showSelected && showUnselected) {
      return NavigationDestinationLabelBehavior.alwaysShow;
    } else if (showSelected && !showUnselected) {
      return NavigationDestinationLabelBehavior.onlyShowSelected;
    } else {
      return NavigationDestinationLabelBehavior.alwaysHide;
    }
  }

  /// Wraps navigation bar with iOS 26 Liquid Glass Dynamic Material effects
  /// 
  /// Implements sophisticated optical properties for navigation bars including:
  /// - Environmental transparency with adaptive opacity
  /// - Subtle reflections for spatial awareness
  /// - Enhanced interaction states for navigation clarity
  Widget _wrapWithLiquidGlass(BuildContext context, Widget child) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        // Gradient background with environmental transparency
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.3, 0.7, 1.0],
          colors: [
            Colors.transparent,
            (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('glassOpacity', glassOpacity) * 0.08),
            (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('glassOpacity', glassOpacity) * 0.12),
            (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('glassOpacity', glassOpacity) * 0.15),
          ],
        ),
        // Subtle shadow for material presence
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey.shade300)
                .withOpacity(0.2),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
          // Environmental reflection shadow
          BoxShadow(
            color: (isDark ? Colors.white : Colors.black)
                .withOpacity(valueOf('reflectionIntensity', reflectionIntensity) * 0.05),
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
                  Colors.white.withOpacity(valueOf('reflectionIntensity', reflectionIntensity) * 0.1),
                  Colors.white.withOpacity(valueOf('reflectionIntensity', reflectionIntensity) * 0.05),
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
}
