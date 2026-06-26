package com.example.with_jesus.native

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object PlatformChannelRegistry {
    private const val INTENT_CHANNEL = "app/native/intent"
    private const val MEDIA_STORE_CHANNEL = "app/native/mediastore"
    private const val LAUNCHER_CHANNEL = "app/native/launcher"
    private const val USAGE_STATS_CHANNEL = "app/native/usage_stats"
    private const val OVERLAY_CHANNEL = "app/native/overlay"
    private const val HAPTICS_CHANNEL = "app/native/haptics"

    fun registerChannels(flutterEngine: FlutterEngine, context: Context) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INTENT_CHANNEL).setMethodCallHandler(AppIntentChannel(context))

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_STORE_CHANNEL).setMethodCallHandler(MediaStoreChannel(context))

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LAUNCHER_CHANNEL).setMethodCallHandler(LauncherChannel(context))

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, USAGE_STATS_CHANNEL).setMethodCallHandler { call, result ->
            result.notImplemented()
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OVERLAY_CHANNEL).setMethodCallHandler { call, result ->
            result.notImplemented()
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, HAPTICS_CHANNEL).setMethodCallHandler { call, result ->
            result.notImplemented()
        }
    }
}
