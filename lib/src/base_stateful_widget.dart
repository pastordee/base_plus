import 'package:flutter/material.dart';

import 'base_mixin.dart';
import 'base_param.dart';

/// Base stateful widget
/// Cupertino mode uses buildByCupertino method, Material mode uses buildByMaterial method
/// *** Parameters
/// 1. Cupertino mode: Gets corresponding value from cupertino, falls back to common parameters if not found
/// 2. Material mode: Gets corresponding value from material, falls back to common parameters if not found
/// 3. In cupertino mode, you can use cupertino = { forceUseMaterial: true } to force material mode build
///   Use cupertino = { disabled: true } to disable build
/// 4. In material mode, you can use material = { forceUseCupertino: true } to force cupertino mode build
///   Use material = { disabled: true } to disable build
/// ***
/// *** Flutter disables runtime reflection, so value retrieval is handled by each child component,
/// *** Cupertino mode uses valueFromCupertino(key, value) to get values,
/// *** Material mode uses valueOf(key, value) to get values
/// ***
abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({
    Key? key,
    this.baseParam,
  }) : super(key: key);

  /// Personalization parameters, gets platform parameters first, then mode parameters
  final BaseParam? baseParam;
}

abstract class BaseState<T extends BaseStatefulWidget> extends State<T> with BaseMixin {
  @override
  T get widget => super.widget;

  @override
  BuildContext get context => super.context;

  @override
  bool get mounted => super.mounted;

  @override
  dynamic valueOf(String key, dynamic value) {
    return valueOfBaseParam(widget.baseParam, key, value);
  }

  @override
  Widget build(BuildContext context) {
    return commonBuild(context, widget.baseParam);
  }
}
