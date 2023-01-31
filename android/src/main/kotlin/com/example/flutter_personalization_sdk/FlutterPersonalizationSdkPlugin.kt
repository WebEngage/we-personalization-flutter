package com.example.flutter_personalization_sdk

import android.content.Context
import android.content.SharedPreferences
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.example.flutter_personalization_sdk.registry.DataRegistry
import com.example.flutter_personalization_sdk.utils.*
import com.webengage.personalization.WEPersonalization

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterPersonalizationSdkPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel
  private lateinit var context: Context;
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, PERSONALIZATION_SDK)
   // flutterPluginBinding.platformViewRegistry.registerViewFactory("name",null)
    DataRegistry.instance.initFlutterPlugin(this)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val methodName = call.method
    when(methodName){
      METHOD_NAME_REGISTER -> {
        val registered = DataRegistry.instance.registerData(call.arguments as HashMap<String,Any>)
        return result.success(registered)
      }
      METHOD_NAME_DEREGISTER -> {
        val remove = DataRegistry.instance.removeData(call.arguments as HashMap<String, Any>)
        return result.success(remove)
      }
      METHOD_NAME_INIT -> {
        val sharedPrefsManager: SharedPreferences =
          context.getSharedPreferences("we_shared_storage", Context.MODE_PRIVATE)
        sharedPrefsManager.edit().putBoolean("com.webengage.personalization.auto_track_impression", false)
          .apply()
        WEPersonalization.get().init()
      //  WEPersonalization.get().registerPropertyRegistryCallback(listener = CallbackHandler.instance)
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
      channel.invokeMethod(
        methodName,
        messagePayload
      )
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
