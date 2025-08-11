import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

/// Enhanced Material widget with iOS 26 Liquid Glass Dynamic Material support
class BaseMaterialWidget extends StatefulWidget {
  final Widget child;
  final ThemeData? theme;
  final InteractiveInkFeatureFactory? splashFactory;
  final bool enableLiquidGlass;
  final bool enableEnvironmentalAwareness;
  final bool enableHapticFeedback;
  final MaterialType materialType;
  final Color? surfaceColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Duration animationDuration;
  final Curve animationCurve;

  /// Legacy constructor with iOS 26 Liquid Glass enhancements
  BaseMaterialWidget({
    Key? key,
    required Widget child,
    this.theme,
    InteractiveInkFeatureFactory? splashFactory,
    this.enableLiquidGlass = true,
    this.enableEnvironmentalAwareness = true,
    this.enableHapticFeedback = true,
    this.materialType = MaterialType.transparency,
    this.surfaceColor,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
  })  : assert(child != null, 'child can not be null.'),
        assert(
            (theme == null && splashFactory == null) ||
                (theme != null && splashFactory != null),
            'theme and factory must be the same value.'),
        child = (theme != null && splashFactory != null)
            ? _buildThemedChild(child, theme, splashFactory)
            : child,
        splashFactory = splashFactory ?? InkRipple.splashFactory,
        super(key: key);

  /// Custom material component without ripple effects
  /// Enhanced with iOS 26 Liquid Glass environmental awareness
  /// Suitable for using material components in cupertino mode
  BaseMaterialWidget.withoutSplash({
    Key? key,
    required Widget child,
    this.theme,
    this.enableLiquidGlass = true,
    this.enableEnvironmentalAwareness = true,
    this.enableHapticFeedback = false,
    this.materialType = MaterialType.transparency,
    this.surfaceColor,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
  })  : assert(child != null, 'child can not be null.'),
        child = _buildThemedChild(child, theme!, WithoutSplashFactory()),
        splashFactory = WithoutSplashFactory(),
        super(key: key);

  /// Factory for Material 3 Design System integration
  factory BaseMaterialWidget.material3({
    Key? key,
    required Widget child,
    ThemeData? theme,
    InteractiveInkFeatureFactory? splashFactory,
    bool enableLiquidGlass = true,
    bool enableEnvironmentalAwareness = true,
    bool enableHapticFeedback = true,
    Color? surfaceColor,
    double? elevation = 1.0,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return BaseMaterialWidget(
      key: key,
      child: child,
      theme: theme,
      splashFactory: splashFactory ?? InkRipple.splashFactory,
      enableLiquidGlass: enableLiquidGlass,
      enableEnvironmentalAwareness: enableEnvironmentalAwareness,
      enableHapticFeedback: enableHapticFeedback,
      materialType: MaterialType.card,
      surfaceColor: surfaceColor,
      elevation: elevation,
      borderRadius: borderRadius ?? BorderRadius.circular(12.0),
      padding: padding,
    );
  }

  /// Factory for iOS 26 Liquid Glass effect
  factory BaseMaterialWidget.liquidGlass({
    Key? key,
    required Widget child,
    ThemeData? theme,
    bool enableEnvironmentalAwareness = true,
    bool enableHapticFeedback = true,
    Color? surfaceColor,
    double? elevation = 8.0,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return BaseMaterialWidget(
      key: key,
      child: child,
      theme: theme,
      splashFactory: InkSparkle.splashFactory,
      enableLiquidGlass: true,
      enableEnvironmentalAwareness: enableEnvironmentalAwareness,
      enableHapticFeedback: enableHapticFeedback,
      materialType: MaterialType.canvas,
      surfaceColor: surfaceColor,
      elevation: elevation,
      borderRadius: borderRadius ?? BorderRadius.circular(16.0),
      padding: padding,
    );
  }

  static Widget _buildThemedChild(Widget child, ThemeData theme, InteractiveInkFeatureFactory splashFactory) {
    return Theme(
      data: theme.copyWith(
        splashFactory: splashFactory,
      ),
      child: child,
    );
  }

  @override
  State<BaseMaterialWidget> createState() => _BaseMaterialWidgetState();
}

class _BaseMaterialWidgetState extends State<BaseMaterialWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.6, curve: widget.animationCurve),
    ));

    _blurAnimation = Tween<double>(
      begin: 8.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 1.0, curve: widget.animationCurve),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _wrapWithLiquidGlass(Widget child) {
    if (!widget.enableLiquidGlass) return child;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        
        // iOS 26 Liquid Glass properties
        final glassColor = widget.surfaceColor ?? 
            colorScheme.surface.withOpacity(0.85);
        final shadowColor = colorScheme.shadow.withOpacity(0.15);
        final highlightColor = colorScheme.onSurface.withOpacity(0.08);

        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
                color: glassColor,
                boxShadow: [
                  // Primary shadow with environmental awareness
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: (widget.elevation ?? 4.0) * 2.0,
                    offset: Offset(0, (widget.elevation ?? 4.0) * 0.5),
                    spreadRadius: 0.5,
                  ),
                  // Reflection highlight
                  BoxShadow(
                    color: highlightColor,
                    blurRadius: _blurAnimation.value,
                    offset: const Offset(0, -1),
                    spreadRadius: -0.5,
                  ),
                  // Depth shadow
                  BoxShadow(
                    color: shadowColor.withOpacity(0.05),
                    blurRadius: (widget.elevation ?? 4.0) * 4.0,
                    offset: Offset(0, (widget.elevation ?? 4.0) * 1.5),
                    spreadRadius: 1.0,
                  ),
                ],
                // Gradient overlay for Liquid Glass effect
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    highlightColor,
                    Colors.transparent,
                    shadowColor.withOpacity(0.1),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: ClipRRect(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
                child: BackdropFilter(
                  filter: widget.enableEnvironmentalAwareness
                      ? ui.ImageFilter.blur(
                          sigmaX: math.max(0.0, _blurAnimation.value * 0.5),
                          sigmaY: math.max(0.0, _blurAnimation.value * 0.5),
                        )
                      : ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }

  void _handleInteraction() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget materialChild = Material(
      type: widget.materialType,
      color: widget.materialType == MaterialType.transparency 
          ? Colors.transparent 
          : widget.surfaceColor,
      elevation: widget.elevation ?? 0.0,
      borderRadius: widget.borderRadius,
      child: widget.child,
    );

    // Apply Liquid Glass effects if enabled
    if (widget.enableLiquidGlass) {
      materialChild = _wrapWithLiquidGlass(materialChild);
    }

    // Add interaction handling
    return GestureDetector(
      onTap: _handleInteraction,
      child: materialChild,
    );
  }
}

/// Remove ripple effects, but still has 200ms delay highlighting
/// Enhanced with iOS 26 Liquid Glass compatibility
class WithoutSplashFactory extends InteractiveInkFeatureFactory {
  const WithoutSplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required TextDirection textDirection,
    Offset? position,
    required Color color,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return BaseNoSplash(
      controller: controller,
      referenceBox: referenceBox,
      onRemoved: onRemoved,
    );
  }
}

/// iOS 26 Liquid Glass Splash Factory
/// Provides enhanced ripple effects with environmental awareness
class LiquidGlassSplashFactory extends InteractiveInkFeatureFactory {
  const LiquidGlassSplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required TextDirection textDirection,
    Offset? position,
    required Color color,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return InkSparkle(
      controller: controller,
      referenceBox: referenceBox,
      position: position ?? referenceBox.size.center(Offset.zero),
      color: color.withOpacity(0.15), // Enhanced transparency for Liquid Glass
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius ?? BorderRadius.circular(16.0),
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
    );
  }
}

/// Material 3 Enhanced Splash Factory
class Material3SplashFactory extends InteractiveInkFeatureFactory {
  const Material3SplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required TextDirection textDirection,
    Offset? position,
    required Color color,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return InkSparkle(
      controller: controller,
      referenceBox: referenceBox,
      position: position ?? referenceBox.size.center(Offset.zero),
      color: color.withOpacity(0.12), // Material 3 recommended opacity
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius ?? BorderRadius.circular(12.0),
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
    );
  }
}

/// No-operation splash for minimal visual impact
class BaseNoSplash extends InteractiveInkFeature {
  BaseNoSplash({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    VoidCallback? onRemoved,
  }) : super(
          controller: controller,
          referenceBox: referenceBox,
          color: Colors.transparent,
          onRemoved: onRemoved,
        );

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    // No visual effect - empty implementation
  }
}
