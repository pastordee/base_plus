// Created: 2026-09-26
import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart';

/// iOS 26's SOFT scroll-edge effect, as Mail shows over a message: no box and
/// no line — content coming out from under the bar is sharp, and grows
/// blurrier and fades into the page colour towards the top of the screen.
///
/// UIKit draws this only over a real UIScrollView; Flutter content isn't one,
/// and a native blur can't see Flutter's pixels, so it is drawn here. Flutter
/// has no variable blur, so the progressive blur is [strips] thin bands, each a
/// little stronger than the one below.
///
/// Fills its box: place it over the top of the page, ending a little above the
/// bar's bottom edge (BaseAppBar does this for every see-through bar).
/// Pages whose large title collapses into the bar use the HARD edge instead —
/// an even frost with a hairline.
///
/// Values approved by the owner on the Prayers page, 2026-09-26.
class BaseSoftScrollEdge extends StatelessWidget {
  /// Creates the effect; it fills the box it is given.
  const BaseSoftScrollEdge({
    super.key,
    this.maxBlur = 14,
    this.strips = 12,
    this.color,
  });

  /// Blur at the very top of the box, easing to none at the bottom.
  final double maxBlur;

  /// How many bands make up the progressive blur.
  final int strips;

  /// The fade's colour; the page background by default.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // Not while the page is sliding in or out: the strips moved by fractions
    // of a pixel and their joins showed as a dark line flickering across the
    // bar during the transition (owner, 2026-09-26). Shown once the page has
    // settled — and nothing has scrolled under the bar before then anyway.
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    final Animation<double>? inOut = route?.animation;
    final Animation<double>? covered = route?.secondaryAnimation;
    if (inOut == null || covered == null) {
      return _edge(context);
    }
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[inOut, covered]),
      builder: (BuildContext context, Widget? edge) {
        final bool settled = inOut.status == AnimationStatus.completed &&
            covered.status == AnimationStatus.dismissed;
        return settled ? edge! : const SizedBox.shrink();
      },
      child: _edge(context),
    );
  }

  Widget _edge(BuildContext context) {
    final Color base =
        color ?? CupertinoTheme.of(context).scaffoldBackgroundColor;
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints box) {
          final double height = box.maxHeight;
          if (!height.isFinite || height <= 0) {
            return const SizedBox.shrink();
          }
          final double strip = height / strips;
          return Stack(
            children: <Widget>[
              for (int i = 0; i < strips; i++)
                Positioned(
                  top: i * strip,
                  left: 0,
                  right: 0,
                  height: strip + 0.5, // overlap: no hairline gaps
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: _sigma(i),
                        sigmaY: _sigma(i),
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        base.withValues(alpha: 0.85),
                        base.withValues(alpha: 0.35),
                        base.withValues(alpha: 0.0),
                      ],
                      stops: const <double>[0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Strongest at the top, down to none at the bottom strip.
  double _sigma(int i) {
    final double t = strips <= 1 ? 1 : 1 - i / (strips - 1);
    return maxBlur * t * t;
  }
}

/// iOS 26's HARD scroll-edge effect, for a large title collapsing into the
/// bar (Music's playlists, an event page): an even frost with a hairline along
/// the bottom, fading in over the first [distance] of scrolling as the title
/// slides beneath the bar.
///
/// Drawn in Flutter because a native blur can't see Flutter's pixels (it shows
/// as a flat grey box). Fills its box: the status bar plus the bar.
/// Values approved by the owner on the event page, 2026-09-26.
class BaseHardScrollEdge extends StatelessWidget {
  /// Creates the effect, driven by [scrollController].
  const BaseHardScrollEdge({
    super.key,
    required this.scrollController,
    this.distance = 52,
    this.blur = 16,
    this.tint = 0.25,
  });

  /// The page's scroll view.
  final ScrollController scrollController;

  /// Scroll distance over which the effect fades in.
  final double distance;

  /// Blur of the frost.
  final double blur;

  /// Opacity of the page-colour tint over the blur.
  final double tint;

  @override
  Widget build(BuildContext context) {
    final Color base = CupertinoTheme.of(context).scaffoldBackgroundColor;
    return IgnorePointer(
      child: ListenableBuilder(
        listenable: scrollController,
        builder: (BuildContext context, Widget? frost) {
          final double offset = scrollController.positions.length == 1
              ? scrollController.offset
              : 0;
          final double under = (offset / distance).clamp(0.0, 1.0);
          if (under == 0) {
            return const SizedBox.shrink();
          }
          return Opacity(opacity: under, child: frost);
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: ColoredBox(color: base.withValues(alpha: tint)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Builder(
                builder: (BuildContext context) => Container(
                  height: 1 / MediaQuery.devicePixelRatioOf(context),
                  color: CupertinoColors.separator.resolveFrom(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
