package com.example.flutter_personalization_sdk.registry

import android.util.Log
import com.example.flutter_personalization_sdk.FlutterPersonalizationSdkPlugin
import com.example.flutter_personalization_sdk.model.WEGInline
import com.example.flutter_personalization_sdk.utils.*
import com.webengage.personalization.WEPersonalization
import com.webengage.personalization.callbacks.WEPlaceholderCallback
import com.webengage.personalization.data.WECampaignData
import java.lang.Exception
import java.util.logging.Logger

class DataRegistry {

    companion object {
        val instance = DataRegistry()
    }

    private var registryMap: HashMap<Int, WEGInline> = hashMapOf()
    private var flutterPersonalizationSdkPlugin: FlutterPersonalizationSdkPlugin? = null

    fun initFlutterPlugin(flutterPersonalizationSdkPlugin: FlutterPersonalizationSdkPlugin) {
        this.flutterPersonalizationSdkPlugin = flutterPersonalizationSdkPlugin
    }

    fun registerData(map: HashMap<String, Any>): Boolean {
        val id = map[PAYLOAD_ID] as Int
        if (registryMap.containsKey(id)) {

        }
        val wegInline = WEGInline(
            id = id,
            screenName = map[PAYLOAD_SCREEN_NAME] as String,
            propertyID = map[PAYLOAD_ANDROID_PROPERTY_ID] as String
        )
        registryMap[id] = wegInline
        WEPersonalization.get()
            .registerWEPlaceholderCallback(wegInline.propertyID, object : WEPlaceholderCallback {
                override fun onDataReceived(data: WECampaignData) {
                    onDataReceived(data, wegInline)
                }

                override fun onPlaceholderException(
                    campaignId: String?,
                    targetViewId: String,
                    error: Exception
                ) {
                    onPlaceholderException(campaignId, targetViewId, error, wegInline)
                }

                override fun onRendered(data: WECampaignData) {
                    onRendered(data, wegInline)
                }

            });
        return true
    }

    fun removeData(map: HashMap<String, Any>): Boolean {
        val id = map[PAYLOAD_ID] as Int
        return removeData(id)
    }

    private fun removeData(id: Int): Boolean {
        val contains = registryMap.containsKey(id)
        registryMap.remove(id)
        return contains
    }

    private fun onDataReceived(data: WECampaignData, wegInline: WEGInline) {
        wegInline.weCampaignData = data
        flutterPersonalizationSdkPlugin?.sendCallback(
            METHOD_NAME_ON_DATA_RECEIVED,
            Utils.generateMap(wegInline, data)
        )
    }

    private fun onPlaceholderException(
        campaignId: String?,
        targetViewId: String,
        error: Exception,
        wegInline: WEGInline
    ) {
        flutterPersonalizationSdkPlugin?.sendCallback(
            METHOD_NAME_ON_PLACEHOLDER_EXCEPTION,
            Utils.generateMap(wegInline, campaignId, targetViewId, error)
        )
    }

    private fun onRendered(data: WECampaignData, wegInline: WEGInline) {
        wegInline.weCampaignData = data
        flutterPersonalizationSdkPlugin?.sendCallback(
            METHOD_NAME_ON_RENDERED,
            Utils.generateMap(wegInline, data)
        )
    }


}