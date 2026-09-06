import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoScrollbar;
import 'package:material_ui/material_ui.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseScrollBar
/// use CupertinoScrollbar by cupertino
/// *** use cupertino = { forceUseMaterial: true } force use Scrollbar on cuperitno.
/// use Scrollbar by material
/// *** use material = { forceUseCupertino: true } force use CupertinoScrollbar on material.
///
/// CupertinoScrollbar: 2021.01.20
/// Scrollbar: 2021.03.18
/// modify 2021.06.25 by flutter 2.2.2
class BaseScrollBar extends BaseStatelessWidget {
  const BaseScrollBar({
    Key? key,
    this.controller,
    this.child,
    this.isAlwaysShown = false,
    this.thickness,
    this.thicknessWhileDragging = 8.0,
    this.radius = const Radius.circular(1.5),
    this.radiusWhileDragging = const Radius.circular(4.0),
    this.padding,
    this.notificationPredicate,
    this.showTrackOnHover,
    this.hoverThickness,
    this.interactive,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// *** general properties start ***

  /// [CupertinoScrollbar.controller]
  /// or
  /// [Scrollbar.controller]
  final ScrollController? controller;

  /// [CupertinoScrollbar.child]
  /// or
  /// [Scrollbar.child]
  final Widget? child;

  /// [CupertinoScrollbar.isAlwaysShown]
  /// or
  /// [Scrollbar.isAlwaysShown]
  final bool isAlwaysShown;

  /// [CupertinoScrollbar.thickness]
  /// or
  /// [Scrollbar.thickness]
  final double? thickness;

  /// [CupertinoScrollbar.radius]
  /// or
  /// [Scrollbar.radius]
  final Radius radius;

  /// [MediaQuery.of(context).padding]
  final EdgeInsets? padding;

  /// [CupertinoScrollbar.notificationPredicate]
  /// or
  /// [Scrollbar.notificationPredicate]
  final ScrollNotificationPredicate? notificationPredicate;

  /// *** general properties end ***

  /// *** cupertino properties start ***

  /// [CupertinoScrollbar.defaultThicknessWhileDragging]
  final double thicknessWhileDragging;

  /// [CupertinoScrollbar.defaultRadiusWhileDragging]
  final Radius radiusWhileDragging;

  /// *** cupertino properties end ***

  /// *** material properties start ***

  /// [Scrollbar.showTrackOnHover]
  final bool? showTrackOnHover;

  /// [Scrollbar.hoverThickness]
  final double? hoverThickness;

  /// [Scrollbar.interactive]
  final bool? interactive;

  /// *** material properties end ***

  /// The controller the scrollbar should actually track.
  ///
  /// Falls back to the child's own when the child is a scroll view that was
  /// given one. `BaseScrollBar(child: CustomScrollView(controller: x))` is the
  /// shape nearly every caller writes, and left to itself the scrollbar reaches
  /// for the [PrimaryScrollController] instead — which on mobile belongs to
  /// whichever scroll view claimed it, usually not this one. Nothing complains
  /// until the thumb first fades in, at which point every scroll throws "The
  /// Scrollbar's ScrollController has no ScrollPosition attached." Reading the
  /// controller off the child means the pairing can't be got wrong by omission.
  ScrollController? _resolveController(BuildContext context) {
    final ScrollController? explicit = valueOf('controller', controller);
    if (explicit != null) {
      return explicit;
    }
    final Widget? _child = valueOf('child', child);
    // SingleChildScrollView is not a ScrollView, so it needs its own case.
    if (_child is ScrollView) {
      return _child.controller;
    }
    if (_child is SingleChildScrollView) {
      return _child.controller;
    }
    return null;
  }

  /// Whether a scrollbar can be painted at all.
  ///
  /// With no controller of our own and no [PrimaryScrollController] above us
  /// there is no position to track, and a scrollbar without one does not
  /// degrade — it throws. Hand back the bare child instead: a missing thumb is
  /// a far smaller problem than an exception on every scroll.
  bool _canPaintScrollbar(BuildContext context, ScrollController? resolved) =>
      resolved != null || PrimaryScrollController.maybeOf(context) != null;

  @override
  Widget buildByCupertino(BuildContext context) {
    final Widget _child = valueOf('child', child);
    assert(_child != null, 'child can\'t be null');
    final ScrollController? _controller = _resolveController(context);
    if (!_canPaintScrollbar(context, _controller)) {
      return _buildWidget(context, _child);
    }
    final Widget _scrollbar = CupertinoScrollbar(
      controller: _controller,
      child: _child,
      // isAlwaysShown: valueOf('isAlwaysShown', isAlwaysShown),
      thickness: valueOf('thickness', thickness) ?? 3.0,
      thicknessWhileDragging: valueOf('thicknessWhileDragging', thicknessWhileDragging),
      radius: valueOf('radius', radius),
      radiusWhileDragging: valueOf('radiusWhileDragging', radiusWhileDragging),
      notificationPredicate: valueOf('notificationPredicate', notificationPredicate),
    );
    return _buildWidget(context, _scrollbar);
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final Widget? _child = valueOf('child', child);
    final ScrollController? _controller = _resolveController(context);
    if (!_canPaintScrollbar(context, _controller)) {
      return _buildWidget(context, _child!);
    }
    final Widget _scrollbar = Scrollbar(
      child: _child!,
      controller: _controller,
      // isAlwaysShown: valueOf('isAlwaysShown', isAlwaysShown),
      // showTrackOnHover: valueOf('showTrackOnHover', showTrackOnHover),
      // hoverThickness: valueOf('hoverThickness', hoverThickness),
      thickness: valueOf('thickness', thickness),
      radius: valueOf('radius', radius),
      notificationPredicate: valueOf('notificationPredicate', notificationPredicate),
      interactive: valueOf('interactive', interactive),
    );
    return _buildWidget(context, _scrollbar);
  }

  Widget _buildWidget(BuildContext context, Widget scrollbar) {
    final EdgeInsets? _padding = valueOf('padding', padding);
    if (_padding != null) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: _padding,
        ),
        child: scrollbar,
      );
    }
    return scrollbar;
  }
}
