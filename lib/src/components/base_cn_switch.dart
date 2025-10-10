import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseCNSwitch - Native iOS switch using CNSwitch
/// 
/// Provides enhanced switch with native iOS appearance
/// Falls back to Material Switch on Android
/// 
/// Example:
/// ```dart
/// BaseCNSwitch(
///   value: _switchValue,
///   onChanged: (v) => setState(() => _switchValue = v),
///   color: Colors.pink,
/// )
/// ```
class BaseCNSwitch extends BaseStatelessWidget {
  const BaseCNSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.color,
    this.activeColor,
    this.inactiveTrackColor,
    this.thumbColor,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// Current switch value
  final bool value;

  /// Called when the switch value changes
  final ValueChanged<bool>? onChanged;

  /// Switch color (CNSwitch uses this for active color)
  final Color? color;

  /// Active color (Material only, overrides color if provided)
  final Color? activeColor;

  /// Inactive track color (Material only)
  final Color? inactiveTrackColor;

  /// Thumb color (Material only)
  final MaterialStateProperty<Color?>? thumbColor;

  @override
  Widget buildByCupertino(BuildContext context) {
    return CNSwitch(
      value: valueOf('value', value),
      color: valueOf('color', color),
      onChanged: valueOf('onChanged', onChanged),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    return Switch(
      value: valueOf('value', value),
      onChanged: valueOf('onChanged', onChanged),
      activeColor: valueOf('activeColor', activeColor) ?? valueOf('color', color),
      inactiveTrackColor: valueOf('inactiveTrackColor', inactiveTrackColor),
      thumbColor: valueOf('thumbColor', thumbColor),
    );
  }
}
