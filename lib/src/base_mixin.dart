import 'package:base/base.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart' show BuildContext, Container, Theme;

import 'components/base_material_widget.dart';
import 'config/base_config.dart';
import 'mode/base_mode.dart';
import 'theme/base_theme.dart';

/// Common methods
mixin BaseMixin {
  /// build之前调用
  void beforeBuild(BuildContext context) {}

  /// buildByMaterial之前调用
  void beforeBuildByMaterial(BuildContext context) {}

  /// buildByCupertino之前调用
  void beforeBuildByCupertino(BuildContext context) {}

  /// buildByCupertinoNative之前调用 (native iOS implementation)
  void beforeBuildByCupertinoNative(BuildContext context) {}

  /// build on cupertino mode (Flutter implementation)
  dynamic buildByCupertino(BuildContext context);

  /// build on cupertino mode with native iOS components (cupertino_native package)
  /// This is called when baseParam.nativeIOS = true
  /// Default implementation falls back to buildByCupertino()
  dynamic buildByCupertinoNative(BuildContext context) {
    // Default: fallback to standard Flutter Cupertino implementation
    return buildByCupertino(context);
  }

  /// build on material mode
  dynamic buildByMaterial(BuildContext context);

  dynamic valueOf(String key, dynamic value);

  /// 没得反射，danteng
  /// 先取平台里的值，再从模式中取值，最后取value的值
  dynamic valueOfBaseParam(BaseParam? baseParam, String key, dynamic value) {
    return baseParam != null ? baseParam.valueOf(key, value) ?? value : value;
  }

  dynamic commonBuild(BuildContext context, BaseParam? baseParam) {
    beforeBuild(context);
    final WidgetBuildMode _widgetBuildMode = getBuildMode(baseParam);
    dynamic _dynamic;
    switch (_widgetBuildMode) {
      case WidgetBuildMode.cupertino:
      case WidgetBuildMode.forceUseCupertino:
        // Check if native iOS implementation is enabled
        final bool useNativeIOS = baseParam?.nativeIOS ?? false;
        if (useNativeIOS) {
          beforeBuildByCupertinoNative(context);
          _dynamic = buildByCupertinoNative(context);
        } else {
          beforeBuildByCupertino(context);
          _dynamic = buildByCupertino(context);
        }
        break;
      case WidgetBuildMode.material:
        beforeBuildByMaterial(context);
        _dynamic = buildByMaterial(context);
        break;
      case WidgetBuildMode.forceUseMaterial:
        // 默认套多一层 Material
        beforeBuildByMaterial(context);
        // 是否禁用水波纹
        final bool _withoutSplashOnCupertino = baseParam?.withoutSplashOnCupertino ?? withoutSplashOnCupertino;
        if (_withoutSplashOnCupertino) {
          _dynamic = BaseMaterialWidget.withoutSplash(
            theme: BaseTheme.of(context).materialTheme ?? Theme.of(context),
            child: buildByMaterial(context),
          );
        } else {
          _dynamic = BaseMaterialWidget(child: buildByMaterial(context));
        }
        break;
      case WidgetBuildMode.disabled:
        _dynamic = Container();
        break;
    }
    return _dynamic;
  }

  WidgetBuildMode getBuildMode(BaseParam? baseParam) {
    WidgetBuildMode _widgetBuildMode = WidgetBuildMode.disabled;
    if (baseParam != null) {
      bool _disabled = false;
      if (isCupertinoMode) {
        if (baseParam.forceUseMaterial) {
          /// 强制使用Material模式
          _widgetBuildMode = WidgetBuildMode.forceUseMaterial;
        } else {
          /// 使用Cupertino模式
          _widgetBuildMode = WidgetBuildMode.cupertino;
        }
      } else if (isMaterialMode) {
        if (baseParam.forceUseCupertino) {
          /// 强制使用Cupertino模式
          _widgetBuildMode = WidgetBuildMode.forceUseCupertino;
        } else {
          /// 使用Material模式
          _widgetBuildMode = WidgetBuildMode.material;
        }
      } else {
        assert(true, 'Only support Cupertino mode and Materila mode.');
      }
      if (kIsWeb && baseParam.disabledOnWeb) {
        _widgetBuildMode = WidgetBuildMode.disabled;
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            if (baseParam.disabledOnAndroid) {
              _disabled = true;
            }
            break;
          case TargetPlatform.fuchsia:
            if (baseParam.disabledOnFuchsia) {
              _disabled = true;
            }
            break;
          case TargetPlatform.iOS:
            if (baseParam.disabledOnIOS) {
              _disabled = true;
            }
            break;
          case TargetPlatform.linux:
            if (baseParam.disabledOnLinux) {
              _disabled = true;
            }
            break;
          case TargetPlatform.macOS:
            if (baseParam.disabledOnMacOS) {
              _disabled = true;
            }
            break;
          case TargetPlatform.windows:
            if (baseParam.disabledOnWindows) {
              _disabled = true;
            }
            break;
        }
        // Check disabledOnOthers after the switch
        if (!_disabled && baseParam.disabledOnOthers) {
          // Only apply disabledOnOthers if platform doesn't match any specific case
          final isKnownPlatform = defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.fuchsia ||
              defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.linux ||
              defaultTargetPlatform == TargetPlatform.macOS ||
              defaultTargetPlatform == TargetPlatform.windows;
          if (!isKnownPlatform) {
            _disabled = true;
          }
        }
      }
      if (_disabled) {
        _widgetBuildMode = WidgetBuildMode.disabled;
      }
    } else {
      if (isCupertinoMode) {
        _widgetBuildMode = WidgetBuildMode.cupertino;
      } else if (isMaterialMode) {
        _widgetBuildMode = WidgetBuildMode.material;
      } else {
        assert(true, 'Only support Cupertino mode and Materila mode.');
      }
    }
    return _widgetBuildMode;
  }
}
