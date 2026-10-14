// Created: 2026-10-14
//
// A window toolbar that the screens' own bars move into — the Mac's
// (owner, 2026-10-14: "move all app bar icons to the top like Mail — and
// it can even be re-arranged on a normal Mac app").
//
// The app puts a [BaseToolbarHost] around everything. A [BaseAppBar] under
// it that sits at the top of the window draws nothing of its own — just room
// for the toolbar — and hands what it would have shown (its buttons, menus,
// segmented control and title) to the [BaseToolbarHostController]. The app
// reads [BaseToolbarHostController.bars] and builds the real toolbar from
// them (an NSToolbar on the Mac, which people can customise).
//
// Several bars can be on screen at once — a list beside a conversation —
// and their items are all offered, left to right. A bar that isn't on show
// (a tab behind another, a page covered by the one pushed over it, a tile
// kept alive off screen) offers nothing. A bar lower down the window — in a
// sheet, a panel — is not the window's: it draws itself as usual.

import 'package:cupertino_native_extra/cupertino_native.dart'
    show CNPopupMenuDivider, CNPopupMenuEntry, CNPopupMenuItem,
        CNPopupMenuSubmenu;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../navigation_bar/base_navigation_bar.dart';

/// What one screen's bar offers the window toolbar.
@immutable
class BaseToolbarBar {
  const BaseToolbarBar({
    required this.left,
    this.tag,
    this.title,
    this.leading = const <BaseNavigationBarAction>[],
    this.trailing = const <BaseNavigationBarAction>[],
    this.segments,
    this.selectedSegment,
    this.onSegmentChanged,
  });

  /// Where the bar starts across the window — the toolbar keeps the bars
  /// in this order.
  final double left;

  /// The nearest [BaseToolbarTag] above the bar: which part of the app it
  /// belongs to.
  final Object? tag;

  final String? title;
  final List<BaseNavigationBarAction> leading;
  final List<BaseNavigationBarAction> trailing;
  final List<String>? segments;
  final int? selectedSegment;
  final ValueChanged<int>? onSegmentChanged;
}

/// Keeps track of the bars that have moved into the window toolbar.
class BaseToolbarHostController extends ChangeNotifier {
  BaseToolbarHostController({double bandHeight = 52}) : _bandHeight = bandHeight;

  double _bandHeight;

  /// How tall the toolbar is. Bars give the screen at least this much room,
  /// and only a bar starting in its top half counts as the window's. It
  /// changes with the toolbar (taller with labels under the icons): the
  /// [BaseToolbarHost] above then rebuilds the bars.
  double get bandHeight => _bandHeight;
  set bandHeight(double value) {
    if (value == _bandHeight) return;
    _bandHeight = value;
    for (final _HostedBarState s in _states.toList()) {
      s._hostChanged();
    }
    _scheduleCheck();
  }

  bool _enabled = true;

  /// Off while the toolbar is hidden (View ▸ Hide Toolbar): every bar draws
  /// itself again.
  bool get enabled => _enabled;
  set enabled(bool value) {
    if (value == _enabled) return;
    _enabled = value;
    for (final _HostedBarState s in _states.toList()) {
      s._hostChanged();
    }
    _scheduleCheck();
  }

  /// Painted in the room a bar leaves, so a page scrolling up under the
  /// toolbar doesn't show through it (owner, 2026-10-14). Null: see-through.
  Color? background;

  double _topInset = 0;

  /// Room the app has left above the screens (for pages with no bar to move
  /// up): a bar just below it still counts as at the top.
  double get topInset => _topInset;
  set topInset(double value) {
    if (value == _topInset) return;
    _topInset = value;
    _scheduleCheck();
  }

  final Set<_HostedBarState> _states = <_HostedBarState>{};
  List<BaseToolbarBar> _bars = const <BaseToolbarBar>[];
  bool _checkScheduled = false;

  /// The bars on show at the top of the window, left to right.
  List<BaseToolbarBar> get bars => _bars;

  void _add(_HostedBarState s) {
    _states.add(s);
    _scheduleCheck();
  }

  void _remove(_HostedBarState s) {
    _states.remove(s);
    _scheduleCheck();
  }

  /// After the next frame is laid out: which bars are at the top and on show.
  /// Also asked for on every frame while there are bars, because a page
  /// sliding over another changes what is on show without rebuilding it.
  void _scheduleCheck() {
    if (_checkScheduled) return;
    _checkScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      _check();
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  void _check() {
    final List<BaseToolbarBar> shown = <BaseToolbarBar>[];
    bool animating = false;
    for (final _HostedBarState s in _states.toList()) {
      if (!s.mounted) continue;
      final RenderObject? r = s.context.findRenderObject();
      if (r is! RenderBox || !r.attached || !r.hasSize) continue;
      final Offset at = r.localToGlobal(Offset.zero);
      s._setInBand(at.dy < _topInset + bandHeight / 2);
      if (!_enabled || !s._inBand || !s._tickers) continue;
      final ModalRoute<Object?>? route = s._route;
      if (route != null) {
        if (!route.isActive) continue;
        final AnimationStatus? a = route.animation?.status;
        final AnimationStatus? b = route.secondaryAnimation?.status;
        if (a == AnimationStatus.forward ||
            a == AnimationStatus.reverse ||
            b == AnimationStatus.forward ||
            b == AnimationStatus.reverse) {
          animating = true;
        }
        // Mid-way in or out, or with a page over it: not the screen on show.
        if (a != null && a != AnimationStatus.completed) continue;
        if (b != null && b != AnimationStatus.dismissed) continue;
      }
      if (!_painted(r)) continue;
      shown.add(s._offer(at.dx));
    }
    shown.sort((BaseToolbarBar a, BaseToolbarBar b) => a.left.compareTo(b.left));
    // While a page slides in or out the toolbar keeps what it had, rather
    // than emptying for the length of the slide.
    if (animating) {
      _scheduleCheck();
      return;
    }
    if (!_same(shown, _bars)) {
      _bars = List<BaseToolbarBar>.unmodifiable(shown);
      notifyListeners();
    }
  }

  /// False when something above [r] keeps it off screen: an [Offstage], or an
  /// [IndexedStack] showing another child.
  static bool _painted(RenderObject r) {
    RenderObject node = r;
    while (node.parent != null) {
      final RenderObject parent = node.parent!;
      if (parent is RenderOffstage && parent.offstage) return false;
      if (parent is RenderIndexedStack) {
        int i = 0;
        RenderBox? child = parent.firstChild;
        while (child != null && !identical(child, node)) {
          i++;
          child = parent.childAfter(child);
        }
        if (child != null && parent.index != i) return false;
      }
      node = parent;
    }
    return true;
  }

  static bool _same(List<BaseToolbarBar> a, List<BaseToolbarBar> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (!identical(a[i], b[i])) return false;
    }
    return true;
  }

  /// A popup action's items as the native menu takes them; each entry,
  /// dividers and submenu headers included, has one depth-first index — the
  /// one the action's `onPopupMenuSelected` is given.
  static List<Map<String, Object?>> menuEntries(BaseNavigationBarAction a) {
    Map<String, Object?>? one(CNPopupMenuEntry e) {
      if (e is CNPopupMenuItem) {
        return <String, Object?>{
          'type': 'item',
          'label': e.label,
          'icon': e.icon?.name ?? '',
          'enabled': e.enabled,
          'selected': e.selected,
          if (e.subtitle != null) 'subtitle': e.subtitle,
        };
      }
      if (e is CNPopupMenuSubmenu) {
        return <String, Object?>{
          'type': 'submenu',
          'label': e.title,
          'icon': e.icon?.name ?? '',
          'children': e.children.map(one).whereType<Map<String, Object?>>().toList(),
        };
      }
      if (e is CNPopupMenuDivider) return <String, Object?>{'type': 'divider'};
      return null;
    }

    return (a.cnPopupMenuEntries ?? const <CNPopupMenuEntry>[])
        .map(one)
        .whereType<Map<String, Object?>>()
        .toList();
  }
}

/// Puts the screens' bars under it into [controller]'s toolbar.
class BaseToolbarHost extends InheritedWidget {
  BaseToolbarHost({
    super.key,
    required this.controller,
    required super.child,
  }) : _height = controller.bandHeight;

  final BaseToolbarHostController controller;

  /// The toolbar's height when this was built: the bars depend on it.
  final double _height;

  static BaseToolbarHostController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BaseToolbarHost>()?.controller;

  @override
  bool updateShouldNotify(BaseToolbarHost oldWidget) =>
      oldWidget.controller != controller || oldWidget._height != _height;
}

/// Names the part of the app the bars under it belong to
/// ([BaseToolbarBar.tag]).
class BaseToolbarTag extends InheritedWidget {
  const BaseToolbarTag({super.key, required this.tag, required super.child});

  final Object tag;

  static Object? of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<BaseToolbarTag>()?.tag;

  @override
  bool updateShouldNotify(BaseToolbarTag oldWidget) => oldWidget.tag != tag;
}

/// A [BaseAppBar] under a [BaseToolbarHost]: room for the toolbar where the
/// bar was, or — away from the top of the window — the bar itself.
class BaseHostedAppBar extends StatefulWidget {
  const BaseHostedAppBar({
    super.key,
    required this.controller,
    required this.bar,
    required this.height,
    required this.offer,
    this.titleWidget,
  });

  final BaseToolbarHostController controller;

  /// The bar as it is drawn when it isn't in the toolbar.
  final Widget bar;
  final double height;

  /// A title the toolbar can't show (an avatar and a name): drawn in the
  /// room the bar leaves, under the toolbar's own items.
  final Widget? titleWidget;

  /// What the bar offers, read from the [BaseAppBar] that built this.
  final BaseToolbarBar Function(double left, Object? tag) offer;

  @override
  State<BaseHostedAppBar> createState() => _HostedBarState();
}

class _HostedBarState extends State<BaseHostedAppBar> {
  bool _inBand = true;
  bool _tickers = true;
  ModalRoute<Object?>? _route;
  BaseToolbarBar? _last;

  @override
  void initState() {
    super.initState();
    widget.controller._add(this);
  }

  @override
  void didUpdateWidget(BaseHostedAppBar old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller._remove(this);
      widget.controller._add(this);
    }
    _last = null;
    widget.controller._scheduleCheck();
  }

  @override
  void dispose() {
    widget.controller._remove(this);
    super.dispose();
  }

  void _setInBand(bool value) {
    if (value == _inBand) return;
    setState(() => _inBand = value);
  }

  void _hostChanged() {
    if (mounted) setState(() {});
  }

  /// The same object while nothing about the bar has changed, so the toolbar
  /// is only rebuilt when it must be.
  BaseToolbarBar _offer(double left) {
    final BaseToolbarBar? last = _last;
    if (last != null && (last.left - left).abs() < 0.5) return last;
    return _last = widget.offer(left, BaseToolbarTag.of(context));
  }

  @override
  Widget build(BuildContext context) {
    _route = ModalRoute.of(context);
    _tickers = TickerMode.valuesOf(context).enabled;
    // A rebuild is often the only sign that the bar came on or went off
    // screen (its route was covered, its tab hidden).
    _last = null;
    widget.controller._scheduleCheck();
    if (!widget.controller.enabled || !_inBand) return widget.bar;
    final Color? background = widget.controller.background;
    final Widget room = SizedBox(
      height: widget.height,
      child: widget.titleWidget == null
          ? null
          : IgnorePointer(child: Center(child: widget.titleWidget)),
    );
    return background == null ? room : ColoredBox(color: background, child: room);
  }
}
