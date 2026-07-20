import 'package:flutter/material.dart';
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';
import '../components/base_popup_menu_button.dart';

/// Cross-platform navigation bar action
///
/// Represents an action button in the navigation bar with icon and/or label.
/// Also supports spacing actions for layout control.
///
/// Automatically converts to platform-specific formats:
/// - iOS: Uses CNNavigationBarAction with SF Symbols
/// - Material: Uses IconButton/TextButton with Material icons
class BaseNavigationBarAction {
  const BaseNavigationBarAction({
    this.icon,
    this.label,
    this.onPressed,
    this.tint,
    this.padding,
    this.labelSize = 15,
    this.iconSize = 16,
    this.badgeValue,
    this.badgeColor,
  })  : popupMenuItems = null,
        onPopupMenuSelected = null,
        _isFixedSpace = false,
        _isFlexibleSpace = false,
        _usePopupMenuButton = false,
        _spaceWidth = null,
        _isImageAction = false,
        _materialImage = null,
        _iosImage = null,
        _imageWidth = null,
        _imageHeight = null,
        assert(icon != null || label != null,
            'Either icon or label must be provided');

  const BaseNavigationBarAction._fixedSpace(this._spaceWidth)
      : icon = null,
        label = null,
        onPressed = null,
        tint = null,
        padding = null,
        labelSize = null,
        iconSize = null,
        badgeValue = null,
        badgeColor = null,
        popupMenuItems = null,
        onPopupMenuSelected = null,
        _isFixedSpace = true,
        _isFlexibleSpace = false,
        _usePopupMenuButton = false,
        _isImageAction = false,
        _materialImage = null,
        _iosImage = null,
        _imageWidth = null,
        _imageHeight = null;

  const BaseNavigationBarAction._flexibleSpace()
      : icon = null,
        label = null,
        onPressed = null,
        tint = null,
        padding = null,
        labelSize = null,
        iconSize = null,
        badgeValue = null,
        badgeColor = null,
        popupMenuItems = null,
        onPopupMenuSelected = null,
        _isFixedSpace = false,
        _isFlexibleSpace = true,
        _usePopupMenuButton = false,
        _spaceWidth = null,
        _isImageAction = false,
        _materialImage = null,
        _iosImage = null,
        _imageWidth = null,
        _imageHeight = null;

  const BaseNavigationBarAction._popupMenu({
    required this.icon,
    required this.label,
    required this.popupMenuItems,
    required this.onPopupMenuSelected,
    this.tint,
    this.padding,
    this.labelSize = 15,
    this.iconSize = 16,
    this.badgeValue,
    this.badgeColor,
    bool usePopupMenuButton = false,
  })  : onPressed = null,
        _isFixedSpace = false,
        _isFlexibleSpace = false,
        _usePopupMenuButton = usePopupMenuButton,
        _spaceWidth = null,
        _isImageAction = false,
        _materialImage = null,
        _iosImage = null,
        _imageWidth = null,
        _imageHeight = null;

  BaseNavigationBarAction._imageAction({
    required String materialImage,
    String? iosImage,
    double imageSize = 24.0,
    double imageWidth = 24.0,
    double imageHeight = 24.0,
    this.label,
    this.onPressed,
    this.tint,
    this.padding,
    this.labelSize,
    this.badgeValue,
    this.badgeColor,
  })  : icon = null,
        iconSize = imageSize,
        popupMenuItems = null,
        onPopupMenuSelected = null,
        _isFixedSpace = false,
        _isFlexibleSpace = false,
        _usePopupMenuButton = false,
        _spaceWidth = null,
        _isImageAction = true,
        _materialImage = materialImage,
        _iosImage = iosImage,
        _imageWidth = imageWidth,
        _imageHeight = imageHeight;

  /// Icon for the action (CNSymbol on iOS, Material icon elsewhere)
  final CNSymbol? icon;

  /// Optional text label
  final String? label;

  /// Callback when action is pressed
  final VoidCallback? onPressed;

  /// Custom tint color for the action
  final Color? tint;

  /// Padding around the action (iOS only)
  final double? padding;

  /// Label text size (iOS only)
  final double? labelSize;

  /// Icon size (iOS only)
  final double? iconSize;

  /// Badge value to display on the action (iOS only)
  final String? badgeValue;

  /// Badge background color (iOS only)
  final Color? badgeColor;

  /// Popup menu items to display when the action is pressed
  final List<BasePopupMenuItem>? popupMenuItems;

  /// Called when a popup menu item is selected
  final ValueChanged<int>? onPopupMenuSelected;

  /// Internal flag for fixed space action
  final bool _isFixedSpace;

  /// Internal flag for flexible space action
  final bool _isFlexibleSpace;

  /// Internal flag for popup menu button usage
  final bool _usePopupMenuButton;

  /// Internal space width
  final double? _spaceWidth;

  /// Internal flag for image action
  final bool _isImageAction;

  /// Asset path for Material image rendering
  final String? _materialImage;

  /// iOS-specific asset path; falls back to [_materialImage] if not set
  final String? _iosImage;

  /// Image width for Material rendering
  final double? _imageWidth;

  /// Image height for Material rendering
  final double? _imageHeight;

  /// Creates a fixed space action
  factory BaseNavigationBarAction.fixedSpace(double width) {
    return BaseNavigationBarAction._fixedSpace(width);
  }

  /// Creates a flexible space action
  factory BaseNavigationBarAction.flexibleSpace() {
    return const BaseNavigationBarAction._flexibleSpace();
  }

  /// Creates a navigation bar action with a popup menu
  factory BaseNavigationBarAction.popupMenu({
    CNSymbol? icon,
    String? label,
    required List<BasePopupMenuItem> popupMenuItems,
    required ValueChanged<int> onPopupMenuSelected,
    Color? tint,
    double? padding,
    double? labelSize = 15,
    double? iconSize = 16,
    String? badgeValue,
    Color? badgeColor,
  }) {
    return BaseNavigationBarAction._popupMenu(
      icon: icon,
      label: label,
      popupMenuItems: popupMenuItems,
      onPopupMenuSelected: onPopupMenuSelected,
      tint: tint,
      padding: padding,
      labelSize: labelSize,
      iconSize: iconSize,
      badgeValue: badgeValue,
      badgeColor: badgeColor,
      usePopupMenuButton: false,
    );
  }

  /// Creates a navigation bar action with a CNPopupMenuButton
  factory BaseNavigationBarAction.popupMenuButton({
    CNSymbol? icon,
    String? label,
    required List<BasePopupMenuItem> popupMenuItems,
    required ValueChanged<int> onPopupMenuSelected,
    Color? tint,
    double? padding,
    double? labelSize = 15,
    double? iconSize = 16,
    String? badgeValue,
    Color? badgeColor,
  }) {
    return BaseNavigationBarAction._popupMenu(
      icon: icon,
      label: label,
      popupMenuItems: popupMenuItems,
      onPopupMenuSelected: onPopupMenuSelected,
      tint: tint,
      padding: padding,
      labelSize: labelSize,
      iconSize: iconSize,
      badgeValue: badgeValue,
      badgeColor: badgeColor,
      usePopupMenuButton: true,
    );
  }

  /// Creates an action with a custom image asset.
  ///
  /// [materialImage] is the asset path used on Android via [Image.asset].
  /// [iosImage] is an optional iOS-specific asset path; on iOS the native side
  /// resolves it via [lookupKey(forAsset:)] — no bytes cross the channel.
  ///
  /// Example:
  /// ```dart
  /// BaseNavigationBarAction.withImage(
  ///   materialImage: 'assets/icons/custom.png',
  ///   iosImage: 'assets/icons/custom_ios.png', // optional
  ///   imageSize: 24.0,
  ///   label: 'Custom',
  ///   onPressed: () {},
  /// )
  /// ```
  factory BaseNavigationBarAction.withImage({
    required String materialImage,
    String? iosImage,
    double imageSize = 24.0,
    double imageWidth = 24.0,
    double imageHeight = 24.0,
    String? label,
    VoidCallback? onPressed,
    Color? tint,
    double? padding,
    double? labelSize,
    String? badgeValue,
    Color? badgeColor,
  }) {
    return BaseNavigationBarAction._imageAction(
      materialImage: materialImage,
      iosImage: iosImage,
      imageSize: imageSize,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      label: label,
      onPressed: onPressed,
      tint: tint,
      padding: padding,
      labelSize: labelSize,
      badgeValue: badgeValue,
      badgeColor: badgeColor,
    );
  }

  /// Check if this is a fixed space action
  bool get isFixedSpace => _isFixedSpace;

  /// Check if this is a flexible space action
  bool get isFlexibleSpace => _isFlexibleSpace;

  /// Check if this is a custom image action
  bool get isImageAction => _isImageAction;

  /// Get the space width (for fixed space actions)
  double? get spaceWidth => _spaceWidth;

  /// Convert to CNNavigationBarAction for iOS implementation
  CNNavigationBarAction toCNNavigationBarAction() {
    if (_isFixedSpace) {
      return CNNavigationBarAction.fixedSpace(_spaceWidth ?? 8);
    }
    if (_isFlexibleSpace) {
      return CNNavigationBarAction.flexibleSpace();
    }
    // Handle popup menu actions - convert BasePopupMenuItem to CNPopupMenuItem
    if (popupMenuItems != null && onPopupMenuSelected != null) {
      // Convert BasePopupMenuItem to CN format
      final cnItems = popupMenuItems!.map((item) {
        if (item.isDivider) {
          return const CNPopupMenuDivider();
        }

        CNSymbol? itemIcon;
        if (item.iosIcon != null) {
          itemIcon = CNSymbol(item.iosIcon!, size: item.iconSize ?? 18);
        } else if (item.iconData != null) {
          // Try to map Material icon to SF Symbol
          final sfSymbol = _mapIconToSFSymbol(item.iconData);
          if (sfSymbol != null) {
            itemIcon = CNSymbol(sfSymbol, size: item.iconSize ?? 18);
          }
        }

        return CNPopupMenuItem(
          label: item.label,
          icon: itemIcon,
          enabled: item.enabled,
        );
      }).toList();

      if (_usePopupMenuButton) {
        return CNNavigationBarAction.popupMenuButton(
          icon: icon,
          label: label,
          popupMenuItems: cnItems,
          onPopupMenuSelected: onPopupMenuSelected!,
          tint: tint,
          padding: padding,
          labelSize: labelSize,
          iconSize: iconSize,
          badgeValue: badgeValue,
          badgeColor: badgeColor,
        );
      } else {
        return CNNavigationBarAction.popupMenu(
          icon: icon,
          label: label,
          popupMenuItems: cnItems,
          onPopupMenuSelected: onPopupMenuSelected!,
          tint: tint,
          padding: padding,
          labelSize: labelSize,
          iconSize: iconSize,
          badgeValue: badgeValue,
          badgeColor: badgeColor,
        );
      }
    }
    // Image action
    if (_isImageAction) {
      return CNNavigationBarAction(
        imageAsset: _iosImage ?? _materialImage,
        label: label,
        onPressed: onPressed,
        tint: tint,
        padding: padding,
        labelSize: labelSize,
        iconSize: iconSize,
        badgeValue: badgeValue,
        badgeColor: badgeColor,
      );
    }
    // Regular action
    return CNNavigationBarAction(
      icon: icon,
      label: label,
      onPressed: onPressed,
      tint: tint,
      padding: padding,
      labelSize: labelSize,
      iconSize: iconSize,
      badgeValue: badgeValue,
      badgeColor: badgeColor,
    );
  }

  /// Map Material icon to SF Symbol name
  String? _mapIconToSFSymbol(IconData? iconData) {
    if (iconData == null) return null;

    final Map<int, String> iconMap = {
      Icons.refresh.codePoint: 'arrow.clockwise',
      Icons.edit.codePoint: 'pencil',
      Icons.delete.codePoint: 'trash',
      Icons.copy.codePoint: 'doc.on.doc',
      Icons.paste.codePoint: 'doc.on.clipboard',
      Icons.share.codePoint: 'square.and.arrow.up',
      Icons.settings.codePoint: 'gear',
      Icons.add.codePoint: 'plus',
      Icons.remove.codePoint: 'minus',
      Icons.close.codePoint: 'xmark',
      Icons.check.codePoint: 'checkmark',
      Icons.favorite.codePoint: 'heart',
      Icons.favorite_border.codePoint: 'heart',
      Icons.star.codePoint: 'star',
      Icons.star_border.codePoint: 'star',
      Icons.search.codePoint: 'magnifyingglass',
      Icons.download.codePoint: 'square.and.arrow.down',
    };

    return iconMap[iconData.codePoint];
  }

  /// Render this action as a Material widget.
  ///
  /// Lets [BaseAppBar]'s Android (Material) build reuse `leadingActions` /
  /// `trailingActions` as its `leading` / `actions`, so callers configure the
  /// bar's buttons ONCE instead of duplicating them with `leading` / `actions`.
  /// Icon actions map their SF Symbol name to the nearest Material icon; image
  /// actions use `materialImage`; popup-menu actions become a
  /// [BasePopupMenuButton]; space actions become sized gaps.
  Widget toMaterialWidget(BuildContext context) {
    if (_isFixedSpace) {
      return SizedBox(width: _spaceWidth ?? 8);
    }
    if (_isFlexibleSpace) {
      // `flexibleSpace` is an iOS trailing-layout concept. A [Spacer] here would
      // throw inside the AppBar's min-width actions Row (unbounded flex), taking
      // the whole toolbar (leading + actions) down with it. Material actions are
      // already right-aligned, so this is just a no-op gap.
      return const SizedBox.shrink();
    }

    final Color? color = tint;
    final double size = iconSize ?? 20;

    // Popup menu action
    if (popupMenuItems != null && onPopupMenuSelected != null) {
      final Widget menu = BasePopupMenuButton.icon(
        items: popupMenuItems!,
        onSelected: onPopupMenuSelected!,
        materialIcon: _sfSymbolToMaterialIcon(icon?.name) ?? Icons.more_vert,
        iosIcon: icon?.name ?? 'ellipsis',
        tooltip: label,
      );
      // BasePopupMenuButton renders Icon(materialIcon) with no explicit color,
      // so it inherits the ambient IconTheme — apply the action's tint here.
      if (color != null) {
        return IconTheme.merge(
          data: IconThemeData(color: color),
          child: menu,
        );
      }
      return menu;
    }

    // Custom image action
    if (_isImageAction && _materialImage != null) {
      return IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        tooltip: label,
        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        icon: Image.asset(
          _materialImage!,
          width: _imageWidth ?? size,
          height: _imageHeight ?? size,
          color: color,
        ),
      );
    }

    // Icon (SF Symbol) action → nearest Material icon.
    // Set the tint directly on the Icon (authoritative) so the AppBar's own
    // foregroundColor / actionsIconTheme can't override it.
    if (icon != null) {
      return IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        tooltip: label,
        color: color,
        iconSize: size,
        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        icon: Icon(
          _sfSymbolToMaterialIcon(icon!.name) ?? Icons.circle_outlined,
          color: color,
        ),
      );
    }

    // Label-only action
    if (label != null) {
      return TextButton(
        onPressed: onPressed,
        child: Text(label!, style: color != null ? TextStyle(color: color) : null),
      );
    }

    return const SizedBox.shrink();
  }

  /// Map an SF Symbol name to the nearest Material [IconData] (inverse of
  /// [_mapIconToSFSymbol], plus common navigation symbols). Returns null when
  /// there's no good match.
  IconData? _sfSymbolToMaterialIcon(String? name) {
    if (name == null) {
      return null;
    }
    const Map<String, IconData> map = {
      'chevron.left': Icons.arrow_back_ios_new,
      'chevron.right': Icons.arrow_forward_ios,
      'chevron.backward': Icons.arrow_back_ios_new,
      'chevron.forward': Icons.arrow_forward_ios,
      'arrow.left': Icons.arrow_back,
      'arrow.backward': Icons.arrow_back,
      'arrow.right': Icons.arrow_forward,
      'arrow.up': Icons.arrow_upward,
      'arrow.down': Icons.arrow_downward,
      'arrow.clockwise': Icons.refresh,
      'ellipsis': Icons.more_horiz,
      'ellipsis.circle': Icons.more_vert,
      'xmark': Icons.close,
      'xmark.circle': Icons.cancel,
      'checkmark': Icons.check,
      'plus': Icons.add,
      'plus.circle': Icons.add_circle_outline,
      'minus': Icons.remove,
      'trash': Icons.delete,
      'pencil': Icons.edit,
      'square.and.pencil': Icons.edit,
      'doc.on.doc': Icons.copy,
      'doc.on.clipboard': Icons.paste,
      'square.and.arrow.up': Icons.share,
      'square.and.arrow.down': Icons.download,
      'gear': Icons.settings,
      'gearshape': Icons.settings,
      'heart': Icons.favorite,
      'heart.fill': Icons.favorite,
      'star': Icons.star,
      'star.fill': Icons.star,
      'magnifyingglass': Icons.search,
      'person': Icons.person,
      'person.badge.plus': Icons.person_add,
      'person.crop.circle': Icons.account_circle,
      'message': Icons.message,
      'bell': Icons.notifications_none,
      'bell.fill': Icons.notifications,
      'bookmark': Icons.bookmark_border,
      'bookmark.fill': Icons.bookmark,
      'house': Icons.home,
      'line.3.horizontal': Icons.menu,
      'slider.horizontal.3': Icons.tune,
      'paperplane': Icons.send,
      'paperplane.fill': Icons.send,
      'info.circle': Icons.info_outline,
      'exclamationmark.triangle': Icons.warning_amber,
      'calendar': Icons.calendar_today,
      'camera': Icons.camera_alt,
      'photo': Icons.photo,
      'play.fill': Icons.play_arrow,
      'pause.fill': Icons.pause,
    };
    return map[name];
  }
}

/// Internal: CNNavigationBarAction from cupertino_native package
/// Used only for iOS platform channel communication
/// Public API should use BaseNavigationBarAction instead

/// BaseNavigationBar - Cross-platform navigation bar with native iOS support
///
/// Uses CNNavigationBar (Cupertino Native) for iOS - provides native iOS navigation bar
/// with large title mode, transparency, and flexible actions via UINavigationBar.
/// Uses Material AppBar for Android.
///
/// *** use cupertino = { forceUseMaterial: true } force use Material AppBar on iOS
/// *** use material = { forceUseCupertino: true } force use CNNavigationBar on Android
///
/// Features:
/// - Native iOS UINavigationBar via CNNavigationBar (cupertino_native package)
/// - Material Design AppBar for Android
/// - Leading, title, and trailing actions
/// - Large title mode support
/// - Transparency with blur effects
/// - Search functionality via factory constructor
/// - Segmented control integration (iOS native)
/// - Built-in liquid glass effects on iOS (no manual wrapper needed)
/// - Automatic platform-specific conversion of actions
///
/// Example:
/// ```dart
/// BaseNavigationBar(
///   leading: [
///     BaseNavigationBarAction(
///       icon: CNSymbol('chevron.left'),
///       onPressed: () => Navigator.pop(context),
///     ),
///     BaseNavigationBarAction(
///       label: 'Back',
///       onPressed: () => Navigator.pop(context),
///     ),
///   ],
///   title: 'Navigation Bar',
///   trailing: [
///     BaseNavigationBarAction(
///       icon: CNSymbol('gear'),
///       onPressed: () => print('Settings'),
///     ),
///     BaseNavigationBarAction(
///       icon: CNSymbol('plus'),
///       onPressed: () => print('Add'),
///     ),
///   ],
///   tint: CupertinoColors.label,
///   transparent: false,
///   largeTitle: false,
/// )
/// ```
///
/// For segmented control, add the following parameters:
/// ```dart
/// BaseNavigationBar(
///   title: 'Native Nav Bar',
///   titleSize: 20,
///   onTitlePressed: () => print('Title tapped!'),
///   segmentedControlLabels: ['Notifications', 'Buddy Requests'],
///   segmentedControlSelectedIndex: _selectedIndex,
///   onSegmentedControlValueChanged: (index) {
///     setState(() => _selectedIndex = index);
///   },
///   segmentedControlHeight: 40,
///   segmentedControlTint: CupertinoColors.white,
///   trailing: [
///     BaseNavigationBarAction(
///       icon: CNSymbol('gear'),
///       onPressed: () => print('Settings'),
///     ),
///   ],
/// )
/// ```
///
/// For search functionality, use the factory constructor:
/// ```dart
/// BaseNavigationBar.search(
///   leading: [
///     BaseNavigationBarAction(icon: CNSymbol('chevron.left'), onPressed: () {}),
///   ],
///   trailing: [
///     BaseNavigationBarAction(icon: CNSymbol('ellipsis.circle'), onPressed: () {}),
///   ],
///   searchConfig: CNSearchConfig(
///     placeholder: 'Search',
///     onSearchTextChanged: (text) => print(text),
///     resultsBuilder: (context, text) => SearchResults(text),
///   ),
/// )
/// ```
///
/// Available action types:
/// - `BaseNavigationBarAction()` - Regular action with icon/label
/// - `BaseNavigationBarAction.fixedSpace(5)` - Fixed spacing
/// - `BaseNavigationBarAction.flexibleSpace()` - Flexible spacing
///
/// ## Forcing Rebuild/Refresh
///
/// Since BaseNavigationBar is a StatelessWidget, it rebuilds when its parent rebuilds.
/// To force a rebuild when the navigation bar's state changes, use one of these methods:
///
/// **Method 1: Change the Key (Recommended)**
/// ```dart
/// class MyWidget extends StatefulWidget {
///   @override
///   State<MyWidget> createState() => _MyWidgetState();
/// }
///
/// class _MyWidgetState extends State<MyWidget> {
///   int _refreshKey = 0;
///   List<BaseNavigationBarAction> _actions = [...];
///
///   void updateActions() {
///     setState(() {
///       _actions = [...]; // Update actions
///       _refreshKey++; // Increment key to force rebuild
///     });
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return BaseNavigationBar(
///       key: ValueKey(_refreshKey), // Or use BaseNavigationBar.refreshKey()
///       trailing: _actions,
///       // ...
///     );
///   }
/// }
/// ```
///
/// **Method 2: Use UniqueKey for Each Rebuild**
/// ```dart
/// BaseNavigationBar(
///   key: UniqueKey(), // Creates new key on every build
///   // ...
/// )
/// ```
///
/// **Method 3: Use the Static Helper**
/// ```dart
/// BaseNavigationBar(
///   key: BaseNavigationBar.refreshKey(), // Generates unique key
///   // ...
/// )
/// ```
///
/// Updated: 2024.10.25 - Refactored to use BaseNavigationBarAction in public API
/// Updated: 2024.10.30 - Added refresh documentation and helper methods
class BaseNavigationBar extends BaseStatelessWidget {
  const BaseNavigationBar({
    Key? key,
    this.leading,
    this.title,
    this.trailing,
    this.tint,
    this.transparent = false,
    this.largeTitle = false,
    this.height,
    this.titleSize,
    this.onTitlePressed,
    this.searchConfig,
    this.segmentedControlLabels,
    this.segmentedControlSelectedIndex,
    this.onSegmentedControlValueChanged,
    this.segmentedControlHeight,
    this.segmentedControlTint,
    this.segmentedControlLabelSize,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// Creates a unique key for forcing widget rebuild
  ///
  /// Use this when you need to force the navigation bar to rebuild,
  /// for example when actions are updated dynamically.
  ///
  /// Example:
  /// ```dart
  /// BaseNavigationBar(
  ///   key: BaseNavigationBar.refreshKey(),
  ///   trailing: _dynamicActions,
  /// )
  /// ```
  static Key refreshKey() => UniqueKey();

  /// Factory constructor for search-enabled navigation bar
  const BaseNavigationBar.search({
    Key? key,
    List<BaseNavigationBarAction>? leading,
    List<BaseNavigationBarAction>? trailing,
    required CNSearchConfig searchConfig,
    Color? tint,
    bool transparent = false,
    bool largeTitle = false,
    double? height,
    double? titleSize,
    VoidCallback? onTitlePressed,
    BaseParam? baseParam,
  }) : this(
          key: key,
          leading: leading,
          trailing: trailing,
          searchConfig: searchConfig,
          tint: tint,
          transparent: transparent,
          largeTitle: largeTitle,
          height: height,
          titleSize: titleSize,
          onTitlePressed: onTitlePressed,
          baseParam: baseParam,
        );

  /// Leading navigation actions
  final List<BaseNavigationBarAction>? leading;

  /// Navigation bar title
  final String? title;

  /// Trailing navigation actions
  final List<BaseNavigationBarAction>? trailing;

  /// Tint color for icons and text
  final Color? tint;

  /// Whether the navigation bar should be transparent
  final bool transparent;

  /// Whether to use large title style
  final bool largeTitle;

  /// Custom height for the navigation bar
  final double? height;

  /// Title text size
  final double? titleSize;

  /// Callback when title is tapped
  final VoidCallback? onTitlePressed;

  /// Search configuration for search-enabled navigation bar
  final CNSearchConfig? searchConfig;

  /// Labels for segmented control (iOS native)
  /// When provided, displays a segmented control below the navigation bar
  final List<String>? segmentedControlLabels;

  /// Selected index for segmented control (iOS native)
  final int? segmentedControlSelectedIndex;

  /// Callback when segmented control value changes (iOS native)
  final ValueChanged<int>? onSegmentedControlValueChanged;

  /// Custom height for segmented control (iOS native)
  final double? segmentedControlHeight;

  /// Tint color for segmented control (iOS native)
  final Color? segmentedControlTint;

  /// Label size for segmented control text (iOS native)
  final double? segmentedControlLabelSize;

  @override
  Widget buildByCupertino(BuildContext context) {
    // Convert BaseNavigationBarAction to CNNavigationBarAction for iOS
    final leadingActions = valueOf('leading', leading);
    final trailingActions = valueOf('trailing', trailing);

    List<CNNavigationBarAction>? cnLeading;
    List<CNNavigationBarAction>? cnTrailing;

    if (leadingActions != null) {
      cnLeading = (leadingActions as List)
          .map((action) =>
              (action as BaseNavigationBarAction).toCNNavigationBarAction())
          .toList();
    }

    if (trailingActions != null) {
      cnTrailing = (trailingActions as List)
          .map((action) =>
              (action as BaseNavigationBarAction).toCNNavigationBarAction())
          .toList();
    }

    // Check if this is a search navigation bar
    final searchConf = valueOf('searchConfig', searchConfig);
    if (searchConf != null) {
      return CNNavigationBar.search(
        leading: cnLeading,
        trailing: cnTrailing,
        searchConfig: searchConf,
        tint: valueOf('tint', tint),
        transparent: valueOf('transparent', transparent),
        largeTitle: valueOf('largeTitle', largeTitle),
        height: valueOf('height', height),
        titleSize: valueOf('titleSize', titleSize),
        onTitlePressed: valueOf('onTitlePressed', onTitlePressed),
      );
    }

    return CNNavigationBar(
      leading: cnLeading,
      title: valueOf('title', title),
      trailing: cnTrailing,
      tint: valueOf('tint', tint),
      transparent: valueOf('transparent', transparent),
      largeTitle: valueOf('largeTitle', largeTitle),
      height: valueOf('height', height),
      titleSize: valueOf('titleSize', titleSize),
      onTitlePressed: valueOf('onTitlePressed', onTitlePressed),
      segmentedControlLabels:
          valueOf('segmentedControlLabels', segmentedControlLabels),
      segmentedControlSelectedIndex: valueOf(
          'segmentedControlSelectedIndex', segmentedControlSelectedIndex),
      onSegmentedControlValueChanged: valueOf(
          'onSegmentedControlValueChanged', onSegmentedControlValueChanged),
      segmentedControlHeight:
          valueOf('segmentedControlHeight', segmentedControlHeight),
      segmentedControlTint:
          valueOf('segmentedControlTint', segmentedControlTint),
      segmentedControlLabelSize:
          valueOf('segmentedControlLabelSize', segmentedControlLabelSize),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = valueOf('tint', tint) ?? theme.colorScheme.primary;
    final textColor = valueOf('tint', tint) ?? theme.colorScheme.onSurface;

    // Check if this is a search navigation bar
    final searchConf = valueOf('searchConfig', searchConfig);
    if (searchConf != null) {
      return _buildMaterialSearchNavBar(
          context, theme, iconColor, textColor, searchConf);
    }

    return Container(
      height: valueOf('height', height) ??
          (valueOf('largeTitle', largeTitle) ? 96 : 56),
      decoration: valueOf('transparent', transparent)
          ? null
          : BoxDecoration(
              color: theme.appBarTheme.backgroundColor ??
                  theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: valueOf('largeTitle', largeTitle)
              ? _buildLargeTitleLayout(textColor, iconColor)
              : _buildRegularLayout(textColor, iconColor),
        ),
      ),
    );
  }

  /// Build Material search navigation bar
  Widget _buildMaterialSearchNavBar(
    BuildContext context,
    ThemeData theme,
    Color iconColor,
    Color textColor,
    CNSearchConfig searchConfig,
  ) {
    return Container(
      height: valueOf('height', height) ?? 56,
      decoration: valueOf('transparent', transparent)
          ? null
          : BoxDecoration(
              color: theme.appBarTheme.backgroundColor ??
                  theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Leading actions
              if (valueOf('leading', leading) != null) ...[
                ..._buildMaterialActions(
                    valueOf('leading', leading)!, iconColor),
                const SizedBox(width: 12),
              ],

              // Search field
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: searchConfig.onSearchTextChanged,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: searchConfig.placeholder,
                      hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      prefixIcon: Icon(Icons.search,
                          color: iconColor.withOpacity(0.7), size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ),

              // Trailing actions
              if (valueOf('trailing', trailing) != null) ...[
                const SizedBox(width: 12),
                ..._buildMaterialActions(
                    valueOf('trailing', trailing)!, iconColor),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeTitleLayout(Color textColor, Color iconColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row with actions
        SizedBox(
          height: 44,
          child: Row(
            children: [
              if (valueOf('leading', leading) != null) ...[
                ..._buildMaterialActions(
                    valueOf('leading', leading)!, iconColor),
                const Spacer(),
              ] else
                const Spacer(),
              if (valueOf('trailing', trailing) != null)
                ..._buildMaterialActions(
                    valueOf('trailing', trailing)!, iconColor),
            ],
          ),
        ),
        // Large title
        if (valueOf('title', title) != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              valueOf('title', title)!,
              style: TextStyle(
                color: textColor,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRegularLayout(Color textColor, Color iconColor) {
    return Row(
      children: [
        // Leading actions
        if (valueOf('leading', leading) != null) ...[
          ..._buildMaterialActions(valueOf('leading', leading)!, iconColor),
          const SizedBox(width: 12),
        ],

        // Title
        if (valueOf('title', title) != null)
          Expanded(
            child: Text(
              valueOf('title', title)!,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          const Spacer(),

        // Trailing actions
        if (valueOf('trailing', trailing) != null) ...[
          const SizedBox(width: 12),
          ..._buildMaterialActions(valueOf('trailing', trailing)!, iconColor),
        ],
      ],
    );
  }

  List<Widget> _buildMaterialActions(
      List<BaseNavigationBarAction> actions, Color iconColor) {
    return actions.map((action) {
      // Handle special action types
      if (action.isFixedSpace) {
        // This is a fixed space action
        return SizedBox(width: action.spaceWidth ?? 8);
      }

      if (action.isFlexibleSpace) {
        // This is a flexible space action
        return const Expanded(child: SizedBox());
      }

      // Use custom tint color if provided, otherwise use default iconColor
      final actionColor = action.tint ?? iconColor;

      // Custom image action
      if (action.isImageAction) {
        final Image img = Image.asset(
          action._materialImage!,
          width: action._imageWidth ?? 24.0,
          height: action._imageHeight ?? 24.0,
        );
        if (action.label != null) {
          return GestureDetector(
            onTap: action.onPressed,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                img,
                Text(
                  action.label!,
                  style: TextStyle(color: actionColor, fontSize: 10),
                ),
              ],
            ),
          );
        }
        return GestureDetector(
          onTap: action.onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: img,
          ),
        );
      }

      // Regular action with icon/label
      if (action.icon != null && action.label != null) {
        // Both icon and label
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: action.onPressed,
              icon: _buildMaterialIcon(action.icon!),
              color: actionColor,
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            Text(
              action.label!,
              style: TextStyle(color: actionColor, fontSize: 10),
            ),
          ],
        );
      } else if (action.icon != null) {
        // Icon only
        return IconButton(
          onPressed: action.onPressed,
          icon: _buildMaterialIcon(action.icon!),
          color: actionColor,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        );
      } else if (action.label != null) {
        // Label only
        return TextButton(
          onPressed: action.onPressed,
          child: Text(action.label!, style: TextStyle(color: actionColor)),
        );
      }

      return const SizedBox.shrink();
    }).toList();
  }

  Widget _buildMaterialIcon(CNSymbol symbol) {
    // Map SF Symbol to Material icon
    final iconData = _mapSFSymbolToMaterialIcon(symbol.name);
    return Icon(iconData, size: symbol.size);
  }

  IconData _mapSFSymbolToMaterialIcon(String sfSymbol) {
    final Map<String, IconData> iconMap = {
      // Navigation
      'chevron.left': Icons.chevron_left,
      'chevron.right': Icons.chevron_right,
      'chevron.up': Icons.keyboard_arrow_up,
      'chevron.down': Icons.keyboard_arrow_down,
      'arrow.left': Icons.arrow_back,
      'arrow.right': Icons.arrow_forward,
      'arrow.up.left': Icons.north_west,
      'arrow.down.right': Icons.south_east,

      // Common Actions
      'plus': Icons.add,
      'plus.circle': Icons.add_circle,
      'plus.circle.fill': Icons.add_circle,
      'minus': Icons.remove,
      'minus.circle': Icons.remove_circle,
      'xmark': Icons.close,
      'xmark.circle': Icons.cancel,
      'checkmark': Icons.check,
      'checkmark.circle': Icons.check_circle,

      // Settings
      'gear': Icons.settings,
      'gearshape': Icons.settings,
      'gearshape.fill': Icons.settings,
      'slider.horizontal.3': Icons.tune,
      'slider.horizontal': Icons.tune,

      // Menu & Navigation
      'ellipsis': Icons.more_horiz,
      'ellipsis.circle': Icons.more_vert,
      'apps': Icons.apps,
      'apps.iphone': Icons.apps,

      // Favorites & Interactions
      'star': Icons.star_border,
      'star.fill': Icons.star,
      'heart': Icons.favorite_border,
      'heart.fill': Icons.favorite,
      'bookmark': Icons.bookmark_border,
      'bookmark.fill': Icons.bookmark,

      // Search & Find
      'magnifyingglass': Icons.search,
      'magnifyingglass.circle': Icons.search,

      // Home & Places
      'house': Icons.home,
      'house.fill': Icons.home,
      'building.2': Icons.apartment,
      'location': Icons.location_on,
      'location.circle': Icons.location_on,
      'location.fill': Icons.location_on,

      // Communication
      'envelope': Icons.email,
      'envelope.open': Icons.mail_outline,
      'phone': Icons.phone,
      'phone.fill': Icons.phone,
      'message': Icons.message,
      'message.circle': Icons.chat_bubble,
      'bell': Icons.notifications,
      'bell.fill': Icons.notifications_active,
      'bell.badge': Icons.notifications_active,

      // Media
      'camera': Icons.camera_alt,
      'camera.fill': Icons.camera_alt,
      'photo': Icons.photo,
      'photo.on.rectangle': Icons.image,
      'photo.fill': Icons.image,
      'video': Icons.videocam,
      'video.fill': Icons.videocam,
      'music.note': Icons.music_note,
      'music.note.list': Icons.playlist_play,

      // Files & Folders
      'doc': Icons.insert_drive_file,
      'doc.on.doc': Icons.content_copy,
      'doc.circle': Icons.insert_drive_file,
      'folder': Icons.folder,
      'folder.fill': Icons.folder,
      'folder.badge.plus': Icons.create_new_folder,

      // Edit & Text
      'pencil': Icons.edit,
      'pencil.circle': Icons.edit,
      'pencil.circle.fill': Icons.edit,
      'trash': Icons.delete,
      'trash.circle': Icons.delete_outline,
      'trash.circle.fill': Icons.delete,
      'bold': Icons.format_bold,
      'italic': Icons.format_italic,
      'underline': Icons.format_underlined,
      'strikethrough': Icons.strikethrough_s,
      'textformat.size': Icons.text_fields,
      'textformat': Icons.text_fields,

      // Grid & Layout
      'square.grid.2x2': Icons.grid_view,
      'square.grid.3x2': Icons.grid_on,
      'list.bullet': Icons.list,
      'list.number': Icons.format_list_numbered,

      // Links & Sharing
      'link': Icons.link,
      'link.circle': Icons.link,
      'paperclip': Icons.attach_file,
      'square.and.arrow.up': Icons.share,
      'square.and.arrow.down': Icons.download,

      // Time & Date
      'clock': Icons.schedule,
      'clock.fill': Icons.access_time,
      'calendar': Icons.calendar_today,
      'calendar.circle': Icons.calendar_today,

      // User & Account
      'person': Icons.person,
      'person.fill': Icons.person,
      'person.circle': Icons.account_circle,
      'person.circle.fill': Icons.account_circle,
      'people': Icons.group,
      'people.fill': Icons.group,

      // Miscellaneous
      'paintpalette': Icons.palette,
      'paintpalette.fill': Icons.palette,
      'hand.raised': Icons.pan_tool,
      'sun.max': Icons.wb_sunny,
      'sun.max.fill': Icons.wb_sunny,
      'moon': Icons.brightness_2,
      'moon.fill': Icons.brightness_2,
    };
    return iconMap[sfSymbol] ?? Icons.circle;
  }
}
