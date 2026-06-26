package com.example.with_jesus.native

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AppIntentChannel(private val context: Context) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isInstalled" -> {
                val packageName = call.argument<String>("package")
                if (packageName == null) {
                    result.error("INVALID_ARGUMENT", "package is required", null)
                    return
                }
                result.success(isPackageInstalled(packageName))
            }
            "launch" -> {
                val packageName = call.argument<String>("package")
                val deepRef = call.argument<String>("deepRef")
                if (packageName == null) {
                    result.error("INVALID_ARGUMENT", "package is required", null)
                    return
                }
                val launched = launchPackage(packageName, deepRef)
                result.success(launched)
            }
            "openStore" -> {
                val packageName = call.argument<String>("package")
                if (packageName == null) {
                    result.error("INVALID_ARGUMENT", "package is required", null)
                    return
                }
                openStore(packageName)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun isPackageInstalled(packageName: String): Boolean {
        return try {
            context.packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun launchPackage(packageName: String, deepRef: String?): Boolean {
        // Try deep link first if deepRef is provided
        if (deepRef != null && deepRef.isNotBlank()) {
            try {
                val deepIntent = Intent(Intent.ACTION_VIEW, Uri.parse(deepRef)).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    setPackage(packageName)
                }
                if (deepIntent.resolveActivity(context.packageManager) != null) {
                    context.startActivity(deepIntent)
                    return true
                }
            } catch (e: Exception) {
                // Fall through to launch intent
            }
        }

        // Fall back to launch intent
        return try {
            val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
            if (launchIntent != null) {
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(launchIntent)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }

    private fun openStore(packageName: String) {
        val marketIntent = Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=$packageName")).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            context.startActivity(marketIntent)
        } catch (e: android.content.ActivityNotFoundException) {
            // Fall back to browser
            val webIntent = Intent(
                Intent.ACTION_VIEW,
                Uri.parse("https://play.google.com/store/apps/details?id=$packageName")
            ).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(webIntent)
        }
    }
}
