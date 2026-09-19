// Created: 2026-09-19
import 'package:cupertino_native_extra/cupertino_native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_ui/material_ui.dart';

import '../components/base_glass_surface.dart';
import '../components/base_popup_menu_button.dart';
import '../navigation_bar/base_navigation_bar.dart';

/// Where [BaseAppBar] sends its buttons when the screen wants them down the
/// side rather than across the top.
///
/// iPhone Duo's cover screen is wider and shorter than any other iPhone, and
/// Apple moves navigation bars and toolbars into a column down its trailing
/// edge, under the status bar ("Designing for iPhone Duo" → Vertical
/// controls). UIKit does that for its own bars; the native bar here sits in a
/// platform view and never learns about it, so the app has to ask.
///
/// Put one of these above the app, [active] while the side column is showing,
/// and show [BaseSideToolbar] in that column. Every [BaseAppBar] below then
/// keeps its title and any text-only buttons across the top — Apple keeps
/// those horizontal — and hands its icon buttons to the column instead.
class BaseSideToolbarScope extends InheritedWidget {
  const BaseSideToolbarScope({
    super.key,
    required this.controller,
    required this.active,
    required super.child,
  });

  final BaseSideToolbarController controller;

  /// Whether the column is on screen. False leaves every bar as it was.
  final bool active;

  /// The scope, or null when there is none or it is not [active].
  static BaseSideToolbarScope? maybeOf(BuildContext context) {
    final BaseSideToolbarScope? scope =
        context.dependOnInheritedWidgetOfExactType<BaseSideToolbarScope>();
    return (scope == null || !scope.active) ? null : scope;
  }

  @override
  bool updateShouldNotify(BaseSideToolbarScope oldWidget) =>
      active != oldWidget.active || controller != oldWidget.controller;
}

/// Which screen's buttons the column is showing.
///
/// A stack, because screens cover one another: the screen that came into view
/// last is the one on top, and when it goes the one beneath it comes back.
class BaseSideToolbarController extends ChangeNotifier {
  final List<_SideToolbarEntry> _stack = <_SideToolbarEntry>[];

  /// Screens' primary actions (their floating "create" button), by owner.
  final Map<Object, BaseNavigationBarAction> _primary =
      <Object, BaseNavigationBarAction>{};

  /// The groups to show, top to bottom, or empty when no screen has any.
  List<List<BaseNavigationBarAction>> get groups =>
      _stack.isEmpty
          ? const <List<BaseNavigationBarAction>>[]
          : _stack.last.groups;

  /// The showing screen's primary action, drawn filled after its groups, or
  /// null. The most recently published wins.
  BaseNavigationBarAction? get primary =>
      _primary.isEmpty ? null : _primary.values.last;

  void _publishPrimary(Object owner, BaseNavigationBarAction action) {
    _primary.remove(owner);
    _primary[owner] = action;
    notifyListeners();
  }

  void _withdrawPrimary(Object owner) {
    if (_primary.remove(owner) != null) {
      notifyListeners();
    }
  }

  void _publish(Object owner, List<List<BaseNavigationBarAction>> groups,
      {required bool toTop}) {
    final int i =
        _stack.indexWhere((_SideToolbarEntry e) => identical(e.owner, owner));
    if (i >= 0 && !toTop) {
      _stack[i] = _SideToolbarEntry(owner, groups);
    } else {
      if (i >= 0) {
        _stack.removeAt(i);
      }
      _stack.add(_SideToolbarEntry(owner, groups));
    }
    notifyListeners();
  }

  void _withdraw(Object owner) {
    final int before = _stack.length;
    _stack.removeWhere((_SideToolbarEntry e) => identical(e.owner, owner));
    if (_stack.length != before) {
      notifyListeners();
    }
  }
}

class _SideToolbarEntry {
  const _SideToolbarEntry(this.owner, this.groups);
  final Object owner;
  final List<List<BaseNavigationBarAction>> groups;
}

/// Splits a bar's actions into what the column takes and what stays across the
/// top.
///
/// The column takes anything with an icon or an image; text-only buttons stay,
/// since Apple keeps labelled controls horizontal. Leading and trailing are
/// separate groups, and a flexible space splits a group the way it splits the
/// native bar's glass.
({List<List<BaseNavigationBarAction>> groups,
    List<BaseNavigationBarAction> leading,
    List<BaseNavigationBarAction> trailing}) splitForSideToolbar(
  List<BaseNavigationBarAction>? leading,
  List<BaseNavigationBarAction>? trailing,
) {
  final List<List<BaseNavigationBarAction>> groups =
      <List<BaseNavigationBarAction>>[];
  List<BaseNavigationBarAction> take(List<BaseNavigationBarAction>? actions) {
    final List<BaseNavigationBarAction> kept = <BaseNavigationBarAction>[];
    List<BaseNavigationBarAction> group = <BaseNavigationBarAction>[];
    for (final BaseNavigationBarAction a
        in actions ?? const <BaseNavigationBarAction>[]) {
      if (a.isFlexibleSpace) {
        if (group.isNotEmpty) {
          groups.add(group);
        }
        group = <BaseNavigationBarAction>[];
      } else if (a.isFixedSpace) {
        continue;
      } else if (a.icon != null || a.isImageAction || _isShortLabel(a)) {
        group.add(a);
      } else {
        kept.add(a);
      }
    }
    if (group.isNotEmpty) {
      groups.add(group);
    }
    return kept;
  }

  final List<BaseNavigationBarAction> keptLeading = take(leading);
  final List<BaseNavigationBarAction> keptTrailing = take(trailing);
  return (groups: groups, leading: keptLeading, trailing: keptTrailing);
}

/// A text-only action short enough to sit in a round button — a Bible
/// version such as ESV or NKJV. Apple keeps labelled controls horizontal, but a
/// few letters read as a symbol would, and leaving them in the bar kept a whole
/// bar across the top for one button (owner, 2026-09-19).
///
/// Abbreviations only (all capitals, up to five): words such as Done, Next or
/// Edit stay in the bar, as Apple asks.
bool _isShortLabel(BaseNavigationBarAction a) =>
    a.icon == null &&
    !a.isImageAction &&
    RegExp(r'^[A-Z0-9]{2,5}$').hasMatch(a.label?.trim() ?? '');

/// Puts [groups] in the column while the screen it sits in is the one showing.
///
/// "Showing" is [TickerMode]: a tab the home screen has hidden, and a route
/// covered by another, both have their tickers switched off — so a screen out
/// of sight gives the column up without having to know why.
class BaseSideToolbarPublisher extends StatefulWidget {
  const BaseSideToolbarPublisher({super.key, required this.groups});

  final List<List<BaseNavigationBarAction>> groups;

  @override
  State<BaseSideToolbarPublisher> createState() =>
      _BaseSideToolbarPublisherState();
}

class _BaseSideToolbarPublisherState extends State<BaseSideToolbarPublisher> {
  BaseSideToolbarController? _controller;
  bool _shown = false;

  /// The column is rebuilt from above the app, which may not be told to
  /// change while this subtree builds — so changes wait for the end of the
  /// frame, and ask for one, since a post-frame callback schedules nothing.
  void _later(VoidCallback fn) {
    SchedulerBinding.instance.addPostFrameCallback((_) => fn());
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final BaseSideToolbarController? controller =
        BaseSideToolbarScope.maybeOf(context)?.controller;
    final bool show =
        controller != null && TickerMode.valuesOf(context).enabled;
    final BaseSideToolbarController? previous = _controller;
    if (previous != null && previous != controller) {
      _later(() => previous._withdraw(this));
    }
    _controller = controller;
    if (show) {
      final bool toTop = !_shown;
      final List<List<BaseNavigationBarAction>> groups = widget.groups;
      _later(() => controller._publish(this, groups, toTop: toTop));
    } else if (_shown && controller != null) {
      _later(() => controller._withdraw(this));
    }
    _shown = show;
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    final BaseSideToolbarController? controller = _controller;
    if (controller != null) {
      _later(() => controller._withdraw(this));
    }
    super.dispose();
  }
}

/// The column's toolbar: the showing screen's buttons, top to bottom.
///
/// A group of one is a round glass button. Two or more share one capsule of
/// glass, the way Mail keeps trash, move and reply together — related actions
/// read as one control.
class BaseSideToolbar extends StatelessWidget {
  const BaseSideToolbar({super.key, required this.controller});

  final BaseSideToolbarController controller;

  /// Diameter of a button, and the width of a group's capsule.
  static const double buttonSize = 44;

  static const double _groupGap = 10;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? _) {
        final List<List<BaseNavigationBarAction>> groups = controller.groups;
        final BaseNavigationBarAction? primary = controller.primary;
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          return _nativeColumn(context, groups, primary);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < groups.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(height: _groupGap),
              _group(context, groups[i]),
            ],
            // Apple's order: navigation, then the prominent action.
            if (primary != null) ...<Widget>[
              if (groups.isNotEmpty) const SizedBox(height: _groupGap),
              _button(context, primary, alone: true, prominent: true),
            ],
          ],
        );
      },
    );
  }

  /// The column in native Liquid Glass ([CNVerticalBar]). Runs of groups go
  /// into one native bar; a group holding a short text button (a Bible
  /// version) is drawn as before, since the native bar shows symbols only.
  Widget _nativeColumn(
    BuildContext context,
    List<List<BaseNavigationBarAction>> groups,
    BaseNavigationBarAction? primary,
  ) {
    final List<Widget> children = <Widget>[];
    List<CNVerticalBarGroup> run = <CNVerticalBarGroup>[];
    Color? tint = primary?.tint;
    for (final List<BaseNavigationBarAction> g in groups) {
      for (final BaseNavigationBarAction a in g) {
        tint ??= a.tint;
      }
    }
    void flush() {
      if (run.isEmpty) {
        return;
      }
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: _groupGap));
      }
      children.add(
        CNVerticalBar(
          groups: run,
          // The screen's own tint: the column sits outside the app's theme.
          tint: tint,
          itemSize: buttonSize,
          groupSpacing: _groupGap,
          inset: 0,
        ),
      );
      run = <CNVerticalBarGroup>[];
    }

    for (final List<BaseNavigationBarAction> g in groups) {
      if (g.any(_isShortLabel)) {
        flush();
        if (children.isNotEmpty) {
          children.add(const SizedBox(height: _groupGap));
        }
        children.add(_group(context, g));
      } else {
        run.add(CNVerticalBarGroup(<CNVerticalBarItem>[
          for (final BaseNavigationBarAction a in g) _nativeItem(a),
        ]));
      }
    }
    if (primary != null) {
      run.add(CNVerticalBarGroup(
        <CNVerticalBarItem>[_nativeItem(primary)],
        prominent: true,
      ));
    }
    flush();
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  CNVerticalBarItem _nativeItem(BaseNavigationBarAction a) {
    final List<BasePopupMenuItem>? menu = a.popupMenuItems;
    return CNVerticalBarItem(
      symbol: a.icon?.name,
      image: a.iosImageAsset != null ? AssetImage(a.iosImageAsset!) : null,
      label: a.label ?? '',
      badge: a.badgeValue,
      onPressed: a.onPressed,
      menu: menu == null
          ? null
          : <CNVerticalBarMenuItem>[
              for (final BasePopupMenuItem m in menu)
                m.isDivider
                    ? const CNVerticalBarMenuItem.divider()
                    : CNVerticalBarMenuItem(
                        title: m.label,
                        symbol: m.iosIcon,
                      ),
            ],
      onMenuSelected: a.onPopupMenuSelected,
    );
  }

  Widget _group(BuildContext context, List<BaseNavigationBarAction> group) {
    if (group.length == 1) {
      return _button(context, group.single, alone: true);
    }
    final double height = buttonSize * group.length;
    return SizedBox(
      width: buttonSize,
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: BaseGlassSurface(
              shapes: <BaseGlassShape>[
                BaseGlassShape(
                  rect: Offset.zero & Size(buttonSize, height),
                  cornerRadius: buttonSize / 2,
                ),
              ],
              fallbackColor: Theme.of(context).colorScheme.surface
                  .withValues(alpha: 0.92),
            ),
          ),
          Column(
            children: <Widget>[
              for (final BaseNavigationBarAction a in group)
                _button(context, a, alone: false),
            ],
          ),
        ],
      ),
    );
  }

  /// One action as a native button: glass of its own when [alone], plain on
  /// its group's capsule otherwise.
  Widget _button(
    BuildContext context,
    BaseNavigationBarAction a, {
    required bool alone,
    bool prominent = false,
  }) {
    final CNButtonStyle style = prominent
        ? CNButtonStyle.prominentGlass
        : alone
            ? CNButtonStyle.glass
            : CNButtonStyle.plain;
    final Color? tint = a.tint;
    // The bar's icons are sized for a 44pt strip, some of them very small;
    // in a column of full-size buttons they want the standard symbol size.
    // Coloured on the symbol itself: native glass keeps its own foreground
    // and ignores the button's tint, which left a red icon drawn in black.
    // Prominent glass is filled with the tint, so its symbol is left for the
    // button to colour for contrast.
    CNSymbol symbol(CNSymbol s) => CNSymbol(
          s.name,
          size: 18,
          color: prominent ? s.color : (s.color ?? tint),
          mode: s.mode,
          paletteColors: s.paletteColors,
          gradient: s.gradient,
        );

    final Widget control;
    final List<CNPopupMenuEntry>? entries = a.cnPopupMenuEntries;
    if (_isShortLabel(a)) {
      // Drawn rather than native: a native text button pads its title and
      // truncates four letters in a 44pt circle.
      control = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: a.onPressed,
        child: Stack(
          children: <Widget>[
            if (alone)
              Positioned.fill(
                child: BaseGlassSurface(
                  shapes: <BaseGlassShape>[
                    BaseGlassShape(
                      rect: const Offset(0, 0) & const Size(buttonSize, buttonSize),
                      cornerRadius: buttonSize / 2,
                    ),
                  ],
                  fallbackColor: Theme.of(context).colorScheme.surface
                      .withValues(alpha: 0.92),
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    a.label!.trim(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: tint,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (entries != null && a.onPopupMenuSelected != null) {
      control = CNPopupMenuButton.icon(
        buttonIcon: symbol(a.icon ?? const CNSymbol('ellipsis')),
        items: entries,
        onSelected: a.onPopupMenuSelected!,
        tint: tint,
        size: buttonSize,
        buttonStyle: style,
      );
    } else if (a.iosImageAsset != null) {
      control = CNButton.image(
        image: AssetImage(a.iosImageAsset!),
        imageSize: 22,
        onPressed: a.onPressed,
        tint: tint,
        size: buttonSize,
        style: style,
      );
    } else {
      control = CNButton.icon(
        icon: symbol(a.icon!),
        onPressed: a.onPressed,
        tint: tint,
        size: buttonSize,
        style: style,
      );
    }

    final String? badge = a.badgeValue;
    return Semantics(
      button: true,
      label: a.label,
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            control,
            if (badge != null && badge.isNotEmpty)
              Positioned(
                top: 4,
                right: 4,
                child: IgnorePointer(
                  child: _Badge(
                    value: badge.trim(),
                    color: a.badgeColor ?? const Color(0xFFFF3B30),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A count, or a plain dot when the value is blank — the native bar's rule.
class _Badge extends StatelessWidget {
  const _Badge({required this.value, required this.color});

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) {
      return Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
    }
    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Puts a screen's primary action — its floating "create" button — in the
/// side column while that screen is the one showing: its route on top, and its
/// tickers on (a hidden tab has them off).
class BaseSideToolbarPrimary extends StatefulWidget {
  const BaseSideToolbarPrimary({super.key, required this.action});

  final BaseNavigationBarAction action;

  @override
  State<BaseSideToolbarPrimary> createState() => _BaseSideToolbarPrimaryState();
}

class _BaseSideToolbarPrimaryState extends State<BaseSideToolbarPrimary> {
  BaseSideToolbarController? _controller;
  bool _shown = false;

  void _later(VoidCallback fn) {
    SchedulerBinding.instance.addPostFrameCallback((_) => fn());
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final BaseSideToolbarController? controller =
        BaseSideToolbarScope.maybeOf(context)?.controller;
    final bool show = controller != null &&
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.of(context)?.isCurrent ?? true);
    final BaseSideToolbarController? previous = _controller;
    if (previous != null && previous != controller) {
      _later(() => previous._withdrawPrimary(this));
    }
    _controller = controller;
    if (show) {
      final BaseNavigationBarAction action = widget.action;
      _later(() => controller._publishPrimary(this, action));
    } else if (_shown && controller != null) {
      _later(() => controller._withdrawPrimary(this));
    }
    _shown = show;
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    final BaseSideToolbarController? controller = _controller;
    if (controller != null) {
      _later(() => controller._withdrawPrimary(this));
    }
    super.dispose();
  }
}
