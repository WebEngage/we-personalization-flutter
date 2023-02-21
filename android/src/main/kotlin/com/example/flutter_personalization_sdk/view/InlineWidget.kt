package com.example.flutter_personalization_sdk.view

import android.content.Context
import android.content.SharedPreferences
import android.os.Handler
import android.os.Looper
import android.view.View
import com.example.flutter_personalization_sdk.handler.CallbackHandler
import com.example.flutter_personalization_sdk.registry.DataRegistry
import com.example.flutter_personalization_sdk.utils.*
import com.webengage.personalization.WEPersonalization
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView

class InlineWidget internal constructor(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    payload: Any?
) : PlatformView, MethodCallHandler {
    private val inlineView: InlineViewWidget
    private val methodChannel: MethodChannel

    init {
        val map = payload as HashMap<String, Any>
        inlineView = InlineViewWidget(context, map, this)
        methodChannel = MethodChannel(messenger, "${CHANNEL_INLINE_VIEW}_$id")
    }

    override fun getView(): View? {
        return inlineView
    }

    override fun dispose() {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_NAME_SEND_CLICK -> {
                var map = call.arguments as HashMap<String, Any>
                val data = map[PAYLOAD_DATA] as HashMap<String, Any>
                inlineView.getWEGInlineView().weCampaignData?.trackClick(data)
                return result.success(true)
            }
            METHOD_NAME_SEND_IMPRESSION -> {
                var map = call.arguments as HashMap<String, Any>
                val data = map[PAYLOAD_DATA] as HashMap<String, Any>
                inlineView.getWEGInlineView().weCampaignData?.trackImpression(data);
                return result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    fun sendCallback(methodName: String, message: Map<String, *>?) {
        val messagePayload: MutableMap<String, Any> = java.util.HashMap()
        message?.let {
            messagePayload.put(PAYLOAD, it)
        }
        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod(
                methodName,
                messagePayload
            )
        }
    }


}