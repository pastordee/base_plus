// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseBottomToolbar - Cross-platform bottom toolbar with expandable search
/// 
/// Provides native iOS bottom toolbar with expandable search with fallback to Material Design
/// bottom app bar on other platforms. The iOS version provides a native toolbar experience
/// with smooth animations and Apple HIG compliance.
/// 
/// Features:
/// - Native iOS bottom toolbar with expandable search
/// - Material Design fallback with similar functionality
/// - Consistent API across platforms
/// - Apple HIG compliant search behavior
/// - Context-aware icon display during search
/// - Smooth animations for search expansion
/// 
/// Apple HIG implementation:
/// - Search in a bottom toolbar pattern
/// - Expandable search that shows current context
/// - Proper visual hierarchy and spacing
/// - Platform-appropriate animations and behaviors
/// 
/// Updated: 2024.10.25
/// 
/// Example:
/// ```dart
/// BaseBottomToolbar(
///   leadingAction: CupertinoButton(
///     child: Icon(CupertinoIcons.line_horizontal_3),
///     onPressed: () => showMenu(),
///   ),
///   searchPlaceholder: 'Search',
///   onSearchChanged: (text) => updateResults(text),
///   trailingAction: CupertinoButton(
///     child: Icon(CupertinoIcons.square_pencil),
///     onPressed: () => compose(),
///   ),
///   currentTabIcon: CupertinoIcons.house_fill,
///   currentTabLabel: 'Home',
/// )
/// ```
class BaseBottomToolbar extends BaseStatelessWidget {
  const BaseBottomToolbar({
    Key? key,
    this.leadingAction,
    this.trailingAction,
    this.searchPlaceholder = 'Search',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchFocusChanged,
    this.currentTabIcon,
    this.currentTabLabel,
    this.height = 50.0,
    this.backgroundColor,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// Optional leading button (e.g., menu, filter)
  final Widget? leadingAction;

  /// Optional trailing button (e.g., compose, add)
  final Widget? trailingAction;

  /// Placeholder text for the search field
  final String searchPlaceholder;

  /// Called when search text changes
  final ValueChanged<String>? onSearchChanged;

  /// Called when search is submitted
  final ValueChanged<String>? onSearchSubmitted;

  /// Called when search field gains/loses focus
  final ValueChanged<bool>? onSearchFocusChanged;

  /// Icon to show when search is expanded (current tab context)
  final IconData? currentTabIcon;

  /// Label to show when search is expanded (current tab context)
  final String? currentTabLabel;

  /// Toolbar height
  final double height;

  /// Background color
  final Color? backgroundColor;

  @override
  Widget buildByCupertino(BuildContext context) {
    return _CNBottomToolbarCupertino(
      leadingAction: leadingAction,
      trailingAction: trailingAction,
      searchPlaceholder: searchPlaceholder,
      onSearchChanged: onSearchChanged,
      onSearchSubmitted: onSearchSubmitted,
      onSearchFocusChanged: onSearchFocusChanged,
      currentTabIcon: currentTabIcon,
      currentTabLabel: currentTabLabel,
      height: height,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    return _CNBottomToolbarMaterial(
      leadingAction: leadingAction,
      trailingAction: trailingAction,
      searchPlaceholder: searchPlaceholder,
      onSearchChanged: onSearchChanged,
      onSearchSubmitted: onSearchSubmitted,
      onSearchFocusChanged: onSearchFocusChanged,
      currentTabIcon: currentTabIcon,
      currentTabLabel: currentTabLabel,
      height: height,
      backgroundColor: backgroundColor,
    );
  }
}

/// Cupertino implementation of the bottom toolbar
class _CNBottomToolbarCupertino extends StatefulWidget {
  const _CNBottomToolbarCupertino({
    this.leadingAction,
    this.trailingAction,
    this.searchPlaceholder = 'Search',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchFocusChanged,
    this.currentTabIcon,
    this.currentTabLabel,
    this.height = 50.0,
    this.backgroundColor,
  });

  final Widget? leadingAction;
  final Widget? trailingAction;
  final String searchPlaceholder;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final ValueChanged<bool>? onSearchFocusChanged;
  final IconData? currentTabIcon;
  final String? currentTabLabel;
  final double height;
  final Color? backgroundColor;

  @override
  State<_CNBottomToolbarCupertino> createState() => _CNBottomToolbarCupertinoState();
}

class _CNBottomToolbarCupertinoState extends State<_CNBottomToolbarCupertino> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _searchExpandAnimation;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchExpandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isSearchExpanded = _focusNode.hasFocus;
    });
    
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    
    widget.onSearchFocusChanged?.call(_focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? 
        CupertinoTheme.of(context).barBackgroundColor;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 0.5,
          ),
        ),
      ),
      child: AnimatedBuilder(
        animation: _searchExpandAnimation,
        builder: (context, child) {
          return Row(
            children: [
              // Leading: Menu button OR current tab icon when expanded
              _buildLeadingArea(),
              
              // Search field (expands when focused)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: CupertinoSearchTextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    placeholder: widget.searchPlaceholder,
                    onChanged: widget.onSearchChanged,
                    onSubmitted: widget.onSearchSubmitted,
                    backgroundColor: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                  ),
                ),
              ),
              
              // Trailing button (fades out when search expands)
              if (widget.trailingAction != null)
                Opacity(
                  opacity: 1.0 - (_searchExpandAnimation.value * 0.5),
                  child: _buildTrailingButton(),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeadingArea() {
    if (_isSearchExpanded && widget.currentTabIcon != null) {
      // Show current tab icon when search is expanded
      return Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.currentTabIcon,
              size: 24,
              color: CupertinoColors.systemBlue.resolveFrom(context),
            ),
            if (widget.currentTabLabel != null) ...[
              const SizedBox(height: 2),
              Text(
                widget.currentTabLabel!,
                style: TextStyle(
                  fontSize: 10,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Show leading button when not searching
    if (widget.leadingAction != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: SizedBox(
          width: 44,
          height: 44,
          child: widget.leadingAction!,
        ),
      );
    }

    return const SizedBox(width: 8);
  }

  Widget _buildTrailingButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: 44,
        height: 44,
        child: widget.trailingAction!,
      ),
    );
  }
}

/// Material implementation of the bottom toolbar
class _CNBottomToolbarMaterial extends StatefulWidget {
  const _CNBottomToolbarMaterial({
    this.leadingAction,
    this.trailingAction,
    this.searchPlaceholder = 'Search',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchFocusChanged,
    this.currentTabIcon,
    this.currentTabLabel,
    this.height = 50.0,
    this.backgroundColor,
  });

  final Widget? leadingAction;
  final Widget? trailingAction;
  final String searchPlaceholder;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final ValueChanged<bool>? onSearchFocusChanged;
  final IconData? currentTabIcon;
  final String? currentTabLabel;
  final double height;
  final Color? backgroundColor;

  @override
  State<_CNBottomToolbarMaterial> createState() => _CNBottomToolbarMaterialState();
}

class _CNBottomToolbarMaterialState extends State<_CNBottomToolbarMaterial> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _searchExpandAnimation;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchExpandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isSearchExpanded = _focusNode.hasFocus;
    });
    
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    
    widget.onSearchFocusChanged?.call(_focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? 
        theme.bottomAppBarTheme.color ?? 
        theme.colorScheme.surface;

    return Material(
      color: backgroundColor,
      elevation: 8.0,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.dividerColor,
              width: 1.0,
            ),
          ),
        ),
        child: AnimatedBuilder(
          animation: _searchExpandAnimation,
          builder: (context, child) {
            return Row(
              children: [
                // Leading: Menu button OR current tab icon when expanded
                _buildLeadingArea(),
                
                // Search field (expands when focused)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      onChanged: widget.onSearchChanged,
                      onSubmitted: widget.onSearchSubmitted,
                      decoration: InputDecoration(
                        hintText: widget.searchPlaceholder,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _textController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _textController.clear();
                                widget.onSearchChanged?.call('');
                              },
                            )
                          : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.onSurface.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Trailing button (fades out when search expands)
                if (widget.trailingAction != null)
                  Opacity(
                    opacity: 1.0 - (_searchExpandAnimation.value * 0.5),
                    child: _buildTrailingButton(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeadingArea() {
    if (_isSearchExpanded && widget.currentTabIcon != null) {
      // Show current tab icon when search is expanded
      return Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.currentTabIcon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            if (widget.currentTabLabel != null) ...[
              const SizedBox(height: 2),
              Text(
                widget.currentTabLabel!,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Show leading button when not searching
    if (widget.leadingAction != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: SizedBox(
          width: 44,
          height: 44,
          child: widget.leadingAction!,
        ),
      );
    }

    return const SizedBox(width: 8);
  }

  Widget _buildTrailingButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: 44,
        height: 44,
        child: widget.trailingAction!,
      ),
    );
  }
}

/// Legacy CNBottomToolbar class for backward compatibility
/// 
/// This maintains the original API while delegating to BaseBottomToolbar
/// for actual implementation.
class CNBottomToolbar extends StatefulWidget {
  /// Creates a bottom toolbar with expandable search.
  const CNBottomToolbar({
    super.key,
    this.leadingAction,
    this.trailingAction,
    this.searchPlaceholder = 'Search',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchFocusChanged,
    this.currentTabIcon,
    this.currentTabLabel,
    this.height = 50.0,
    this.backgroundColor,
  });

  /// Optional leading button (e.g., menu, filter)
  final Widget? leadingAction;

  /// Optional trailing button (e.g., compose, add)
  final Widget? trailingAction;

  /// Placeholder text for the search field
  final String searchPlaceholder;

  /// Called when search text changes
  final ValueChanged<String>? onSearchChanged;

  /// Called when search is submitted
  final ValueChanged<String>? onSearchSubmitted;

  /// Called when search field gains/loses focus
  final ValueChanged<bool>? onSearchFocusChanged;

  /// Icon to show when search is expanded (current tab context)
  final IconData? currentTabIcon;

  /// Label to show when search is expanded (current tab context)
  final String? currentTabLabel;

  /// Toolbar height
  final double height;

  /// Background color
  final Color? backgroundColor;

  @override
  State<CNBottomToolbar> createState() => _CNBottomToolbarState();
}

class _CNBottomToolbarState extends State<CNBottomToolbar> {
  @override
  Widget build(BuildContext context) {
    return BaseBottomToolbar(
      leadingAction: widget.leadingAction,
      trailingAction: widget.trailingAction,
      searchPlaceholder: widget.searchPlaceholder,
      onSearchChanged: widget.onSearchChanged,
      onSearchSubmitted: widget.onSearchSubmitted,
      onSearchFocusChanged: widget.onSearchFocusChanged,
      currentTabIcon: widget.currentTabIcon,
      currentTabLabel: widget.currentTabLabel,
      height: widget.height,
      backgroundColor: widget.backgroundColor,
    );
  }
}