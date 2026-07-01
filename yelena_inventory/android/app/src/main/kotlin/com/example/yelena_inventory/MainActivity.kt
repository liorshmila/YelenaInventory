package com.example.yelena_inventory

import android.media.AudioManager
import android.media.ToneGenerator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "yelena_inventory/barcode_beep"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "playSuccessBeep" -> {
                    playSuccessBeep()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun playSuccessBeep() {
        val toneGenerator = ToneGenerator(AudioManager.STREAM_NOTIFICATION, 100)
        toneGenerator.startTone(ToneGenerator.TONE_PROP_BEEP, 120)
        window.decorView.postDelayed({
            toneGenerator.release()
        }, 180)
    }
}
