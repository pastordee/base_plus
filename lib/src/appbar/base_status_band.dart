// Created: 2026-09-21
import 'package:material_ui/material_ui.dart';

// The tall status band, and where a bar goes in it.
//
// The iPhone Duo's inner display in portrait has an 82pt top inset with the
// clock and the signal tucked into its right-hand corner, leaving most of
// that band empty. Apple's own apps put the screen's bar up there beside the
// clock rather than on a second row below it — Safari's toolbar sits on the
// clock's line — and so do these apps (owner, 2026-09-21).
//
// An iPad's top inset is 24pt with nothing to sit beside, so its bar stays
// below the status bar as usual, and a phone's is unchanged.
//
// This is the measurement, kept in one place so the main app and the Creator
// place their bars alike. The main app has carried its own copy of these
// numbers in its tablet home shell since 2026-09-19; this is where they
// belong.
/// Room to keep clear on the right of a bar sharing the band: the clock and
/// the signal live there.
const double kBaseStatusCornerWidth = 120;

/// How far down the band the bar is nudged so it lands on the clock's line
/// rather than above it — the clock sits low in the band, not in its middle.
const double kBaseStatusBandBaseline = 6;

/// Whether this screen's status bar is a tall band with the clock only in its
/// corner, so a bar can share the line with it.
///
/// Two tests, and both are needed. A modern iPhone's top inset is 62 — over
/// the line a foldable's 82 was meant to clear — so on height alone every
/// screen on an iPhone 18 Pro put its bar up into the status bar, across the
/// clock and the battery (owner, 2026-09-21). The band belongs to the
/// foldable's inner display, which is tablet-sized; a phone's is not, however
/// tall its inset has grown.
///
/// viewPadding rather than padding: a SafeArea or a MediaQuery override
/// further up may already have taken the inset, and the question is about the
/// hardware, not about what is left of it.
bool baseStatusBand(BuildContext context) {
  final MediaQueryData mq = MediaQuery.of(context);
  return mq.viewPadding.top >= 60 && mq.size.shortestSide >= 600;
}

/// Where the top of a [barHeight]-tall bar goes so it sits on the clock's
/// line, measured from the top of the screen.
///
/// Negative space is the point: the bar is drawn INSIDE the status inset,
/// which is why it cannot be a Scaffold's `appBar` without the inset above it
/// being reduced first — see [baseStatusBandInset].
double baseStatusBandBarTop(
  BuildContext context, {
  required double barHeight,
}) =>
    MediaQuery.viewPaddingOf(context).top -
    barHeight -
    kBaseStatusBandBaseline;

/// The top inset to hand a scaffold whose `appBar` should sit in the band.
///
/// A bar in the `appBar` slot is laid out below whatever top padding the
/// MediaQuery reports, so the only way up into the band is to report less of
/// it. Feed this to `MediaQuery(...copyWith(padding: ...top: ...))` above the
/// scaffold; off the band it returns the real inset and nothing changes.
double baseStatusBandInset(
  BuildContext context, {
  required double barHeight,
}) {
  if (!baseStatusBand(context)) {
    return MediaQuery.viewPaddingOf(context).top;
  }
  final double top = baseStatusBandBarTop(context, barHeight: barHeight);
  return top < 0 ? 0 : top;
}

/// Puts a scaffold's `appBar` on the status band's line, where the screen has
/// one.
///
/// Wrap the scaffold. A bar in the `appBar` slot is laid out below whatever
/// top padding the MediaQuery reports, so this reports less of it and the bar
/// rises into the band beside the clock. The bar stays native: the placement
/// is Flutter's, and the native path's own SafeArea reads the same padding.
///
/// Off the band — an iPad, a phone, or a screen whose status is a side column
/// (the iPhone Duo in landscape) — this changes nothing at all.
///
/// The screen still has to keep its right-hand actions clear of the clock:
/// put a [SizedBox] of [kBaseStatusCornerWidth] at the end of `actions`,
/// guarded by [baseStatusBand].
class BaseStatusBand extends StatelessWidget {
  const BaseStatusBand({
    super.key,
    required this.child,
    this.barHeight = 56,
  });

  final Widget child;

  /// The bar's own height, which decides how far up it goes.
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    if (!baseStatusBand(context)) return child;
    final MediaQueryData mq = MediaQuery.of(context);
    return MediaQuery(
      data: mq.copyWith(
        padding: mq.padding.copyWith(
          top: baseStatusBandInset(context, barHeight: barHeight),
        ),
      ),
      child: child,
    );
  }
}
