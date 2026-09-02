import 'package:material_ui/material_ui.dart';
import 'package:cupertino_native_extra/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseSegmentedControl - Cross-platform segmented control with native iOS support
///
/// Uses CNSegmentedControl (Cupertino Native) for iOS - provides true native iOS appearance
/// with built-in liquid glass effects and native rendering.
/// Uses Material SegmentedButton for Android and other platforms.
///
/// *** use cupertino = { forceUseMaterial: true } force use SegmentedButton on iOS
/// *** use material = { forceUseCupertino: true } force use CNSegmentedControl on Android
///
/// Features:
/// - Native iOS segmented control via CNSegmentedControl (cupertino_native package)
/// - Material Design SegmentedButton for Android
/// - Consistent API across platforms
/// - Built-in liquid glass effects on iOS (no manual wrapper needed)
///
/// Example:
/// ```dart
/// BaseSegmentedControl(
///   labels: const ['One', 'Two', 'Three'],
///   selectedIndex: _selectedIndex,
///   onValueChanged: (i) => setState(() => _selectedIndex = i),
/// )
/// ```
///
/// Updated: 2024.10.25 - Renamed from BaseCNSegmentedControl for consistency
class BaseSegmentedControl extends BaseStatelessWidget {
  const BaseSegmentedControl({
    Key? key,
    required this.labels,
    required this.selectedIndex,
    required this.onValueChanged,
    this.labelSize,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// List of segment labels
  final List<String> labels;

  /// Currently selected segment index
  final int selectedIndex;

  /// Called when a segment is selected
  final ValueChanged<int> onValueChanged;

  /// Size of the segment labels. Applies on both platforms.
  final double? labelSize;

  @override
  Widget buildByCupertino(BuildContext context) {
    return CNSegmentedControl(
      labels: valueOf('labels', labels),
      selectedIndex: valueOf('selectedIndex', selectedIndex),
      onValueChanged: valueOf('onValueChanged', onValueChanged),
      labelSize: valueOf('labelSize', labelSize),
    );
  }

  @override
  Widget buildByMaterial(BuildContext context) {
    final selectedIdx = valueOf('selectedIndex', selectedIndex);
    final labelsList = valueOf('labels', labels);
    // labelSize was honoured on iOS and silently dropped here, so a caller that
    // shrank its labels to make them fit got no effect on Android at all.
    final double? size = valueOf('labelSize', labelSize);

    final scheme = Theme.of(context).colorScheme;

    // Material draws a hard outline around the whole control AND a divider
    // between every segment, which next to the rest of this app — and next to
    // the same control on iOS, where CNSegmentedControl has neither — reads as
    // a cage around the words. Taking the outline off takes the dividers with
    // it, since SegmentedButton paints them from the same BorderSide.
    //
    // What's left needs something to sit in or the tabs stop looking tappable,
    // so the control gets the soft rounded track iOS gives it, with the
    // selected segment picked out inside it.
    //
    // The tints are taken from onSurface and primary rather than the surface
    // roles, because a surface-on-surface pill is only visible if the theme
    // happens to separate those two colours — the first attempt used
    // surfaceContainerHighest for the track and surface for the selected
    // segment, and on this app's light sheet both resolved to white, leaving
    // four labels floating with no control around them at all. A tint of the
    // accent can't disappear that way in either theme, and it matches the
    // stepper sitting next to this control, which already uses primary at 12%.
    return Container(
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(22),
      ),
      // No inset. An inset track leaves a band of itself above and below the
      // selected segment, so the selection reads as a small pill floating in a
      // taller bar rather than as the tab itself being on.
      child: SegmentedButton<int>(
      style: ButtonStyle(
        side: const WidgetStatePropertyAll(BorderSide.none),
        // Same radius as the track, so a selected end segment sits flush into
        // the corner instead of cutting across it.
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary.withValues(alpha: 0.12)
              : Colors.transparent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurface.withValues(alpha: 0.7),
        ),
        overlayColor: WidgetStatePropertyAll(
          scheme.primary.withValues(alpha: 0.08),
        ),
        // Material's default tap target adds 48dp of height and a wide
        // horizontal inset to every segment. That is what was still holding
        // the labels apart after the outline came off, and on a four-tab
        // control it is also width the longest label needs.
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 4),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      // Material 3 puts a checkmark in the selected segment and reserves the
      // room for it in every segment, so a four-tab control gives up real width
      // to an icon that only repeats what the filled background already says.
      // Off, the labels get that width back — which is the difference between
      // fitting and not on a narrow phone.
      showSelectedIcon: false,
      segments: List.generate(
        labelsList.length,
        (index) => ButtonSegment<int>(
          value: index,
          // One line, always. A bare Text wraps, and a segment is nowhere near
          // tall enough for two: "Books" came out as "Boo" over "ks".
          label: Text(
            labelsList[index],
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: size == null ? null : TextStyle(fontSize: size),
          ),
        ),
      ),
      selected: {selectedIdx},
      onSelectionChanged: (Set<int> newSelection) {
        if (newSelection.isNotEmpty) {
          valueOf('onValueChanged', onValueChanged)?.call(newSelection.first);
        }
      },
      ),
    );
  }
}
