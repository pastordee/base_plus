import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseCNSlider - Native iOS slider using CNSlider
/// 
/// Provides enhanced slider with native iOS appearance
/// Falls back to Material Slider on Android
/// 
/// Example:
/// ```dart
/// BaseCNSlider(
///   value: _sliderValue,
///   min: 0,
///   max: 100,
///   onChanged: (v) => setState(() => _sliderValue = v),
/// )
/// ```
class BaseCNSlider extends BaseStatelessWidget {
  const BaseCNSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.divisions,
    this.label,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// Current slider value
  final double value;

  /// Called when the slider value changes
  final ValueChanged<double>? onChanged;

  /// Minimum value
  final double min;

  /// Maximum value
  final double max;

  /// Whether the slider is enabled
  final bool enabled;

  /// Active track color
  final Color? activeColor;

  /// Inactive track color (Material only)
  final Color? inactiveColor;

  /// Number of discrete divisions (Material only)
  final int? divisions;

  /// Label text (Material only)
  final String? label;

  @override
  Widget buildByCupertino(BuildContext context) {
    return CNSlider(
      value: valueOf('value', value),
      min: valueOf('min', min),
      max: valueOf('max', max),
      enabled: valueOf('enabled', enabled) && onChanged != null,
      onChanged: valueOf('onChanged', onChanged),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    return Slider(
      value: valueOf('value', value),
      min: valueOf('min', min),
      max: valueOf('max', max),
      divisions: valueOf('divisions', divisions),
      label: valueOf('label', label),
      activeColor: valueOf('activeColor', activeColor),
      inactiveColor: valueOf('inactiveColor', inactiveColor),
      onChanged: valueOf('onChanged', onChanged),
    );
  }
}
