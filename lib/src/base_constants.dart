/// Components have dependencies on each other. Many Material components require a Material Widget ancestor.
/// Setting forceUseMaterial or forceUseCupertino on individual components may cause unpredictable errors.
/// If you need to change modes, it's recommended to modify the entire app's mode at the app level
/// (by setting the targetPlatform parameter)
///
/// How to use:
/// cupertino: const <String, dynamic>{
///   forceUseMaterial: true
/// }
/// Force use of material components, used in cupertino parameters. Use with caution, may be removed in future versions.
const String forceUseMaterial = 'forceUseMaterial';

/// material: const <String, dynamic>{
///   forceUseCupertino: true
/// }
/// Force use of cupertino components, used in material parameters. Use with caution, may be removed in future versions.
const String forceUseCupertino = 'forceUseCupertino';

/// How to use:
/// cupertino: const <String, dynamic>{
///   disabled: true
/// }
///
/// material: const <String, dynamic>{
///   disabled: true
/// }
/// Disable in a specific mode
const String disabled = 'disabled';

/// Whether to disable ripple effects in cupertino mode
const String customWithoutSplashOnCupertino = 'withoutSplashOnCupertino';