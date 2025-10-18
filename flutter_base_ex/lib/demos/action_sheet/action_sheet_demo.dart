import 'package:base/base.dart';
import 'package:flutter/material.dart';

import '../demo_page.dart';
import '../demo_tile.dart';
import 'cn_action_sheet_demo.dart';

/// ActionSheet Demo
class ActionSheetDemo extends StatelessWidget {
  const ActionSheetDemo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DemoTile> _demos = <DemoTile>[
      DemoTile(
        title: const Text('CNActionSheet - Demo Page'),
        page: const CNActionSheetDemo(),
        onTop: (BuildContext context) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CNActionSheetDemo(),
            ),
          );
        },
      ),
      DemoTile(
        title: const Text('CNActionSheet - Basic'),
        page: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: BaseButton(
                child: const Text(
                  'Basic CNActionSheet',
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.white,
                onPressed: () async {
                  await BaseCNActionSheet.show(
                    context: context,
                    title: 'Choose an Option',
                    message: 'Select one of the available options below.',
                    actions: [
                      CNActionSheetAction(
                        title: 'Option 1',
                        style: CNActionSheetButtonStyle.defaultStyle,
                      ),
                      CNActionSheetAction(
                        title: 'Option 2',
                        style: CNActionSheetButtonStyle.defaultStyle,
                      ),
                    ],
                    cancelAction: CNActionSheetAction(
                      title: 'Cancel',
                      style: CNActionSheetButtonStyle.cancel,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      DemoTile(
        title: const Text('CNActionSheet - Destructive'),
        page: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: BaseButton(
                child: const Text(
                  'Destructive CNActionSheet',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                onPressed: () async {
                  await BaseCNActionSheet.showConfirmation(
                    context: context,
                    title: 'Delete Draft?',
                    message: 'This action cannot be undone.',
                    confirmTitle: 'Delete Draft',
                    cancelTitle: 'Keep Draft',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      DemoTile(
        page: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: BaseButton(
                child: const Text(
                  'ActionSheet',
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.white,
                onPressed: () {
                  BaseActionSheet(
                    title: const Text('标题'),
                    message: const Text('内容'),
                    actions: <Widget>[
                      BaseActionSheetAction(
                        child: const Text('选项1'),
                        onPressed: () {},
                      ),
                      BaseActionSheetAction(
                        child: const Text('选项2'),
                        onPressed: () {},
                        isDefaultAction: true,
                      ),
                      BaseActionSheetAction(
                        child: const Text('选项3'),
                        onPressed: () {},
                        isDestructiveAction: true,
                      ),
                    ],
                    cancelButton: BaseActionSheetAction(
                      child: const Text('取消'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ).show<void>(context);
                },
              ),
            ),
          ],
        ),
      )
    ];
    return DemoPage(
      title: 'ActionSheet',
      widgetName: 'BaseActionSheet',
      materialDesc: 'use custom BottomSheet',
      cupertinoDesc: 'use CupertinoActionSheet',
      tips: 'Use like: \nBaseActionSheet('
          '\n\t\t\ttitle: ...\n\t\t\t'
          'actions: ...\n'
          ').show<void>(context);',
      demos: _demos,
    );
  }
}
