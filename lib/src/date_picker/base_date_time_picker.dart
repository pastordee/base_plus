import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mode/base_mode.dart';

/// What a [BaseDateTimePicker] / [BaseDateTimePickerView] lets the user choose.
enum BaseDateTimePickerMode { date, time, dateAndTime }

CupertinoDatePickerMode _cupertinoMode(BaseDateTimePickerMode mode) {
  switch (mode) {
    case BaseDateTimePickerMode.date:
      return CupertinoDatePickerMode.date;
    case BaseDateTimePickerMode.time:
      return CupertinoDatePickerMode.time;
    case BaseDateTimePickerMode.dateAndTime:
      return CupertinoDatePickerMode.dateAndTime;
  }
}

DateTime _clamp(DateTime value, DateTime? min, DateTime? max) {
  if (min != null && value.isBefore(min)) {
    return min;
  }
  if (max != null && value.isAfter(max)) {
    return max;
  }
  return value;
}

DateTime _combine(DateTime date, TimeOfDay time) =>
    DateTime(date.year, date.month, date.day, time.hour, time.minute);

/// An adaptive, **embeddable** date/time picker surface.
///
/// Renders the platform-native inline picker and reports every change live via
/// [onChanged] — a Cupertino wheel on iOS, and on Material a `CalendarDatePicker`
/// (plus an inline time row when the mode includes time). Use this when you want
/// the picker to live inside your own sheet/layout and bind a value as the user
/// scrolls (e.g. a date-of-birth field). For a self-contained modal that returns
/// a value on "Done", use [BaseDateTimePicker.show] instead.
class BaseDateTimePickerView extends StatefulWidget {
  const BaseDateTimePickerView({
    Key? key,
    required this.onChanged,
    this.mode = BaseDateTimePickerMode.date,
    this.initial,
    this.minimum,
    this.maximum,
    this.minuteInterval = 1,
    this.use24hFormat,
    this.height = 216,
    this.backgroundColor,
  }) : super(key: key);

  final BaseDateTimePickerMode mode;
  final DateTime? initial;
  final DateTime? minimum;
  final DateTime? maximum;
  final int minuteInterval;
  final bool? use24hFormat;

  /// Height reserved for the Cupertino wheel (ignored on Material).
  final double height;

  final Color? backgroundColor;

  /// Called on every change with the currently-selected value.
  final ValueChanged<DateTime> onChanged;

  @override
  State<BaseDateTimePickerView> createState() => _BaseDateTimePickerViewState();
}

class _BaseDateTimePickerViewState extends State<BaseDateTimePickerView> {
  late DateTime _value;

  @override
  void initState() {
    super.initState();
    _value = _clamp(
      widget.initial ?? DateTime.now(),
      widget.minimum,
      widget.maximum,
    );
  }

  void _emit(DateTime v) {
    _value = _clamp(v, widget.minimum, widget.maximum);
    widget.onChanged(_value);
  }

  bool get _hasDate => widget.mode != BaseDateTimePickerMode.time;
  bool get _hasTime => widget.mode != BaseDateTimePickerMode.date;

  @override
  Widget build(BuildContext context) {
    if (isCupertinoMode) {
      return _buildCupertino(context);
    }
    return _buildMaterial(context);
  }

  Widget _buildCupertino(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: CupertinoDatePicker(
        backgroundColor: widget.backgroundColor,
        mode: _cupertinoMode(widget.mode),
        initialDateTime: _value,
        minimumDate: widget.minimum,
        maximumDate: widget.maximum,
        minuteInterval: widget.minuteInterval,
        use24hFormat:
            widget.use24hFormat ?? MediaQuery.of(context).alwaysUse24HourFormat,
        onDateTimeChanged: _emit,
      ),
    );
  }

  Widget _buildMaterial(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime first = widget.minimum ?? DateTime(now.year - 100);
    final DateTime last = widget.maximum ?? DateTime(now.year + 100);

    // Time-only: no inline Material spinner exists, so surface a tappable field
    // that opens the standard time dialog.
    if (!_hasDate) {
      return _TimeRow(
        value: _value,
        use24hFormat: widget.use24hFormat,
        onPick: (TimeOfDay t) => _emit(_combine(_value, t)),
      );
    }

    final CalendarDatePicker calendar = CalendarDatePicker(
      initialDate: _clamp(_value, first, last),
      firstDate: first,
      lastDate: last,
      onDateChanged: (DateTime d) => _emit(
        _hasTime ? _combine(d, TimeOfDay.fromDateTime(_value)) : d,
      ),
    );

    // Date-only: let the calendar take its natural size.
    if (!_hasTime) {
      return calendar;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(child: calendar),
        _TimeRow(
          value: _value,
          use24hFormat: widget.use24hFormat,
          onPick: (TimeOfDay t) => _emit(_combine(_value, t)),
        ),
      ],
    );
  }
}

/// Inline "pick a time" row for the Material path (Material has no inline time
/// spinner, so this opens the standard time dialog).
class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.value,
    required this.onPick,
    this.use24hFormat,
  });

  final DateTime value;
  final ValueChanged<TimeOfDay> onPick;
  final bool? use24hFormat;

  @override
  Widget build(BuildContext context) {
    final TimeOfDay t = TimeOfDay.fromDateTime(value);
    return ListTile(
      leading: const Icon(Icons.access_time),
      title: Text(MaterialLocalizations.of(context)
          .formatTimeOfDay(t, alwaysUse24HourFormat: use24hFormat ?? false)),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () async {
        final TimeOfDay? picked =
            await showTimePicker(context: context, initialTime: t);
        if (picked != null) {
          onPick(picked);
        }
      },
    );
  }
}

/// Adaptive date/time picker presented as a modal that resolves to the chosen
/// [DateTime] (or `null` if cancelled).
///
/// - **iOS / Cupertino:** a bottom sheet with a Cancel / title / Done header
///   above a live [CupertinoDatePicker]; the value commits on **Done**.
/// - **Android / Material:** the native `showDatePicker` / `showTimePicker`
///   dialogs (both, in order, for [BaseDateTimePickerMode.dateAndTime]).
///
/// For an inline, live-binding picker embedded in your own layout, use
/// [BaseDateTimePickerView].
class BaseDateTimePicker {
  const BaseDateTimePicker._();

  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initial,
    DateTime? minimum,
    DateTime? maximum,
    BaseDateTimePickerMode mode = BaseDateTimePickerMode.dateAndTime,
    int minuteInterval = 1,
    bool? use24hFormat,
    String? title,
    String? confirmText,
    String? cancelText,
    bool useRootNavigator = true,
  }) {
    if (isCupertinoMode) {
      return _showCupertino(
        context,
        initial: initial,
        minimum: minimum,
        maximum: maximum,
        mode: mode,
        minuteInterval: minuteInterval,
        use24hFormat: use24hFormat,
        title: title,
        confirmText: confirmText,
        cancelText: cancelText,
        useRootNavigator: useRootNavigator,
      );
    }
    return _showMaterial(
      context,
      initial: initial,
      minimum: minimum,
      maximum: maximum,
      mode: mode,
      useRootNavigator: useRootNavigator,
    );
  }

  static Future<DateTime?> _showCupertino(
    BuildContext context, {
    required DateTime? initial,
    required DateTime? minimum,
    required DateTime? maximum,
    required BaseDateTimePickerMode mode,
    required int minuteInterval,
    required bool? use24hFormat,
    required String? title,
    required String? confirmText,
    required String? cancelText,
    required bool useRootNavigator,
  }) {
    return showCupertinoModalPopup<DateTime>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext ctx) => _CupertinoPickerSheet(
        initial: initial,
        minimum: minimum,
        maximum: maximum,
        mode: mode,
        minuteInterval: minuteInterval,
        use24hFormat: use24hFormat,
        title: title,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }

  static Future<DateTime?> _showMaterial(
    BuildContext context, {
    required DateTime? initial,
    required DateTime? minimum,
    required DateTime? maximum,
    required BaseDateTimePickerMode mode,
    required bool useRootNavigator,
  }) async {
    final DateTime now = DateTime.now();
    final DateTime base = initial ?? now;
    final DateTime first = minimum ?? DateTime(now.year - 100);
    final DateTime last = maximum ?? DateTime(now.year + 100);

    DateTime result = base;

    if (mode != BaseDateTimePickerMode.time) {
      final DateTime? date = await showDatePicker(
        context: context,
        useRootNavigator: useRootNavigator,
        initialDate: _clamp(base, first, last),
        firstDate: first,
        lastDate: last,
      );
      if (date == null) {
        return null;
      }
      result = DateTime(
          date.year, date.month, date.day, result.hour, result.minute);
    }

    if (mode != BaseDateTimePickerMode.date) {
      if (!context.mounted) {
        return null;
      }
      final TimeOfDay? time = await showTimePicker(
        context: context,
        useRootNavigator: useRootNavigator,
        initialTime: TimeOfDay.fromDateTime(result),
      );
      if (time == null) {
        return null;
      }
      result = _combine(result, time);
    }

    return _clamp(result, minimum, maximum);
  }
}

/// Cupertino modal body: header (Cancel / title / Done) + live wheel.
class _CupertinoPickerSheet extends StatefulWidget {
  const _CupertinoPickerSheet({
    required this.initial,
    required this.minimum,
    required this.maximum,
    required this.mode,
    required this.minuteInterval,
    required this.use24hFormat,
    required this.title,
    required this.confirmText,
    required this.cancelText,
  });

  final DateTime? initial;
  final DateTime? minimum;
  final DateTime? maximum;
  final BaseDateTimePickerMode mode;
  final int minuteInterval;
  final bool? use24hFormat;
  final String? title;
  final String? confirmText;
  final String? cancelText;

  @override
  State<_CupertinoPickerSheet> createState() => _CupertinoPickerSheetState();
}

class _CupertinoPickerSheetState extends State<_CupertinoPickerSheet> {
  late DateTime _value;

  @override
  void initState() {
    super.initState();
    _value = _clamp(
      widget.initial ?? DateTime.now(),
      widget.minimum,
      widget.maximum,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = CupertinoDynamicColor.resolve(
      CupertinoColors.systemBackground,
      context,
    );
    // Material ancestor gives child text a proper DefaultTextStyle — without it
    // the bare title Text renders with the debug fallback (oversized, yellow
    // double-underline) inside a Cupertino modal popup.
    return Material(
      color: bg,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _header(context),
            const Divider(height: 1),
            BaseDateTimePickerView(
              mode: widget.mode,
              initial: _value,
              minimum: widget.minimum,
              maximum: widget.maximum,
              minuteInterval: widget.minuteInterval,
              use24hFormat: widget.use24hFormat,
              backgroundColor: bg,
              onChanged: (DateTime v) => _value = v,
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onPressed: () => Navigator.of(context).pop<DateTime>(null),
            child: Text(widget.cancelText ?? 'Cancel'),
          ),
          if (widget.title != null)
            Expanded(
              child: Text(
                widget.title!,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),
            ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onPressed: () => Navigator.of(context).pop<DateTime>(_value),
            child: Text(
              widget.confirmText ?? 'Done',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
