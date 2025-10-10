import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_stateless_widget.dart';

/// BaseCNNavigationBar - Native iOS navigation bar using CNNavigationBar
/// 
/// Provides a navigation bar with leading, title, and trailing actions
/// Supports large title mode and transparency
/// Falls back to Material AppBar on Android
/// 
/// Example:
/// ```dart
/// BaseCNNavigationBar(
///   leading: [
///     CNNavigationBarAction(
///       icon: CNSymbol('chevron.left'),
///       onPressed: () => Navigator.pop(context),
///     ),
///     CNNavigationBarAction(
///       label: 'Back',
///       onPressed: () => Navigator.pop(context),
///     ),
///   ],
///   title: 'Native Nav Bar',
///   trailing: [
///     CNNavigationBarAction(
///       icon: CNSymbol('gear'),
///       onPressed: () => print('Settings'),
///     ),
///     CNNavigationBarAction(
///       icon: CNSymbol('plus'),
///       onPressed: () => print('Add'),
///     ),
///   ],
///   tint: CupertinoColors.label,
///   transparent: false,
///   largeTitle: false,
/// )
/// ```
class BaseCNNavigationBar extends BaseStatelessWidget {
  const BaseCNNavigationBar({
    Key? key,
    this.leading,
    this.title,
    this.trailing,
    this.tint,
    this.transparent = false,
    this.largeTitle = false,
    this.height,
  }) : super(key: key);

  /// Leading actions (typically back button with optional label)
  final List<CNNavigationBarAction>? leading;

  /// Navigation bar title
  final String? title;

  /// Trailing actions (typically action buttons)
  final List<CNNavigationBarAction>? trailing;

  /// Tint color for icons and text
  final Color? tint;

  /// Whether the navigation bar should be transparent
  final bool transparent;

  /// Whether to show large title style (iOS 11+)
  final bool largeTitle;

  /// Custom height for the navigation bar
  final double? height;

  @override
  Widget buildByCupertino(BuildContext context) {
    return CNNavigationBar(
      leading: leading,
      title: title,
      trailing: trailing,
      tint: tint,
      transparent: transparent,
      largeTitle: largeTitle,
      height: height,
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = tint ?? theme.colorScheme.primary;
    final textColor = tint ?? theme.colorScheme.onSurface;

    return Container(
      height: height ?? (largeTitle ? 96 : 56),
      decoration: transparent
          ? null
          : BoxDecoration(
              color: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                // Leading actions
                if (leading != null && leading!.isNotEmpty) ...[
                  ..._buildMaterialActions(leading!, iconColor, textColor),
                  const SizedBox(width: 8),
                ],
                // Title
                Expanded(
                  child: title != null
                      ? Text(
                          title!,
                          style: largeTitle
                              ? theme.textTheme.headlineSmall?.copyWith(color: textColor)
                              : theme.textTheme.titleLarge?.copyWith(color: textColor),
                          overflow: TextOverflow.ellipsis,
                        )
                      : const SizedBox.shrink(),
                ),
                // Trailing actions
                if (trailing != null && trailing!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  ..._buildMaterialActions(trailing!, iconColor, textColor),
                ],
              ],
            ),
          ),
          // Large title section
          if (largeTitle && title != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title!,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildMaterialActions(
    List<CNNavigationBarAction> actions,
    Color iconColor,
    Color textColor,
  ) {
    return actions.map((action) {
      if (action.icon != null) {
        final materialIcon = _mapSFSymbolToMaterialIcon(action.icon!.name);
        return IconButton(
          icon: Icon(materialIcon, color: iconColor),
          onPressed: action.onPressed,
          padding: const EdgeInsets.all(8.0),
        );
      } else if (action.label != null) {
        return TextButton(
          onPressed: action.onPressed,
          child: Text(action.label!, style: TextStyle(color: textColor)),
        );
      }
      return const SizedBox.shrink();
    }).toList();
  }

  IconData _mapSFSymbolToMaterialIcon(String sfSymbol) {
    // Map common SF Symbols to Material Icons
    const iconMap = {
      // Navigation
      'chevron.left': Icons.chevron_left,
      'chevron.right': Icons.chevron_right,
      'chevron.up': Icons.expand_less,
      'chevron.down': Icons.expand_more,
      'arrow.left': Icons.arrow_back,
      'arrow.right': Icons.arrow_forward,
      'arrow.up': Icons.arrow_upward,
      'arrow.down': Icons.arrow_downward,
      
      // Actions
      'plus': Icons.add,
      'minus': Icons.remove,
      'xmark': Icons.close,
      'checkmark': Icons.check,
      'pencil': Icons.edit,
      'trash': Icons.delete,
      'gear': Icons.settings,
      'ellipsis': Icons.more_horiz,
      'ellipsis.circle': Icons.more_vert,
      
      // Communication
      'paperplane': Icons.send,
      'paperplane.fill': Icons.send,
      'envelope': Icons.email,
      'envelope.fill': Icons.email,
      'phone': Icons.phone,
      'phone.fill': Icons.phone,
      'message': Icons.message,
      'message.fill': Icons.message,
      
      // Media
      'photo': Icons.photo,
      'photo.fill': Icons.photo,
      'camera': Icons.camera_alt,
      'camera.fill': Icons.camera_alt,
      'video': Icons.videocam,
      'video.fill': Icons.videocam,
      'play': Icons.play_arrow,
      'play.fill': Icons.play_arrow,
      'pause': Icons.pause,
      'pause.fill': Icons.pause,
      
      // UI
      'heart': Icons.favorite_border,
      'heart.fill': Icons.favorite,
      'star': Icons.star_border,
      'star.fill': Icons.star,
      'bookmark': Icons.bookmark_border,
      'bookmark.fill': Icons.bookmark,
      'tag': Icons.label_outline,
      'tag.fill': Icons.label,
      
      // Content
      'doc': Icons.description,
      'doc.fill': Icons.description,
      'folder': Icons.folder_outlined,
      'folder.fill': Icons.folder,
      'square.and.arrow.up': Icons.share,
      'square.and.arrow.down': Icons.download,
    };

    return iconMap[sfSymbol] ?? Icons.circle_outlined;
  }
}
