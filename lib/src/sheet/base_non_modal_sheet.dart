import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// A resting height for a [BaseNonModalSheet].
///
/// Either a fraction of the screen height or a fixed number of logical pixels.
@immutable
class BaseSheetDetent {
  /// A detent at [fraction] of the available height, 0..1.
  const BaseSheetDetent.fraction(double fraction)
    : _fraction = fraction,
      _height = null,
      assert(
        fraction > 0 && fraction <= 1,
        'A fractional detent must be within 0..1.',
      );

  /// A detent at a fixed [height] in logical pixels.
  const BaseSheetDetent.height(double height)
    : _fraction = null,
      _height = height,
      assert(height > 0, 'A fixed detent must be a positive height.');

  final double? _fraction;
  final double? _height;

  /// This detent in logical pixels, given the space the sheet may occupy.
  double resolve(double available) =>
      (_height ?? _fraction! * available).clamp(0.0, available);
}

/// Lets a widget inside a [BaseNonModalSheet] dismiss it, or hand a selection
/// back to whoever opened it.
///
/// A modal sheet is a route, so its contents just call `Navigator.pop(value)`.
/// A non-modal sheet is an overlay entry with no route of its own — the same
/// call there would pop the page *behind* the sheet, throwing the user out of
/// the screen they were on. Content that can be hosted either way should reach
/// for [maybeOf] and fall back to `Navigator.pop` when it comes back null.
///
/// ```dart
/// final scope = BaseNonModalSheetScope.maybeOf(context);
/// if (scope != null) {
///   scope.complete(chapter);
/// } else {
///   Navigator.of(context).pop(chapter);
/// }
/// ```
class BaseNonModalSheetScope extends InheritedWidget {
  const BaseNonModalSheetScope({
    required this.close,
    required this.complete,
    required this.hostContext,
    required super.child,
    super.key,
  });

  /// Dismisses the sheet without a selection.
  final VoidCallback close;

  /// Dismisses the sheet and delivers [result] to the host's `onResult`.
  final void Function(Object? result) complete;

  /// The context that opened the sheet.
  ///
  /// For presenting something that has to outlive the sheet. Content inside a
  /// sheet cannot use its own context for that: closing first leaves it
  /// defunct, and reaching for `Navigator.of(context).context` instead is
  /// worse — `showModalBottomSheet` and friends capture inherited widgets with
  /// `InheritedTheme.capture(from: context, to: navigator.context)`, so a
  /// navigator context captures *nothing* and the new surface builds with no
  /// theme at all: no background, unstyled text, still hit-testable.
  final BuildContext hostContext;

  /// The enclosing sheet, or null when the caller is not inside one — which is
  /// how content tells a non-modal host apart from a modal route.
  ///
  /// Deliberately not a dependency: these are stable callbacks, and a rebuild
  /// on every sheet change would be noise.
  static BaseNonModalSheetScope? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<BaseNonModalSheetScope>();

  @override
  bool updateShouldNotify(BaseNonModalSheetScope oldWidget) => false;
}

/// A handle on a sheet shown by [BaseNonModalSheet.show].
class BaseNonModalSheetController {
  BaseNonModalSheetController._(this._close);

  final VoidCallback _close;
  bool _closed = false;

  /// Dismisses the sheet. Safe to call more than once.
  void close() {
    if (_closed) return;
    _closed = true;
    _close();
  }
}

/// A bottom sheet that leaves the screen behind it fully interactive — the
/// treatment Apple Maps and Find My use, where the map keeps panning while the
/// sheet sits over it.
///
/// The distinction that matters is the size of the *hit area*. A sheet built on
/// `Positioned.fill` + `DraggableScrollableSheet(expand: true)` looks the same
/// but puts a scrollable across the whole viewport, so every drag lands in the
/// sheet and the content behind never sees one. This sheet occupies only its
/// own bounds, so touches outside it reach whatever is underneath untouched.
///
/// Unlike a native `UISheetPresentationController`, the content here is an
/// ordinary widget subtree in the same tree as the caller — so it can hold
/// images, chips, colour swatches, and can read the same controllers and
/// providers the calling screen uses.
///
/// ```dart
/// final sheet = BaseNonModalSheet.show(
///   context: context,
///   detents: const <BaseSheetDetent>[
///     BaseSheetDetent.fraction(0.3),
///     BaseSheetDetent.fraction(0.6),
///   ],
///   header: const Text('Proverbs 20: 21'),
///   builder: (BuildContext context, ScrollController controller) =>
///       ListView(controller: controller, children: ...),
/// );
/// // later
/// sheet.close();
/// ```
class BaseNonModalSheet extends StatefulWidget {
  const BaseNonModalSheet({
    required this.detents,
    required this.builder,
    this.header,
    this.initialDetent = 0,
    this.showGrabber = true,
    this.backgroundColor,
    this.cornerRadius = 16.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 8.0),
    this.onDismiss,
    this.onResult,
    this.hostContext,
    super.key,
  });

  /// The heights this sheet snaps between, smallest first.
  final List<BaseSheetDetent> detents;

  /// Builds the scrolling body. The [ScrollController] it is handed must be
  /// given to the scrollable inside, so dragging the body past its top edge can
  /// hand the gesture back to the sheet.
  final Widget Function(BuildContext context, ScrollController controller)
  builder;

  /// Pinned above the body and, with the grabber, the area that drags the
  /// sheet between detents.
  final Widget? header;

  /// Index into [detents] to open at.
  final int initialDetent;

  final bool showGrabber;
  final Color? backgroundColor;
  final double cornerRadius;
  final EdgeInsets margin;

  /// Called when the sheet is dragged shut. Not called by
  /// [BaseNonModalSheetController.close].
  final VoidCallback? onDismiss;

  /// Receives whatever a descendant passed to
  /// [BaseNonModalSheetScope.complete] — the overlay's stand-in for the value a
  /// modal route returns from `Navigator.pop`.
  final void Function(Object? result)? onResult;

  /// The context that opened this sheet, exposed to descendants through
  /// [BaseNonModalSheetScope.hostContext].
  final BuildContext? hostContext;

  /// Inserts a non-modal sheet into [context]'s [Overlay] and returns a handle
  /// for closing it.
  ///
  /// The entry is a bare [Positioned] pinned to the bottom, so the overlay
  /// contributes no hit area of its own — everything outside the sheet keeps
  /// behaving exactly as it did before the sheet appeared.
  static BaseNonModalSheetController show({
    required BuildContext context,
    required List<BaseSheetDetent> detents,
    required Widget Function(BuildContext context, ScrollController controller)
    builder,
    Widget? header,
    int initialDetent = 0,
    bool showGrabber = true,
    Color? backgroundColor,
    double cornerRadius = 16.0,
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 8.0),
    VoidCallback? onDismiss,
    void Function(Object? result)? onResult,
    OverlayState? overlay,
  }) {
    final OverlayState target = overlay ?? Overlay.of(context);
    late final OverlayEntry entry;
    late final BaseNonModalSheetController controller;

    void remove() {
      if (entry.mounted) entry.remove();
    }

    entry = OverlayEntry(
      builder: (BuildContext overlayContext) => Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: BaseNonModalSheet(
          detents: detents,
          builder: builder,
          header: header,
          initialDetent: initialDetent,
          showGrabber: showGrabber,
          backgroundColor: backgroundColor,
          cornerRadius: cornerRadius,
          margin: margin,
          hostContext: context,
          onResult: (Object? result) {
            controller.close();
            onResult?.call(result);
          },
          onDismiss: () {
            controller.close();
            onDismiss?.call();
          },
        ),
      ),
    );

    controller = BaseNonModalSheetController._(remove);
    target.insert(entry);
    return controller;
  }

  @override
  State<BaseNonModalSheet> createState() => _BaseNonModalSheetState();
}

class _BaseNonModalSheetState extends State<BaseNonModalSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  )..forward();

  final ScrollController _scrollController = ScrollController();

  /// The sheet's current height in logical pixels. Null until the first layout,
  /// because a fractional detent has nothing to resolve against before then.
  double? _height;
  double _available = 0.0;
  bool _dismissing = false;

  @override
  void dispose() {
    _entrance.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<double> get _stops =>
      widget.detents.map((BaseSheetDetent d) => d.resolve(_available)).toList()
        ..sort();

  void _onDragUpdate(DragUpdateDetails details) {
    final List<double> stops = _stops;
    setState(() {
      // Dragging up grows the sheet, so the delta is inverted. Allowed to
      // overshoot the smallest stop downwards, which is what makes a
      // drag-to-dismiss possible.
      _height = ((_height ?? stops.last) - details.delta.dy).clamp(
        0.0,
        stops.last,
      );
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final List<double> stops = _stops;
    final double current = _height ?? stops.last;
    final double velocity = details.velocity.pixelsPerSecond.dy;

    // A firm flick downwards from the smallest detent closes the sheet, which
    // is the gesture people expect even though nothing else here is modal.
    if (velocity > 700 && current <= stops.first) {
      _dismiss();
      return;
    }

    // Let a flick carry the sheet to the next stop in its direction rather than
    // snapping back to whichever happens to be nearest.
    double target = stops.first;
    if (velocity.abs() > 400) {
      final Iterable<double> candidates = velocity < 0
          ? stops.where((double s) => s > current)
          : stops.where((double s) => s < current);
      target = candidates.isEmpty
          ? _nearest(stops, current)
          : (velocity < 0 ? candidates.first : candidates.last);
    } else {
      target = _nearest(stops, current);
    }

    if (velocity > 700 && target == stops.first && current < stops.first) {
      _dismiss();
      return;
    }
    setState(() => _height = target);
  }

  double _nearest(List<double> stops, double value) => stops.reduce(
    (double a, double b) => (a - value).abs() <= (b - value).abs() ? a : b,
  );

  void _dismiss() {
    if (_dismissing) return;
    _dismissing = true;
    _entrance.reverse().whenComplete(() => widget.onDismiss?.call());
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    // The sheet may use everything below the status bar; resolving fractional
    // detents against the full screen would let one sit under the notch.
    _available = media.size.height - media.padding.top;
    _height ??= widget
        .detents[widget.initialDetent.clamp(0, widget.detents.length - 1)]
        .resolve(_available);

    final ThemeData theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _entrance,
      builder: (BuildContext context, Widget? child) => Transform.translate(
        offset: Offset(0.0, (1.0 - _entrance.value) * (_height ?? 0.0)),
        child: child,
      ),
      child: Padding(
        padding: widget.margin,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: _height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(widget.cornerRadius),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 14.0,
                offset: const Offset(0.0, -3.0),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          // In scope for everything the sheet hosts, so content that would
          // otherwise call Navigator.pop can close this sheet — or return a
          // selection through it — instead of popping the page behind it.
          child: BaseNonModalSheetScope(
            close: _dismiss,
            complete: (Object? result) => widget.onResult?.call(result),
            hostContext: widget.hostContext ?? context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // The grabber and header are the drag surface. Keeping the body
                // out of it means a list inside the sheet scrolls normally
                // instead of fighting the sheet for every gesture.
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: _onDragUpdate,
                  onVerticalDragEnd: _onDragEnd,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (widget.showGrabber)
                        Container(
                          width: 36.0,
                          height: 5.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.25,
                            ),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      if (widget.header != null) widget.header!,
                    ],
                  ),
                ),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: widget.builder(context, _scrollController),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
