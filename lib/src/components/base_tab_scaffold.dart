import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../appbar/base_app_bar.dart';
import '../base_param.dart';
import '../base_stateless_widget.dart';

/// A cross-platform tab scaffold that provides bottom navigation for both platforms
/// 
/// For iOS/Cupertino: Uses CupertinoTabScaffold with CupertinoTabBar
/// For Android/Material: Uses Scaffold with BottomNavigationBar
/// 
/// This widget handles the complete scaffold structure and tab management.
/// Note: This is different from the existing BaseTabScaffold in the scaffold directory.
class BaseCrossPlatformTabScaffold extends BaseStatelessWidget {
  const BaseCrossPlatformTabScaffold({
    Key? key,
    required this.tabs,
    required this.tabBuilder,
    this.controller,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.appBar,
    // Tab bar properties
    this.currentIndex = 0,
    this.onTap,
    this.type = BottomNavigationBarType.fixed,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.iconSize = 24.0,
    this.elevation,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    // Cupertino specific
    this.activeColor,
    this.inactiveColor,
    this.border,
    this.tabBarHeight = 50.0,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// List of tabs to display in the bottom navigation
  final List<BottomNavigationBarItem> tabs;

  /// Builder function for tab content
  final IndexedWidgetBuilder tabBuilder;

  /// Optional controller for managing tab state
  final CupertinoTabController? controller;

  /// Background color of the scaffold
  final Color? backgroundColor;

  /// Whether the body should resize when the keyboard appears
  final bool resizeToAvoidBottomInset;

  /// Optional app bar (only used in Material mode)
  final BaseAppBar? appBar;

  /// Current selected tab index
  final int currentIndex;

  /// Callback when a tab is tapped
  final ValueChanged<int>? onTap;

  /// Type of bottom navigation bar (Material only)
  final BottomNavigationBarType type;

  /// Color of selected items
  final Color? selectedItemColor;

  /// Color of unselected items
  final Color? unselectedItemColor;

  /// Font size for selected labels
  final double selectedFontSize;

  /// Font size for unselected labels
  final double unselectedFontSize;

  /// Size of tab icons
  final double iconSize;

  /// Elevation of bottom navigation bar (Material only)
  final double? elevation;

  /// Whether to show selected labels
  final bool showSelectedLabels;

  /// Whether to show unselected labels
  final bool showUnselectedLabels;

  // Cupertino specific properties
  /// Active color for Cupertino tab bar
  final Color? activeColor;

  /// Inactive color for Cupertino tab bar
  final Color? inactiveColor;

  /// Border for Cupertino tab bar
  final Border? border;

  /// Height of Cupertino tab bar
  final double tabBarHeight;

  @override
  Widget buildByCupertino(BuildContext context) {
    return CupertinoTabScaffold(
      controller: valueOf('controller', controller),
      backgroundColor: valueOf('backgroundColor', backgroundColor),
      resizeToAvoidBottomInset: valueOf('resizeToAvoidBottomInset', resizeToAvoidBottomInset),
      tabBar: CupertinoTabBar(
        items: valueOf('tabs', tabs),
        onTap: valueOf('onTap', onTap),
        currentIndex: valueOf('currentIndex', currentIndex),
        backgroundColor: valueOf('backgroundColor', backgroundColor),
        activeColor: valueOf('activeColor', activeColor) ?? 
                     valueOf('selectedItemColor', selectedItemColor),
        inactiveColor: valueOf('inactiveColor', inactiveColor) ?? 
                       valueOf('unselectedItemColor', unselectedItemColor),
        iconSize: valueOf('iconSize', iconSize),
        border: valueOf('border', border),
        height: valueOf('tabBarHeight', tabBarHeight),
      ),
      tabBuilder: (BuildContext context, int index) {
        return valueOf('tabBuilder', tabBuilder)(context, index);
      },
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final BaseAppBar? materialAppBar = valueOf('appBar', appBar);
    
    return Scaffold(
      appBar: materialAppBar?.build(context) as PreferredSizeWidget?,
      backgroundColor: valueOf('backgroundColor', backgroundColor),
      resizeToAvoidBottomInset: valueOf('resizeToAvoidBottomInset', resizeToAvoidBottomInset),
      body: valueOf('tabBuilder', tabBuilder)(context, valueOf('currentIndex', currentIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: valueOf('tabs', tabs),
        onTap: valueOf('onTap', onTap),
        currentIndex: valueOf('currentIndex', currentIndex),
        type: valueOf('type', type),
        selectedItemColor: valueOf('selectedItemColor', selectedItemColor),
        unselectedItemColor: valueOf('unselectedItemColor', unselectedItemColor),
        selectedFontSize: valueOf('selectedFontSize', selectedFontSize),
        unselectedFontSize: valueOf('unselectedFontSize', unselectedFontSize),
        iconSize: valueOf('iconSize', iconSize),
        elevation: valueOf('elevation', elevation),
        showSelectedLabels: valueOf('showSelectedLabels', showSelectedLabels),
        showUnselectedLabels: valueOf('showUnselectedLabels', showUnselectedLabels),
      ),
    );
  }
}
