package com.example.airgapped

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "airgapped/launcher"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                val url = call.argument<String>("url")
                if (url != null) {
                    try {
                        val intent = Intent(Intent.ACTION_VIEW)
                        intent.data = Uri.parse(url)
                        startActivity(intent)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", "Cannot open $url", null)
                    }
                } else {
                    result.error("INVALID", "URL was null", null)
                }
            }
    }
}
