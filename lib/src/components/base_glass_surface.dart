// Created: 2026-09-09
import 'dart:io' show Platform;
import 'dart:ui' as ui;

import 'package:cupertino_native_extra/cupertino_native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// One shape drawn on a [BaseGlassSurface].
@immutable
class BaseGlassShape {
  /// Creates a shape occupying [rect], rounded by [cornerRadius].
  const BaseGlassShape({required this.rect, this.cornerRadius = 0});

  /// Where the shape sits, in logical pixels relative to the surface.
  final Rect rect;

  /// Corner radius. Pass half the height for a capsule.
  final double cornerRadius;

  @override
  bool operator ==(Object other) =>
      other is BaseGlassShape &&
      other.rect == rect &&
      other.cornerRadius == cornerRadius;

  @override
  int get hashCode => Object.hash(rect, cornerRadius);
}

/// A backdrop of glass shapes that **flow together as they approach**.
///
/// On iOS 26 this is UIKit's `UIGlassContainerEffect`: shapes within [spacing]
/// of each other merge into one piece of glass and separate again as they move
/// apart. That behaviour is the reason to reach for this rather than a
/// [BackdropFilter] — a blur cannot merge two shapes, so a bar drawn on a
/// sheet stays visibly a bar on a sheet however well their colours are
/// matched. Here it can dissolve into the sheet and re-form.
///
/// Merging is a property of one surface. Shapes given to two different
/// [BaseGlassSurface]s never merge, so everything that has to flow together
/// belongs in a single [shapes] list.
///
/// Everywhere else — Android, and iOS before 26 — it falls back to a blurred
/// translucent fill clipped to the same shapes. The layout is identical and
/// the surface still reads as frosted; only the merging is missing, so a
/// design that *depends* on shapes joining needs to still make sense when they
/// stay apart.
///
/// This draws no content and accepts no touches. Size it to the region the
/// shapes live in, put it at the bottom of a [Stack], and lay the real widgets
/// over it:
///
/// ```dart
/// Stack(
///   children: [
///     Positioned.fill(
///       child: BaseGlassSurface(
///         spacing: 12,
///         shapes: [
///           BaseGlassShape(rect: trayRect, cornerRadius: 50),
///           BaseGlassShape(rect: barRect, cornerRadius: barRect.height / 2),
///         ],
///       ),
///     ),
///     ...content,
///   ],
/// )
/// ```
class BaseGlassSurface extends StatelessWidget {
  /// Creates a glass backdrop drawing [shapes].
  const BaseGlassSurface({
    Key? key,
    required this.shapes,
    this.spacing = 0,
    this.clear = false,
    this.tint,
    this.fallbackColor,
    this.fallbackBlur = 24,
  }) : super(key: key);

  /// The shapes to draw, in paint order.
  final List<BaseGlassShape> shapes;

  /// How close two shapes come before they begin to merge, in logical pixels.
  ///
  /// Zero merges them only once they touch. Raising it makes them reach for
  /// each other sooner. Ignored by the fallback, which never merges.
  final double spacing;

  /// Use the thinner, clearer material instead of the standard frosted one.
  final bool clear;

  /// A colour mixed into the glass. Null leaves the system tint.
  final Color? tint;

  /// Fill colour for the fallback. Should be translucent — it is painted over
  /// a blur, and an opaque value hides it. Defaults to a light frost.
  final Color? fallbackColor;

  /// Blur sigma for the fallback.
  final double fallbackBlur;

  bool get _canUseNativeGlass => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    if (_canUseNativeGlass) {
      return CNGlassSurface(
        spacing: spacing,
        style: clear ? CNGlassStyle.clear : CNGlassStyle.regular,
        tint: tint,
        elements: shapes
            .map(
              (BaseGlassShape s) =>
                  CNGlassElement(rect: s.rect, cornerRadius: s.cornerRadius),
            )
            .toList(),
      );
    }
    return _FallbackGlass(
      shapes: shapes,
      color: fallbackColor ?? const Color(0x8CFFFFFF),
      blur: fallbackBlur,
    );
  }
}

/// Blur-and-fill stand-in for platforms with no glass material.
///
/// The blur is clipped to the shapes rather than run over the whole surface:
/// the gaps between shapes have to stay clear, or the surface reads as one
/// wide frosted band instead of separate pieces.
class _FallbackGlass extends StatelessWidget {
  const _FallbackGlass({
    required this.shapes,
    required this.color,
    required this.blur,
  });

  final List<BaseGlassShape> shapes;
  final Color color;
  final double blur;

  @override
  Widget build(BuildContext context) {
    if (shapes.isEmpty) {
      return const SizedBox.shrink();
    }
    return IgnorePointer(
      child: ClipPath(
        clipper: _ShapesClipper(shapes),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: ColoredBox(color: color),
        ),
      ),
    );
  }
}

class _ShapesClipper extends CustomClipper<Path> {
  const _ShapesClipper(this.shapes);

  final List<BaseGlassShape> shapes;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    for (final BaseGlassShape s in shapes) {
      path.addRRect(
        RRect.fromRectAndRadius(s.rect, Radius.circular(s.cornerRadius)),
      );
    }
    return path;
  }

  @override
  bool shouldReclip(_ShapesClipper oldClipper) =>
      !listEquals(oldClipper.shapes, shapes);
}
