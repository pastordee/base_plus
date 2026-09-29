// Created: 2026-09-29
//
// A sheet shaped for the screen it opens on.
//
// On a phone [showBaseSheet] IS showModalBottomSheet: same arguments, same
// sheet. On a Mac and on a tablet, a sheet rising from the bottom is the
// phone's shape: it covers what it is adjusting. There it opens as a floating
// panel instead:
//
//  - it doesn't block the screen — what is behind stays usable, so a slider
//    can be moved while the thing it changes is in view;
//  - it is dragged by the grip along its top and closed with its × or Esc;
//  - it opens where the last one was left.
//
// It is still a route, so a sheet that closes itself (Navigator.pop,
// Get.back) closes the panel, and what it pops comes back from the call.
//
// Decided with the owner after trying it on an iPad (2026-09-29): "the bottom
// sheet feels like a phone, this feels like a tablet or laptop". Made in the
// Creator app first; shared from here so both apps agree. Separate native
// windows can replace the panel here once Flutter's multi-window API is
// stable.

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Whether sheets float here: a Mac, or a tablet-sized screen.
bool baseUsesFloatingPanels(BuildContext context) {
  if (kIsWeb) {
    return false;
  }
  if (Platform.isMacOS) {
    return true;
  }
  // Any tablet, held either way (owner, 2026-09-29: "we have to apply it to
  // portrait as well because it's the iPad").
  return MediaQuery.sizeOf(context).shortestSide >= 600;
}

/// [showModalBottomSheet] on a phone; a floating, non-blocking panel on a Mac
/// or a tablet (see the file comment).
Future<T?> showBaseSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  Color? barrierColor,
  bool isScrollControlled = false,
  BoxConstraints? constraints,
  ShapeBorder? shape,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useRootNavigator = false,
  AnimationController? transitionAnimationController,
  RouteSettings? routeSettings,
}) {
  if (!baseUsesFloatingPanels(context)) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      constraints: constraints,
      shape: shape,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      transitionAnimationController: transitionAnimationController,
      routeSettings: routeSettings,
    );
  }
  final NavigatorState navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );
  // A sheet that paints its own card passes transparent; anything else gets
  // the colour a bottom sheet would have had.
  final bool ownCard = backgroundColor != null && backgroundColor.a == 0;
  final Color? panelColor = ownCard
      ? null
      : backgroundColor ??
            Theme.of(context).bottomSheetTheme.modalBackgroundColor ??
            Theme.of(context).bottomSheetTheme.backgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerLow;
  return navigator.push<T>(
    BaseFloatingPanelRoute<T>(
      builder: builder,
      maxWidth: constraints?.maxWidth,
      panelColor: panelColor,
      settings: routeSettings,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
    ),
  );
}

/// A panel floating over the screen, with no barrier: everything around it
/// stays live.
class BaseFloatingPanelRoute<T> extends ModalRoute<T> {
  BaseFloatingPanelRoute({
    required this.builder,
    this.maxWidth,
    this.panelColor,
    this.capturedThemes,
    super.settings,
  });

  final WidgetBuilder builder;
  final double? maxWidth;

  /// The panel's own fill; null when the sheet paints its own card.
  final Color? panelColor;
  final CapturedThemes? capturedThemes;

  /// Where the last panel's top-left was left.
  static Offset? _lastOffset;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 140);

  /// No barrier at all: taps beside the panel reach the screen under it.
  @override
  Widget buildModalBarrier() => const IgnorePointer(child: SizedBox.shrink());

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget content = Builder(builder: builder);
    return _BaseFloatingPanel(
      maxWidth: maxWidth,
      panelColor: panelColor,
      initialOffset: _lastOffset,
      onMoved: (Offset o) => _lastOffset = o,
      onClose: () => Navigator.of(context).maybePop(),
      child: capturedThemes?.wrap(content) ?? content,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }
}

class _BaseFloatingPanel extends StatefulWidget {
  const _BaseFloatingPanel({
    required this.child,
    required this.onClose,
    required this.onMoved,
    this.initialOffset,
    this.maxWidth,
    this.panelColor,
  });

  final Widget child;
  final VoidCallback onClose;
  final ValueChanged<Offset> onMoved;
  final Offset? initialOffset;
  final double? maxWidth;
  final Color? panelColor;

  @override
  State<_BaseFloatingPanel> createState() => _BaseFloatingPanelState();
}

class _BaseFloatingPanelState extends State<_BaseFloatingPanel> {
  static const double _defaultWidth = 440;
  static const double _gripH = 26;
  static const double _radius = 28;

  /// Mid grey reads on light and dark glass alike: this sits over whatever
  /// the sheet paints, in whichever theme.
  static const Color _chrome = Color(0xFF8E8E93);

  Offset? _offset;

  @override
  Widget build(BuildContext context) {
    final Size window = MediaQuery.sizeOf(context);
    final EdgeInsets safe = MediaQuery.paddingOf(context);
    final double width = math
        .min(widget.maxWidth ?? _defaultWidth, _defaultWidth)
        .clamp(280.0, math.max(280.0, window.width - 32));
    final double maxHeight = (window.height - safe.vertical) * 0.85;
    // First time: along the right, a little down — beside what is being
    // worked on rather than over it.
    final Offset start =
        widget.initialOffset ??
        Offset(
          window.width - width - 24 - safe.right,
          safe.top + (window.height - safe.vertical) * 0.1,
        );
    final Offset at = _clamp(_offset ?? start, window, safe, width);

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): widget.onClose,
      },
      child: Focus(
        autofocus: true,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: at.dx,
              top: at.dy,
              width: width,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                // Shadow outside, contents inside: a clipped Material would
                // cut the shadow off.
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_radius),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.30),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Material(
                    type: widget.panelColor == null
                        ? MaterialType.transparency
                        : MaterialType.canvas,
                    color: widget.panelColor,
                    borderRadius: BorderRadius.circular(_radius),
                    clipBehavior: widget.panelColor == null
                        ? Clip.none
                        : Clip.antiAlias,
                    child: Stack(
                      children: <Widget>[
                        // The sheet itself, with room for the grip.
                        Padding(
                          padding: const EdgeInsets.only(top: _gripH - 8),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            removeBottom: true,
                            child: widget.child,
                          ),
                        ),
                        // Grip: drag to move.
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          height: _gripH,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.grab,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanUpdate: (DragUpdateDetails d) =>
                                  setState(() {
                                    _offset = _clamp(
                                      at + d.delta,
                                      window,
                                      safe,
                                      width,
                                    );
                                    widget.onMoved(_offset!);
                                  }),
                              child: Center(
                                child: Container(
                                  width: 36,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: _chrome.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Close.
                        Positioned(
                          top: 2,
                          right: 6,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: widget.onClose,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: _chrome.withValues(alpha: 0.22),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 15,
                                  color: _chrome,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Keeps the grip on screen, so the panel can always be dragged back.
  Offset _clamp(Offset o, Size window, EdgeInsets safe, double width) => Offset(
    o.dx.clamp(8.0 + safe.left, math.max(8.0, window.width - width - 8)),
    o.dy.clamp(8.0 + safe.top, math.max(8.0, window.height - 80)),
  );
}
