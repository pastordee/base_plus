import 'package:base/base.dart';
import '../../iconfont/iconfont.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

import '../demo_page.dart';
import '../demo_tile.dart';

/// Tab Scaffold Demo
class TabScaffoldDemo extends StatelessWidget {
  const TabScaffoldDemo({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<DemoTile> _demos = <DemoTile>[
      DemoTile(
        title: const Text('tab scaffold'),
        page: _Demo(),
      )
    ];
    return DemoPage(
      widgetName: 'BaseTabScaffold',
      materialDesc: 'use Scaffold',
      cupertinoDesc: 'use CupertinoTabScaffold',
      parameterDesc: const <String, String>{
        'tabBar': 'BaseTabBar, use CupertinoTabBar on Cupertino, '
            'use BottomNavigationBar on Material.\n'
            'BaseTabBar.items is List<BaseBarItem> '
            'and the BaseBarItem use custom BottomNavigationBarItem, '
            'the icon can be null',
        'tabViews': 'The scaffolds.'
      },
      demos: _demos,
    );
  }
}

class _Demo extends StatefulWidget {
  @override
  State<_Demo> createState() => _DemoState();
}

class _DemoState extends State<_Demo> {
  int _currentIndex = 0;

   BaseTabBar _buildAutoBaseTabBar() {
    return BaseTabBar(
      // Enable native iOS tab bar (will use CNTabBar on iOS with SF Symbols, Material elsewhere)
      useNativeCupertinoTabBar: true,
      baseParam: BaseParam(nativeIOS: true),
      items: <BottomNavigationBarItem>[
        // Approach 1: Using convenience factory method with SF Symbols
        BottomNavigationBarItemNativeExtension.withSFSymbol(
          sfSymbolName: SFSymbols.home,
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: 'Home',
        ),

        // Approach 2: Using KeyedSubtree manually for more control
        const BottomNavigationBarItem(
          icon: KeyedSubtree(
            key: BaseNativeTabBarItemKey(SFSymbols.search),
            child: Icon(Icons.search_outlined),
          ),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
                
        // Approach 3: Let BaseTabBar automatically map icon to SF Symbol
        // BaseTabBar will attempt to map Icons.person_outline to 'person.crop.circle'
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),

        // Approach 4: Native Components demo with Apple logo
        const BottomNavigationBarItem(
          icon: KeyedSubtree(
            key: BaseNativeTabBarItemKey('apple.logo'),
            child: Icon(Icons.apple),
          ),
          activeIcon: Icon(Icons.apple),
          label: 'Native',
        ),

        // // Approach 5: Settings with gear icon
        BottomNavigationBarItemNativeExtension.withSFSymbol(
          sfSymbolName: SFSymbols.settings,
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          label: 'Settings',
        ),
        
      ],
      cnSplit: true,
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() => _currentIndex = index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      const _TabPage(title: 'Messages'),
      const _TabPage(title: 'Contacts'),
      const _TabPage(title: 'Discover'),
      const _TabPage(title: 'Me'),
    ];
    return  BaseTabScaffold(
        backgroundColor: Colors.red,
        baseParam: BaseParam(nativeIOS: true),
        appBar: BaseAppBar(
          transparent: true,
          tint: Colors.white,
          baseParam: BaseParam(nativeIOS: false),
          title: const Text('Tab Scaffold Demo'),
          leadingActions: [
            BaseNavigationBarAction(
              icon: CNSymbol('chevron.left'),
              label: 'Back',
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
          trailingActions: [
            BaseNavigationBarAction(
              icon: CNSymbol('ellipsis.circle'),
              label: 'More',
              onPressed: () {
                print('More pressed');
              },
            ),
          ],
        ),
        tabBar: _buildAutoBaseTabBar(),
        // BaseTabBar(
        //   cnSplit:true,
        //   useNativeCupertinoTabBar: true,
        //   type: BottomNavigationBarType.shifting,
        //   currentIndex: _currentIndex,
        //   onTap: (int index) {
        //     setState(() {
        //       print(' Tapped tab: $index ');
        //       _currentIndex = index;
        //     });
        //   },
          
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem( 
        //       icon: BaseIcon(
        //         icon: IconFont.dialog,
        //       ),
        //       label: 'Messages',
        //     ),
        //      BottomNavigationBarItem(
        //   icon: KeyedSubtree(
        //     key: BaseNativeTabBarItemKey('apple.logo'),
        //     child: Icon(Icons.apple),
        //   ),
        //   activeIcon: Icon(Icons.apple),
        //   label: 'Contacts',
        // ),
        //     // BottomNavigationBarItem(
        //     //   icon: BaseIcon(
        //     //     icon: IconFont.contacts,
        //     //   ),
        //     //   label: 'Contacts',
        //     // ),
        //     BottomNavigationBarItem(
        //       icon: BaseIcon(
        //         icon: IconFont.discover,
        //       ),
        //       label: 'Discover',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: BaseIcon(
        //         icon: IconFont.profile,
        //       ),
        //       label: 'Me',
        //     ),
        //   ],
        //   iconSize: 24.0,
        // ),
        tabViews: children,
    
    );
  }
}

class _TabPage extends StatelessWidget {
  const _TabPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Colors.pinkAccent,
      body: _Body(title: title),
      // baseParam: BaseParam(
      //   cupertino: const <String, dynamic>{
      //     'backgroundColor': CupertinoColors.systemGroupedBackground,
      //   },
      // ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
    this.title = '',
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        // Bottom height includes TabBar
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}
