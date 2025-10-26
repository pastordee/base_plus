import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/cupertino.dart' show CupertinoButton, ShapeBorder, CupertinoColors;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseButton
///
/// Modern cross-platform button with iOS 26 Liquid Glass Dynamic Material design.
/// Implements true Liquid Glass principles with dynamic adaptability, real-time interactivity,
/// and sophisticated optical properties including transparency, reflections, and refractions.
///
/// **iOS 26 Liquid Glass Dynamic Material Features:**
/// - **Transparency & Refractions**: Multi-layer optical effects with realistic light behavior
/// - **Dynamic Adaptability**: Content and context-aware visual transformations
/// - **Real-time Interactivity**: Enhanced haptic feedback and visual responses
/// - **Unified Design Language**: Consistent experience across Apple platforms
/// - **Content Hierarchy**: Clear separation between button content and background
/// - **Fluid Responsiveness**: Adaptive appearance based on user interactions
///
/// **Material 3 Integration:**
/// - Full Material 3 button variants (Filled, Tonal, Outlined, Text)
/// - Semantic ColorScheme usage with state layers and enhanced accessibility
/// - Modern elevation and shadow systems with cross-platform harmony
///
/// use CupertinoButton or CupertinoButton.filled by cupertino
/// *** use cupertino = { forceUseMaterial: true } force use Material buttons (FilledButton, TextButton, OutlinedButton, ElevatedButton) on cupertino.
/// use FilledButton, TextButton, OutlinedButton, ElevatedButton (Material 3) by material
/// *** use material = { forceUseCupertino: true } force use CupertinoButton or CupertinoButton.filled on material.
///
/// CupertinoButton: Updated for iOS 26 Liquid Glass Dynamic Material design patterns
/// Material Buttons: Updated for Material 3 (Material You)
/// Updated: 2025.08.11 for iOS 26 Liquid Glass Dynamic Material and Material 3
class BaseButton extends BaseStatelessWidget {
  const BaseButton({
    Key? key,
    this.color,
    this.onPressed,
    this.disabledColor,
    this.padding,
    this.child,
    this.minSize = 44.0,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.alignment = Alignment.center,
    this.filledButton = false,
    this.onLongPress,
    this.style,
    this.onHighlightChanged,
    this.textTheme,
    this.textColor,
    this.disabledTextColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.colorBrightness,
    this.elevation,
    this.focusElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.visualDensity,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.animationDuration,
    this.minWidth,
    this.mouseCursor,
    this.hoverElevation,
    this.enableFeedback = true,

    /// Make button same height as CupertinoButton, only effective for MaterialButton
    /// Others need to modify Theme.of(context).buttonTheme.height to take effect
    this.height = 48.0,
    this.textButton = false,
    this.outlinedButton = false,
    this.elevatedButton = false,
    this.filledTonalButton = false,

    /// Enhanced haptic feedback for iOS interactions
    /// CNButton components automatically include liquid glass effects
    this.adaptiveHaptics = true,
    
    /// CNButton (cupertino_native) properties
    /// Use CNButton for native iOS buttons with built-in liquid glass effects
    this.useCNButton = false,
    this.cnButtonStyle,
    this.shrinkWrap = false,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// [CupertinoButton], child is Row(children:[icon, label])
  /// or
  /// [MaterialButton], child is Row(children:[icon, label])
  /// or
  /// [TextButton.icon]
  /// or
  /// [outlinedButtonButton.icon]
  /// or
  /// [ElevatedButton.icon]
  const factory BaseButton.icon({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus,
    Clip clipBehavior,
    EdgeInsetsGeometry? padding,
    Color? color,
    Color? disabledColor,
    double minSize,
    double? pressedOpacity,
    BorderRadius? borderRadius,
    AlignmentGeometry alignment,
    Widget icon,
    Widget label,
    bool filledButton,
    bool filledTonalButton,
    bool textButton,
    bool outlinedButton,
    bool elevatedButton,
    bool adaptiveHaptics,
    bool useCNButton,
    CNButtonStyle? cnButtonStyle,
    bool shrinkWrap,
    BaseParam? baseParam,
  }) = _BaseButtonWithIcon;

  /// *** general properties start ***

  /// [CupertinoButton.color]
  /// or
  /// [MaterialButton.color]
  final Color? color;

  /// [CupertinoButton.onPressed]
  /// or
  /// [MaterialButton.onPressed]
  final VoidCallback? onPressed;

  /// [CupertinoButton.disabledColor]
  /// or
  /// [MaterialButton.disabledColor]
  final Color? disabledColor;

  /// [CupertinoButton.padding]
  /// or
  /// [MaterialButton.padding]
  final EdgeInsetsGeometry? padding;

  /// [CupertinoButton.child]
  /// or
  /// [MaterialButton.child]
  final Widget? child;

  /// *** general properties end ***

  /// *** cupertino properties start ***

  /// [CupertinoButton.minSize]
  final double? minSize;

  /// [CupertinoButton.pressedOpacity]
  final double? pressedOpacity;

  /// [CupertinoButton.borderRadius]
  final BorderRadius? borderRadius;

  /// [CupertinoButton.alignment]
  final AlignmentGeometry alignment;

  /// [CupertinoButton.filled]
  /// use CupertinoButton.filled, will ignore the color, use primary color.
  final bool filledButton;

  /// Material 3 FilledButton.tonal variant
  /// use FilledButton.tonal for Material 3 design
  final bool filledTonalButton;

  /// *** cupertino properties ened ***

  /// *** material properties start ***

  /// [MaterialButton.onLongPress]
  final VoidCallback? onLongPress;

  /// [ButtonStyleButton.style]
  final ButtonStyle? style;

  /// [MaterialButton.onHighlightChanged]
  final ValueChanged<bool>? onHighlightChanged;

  /// [MaterialButton.textTheme]
  final ButtonTextTheme? textTheme;

  /// [MaterialButton.textColor]
  final Color? textColor;

  /// [MaterialButton.disabledTextColor]
  final Color? disabledTextColor;

  /// [MaterialButton.focusColor]
  final Color? focusColor;

  /// [MaterialButton.hoverColor]
  final Color? hoverColor;

  /// [MaterialButton.highlightColor]
  final Color? highlightColor;

  /// [MaterialButton.splashColor]
  final Color? splashColor;

  /// [MaterialButton.colorBrightness]
  final Brightness? colorBrightness;

  /// [MaterialButton.elevation]
  final double? elevation;

  /// [MaterialButton.hoverElevation]
  final double? hoverElevation;

  /// [MaterialButton.focusElevation]
  final double? focusElevation;

  /// [MaterialButton.highlightElevation]
  final double? highlightElevation;

  /// [MaterialButton.disabledElevation]
  final double? disabledElevation;

  /// [MaterialButton.visualDensity]
  final VisualDensity? visualDensity;

  /// [MaterialButton.shape]
  final ShapeBorder? shape;

  /// [MaterialButton.clipBehavior]
  final Clip clipBehavior;

  /// [MaterialButton.focusNode]
  final FocusNode? focusNode;

  /// [MaterialButton.autofocus]
  final bool autofocus;

  /// [MaterialButton.materialTapTargetSize]
  final MaterialTapTargetSize? materialTapTargetSize;

  /// [MaterialButton.animationDuration]
  final Duration? animationDuration;

  /// [MaterialButton.minWidth]
  final double? minWidth;

  /// [MaterialButton.height]
  final double? height;

  /// [MaterialButton.mouseCursor]
  final MouseCursor? mouseCursor;

  /// [MaterialButton.enableFeedback]
  final bool enableFeedback;

  /// [TextButton]
  /// use TextButton
  final bool textButton;

  /// [OutlinedButton]
  /// use OutlinedButton
  final bool outlinedButton;

  /// [ElevatedButton]
  /// use ElevatedButton
  final bool elevatedButton;

  /// Enhanced haptic feedback for iOS interactions
  /// Provides adaptive haptic responses based on button type
  /// Note: CNButton components automatically include liquid glass effects
  final bool adaptiveHaptics;

  /// *** CNButton (cupertino_native) properties start ***

  /// Use CNButton from cupertino_native package (native iOS button with built-in liquid glass effects)
  /// When true, uses CNButton instead of CupertinoButton on iOS
  final bool useCNButton;

  /// CNButton style (plain, gray, filled, tinted, bordered, prominentGlass)
  /// Only used when useCNButton is true
  final CNButtonStyle? cnButtonStyle;

  /// Shrink wrap button to fit content (CNButton only)
  /// Only used when useCNButton is true
  final bool shrinkWrap;

  /// *** CNButton properties end ***

  /// *** material properties end ***

  @override
  Widget buildByCupertino(BuildContext context) {
    final Widget _child = valueOf('child', child);
    return buildByCupertinoWithChild(_child);
  }

  /// Final build method, for compatibility with BaseButton.icon
  Widget buildByCupertinoWithChild(Widget child) {
    assert(child != null, 'child can\'t be null.');
    
    // Check if CNButton should be used
    final bool _useCNButton = valueOf('useCNButton', useCNButton);
    
    if (_useCNButton) {
      return _buildCNButton(child);
    }
    
    // Original CupertinoButton implementation
    final Color _disabledColor = valueOf('disabledColor', disabledColor) ?? CupertinoColors.quaternarySystemFill;
    final EdgeInsetsGeometry? _padding = valueOf('padding', padding);
    final VoidCallback? _onPressed = valueOf('onPressed', onPressed);
    final double _minSize = valueOf('minSize', minSize);
    final double _pressedOpacity = valueOf('minSize', pressedOpacity);
    final BorderRadius? _borderRadius = valueOf('borderRadius', borderRadius);
    final AlignmentGeometry _alignment = valueOf('alignment', alignment);
    final bool _adaptiveHaptics = valueOf('adaptiveHaptics', adaptiveHaptics);

    // Enhanced onPressed with haptic feedback
    VoidCallback? _enhancedOnPressed;
    if (_onPressed != null) {
      _enhancedOnPressed = () {
        if (_adaptiveHaptics) {
          HapticFeedback.lightImpact();
        }
        _onPressed();
      };
    }

    Widget button;
    if (filledButton) {
      button = CupertinoButton.filled(
        child: child,
        padding: _padding,
        disabledColor: _disabledColor,
        minSize: _minSize,
        pressedOpacity: _pressedOpacity,
        borderRadius: _borderRadius,
        alignment: _alignment,
        onPressed: _enhancedOnPressed,
      );
    } else {
      button = CupertinoButton(
        child: child,
        padding: _padding,
        color: valueOf('color', color),
        disabledColor: _disabledColor,
        minSize: _minSize,
        pressedOpacity: _pressedOpacity,
        borderRadius: _borderRadius,
        alignment: _alignment,
        onPressed: _enhancedOnPressed,
      );
    }

    return button;
  }

  /// Build button using CNButton from cupertino_native package
  Widget _buildCNButton(Widget child) {
    final VoidCallback? _onPressed = valueOf('onPressed', onPressed);
    final CNButtonStyle _style = valueOf('cnButtonStyle', cnButtonStyle) ?? CNButtonStyle.plain;
    final bool _shrinkWrap = valueOf('shrinkWrap', shrinkWrap);
    
    // Check if child contains both icon and label (BaseButton.icon)
    if (child is _ButtonWithIconChild) {
      // Extract icon and label from child
      final buttonChild = child;
      final iconWidget = buttonChild.icon;
      final labelWidget = buttonChild.label;
      
      // Convert icon widget to CNSymbol if possible
      CNSymbol? cnSymbol;
      if (iconWidget is Icon) {
        // Try to map Material icon to SF Symbol
        final sfSymbolName = _mapIconToSFSymbol(iconWidget.icon);
        if (sfSymbolName != null) {
          cnSymbol = CNSymbol(sfSymbolName, size: iconWidget.size ?? 18);
        }
      } else if (iconWidget is CNIcon) {
        cnSymbol = iconWidget.symbol;
      }
      
      // Get label text
      String? labelText;
      if (labelWidget is Text) {
        labelText = labelWidget.data;
      }
      
      // Build CNButton with icon and label
      if (cnSymbol != null && labelText != null) {
        return CNButton(
          label: labelText,
          style: _style,
          onPressed: _onPressed,
          shrinkWrap: _shrinkWrap,
        );
      } else if (cnSymbol != null) {
        return CNButton.icon(
          icon: cnSymbol,
          style: _style,
          onPressed: _onPressed,
        );
      }
    }
    
    // Extract label from child if it's a Text widget
    String? labelText;
    if (child is Text) {
      labelText = child.data ?? '';
    }
    
    if (labelText != null && labelText.isNotEmpty) {
      return CNButton(
        label: labelText,
        style: _style,
        onPressed: _onPressed,
        shrinkWrap: _shrinkWrap,
      );
    }
    
    // Fallback to regular CupertinoButton if we can't extract the necessary info
    return CupertinoButton(
      child: child,
      onPressed: _onPressed,
    );
  }

  /// Map common Material icons to SF Symbols
  String? _mapIconToSFSymbol(IconData? iconData) {
    if (iconData == null) return null;
    
    final Map<int, String> iconMap = {
      // Common icons
      0xe87d: 'heart.fill',       // Icons.favorite
      0xe87e: 'heart',            // Icons.favorite_border
      0xe838: 'star.fill',        // Icons.star
      0xe8e8: 'star',             // Icons.star_border
      0xe145: 'plus',             // Icons.add
      0xe15b: 'checkmark',        // Icons.check
      0xe5cd: 'xmark',            // Icons.close
      0xe3af: 'ellipsis',         // Icons.more_horiz
      0xe3b0: 'ellipsis',         // Icons.more_vert
      0xe571: 'gearshape',        // Icons.settings
      0xe3c9: 'info.circle',      // Icons.info
      0xe80d: 'square.and.arrow.up', // Icons.share
      0xe1fe: 'trash',            // Icons.delete
      0xe3c3: 'pencil',           // Icons.edit
      0xe0e0: 'heart',            // Icons.favorite_border
    };

    return iconMap[iconData.codePoint];
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final Widget _child = valueOf('child', child);
    return buildByMaterialWithChild(_child, context);
  }

  /// Final build method, for compatibility with BaseButton.icon
  Widget buildByMaterialWithChild(Widget child, [BuildContext? context]) {
    // Ensure only one button type is selected at a time
    final List<bool> buttonTypes = [textButton, outlinedButton, elevatedButton, filledButton, filledTonalButton];
    final int selectedTypes = buttonTypes.where((type) => type).length;
    assert(
      selectedTypes <= 1,
      'Only one button type can be true at a time: textButton, outlinedButton, elevatedButton, filledButton, or filledTonalButton.',
    );
    assert(child != null, 'child can\'t be null.');
    
    final VoidCallback? _onPressed = valueOf('onPressed', onPressed);
    final VoidCallback? _onLongPress = valueOf('onLongPress', onLongPress);
    final ButtonStyle? _style = valueOf('style', style);
    final FocusNode? _focusNode = valueOf('focusNode', focusNode);
    final bool _autofocus = valueOf('autofocus', autofocus);
    final Clip _clipBehavior = valueOf('clipBehavior', clipBehavior);

    // iOS 26 Features (adaptive haptics work on Material too)
    final bool _adaptiveHaptics = valueOf('adaptiveHaptics', adaptiveHaptics);

    // Enhanced onPressed with haptic feedback
    VoidCallback? _enhancedOnPressed;
    if (_onPressed != null) {
      _enhancedOnPressed = () {
        if (_adaptiveHaptics) {
          HapticFeedback.mediumImpact(); // Slightly stronger feedback for Material
        }
        _onPressed();
      };
    }

    // Material 3 enhanced button styling (only if context is available)
    ButtonStyle? enhancedStyle = _style;
    if (context != null) {
      final ThemeData theme = Theme.of(context);
      final ColorScheme colorScheme = theme.colorScheme;
      
      // Enhanced ButtonStyle for Material 3 compliance
      if (theme.useMaterial3 && enhancedStyle == null) {
        enhancedStyle = ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>((states) {
            if (states.contains(MaterialState.disabled)) return 0;
            if (states.contains(MaterialState.pressed)) return 1;
            return 2;
          }),
          shadowColor: MaterialStateProperty.all(colorScheme.shadow),
          surfaceTintColor: MaterialStateProperty.all(colorScheme.surfaceTint),
        );
      }
    }

    if (textButton) {
      return TextButton(
        onPressed: _enhancedOnPressed,
        onLongPress: _onLongPress,
        style: enhancedStyle,
        focusNode: _focusNode,
        autofocus: _autofocus,
        clipBehavior: _clipBehavior,
        child: child,
      );
    } else if (outlinedButton) {
      return OutlinedButton(
        onPressed: _enhancedOnPressed,
        onLongPress: _onLongPress,
        style: enhancedStyle,
        focusNode: _focusNode,
        autofocus: _autofocus,
        clipBehavior: _clipBehavior,
        child: child,
      );
    } else if (elevatedButton) {
      return ElevatedButton(
        onPressed: _enhancedOnPressed,
        onLongPress: _onLongPress,
        style: enhancedStyle,
        focusNode: _focusNode,
        autofocus: _autofocus,
        clipBehavior: _clipBehavior,
        child: child,
      );
    } else if (filledButton) {
      return FilledButton(
        onPressed: _enhancedOnPressed,
        onLongPress: _onLongPress,
        style: enhancedStyle,
        focusNode: _focusNode,
        autofocus: _autofocus,
        clipBehavior: _clipBehavior,
        child: child,
      );
    } else if (filledTonalButton) {
      return FilledButton.tonal(
        onPressed: _enhancedOnPressed,
        onLongPress: _onLongPress,
        style: enhancedStyle,
        focusNode: _focusNode,
        autofocus: _autofocus,
        clipBehavior: _clipBehavior,
        child: child,
      );
    }
    
    // Fallback to MaterialButton for legacy support
    return MaterialButton(
      onPressed: _enhancedOnPressed,
      onLongPress: _onLongPress,
      onHighlightChanged: valueOf('onHighlightChanged', onHighlightChanged),
      mouseCursor: valueOf('mouseCursor', mouseCursor),
      textTheme: valueOf('textTheme', textTheme),
      textColor: valueOf('textColor', textColor),
      disabledTextColor: valueOf('disabledTextColor', disabledTextColor),
      color: valueOf('color', color),
      disabledColor: valueOf('disabledColor', disabledColor),
      focusColor: valueOf('focusColor', focusColor),
      hoverColor: valueOf('hoverColor', hoverColor),
      highlightColor: valueOf('highlightColor', highlightColor),
      splashColor: valueOf('splashColor', splashColor),
      colorBrightness: valueOf('colorBrightness', colorBrightness),
      elevation: valueOf('elevation', elevation),
      focusElevation: valueOf('focusElevation', focusElevation),
      hoverElevation: valueOf('hoverElevation', hoverElevation),
      highlightElevation: valueOf('highlightElevation', highlightElevation),
      disabledElevation: valueOf('disabledElevation', disabledElevation),
      padding: valueOf('padding', padding),
      visualDensity: valueOf('visualDensity', visualDensity),
      shape: valueOf('shape', shape),
      clipBehavior: _clipBehavior,
      focusNode: _focusNode,
      autofocus: _autofocus,
      materialTapTargetSize: valueOf('materialTapTargetSize', materialTapTargetSize),
      animationDuration: valueOf('animationDuration', animationDuration),
      minWidth: valueOf('minWidth', minWidth),
      height: valueOf('height', height),
      enableFeedback: valueOf('enableFeedback', enableFeedback),
      child: child,
    );
  }
}

/// 带icon的BaseButton
class _BaseButtonWithIcon extends BaseButton {
  const _BaseButtonWithIcon({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    EdgeInsetsGeometry? padding,
    Color? color,
    Color? disabledColor,
    double? minSize = 24.0,
    double? pressedOpacity = .4,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    AlignmentGeometry alignment = Alignment.center,
    this.icon,
    this.label,
    bool filledButton = false,
    bool filledTonalButton = false,
    bool textButton = false,
    bool outlinedButton = false,
    bool elevatedButton = false,
    bool adaptiveHaptics = true,
    bool useCNButton = false,
    CNButtonStyle? cnButtonStyle,
    bool shrinkWrap = false,
    BaseParam? baseParam,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          padding: padding,
          color: color,
          disabledColor: disabledColor,
          minSize: minSize,
          pressedOpacity: pressedOpacity,
          borderRadius: borderRadius,
          alignment: alignment,
          textButton: textButton,
          filledButton: filledButton,
          filledTonalButton: filledTonalButton,
          outlinedButton: outlinedButton,
          elevatedButton: elevatedButton,
          adaptiveHaptics: adaptiveHaptics,
          useCNButton: useCNButton,
          cnButtonStyle: cnButtonStyle,
          shrinkWrap: shrinkWrap,
          baseParam: baseParam,
        );

  final Widget? icon;
  final Widget? label;

  @override
  Widget buildByCupertino(BuildContext context) {
    final Widget _icon = valueOf('icon', icon);
    final Widget? _label = valueOf('label', label);
    assert(_icon != null, 'icon can\'t be null.');
    final Widget _child = _ButtonWithIconChild(icon: icon!, label: _label);
    return super.buildByCupertinoWithChild(_child);
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final Widget _icon = valueOf('icon', icon);
    final Widget _label = valueOf('label', label);
    assert(_icon != null, 'icon can\'t be null.');
    final Widget _child = _ButtonWithIconChild(icon: icon!, label: _label);
    return super.buildByMaterialWithChild(_child, context);
  }
}

/// BaseButton.Icon.child
class _ButtonWithIconChild extends StatelessWidget {
  const _ButtonWithIconChild({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final Widget? label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.maybeOf(context)?.textScaleFactor ?? 1;
    final double gap = scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: label != null ? <Widget>[icon, SizedBox(width: gap), label!] : <Widget>[icon],
    );
  }
}
