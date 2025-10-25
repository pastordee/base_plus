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
        title: const Text('ActionSheet - Native iOS Demo'),
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
        title: const Text('ActionSheet - Basic'),
        page: Scaffold(
          appBar: AppBar(
            title: const Text('ActionSheet - Basic'),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: BaseButton(
                  child: const Text(
                    'Basic ActionSheet',
                    style: TextStyle(color: Colors.black),
                  ),
                  color: Colors.white,
                  onPressed: () async {
                    await BaseActionSheet.show(
                      context: context,
                      title: 'Choose an Option',
                      message: 'Select one of the available options below.',
                      actions: [
                        const CNActionSheetAction(
                          title: 'Option 1',
                          style: CNActionSheetButtonStyle.defaultStyle,
                        ),
                        const CNActionSheetAction(
                          title: 'Option 2',
                          style: CNActionSheetButtonStyle.defaultStyle,
                        ),
                      ],
                      cancelAction: const CNActionSheetAction(
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
      ),
      DemoTile(
        title: const Text('ActionSheet - Destructive'),
        page: Scaffold(
          appBar: AppBar(
            title: const Text('ActionSheet - Destructive'),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: BaseButton(
                  child: const Text(
                    'Destructive ActionSheet',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                  onPressed: () async {
                    await BaseActionSheet.showConfirmation(
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
      ),
    ];
    return DemoPage(
      title: 'ActionSheet',
      widgetName: 'BaseActionSheet',
      materialDesc: 'Native iOS action sheets with Material bottom sheet fallback',
      cupertinoDesc: 'True native iOS action sheets via platform channels',
      tips: 'BaseActionSheet.show(\n'
          '  context: context,\n'
          '  title: \'Title\',\n'
          '  message: \'Message\',\n'
          '  actions: [\n'
          '    CNActionSheetAction(\n'
          '      title: \'Action\',\n'
          '      onPressed: () { },\n'
          '    ),\n'
          '  ],\n'
          '  cancelAction: CNActionSheetAction(\n'
          '    title: \'Cancel\',\n'
          '  ),\n'
          ');',
      demos: _demos,
    );
  }
}
