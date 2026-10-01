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
//  - anything else: nothing — the child as it is.
//
// Made for the Creator first and shared so both apps' menus work alike
// (owner, 2026-09-29).

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

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
  });

  final String edit;
  final String undo;
  final String redo;
  final String cut;
  final String copy;
  final String paste;
  final String selectAll;
  final String window;
}

/// Whether this device shows a menu bar the app can fill: a Mac, or an iPad.
bool baseHasMenuBar(BuildContext context) {
  if (kIsWeb) {
    return false;
  }
  if (Platform.isMacOS) {
    return true;
  }
  return Platform.isIOS && MediaQuery.sizeOf(context).shortestSide >= 600;
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
  });

  final String appName;
  final List<BaseMenu> Function() menus;
  final BaseMenuBarLabels labels;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!baseHasMenuBar(context)) {
      return child;
    }
    if (Platform.isMacOS) {
      return PlatformMenuBar(
        menus: _macMenus(appName, menus(), labels),
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
