package com.liorshmila.yelenainventory

import android.media.AudioManager
import android.media.ToneGenerator
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.system.exitProcess

class MainActivity : FlutterActivity() {
    private val beepChannelName = "yelena_inventory/barcode_beep"
    private val appControlChannelName = "yelena_inventory/app_control"
    private val appInfoChannelName = "yelena_inventory/app_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            beepChannelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "playSuccessBeep" -> {
                    playSuccessBeep()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            appControlChannelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "exitApplication" -> {
                    finishAndRemoveTask()
                    result.success(null)
                    window.decorView.postDelayed({
                        exitProcess(0)
                    }, 120)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            appInfoChannelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAppVersion" -> {
                    val packageInfo = packageManager.getPackageInfo(packageName, 0)
                    val buildNumber = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        packageInfo.longVersionCode
                    } else {
                        @Suppress("DEPRECATION")
                        packageInfo.versionCode.toLong()
                    }

                    result.success(
                        mapOf(
                            "version" to packageInfo.versionName,
                            "buildNumber" to buildNumber.toString()
                        )
                    )
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
