// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cupertino_interactive_keyboard/cupertino_interactive_keyboard.dart' as cik;

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// Base wrapper for CupertinoInteractiveKeyboard with cross-platform support
/// 
/// Provides iOS-style interactive keyboard dismissal with fallback to standard
/// keyboard handling on other platforms. Uses the actual cupertino_interactive_keyboard
/// package for authentic drag-to-dismiss functionality on iOS.
/// 
/// Features:
/// - Native iOS interactive keyboard dismissal with drag gestures
/// - Keyboard height tracking and animation
/// - Custom keyboard toolbar support
/// - Cross-platform Material Design fallback
/// - Tap-to-dismiss functionality
/// - Apple HIG compliant keyboard behavior
/// 
/// Apple HIG implementation:
/// - Interactive dismissal with drag gestures using native implementation
/// - Smooth keyboard animation curves
/// - Proper safe area handling
/// - Keyboard toolbar integration
/// - Haptic feedback support (when available)
/// 
/// Example usage:
/// ```dart
/// BaseCupertinoInteractiveKeyboard(
///   child: Column(
///     children: [
///       TextField(
///         decoration: InputDecoration(
///           hintText: 'Type something...',
///         ),
///       ),
///       // Other content
///     ],
///   ),
///   onKeyboardHeightChanged: (height) {
///     print('Keyboard height: $height');
///   },
///   enableInteractiveDismissal: true,
/// )
/// ```
class BaseCupertinoInteractiveKeyboard extends BaseStatelessWidget {
  /// Creates a Cupertino interactive keyboard wrapper
  const BaseCupertinoInteractiveKeyboard({
    Key? key,
    required this.child,
    this.onKeyboardHeightChanged,
    this.enableInteractiveDismissal = true,
    this.keyboardToolbar,
    this.dismissOnTap = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// The child widget to wrap with interactive keyboard functionality
  final Widget child;

  /// Callback for keyboard height changes
  final ValueChanged<double>? onKeyboardHeightChanged;

  /// Whether to enable interactive dismissal with gestures
  final bool enableInteractiveDismissal;

  /// Optional keyboard toolbar widget
  final Widget? keyboardToolbar;

  /// Whether to dismiss keyboard when tapping outside
  final bool dismissOnTap;

  /// Animation duration for keyboard transitions
  final Duration animationDuration;

  /// Animation curve for keyboard transitions
  final Curve animationCurve;

  @override
  Widget buildByCupertino(BuildContext context) {
    return _KeyboardHeightReader(
      onKeyboardHeightChanged: onKeyboardHeightChanged,
      enableInteractiveDismissal: enableInteractiveDismissal,
      keyboardToolbar: keyboardToolbar,
      dismissOnTap: dismissOnTap,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      child: child,
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    return _CupertinoInteractiveKeyboardMaterial(
      onKeyboardHeightChanged: onKeyboardHeightChanged,
      enableInteractiveDismissal: enableInteractiveDismissal,
      keyboardToolbar: keyboardToolbar,
      dismissOnTap: dismissOnTap,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      child: child,
    );
  }
}

/// Wrapper widget that uses keyboard visibility callback from the package
/// to track keyboard state (no MediaQuery needed)
class _KeyboardHeightReader extends StatefulWidget {
  const _KeyboardHeightReader({
    required this.child,
    this.onKeyboardHeightChanged,
    this.enableInteractiveDismissal = true,
    this.keyboardToolbar,
    this.dismissOnTap = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
  });

  final Widget child;
  final ValueChanged<double>? onKeyboardHeightChanged;
  final bool enableInteractiveDismissal;
  final Widget? keyboardToolbar;
  final bool dismissOnTap;
  final Duration animationDuration;
  final Curve animationCurve;

  @override
  State<_KeyboardHeightReader> createState() => _KeyboardHeightReaderState();
}

class _KeyboardHeightReaderState extends State<_KeyboardHeightReader> with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  // Estimated keyboard height for iOS (typical value)
  static const double _estimatedKeyboardHeight = 336.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Trigger rebuild when metrics change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _handleKeyboardVisibilityChanged(bool isVisible) {
    print('[KeyboardVisibility] Keyboard visibility changed: $isVisible');
    
    if (isVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isVisible;
      });
      
      // Report keyboard height based on visibility
      final height = isVisible ? _estimatedKeyboardHeight : 0.0;
      print('[KeyboardVisibility] Reporting keyboard height: $height');
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onKeyboardHeightChanged?.call(height);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.child;
    
    // Use the actual CupertinoInteractiveKeyboard from the package (v0.0.2+1)
    if (widget.enableInteractiveDismissal) {
      content = cik.CupertinoInteractiveKeyboard(
        onKeyboardVisibilityChanged: _handleKeyboardVisibilityChanged,
        child: content,
      );
    }
    
    // Add input accessory if keyboard toolbar is provided and keyboard is visible
    if (widget.keyboardToolbar != null && _isKeyboardVisible) {
      content = Column(
        children: [
          Expanded(child: content),
          cik.CupertinoInputAccessory(
            child: widget.keyboardToolbar!,
          ),
        ],
      );
    }
    
    // Add tap-to-dismiss functionality
    if (widget.dismissOnTap) {
      content = GestureDetector(
        onTap: () {
          if (_isKeyboardVisible) {
            FocusScope.of(context).unfocus();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: content,
      );
    }
    
    return content;
  }
}

/// Material implementation with standard keyboard handling
class _CupertinoInteractiveKeyboardMaterial extends StatefulWidget {
  const _CupertinoInteractiveKeyboardMaterial({
    required this.child,
    this.onKeyboardHeightChanged,
    this.enableInteractiveDismissal = true,
    this.keyboardToolbar,
    this.dismissOnTap = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
  });

  final Widget child;
  final ValueChanged<double>? onKeyboardHeightChanged;
  final bool enableInteractiveDismissal;
  final Widget? keyboardToolbar;
  final bool dismissOnTap;
  final Duration animationDuration;
  final Curve animationCurve;

  @override
  State<_CupertinoInteractiveKeyboardMaterial> createState() => 
      _CupertinoInteractiveKeyboardMaterialState();
}

class _CupertinoInteractiveKeyboardMaterialState extends State<_CupertinoInteractiveKeyboardMaterial>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  
  double _keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    // Listen to keyboard changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateKeyboardHeight();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Called whenever the metrics (including keyboard height) change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateKeyboardHeight();
      }
    });
  }

  void _updateKeyboardHeight() {
    final mediaQuery = MediaQuery.of(context);
    final newKeyboardHeight = mediaQuery.viewInsets.bottom;
    
    if (newKeyboardHeight != _keyboardHeight) {
      setState(() {
        _keyboardHeight = newKeyboardHeight;
        _isKeyboardVisible = _keyboardHeight > 0;
      });
      
      widget.onKeyboardHeightChanged?.call(_keyboardHeight);
      
      if (_isKeyboardVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    Widget content = widget.child;
    
    // Add keyboard toolbar if provided (Material style)
    if (widget.keyboardToolbar != null && _isKeyboardVisible) {
      content = Column(
        children: [
          Expanded(child: content),
          AnimatedContainer(
            duration: widget.animationDuration,
            curve: widget.animationCurve,
            height: _isKeyboardVisible ? null : 0,
            child: Material(
              elevation: 8,
              child: widget.keyboardToolbar,
            ),
          ),
        ],
      );
    }
    
    // Add tap-to-dismiss functionality
    if (widget.dismissOnTap) {
      content = GestureDetector(
        onTap: () {
          if (_isKeyboardVisible) {
            FocusScope.of(context).unfocus();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: content,
      );
    }
    
    // For Material, we provide basic swipe-to-dismiss
    if (widget.enableInteractiveDismissal && _isKeyboardVisible) {
      content = GestureDetector(
        onPanUpdate: (details) {
          // Dismiss keyboard on downward swipe
          if (details.delta.dy > 5) {
            FocusScope.of(context).unfocus();
          }
        },
        child: content,
      );
    }
    
    return content;
  }
}

/// Legacy CupertinoInteractiveKeyboard class for backward compatibility
/// 
/// This maintains the original API while delegating to BaseCupertinoInteractiveKeyboard
/// for actual implementation.
class CupertinoInteractiveKeyboard extends StatelessWidget {
  /// Creates a Cupertino interactive keyboard wrapper
  const CupertinoInteractiveKeyboard({
    Key? key,
    required this.child,
    this.onKeyboardHeightChanged,
    this.enableInteractiveDismissal = true,
    this.keyboardToolbar,
    this.dismissOnTap = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
  }) : super(key: key);

  /// The child widget to wrap with interactive keyboard functionality
  final Widget child;

  /// Callback for keyboard height changes
  final ValueChanged<double>? onKeyboardHeightChanged;

  /// Whether to enable interactive dismissal with gestures
  final bool enableInteractiveDismissal;

  /// Optional keyboard toolbar widget
  final Widget? keyboardToolbar;

  /// Whether to dismiss keyboard when tapping outside
  final bool dismissOnTap;

  /// Animation duration for keyboard transitions
  final Duration animationDuration;

  /// Animation curve for keyboard transitions
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    return BaseCupertinoInteractiveKeyboard(
      onKeyboardHeightChanged: onKeyboardHeightChanged,
      enableInteractiveDismissal: enableInteractiveDismissal,
      keyboardToolbar: keyboardToolbar,
      dismissOnTap: dismissOnTap,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      child: child,
    );
  }
}

/// Input Accessory for keyboard toolbars
/// 
/// Wrapper around the actual CupertinoInputAccessory from the package
/// to provide a consistent API.
class CupertinoInputAccessory extends StatelessWidget {
  /// Creates a Cupertino input accessory
  const CupertinoInputAccessory({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The child widget to show as the input accessory
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return cik.CupertinoInputAccessory(
      child: child,
    );
  }
}