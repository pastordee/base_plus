import 'package:base/base.dart';
import 'package:flutter/material.dart';

import '../demo_page.dart';
import '../demo_tile.dart';
import 'alert_dialog_demo.dart';
import 'ios26_liquid_glass_dialog_demo.dart';

/// Dialo Demo
class DialogDemo extends StatelessWidget {
  DialogDemo({
    Key? key,
  }) : super(key: key);
  final List<DemoTile> _demos = <DemoTile>[
    DemoTile(
      title: const Text('iOS 26 Liquid Glass'),
      page: const iOS26LiquidGlassDialogDemo(),
      onTop: (BuildContext context) {
        BaseAlertDialog(
          enableLiquidGlass: true,
          glassOpacity: 0.8,
          reflectionIntensity: 0.6,
          refractionStrength: 0.4,
          adaptiveInteraction: true,
          contentHierarchy: true,
          hapticFeedback: true,
          title: const Text('Liquid Glass Demo'),
          content: const Text(
            'Experience iOS 26 Liquid Glass Dynamic Material with transparency, '
            'reflections, and real-time adaptability.',
          ),
          actions: [
            BaseDialogAction(
              enableLiquidGlass: true,
              adaptiveInteraction: true,
              hapticFeedback: true,
              buttonType: BaseDialogActionType.filled,
              child: const Text('Amazing!'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ).show<void>(context);
      },
    ),
    DemoTile(
      title: const Text('normal'),
      page: const AlertDialogDemo(),
      onTop: (BuildContext context) {
        const BaseAlertDialog(
          content: Text(
            'qwertyuioplkjhgfdsazxcvbnm',
            style: TextStyle(fontSize: 16.0),
          ),
        ).show<void>(context);
      },
    ),
    DemoTile(
      title: const Text('action'),
      page: const AlertDialogDemo(),
      onTop: (BuildContext context) {
        BaseAlertDialog(
          content: const Text('qwertyuioplkjhgfdsazxcvbnm'),
          actions: <Widget>[
            BaseDialogAction(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ).show<void>(
          context,
          barrierDismissible: false,
        );
      },
    ),
    DemoTile(
      title: const Text('actions'),
      page: const AlertDialogDemo(),
      onTop: (BuildContext context) {
        BaseAlertDialog(
          content: const Text('qwertyuioplkjhgfdsazxcvbnm'),
          actions: <Widget>[
            BaseDialogAction(
              child: const Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BaseDialogAction(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ).show<void>(
          context,
          barrierDismissible: false,
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Alert Dialog - Enhanced',
      widgetName: 'BaseAlertDialog with iOS 26 Liquid Glass',
      materialDesc: 'use AlertDialog with Material 3',
      cupertinoDesc: 'use CupertinoAlertDialog with Liquid Glass',
      tips: 'Enhanced with iOS 26 Liquid Glass Dynamic Material:\n'
          'BaseAlertDialog(\n\t\t\t'
          'enableLiquidGlass: true,\n\t\t\t'
          'glassOpacity: 0.8,\n\t\t\t'
          'reflectionIntensity: 0.6,\n\t\t\t'
          'content: ...\n\t\t\t'
          'actions: ...\n'
          ').show<void>(context);\n\n'
          'Material 3 Action Types:\n'
          'BaseDialogAction(\n\t\t\t'
          'buttonType: BaseDialogActionType.filled,\n\t\t\t'
          'enableLiquidGlass: true,\n\t\t\t'
          'child: Text("OK")\n'
          ');',
      demos: _demos,
    );
  }
}
