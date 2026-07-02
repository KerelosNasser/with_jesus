import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:with_jesus/native/channels/launcher_channel.dart';

/// Status of this app as the default home / launcher.
class DetoxLauncherStatus {
  /// Creates a [DetoxLauncherStatus] with the given values.
  const DetoxLauncherStatus({required this.isDefault});

  /// Whether this app is currently the default Home / Launcher app.
  final bool isDefault;
}

/// Provider that resolves whether this app is the default launcher.
///
/// Returns [DetoxLauncherStatus] with [DetoxLauncherStatus.isDefault] set to
/// `true` when the app is the current default home / launcher app.
final detoxLauncherStatusProvider =
    FutureProvider<DetoxLauncherStatus>((ref) async {
  final isDefault = await LauncherChannel.isDefaultLauncher();
  return DetoxLauncherStatus(isDefault: isDefault);
});

/// Requests that the user set this app as the default launcher.
///
/// On Android 10+ this opens the system role-request dialog. After the request
/// the [detoxLauncherStatusProvider] is invalidated so it re-resolves.
Future<void> requestLauncherRole(WidgetRef ref) async {
  await LauncherChannel.requestDefaultLauncher();
  ref.invalidate(detoxLauncherStatusProvider);
}
