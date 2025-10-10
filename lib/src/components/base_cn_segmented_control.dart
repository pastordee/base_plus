import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../base_param.dart';
import '../base_stateless_widget.dart';

/// BaseCNSegmentedControl - Native iOS segmented control using CNSegmentedControl
/// 
/// Provides enhanced segmented control with native iOS appearance
/// Falls back to Material SegmentedButton on Android
/// 
/// Example:
/// ```dart
/// BaseCNSegmentedControl(
///   labels: const ['One', 'Two', 'Three'],
///   selectedIndex: _selectedIndex,
///   onValueChanged: (i) => setState(() => _selectedIndex = i),
/// )
/// ```
class BaseCNSegmentedControl extends BaseStatelessWidget {
  const BaseCNSegmentedControl({
    Key? key,
    required this.labels,
    required this.selectedIndex,
    required this.onValueChanged,
    BaseParam? baseParam,
  }) : super(key: key, baseParam: baseParam);

  /// List of segment labels
  final List<String> labels;

  /// Currently selected segment index
  final int selectedIndex;

  /// Called when a segment is selected
  final ValueChanged<int> onValueChanged;

  @override
  Widget buildByCupertino(BuildContext context) {
    return CNSegmentedControl(
      labels: valueOf('labels', labels),
      selectedIndex: valueOf('selectedIndex', selectedIndex),
      onValueChanged: valueOf('onValueChanged', onValueChanged),
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
