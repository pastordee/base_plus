// Created: 2026-08-18
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../mode/base_mode.dart';

/// A platform-adaptive "side draw" presenter.
///
/// The problem it solves: a left-anchored navigation drawer is the natural
/// Android pattern, but on iOS a full-height side drawer (or a bottom sheet)
/// feels foreign. iOS users expect a menu to appear as a floating, rounded,
/// frosted card that scales open from the button that summoned it — exactly like
/// a native `UIMenu` popover, just big enough to hold richer content. Rather than
/// change the existing Material [Drawer] flow, [BaseSideDraw] is an *additive*
/// imperative presenter that renders the SAME Flutter content differently per
/// platform:
///
///   * Material (Android/others): a left-anchored panel that slides in from the
///     leading edge behind a scrim — visually identical to a Navigation Drawer,
///     so Android keeps exactly what it has today.
///   * Cupertino (iOS/macOS): a left-anchored, full-height **frosted panel**
///     with rounded trailing corners that slides in with an iOS spring — the
///     familiar drawer *shape*, but translucent/blurred so it reads as native.
///     Hosts the identical Flutter widget tree with full app state (no second
///     FlutterEngine).
///
/// The content [builder] is platform-agnostic: pass your grid / menu once and
/// [BaseSideDraw] handles the container chrome. Dismiss with
/// `Navigator.of(context).pop()` from inside the content, exactly like a Drawer.
///
/// Example:
/// ```dart
/// BaseSideDraw.show(
///   context: context,
///   builder: (_) => const AppMenuGrid(),
/// );
/// ```
class BaseSideDraw {
  const BaseSideDraw._();

  /// Presents the side draw, adapting to the platform.
  ///
  /// * [builder] builds the content shown inside the platform container.
  /// * [materialWidth] is the panel width for the Material left-drawer.
  /// * [cupertinoWidth] is the panel width for the iOS frosted drawer.
  /// * [cupertinoBlurSigma] controls how strong the iOS frost is (0 = opaque).
  /// * [barrierColor] overrides the scrim colour on both platforms.
  /// * [useRootNavigator] presents above everything (bottom nav bars, etc.).
  /// * [forceMaterial] forces the Android presentation even on iOS (escape hatch
  ///   for callers that want the classic drawer everywhere).
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    double materialWidth = 350,
    double cupertinoWidth = 360,
    double cupertinoBlurSigma = 30,
    // A near-opaque tint gives the uniform frosted-white look of native iOS
    // menus (e.g. Calendar — barely see-through), and stops the backdrop
    // showing through unevenly (app-bar vs page) as two tones. Lower it toward
    // ~0.7 for a glassier, more see-through panel.
    double cupertinoTint = 0.95,
    double cupertinoCornerRadius = 30,
    Color? barrierColor,
    bool useRootNavigator = true,
    bool forceMaterial = false,
  }) {
    final useCupertino =
        !forceMaterial && currentBaseMode == BaseMode.cupertino;

    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    if (useCupertino) {
      return navigator.push<T>(
        _CupertinoDrawerRoute<T>(
          width: cupertinoWidth,
          isRtl: isRtl,
          blurSigma: cupertinoBlurSigma,
          tint: cupertinoTint,
          cornerRadius: cupertinoCornerRadius,
          scrim: barrierColor ?? Colors.black.withValues(alpha: 0.2),
          builder: builder,
        ),
      );
    }

    return navigator.push<T>(
      _SideDrawerRoute<T>(
        width: materialWidth,
        isRtl: isRtl,
        barrierColor: barrierColor ?? Colors.black54,
        builder: builder,
      ),
    );
  }
}

/// Cupertino: a left-anchored (trailing-in-RTL) **floating** frosted card. It is
/// inset from the top and bottom (so a sliver of the screen shows above and
/// below), has large rounded corners on every side, a heavy background blur and
/// a translucent tint with a subtle light edge — the Apple-menu / Calendar
/// popover look. Slides in with an iOS spring curve.
class _CupertinoDrawerRoute<T> extends PopupRoute<T> {
  _CupertinoDrawerRoute({
    required this.width,
    required this.isRtl,
    required this.blurSigma,
    required this.tint,
    required this.cornerRadius,
    required this.scrim,
    required this.builder,
  });

  final double width;
  final bool isRtl;
  final double blurSigma;
  final double tint;
  final double cornerRadius;
  final Color scrim;
  final WidgetBuilder builder;

  @override
  Color? get barrierColor => scrim;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 320);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final align = isRtl ? Alignment.centerRight : Alignment.centerLeft;
    final panelWidth = width.clamp(0.0, media.size.width * 0.92);
    final corners = BorderRadius.circular(cornerRadius);

    // Floating insets: leave a gap above (below the notch) and below (above the
    // home indicator) so the screen peeks through top and bottom, plus a small
    // margin on the anchored edge so all four rounded corners are visible.
    final topGap = media.padding.top + 10;
    final bottomGap = media.padding.bottom + 18;
    const sideGap = 8.0;

    return Padding(
      padding: EdgeInsets.only(
        top: topGap,
        bottom: bottomGap,
        left: isRtl ? 0 : sideGap,
        right: isRtl ? sideGap : 0,
      ),
      child: Align(
        alignment: align,
        child: SizedBox(
          width: panelWidth,
          height: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: corners,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 34,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: corners,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: Container(
                  // Translucent tint over the blur — the frosted-glass look, with
                  // a faint light edge for the iOS "material" rim. The hosted
                  // content should be transparent for this to show through.
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: tint),
                    borderRadius: corners,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 0.8,
                    ),
                  ),
                  // The card already sits inside the safe area (top/bottom gaps),
                  // so strip the content's own status-bar / home-indicator
                  // padding to avoid a double gap.
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: Builder(builder: builder),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final begin = isRtl ? const Offset(1, 0) : const Offset(-1, 0);
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: Offset.zero).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
      ),
      child: child,
    );
  }
}

/// A left-anchored (or right-anchored in RTL) drawer route that slides the
/// content in from the leading edge behind a dismissible scrim — the classic
/// Material navigation-drawer motion, so Android keeps its current look.
class _SideDrawerRoute<T> extends PopupRoute<T> {
  _SideDrawerRoute({
    required this.width,
    required this.isRtl,
    required this.barrierColor,
    required this.builder,
  });

  final double width;
  final bool isRtl;
  @override
  final Color barrierColor;
  final WidgetBuilder builder;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 280);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final align = isRtl ? Alignment.centerRight : Alignment.centerLeft;
    final panelWidth =
        width.clamp(0.0, MediaQuery.of(context).size.width * 0.9);
    return Align(
      alignment: align,
      child: SizedBox(
        width: panelWidth,
        height: double.infinity,
        child: Builder(builder: builder),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final begin = isRtl ? const Offset(1, 0) : const Offset(-1, 0);
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: Offset.zero).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      ),
      child: child,
    );
  }
}
