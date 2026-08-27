// Created: 2026-08-16
import 'package:material_ui/material_ui.dart';

/// Drives the iOS-style hand-off between a large title sitting in the scroll
/// body and the compact title in the app bar.
///
/// Attach it to the scroll view that owns the large title, hand the same
/// controller to [BaseAppBar.largeTitleController] and to a [BaseLargeTitle] in
/// the body, and the two cross-fade as the user scrolls:
///
/// ```dart
/// final _handoff = BaseLargeTitleController();
///
/// BaseScaffold(
///   extendBodyBehindAppBar: true,
///   appBar: BaseAppBar(
///     glass: true,
///     title: Text(event.title),
///     largeTitleController: _handoff,
///   ),
///   body: CustomScrollView(
///     controller: _handoff.scrollController,
///     slivers: <Widget>[
///       BaseLargeTitle.spacer(context),
///       BaseLargeTitle.text(event.title, controller: _handoff).sliver,
///       ...
///     ],
///   ),
/// );
/// ```
///
/// Remember to [dispose] it from the State that created it.
///
/// The fade is driven continuously by scroll offset rather than by a boolean
/// threshold, so the body title tracks the finger and is fully transparent
/// *before* it slides under a glass app bar (a threshold + `AnimatedOpacity`
/// instead reads as a late blink once the title is already hidden).
class BaseLargeTitleController extends ChangeNotifier {
  /// Creates a hand-off controller.
  ///
  /// Pass a [scrollController] to reuse one the screen already owns; otherwise
  /// one is created here and disposed with this object.
  ///
  /// [distance] is how many logical pixels of scrolling complete the fade.
  /// The default (48) suits a large title of roughly [kToolbarHeight]: it is
  /// fully faded just as its top edge reaches the bottom of the bar. Raise it
  /// to let the tail of the title slide under the glass, lower it to make the
  /// title vanish sooner.
  BaseLargeTitleController({
    ScrollController? scrollController,
    this.distance = 48.0,
  })  : assert(distance > 0.0, 'distance must be greater than zero'),
        scrollController = scrollController ?? ScrollController(),
        _ownsScrollController = scrollController == null {
    this.scrollController.addListener(_onScroll);
  }

  /// The scroll view driving the hand-off. Pass this to the body's
  /// [ScrollView.controller].
  final ScrollController scrollController;

  /// Scroll distance over which the hand-off completes.
  final double distance;

  final bool _ownsScrollController;
  bool _disposed = false;

  double _value = 0.0;

  /// Progress of the hand-off, from 0.0 to 1.0.
  ///
  /// 0.0 — the title lives in the body at full opacity.
  /// 1.0 — the title has fully handed off to the app bar.
  double get value => _value;

  /// Opacity for the app bar's compact title. Equivalent to [value].
  double get appBarOpacity => _value;

  /// Opacity for the body's large title. Equivalent to `1.0 - value`.
  double get largeTitleOpacity => 1.0 - _value;

  /// Whether the body title has fully faded out and the bar owns the title.
  ///
  /// Useful for anything else the screen wants to switch on scroll (a divider
  /// under the bar, a background change).
  bool get isScrolled => _value >= 1.0;

  void _onScroll() {
    if (_disposed) {
      return;
    }
    // `offset` asserts when a controller drives zero or several positions
    // (e.g. mid-route-transition, or one controller reused by two views).
    if (scrollController.positions.length != 1) {
      return;
    }
    final double next =
        (scrollController.offset / distance).clamp(0.0, 1.0).toDouble();
    if (next == _value) {
      return;
    }
    _value = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    scrollController.removeListener(_onScroll);
    if (_ownsScrollController) {
      scrollController.dispose();
    }
    super.dispose();
  }
}

/// The large title that sits at the top of the scroll body and fades out as the
/// app bar's compact title fades in.
///
/// Pair it with [BaseAppBar.largeTitleController] using the same
/// [BaseLargeTitleController]. Use [sliver] to drop it straight into a
/// [CustomScrollView].
class BaseLargeTitle extends StatelessWidget {
  /// A large title rendering an arbitrary [child].
  const BaseLargeTitle({
    Key? key,
    required this.controller,
    required Widget this.child,
    this.padding = _defaultPadding,
    this.alignment = AlignmentDirectional.centerStart,
  })  : text = null,
        style = null,
        maxLines = null,
        super(key: key);

  /// A large title rendering [data] with the platform's large-title style.
  const BaseLargeTitle.text(
    String this.text, {
    Key? key,
    required this.controller,
    this.style,
    this.maxLines = 2,
    this.padding = _defaultPadding,
    this.alignment = AlignmentDirectional.centerStart,
  })  : child = null,
        super(key: key);

  static const EdgeInsetsGeometry _defaultPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0);

  /// The hand-off this title is driven by. Share it with the app bar.
  final BaseLargeTitleController controller;

  /// The title widget, when built with the default constructor.
  final Widget? child;

  /// The title string, when built with [BaseLargeTitle.text].
  final String? text;

  /// Style override for [BaseLargeTitle.text]. Defaults to
  /// [TextTheme.headlineSmall] at [FontWeight.w700] in
  /// [ColorScheme.onSurface].
  final TextStyle? style;

  /// Maximum lines for [BaseLargeTitle.text]. Overflow ellipsises.
  final int? maxLines;

  /// Padding around the title. Defaults to 16 horizontal / 20 vertical.
  final EdgeInsetsGeometry padding;

  /// Alignment of the title within its padding. Defaults to start-aligned,
  /// matching the iOS large-title convention.
  final AlignmentGeometry alignment;

  /// This title wrapped for a [CustomScrollView]'s `slivers` list.
  Widget get sliver => SliverToBoxAdapter(child: this);

  /// A sliver that reserves the height a translucent app bar covers.
  ///
  /// With `BaseScaffold(extendBodyBehindAppBar: true)` the body starts under
  /// the bar, so a large title placed at offset 0 would begin already hidden.
  /// Put this first in the `slivers` list to push it clear.
  static Widget spacer(BuildContext context, {double? appBarHeight}) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).padding.top +
            (appBarHeight ?? kToolbarHeight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: controller.largeTitleOpacity,
          child: child,
        );
      },
      // Built once and passed through — the title itself doesn't depend on the
      // hand-off value, only the Opacity above it does.
      child: Padding(
        padding: padding,
        child: Align(
          alignment: alignment,
          child: child ?? _buildText(context),
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(
      text!,
      style: style ??
          theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
