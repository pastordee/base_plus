import 'package:base/base.dart';
import 'safeArea_demo.dart';
import 'package:flutter/widgets.dart';

import '../demo_page.dart';
import '../demo_tile.dart';

/// Scaffold Demo
class ScaffoldDemo extends StatelessWidget {
  const ScaffoldDemo({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<DemoTile> _demos = <DemoTile>[];
    if (isCupertinoMode) {
      _demos.add(const DemoTile(
        title: Text('safeArea scaffold'),
        page: SateAreaDemo(),
      ));
    }
    return DemoPage(
      widgetName: 'BaseScaffold',
      materialDesc: 'use Scaffold',
      cupertinoDesc: 'CupertinoPageScaffold',
      parameterDesc: const <String, String>{
        'safeAreaTop': 'Effective in Cupertino mode, default is false. '
            'Equivalent to SafeArea\'s top. When the status bar background may be transparent, '
            'and no components like BoxScrollView that automatically set top padding are used, '
            'you can set this to true, and the page will start below the navigation bar.',
        'safeAreaBottom': 'Effective in Cupertino mode, default is false. Equivalent to SafeArea\'s bottom. '
            'Set to true to prevent the page from being obscured by the Home Indicator at the bottom of iPhone.',
      },
      demos: _demos,
    );
  }
}
