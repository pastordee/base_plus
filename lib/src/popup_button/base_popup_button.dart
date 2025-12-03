import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BasePopupButton - Cross-platform popup button with native iOS support
/// 
/// Uses CNPopupButton (Cupertino Native) for iOS - provides true native iOS popup button
/// (UIButton with popup menu) with built-in liquid glass effects and native rendering.
/// Uses PopupMenuButton (Material) for Android and other platforms.
/// 
/// *** use cupertino = { forceUseMaterial: true } force use Material popup on iOS
/// *** use material = { forceUseCupertino: true } force use CNPopupButton on Android
///
/// Features:
/// - Native iOS popup button via CNPopupButton (cupertino_native package)
/// - Material Design popup menu for Android
/// - Displays selected option on button label
/// - Supports all CNButtonStyle options (plain, gray, tinted, filled, bordered)
/// - Optional prefix text (e.g., "Show:", "Filter:")
/// - Custom dimensions (width and height)
/// - Custom tint colors for themed buttons
/// - Divider support between options
/// - Built-in liquid glass effects on iOS (no manual wrapper needed)
/// 
/// Example usage:
/// ```dart
/// BasePopupButton(
///   options: ['All', 'Images', 'Videos', 'Documents'],
///   selectedIndex: 0,
///   onSelected: (index) {
///     print('Selected: $index');
///   },
///   buttonStyle: CNButtonStyle.tinted,
///   tint: CupertinoColors.systemBlue,
///   prefix: 'Filter:',
/// )
/// ```
/// 
/// Updated: 2024.10.25 - Renamed from BaseCNPopupButton for consistency
class BasePopupButton extends BaseStatelessWidget {
  /// Creates a base popup button wrapper
  const BasePopupButton({
    Key? key,
    required this.options,
    this.selectedIndex = 0,
    required this.onSelected,
    this.tint,
    this.height = 32.0,
    this.width,
    this.buttonStyle = CNButtonStyle.plain,
    this.prefix,
    this.dividerIndices = const [],
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// List of options to display in the popup menu
  final List<String> options;

  /// Currently selected index
  final int selectedIndex;

  /// Called when an option is selected
  final void Function(int) onSelected;

  /// Custom tint color for the button
  final Color? tint;

  /// Height of the button
  final double height;

  /// Width of the button (optional, defaults to auto-sizing)
  final double? width;

  /// Button style from CNButtonStyle
  final CNButtonStyle buttonStyle;

  /// Optional prefix text displayed before the selected option (e.g., "Show:", "Filter:")
  final String? prefix;

  /// Indices where dividers should be inserted
  final List<int> dividerIndices;

  @override
  Widget buildByCupertino(BuildContext context) {
    // Wrap CNPopupButton with constraints to ensure proper width in Expanded/Flexible layouts
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: valueOf('width', width) ?? 120, // Ensure minimum width for proper text display
        maxWidth: valueOf('width', width) ?? double.infinity, // Allow expansion if in Expanded widget
        minHeight: valueOf('height', height),
        maxHeight: valueOf('height', height),
      ),
      child: CNPopupButton(
        options: valueOf('options', options),
        selectedIndex: valueOf('selectedIndex', selectedIndex),
        onSelected: valueOf('onSelected', onSelected),
        tint: valueOf('tint', tint),
        height: valueOf('height', height),
        width: valueOf('width', width), // Keep width param for CNPopupButton's internal handling
        buttonStyle: valueOf('buttonStyle', buttonStyle),
        prefix: valueOf('prefix', prefix),
        dividerIndices: valueOf('dividerIndices', dividerIndices),
      ),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final theme = Theme.of(context);
    final opts = valueOf('options', options);
    final selIdx = valueOf('selectedIndex', selectedIndex);
    final divIndices = valueOf('dividerIndices', dividerIndices);
    final w = valueOf('width', width);
    final h = valueOf('height', height);
    final pfx = valueOf('prefix', prefix);
    final btnStyle = valueOf('buttonStyle', buttonStyle);
    
    return PopupMenuButton<int>(
      itemBuilder: (context) {
        final items = <PopupMenuEntry<int>>[];
        for (int i = 0; i < opts.length; i++) {
          items.add(
            PopupMenuItem<int>(
              value: i,
              child: Text(opts[i]),
            ),
          );
          // Add dividers at specified indices
          if (divIndices.contains(i) && i < opts.length - 1) {
            items.add(const PopupMenuDivider());
          }
        }
        return items;
      },
      onSelected: valueOf('onSelected', onSelected),
      child: InkWell(
        onTap: () {}, // Empty tap handler to ensure ink response
        child: Container(
          height: h,
          constraints: w != null 
              ? BoxConstraints(minWidth: w, maxWidth: w)
              : const BoxConstraints(minWidth: 120), // Increased minimum width
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _getBackgroundColor(theme, btnStyle),
            borderRadius: BorderRadius.circular(8),
            border: btnStyle == CNButtonStyle.bordered
                ? Border.all(color: valueOf('tint', tint) ?? theme.colorScheme.primary)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max, // Changed from min to max to fill available space
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible( // Wrap text section in Flexible to allow it to shrink if needed
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (pfx != null) ...[
                      Text(
                        pfx,
                        style: TextStyle(
                          color: _getTextColor(theme, btnStyle),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Flexible( // Allow option text to shrink if needed
                      child: Text(
                        opts[selIdx],
                        style: TextStyle(
                          color: _getTextColor(theme, btnStyle),
                        ),
                        overflow: TextOverflow.ellipsis, // Handle very long text gracefully
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_drop_down,
                color: _getTextColor(theme, btnStyle),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme, CNButtonStyle style) {
    switch (style) {
      case CNButtonStyle.plain:
        return Colors.transparent;
      case CNButtonStyle.gray:
        return theme.colorScheme.surfaceVariant;
      case CNButtonStyle.tinted:
        return (valueOf('tint', tint) ?? theme.colorScheme.primary).withOpacity(0.1);
      case CNButtonStyle.filled:
        return valueOf('tint', tint) ?? theme.colorScheme.primary;
      case CNButtonStyle.bordered:
        return Colors.transparent;
      default:
        return Colors.transparent;
    }
  }

  Color _getTextColor(ThemeData theme, CNButtonStyle style) {
    switch (style) {
      case CNButtonStyle.filled:
        return theme.colorScheme.onPrimary;
      case CNButtonStyle.tinted:
        return valueOf('tint', tint) ?? theme.colorScheme.primary;
      default:
        return theme.colorScheme.onSurface;
    }
  }
}
