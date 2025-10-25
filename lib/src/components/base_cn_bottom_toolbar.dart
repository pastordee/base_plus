// ignore_for_file: deprecated_member_use_from_same_package

import '../toolbar/base_bottom_toolbar.dart';

/// @deprecated Use [BaseBottomToolbar] instead.
/// 
/// This class is deprecated and will be removed in a future version.
/// Please migrate to [BaseBottomToolbar] which provides the same functionality
/// with a clearer name.
/// 
/// Migration:
/// ```dart
/// // Old
/// BaseCNBottomToolbar(...)
/// 
/// // New
/// BaseBottomToolbar(...)
/// ```
@Deprecated('Use BaseBottomToolbar instead. '
    'This class will be removed in a future version.')
class BaseCNBottomToolbar extends BaseBottomToolbar {
  const BaseCNBottomToolbar({
    super.key,
    super.leadingAction,
    super.trailingAction,
    super.searchPlaceholder,
    super.onSearchChanged,
    super.onSearchSubmitted,
    super.onSearchFocusChanged,
    super.currentTabIcon,
    super.currentTabLabel,
    super.height,
    super.backgroundColor,
    super.baseParam,
  });
}
