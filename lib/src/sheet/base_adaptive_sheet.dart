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

  /// Where the last panel's top-left was left, and the width it was given.
  /// Only the width carries over: every sheet is its own height, and one
  /// sheet's height handed to the next could squeeze it.
  static Offset? _lastOffset;
  static double? _lastWidth;

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
      initialWidth: _lastWidth,
      onResized: (double w) => _lastWidth = w,
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
    required this.onResized,
    this.initialOffset,
    this.initialWidth,
    this.maxWidth,
    this.panelColor,
  });

  final Widget child;
  final VoidCallback onClose;
  final ValueChanged<Offset> onMoved;
  final ValueChanged<double> onResized;
  final Offset? initialOffset;

  /// The width the last panel was left at.
  final double? initialWidth;
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

  static const double _minWidth = 320;
  static const double _minHeight = 160;
  static const double _handle = 22;

  Offset? _offset;

  /// Set by the corner handle.
  double? _width;
  double? _height;

  /// The sheet's own height, taken when the handle is first grabbed. Made
  /// shorter than this, the sheet is NOT squeezed — it keeps this height
  /// inside a scroll view, so a sheet whose contents can't shrink (the
  /// account sheet, owner 2026-09-29: "bottom overflowed by 44 pixels")
  /// scrolls instead of overflowing. Made taller, the height is a ceiling a
  /// scrolling sheet can grow into.
  double? _naturalHeight;
  final GlobalKey _panelKey = GlobalKey();
  Size? _dragStart;
  Offset _dragDelta = Offset.zero;

  @override
  void initState() {
    super.initState();
    _width = widget.initialWidth;
  }

  bool get _squeezed =>
      _height != null && _naturalHeight != null && _height! < _naturalHeight!;

  double _widthLimit(Size window) => math.max(_minWidth, window.width * 0.8);
  double _heightLimit(Size window, EdgeInsets safe) =>
      math.max(_minHeight, (window.height - safe.vertical) * 0.9);

  @override
  Widget build(BuildContext context) {
    final Size window = MediaQuery.sizeOf(context);
    final EdgeInsets safe = MediaQuery.paddingOf(context);
    final double width = (_width ??
            math.min(widget.maxWidth ?? _defaultWidth, _defaultWidth))
        .clamp(
          math.min(_minWidth, window.width - 32),
          math.max(_minWidth, math.min(_widthLimit(window), window.width - 32)),
        );
    final double maxHeight = (_height ??
            (window.height - safe.vertical) * 0.85)
        .clamp(_minHeight, _heightLimit(window, safe));
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
                key: _panelKey,
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
                        // The sheet itself, with room for the grip — at its
                        // own height, scrolled, when made shorter than that.
                        _fit(
                          Padding(
                            padding: const EdgeInsets.only(top: _gripH - 8),
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              removeBottom: true,
                              child: widget.child,
                            ),
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
                        // Resize: width, and the most height it may take.
                        Positioned(
                          right: 0,
                          bottom: 0,
                          width: _handle + 8,
                          height: _handle + 8,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.resizeUpLeftDownRight,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanStart: (_) {
                                final RenderBox? box =
                                    _panelKey.currentContext?.findRenderObject()
                                        as RenderBox?;
                                _dragStart = box?.size ??
                                    Size(width, maxHeight);
                                // The first grab measures the sheet as it
                                // lays itself out, before any resizing.
                                _naturalHeight ??= _dragStart!.height;
                                _dragDelta = Offset.zero;
                              },
                              onPanUpdate: (DragUpdateDetails d) =>
                                  _resizeBy(d.delta, window, safe),
                              onPanEnd: (_) {
                                if (_width != null) {
                                  widget.onResized(_width!);
                                }
                              },
                              child: const Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.all(7),
                                  child: SizedBox.square(
                                    dimension: 12,
                                    child: CustomPaint(
                                      painter: _ResizeGripPainter(_chrome),
                                    ),
                                  ),
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

  /// The corner handle's drag. It starts from the panel's height as drawn,
  /// so dragging up shrinks it straight away even when the sheet was shorter
  /// than its ceiling.
  void _resizeBy(Offset delta, Size window, EdgeInsets safe) {
    final Size start = _dragStart ?? const Size(_defaultWidth, 400);
    _dragDelta += delta;
    setState(() {
      _width = (start.width + _dragDelta.dx).clamp(
        math.min(_minWidth, window.width - 32),
        math.max(_minWidth, math.min(_widthLimit(window), window.width - 32)),
      );
      _height = (start.height + _dragDelta.dy).clamp(
        _minHeight,
        _heightLimit(window, safe),
      );
    });
  }

  /// [sheet] as it is — or, made shorter than its own height, at that height
  /// in a scroll view of the height asked for.
  Widget _fit(Widget sheet) {
    if (!_squeezed) {
      return sheet;
    }
    return SizedBox(
      height: _height,
      child: SingleChildScrollView(
        child: SizedBox(height: _naturalHeight, child: sheet),
      ),
    );
  }

  /// Keeps the grip on screen, so the panel can always be dragged back.
  Offset _clamp(Offset o, Size window, EdgeInsets safe, double width) => Offset(
    o.dx.clamp(8.0 + safe.left, math.max(8.0, window.width - width - 8)),
    o.dy.clamp(8.0 + safe.top, math.max(8.0, window.height - 80)),
  );
}

/// Two short diagonals in the corner, the usual sign for "drag to resize".
class _ResizeGripPainter extends CustomPainter {
  const _ResizeGripPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width, size.height * 0.2),
      Offset(size.width * 0.2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height * 0.62),
      Offset(size.width * 0.62, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ResizeGripPainter old) => old.color != color;
}
