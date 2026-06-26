import 'platform_channel_registry.dart' as registry;

class LauncherChannel {
  static const _channel = registry.PlatformChannelRegistry.launcherChannel;

  /// Returns whether this app is currently the default Home / Launcher app.
  static Future<bool> isDefaultLauncher() async {
    try {
      final result = await _channel.invokeMethod<bool>('isDefaultLauncher');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Opens system settings so the user can set this app as the default launcher.
  ///
  /// On Android 10+ this opens the role-request dialog. On older versions it
  /// opens the Home settings page.
  static Future<void> requestDefaultLauncher() async {
    try {
      await _channel.invokeMethod<void>('requestDefaultLauncher');
    } catch (e) {
      // Silent fail
    }
  }
}
