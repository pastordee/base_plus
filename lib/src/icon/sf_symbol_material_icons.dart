// Created: 2026-08-21
import 'package:flutter/material.dart';

/// A single, comprehensive SF Symbol → Material [IconData] mapping shared by
/// every base_plus component that renders an iOS SF Symbol on Android
/// (navigation bar, toolbar, tab bar, icon button, native sheet, …).
///
/// Historically each component kept its own small, incomplete map and fell back
/// to a generic dot (`Icons.circle`) for anything it didn't know — so many SF
/// Symbols showed up as a plain dot on Android. Centralising the table here
/// means a symbol added once is understood everywhere.
///
/// The map is deliberately a superset: it covers every SF Symbol used across the
/// app plus common variants. When adding a new SF Symbol anywhere, add its
/// Material equivalent here rather than to a component-local map.
const Map<String, IconData> kSfSymbolMaterialIcons = <String, IconData>{
  // ── Navigation / chevrons / arrows ──────────────────────────────────────
  'chevron.left': Icons.chevron_left,
  'chevron.right': Icons.chevron_right,
  'chevron.backward': Icons.chevron_left,
  'chevron.forward': Icons.chevron_right,
  'chevron.up': Icons.keyboard_arrow_up,
  'chevron.down': Icons.keyboard_arrow_down,
  'arrow.left': Icons.arrow_back,
  'arrow.right': Icons.arrow_forward,
  'arrow.up': Icons.arrow_upward,
  'arrow.down': Icons.arrow_downward,
  'arrow.up.left': Icons.north_west,
  'arrow.down.right': Icons.south_east,
  'arrow.down.circle': Icons.arrow_circle_down,
  'arrow.up.circle': Icons.arrow_circle_up,
  'arrow.up.arrow.down': Icons.swap_vert,
  'arrow.up.left.and.arrow.down.right': Icons.open_in_full,
  'arrow.clockwise': Icons.refresh,
  'arrow.counterclockwise': Icons.refresh,
  'arrow.uturn.backward': Icons.undo,
  'arrow.uturn.forward': Icons.redo,
  'refresh': Icons.refresh,

  // ── Common actions ──────────────────────────────────────────────────────
  'plus': Icons.add,
  'plus.circle': Icons.add_circle,
  'plus.circle.fill': Icons.add_circle,
  'minus': Icons.remove,
  'minus.circle': Icons.remove_circle,
  'xmark': Icons.close,
  'xmark.circle': Icons.cancel,
  'clear': Icons.clear,
  'checkmark': Icons.check,
  'checkmark.circle': Icons.check_circle,
  'checkmark.circle.fill': Icons.check_circle,

  // ── Settings / filters / sliders ────────────────────────────────────────
  'gear': Icons.settings,
  'gearshape': Icons.settings,
  'gearshape.fill': Icons.settings,
  'slider.horizontal.3': Icons.tune,
  'slider.horizontal': Icons.tune,
  'filter': Icons.filter_list,
  'line.3.horizontal.decrease': Icons.filter_list,
  'line.3.horizontal.decrease.circle': Icons.filter_list,
  'line.horizontal.3.decrease.circle': Icons.filter_list,

  // ── Menus & layout ──────────────────────────────────────────────────────
  'ellipsis': Icons.more_horiz,
  'ellipsis.circle': Icons.more_vert,
  'ellipsis.circle.fill': Icons.more_vert,
  'line.3.horizontal': Icons.menu,
  'apps': Icons.apps,
  'apps.iphone': Icons.apps,
  'square.grid.2x2': Icons.grid_view,
  'square.grid.3x2': Icons.grid_on,
  'grid': Icons.grid_view,
  'list.bullet': Icons.list,
  'list.number': Icons.format_list_numbered,
  'rectangle.expand.vertical': Icons.unfold_more,

  // ── Favorites & interactions ────────────────────────────────────────────
  'star': Icons.star_border,
  'star.fill': Icons.star,
  'heart': Icons.favorite_border,
  'heart.fill': Icons.favorite,
  'bookmark': Icons.bookmark_border,
  'bookmark.fill': Icons.bookmark,
  'flag': Icons.flag,
  'pin': Icons.push_pin,
  'hands.sparkles': Icons.volunteer_activism,
  'hand.raised': Icons.pan_tool,

  // ── Search ──────────────────────────────────────────────────────────────
  'magnifyingglass': Icons.search,
  'magnifyingglass.circle': Icons.search,

  // ── Home & places ───────────────────────────────────────────────────────
  'house': Icons.home,
  'house.fill': Icons.home,
  'building.2': Icons.apartment,
  'location': Icons.location_on,
  'location.circle': Icons.location_on,
  'location.fill': Icons.location_on,

  // ── Communication ───────────────────────────────────────────────────────
  'envelope': Icons.email,
  'envelope.open': Icons.mail_outline,
  'phone': Icons.phone,
  'phone.fill': Icons.phone,
  'message': Icons.message,
  'message.circle': Icons.chat_bubble,
  'paperplane': Icons.send,
  'paperplane.fill': Icons.send,
  'bell': Icons.notifications,
  'bell.fill': Icons.notifications_active,
  'bell.badge': Icons.notifications_active,
  'exclamationmark.bubble': Icons.report,
  'exclamationmark.triangle': Icons.warning_amber,
  'questionmark.circle': Icons.help_outline,
  'info.circle': Icons.info_outline,
  'dot.radiowaves.up.forward': Icons.wifi_tethering,

  // ── Media ───────────────────────────────────────────────────────────────
  'camera': Icons.camera_alt,
  'camera.fill': Icons.camera_alt,
  'photo': Icons.photo,
  'photo.on.rectangle': Icons.photo_library,
  'photo.fill': Icons.image,
  'video': Icons.videocam,
  'video.fill': Icons.videocam,
  'music.note': Icons.music_note,
  'music.note.list': Icons.playlist_play,
  'play.fill': Icons.play_arrow,
  'play.rectangle.on.rectangle': Icons.smart_display,
  'eye.fill': Icons.visibility,
  'eye': Icons.visibility,
  'eye.slash': Icons.visibility_off,
  'mute': Icons.volume_off,
  'speaker.slash': Icons.volume_off,
  'tv': Icons.tv,
  'tv.badge.wifi': Icons.cast,
  'pip.enter': Icons.picture_in_picture_alt,

  // ── Files & folders ─────────────────────────────────────────────────────
  'doc': Icons.insert_drive_file,
  'doc.on.doc': Icons.content_copy,
  'doc.on.clipboard': Icons.content_paste,
  'doc.circle': Icons.insert_drive_file,
  'folder': Icons.folder,
  'folder.fill': Icons.folder,
  'folder.badge.plus': Icons.create_new_folder,
  'note.text.badge.plus': Icons.note_add,
  'diskette': Icons.save,
  'tray.and.arrow.down': Icons.move_to_inbox,
  'square.and.arrow.down.badge.clock.fill': Icons.save_alt,

  // ── Edit & text ─────────────────────────────────────────────────────────
  'pencil': Icons.edit,
  'pencil.circle': Icons.edit,
  'pencil.circle.fill': Icons.edit,
  'edit': Icons.edit,
  'trash': Icons.delete,
  'trash.circle': Icons.delete_outline,
  'trash.circle.fill': Icons.delete,
  'trash.slash': Icons.delete_outline,
  'bold': Icons.format_bold,
  'italic': Icons.format_italic,
  'underline': Icons.format_underlined,
  'strikethrough': Icons.strikethrough_s,
  'textformat.size': Icons.text_fields,
  'textformat': Icons.text_fields,

  // ── Links & sharing ─────────────────────────────────────────────────────
  'link': Icons.link,
  'link.circle': Icons.link,
  'paperclip': Icons.attach_file,
  'square.and.arrow.up': Icons.share,
  'square.and.arrow.up.circle': Icons.share,
  'square.and.arrow.down': Icons.download,
  'export': Icons.upload,

  // ── Time & date ─────────────────────────────────────────────────────────
  'clock': Icons.schedule,
  'clock.fill': Icons.access_time,
  'alarm': Icons.alarm,
  'calendar': Icons.calendar_today,
  'calendar.circle': Icons.calendar_today,
  'calendar.badge.plus': Icons.event,

  // ── User & account ──────────────────────────────────────────────────────
  'person': Icons.person,
  'person.fill': Icons.person,
  'person.circle': Icons.account_circle,
  'person.circle.fill': Icons.account_circle,
  'person.3': Icons.groups,
  'person.fill.xmark': Icons.person_off,
  'person.badge.shield.exclamationmark': Icons.admin_panel_settings,
  'person.crop.circle.badge.exclamationmark': Icons.report_gmailerrorred,
  'people': Icons.group,
  'people.fill': Icons.group,

  // ── Books & study ───────────────────────────────────────────────────────
  'book': Icons.menu_book,
  'book.closed': Icons.menu_book,
  'book.fill': Icons.menu_book,
  'chart.bar': Icons.bar_chart,
  'chart.bar.fill': Icons.bar_chart,

  // ── Appearance / misc ───────────────────────────────────────────────────
  'paintpalette': Icons.palette,
  'paintpalette.fill': Icons.palette,
  'paintbrush': Icons.brush,
  'paintbrush.fill': Icons.brush,
  'sun.max': Icons.wb_sunny,
  'sun.max.fill': Icons.wb_sunny,
  'moon': Icons.brightness_2,
  'moon.fill': Icons.brightness_2,
};

/// Resolves an SF Symbol [name] to a Material [IconData].
///
/// Lookup order: exact match → the same name with a trailing `.fill` / `.circle`
/// / `.circle.fill` variant stripped → [fallback]. This means an unmapped
/// `foo.fill` still resolves if plain `foo` is mapped, so the generic-dot
/// fallback is hit far less often.
IconData sfSymbolToMaterialIcon(
  String name, {
  IconData fallback = Icons.circle,
}) {
  final exact = kSfSymbolMaterialIcons[name];
  if (exact != null) return exact;

  // Progressively strip common trailing modifiers and retry.
  for (final suffix in const ['.fill', '.circle.fill', '.circle']) {
    if (name.endsWith(suffix)) {
      final base = name.substring(0, name.length - suffix.length);
      final hit = kSfSymbolMaterialIcons[base];
      if (hit != null) return hit;
    }
  }
  return fallback;
}
