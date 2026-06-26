import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages async initialization before the app runs.
///
/// Calls [WidgetsFlutterBinding.ensureInitialized] and returns a [ProviderContainer]
/// pre-configured with overrides for initialized singletons (Drift, secure storage,
/// shared preferences, audio handler).
class Bootstrap {
  /// Initialize all async dependencies and return a [ProviderContainer].
  ///
  /// Future: wire up Drift, secure storage, shared prefs, and audio service here.
  static Future<ProviderContainer> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Future: init Drift, secure storage, prefs, audio handler here

    return ProviderContainer(
      overrides: [
        // Future: provide initialized singletons here
      ],
    );
  }
}
