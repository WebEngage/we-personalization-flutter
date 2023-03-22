package com.webengage.we_personalization_flutter.registry

import com.webengage.we_personalization_flutter.WEPersonalizationPlugin
import com.webengage.we_personalization_flutter.model.WEProperty
import com.webengage.we_personalization_flutter.utils.*
import com.webengage.personalization.WEPersonalization
import com.webengage.personalization.callbacks.WEPlaceholderCallback
import com.webengage.personalization.data.WECampaignData
import java.lang.Exception
import java.util.logging.Logger

internal class WEPropertyRegistry {

    companion object {
        val instance = WEPropertyRegistry()
    }

    private var registryMap: HashMap<Int, WEProperty> = hashMapOf()
    private var WEPersonalizationPlugin: WEPersonalizationPlugin? = null
    private val impressionTrackedForTargetViews: MutableList<String> = mutableListOf()

    fun initFlutterPlugin(WEPersonalizationPlugin: WEPersonalizationPlugin?) {
        this.WEPersonalizationPlugin = WEPersonalizationPlugin
    }

    fun registerProperty(details: HashMap<String, Any>): Boolean {
        WELogger.v("WEPropertyRegistry","registerProperty for details $details")
        val id = details[PAYLOAD_ID] as Int
        val weProperty = WEProperty(
            id = id,
            screenName = details[PAYLOAD_SCREEN_NAME] as String,
            propertyID = details[PAYLOAD_ANDROID_PROPERTY_ID] as String
        )
        registryMap[id] = weProperty
        load(weProperty)
        return true
    }

    private fun load(weProperty: WEProperty) {
        WEPersonalization.get()
            .registerWEPlaceholderCallback(weProperty.propertyID, object : WEPlaceholderCallback {
                override fun onDataReceived(data: WECampaignData) {
                    onDataReceived(data, weProperty)

                }

                override fun onPlaceholderException(
                    campaignId: String?,
                    targetViewId: String,
                    error: Exception
                ) {
                    onPlaceholderException(campaignId, targetViewId, error, weProperty)
                }

                override fun onRendered(data: WECampaignData) {
                    onRendered(data, weProperty)
                }

            })
    }

    fun deregisterProperty(details: HashMap<String, Any>): Boolean {
        WELogger.v("WEPropertyRegistry","deregisterProperty for details $details")
        val id = details[PAYLOAD_ID] as Int
        return deregisterProperty(id)
    }

    fun trackClick(id: Int, data: HashMap<String, Any>) {
        WELogger.v("WEPropertyRegistry","trackClick called for $data")
        if (registryMap.containsKey(id)) {
            val inline = registryMap[id];
            inline?.weCampaignData?.trackClick(data)
        }
    }

    fun trackImpression(id: Int, data: HashMap<String, Any>) {
        WELogger.v("WEPropertyRegistry","trackImpression called for $data")
        if (registryMap.containsKey(id)) {
            val inline = registryMap[id];
            inline?.weCampaignData?.trackImpression(data)
        }
    }

    private fun deregisterProperty(id: Int): Boolean {
        val contains = registryMap.containsKey(id)
        if (contains) {
            val data = registryMap[id]
            WEPersonalization.get().unregisterWEPlaceholderCallback(data!!.propertyID)
        }
        registryMap.remove(id)

        return contains
    }

    private fun onDataReceived(data: WECampaignData, weProperty: WEProperty) {
        WELogger.v("WEPropertyRegistry","onDataReceived ${data.targetViewId}")
        weProperty.weCampaignData = data
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_DATA_RECEIVED,
            WEUtils.generateMap(weProperty, data)
        )
    }

    private fun onPlaceholderException(
        campaignId: String?,
        targetViewId: String,
        error: Exception,
        weProperty: WEProperty
    ) {
        WELogger.v("WEPropertyRegistry","onPlaceholderException")
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_PLACEHOLDER_EXCEPTION,
            WEUtils.generateMap(weProperty, campaignId, targetViewId, error)
        )
    }

    private fun onRendered(data: WECampaignData, weProperty: WEProperty) {
        WELogger.v("WEPropertyRegistry","onRendered")
        weProperty.weCampaignData = data
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_RENDERED,
            WEUtils.generateMap(weProperty, data)
        )
    }

    fun setImpressionTrackedDetails(targetViewId: String, campaignId: String) {
        impressionTrackedForTargetViews.add("${targetViewId}_${campaignId}")
    }

    fun isImpressionAlreadyTracked(targetViewId: String, campaignId: String): Boolean {
        return impressionTrackedForTargetViews.contains("${targetViewId}_${campaignId}")
    }

    fun clearCacheData() {
        impressionTrackedForTargetViews.clear()
    }

    fun onScreenNavigated(screenName: String) {
        for ((key, value) in registryMap) {
            if (value.screenName.isNotEmpty() && screenName == value.screenName) {
                value.weCampaignData = null
                load(value)
            }
        }
    }

}