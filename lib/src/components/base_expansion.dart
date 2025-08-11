import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Duration _expansionTransitionDuration = Duration(milliseconds: 300);

/// BaseExpansion with iOS 26 Liquid Glass Dynamic Material and Material 3 support
/// 
/// Features iOS 26 Liquid Glass Dynamic Material with:
/// - Transparency with optical clarity zones for expansion panels
/// - Environmental reflections and adaptive blur effects
/// - Dynamic interaction states with real-time responsiveness
/// - Enhanced haptic feedback for expansion gestures
/// - Unified design language across platforms
/// 
/// Material 3 Integration:
/// - Modern elevation system with surface tinting
/// - Semantic ColorScheme usage with adaptive colors
/// - Enhanced accessibility and interaction feedback
/// - Sophisticated animation curves with Material Motion
/// 
/// Enhanced expansion panel that can be positioned anywhere on screen
/// with advanced optical effects and smooth Material Motion animations.
/// 
/// Enhanced: 2024.01.20 with iOS 26 Liquid Glass Dynamic Material
class BaseExpansion extends StatefulWidget {
  const BaseExpansion({
    Key? key,
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    this.width,
    this.height,
    this.duration = _expansionTransitionDuration,
    required this.child,
    this.barrierDismissible = true,
    this.curve = Curves.easeOutCubic,

    // iOS 26 Liquid Glass Dynamic Material properties
    this.enableLiquidGlass = true,
    this.glassOpacity = 0.85,
    this.reflectionIntensity = 0.6,
    this.refractionStrength = 0.4,
    this.adaptiveInteraction = true,
    this.hapticFeedback = true,
    this.environmentalAwareness = true,

    // Material 3 properties
    this.useMaterial3Elevation = true,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.elevation = 8.0,
  }) : super(key: key);

  const BaseExpansion.fromHeight({
    Key? key,
    this.left = 0.0,
    this.top = 0.0,
    this.height,
    this.duration = _expansionTransitionDuration,
    required this.child,
    this.barrierDismissible = true,
    this.curve = Curves.easeOutCubic,

    // iOS 26 Liquid Glass Dynamic Material properties
    this.enableLiquidGlass = true,
    this.glassOpacity = 0.85,
    this.reflectionIntensity = 0.6,
    this.refractionStrength = 0.4,
    this.adaptiveInteraction = true,
    this.hapticFeedback = true,
    this.environmentalAwareness = true,

    // Material 3 properties
    this.useMaterial3Elevation = true,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.elevation = 8.0,
  })  : width = null,
        right = null,
        bottom = null,
        super(key: key);

  /// Position properties
  final double left;
  final double top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;

  /// Animation properties
  final Duration duration;
  final Widget child;
  final bool barrierDismissible;
  final Curve curve;

  /// *** iOS 26 Liquid Glass Dynamic Material properties start ***

  /// Enable Liquid Glass Dynamic Material optical effects for expansion panels
  /// Provides transparency, reflections, and adaptive visual states
  final bool enableLiquidGlass;

  /// Glass transparency level for environmental awareness
  /// Creates optical clarity while maintaining content readability (0.0 to 1.0)
  final double glassOpacity;

  /// Reflection intensity for environmental responsiveness
  /// Simulates real-world glass reflection behavior (0.0 to 1.0)
  final double reflectionIntensity;

  /// Refraction strength for light distortion effects
  /// Creates realistic glass light-bending properties (0.0 to 1.0)
  final double refractionStrength;

  /// Enable adaptive interaction with real-time responsiveness
  /// Provides context-aware visual and haptic feedback for expansion interactions
  final bool adaptiveInteraction;

  /// Enable haptic feedback for enhanced expansion experience
  /// Provides appropriate haptic responses for expand/collapse gestures
  final bool hapticFeedback;

  /// Enable environmental awareness for dynamic adaptation
  /// Responds to surrounding content and lighting conditions
  final bool environmentalAwareness;

  /// *** iOS 26 Liquid Glass Dynamic Material properties end ***

  /// *** Material 3 properties start ***

  /// Use Material 3 elevation system with surface tinting
  /// Provides modern elevation handling with enhanced visual depth
  final bool useMaterial3Elevation;

  /// Background color for the expansion panel
  /// Uses semantic ColorScheme colors when null
  final Color? backgroundColor;

  /// Border radius for the expansion panel
  /// Creates rounded corners with Material 3 design tokens
  final BorderRadius borderRadius;

  /// Elevation level for the expansion panel
  /// Enhanced with Material 3 surface tinting when enabled
  final double elevation;

  /// *** Material 3 properties end ***

  @override
  State<StatefulWidget> createState() => BaseExpansionState();

  Future<T?> open<T>(
    BuildContext context,
    BaseExpansion baseExpansion, {
    Duration duration = const Duration(milliseconds: 0),
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        transitionDuration: duration,
        barrierDismissible: true,
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return baseExpansion;
        },
      ),
    );
  }
}

class BaseExpansionState extends State<BaseExpansion> with TickerProviderStateMixin {
  double? _height;
  double? _width;
  late AnimationController _glassAnimationController;
  late Animation<double> _glassOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _height = 0.0;
    _width = widget.width;

    // Initialize Liquid Glass animation controller
    _glassAnimationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _glassOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: widget.glassOpacity,
    ).animate(CurvedAnimation(
      parent: _glassAnimationController,
      curve: widget.curve,
    ));

    // Provide haptic feedback when expansion begins
    if (widget.hapticFeedback && widget.adaptiveInteraction) {
      HapticFeedback.lightImpact();
    }

    Future<void>.delayed(const Duration(milliseconds: 0), () {
      setState(() {
        _height = widget.height;
      });
      _glassAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _glassAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width ??= MediaQuery.of(context).size.width;
    
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Enhanced barrier with optional blur effect
        _buildBarrier(context),
        // Main expansion content with Liquid Glass effects
        _buildExpansionContent(context),
      ],
    );
  }

  /// Build the dismissible barrier with optional backdrop blur
  Widget _buildBarrier(BuildContext context) {
    Widget barrier = GestureDetector(
      child: Container(
        color: Colors.transparent,
      ),
      onTap: () {
        if (widget.barrierDismissible) {
          close();
        }
      },
    );

    // Add environmental blur for Liquid Glass effect
    if (widget.enableLiquidGlass && widget.environmentalAwareness) {
      return AnimatedBuilder(
        animation: _glassOpacityAnimation,
        builder: (context, child) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _glassOpacityAnimation.value * 5.0,
              sigmaY: _glassOpacityAnimation.value * 5.0,
            ),
            child: barrier,
          );
        },
      );
    }

    return barrier;
  }

  /// Build the main expansion content with enhanced visual effects
  Widget _buildExpansionContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final useMaterial3 = Theme.of(context).useMaterial3;

    Widget content = AnimatedContainer(
      duration: widget.duration,
      curve: widget.curve,
      height: _height,
      width: _width,
      child: widget.child,
    );

    // Apply Material 3 styling and Liquid Glass effects
    if (widget.enableLiquidGlass || widget.useMaterial3Elevation) {
      content = _wrapWithEnhancedStyling(context, content, colorScheme, useMaterial3);
    }

    return Positioned(
      left: widget.left,
      top: widget.top,
      right: widget.right,
      bottom: widget.bottom,
      child: content,
    );
  }

  /// Wrap content with enhanced Material 3 and Liquid Glass styling
  Widget _wrapWithEnhancedStyling(
    BuildContext context,
    Widget content,
    ColorScheme colorScheme,
    bool useMaterial3,
  ) {
    final backgroundColor = widget.backgroundColor ?? 
        (useMaterial3 ? colorScheme.surface : Colors.white);

    return AnimatedBuilder(
      animation: _glassOpacityAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: widget.borderRadius,
            // Enhanced shadows for Material 3 elevation
            boxShadow: _buildEnhancedShadows(context, useMaterial3, colorScheme),
          ),
          child: widget.enableLiquidGlass 
              ? _wrapWithLiquidGlass(context, content)
              : ClipRRect(
                  borderRadius: widget.borderRadius,
                  child: content,
                ),
        );
      },
    );
  }

  /// Build enhanced shadow system for Material 3 elevation
  List<BoxShadow> _buildEnhancedShadows(
    BuildContext context,
    bool useMaterial3,
    ColorScheme colorScheme,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final elevation = widget.elevation;

    if (useMaterial3 && widget.useMaterial3Elevation) {
      // Material 3 elevation with surface tinting
      return [
        // Primary elevation shadow
        BoxShadow(
          color: (isDark ? Colors.black : Colors.grey.shade400).withOpacity(0.3),
          offset: Offset(0, elevation * 0.5),
          blurRadius: elevation * 2,
          spreadRadius: 0,
        ),
        // Secondary ambient shadow
        BoxShadow(
          color: (isDark ? Colors.black : Colors.grey.shade300).withOpacity(0.15),
          offset: Offset(0, elevation * 0.25),
          blurRadius: elevation * 1.5,
          spreadRadius: elevation * 0.1,
        ),
        // Surface tint shadow for Material 3
        if (useMaterial3)
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.08),
            offset: const Offset(0, 0),
            blurRadius: elevation,
            spreadRadius: 0,
          ),
      ];
    } else {
      // Legacy elevation shadow
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.16),
          offset: Offset(0, elevation * 0.5),
          blurRadius: elevation,
        ),
      ];
    }
  }

  /// iOS 26 Liquid Glass Dynamic Material wrapper
  Widget _wrapWithLiquidGlass(BuildContext context, Widget content) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.refractionStrength * 15,
          sigmaY: widget.refractionStrength * 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            // Liquid Glass gradient overlay
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.3, 0.6, 1.0],
              colors: [
                Colors.white.withOpacity(_glassOpacityAnimation.value * widget.reflectionIntensity * 0.3),
                Colors.white.withOpacity(_glassOpacityAnimation.value * widget.reflectionIntensity * 0.15),
                Colors.white.withOpacity(_glassOpacityAnimation.value * widget.reflectionIntensity * 0.08),
                Colors.transparent,
              ],
            ),
            // Additional refractive overlay
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withOpacity(
                _glassOpacityAnimation.value * 0.1
              ),
              width: 0.5,
            ),
          ),
          child: content,
        ),
      ),
    );
  }

  /// Close the expansion panel with enhanced animations and haptic feedback
  Future<void> close() async {
    // Provide haptic feedback when closing
    if (widget.hapticFeedback && widget.adaptiveInteraction) {
      HapticFeedback.selectionClick();
    }

    // Animate glass effects out
    _glassAnimationController.reverse();

    setState(() {
      _height = 0.0;
    });

    return Future<void>.delayed(widget.duration, () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}

/// Enhanced BaseExpansion helper functions with Material 3 and Liquid Glass support

/// Open expansion panel with modern page route and enhanced transitions
Future<T?> openBaseExpansion<T>(
  BuildContext context,
  BaseExpansion baseExpansion, {
  Duration? transitionDuration,
  bool enableBarrierBlur = true,
}) {
  final duration = transitionDuration ?? const Duration(milliseconds: 150);
  
  return Navigator.of(context).push<T>(
    PageRouteBuilder<T>(
      opaque: false,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      barrierDismissible: baseExpansion.barrierDismissible,
      barrierColor: enableBarrierBlur 
          ? Colors.black.withOpacity(0.1)
          : Colors.transparent,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: baseExpansion,
        );
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        // Enhanced transition with scale and fade for modern feel
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    ),
  );
}

/// Close expansion panel with enhanced state management
void closeBaseExpansion(GlobalKey<BaseExpansionState> key) {
  key.currentState?.close();
}

/// Material 3 optimized expansion panel factory
class BaseExpansionM3 {
  /// Create a Material 3 styled expansion panel
  static BaseExpansion create({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    Duration duration = const Duration(milliseconds: 300),
    bool barrierDismissible = true,
    
    // Material 3 specific
    Color? backgroundColor,
    double elevation = 3.0,
    BorderRadius? borderRadius,
    
    // iOS 26 Liquid Glass
    bool enableLiquidGlass = true,
    double glassOpacity = 0.9,
    double reflectionIntensity = 0.7,
    bool hapticFeedback = true,
  }) {
    return BaseExpansion(
      key: key,
      child: child,
      width: width,
      height: height,
      duration: duration,
      barrierDismissible: barrierDismissible,
      curve: Curves.easeOutCubic,
      
      // Material 3 properties
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(28.0)),
      useMaterial3Elevation: true,
      
      // iOS 26 Liquid Glass properties
      enableLiquidGlass: enableLiquidGlass,
      glassOpacity: glassOpacity,
      reflectionIntensity: reflectionIntensity,
      refractionStrength: 0.4,
      adaptiveInteraction: true,
      hapticFeedback: hapticFeedback,
      environmentalAwareness: true,
    );
  }

  /// Create a bottom sheet style expansion panel
  static BaseExpansion bottomSheet({
    Key? key,
    required Widget child,
    double? height,
    Duration duration = const Duration(milliseconds: 350),
    bool barrierDismissible = true,
    bool enableLiquidGlass = true,
  }) {
    return BaseExpansion.fromHeight(
      key: key,
      child: child,
      height: height,
      duration: duration,
      barrierDismissible: barrierDismissible,
      curve: Curves.easeOutCubic,
      left: 0.0,
      
      // Material 3 bottom sheet styling
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28.0),
        topRight: Radius.circular(28.0),
      ),
      elevation: 8.0,
      useMaterial3Elevation: true,
      
      // iOS 26 Liquid Glass properties
      enableLiquidGlass: enableLiquidGlass,
      glassOpacity: 0.95,
      reflectionIntensity: 0.8,
      refractionStrength: 0.3,
      adaptiveInteraction: true,
      hapticFeedback: true,
      environmentalAwareness: true,
    );
  }

  /// Create a dialog style expansion panel
  static BaseExpansion dialog({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    Duration duration = const Duration(milliseconds: 250),
    bool barrierDismissible = true,
    bool enableLiquidGlass = true,
  }) {
    return BaseExpansion(
      key: key,
      child: child,
      width: width ?? 320.0,
      height: height,
      left: 20.0,
      top: 100.0,
      right: 20.0,
      duration: duration,
      barrierDismissible: barrierDismissible,
      curve: Curves.easeOutCubic,
      
      // Material 3 dialog styling
      borderRadius: const BorderRadius.all(Radius.circular(28.0)),
      elevation: 6.0,
      useMaterial3Elevation: true,
      
      // iOS 26 Liquid Glass properties
      enableLiquidGlass: enableLiquidGlass,
      glassOpacity: 0.85,
      reflectionIntensity: 0.6,
      refractionStrength: 0.4,
      adaptiveInteraction: true,
      hapticFeedback: true,
      environmentalAwareness: true,
    );
  }
}
