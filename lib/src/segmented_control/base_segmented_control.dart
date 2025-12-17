import 'package:flutter/material.dart';
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

    return SegmentedButton<int>(
      segments: List.generate(
        labelsList.length,
        (index) => ButtonSegment<int>(
          value: index,
          label: Text(labelsList[index]),
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
