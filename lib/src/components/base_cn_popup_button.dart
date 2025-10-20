import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

// Re-export CNPopupButton for convenience
export 'package:cupertino_native/cupertino_native.dart' show CNPopupButton;

/// Base wrapper for CNPopupButton with cross-platform support
/// 
/// Provides native iOS popup button (UIButton with popup menu) with fallback to 
/// Material Design popup menu on other platforms.
/// 
/// Uses CNPopupButton from cupertino_native on iOS, and PopupMenuButton on Android/other platforms.
/// 
/// Features:
/// - Native iOS popup button (UIButton with popup menu)
/// - Displays selected option on button label
/// - Supports all CNButtonStyle options (plain, gray, tinted, filled, bordered)
/// - Optional prefix text (e.g., "Show:", "Filter:")
/// - Custom dimensions (width and height)
/// - Custom tint colors for themed buttons
/// - Divider support between options
/// - Material Design popup menu fallback
/// 
/// Example usage:
/// ```dart
/// BaseCNPopupButton(
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
class BaseCNPopupButton extends BaseStatelessWidget {
  /// Creates a base popup button wrapper
  const BaseCNPopupButton({
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
        minWidth: width ?? 120, // Ensure minimum width for proper text display
        maxWidth: width ?? double.infinity, // Allow expansion if in Expanded widget
        minHeight: height,
        maxHeight: height,
      ),
      child: CNPopupButton(
        options: options,
        selectedIndex: selectedIndex,
        onSelected: onSelected,
        tint: tint,
        height: height,
        width: width, // Keep width param for CNPopupButton's internal handling
        buttonStyle: buttonStyle,
        prefix: prefix,
        dividerIndices: dividerIndices,
      ),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final theme = Theme.of(context);
    
    return PopupMenuButton<int>(
      itemBuilder: (context) {
        final items = <PopupMenuEntry<int>>[];
        for (int i = 0; i < options.length; i++) {
          items.add(
            PopupMenuItem<int>(
              value: i,
              child: Text(options[i]),
            ),
          );
          // Add dividers at specified indices
          if (dividerIndices.contains(i) && i < options.length - 1) {
            items.add(const PopupMenuDivider());
          }
        }
        return items;
      },
      onSelected: onSelected,
      child: InkWell(
        onTap: () {}, // Empty tap handler to ensure ink response
        child: Container(
          height: height,
          constraints: width != null 
              ? BoxConstraints(minWidth: width!, maxWidth: width!)
              : const BoxConstraints(minWidth: 120), // Increased minimum width
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _getBackgroundColor(theme),
            borderRadius: BorderRadius.circular(8),
            border: buttonStyle == CNButtonStyle.bordered
                ? Border.all(color: tint ?? theme.colorScheme.primary)
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
                    if (prefix != null) ...[
                      Text(
                        prefix!,
                        style: TextStyle(
                          color: _getTextColor(theme),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Flexible( // Allow option text to shrink if needed
                      child: Text(
                        options[selectedIndex],
                        style: TextStyle(
                          color: _getTextColor(theme),
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
                color: _getTextColor(theme),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (buttonStyle) {
      case CNButtonStyle.plain:
        return Colors.transparent;
      case CNButtonStyle.gray:
        return theme.colorScheme.surfaceVariant;
      case CNButtonStyle.tinted:
        return (tint ?? theme.colorScheme.primary).withOpacity(0.1);
      case CNButtonStyle.filled:
        return tint ?? theme.colorScheme.primary;
      case CNButtonStyle.bordered:
        return Colors.transparent;
      default:
        return Colors.transparent;
    }
  }

  Color _getTextColor(ThemeData theme) {
    switch (buttonStyle) {
      case CNButtonStyle.filled:
        return theme.colorScheme.onPrimary;
      case CNButtonStyle.tinted:
        return tint ?? theme.colorScheme.primary;
      default:
        return theme.colorScheme.onSurface;
    }
  }
}
