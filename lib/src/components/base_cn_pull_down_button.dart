import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../pull_down_button/base_pull_down_button.dart';

// Re-export Base* menu entry classes
export '../pull_down_button/base_pull_down_button.dart'
    show
        BasePullDownMenuEntry,
        BasePullDownMenuItem,
        BasePullDownMenuDivider,
        BasePullDownMenuInlineActions,
        BasePullDownInlineAction,
        BasePullDownMenuSubmenu;

/// @Deprecated - Use BasePullDownButton instead
/// 
/// BaseCNPullDownButton has been renamed to BasePullDownButton for consistency.
/// BasePullDownButton provides the same native iOS rendering via CNPullDownButton
/// and Material Design popup menu fallback.
/// 
/// Additionally, the public API now uses Base* menu entry classes instead of CN*.
/// 
/// Migration:
/// ```dart
/// // Old
/// BaseCNPullDownButton.icon(
///   buttonIcon: CNSymbol('ellipsis.circle'),
///   items: [
///     CNPullDownMenuItem(label: 'Save', icon: CNSymbol('square.and.arrow.down')),
///     CNPullDownMenuDivider(),
///   ],
/// )
/// 
/// // New
/// BasePullDownButton.icon(
///   buttonIcon: CNSymbol('ellipsis.circle'),
///   items: [
///     BasePullDownMenuItem(label: 'Save', icon: CNSymbol('square.and.arrow.down')),
///     BasePullDownMenuDivider(),
///   ],
/// )
/// ```
/// 
/// Rename classes:
/// - BaseCNPullDownButton → BasePullDownButton
/// - CNPullDownMenuItem → BasePullDownMenuItem
/// - CNPullDownMenuDivider → BasePullDownMenuDivider
/// - CNPullDownMenuInlineActions → BasePullDownMenuInlineActions
/// - CNPullDownInlineAction → BasePullDownInlineAction
/// - CNPullDownMenuSubmenu → BasePullDownMenuSubmenu
@Deprecated('Use BasePullDownButton with Base* menu entry classes instead. BaseCNPullDownButton will be removed in a future version.')
class BaseCNPullDownButton extends BasePullDownButton {
  BaseCNPullDownButton({
    Key? key,
    required List<CNPullDownMenuEntry> items,
    ValueChanged<int>? onSelected,
    ValueChanged<int>? onInlineActionSelected,
    String? buttonLabel,
    double size = 44.0,
    bool enabled = true,
    BaseParam? baseParam,
  }) : super(
         key: key,
         items: _convertMenuEntries(items),
         onSelected: onSelected,
         onInlineActionSelected: onInlineActionSelected,
         buttonLabel: buttonLabel,
         size: size,
         enabled: enabled,
         baseParam: baseParam,
       );

  BaseCNPullDownButton.icon({
    Key? key,
    required CNSymbol buttonIcon,
    double size = 44.0,
    required List<CNPullDownMenuEntry> items,
    ValueChanged<int>? onSelected,
    ValueChanged<int>? onInlineActionSelected,
    bool enabled = true,
    BaseParam? baseParam,
  }) : super.icon(
         key: key,
         buttonIcon: buttonIcon,
         size: size,
         items: _convertMenuEntries(items),
         onSelected: onSelected,
         onInlineActionSelected: onInlineActionSelected,
         enabled: enabled,
         baseParam: baseParam,
       );

  /// Convert CN* menu entries to Base* menu entries
  static List<BasePullDownMenuEntry> _convertMenuEntries(List<CNPullDownMenuEntry> entries) {
    return entries.map((entry) {
      if (entry is CNPullDownMenuItem) {
        return BasePullDownMenuItem(
          label: entry.label,
          icon: entry.icon,
          isDestructive: entry.isDestructive,
        );
      } else if (entry is CNPullDownMenuDivider) {
        return const BasePullDownMenuDivider();
      } else if (entry is CNPullDownMenuInlineActions) {
        return BasePullDownMenuInlineActions(
          actions: entry.actions.map((action) => BasePullDownInlineAction(
            label: action.label,
            icon: action.icon,
          )).toList(),
        );
      } else if (entry is CNPullDownMenuSubmenu) {
        return BasePullDownMenuSubmenu(
          title: entry.title,
          subtitle: entry.subtitle,
          icon: entry.icon,
          items: _convertMenuEntries(entry.items),
        );
      }
      // Fallback: return a simple menu item
      return const BasePullDownMenuItem(label: 'Unknown');
    }).toList();
  }
}
