import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseSlider - Cross-platform slider with native iOS support
/// 
/// Uses CNSlider (Cupertino Native) for iOS - provides true native iOS appearance
/// with built-in liquid glass effects and native rendering.
/// Uses Material Slider for Android and other platforms.
/// 
/// *** use cupertino = { forceUseMaterial: true } force use Material Slider on iOS
/// *** use material = { forceUseCupertino: true } force use CNSlider on Android
///
/// Features:
/// - Native iOS slider via CNSlider (cupertino_native package)
/// - Material Design slider for Android
/// - Consistent API across platforms
/// - Built-in liquid glass effects on iOS (no manual wrapper needed)
/// - Discrete divisions and labels (Material only)
/// 
/// Example:
/// ```dart
/// BaseSlider(
///   value: _sliderValue,
///   min: 0,
///   max: 100,
///   onChanged: (v) => setState(() => _sliderValue = v),
/// )
/// ```
/// 
/// Updated: 2024.10.25 - Integrated CNSlider for native iOS rendering
class BaseSlider extends BaseStatelessWidget {
  const BaseSlider({
    Key? key,
    this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.thumbColor = Colors.white,
    this.label,
    this.inactiveColor,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.semanticFormatterCallback,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties end ***

  /// [CupertinoSlider.value]
  /// or
  /// [Slider.value]
  final double? value;

  /// [CupertinoSlider.onChanged]
  /// or
  /// [Slider.onChanged]
  final ValueChanged<double>? onChanged;

  /// [CupertinoSlider.onChangeStart]
  /// or
  /// [Slider.onChangeStart]
  final ValueChanged<double>? onChangeStart;

  /// [CupertinoSlider.onChangeEnd]
  /// or
  /// [Slider.onChangeEnd]
  final ValueChanged<double>? onChangeEnd;

  /// [CupertinoSlider.min]
  /// or
  /// [Slider.min]
  final double min;

  /// [CupertinoSlider.max]
  /// or
  /// [Slider.max]
  final double max;

  /// [CupertinoSlider.divisions]
  /// or
  /// [Slider.divisions]
  final int? divisions;

  /// [CupertinoSlider.activeColor]
  /// or
  /// [Slider.activeColor]
  final Color? activeColor;

  /// *** general properties end ***

  /// *** cupertino properties start ***

  /// [CupertinoSlider.thumbColor]
  final Color thumbColor;

  /// *** cupertino properties end ***

  /// *** material properties start ***

  /// [Slider.label]
  final String? label;

  /// [Slider.inactiveColor]
  final Color? inactiveColor;

  /// [Slider.mouseCursor]
  final MouseCursor? mouseCursor;

  /// [Slider.focusNode]
  final FocusNode? focusNode;

  /// [Slider.autofocus]
  final bool autofocus;

  /// [Slider.semanticFormatterCallback]
  final SemanticFormatterCallback? semanticFormatterCallback;

  /// *** material properties end ***

  @override
  Widget buildByCupertino(BuildContext context) {
    return CNSlider(
      value: valueOf('value', value) ?? 0.0,
      min: valueOf('min', min),
      max: valueOf('max', max),
      enabled: onChanged != null,
      onChanged: valueOf('onChanged', onChanged),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    return Slider(
      value: valueOf('value', value),
      onChanged: valueOf('onChanged', onChanged),
      onChangeStart: valueOf('onChangeStart', onChangeStart),
      onChangeEnd: valueOf('onChangeEnd', onChangeEnd),
      min: valueOf('min', min),
      max: valueOf('max', max),
      divisions: valueOf('divisions', divisions),
      label: valueOf('label', label),
      activeColor: valueOf('activeColor', activeColor),
      inactiveColor: valueOf('inactiveColor', inactiveColor),
      mouseCursor: valueOf('mouseCursor', mouseCursor),
      semanticFormatterCallback: valueOf('semanticFormatterCallback', semanticFormatterCallback),
      focusNode: valueOf('focusNode', focusNode),
      autofocus: valueOf('autofocus', autofocus),
    );
  }
}
