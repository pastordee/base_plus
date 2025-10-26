import 'dart:math';

import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoDynamicColor, CupertinoTheme;
import 'package:flutter/material.dart';

import '../base_class.dart';
import '../base_param.dart';

/// Use different colors for Brightness.light and Brightness.dark
///
/// * Must call build(context) method when using
/// * In cupertino mode, dynamicColor value takes priority
/// * In material mode, color and darkColor values take priority
///
class BaseColor extends BaseClass {
  const BaseColor({
    this.color,
    this.darkColor,
    this.dynamicColor = CupertinoColors.secondarySystemBackground,
    BaseParam? baseParam,
  })  : assert(color != null || darkColor != null || dynamicColor != null),
        super(baseParam: baseParam);

  /// High contrast, generally used for background color
  /// Default: Brightness.light uses black, Brightness.dark uses white
  const BaseColor.highContrast({
    this.color,
    this.darkColor,
    this.dynamicColor = const CupertinoDynamicColor.withBrightness(
      color: Colors.black,
      darkColor: Colors.white,
    ),
    BaseParam? baseParam,
  })  : assert(color != null || darkColor != null || dynamicColor != null),
        super(baseParam: baseParam);

  /// When brightness = Brightness.light
  ///
  /// Priority value in material mode
  final Color? color;

  /// When brightness = Brightness.dark
  ///
  /// Priority value in material mode
  final Color? darkColor;

  /// [CupertinoDynamicColor]
  ///
  /// Priority value in cupertino mode
  final CupertinoDynamicColor? dynamicColor;

  @override
  dynamic valueOf(String key, dynamic value) {
    return valueOfBaseParam(baseParam, key, value);
  }

  @override
  Color buildByCupertino(BuildContext context) {
    final CupertinoDynamicColor? _dynamicColor = valueOf(
      'dynamicColor',
      dynamicColor,
    );
    if (_dynamicColor != null) {
      return _dynamicColor.resolveFrom(context);
    }
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    brightness = CupertinoTheme.of(context).brightness ?? Brightness.light;
    final Color? color = valueOf('color', this.color);
    final Color? darkColor = valueOf('color', this.darkColor);
    Color finalColor;
    if (brightness == Brightness.light) {
      finalColor = color ?? Colors.black;
    } else {
      finalColor = darkColor ?? Colors.white;
    }
    return finalColor;
  }

  @override
  Color buildByMaterial(BuildContext context) {
    final Color? color = valueOf('color', this.color);
    final Color? darkColor = valueOf('color', this.darkColor);
    final CupertinoDynamicColor? dynamicColor = valueOf(
      'dynamicColor',
      this.dynamicColor,
    );
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    Color finalColor = Colors.white;
    switch (brightness) {
      case Brightness.light:
        finalColor = color ?? dynamicColor?.color ?? Colors.black;
        break;
      case Brightness.dark:
        finalColor = darkColor ?? dynamicColor?.darkColor ?? Colors.white;
        break;
    }
    return finalColor;
  }
}

/// Random color, does not support custom ranges
class BaseRandomColor extends Color {
  /// Same as [Color.fromARGB], if parameter has value, lock that value
  BaseRandomColor({int? a, int? r, int? g, int? b})
      : super(((((a ?? Random().nextInt(256)) & 0xff) << 24) |
                (((r ?? Random().nextInt(256)) & 0xff) << 16) |
                (((g ?? Random().nextInt(256)) & 0xff) << 8) |
                (((b ?? Random().nextInt(256)) & 0xff) << 0)) &
            0xFFFFFFFF);

  /// Same as [Color.fromRGBO], if parameter has value, lock that value
  BaseRandomColor.fromRGBO({int? r, int? g, int? b, double? opacity})
      : super((((((opacity ?? Random().nextDouble()) * 0xff ~/ 1) & 0xff) << 24) |
                (((r ?? Random().nextInt(256)) & 0xff) << 16) |
                (((g ?? Random().nextInt(256)) & 0xff) << 8) |
                (((b ?? Random().nextInt(256)) & 0xff) << 0)) &
            0xFFFFFFFF);

  /// Fixed red
  BaseRandomColor.withRed(int r)
      : super((((Random().nextInt(256) & 0xff) << 24) | ((r & 0xff) << 16) | ((Random().nextInt(256) & 0xff) << 8) | ((Random().nextInt(256) & 0xff) << 0)) &
            0xFFFFFFFF);

  /// Fixed blue
  BaseRandomColor.withBlue(int b)
      : super((((Random().nextInt(256) & 0xff) << 24) | ((Random().nextInt(256) & 0xff) << 16) | ((Random().nextInt(256) & 0xff) << 8) | ((b & 0xff) << 0)) &
            0xFFFFFFFF);

  /// Fixed green
  BaseRandomColor.withGreen(int g)
      : super((((Random().nextInt(256) & 0xff) << 24) | ((Random().nextInt(256) & 0xff) << 16) | ((g & 0xff) << 8) | ((Random().nextInt(256) & 0xff) << 0)) &
            0xFFFFFFFF);

  /// Fixed alpha
  BaseRandomColor.withAlpha(int a)
      : super((((a & 0xff) << 24) | ((Random().nextInt(256) & 0xff) << 16) | ((Random().nextInt(256) & 0xff) << 8) | ((Random().nextInt(256) & 0xff) << 0)) &
            0xFFFFFFFF);

  /// Fixed opacity
  BaseRandomColor.withOpacity(double opacity)
      : super(((((opacity * 0xff ~/ 1) & 0xff) << 24) |
                ((Random().nextInt(256) & 0xff) << 16) |
                ((Random().nextInt(256) & 0xff) << 8) |
                ((Random().nextInt(256) & 0xff) << 0)) &
            0xFFFFFFFF);
}
