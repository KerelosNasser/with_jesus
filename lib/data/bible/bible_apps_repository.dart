import '../../domain/bible/bible_app.dart';
import '../../native/channels/app_intent_channel.dart';

class BibleAppsRepository {
  List<BibleApp> getSupportedApps() => List.unmodifiable(kSupportedBibleApps);

  Future<List<BibleApp>> getInstalledApps() async {
    final installed = <BibleApp>[];
    for (final app in kSupportedBibleApps) {
      final isInstalled = await AppIntentChannel.isInstalled(app.packageId);
      if (isInstalled) {
        installed.add(app);
      }
    }
    return installed;
  }

  Future<bool> launchApp(BibleApp app, {String? deepRef}) {
    return AppIntentChannel.launch(app.packageId, deepRef: deepRef);
  }

  Future<void> openStore(BibleApp app) {
    return AppIntentChannel.openStore(app.packageId);
  }
}
