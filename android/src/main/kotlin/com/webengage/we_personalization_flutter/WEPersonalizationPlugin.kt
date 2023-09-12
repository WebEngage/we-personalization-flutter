package com.webengage.we_personalization_flutter

import android.content.Context
import android.content.SharedPreferences
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.webengage.we_personalization_flutter.handler.WEPluginCallbackHandler
import com.webengage.we_personalization_flutter.registry.WEPropertyRegistry
import com.webengage.we_personalization_flutter.utils.*
import com.webengage.we_personalization_flutter.view.WEInlineWidgetFactory
import com.webengage.personalization.WEPersonalization
import com.webengage.sdk.android.Logger

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class WEPersonalizationPlugin : FlutterPlugin, MethodCallHandler {

    private var channel: MethodChannel? = null
    private lateinit var context: Context;
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        WELogger.setLogLevel(WELogger.VERBOSE)
        WELogger.v("WEPersonalizationPlugin","onAttachedToEngine channel is null = ${channel == null}")
        context = flutterPluginBinding.applicationContext
        if (channel == null) {
            channel = MethodChannel(flutterPluginBinding.binaryMessenger, PERSONALIZATION_SDK)
            flutterPluginBinding.platformViewRegistry.registerViewFactory(
                CHANNEL_INLINE_VIEW,
                WEInlineWidgetFactory(flutterPluginBinding.binaryMessenger)
            )
            channel?.setMethodCallHandler(this)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        WELogger.v("WEPersonalizationPlugin","onMethodCall ${call.method} ${call.arguments}")
        when (call.method) {
            METHOD_NAME_REGISTER -> {
                val registered =
                    WEPropertyRegistry.instance.registerProperty(call.arguments as HashMap<String, Any>)
                return result.success(registered)
            }
            METHOD_NAME_DEREGISTER -> {
                val remove =
                    WEPropertyRegistry.instance.deregisterProperty(call.arguments as HashMap<String, Any>)
                return result.success(remove)
            }
            METHOD_NAME_INIT -> {
                disableAutoTracking()
                WEPluginCallbackHandler.instance.setFlutterPersonalizationSdkPlugin(this)
                WEPropertyRegistry.instance.initFlutterPlugin(this)
                WEPersonalization.get().init()
                WEPersonalization.get()
                    .registerPropertyRegistryCallback(listener = WEPluginCallbackHandler.instance)
                WEPersonalization.get()
                    .registerWECampaignCallback(callback = WEPluginCallbackHandler.instance)
                return result.success(true)
            }
            METHOD_NAME_SEND_CLICK -> {
                val map = call.arguments as HashMap<String, Any>
                val id = map[PAYLOAD_ID] as Int
                val data = map[PAYLOAD_DATA] as HashMap<String, Any>
                WEPropertyRegistry.instance.trackClick(id, data)
                return result.success(true)
            }
            METHOD_NAME_SEND_IMPRESSION -> {
                val map = call.arguments as HashMap<String, Any>
                val id = map[PAYLOAD_ID] as Int
                val data = map[PAYLOAD_DATA] as HashMap<String, Any>
                WEPropertyRegistry.instance.trackImpression(id, data)
                return result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun disableAutoTracking() {
        val sharedPrefsManager: SharedPreferences =
            context.getSharedPreferences("we_shared_storage", Context.MODE_PRIVATE)
        sharedPrefsManager.edit()
            .putBoolean("com.webengage.personalization.auto_track_impression", false)
            .apply()
    }

    fun sendCallback(methodName: String, message: Map<String, *>?) {
        WELogger.v("WEPersonalizationPlugin","sendCallback to flutter $methodName $message")
        val messagePayload: MutableMap<String, Any> = java.util.HashMap()
        message?.let {
            messagePayload.put(PAYLOAD, it)
        }
        Handler(Looper.getMainLooper()).post {
            channel?.invokeMethod(
                methodName,
                messagePayload
            )
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        WELogger.v("WEPersonalizationPlugin","onDetachedFromEngine")
        WEPropertyRegistry.instance.initFlutterPlugin(null)
        WEPluginCallbackHandler.instance.setFlutterPersonalizationSdkPlugin(null)
        channel?.setMethodCallHandler(null)
        channel = null
    }
}
