import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'provider/app_provider.dart';

const String _version = '2.2.2+3';
const String _flutter_version = '2.2.2';

const double _appBarMaxHeight = 100;

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(
        title: Text('Settings'),
        transitionBetweenRoutes: true,
      ),
      body: Consumer<AppProvider>(
        builder: (_, AppProvider appProvider, __) {
          return ListView(
            children: const <Widget>[
              _PlatformWidget(),
              _CustomSettingWidget(),
              _VersionWidget(),
              _DocWidget(),
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

class _DocWidget extends StatelessWidget {
  const _DocWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      margin: const EdgeInsets.only(top: 20.0),
      children: <Widget>[
        BaseTile(
          title: const Center(
            child: Text('View Documentation'),
          ),
          onTap: () async {
            const String url = 'https://nillnil.github.io/flutter_base/#/';
            if (await canLaunch(url)) {
              launch(url);
            }
          },
        ),
      ],
    );
  }
}

class _VersionWidget extends StatelessWidget {
  const _VersionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, _) {
        return const BaseSection(
          margin: EdgeInsets.only(top: 20.0),
          children: <Widget>[
            BaseTile(
              titleText: 'Flutter Version',
              trailing: Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Text(
                  _flutter_version,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            BaseTile(
              titleText: 'App Version',
              trailing: Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Text(
                  _version,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CustomSettingWidget extends StatelessWidget {
  const _CustomSettingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      margin: const EdgeInsets.only(top: 20.0),
      children: <Widget>[
        const _NightModeWidget(),
        BaseTile(
          titleText: 'Personalization Settings',
          trailing: const BaseIcon(
            icon: CupertinoIcons.right_chevron,
            size: 25,
            color: Colors.grey,
          ),
          onTap: () {
            BaseRoute<void>(
              builder: (_) {
                return const _OtherSettingWidget();
              },
              fullscreenGackGesture: false,
            ).push(context);
          },
        ),
      ],
    );
  }
}

class _OtherSettingWidget extends StatelessWidget {
  const _OtherSettingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(title: Text('Personalization Settings')),
      body: Consumer<AppProvider>(
        builder: (BuildContext context, AppProvider appProvider, _) {
          double? _currentAppBarHeight = appProvider.appBarHeight;
          _currentAppBarHeight ??= isCupertinoMode ? 44.0 : 56.0;
          return ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              BaseMaterialWidget.withoutSplash(
                theme: BaseTheme.of(context).materialTheme,
                child: ExpansionTile(
                  title: const Text('Default Navigation Bar Height'),
                  childrenPadding: const EdgeInsets.all(10.0),
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text('${_currentAppBarHeight.toInt()}'),
                          ),
                          Row(
                            children: <Widget>[
                              const Text('0'),
                              Expanded(
                                child: BaseSlider(
                                  value: appProvider.appBarHeight != null
                                      ? appProvider.appBarHeight!
                                      : isCupertinoMode
                                          ? 44.0
                                          : 56.0,
                                  min: 0.0,
                                  divisions: (_appBarMaxHeight - 0) ~/ 2,
                                  max: _appBarMaxHeight,
                                  onChanged: (double value) {
                                    appProvider.changeAppBarHeight(value);
                                  },
                                ),
                              ),
                              Text('${_appBarMaxHeight.toInt()}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BaseTile(
                titleText: 'Full-screen Gesture Back for Routes',
                trailing: BaseSwitch(
                  value: appProvider.routeFullscreenGackGesture,
                  onChanged: (bool value) {
                    if (value) {
                      const BaseAlertDialog(
                        title: Text('Enable Full-screen Gesture Back\nPlease resolve gesture conflicts on pages yourself'),
                      ).show<void>(context);
                    }
                    appProvider.changeRouteFullscreenGackGesture();
                  },
                ),
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NightModeWidget extends StatelessWidget {
  const _NightModeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, _) {
        String themeModeText = '';
        switch (appProvider.themeMode) {
          case ThemeMode.light:
            themeModeText = 'Light';
            break;
          case ThemeMode.dark:
            themeModeText = 'Dark';
            break;
          default:
            themeModeText = 'Follow System';
        }
        return BaseTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          title: const Text('Appearance'),
          trailing: SizedBox(
            width: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(themeModeText),
                const BaseIcon(
                  icon: CupertinoIcons.right_chevron,
                  size: 25,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          onTap: () {
            BaseRoute<void>(
              builder: (_) => _ThemeModePage(),
              fullscreenDialog: true,
            ).push(context);
          },
        );
      },
    );
  }
}

class _ThemeModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: const Text('Appearance'),
        padding: EdgeInsetsDirectional.zero,
        leading: BaseIconButton(
          icon: CupertinoIcons.clear_thick,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (BuildContext context, AppProvider appProvider, _) {
          const Widget trailing = SizedBox(
            width: 40.0,
            child: BaseIcon(
              icon: CupertinoIcons.check_mark,
              size: 36,
            ),
          );
          const Widget blankWidget = SizedBox(
            width: 40.0,
          );
          return ListView(
            children: <Widget>[
              BaseSection(
                margin: const EdgeInsets.only(top: 0.0),
                children: <Widget>[
                  BaseTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    title: const Text('Follow System'),
                    trailing: appProvider.themeMode == ThemeMode.system ? trailing : blankWidget,
                    onTap: () {
                      appProvider.changeThemeMode(ThemeMode.system);
                    },
                  ),
                  BaseTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    title: const Text('Dark'),
                    trailing: appProvider.themeMode == ThemeMode.dark ? trailing : blankWidget,
                    onTap: () {
                      appProvider.changeThemeMode(ThemeMode.dark);
                    },
                  ),
                  BaseTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    title: const Text('Light'),
                    trailing: appProvider.themeMode == ThemeMode.light ? trailing : blankWidget,
                    onTap: () {
                      appProvider.changeThemeMode(ThemeMode.light);
                    },
                  ),
                ],
              ),
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

class _PlatformWidget extends StatelessWidget {
  const _PlatformWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, _) {
        return BaseSection(
          margin: const EdgeInsets.only(top: 10.0),
          header: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Current Platform Build Mode: ${isCupertinoMode ? 'Cupertino' : 'Material'}',
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ),
          children: <Widget>[
            BaseTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              title: const Text('Switch Platform Build Mode'),
              trailing: BaseSwitch(
                value: currentBaseMode != defaultBaseMode,
                onChanged: (_) {
                  BasePlatformMode? platformMode = appProvider.platformMode;
                  platformMode = platformMode?.changePlatformMode(mode: currentBaseMode == BaseMode.cupertino ? BaseMode.material : BaseMode.cupertino);
                  appProvider.changePlatformMode(platformMode);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
