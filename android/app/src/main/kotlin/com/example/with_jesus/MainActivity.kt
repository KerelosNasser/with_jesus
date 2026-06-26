package com.example.with_jesus

import com.example.with_jesus.native.PlatformChannelRegistry
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        PlatformChannelRegistry.registerChannels(flutterEngine)
    }
}
