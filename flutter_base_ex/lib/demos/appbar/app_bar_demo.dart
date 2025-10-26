import 'package:base/base.dart' show isCupertinoMode;
import 'package:flutter/widgets.dart';

import '../demo_page.dart';
import '../demo_tile.dart';
import 'backdrop_filter_demo.dart';
import 'custom_height.dart';
import 'ios26_liquid_glass_demo.dart';
import 'news/news.dart';
import 'toolbar_opacity.dart';

/// AppBar Demo
class AppBarDemo extends StatelessWidget {
  const AppBarDemo({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<DemoTile> _demos = <DemoTile>[
      DemoTile(
        title: const Text('iOS 26 Liquid Glass'),
        page: iOS26LiquidGlassDemo(),
        fullscreenGackGesture: false,
      ),
      const DemoTile(
        title: Text('height'),
        page: CustomHeight(),
        fullscreenGackGesture: false,
      ),
      const DemoTile(
        title: Text('bottom'),
        page: News(),
        fullscreenGackGesture: false,
      ),
    ];

    if (isCupertinoMode) {
      _demos.add(
        const DemoTile(
          title: Text('toolbarOpacity'),
          page: ToolbarOpacity(),
        ),
      );
      _demos.add(
        const DemoTile(
          title: Text('backdropFilter'),
          page: BackdropFilterDemo(),
        ),
      );
    }
    return DemoPage(
      title: 'AppBar | NavBar',
      widgetName: 'BaseAppBar',
      materialDesc: 'Uses modified AppBar source code',
      cupertinoDesc: 'Uses modified CupertinoNavigationBar source code',
      parameterDesc: const <String, String>{
        'height': 'Custom height, AppBar default is 56, CupertinoNavigationBar default is 44.\n'
            'Can be set globally using BaseTheme.appBarHeight',
        'backdropFilter': 'Effective in Cupertino mode, default true, whether to add Gaussian blur\n'
            'CupertinoNavigationBar adds a Gaussian blur effect by default when background is transparent.'
            'Set to false to achieve fully transparent navigation bar\n'
            'Can be set globally using BaseTheme.backdropFilter',
        'liquidGlassBlurIntensity': 'iOS 26 Liquid Glass blur intensity (20-100 sigma)\n'
            'Controls the depth of the glass effect. Higher values create deeper blur.',
        'liquidGlassGradientOpacity': 'iOS 26 Liquid Glass gradient overlay opacity (0.0-0.5)\n'
            'Controls the strength of glass reflections and depth perception.',
        'liquidGlassDynamicBlur': 'iOS 26 Liquid Glass dynamic blur effects\n'
            'When enabled, blur intensity can respond to scroll position and interactions.',
        'bottom': 'Also effective in Cupertino mode, such as adding TabBar, will remove ripple and highlight effects.',
        'toolbarOpacity':
            'Also effective in Cupertino mode, simply sets the opacity of leading, middle, trailing text.',
        // 'autoSetBottomColor': 'Effective in Cupertino mode, default true, bottom automatically follows status bar text color.\n'
        //     'Can be set globally using BaseTheme.autoSetBottomColor',
        // 'autoSetMiddleColor': 'Effective in Cupertino mode, default true, middle automatically follows status bar text color.\n'
        //     'Can be set globally using BaseTheme.autoSetMiddleColor',
        // 'autoSetLeadingColor': 'Effective in Cupertino mode, default true, leading automatically follows status bar text color.\n'
        //     'Affected by autoSetTrailingColor\n'
        //     'Can be set globally using BaseTheme.autoSetLeadingColor',
        // 'autoSetTrailingColor': 'Effective in Cupertino mode, default true, trailing automatically follows status bar text color.\n'
        //     'Affected by autoSetLeadingColor\n'
        //     'Can be set globally using BaseTheme.autoSetTrailingColor',
      },
      demos: _demos,
    );
  }
}
