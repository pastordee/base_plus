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

  /// Size of the segment labels (iOS only)
  /// Applies to CNSegmentedControl on iOS
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

    return SegmentedButton<int>(
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
    );
  }
}
