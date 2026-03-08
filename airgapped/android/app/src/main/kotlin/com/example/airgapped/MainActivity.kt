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

                if (call.method == "open") {

                    val url = call.argument<String>("url")

                    val intent = Intent(Intent.ACTION_VIEW)
                    intent.data = Uri.parse(url)

                    startActivity(intent)

                    result.success(null)

                } else {
                    result.notImplemented()
                }
            }
    }
}
