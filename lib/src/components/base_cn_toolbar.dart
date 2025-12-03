import 'package:flutter/material.dart';
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../toolbar/base_toolbar.dart';

export '../toolbar/base_toolbar.dart' show BaseToolbarAlignment, BaseToolbarAction;

/// @Deprecated - Use BaseToolbar instead
/// 
/// BaseCNToolbar has been renamed to BaseToolbar for consistency.
/// BaseToolbar provides the same native iOS rendering via CNToolbar
/// and Material Design fallback.
/// 
/// Additionally, the public API now uses BaseToolbarAction instead of CNToolbarAction.
/// 
/// Migration:
/// ```dart
/// // Old
/// BaseCNToolbar(
///   leading: [
///     CNToolbarAction(icon: CNSymbol('star'), onPressed: () {}),
///   ],
/// )
/// 
/// // New
/// BaseToolbar(
///   leading: [
///     BaseToolbarAction(icon: CNSymbol('star'), onPressed: () {}),
///   ],
/// )
/// ```
/// 
/// The API is almost identical - just rename:
/// - BaseCNToolbar → BaseToolbar
/// - CNToolbarAction → BaseToolbarAction
@Deprecated('Use BaseToolbar with BaseToolbarAction instead. BaseCNToolbar will be removed in a future version.')
class BaseCNToolbar extends BaseToolbar {
  BaseCNToolbar({
    Key? key,
    List<CNToolbarAction>? leading,
    List<CNToolbarAction>? middle,
    List<CNToolbarAction>? trailing,
    String? title,
    Color? tint,
    bool transparent = false,
    double? height,
    double? pillHeight,
    BaseToolbarAlignment middleAlignment = BaseToolbarAlignment.center,
    Color? backgroundColor,
    CNSearchConfig? searchConfig,
    CNSymbol? contextIcon,
    BaseParam? baseParam,
  }) : super(
         key: key,
         leading: _convertActions(leading),
         middle: _convertActions(middle),
         trailing: _convertActions(trailing),
         title: title,
         tint: tint,
         transparent: transparent,
         height: height,
         pillHeight: pillHeight,
         middleAlignment: middleAlignment,
         backgroundColor: backgroundColor,
         searchConfig: searchConfig,
         contextIcon: contextIcon,
         baseParam: baseParam,
       );

  /// Factory constructor for search-enabled toolbar
  BaseCNToolbar.search({
    Key? key,
    List<CNToolbarAction>? leading,
    List<CNToolbarAction>? trailing,
    required CNSearchConfig searchConfig,
    CNSymbol? contextIcon,
    Color? tint,
    bool transparent = false,
    double? height,
    double? pillHeight,
    Color? backgroundColor,
    BaseParam? baseParam,
  }) : super.search(
         key: key,
         leading: _convertActions(leading),
         trailing: _convertActions(trailing),
         searchConfig: searchConfig,
         contextIcon: contextIcon,
         tint: tint,
         transparent: transparent,
         height: height,
         pillHeight: pillHeight,
         backgroundColor: backgroundColor,
         baseParam: baseParam,
       );
  
  /// Convert CNToolbarAction to BaseToolbarAction
  static List<BaseToolbarAction>? _convertActions(List<CNToolbarAction>? actions) {
    return actions?.map((action) => BaseToolbarAction(
      icon: action.icon,
      label: action.label,
      onPressed: action.onPressed,
    )).toList();
  }
}

