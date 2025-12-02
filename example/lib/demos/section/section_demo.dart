import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../demo_page.dart';
import '../demo_tile.dart';
import 'wechat_profile.dart';

/// Section documentation
class SectionDemo extends StatelessWidget {
  const SectionDemo({
    Key? key,
  }) : super(key: key);
  List<DemoTile> get _demos => const <DemoTile>[
        DemoTile(
          title: Text('WeChat Profile Page Imitation'),
          page: WechatProfile(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Section & Tile',
      widgetName: 'BaseSection, BaseTile',
      materialDesc: 'BaseSection: use custom Container\n'
          'BaseTile: use ListTile',
      cupertinoDesc: 'BaseSection: use custom Container\n'
          'BaseTile: use custom InkWell, removes ripple effect, has 200ms delay for highlight on press',
      demos: _demos,
    );
  }
}
