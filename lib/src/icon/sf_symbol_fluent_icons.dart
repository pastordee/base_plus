// Created: 2026-10-16
import 'package:fluent_ui/fluent_ui.dart' as fl;
import 'package:material_ui/material_ui.dart';

import 'sf_symbol_material_icons.dart';

/// SF Symbol → Windows Segoe Fluent icon (fluent_ui's [fl.FluentIcons]), for
/// base_plus widgets drawn in their Fluent build (BaseMode.fluent, Windows).
///
/// Windows apps use Segoe Fluent icons, so where one exists it is used; any
/// symbol not mapped here falls back to the shared Material table
/// ([sfSymbolToMaterialIcon]), which covers every symbol the apps use. When a
/// new SF Symbol appears in a Windows toolbar or menu, add it here.
const Map<String, IconData> kSfSymbolFluentIcons = <String, IconData>{
  // Navigation
  'chevron.backward': fl.FluentIcons.back,
  'chevron.left': fl.FluentIcons.back,
  'arrow.left': fl.FluentIcons.back,
  'chevron.forward': fl.FluentIcons.forward,
  'chevron.right': fl.FluentIcons.chevron_right,
  'chevron.down': fl.FluentIcons.chevron_down,
  'xmark': fl.FluentIcons.chrome_close,
  'sidebar.left': fl.FluentIcons.open_pane,
  'sidebar.right': fl.FluentIcons.close_pane,
  'ellipsis': fl.FluentIcons.more,
  'ellipsis.circle': fl.FluentIcons.more,
  'magnifyingglass': fl.FluentIcons.search,
  'gearshape': fl.FluentIcons.settings,
  'gear': fl.FluentIcons.settings,
  'info.circle': fl.FluentIcons.info,
  'info': fl.FluentIcons.info,
  // Editing
  'plus': fl.FluentIcons.add,
  'plus.circle': fl.FluentIcons.add,
  'pencil': fl.FluentIcons.edit,
  'square.and.pencil': fl.FluentIcons.edit,
  'trash': fl.FluentIcons.delete,
  'square.and.arrow.up': fl.FluentIcons.share,
  'square.and.arrow.down': fl.FluentIcons.download,
  'arrow.up.circle': fl.FluentIcons.upload,
  'icloud.and.arrow.up': fl.FluentIcons.upload,
  'doc.on.doc': fl.FluentIcons.copy,
  'checkmark': fl.FluentIcons.check_mark,
  'checkmark.circle': fl.FluentIcons.accept,
  'arrow.clockwise': fl.FluentIcons.refresh,
  'arrow.triangle.2.circlepath': fl.FluentIcons.sync,
  'arrow.up.arrow.down': fl.FluentIcons.sort,
  'arrow.up.arrow.down.circle': fl.FluentIcons.sort,
  'line.3.horizontal.decrease': fl.FluentIcons.filter,
  'line.3.horizontal.decrease.circle': fl.FluentIcons.filter,
  'link': fl.FluentIcons.link,
  'paperplane': fl.FluentIcons.send,
  // Media
  'video': fl.FluentIcons.video,
  'camera': fl.FluentIcons.camera,
  'mic': fl.FluentIcons.microphone,
  'play': fl.FluentIcons.play,
  'play.fill': fl.FluentIcons.play_solid,
  'pause': fl.FluentIcons.pause,
  'pause.fill': fl.FluentIcons.pause,
  'stop': fl.FluentIcons.stop,
  'stop.fill': fl.FluentIcons.stop_solid,
  'stop.circle': fl.FluentIcons.stop,
  'photo': fl.FluentIcons.photo2,
  'photo.on.rectangle': fl.FluentIcons.photo_collection,
  'arrow.up.left.and.arrow.down.right': fl.FluentIcons.full_screen,
  'arrow.down.right.and.arrow.up.left': fl.FluentIcons.back_to_window,
  // People and things
  'person': fl.FluentIcons.contact,
  'person.2': fl.FluentIcons.people,
  'calendar': fl.FluentIcons.calendar,
  'clock': fl.FluentIcons.clock,
  'globe': fl.FluentIcons.globe,
  'envelope': fl.FluentIcons.mail,
  'heart': fl.FluentIcons.heart,
  'star': fl.FluentIcons.favorite_star,
  'lock': fl.FluentIcons.lock,
  'lock.open': fl.FluentIcons.unlock,
  'exclamationmark.triangle': fl.FluentIcons.warning,
};

/// Resolves an SF Symbol [name] to a Windows Fluent icon, then the Material
/// icon, then [fallback]. Same suffix stripping as the Material table: an
/// unmapped `foo.fill` / `foo.circle` resolves through plain `foo`.
IconData sfSymbolToFluentIcon(
  String name, {
  IconData fallback = fl.FluentIcons.more,
}) {
  final IconData? exact = kSfSymbolFluentIcons[name];
  if (exact != null) {
    return exact;
  }
  for (final String suffix in const <String>['.fill', '.circle.fill', '.circle']) {
    if (name.endsWith(suffix)) {
      final IconData? hit =
          kSfSymbolFluentIcons[name.substring(0, name.length - suffix.length)];
      if (hit != null) {
        return hit;
      }
    }
  }
  return sfSymbolToMaterialIcon(name, fallback: fallback);
}
