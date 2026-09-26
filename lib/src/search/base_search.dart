// Created: 2026-09-26
import 'dart:async';

import 'package:cupertino_native_extra/cupertino_native.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Builds the search page's content for the current [query]: recents or
/// suggestions while it is empty, results once something is typed. Call
/// [search] to run a search from the content (a recent search was tapped) —
/// it fills the field too.
typedef BaseSearchBuilder = Widget Function(
  BuildContext context,
  String query,
  ValueChanged<String> search,
);

/// Search mode, as iOS 26 apps do it (Mail, Photos): the page gives way to a
/// search page, the keyboard comes up with a glass search field riding on it
/// and a round × beside it, and the content above follows what's typed.
///
/// The field is the native `UISearchTextField` ([CNNativeSearchField]); the
/// content is Flutter, from [builder]. A real `UISearchController` can't be
/// used — it draws results in a native view controller, where Flutter can't.
/// Android gets a Material search app bar over the same content.
///
/// ```dart
/// BaseSearch.show(
///   context,
///   placeholder: 'searchWorld'.tr,
///   builder: (context, query, search) =>
///       query.isEmpty ? Recents(onTap: search) : Results(query),
/// );
/// ```
class BaseSearch {
  BaseSearch._();

  /// Told when search mode opens (true) and closes (false), so an app can
  /// clear away what would cover the field — a floating tab bar sits over
  /// every page, and the field and its × ended up under it (owner,
  /// 2026-09-26). Set once, at start-up.
  static ValueChanged<bool>? onSearchModeChanged;

  /// Opens search mode. Completes with whatever the page pops with.
  static Future<T?> show<T>(
    BuildContext context, {
    required String placeholder,
    required BaseSearchBuilder builder,
    ValueChanged<String>? onSubmitted,
    String initialQuery = '',
    Duration debounce = const Duration(milliseconds: 250),
  }) {
    onSearchModeChanged?.call(true);
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext _, Animation<double> __, Animation<double> ___) =>
            _BaseSearchPage(
          placeholder: placeholder,
          builder: builder,
          onSubmitted: onSubmitted,
          initialQuery: initialQuery,
          debounce: debounce,
        ),
        transitionsBuilder: (BuildContext _, Animation<double> animation,
                Animation<double> __, Widget child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ).whenComplete(() => onSearchModeChanged?.call(false));
  }
}

class _BaseSearchPage extends StatefulWidget {
  const _BaseSearchPage({
    required this.placeholder,
    required this.builder,
    required this.onSubmitted,
    required this.initialQuery,
    required this.debounce,
  });

  final String placeholder;
  final BaseSearchBuilder builder;
  final ValueChanged<String>? onSubmitted;
  final String initialQuery;
  final Duration debounce;

  @override
  State<_BaseSearchPage> createState() => _BaseSearchPageState();
}

class _BaseSearchPageState extends State<_BaseSearchPage> {
  /// Height of the iOS field, as the system draws it.
  static const double _fieldHeight = 50;

  /// Space around the iOS field.
  static const double _fieldGap = 8;

  static bool get _native =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  final CNNativeSearchFieldController _nativeField =
      CNNativeSearchFieldController();
  late final TextEditingController _materialField =
      TextEditingController(text: widget.initialQuery);
  late String _query = widget.initialQuery;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _materialField.dispose();
    super.dispose();
  }

  /// Typing: the content follows after a pause, so a query isn't run for
  /// every letter. Emptying the field shows the recents at once.
  void _onChanged(String text) {
    _debounce?.cancel();
    if (text.isEmpty) {
      setState(() => _query = '');
      return;
    }
    _debounce = Timer(widget.debounce, () {
      if (mounted) {
        setState(() => _query = text);
      }
    });
  }

  void _onSubmitted(String text) {
    _debounce?.cancel();
    setState(() => _query = text);
    widget.onSubmitted?.call(text);
  }

  /// A search started from the content (a recent search tapped): fill the
  /// field, show the results, and drop the keyboard so they can be seen.
  void _search(String text) {
    _debounce?.cancel();
    if (_native) {
      _nativeField.setText(text);
      _nativeField.unfocus();
    } else {
      _materialField.text = text;
      FocusScope.of(context).unfocus();
    }
    setState(() => _query = text);
    widget.onSubmitted?.call(text);
  }

  void _close() => Navigator.of(context).maybePop();

  @override
  Widget build(BuildContext context) {
    return _native ? _buildNative(context) : _buildMaterial(context);
  }

  Widget _buildNative(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double keyboard = media.viewInsets.bottom;
    // On the keyboard while it's up; above the home indicator when it isn't.
    final double fieldBottom =
        (keyboard > 0 ? keyboard : media.viewPadding.bottom) + _fieldGap;
    final double contentBottom = fieldBottom + _fieldHeight + _fieldGap;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            // The content ends above the field and the keyboard under it.
            // Not by raising the bottom padding: every list reads that, so a
            // list inside a card (the Bible's chapters) grew a gap as tall as
            // the field and keyboard (owner, 2026-09-26).
            bottom: contentBottom,
            child: MediaQuery(
              data: media.copyWith(
                padding: media.padding.copyWith(bottom: 0),
                viewPadding: media.viewPadding.copyWith(bottom: 0),
                viewInsets: media.viewInsets.copyWith(bottom: 0),
              ),
              child: SafeArea(
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) =>
                      widget.builder(context, _query, _search),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: fieldBottom,
            height: _fieldHeight,
            child: CNNativeSearchField(
              controller: _nativeField,
              placeholder: widget.placeholder,
              initialText: widget.initialQuery,
              autofocus: true,
              tint: Theme.of(context).colorScheme.primary,
              onChanged: _onChanged,
              onSubmitted: _onSubmitted,
              onClose: _close,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterial(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: _close),
        title: TextField(
          controller: _materialField,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            border: InputBorder.none,
          ),
          style: theme.textTheme.titleMedium,
          onChanged: _onChanged,
          onSubmitted: _onSubmitted,
        ),
        actions: <Widget>[
          ListenableBuilder(
            listenable: _materialField,
            builder: (BuildContext context, Widget? _) =>
                _materialField.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _materialField.clear();
                          _onChanged('');
                        },
                      ),
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) =>
            widget.builder(context, _query, _search),
      ),
    );
  }
}
