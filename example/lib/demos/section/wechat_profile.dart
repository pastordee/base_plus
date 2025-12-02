import 'wechat_settings.dart';
import '../../iconfont/iconfont.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:base_plus/base.dart';

class WechatProfile extends StatelessWidget {
  const WechatProfile({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const Widget cameraWidget = BaseIcon(
      icon: IconFont.camera,
      size: 20,
    );
    return WillPopScope(
      onWillPop: () => Future<bool>.value(false), // Disable back navigation
      child: BaseScaffold(
        appBar: BaseAppBar(
          automaticallyImplyLeading: false,
          height: isCupertinoMode ? 44.0 : 56.0,
          border: null,
          elevation: 0.0,
          actions: <Widget>[
            if (isMaterialMode)
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: cameraWidget,
              )
            else
              cameraWidget,
          ],
          baseParam: BaseParam(
            material: <String, dynamic>{
              'backgroundColor': const BaseColor(dynamicColor: CupertinoColors.secondarySystemGroupedBackground).build(context),
            },
            cupertino: const <String, dynamic>{
              'backgroundColor': CupertinoColors.secondarySystemGroupedBackground,
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (_, __) {
              return Container(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(12.0),
                //   color: const BaseColor(dynamicColor: CupertinoColors.opaqueSeparator).build(context),
                // ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: const Column(
                  children: <Widget>[
                    BaseSection(
                      margin: EdgeInsets.only(top: 0.0, bottom: 15.0),
                      divider: null,
                      children: <Widget>[
                        _IdWidget(),
                      ],
                    ),
                    _Pay(),
                    BaseSection(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      divider: BaseSectionDivider(
                        insets: EdgeInsets.only(left: 20),
                      ),
                      children: <Widget>[
                        _Collection(),
                        _Photo(),
                        _Card(),
                        _Emotion(),
                      ],
                    ),
                    _Settings(),
                    _Back(),
                  ],
                ),
              );
            },
          ),
        ),
        baseParam: BaseParam(
          cupertino: const <String, dynamic>{
            'backgroundColor': CupertinoColors.systemGroupedBackground,
          },
        ),
      ),
    );
  }
}

const TextStyle _style = TextStyle(
  fontSize: 17.0,
);

const double _tileHeight = 58;

class _Back extends StatelessWidget {
  const _Back({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      children: <Widget>[
        BaseTile(
          title: const Center(
            child: Text(
              'Back',
              style: _style,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _Settings extends StatelessWidget {
  const _Settings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      children: <Widget>[
        BaseTile(
          leading: const Padding(
            padding: EdgeInsets.only(right: 20.0, left: 10.0),
            child: Icon(
              IconFont.settings,
              color: Colors.blueGrey,
            ),
          ),
          height: _tileHeight,
          title: const Text(
            'Settings',
            style: _style,
          ),
          trailing: SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const <Widget>[
                Text(
                  'Click Me',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
                Icon(
                  CupertinoIcons.right_chevron,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          onTap: () {
            BaseRoute<dynamic>(
              builder: (_) => const WechatSettings(),
              fullscreenGackGesture: true,
            ).push(context, rootNavigator: true);
          },
        ),
      ],
    );
  }
}

class _Emotion extends StatelessWidget {
  const _Emotion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseTile(
      leading: Padding(
        padding: EdgeInsets.only(right: 20.0, left: 10.0),
        child: Icon(
          IconFont.emotion,
          color: Colors.orangeAccent,
        ),
      ),
      height: _tileHeight,
      title: Text(
        'Emoji',
        style: _style,
      ),
      trailing: Icon(
        CupertinoIcons.right_chevron,
        color: Colors.grey,
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseTile(
      leading: Padding(
        padding: EdgeInsets.only(right: 20.0, left: 10.0),
        child: Icon(IconFont.card, color: Colors.green),
      ),
      title: Text(
        'Card Holder',
        style: _style,
      ),
      height: _tileHeight,
      trailing: Icon(
        CupertinoIcons.right_chevron,
        color: Colors.grey,
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseTile(
      leading: Padding(
        padding: EdgeInsets.only(right: 20.0, left: 10.0),
        child: Icon(
          IconFont.photo,
          color: Colors.blueAccent,
        ),
      ),
      height: _tileHeight,
      title: Text(
        'Album',
        style: _style,
      ),
      trailing: Icon(
        CupertinoIcons.right_chevron,
        color: Colors.grey,
      ),
    );
  }
}

class _Collection extends StatelessWidget {
  const _Collection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseTile(
     
      leading: Padding(
        padding: EdgeInsets.only(right: 20.0, left: 10.0),
        child: Icon(
          IconFont.collection,
          color: Colors.redAccent,
        ),
      ),
      height: _tileHeight,
      title: Text(
        'Favorites',
        style: _style,
      ),
      trailing: Icon(
        CupertinoIcons.right_chevron,
        color: Colors.grey,
      ),
    );
  }
}

class _Pay extends StatelessWidget {
  const _Pay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseSection(
      children: <Widget>[
        BaseTile(
          leading: Padding(
            padding: EdgeInsets.only(
              right: 20.0,
              left: 10.0,
            ),
            child: BaseIcon(
              icon: IconFont.pay,
              color: Colors.lightBlue,
            ),
          ),
          height: _tileHeight,
          title: Text(
            'Payment',
            style: _style,
          ),
          trailing: Icon(
            CupertinoIcons.right_chevron,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _IdWidget extends StatelessWidget {
  const _IdWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseTile(
      isThreeLine: false,
      title: const Text(
        'Flutter Base Example',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18.0,
        ),
      ),
      subtitle: const Text(
        'ID: a1dslien1u3bxuanehqeuxye',
        style: TextStyle(color: Colors.grey),
      ),
      contentPadding: const EdgeInsets.all(10.0),
      leading: const FlutterLogo(
        size: 65.0,
      ),
      trailing: SizedBox(
        width: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                IconFont.qrcode,
                size: 15,
                color: Colors.grey,
              ),
            ),
            Icon(
              CupertinoIcons.right_chevron,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
