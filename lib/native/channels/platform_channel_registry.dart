// lib/native/channels/platform_channel_registry.dart
import 'package:flutter/services.dart';

class PlatformChannelRegistry {
  // Method Channels
  static const MethodChannel intentChannel = MethodChannel('app/native/intent');
  static const MethodChannel mediaStoreChannel = MethodChannel('app/native/mediastore');
  static const MethodChannel launcherChannel = MethodChannel('app/native/launcher');
  static const MethodChannel usageStatsChannel = MethodChannel('app/native/usage_stats');
  static const MethodChannel overlayChannel = MethodChannel('app/native/overlay');
  static const MethodChannel hapticsChannel = MethodChannel('app/native/haptics');

  // Event Channels can be added here
}
