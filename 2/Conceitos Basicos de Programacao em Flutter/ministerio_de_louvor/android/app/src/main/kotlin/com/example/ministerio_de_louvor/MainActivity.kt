package com.example.ministerio_de_louvor

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.media.AudioManager

import androidx.core.content.getSystemService

class MainActivity: FlutterActivity() {

    private val CHANNEL = "volume_channel"

    override fun configureFlutterEngine(@androidx.annotation.NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getVolume") {
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                val currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
                result.success(currentVolume)
            } else {
                result.notImplemented()
            }
        }
    }
}