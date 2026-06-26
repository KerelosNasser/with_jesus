import 'platform_channel_registry.dart' as registry;

class AppIntentChannel {
  static const _channel = registry.PlatformChannelRegistry.intentChannel;

  static Future<bool> isInstalled(String package) async {
    try {
      final result = await _channel.invokeMethod<bool>('isInstalled', {'package': package});
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> launch(String package, {String? deepRef}) async {
    try {
      final args = <String, dynamic>{'package': package};
      if (deepRef != null) args['deepRef'] = deepRef;
      final result = await _channel.invokeMethod<bool>('launch', args);
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> openStore(String package) async {
    try {
      await _channel.invokeMethod<void>('openStore', {'package': package});
    } catch (e) {
      // Silent fail
    }
  }
}
