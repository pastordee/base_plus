import 'package:flutter/widgets.dart';
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseCNIcon - Native iOS icon using SF Symbols via CNIcon
/// 
/// **DEPRECATED**: Use [BaseIconButton] instead, which now includes native SF Symbols support.
/// 
/// [BaseIconButton] provides the same functionality with additional features:
/// - iOS 26 Liquid Glass Dynamic Material effects
/// - Interactive button functionality
/// - Material 3 integration
/// - Haptic feedback support
/// - Better cross-platform fallback handling
/// 
/// Migration example:
/// ```dart
/// // Old (BaseCNIcon)
/// BaseCNIcon(
///   symbol: 'heart.fill',
///   size: 24,
///   color: Colors.red,
/// )
/// 
/// // New (BaseIconButton)
/// BaseIconButton(
///   symbol: 'heart.fill',
///   iconSize: 24,
///   color: Colors.red,
///   onPressed: null, // or provide a callback for interactive icons
/// )
/// ```
/// 
/// @deprecated Use [BaseIconButton] with symbol parameter instead
@Deprecated('Use BaseIconButton with symbol parameter instead')
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
