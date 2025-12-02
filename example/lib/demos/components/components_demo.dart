import 'package:base_plus/base.dart';
import '../../provider/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'drawer_demo.dart';
import 'cupertino_interactive_keyboard_demo.dart';
// import 'expansion_demo.dart';

/// Componentes 说明
class ComponentesDemo extends StatelessWidget {
  const ComponentesDemo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(
        title: Text('Components'),
      ),
      body: Consumer<AppProvider>(
        builder: (_, AppProvider appProvider, __) {
          return ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              BaseTile(
                titleText: 'Drawer',
                trailing: const BaseIcon(
                  icon: CupertinoIcons.right_chevron,
                  color: Colors.grey,
                ),
                onTap: () {
                  BaseRoute<void>(
                    builder: (_) => const DrawerDemo(),
                  ).push(context);
                },
              ),
              BaseTile(
                titleText: 'Interactive Keyboard',
                subtitle: const Text('iOS-style keyboard dismissal'),
                trailing: const BaseIcon(
                  icon: CupertinoIcons.right_chevron,
                  color: Colors.grey,
                ),
                onTap: () {
                  BaseRoute<void>(
                    builder: (_) => const CupertinoInteractiveKeyboardDemo(),
                  ).push(context);
                },
              ),
              BaseTile(
                titleText: 'Keyboard Variations',
                subtitle: const Text('Different toolbar styles'),
                trailing: const BaseIcon(
                  icon: CupertinoIcons.right_chevron,
                  color: Colors.grey,
                ),
                onTap: () {
                  BaseRoute<void>(
                    builder: (_) => const CupertinoInteractiveKeyboardVariationsDemo(),
                  ).push(context);
                },
              ),
              // BaseTile(
              //   titleText: 'expansion',
              //   trailing: const BaseIcon(
              //     icon: CupertinoIcons.right_chevron,
              //     color: Colors.grey,
              //   ),
              //   onTap: () {
              //     BaseRoute<void>(
              //       builder: (_) => ExpansionDemo(),
              //     ).push(context);
              //   },
              // ),
            ],
          );
        },
      ),
      baseParam: BaseParam(
        cupertino: const <String, dynamic>{
          'backgroundColor': CupertinoColors.systemGroupedBackground,
        },
      ),
    );
  }
}
