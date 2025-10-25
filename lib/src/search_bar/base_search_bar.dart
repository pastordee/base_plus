// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// Search bar visual style
enum CNSearchBarStyle {
  /// Default search bar style
  defaultStyle,

  /// Prominent search bar style
  prominent,

  /// Minimal search bar style
  minimal,
}

/// Keyboard type
enum CNKeyboardType {
  /// Default keyboard
  defaultType,

  /// ASCII keyboard
  asciiCapable,

  /// Number and punctuation keyboard
  numbersAndPunctuation,

  /// URL keyboard
  url,

  /// Number pad
  numberPad,

  /// Phone pad
  phonePad,

  /// Name and phone pad
  namePhonePad,

  /// Email keyboard
  emailAddress,

  /// Decimal pad
  decimalPad,

  /// Twitter keyboard
  twitter,

  /// Web search keyboard
  webSearch,

  /// ASCII capable number pad
  asciiCapableNumberPad,
}

/// Keyboard appearance
enum CNKeyboardAppearance {
  /// Default appearance
  defaultAppearance,

  /// Light keyboard
  light,

  /// Dark keyboard
  dark,
}

/// Return key type
enum CNReturnKeyType {
  /// Default return key
  defaultType,

  /// Go
  go,

  /// Google
  google,

  /// Join
  join,

  /// Next
  next,

  /// Route
  route,

  /// Search
  search,

  /// Send
  send,

  /// Yahoo
  yahoo,

  /// Done
  done,

  /// Emergency call
  emergencyCall,

  /// Continue
  continueType,
}

/// Auto-capitalization type
enum CNAutocapitalizationType {
  /// No auto-capitalization
  none,

  /// Capitalize words
  words,

  /// Capitalize sentences
  sentences,

  /// Capitalize all characters
  allCharacters,
}

/// Auto-correction type
enum CNAutocorrectionType {
  /// Default behavior
  defaultType,

  /// Disable auto-correction
  no,

  /// Enable auto-correction
  yes,
}

/// Spell checking type
enum CNSpellCheckingType {
  /// Default behavior
  defaultType,

  /// Disable spell checking
  no,

  /// Enable spell checking
  yes,
}

/// BaseSearchBar - Cross-platform search bar with native iOS support
/// 
/// Uses native iOS UISearchBar via platform channels for iOS - provides authentic
/// iOS search experience with scope bars and advanced keyboard configuration.
/// Uses Material Design SearchBar for Android and other platforms.
/// 
/// *** use cupertino = { forceUseMaterial: true } force use Material search on iOS
/// *** use material = { forceUseCupertino: true } force use native iOS search on Android
///
/// Features:
/// - Native iOS UISearchBar rendering via platform channels
/// - Material Design SearchBar for Android
/// - Consistent API across platforms
/// - Apple HIG compliant search behavior
/// - Scope bar support for filtering
/// - Advanced keyboard and input configuration
/// - Authentic iOS styling and animations
/// - Cancel button with native iOS behavior
/// 
/// Apple HIG implementation:
/// - Descriptive placeholder text support
/// - Search bar styles (default, prominent, minimal)
/// - Show/hide cancel button behavior
/// - Voice search button (iOS 14+)
/// - Proper keyboard types and appearance
/// - Scope bar for content filtering
/// 
/// Example:
/// ```dart
/// BaseSearchBar(
///   placeholder: 'Shows, Movies, and More',
///   showsCancelButton: true,
///   showsScopeBar: true,
///   scopeButtonTitles: ['All', 'Movies', 'TV Shows'],
///   selectedScopeIndex: 0,
///   onTextChanged: (text) => performSearch(text),
///   onSearchButtonClicked: (text) => submitSearch(text),
/// )
/// ```
/// 
/// Updated: 2024.10.25 - Renamed from BaseCNSearchBar for consistency
class BaseSearchBar extends BaseStatelessWidget {
  /// Creates a native iOS search bar.
  const BaseSearchBar({
    Key? key,
    this.placeholder,
    this.text,
    this.prompt,
    this.showsCancelButton = false,
    this.showsBookmarkButton = false,
    this.showsSearchResultsButton = false,
    this.searchBarStyle = CNSearchBarStyle.defaultStyle,
    this.barTintColor,
    this.tintColor,
    this.searchFieldBackgroundColor,
    this.showsScopeBar = false,
    this.scopeButtonTitles = const [],
    this.selectedScopeIndex = 0,
    this.keyboardType = CNKeyboardType.defaultType,
    this.keyboardAppearance = CNKeyboardAppearance.defaultAppearance,
    this.returnKeyType = CNReturnKeyType.search,
    this.enablesReturnKeyAutomatically = true,
    this.autocapitalizationType = CNAutocapitalizationType.none,
    this.autocorrectionType = CNAutocorrectionType.defaultType,
    this.spellCheckingType = CNSpellCheckingType.defaultType,
    this.onTextChanged,
    this.onSearchButtonClicked,
    this.onCancelButtonClicked,
    this.onScopeChanged,
    this.onBookmarkButtonClicked,
    this.height = 56.0,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// Placeholder text (e.g., "Shows, Movies, and More")
  final String? placeholder;

  /// Initial search text
  final String? text;

  /// Prompt text displayed above the search bar
  final String? prompt;

  /// Whether to show the cancel button
  final bool showsCancelButton;

  /// Whether to show the bookmark button
  final bool showsBookmarkButton;

  /// Whether to show the search results button
  final bool showsSearchResultsButton;

  /// Visual style of the search bar
  final CNSearchBarStyle searchBarStyle;

  /// Background tint color for the search bar
  final Color? barTintColor;

  /// Tint color for search bar elements
  final Color? tintColor;

  /// Background color for the search text field
  final Color? searchFieldBackgroundColor;

  /// Whether to show the scope bar
  final bool showsScopeBar;

  /// Titles for scope bar buttons
  final List<String> scopeButtonTitles;

  /// Selected scope bar index
  final int selectedScopeIndex;

  /// Keyboard type
  final CNKeyboardType keyboardType;

  /// Keyboard appearance (light/dark)
  final CNKeyboardAppearance keyboardAppearance;

  /// Return key type
  final CNReturnKeyType returnKeyType;

  /// Whether return key is enabled only when there's text
  final bool enablesReturnKeyAutomatically;

  /// Auto-capitalization behavior
  final CNAutocapitalizationType autocapitalizationType;

  /// Auto-correction behavior
  final CNAutocorrectionType autocorrectionType;

  /// Spell checking behavior
  final CNSpellCheckingType spellCheckingType;

  /// Called when search text changes
  final ValueChanged<String>? onTextChanged;

  /// Called when search button is clicked
  final ValueChanged<String>? onSearchButtonClicked;

  /// Called when cancel button is clicked
  final VoidCallback? onCancelButtonClicked;

  /// Called when scope selection changes
  final ValueChanged<int>? onScopeChanged;

  /// Called when bookmark button is clicked
  final VoidCallback? onBookmarkButtonClicked;

  /// Height of the search bar
  final double height;

  @override
  Widget buildByCupertino(BuildContext context) {
    return _CNSearchBarCupertino(
      placeholder: placeholder,
      text: text,
      prompt: prompt,
      showsCancelButton: showsCancelButton,
      showsBookmarkButton: showsBookmarkButton,
      showsSearchResultsButton: showsSearchResultsButton,
      searchBarStyle: searchBarStyle,
      barTintColor: barTintColor,
      tintColor: tintColor,
      searchFieldBackgroundColor: searchFieldBackgroundColor,
      showsScopeBar: showsScopeBar,
      scopeButtonTitles: scopeButtonTitles,
      selectedScopeIndex: selectedScopeIndex,
      keyboardType: keyboardType,
      keyboardAppearance: keyboardAppearance,
      returnKeyType: returnKeyType,
      enablesReturnKeyAutomatically: enablesReturnKeyAutomatically,
      autocapitalizationType: autocapitalizationType,
      autocorrectionType: autocorrectionType,
      spellCheckingType: spellCheckingType,
      onTextChanged: onTextChanged,
      onSearchButtonClicked: onSearchButtonClicked,
      onCancelButtonClicked: onCancelButtonClicked,
      onScopeChanged: onScopeChanged,
      onBookmarkButtonClicked: onBookmarkButtonClicked,
      height: height,
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    return _CNSearchBarMaterial(
      placeholder: placeholder,
      text: text,
      prompt: prompt,
      showsCancelButton: showsCancelButton,
      showsBookmarkButton: showsBookmarkButton,
      showsSearchResultsButton: showsSearchResultsButton,
      searchBarStyle: searchBarStyle,
      barTintColor: barTintColor,
      tintColor: tintColor,
      searchFieldBackgroundColor: searchFieldBackgroundColor,
      showsScopeBar: showsScopeBar,
      scopeButtonTitles: scopeButtonTitles,
      selectedScopeIndex: selectedScopeIndex,
      keyboardType: keyboardType,
      keyboardAppearance: keyboardAppearance,
      returnKeyType: returnKeyType,
      enablesReturnKeyAutomatically: enablesReturnKeyAutomatically,
      autocapitalizationType: autocapitalizationType,
      autocorrectionType: autocorrectionType,
      spellCheckingType: spellCheckingType,
      onTextChanged: onTextChanged,
      onSearchButtonClicked: onSearchButtonClicked,
      onCancelButtonClicked: onCancelButtonClicked,
      onScopeChanged: onScopeChanged,
      onBookmarkButtonClicked: onBookmarkButtonClicked,
      height: height,
    );
  }
}

/// Cupertino implementation using native UISearchBar
class _CNSearchBarCupertino extends StatefulWidget {
  const _CNSearchBarCupertino({
    this.placeholder,
    this.text,
    this.prompt,
    this.showsCancelButton = false,
    this.showsBookmarkButton = false,
    this.showsSearchResultsButton = false,
    this.searchBarStyle = CNSearchBarStyle.defaultStyle,
    this.barTintColor,
    this.tintColor,
    this.searchFieldBackgroundColor,
    this.showsScopeBar = false,
    this.scopeButtonTitles = const [],
    this.selectedScopeIndex = 0,
    this.keyboardType = CNKeyboardType.defaultType,
    this.keyboardAppearance = CNKeyboardAppearance.defaultAppearance,
    this.returnKeyType = CNReturnKeyType.search,
    this.enablesReturnKeyAutomatically = true,
    this.autocapitalizationType = CNAutocapitalizationType.none,
    this.autocorrectionType = CNAutocorrectionType.defaultType,
    this.spellCheckingType = CNSpellCheckingType.defaultType,
    this.onTextChanged,
    this.onSearchButtonClicked,
    this.onCancelButtonClicked,
    this.onScopeChanged,
    this.onBookmarkButtonClicked,
    this.height = 56.0,
  });

  final String? placeholder;
  final String? text;
  final String? prompt;
  final bool showsCancelButton;
  final bool showsBookmarkButton;
  final bool showsSearchResultsButton;
  final CNSearchBarStyle searchBarStyle;
  final Color? barTintColor;
  final Color? tintColor;
  final Color? searchFieldBackgroundColor;
  final bool showsScopeBar;
  final List<String> scopeButtonTitles;
  final int selectedScopeIndex;
  final CNKeyboardType keyboardType;
  final CNKeyboardAppearance keyboardAppearance;
  final CNReturnKeyType returnKeyType;
  final bool enablesReturnKeyAutomatically;
  final CNAutocapitalizationType autocapitalizationType;
  final CNAutocorrectionType autocorrectionType;
  final CNSpellCheckingType spellCheckingType;
  final ValueChanged<String>? onTextChanged;
  final ValueChanged<String>? onSearchButtonClicked;
  final VoidCallback? onCancelButtonClicked;
  final ValueChanged<int>? onScopeChanged;
  final VoidCallback? onBookmarkButtonClicked;
  final double height;

  @override
  State<_CNSearchBarCupertino> createState() => _CNSearchBarCupertinoState();
}

class _CNSearchBarCupertinoState extends State<_CNSearchBarCupertino> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = {
      'placeholder': widget.placeholder ?? 'Search',
      'text': widget.text ?? '',
      if (widget.prompt != null) 'prompt': widget.prompt,
      'showsCancelButton': widget.showsCancelButton,
      'showsBookmarkButton': widget.showsBookmarkButton,
      'showsSearchResultsButton': widget.showsSearchResultsButton,
      'searchBarStyle': widget.searchBarStyle.index,
      if (widget.barTintColor != null)
        'barTintColor': _colorToARGB(widget.barTintColor!),
      if (widget.tintColor != null) 'tintColor': _colorToARGB(widget.tintColor!),
      if (widget.searchFieldBackgroundColor != null)
        'searchFieldBackgroundColor': _colorToARGB(widget.searchFieldBackgroundColor!),
      'showsScopeBar': widget.showsScopeBar,
      'scopeButtonTitles': widget.scopeButtonTitles,
      'selectedScopeIndex': widget.selectedScopeIndex,
      'keyboardType': widget.keyboardType.index,
      'keyboardAppearance': widget.keyboardAppearance.index,
      'returnKeyType': widget.returnKeyType.index,
      'enablesReturnKeyAutomatically': widget.enablesReturnKeyAutomatically,
      'autocapitalizationType': widget.autocapitalizationType.index,
      'autocorrectionType': widget.autocorrectionType.index,
      'spellCheckingType': widget.spellCheckingType.index,
    };

    return SizedBox(
      height: widget.height + (widget.showsScopeBar ? 44.0 : 0.0),
      child: UiKitView(
        viewType: 'CupertinoNativeSearchBar',
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      ),
    );
  }

  void _onPlatformViewCreated(int viewId) {
    _channel = MethodChannel('CupertinoNativeSearchBar_$viewId');
    _channel!.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onTextChanged':
        final text = call.arguments as String;
        widget.onTextChanged?.call(text);
        break;
      case 'onSearchButtonClicked':
        final text = call.arguments as String;
        widget.onSearchButtonClicked?.call(text);
        break;
      case 'onCancelButtonClicked':
        widget.onCancelButtonClicked?.call();
        break;
      case 'onScopeChanged':
        final index = call.arguments as int;
        widget.onScopeChanged?.call(index);
        break;
      case 'onBookmarkButtonClicked':
        widget.onBookmarkButtonClicked?.call();
        break;
    }
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  /// Helper to convert Color to ARGB int
  int _colorToARGB(Color color) {
    return ((color.a * 255).round() << 24) |
        ((color.r * 255).round() << 16) |
        ((color.g * 255).round() << 8) |
        (color.b * 255).round();
  }
}

/// Material implementation of search bar
class _CNSearchBarMaterial extends StatefulWidget {
  const _CNSearchBarMaterial({
    this.placeholder,
    this.text,
    this.prompt,
    this.showsCancelButton = false,
    this.showsBookmarkButton = false,
    this.showsSearchResultsButton = false,
    this.searchBarStyle = CNSearchBarStyle.defaultStyle,
    this.barTintColor,
    this.tintColor,
    this.searchFieldBackgroundColor,
    this.showsScopeBar = false,
    this.scopeButtonTitles = const [],
    this.selectedScopeIndex = 0,
    this.keyboardType = CNKeyboardType.defaultType,
    this.keyboardAppearance = CNKeyboardAppearance.defaultAppearance,
    this.returnKeyType = CNReturnKeyType.search,
    this.enablesReturnKeyAutomatically = true,
    this.autocapitalizationType = CNAutocapitalizationType.none,
    this.autocorrectionType = CNAutocorrectionType.defaultType,
    this.spellCheckingType = CNSpellCheckingType.defaultType,
    this.onTextChanged,
    this.onSearchButtonClicked,
    this.onCancelButtonClicked,
    this.onScopeChanged,
    this.onBookmarkButtonClicked,
    this.height = 56.0,
  });

  final String? placeholder;
  final String? text;
  final String? prompt;
  final bool showsCancelButton;
  final bool showsBookmarkButton;
  final bool showsSearchResultsButton;
  final CNSearchBarStyle searchBarStyle;
  final Color? barTintColor;
  final Color? tintColor;
  final Color? searchFieldBackgroundColor;
  final bool showsScopeBar;
  final List<String> scopeButtonTitles;
  final int selectedScopeIndex;
  final CNKeyboardType keyboardType;
  final CNKeyboardAppearance keyboardAppearance;
  final CNReturnKeyType returnKeyType;
  final bool enablesReturnKeyAutomatically;
  final CNAutocapitalizationType autocapitalizationType;
  final CNAutocorrectionType autocorrectionType;
  final CNSpellCheckingType spellCheckingType;
  final ValueChanged<String>? onTextChanged;
  final ValueChanged<String>? onSearchButtonClicked;
  final VoidCallback? onCancelButtonClicked;
  final ValueChanged<int>? onScopeChanged;
  final VoidCallback? onBookmarkButtonClicked;
  final double height;

  @override
  State<_CNSearchBarMaterial> createState() => _CNSearchBarMaterialState();
}

class _CNSearchBarMaterialState extends State<_CNSearchBarMaterial> {
  late TextEditingController _controller;
  int _selectedScopeIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text ?? '');
    _selectedScopeIndex = widget.selectedScopeIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      height: widget.height + (widget.showsScopeBar ? 48.0 : 0.0),
      decoration: BoxDecoration(
        color: widget.barTintColor ?? theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          // Prompt text (if provided)
          if (widget.prompt != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                widget.prompt!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          
          // Main search bar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Bookmark button (if enabled)
                  if (widget.showsBookmarkButton)
                    IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: widget.onBookmarkButtonClicked,
                      color: widget.tintColor ?? theme.colorScheme.primary,
                    ),
                  
                  // Search field
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: widget.onTextChanged,
                      onSubmitted: widget.onSearchButtonClicked,
                      keyboardType: _mapKeyboardType(widget.keyboardType),
                      textInputAction: _mapReturnKeyType(widget.returnKeyType),
                      textCapitalization: _mapCapitalizationType(widget.autocapitalizationType),
                      autocorrect: widget.autocorrectionType != CNAutocorrectionType.no,
                      enableSuggestions: widget.spellCheckingType != CNSpellCheckingType.no,
                      decoration: InputDecoration(
                        hintText: widget.placeholder ?? 'Search',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                widget.onTextChanged?.call('');
                              },
                            )
                          : (widget.showsSearchResultsButton
                              ? IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () => widget.onSearchButtonClicked?.call(_controller.text),
                                )
                              : null),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: widget.searchFieldBackgroundColor ?? 
                                   theme.colorScheme.onSurface.withOpacity(isDark ? 0.1 : 0.08),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  
                  // Cancel button (if enabled)
                  if (widget.showsCancelButton)
                    TextButton(
                      onPressed: widget.onCancelButtonClicked,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: widget.tintColor ?? theme.colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Scope bar (if enabled)
          if (widget.showsScopeBar && widget.scopeButtonTitles.isNotEmpty)
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.scopeButtonTitles.asMap().entries.map((entry) {
                          final index = entry.key;
                          final title = entry.value;
                          final isSelected = index == _selectedScopeIndex;
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(title),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedScopeIndex = index;
                                  });
                                  widget.onScopeChanged?.call(index);
                                }
                              },
                              selectedColor: widget.tintColor ?? theme.colorScheme.primary,
                              checkmarkColor: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  TextInputType _mapKeyboardType(CNKeyboardType type) {
    switch (type) {
      case CNKeyboardType.emailAddress:
        return TextInputType.emailAddress;
      case CNKeyboardType.url:
        return TextInputType.url;
      case CNKeyboardType.numberPad:
      case CNKeyboardType.decimalPad:
        return TextInputType.number;
      case CNKeyboardType.phonePad:
        return TextInputType.phone;
      case CNKeyboardType.numbersAndPunctuation:
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _mapReturnKeyType(CNReturnKeyType type) {
    switch (type) {
      case CNReturnKeyType.search:
        return TextInputAction.search;
      case CNReturnKeyType.go:
        return TextInputAction.go;
      case CNReturnKeyType.next:
        return TextInputAction.next;
      case CNReturnKeyType.done:
        return TextInputAction.done;
      case CNReturnKeyType.send:
        return TextInputAction.send;
      case CNReturnKeyType.join:
        return TextInputAction.join;
      case CNReturnKeyType.route:
        return TextInputAction.route;
      case CNReturnKeyType.continueType:
        return TextInputAction.continueAction;
      default:
        return TextInputAction.search;
    }
  }

  TextCapitalization _mapCapitalizationType(CNAutocapitalizationType type) {
    switch (type) {
      case CNAutocapitalizationType.words:
        return TextCapitalization.words;
      case CNAutocapitalizationType.sentences:
        return TextCapitalization.sentences;
      case CNAutocapitalizationType.allCharacters:
        return TextCapitalization.characters;
      default:
        return TextCapitalization.none;
    }
  }
}

/// Legacy CNSearchBar class for backward compatibility
/// 
/// This maintains the original API while delegating to BaseCNSearchBar
/// for actual implementation.
class CNSearchBar extends StatefulWidget {
  /// Creates a native iOS search bar.
  const CNSearchBar({
    super.key,
    this.placeholder,
    this.text,
    this.prompt,
    this.showsCancelButton = false,
    this.showsBookmarkButton = false,
    this.showsSearchResultsButton = false,
    this.searchBarStyle = CNSearchBarStyle.defaultStyle,
    this.barTintColor,
    this.tintColor,
    this.searchFieldBackgroundColor,
    this.showsScopeBar = false,
    this.scopeButtonTitles = const [],
    this.selectedScopeIndex = 0,
    this.keyboardType = CNKeyboardType.defaultType,
    this.keyboardAppearance = CNKeyboardAppearance.defaultAppearance,
    this.returnKeyType = CNReturnKeyType.search,
    this.enablesReturnKeyAutomatically = true,
    this.autocapitalizationType = CNAutocapitalizationType.none,
    this.autocorrectionType = CNAutocorrectionType.defaultType,
    this.spellCheckingType = CNSpellCheckingType.defaultType,
    this.onTextChanged,
    this.onSearchButtonClicked,
    this.onCancelButtonClicked,
    this.onScopeChanged,
    this.onBookmarkButtonClicked,
    this.height = 56.0,
  });

  /// Placeholder text (e.g., "Shows, Movies, and More")
  final String? placeholder;

  /// Initial search text
  final String? text;

  /// Prompt text displayed above the search bar
  final String? prompt;

  /// Whether to show the cancel button
  final bool showsCancelButton;

  /// Whether to show the bookmark button
  final bool showsBookmarkButton;

  /// Whether to show the search results button
  final bool showsSearchResultsButton;

  /// Visual style of the search bar
  final CNSearchBarStyle searchBarStyle;

  /// Background tint color for the search bar
  final Color? barTintColor;

  /// Tint color for search bar elements
  final Color? tintColor;

  /// Background color for the search text field
  final Color? searchFieldBackgroundColor;

  /// Whether to show the scope bar
  final bool showsScopeBar;

  /// Titles for scope bar buttons
  final List<String> scopeButtonTitles;

  /// Selected scope bar index
  final int selectedScopeIndex;

  /// Keyboard type
  final CNKeyboardType keyboardType;

  /// Keyboard appearance (light/dark)
  final CNKeyboardAppearance keyboardAppearance;

  /// Return key type
  final CNReturnKeyType returnKeyType;

  /// Whether return key is enabled only when there's text
  final bool enablesReturnKeyAutomatically;

  /// Auto-capitalization behavior
  final CNAutocapitalizationType autocapitalizationType;

  /// Auto-correction behavior
  final CNAutocorrectionType autocorrectionType;

  /// Spell checking behavior
  final CNSpellCheckingType spellCheckingType;

  /// Called when search text changes
  final ValueChanged<String>? onTextChanged;

  /// Called when search button is clicked
  final ValueChanged<String>? onSearchButtonClicked;

  /// Called when cancel button is clicked
  final VoidCallback? onCancelButtonClicked;

  /// Called when scope selection changes
  final ValueChanged<int>? onScopeChanged;

  /// Called when bookmark button is clicked
  final VoidCallback? onBookmarkButtonClicked;

  /// Height of the search bar
  final double height;

  @override
  State<CNSearchBar> createState() => _CNSearchBarState();
}

class _CNSearchBarState extends State<CNSearchBar> {
  @override
  Widget build(BuildContext context) {
    return BaseSearchBar(
      placeholder: widget.placeholder,
      text: widget.text,
      prompt: widget.prompt,
      showsCancelButton: widget.showsCancelButton,
      showsBookmarkButton: widget.showsBookmarkButton,
      showsSearchResultsButton: widget.showsSearchResultsButton,
      searchBarStyle: widget.searchBarStyle,
      barTintColor: widget.barTintColor,
      tintColor: widget.tintColor,
      searchFieldBackgroundColor: widget.searchFieldBackgroundColor,
      showsScopeBar: widget.showsScopeBar,
      scopeButtonTitles: widget.scopeButtonTitles,
      selectedScopeIndex: widget.selectedScopeIndex,
      keyboardType: widget.keyboardType,
      keyboardAppearance: widget.keyboardAppearance,
      returnKeyType: widget.returnKeyType,
      enablesReturnKeyAutomatically: widget.enablesReturnKeyAutomatically,
      autocapitalizationType: widget.autocapitalizationType,
      autocorrectionType: widget.autocorrectionType,
      spellCheckingType: widget.spellCheckingType,
      onTextChanged: widget.onTextChanged,
      onSearchButtonClicked: widget.onSearchButtonClicked,
      onCancelButtonClicked: widget.onCancelButtonClicked,
      onScopeChanged: widget.onScopeChanged,
      onBookmarkButtonClicked: widget.onBookmarkButtonClicked,
      height: widget.height,
    );
  }
}