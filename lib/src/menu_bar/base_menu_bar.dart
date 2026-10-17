// Created: 2026-09-29
//
// An app's menu bar on the Mac and the iPad, from one definition.
//
// The app describes its menus once as [BaseMenu]s — ids, labels, shortcuts
// and what each item does — and [BaseMenuBar] draws them:
//
//  - macOS: Flutter's PlatformMenuBar. It replaces the whole native main
//    menu, so the standard app, Edit and Window menus are added here; the
//    Edit items hand the text intents to whatever has focus (a menu that owns
//    ⌘C gets the key press, not the text field).
//  - iPad: PlatformMenuBar is Mac-only, so the menus go down the
//    "base_plus/menu_bar" channel to the app delegate, which builds them into
//    iPadOS's own menu bar (BaseMenuBarBridge.swift, one copy per app — see
//    the app's ios/Runner). A choice comes back as the item's id. The
//    shortcuts also show in the ⌘ keyboard-shortcut overlay.
//  - Windows (2026-10-16): an in-window Fluent menu bar under the title bar,
//    laid out the Windows way — File (with Settings… and Exit), Edit, View,
//    the app's own menus, Help (with About) — and every shortcut on Ctrl
//    instead of ⌘, working anywhere in the window.
//  - anything else: nothing — the child as it is.
//
// Made for the Creator first and shared so both apps' menus work alike
// (owner, 2026-09-29).

import 'dart:convert';
import 'dart:io';
import 'dart:ui' show AppExitType;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
// Prefixed: fluent_ui re-exports the SDK's material library.
import 'package:fluent_ui/fluent_ui.dart' as fl;

/// One menu item. [key] is the shortcut's character, pressed with ⌘ (and ⇧
/// when [shift], ⌃ when [control]); [children] makes it a submenu.
@immutable
class BaseMenuItem {
  const BaseMenuItem({
    required this.id,
    required this.label,
    this.key,
    this.shift = false,
    this.control = false,
    this.onSelected,
    this.children,
  });

  final String id;
  final String label;
  final String? key;
  final bool shift;
  final bool control;
  final VoidCallback? onSelected;
  final List<BaseMenuItem>? children;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'label': label,
    if (key != null) 'key': key,
    'shift': shift,
    'control': control,
    if (children != null)
      'children': <Object?>[for (final BaseMenuItem c in children!) c.toJson()],
  };
}

/// Where a [BaseMenu] goes in the menu bar.
enum BaseMenuPlace {
  /// Into the app's own menu, after About (Settings…, say).
  app,

  /// Into the system File, View or Help menu, at its top.
  file,
  view,
  help,

  /// A menu of the app's own, after View (Go, say).
  custom,
}

/// One menu: [groups] are separated by dividers.
@immutable
class BaseMenu {
  const BaseMenu({
    required this.place,
    required this.label,
    required this.groups,
    this.id,
  });

  final BaseMenuPlace place;
  final String label;
  final List<List<BaseMenuItem>> groups;

  /// For [BaseMenuPlace.custom] menus: a stable id (defaults to [label]).
  final String? id;

  Map<String, Object?> toJson() => <String, Object?>{
    'place': place.name,
    'label': label,
    'id': id ?? label,
    'groups': <Object?>[
      for (final List<BaseMenuItem> g in groups)
        <Object?>[for (final BaseMenuItem i in g) i.toJson()],
    ],
  };
}

/// The words the Mac's standard menus need, in the app's language.
@immutable
class BaseMenuBarLabels {
  const BaseMenuBarLabels({
    this.edit = 'Edit',
    this.undo = 'Undo',
    this.redo = 'Redo',
    this.cut = 'Cut',
    this.copy = 'Copy',
    this.paste = 'Paste',
    this.selectAll = 'Select All',
    this.window = 'Window',
    this.file = 'File',
    this.view = 'View',
    this.help = 'Help',
    this.exit = 'Exit',
    this.about = 'About',
  });

  final String edit;
  final String undo;
  final String redo;
  final String cut;
  final String copy;
  final String paste;
  final String selectAll;
  final String window;

  /// Windows: the menus the app may have nothing of its own for.
  final String file;
  final String view;
  final String help;

  /// Windows: File ▸ Exit, and Help ▸ About (followed by the app's name).
  final String exit;
  final String about;
}

/// Whether this device shows a menu bar the app can fill: a Mac, or an iPad.
bool baseHasMenuBar(BuildContext context) {
  if (kIsWeb) {
    return false;
  }
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
    return true;
  }
  return (!kIsWeb && Platform.isIOS) && MediaQuery.sizeOf(context).shortestSide >= 600;
}

/// Puts [menus] in the menu bar: PlatformMenuBar on the Mac, the native
/// bridge on an iPad, nothing elsewhere. [menus] is called on every build, so
/// labels follow the app's language.
class BaseMenuBar extends StatelessWidget {
  const BaseMenuBar({
    super.key,
    required this.appName,
    required this.menus,
    required this.child,
    this.labels = const BaseMenuBarLabels(),
    this.navigatorKey,
  });

  final String appName;
  final List<BaseMenu> Function() menus;
  final BaseMenuBarLabels labels;
  final Widget child;

  /// Windows: the app's navigator, for dialogs the bar opens itself (About).
  /// The bar usually sits above the app's Navigator (in the app's builder),
  /// where there is none to find.
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {
    if (!baseHasMenuBar(context)) {
      return child;
    }
    if (!kIsWeb && Platform.isMacOS) {
      return PlatformMenuBar(
        menus: _macMenus(appName, menus(), labels),
        child: child,
      );
    }
    if (!kIsWeb && Platform.isWindows) {
      return _WindowsMenuBar(
        appName: appName,
        menus: menus(),
        labels: labels,
        navigatorKey: navigatorKey,
        child: child,
      );
    }
    return _IPadMenuBar(menus: menus, child: child);
  }
}

// ── macOS ──────────────────────────────────────────────────────────────────

List<PlatformMenuItem> _macMenus(
  String appName,
  List<BaseMenu> menus,
  BaseMenuBarLabels labels,
) {
  Iterable<BaseMenu> at(BaseMenuPlace place) =>
      menus.where((BaseMenu m) => m.place == place);
  List<PlatformMenuItem> groupsOf(Iterable<BaseMenu> ms) => <PlatformMenuItem>[
    for (final BaseMenu m in ms) ..._macGroups(m),
  ];
  PlatformMenu? system(BaseMenuPlace place, {List<PlatformMenuItem>? tail}) {
    final List<BaseMenu> ms = at(place).toList();
    if (ms.isEmpty && tail == null) {
      return null;
    }
    return PlatformMenu(
      // An app with nothing of its own for this menu still gets the
      // system's (View ▸ Full Screen): titled as macOS titles it.
      label: ms.isNotEmpty
          ? ms.first.label
          : place.name[0].toUpperCase() + place.name.substring(1),
      menus: <PlatformMenuItem>[...groupsOf(ms), ...?tail],
    );
  }

  return <PlatformMenuItem>[
    PlatformMenu(
      label: appName,
      menus: <PlatformMenuItem>[
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
          ],
        ),
        ...groupsOf(at(BaseMenuPlace.app)),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.servicesSubmenu,
            ),
          ],
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.hideOtherApplications,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.showAllApplications,
            ),
          ],
        ),
        const PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
          ],
        ),
      ],
    ),
    ?system(BaseMenuPlace.file),
    _macEditMenu(labels),
    ?system(
      BaseMenuPlace.view,
      tail: const <PlatformMenuItem>[
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.toggleFullScreen,
            ),
          ],
        ),
      ],
    ),
    for (final BaseMenu m in at(BaseMenuPlace.custom))
      PlatformMenu(label: m.label, menus: _macGroups(m)),
    PlatformMenu(
      label: labels.window,
      menus: const <PlatformMenuItem>[
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.minimizeWindow,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.zoomWindow,
            ),
          ],
        ),
        PlatformMenuItemGroup(
          members: <PlatformMenuItem>[
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.arrangeWindowsInFront,
            ),
          ],
        ),
      ],
    ),
    ?system(BaseMenuPlace.help),
  ];
}

List<PlatformMenuItem> _macGroups(BaseMenu menu) => <PlatformMenuItem>[
  for (final List<BaseMenuItem> g in menu.groups)
    PlatformMenuItemGroup(
      members: <PlatformMenuItem>[for (final BaseMenuItem i in g) _macItem(i)],
    ),
];

PlatformMenuItem _macItem(BaseMenuItem i) {
  if (i.children != null) {
    return PlatformMenu(
      label: i.label,
      menus: <PlatformMenuItem>[
        for (final BaseMenuItem c in i.children!) _macItem(c),
      ],
    );
  }
  return PlatformMenuItem(
    label: i.label,
    shortcut: i.key == null
        ? null
        : _activator(i.key!, shift: i.shift, control: i.control),
    onSelected: i.onSelected,
  );
}

/// ⌘ + [key] (and ⇧, ⌃). Letters, digits and "," — what menus use.
SingleActivator? _activator(
  String key, {
  bool shift = false,
  bool control = false,
}) {
  final String k = key.toLowerCase();
  LogicalKeyboardKey? logical;
  if (k == ',') {
    logical = LogicalKeyboardKey.comma;
  } else if (k == '/') {
    logical = LogicalKeyboardKey.slash;
  } else if (RegExp(r'^[a-z]$').hasMatch(k)) {
    logical = LogicalKeyboardKey(
      LogicalKeyboardKey.keyA.keyId + k.codeUnitAt(0) - 'a'.codeUnitAt(0),
    );
  } else if (RegExp(r'^[0-9]$').hasMatch(k)) {
    logical = LogicalKeyboardKey(
      LogicalKeyboardKey.digit0.keyId + k.codeUnitAt(0) - '0'.codeUnitAt(0),
    );
  }
  return logical == null
      ? null
      : SingleActivator(logical, meta: true, shift: shift, control: control);
}

PlatformMenu _macEditMenu(BaseMenuBarLabels labels) {
  void edit(Intent intent) {
    final BuildContext? focused = primaryFocus?.context;
    if (focused != null) {
      Actions.maybeInvoke(focused, intent);
    }
  }

  SingleActivator cmd(LogicalKeyboardKey k, {bool shift = false}) =>
      SingleActivator(k, meta: true, shift: shift);

  return PlatformMenu(
    label: labels.edit,
    menus: <PlatformMenuItem>[
      PlatformMenuItemGroup(
        members: <PlatformMenuItem>[
          PlatformMenuItem(
            label: labels.undo,
            shortcut: cmd(LogicalKeyboardKey.keyZ),
            onSelected: () =>
                edit(const UndoTextIntent(SelectionChangedCause.keyboard)),
          ),
          PlatformMenuItem(
            label: labels.redo,
            shortcut: cmd(LogicalKeyboardKey.keyZ, shift: true),
            onSelected: () =>
                edit(const RedoTextIntent(SelectionChangedCause.keyboard)),
          ),
        ],
      ),
      PlatformMenuItemGroup(
        members: <PlatformMenuItem>[
          PlatformMenuItem(
            label: labels.cut,
            shortcut: cmd(LogicalKeyboardKey.keyX),
            onSelected: () => edit(
              const CopySelectionTextIntent.cut(SelectionChangedCause.keyboard),
            ),
          ),
          PlatformMenuItem(
            label: labels.copy,
            shortcut: cmd(LogicalKeyboardKey.keyC),
            onSelected: () => edit(CopySelectionTextIntent.copy),
          ),
          PlatformMenuItem(
            label: labels.paste,
            shortcut: cmd(LogicalKeyboardKey.keyV),
            onSelected: () =>
                edit(const PasteTextIntent(SelectionChangedCause.keyboard)),
          ),
          PlatformMenuItem(
            label: labels.selectAll,
            shortcut: cmd(LogicalKeyboardKey.keyA),
            onSelected: () =>
                edit(const SelectAllTextIntent(SelectionChangedCause.keyboard)),
          ),
        ],
      ),
    ],
  );
}

// ── Windows ────────────────────────────────────────────────────────────────

/// Ctrl + [key] (and Shift; the Mac's ⌃ becomes Alt).
SingleActivator? _windowsActivator(
  String key, {
  bool shift = false,
  bool control = false,
}) {
  final SingleActivator? mac = _activator(key, shift: shift);
  return mac == null
      ? null
      : SingleActivator(mac.trigger, control: true, shift: shift, alt: control);
}

/// "Ctrl+Shift+N", as Windows menus write it.
String _windowsShortcutText(BaseMenuItem i) => <String>[
  'Ctrl',
  if (i.shift) 'Shift',
  if (i.control) 'Alt',
  i.key!.toUpperCase(),
].join('+');

class _WindowsMenuBar extends StatelessWidget {
  const _WindowsMenuBar({
    required this.appName,
    required this.menus,
    required this.labels,
    required this.child,
    this.navigatorKey,
  });

  final String appName;
  final List<BaseMenu> menus;
  final BaseMenuBarLabels labels;
  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  Iterable<BaseMenu> _at(BaseMenuPlace place) =>
      menus.where((BaseMenu m) => m.place == place);

  /// Every shortcut, bound app-wide (menus can be closed when it's pressed).
  Map<ShortcutActivator, VoidCallback> _bindings() {
    final Map<ShortcutActivator, VoidCallback> out =
        <ShortcutActivator, VoidCallback>{};
    void add(BaseMenuItem i) {
      if (i.key != null && i.onSelected != null) {
        final SingleActivator? a =
            _windowsActivator(i.key!, shift: i.shift, control: i.control);
        if (a != null) {
          out[a] = i.onSelected!;
        }
      }
      for (final BaseMenuItem c in i.children ?? const <BaseMenuItem>[]) {
        add(c);
      }
    }
    for (final BaseMenu m in menus) {
      for (final List<BaseMenuItem> g in m.groups) {
        g.forEach(add);
      }
    }
    return out;
  }

  /// A shortcut on the right of a menu item, greyed as Windows has it. The
  /// end padding makes the menu leave room for it: fluent_ui sized the menu
  /// to the labels and cut the longer shortcuts off (Ctrl+Shift+N).
  static Widget _shortcut(String keys) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 24, end: 12),
    child: Opacity(opacity: 0.7, child: Text(keys)),
  );

  fl.MenuFlyoutItemBase _item(BaseMenuItem i) {
    if (i.children != null) {
      return fl.MenuFlyoutSubItem(
        text: Text(i.label),
        items: (_) => <fl.MenuFlyoutItemBase>[
          for (final BaseMenuItem c in i.children!) _item(c),
        ],
      );
    }
    return fl.MenuFlyoutItem(
      text: Text(i.label),
      trailing: i.key == null
          ? null
          : _shortcut(_windowsShortcutText(i)),
      onPressed: i.onSelected,
    );
  }

  List<fl.MenuFlyoutItemBase> _groups(Iterable<BaseMenu> ms) {
    final List<fl.MenuFlyoutItemBase> out = <fl.MenuFlyoutItemBase>[];
    for (final BaseMenu m in ms) {
      for (final List<BaseMenuItem> g in m.groups) {
        if (out.isNotEmpty) {
          out.add(const fl.MenuFlyoutSeparator());
        }
        out.addAll(g.map(_item));
      }
    }
    return out;
  }

  List<fl.MenuFlyoutItemBase> _editItems() {
    void edit(Intent intent) {
      final BuildContext? focused = primaryFocus?.context;
      if (focused != null) {
        Actions.maybeInvoke(focused, intent);
      }
    }
    fl.MenuFlyoutItem entry(String label, String keys, VoidCallback run) =>
        fl.MenuFlyoutItem(
          text: Text(label),
          trailing: _shortcut(keys),
          onPressed: run,
        );
    return <fl.MenuFlyoutItemBase>[
      entry(labels.undo, 'Ctrl+Z',
          () => edit(const UndoTextIntent(SelectionChangedCause.keyboard))),
      entry(labels.redo, 'Ctrl+Y',
          () => edit(const RedoTextIntent(SelectionChangedCause.keyboard))),
      const fl.MenuFlyoutSeparator(),
      entry(labels.cut, 'Ctrl+X', () => edit(
            const CopySelectionTextIntent.cut(SelectionChangedCause.keyboard),
          )),
      entry(labels.copy, 'Ctrl+C', () => edit(CopySelectionTextIntent.copy)),
      entry(labels.paste, 'Ctrl+V',
          () => edit(const PasteTextIntent(SelectionChangedCause.keyboard))),
      entry(labels.selectAll, 'Ctrl+A',
          () => edit(const SelectAllTextIntent(SelectionChangedCause.keyboard))),
    ];
  }

  Future<void> _about(BuildContext context) => fl.showDialog<void>(
    context: navigatorKey?.currentContext ?? context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) => fl.ContentDialog(
      title: Text('${labels.about} $appName'),
      content: Text(appName),
      actions: <Widget>[
        fl.FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final Widget shortcuts = CallbackShortcuts(
      bindings: _bindings(),
      child: child,
    );
    if (fl.FluentTheme.maybeOf(context) == null) {
      // No Fluent theme above: the shortcuts still work, without a bar.
      return shortcuts;
    }
    final List<fl.MenuFlyoutItemBase> file = <fl.MenuFlyoutItemBase>[
      ..._groups(_at(BaseMenuPlace.file)),
      if (_at(BaseMenuPlace.app).isNotEmpty) ...<fl.MenuFlyoutItemBase>[
        if (_at(BaseMenuPlace.file).isNotEmpty) const fl.MenuFlyoutSeparator(),
        ..._groups(_at(BaseMenuPlace.app)),
      ],
      const fl.MenuFlyoutSeparator(),
      fl.MenuFlyoutItem(
        text: Text(labels.exit),
        trailing: _shortcut('Alt+F4'),
        onPressed: () => ServicesBinding.instance
            .exitApplication(AppExitType.required),
      ),
    ];
    final List<fl.MenuFlyoutItemBase> view = _groups(_at(BaseMenuPlace.view));
    final List<fl.MenuFlyoutItemBase> help = <fl.MenuFlyoutItemBase>[
      ..._groups(_at(BaseMenuPlace.help)),
      if (_at(BaseMenuPlace.help).isNotEmpty) const fl.MenuFlyoutSeparator(),
      fl.MenuFlyoutItem(
        text: Text('${labels.about} $appName'),
        onPressed: () => _about(context),
      ),
    ];
    // Fluent's menus open in an overlay and need a Navigator above them. An
    // app puts its menu bar in its builder, above its Navigator, and every
    // menu threw — a grey screen in release (Creator on Windows 11,
    // 2026-10-17). A Navigator around the whole app would become its root
    // navigator (showDialog would push onto it, Get.back would close the
    // wrong route), so the bar gets one of its own, laid over the app
    // (_MenuBarHost): its menus open there and the app's routes are untouched.
    final Widget bar = SizedBox(
      height: _kWindowsMenuBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          // fluent_ui 4.16.1 reads DisableAcrylic the wrong way round
          // (MenuFlyout: useAcrylic = DisableAcrylic.of(context) != null), so
          // its menus were solid. Under DisableAcrylic they get Windows 11's
          // frosted acrylic. Remove when fluent_ui fixes the check.
          child: fl.DisableAcrylic(
          child: fl.MenuBar(
            items: <fl.MenuBarItem>[
              fl.MenuBarItem(title: labels.file, items: file),
              fl.MenuBarItem(title: labels.edit, items: _editItems()),
              if (view.isNotEmpty)
                fl.MenuBarItem(title: labels.view, items: view),
              for (final BaseMenu m in _at(BaseMenuPlace.custom))
                fl.MenuBarItem(title: m.label, items: _groups(<BaseMenu>[m])),
              fl.MenuBarItem(title: labels.help, items: help),
            ],
          ),
          ),
        ),
      ),
    );
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // The bar's own background, Windows' Mica colour in the app's
            // light or dark. It painted nothing, so whatever was behind the
            // app showed through: a light strip in dark mode, white text on
            // it (2026-10-17).
            ColoredBox(
              color: fl.FluentTheme.of(context).micaBackgroundColor,
              child: const SizedBox(
                height: _kWindowsMenuBarHeight,
                width: double.infinity,
              ),
            ),
            Expanded(child: shortcuts),
          ],
        ),
        Positioned.fill(child: _MenuBarHost(bar: bar)),
      ],
    );
  }
}

const double _kWindowsMenuBarHeight = 40;

/// A Navigator of the menu bar's own, covering the window but drawing (and
/// taking clicks) only where the bar and its open menus are.
class _MenuBarHost extends StatefulWidget {
  const _MenuBarHost({required this.bar});

  final Widget bar;

  @override
  State<_MenuBarHost> createState() => _MenuBarHostState();
}

class _MenuBarHostState extends State<_MenuBarHost> {
  late final ValueNotifier<Widget> _bar = ValueNotifier<Widget>(widget.bar);

  @override
  void didUpdateWidget(_MenuBarHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bar.value = widget.bar;
  }

  @override
  void dispose() {
    _bar.dispose();
    super.dispose();
  }

  @override
  // HeroControllerScope.none: the app's MaterialApp hands its
  // HeroController down to the first Navigator below it, and a controller
  // can't serve two.
  Widget build(BuildContext context) => HeroControllerScope.none(
    child: Navigator(
      // Never take the keyboard from the app.
      requestFocus: false,
      onGenerateInitialRoutes: (NavigatorState _, String _) =>
          <Route<void>>[_MenuBarRoute(_bar)],
    ),
  );
}

/// The bar itself, as a route with no barrier: the rest of the window lets
/// clicks through to the app underneath.
class _MenuBarRoute extends OverlayRoute<void> {
  _MenuBarRoute(this.bar);

  final ValueListenable<Widget> bar;

  @override
  Iterable<OverlayEntry> createOverlayEntries() => <OverlayEntry>[
    OverlayEntry(
      builder: (BuildContext context) => Align(
        alignment: AlignmentDirectional.topStart,
        child: ValueListenableBuilder<Widget>(
          valueListenable: bar,
          builder: (BuildContext context, Widget bar, Widget? _) => bar,
        ),
      ),
    ),
  ];
}

// ── iPad ───────────────────────────────────────────────────────────────────

/// Hands the menus to the app delegate and runs what comes back; sends them
/// again whenever they change (the language, say).
class _IPadMenuBar extends StatefulWidget {
  const _IPadMenuBar({required this.menus, required this.child});

  final List<BaseMenu> Function() menus;
  final Widget child;

  @override
  State<_IPadMenuBar> createState() => _IPadMenuBarState();
}

class _IPadMenuBarState extends State<_IPadMenuBar> {
  static const MethodChannel _channel = MethodChannel('base_plus/menu_bar');

  Map<String, VoidCallback> _actions = const <String, VoidCallback>{};
  String? _sent;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'select') {
        _actions[call.arguments as String]?.call();
      }
      return null;
    });
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    super.dispose();
  }

  void _collect(BaseMenuItem i, Map<String, VoidCallback> into) {
    if (i.onSelected != null) {
      into[i.id] = i.onSelected!;
    }
    for (final BaseMenuItem c in i.children ?? const <BaseMenuItem>[]) {
      _collect(c, into);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<BaseMenu> menus = widget.menus();
    final Map<String, VoidCallback> actions = <String, VoidCallback>{};
    for (final BaseMenu m in menus) {
      for (final List<BaseMenuItem> g in m.groups) {
        for (final BaseMenuItem i in g) {
          _collect(i, actions);
        }
      }
    }
    _actions = actions;
    final String json = jsonEncode(<Object?>[
      for (final BaseMenu m in menus) m.toJson(),
    ]);
    if (json != _sent) {
      _sent = json;
      _channel.invokeMethod<void>('setMenus', json).catchError((_) {});
    }
    return widget.child;
  }
}
