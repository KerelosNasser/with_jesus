import 'dart:io' show Platform;

/// Detects the current platform at runtime.
///
/// Pure Dart — no Flutter dependency, so it is testable in unit tests by
/// overriding [defaultPlatform].
class PlatformInfo {
  const PlatformInfo._();

  /// Returns true if running on Android.
  static bool get isAndroid => Platform.isAndroid;

  /// Returns true if running on iOS.
  static bool get isIOS => Platform.isIOS;

  /// Returns true if running on a mobile platform (Android or iOS).
  static bool get isMobile => isAndroid || isIOS;

  /// Returns true if running on desktop (macOS, Linux, Windows).
  static bool get isDesktop =>
      Platform.isMacOS || Platform.isLinux || Platform.isWindows;
}
