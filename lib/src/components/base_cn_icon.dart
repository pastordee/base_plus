import 'package:flutter/widgets.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseCNIcon - Native iOS icon using SF Symbols via CNIcon
/// 
/// Provides a simpler API for using native SF Symbols on iOS
/// Falls back to regular Icon on Android
/// 
/// Example:
/// ```dart
/// BaseCNIcon(
///   symbol: 'heart.fill',
///   size: 24,
///   color: Colors.red,
/// )
/// ```
class BaseCNIcon extends BaseStatelessWidget {
  const BaseCNIcon({
    Key? key,
    required this.symbol,
    this.size = 24,
    this.color,
    this.fallbackIcon,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// SF Symbol name (e.g., 'heart.fill', 'star', 'gearshape')
  final String symbol;

  /// Icon size
  final double size;

  /// Icon color
  final Color? color;

  /// Fallback Material icon for Android
  /// If not provided, will try to show the symbol name as text
  final IconData? fallbackIcon;

  @override
  Widget buildByCupertino(BuildContext context) {
    return CNIcon(
      symbol: CNSymbol(
        valueOf('symbol', symbol),
        size: valueOf('size', size),
      ),
      size: valueOf('size', size),
      color: valueOf('color', color),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final iconData = valueOf('fallbackIcon', fallbackIcon);
    if (iconData != null) {
      return Icon(
        iconData,
        size: valueOf('size', size),
        color: valueOf('color', color),
      );
    }
    
    // Fallback: show symbol name as text
    return Text(
      valueOf('symbol', symbol),
      style: TextStyle(
        fontSize: valueOf('size', size),
        color: valueOf('color', color),
      ),
    );
  }
}
