import 'package:flutter/widgets.dart';

/// Metadata for converting BottomNavigationBarItem to CNTabBarItem
/// 
/// Use this to specify SF Symbol names for native iOS tab bar integration
/// when using BaseTabBar with useNativeCupertinoTabBar enabled.
/// 
/// Example:
/// ```dart
/// BottomNavigationBarItem(
///   icon: Icon(Icons.home, key: BaseNativeTabBarItemKey('house.fill')),
///   label: 'Home',
/// )
/// ```
class BaseNativeTabBarItemKey extends ValueKey<String> {
  const BaseNativeTabBarItemKey(String sfSymbolName) : super(sfSymbolName);
  
  /// The SF Symbol name to use for the native iOS tab bar
  String get sfSymbolName => value;
}

/// Extension to make it easier to add SF Symbol metadata to BottomNavigationBarItem
extension BottomNavigationBarItemNativeExtension on BottomNavigationBarItem {
  /// Create a BottomNavigationBarItem with SF Symbol metadata for native iOS tab bars
  static BottomNavigationBarItem withSFSymbol({
    required Widget icon,
    required String sfSymbolName,
    String? label,
    Widget? activeIcon,
    String? tooltip,
    Color? backgroundColor,
  }) {
    // Wrap the icon with a key containing the SF Symbol name
    final Widget keyedIcon = KeyedSubtree(
      key: BaseNativeTabBarItemKey(sfSymbolName),
      child: icon,
    );

    return BottomNavigationBarItem(
      icon: keyedIcon,
      activeIcon: activeIcon,
      label: label,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
    );
  }
}

/// Common SF Symbol mappings for standard navigation icons
class SFSymbols {
  SFSymbols._();

  // Common navigation symbols
  static const String home = 'house.fill';
  static const String search = 'magnifyingglass';
  static const String profile = 'person.crop.circle';
  static const String settings = 'gearshape.fill';
  static const String favorites = 'heart.fill';
  static const String notifications = 'bell.fill';
  static const String messages = 'envelope.fill';
  static const String phone = 'phone.fill';
  static const String camera = 'camera.fill';
  static const String photos = 'photo.fill';
  static const String videos = 'video.fill';
  static const String music = 'music.note';
  static const String calendar = 'calendar';
  static const String clock = 'clock.fill';
  static const String location = 'location.fill';
  static const String map = 'map.fill';
  static const String bookmark = 'bookmark.fill';
  static const String tag = 'tag.fill';
  static const String folder = 'folder.fill';
  static const String document = 'doc.fill';
  static const String cloud = 'cloud.fill';
  static const String share = 'square.and.arrow.up';
  static const String download = 'arrow.down.circle.fill';
  static const String upload = 'arrow.up.circle.fill';
  static const String trash = 'trash.fill';
  static const String edit = 'pencil';
  static const String add = 'plus.circle.fill';
  static const String remove = 'minus.circle.fill';
  static const String check = 'checkmark.circle.fill';
  static const String close = 'xmark.circle.fill';
  static const String info = 'info.circle.fill';
  static const String help = 'questionmark.circle.fill';
  static const String menu = 'line.3.horizontal';
  static const String more = 'ellipsis.circle.fill';
}
