// Created: 2026-10-18
import 'package:flutter/widgets.dart';

import 'base_glass_surface.dart';

/// [child] on a glass capsule — the same material as the app bar's button
/// items (Liquid Glass on iOS 26, a blurred fill elsewhere).
///
/// For a title drawn in Flutter over a transparent bar (a chat header's avatar
/// and name, say), so it stays readable when content scrolls behind it. A bar
/// whose title is native text gets the same capsule from
/// `BaseNavigationBar(titleGlass: true)` instead.
class BaseGlassPill extends StatelessWidget {
  const BaseGlassPill({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.fallbackColor,
  }) : super(key: key);

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Fill for the non-glass fallback; defaults to [BaseGlassSurface]'s.
  final Color? fallbackColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Sized by the child below, so the capsule always fits the content.
        Positioned.fill(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints c) {
              final Size size = c.biggest;
              return BaseGlassSurface(
                fallbackColor: fallbackColor,
                shapes: <BaseGlassShape>[
                  BaseGlassShape(
                    rect: Offset.zero & size,
                    cornerRadius: size.height / 2,
                  ),
                ],
              );
            },
          ),
        ),
        Padding(padding: padding, child: child),
      ],
    );
  }
}
