import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';
import '../mode/base_mode.dart';

/// BaseActionSheet
/// use CupertinoActionSheet by cupertino with iOS 16+ liquid glass effects
/// *** use cupertino = { forceUseMaterial: true } force use Material 3 BottomSheet on cupertino.
/// use Material 3 BottomSheet by material with modern design patterns
/// *** use material = { forceUseCupertino: true } force use CupertinoActionSheet on material.
///
/// iOS 16+ CupertinoActionSheet with liquid glass effects: 2025.08.11
/// Material 3 BottomSheet with modern design: 2025.08.11
/// Enhanced accessibility and semantic support: 2025.08.11
class BaseActionSheet extends BaseStatelessWidget {
  const BaseActionSheet({
    Key? key,
    this.title,
    this.message,
    this.actions,
    this.messageScrollController,
    this.actionScrollController,
    this.cancelButton,
    this.animationController,
    this.onClosing,
    this.backgroundColor,
    this.enableDrag = true,
    this.onDragStart,
    this.onDragEnd,
    this.elevation = 0.0,
    this.shape,
    this.clipBehavior,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  // *** general properties start ***

  /// [CupertinoActionSheet.title]
  final Widget? title;

  /// [CupertinoActionSheet.message]
  final Widget? message;

  /// [CupertinoActionSheet.actions]
  final List<Widget>? actions;

  /// [CupertinoActionSheet.messageScrollController]
  final ScrollController? messageScrollController;

  /// [CupertinoActionSheet.actionScrollController]
  final ScrollController? actionScrollController;

  /// [BaseActionSheetAction]
  final Widget? cancelButton;

  /// *** general properties end ***

  /// *** material properties start ***

  /// [BottomSheet.animationController]
  final AnimationController? animationController;

  /// [BottomSheet.onClosing]
  final VoidCallback? onClosing;

  /// [BottomSheet.enableDrag]
  final bool enableDrag;

  /// [BottomSheet.onDragStart]
  final BottomSheetDragStartHandler? onDragStart;

  /// [BottomSheet.onDragEnd]
  final BottomSheetDragEndHandler? onDragEnd;

  /// [BottomSheet.backgroundColor]
  final Color? backgroundColor;

  /// [BottomSheet.elevation], default is 0.0
  final double? elevation;

  /// [BottomSheet.shape]
  final ShapeBorder? shape;

  /// [BottomSheet.clipBehavior]
  final Clip? clipBehavior;

  /// *** material properties end ***

  @override
  Widget buildByCupertino(BuildContext context) {
    final bool isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;
    
    // iOS 16+ liquid glass effect wrapper
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), // iOS 16+ rounded corners
        // Liquid glass gradient overlay
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (isDarkMode ? CupertinoColors.systemGrey6.darkColor : CupertinoColors.systemGrey6.color).withOpacity(0.95),
            (isDarkMode ? CupertinoColors.systemGrey5.darkColor : CupertinoColors.systemGrey5.color).withOpacity(0.98),
          ],
        ),
        // Enhanced shadow system for depth
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40), // Liquid glass blur effect
          child: CupertinoActionSheet(
            title: valueOf('title', title),
            message: valueOf('message', message),
            actions: valueOf('actions', actions),
            messageScrollController: valueOf(
              'messageScrollController',
              messageScrollController,
            ),
            actionScrollController: valueOf(
              'actionScrollController',
              actionScrollController,
            ),
            cancelButton: valueOf('cancelButton', cancelButton),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final VoidCallback? onClosingCallback = valueOf('onClosing', onClosing);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    
    return BottomSheet(
      animationController: valueOf('animationController', animationController),
      onClosing: () {
        if (onClosingCallback != null) {
          onClosingCallback();
        }
      },
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), // Material 3 rounded corners
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, -4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            child: Semantics(
              namesRoute: true,
              scopesRoute: true,
              explicitChildNodes: true,
              child: Column(
                children: [
                  // Material 3 drag handle
                  Container(
                    width: 32,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  _buildModernContent(context),
                  _buildModernActions(context),
                ],
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
            ),
          ),
        );
      },
      enableDrag: valueOf('enableDrag', enableDrag),
      onDragStart: valueOf('onDragStart', onDragStart),
      onDragEnd: valueOf('onDragEnd', onDragEnd),
      elevation: 0, // Using custom shadow instead
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: valueOf('clipBehavior', clipBehavior) ?? Clip.hardEdge,
      backgroundColor: Colors.transparent, // Using container decoration instead
    );
  }

  Future<T?> show<T>(
    BuildContext context, {
    Color? barrierColor,
    bool barrierDismissible = true,
    bool? useRootNavigator,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    AnimationController? transitionAnimationController,
  }) {
    const Color _cupertinoDefaultBarrierColor = CupertinoDynamicColor.withBrightness(
      color: Color(0x33000000),
      darkColor: Color(0x7A000000),
    );
    final WidgetBuildMode _widgetBuildMode = getBuildMode(baseParam);
    if (_widgetBuildMode == WidgetBuildMode.cupertino || _widgetBuildMode == WidgetBuildMode.forceUseCupertino) {
      final bool _useRootNavigator = useRootNavigator ??= true;
      return _showByCupertino<T>(
        context,
        barrierColor: barrierColor ?? _cupertinoDefaultBarrierColor,
        barrierDismissible: barrierDismissible,
        useRootNavigator: _useRootNavigator,
        semanticsDismissible: semanticsDismissible,
        routeSettings: routeSettings,
      );
    }
    final bool _useRootNavigator = useRootNavigator ??= false;
    return _showByMaterial<T>(
      context,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: _useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
    );
  }

  Future<T?> _showByCupertino<T>(
    BuildContext context, {
    required Color barrierColor,
    required bool barrierDismissible,
    required bool useRootNavigator,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      semanticsDismissible: semanticsDismissible!,
      routeSettings: routeSettings,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  Future<T?> _showByMaterial<T>(
    BuildContext context, {
    Color? barrierColor,
    required bool isScrollControlled,
    required bool useRootNavigator,
    required bool isDismissible,
    required bool enableDrag,
    required RouteSettings? routeSettings,
    required AnimationController? transitionAnimationController,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  Widget _buildModernContent(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    
    final List<Widget> content = <Widget>[];
    if (title != null || message != null) {
      final Widget titleSection = _ModernMaterialContentSection(
        title: title,
        message: message,
        scrollController: messageScrollController,
        colorScheme: colorScheme,
        textTheme: textTheme,
      );
      content.add(Flexible(child: titleSection));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: content,
    );
  }

  Widget _buildModernActions(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    
    return _ModernMaterialActionSection(
      actions: valueOf('actions', actions),
      cancelButton: valueOf('cancelButton', cancelButton),
      scrollController: valueOf('actionScrollController', actionScrollController),
      colorScheme: colorScheme,
    );
  }
}

// Modern Material 3 constants
const double _kModernContentHorizontalPadding = 24.0;
const double _kModernContentVerticalPadding = 20.0;

class _ModernMaterialContentSection extends StatelessWidget {
  const _ModernMaterialContentSection({
    Key? key,
    this.title,
    this.message,
    this.scrollController,
    required this.colorScheme,
    required this.textTheme,
  }) : super(key: key);

  final Widget? title;
  final Widget? message;
  final ScrollController? scrollController;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final List<Widget> titleContentGroup = <Widget>[];
    
    if (title != null) {
      final Widget titleWidget = DefaultTextStyle(
        style: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ) ?? TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
        child: Semantics(
          namesRoute: true,
          container: true,
          child: title!,
        ),
      );
      titleContentGroup.add(Padding(
        padding: const EdgeInsets.fromLTRB(
          _kModernContentHorizontalPadding,
          _kModernContentVerticalPadding,
          _kModernContentHorizontalPadding,
          0,
        ),
        child: titleWidget,
      ));
    }

    if (message != null) {
      final Widget messageWidget = DefaultTextStyle(
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          height: 1.4,
        ) ?? TextStyle(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
        child: Semantics(
          container: true,
          child: message!,
        ),
      );
      titleContentGroup.add(Padding(
        padding: EdgeInsets.fromLTRB(
          _kModernContentHorizontalPadding,
          title != null ? 8.0 : _kModernContentVerticalPadding,
          _kModernContentHorizontalPadding,
          _kModernContentVerticalPadding,
        ),
        child: messageWidget,
      ));
    }

    if (titleContentGroup.isEmpty) {
      return const SizedBox(width: 0.0, height: 0.0);
    }

    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: titleContentGroup,
        ),
      ),
    );
  }
}

class _ModernMaterialActionSection extends StatelessWidget {
  const _ModernMaterialActionSection({
    Key? key,
    this.actions = const <Widget>[],
    this.cancelButton,
    this.scrollController,
    required this.colorScheme,
  }) : super(key: key);

  final List<Widget> actions;
  final Widget? cancelButton;
  final ScrollController? scrollController;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    
    // Add actions with modern spacing
    if (actions.isNotEmpty) {
      for (int i = 0; i < actions.length; i++) {
        children.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: actions[i],
        ));
      }
    }
    
    // Add cancel button with extra spacing
    if (cancelButton != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: 8)); // Extra spacing before cancel
      }
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: cancelButton!,
      ));
    }
    
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
