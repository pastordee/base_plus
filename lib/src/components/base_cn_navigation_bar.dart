import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../navigation_bar/base_navigation_bar.dart';

export '../navigation_bar/base_navigation_bar.dart' show BaseNavigationBarAction;

/// @Deprecated - Use BaseNavigationBar instead
/// 
/// BaseCNNavigationBar has been renamed to BaseNavigationBar for consistency.
/// BaseNavigationBar provides the same native iOS rendering via CNNavigationBar
/// and Material AppBar fallback.
/// 
/// Additionally, the public API now uses BaseNavigationBarAction instead of CNNavigationBarAction.
/// 
/// Migration:
/// ```dart
/// // Old
/// BaseCNNavigationBar(
///   leading: [
///     CNNavigationBarAction(icon: CNSymbol('chevron.left'), onPressed: () {}),
///   ],
/// )
/// 
/// // New
/// BaseNavigationBar(
///   leading: [
///     BaseNavigationBarAction(icon: CNSymbol('chevron.left'), onPressed: () {}),
///   ],
/// )
/// ```
/// 
/// The API is almost identical - just rename:
/// - BaseCNNavigationBar → BaseNavigationBar
/// - CNNavigationBarAction → BaseNavigationBarAction
@Deprecated('Use BaseNavigationBar with BaseNavigationBarAction instead. BaseCNNavigationBar will be removed in a future version.')
class BaseCNNavigationBar extends BaseNavigationBar {
  BaseCNNavigationBar({
    Key? key,
    List<CNNavigationBarAction>? leading,
    String? title,
    List<CNNavigationBarAction>? trailing,
    Color? tint,
    bool transparent = false,
    bool largeTitle = false,
    double? height,
    double? titleSize,
    VoidCallback? onTitlePressed,
    CNSearchConfig? searchConfig,
    BaseParam? baseParam,
  }) : super(
         key: key,
         leading: _convertActions(leading),
         title: title,
         trailing: _convertActions(trailing),
         tint: tint,
         transparent: transparent,
         largeTitle: largeTitle,
         height: height,
         titleSize: titleSize,
         onTitlePressed: onTitlePressed,
         searchConfig: searchConfig,
         baseParam: baseParam,
       );

  BaseCNNavigationBar.search({
    Key? key,
    List<CNNavigationBarAction>? leading,
    List<CNNavigationBarAction>? trailing,
    required CNSearchConfig searchConfig,
    Color? tint,
    bool transparent = false,
    bool largeTitle = false,
    double? height,
    double? titleSize,
    VoidCallback? onTitlePressed,
    BaseParam? baseParam,
  }) : super.search(
         key: key,
         leading: _convertActions(leading),
         trailing: _convertActions(trailing),
         searchConfig: searchConfig,
         tint: tint,
         transparent: transparent,
         largeTitle: largeTitle,
         height: height,
         titleSize: titleSize,
         onTitlePressed: onTitlePressed,
         baseParam: baseParam,
       );

  /// Convert CNNavigationBarAction to BaseNavigationBarAction
  static List<BaseNavigationBarAction>? _convertActions(List<CNNavigationBarAction>? actions) {
    return actions?.map((action) {
      // Check if it's a fixed space action
      if (action.runtimeType.toString().contains('FixedSpace')) {
        // Try to extract width - default to 8 if not accessible
        return BaseNavigationBarAction.fixedSpace(8);
      }
      // Check if it's a flexible space action
      if (action.runtimeType.toString().contains('FlexibleSpace')) {
        return BaseNavigationBarAction.flexibleSpace();
      }
      // Regular action
      return BaseNavigationBarAction(
        icon: action.icon,
        label: action.label,
        onPressed: action.onPressed,
      );
    }).toList();
  }
}
