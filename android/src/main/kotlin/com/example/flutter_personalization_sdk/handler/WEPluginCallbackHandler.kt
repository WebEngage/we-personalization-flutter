package com.example.flutter_personalization_sdk.handler

import com.example.flutter_personalization_sdk.WEPersonalizationPlugin
import com.example.flutter_personalization_sdk.registry.WEPropertyRegistry
import com.example.flutter_personalization_sdk.utils.*
import com.webengage.personalization.callbacks.WECampaignCallback
import com.webengage.personalization.callbacks.WEPropertyRegistryCallback
import com.webengage.personalization.data.WECampaignData


public interface ScreenNavigatorCallback {
    fun screenNavigated(screenName: String);
}

class WEPluginCallbackHandler : WEPropertyRegistryCallback, WECampaignCallback {

    private var WEPersonalizationPlugin: WEPersonalizationPlugin? = null
    private var mapOfScreenNavigatedCallbacks: HashMap<String, ArrayList<ScreenNavigatorCallback>>? =
        null

    companion object {
        val instance: WEPluginCallbackHandler by lazy { WEPluginCallbackHandler() }
    }


    init {
        if (mapOfScreenNavigatedCallbacks == null) mapOfScreenNavigatedCallbacks = hashMapOf()
    }

    fun setFlutterPersonalizationSdkPlugin(WEPersonalizationPlugin: WEPersonalizationPlugin?) {
        this.WEPersonalizationPlugin = WEPersonalizationPlugin
    }


    fun setScreenNavigatorCallback(
        screenName: String, screenNavigatorCallback: ScreenNavigatorCallback
    ) {
        if (!mapOfScreenNavigatedCallbacks!!.contains(screenName)) {
            mapOfScreenNavigatedCallbacks!![screenName] = ArrayList()
        }
        mapOfScreenNavigatedCallbacks!![screenName]!!.add(screenNavigatorCallback)
    }


     fun removeScreenNavigatorCallback(
        screenName: String, screenNavigatorCallback: ScreenNavigatorCallback
    ) {
        if (mapOfScreenNavigatedCallbacks!!.contains(screenName)) {
            mapOfScreenNavigatedCallbacks!![screenName]?.remove(screenNavigatorCallback)
        }
    }

    override fun onPropertyCacheCleared(screenName: String) {
        WEPropertyRegistry.instance.clearCacheData()
        WEPropertyRegistry.instance.onScreenNavigated(screenName)
        screenName.let {
            val list = mapOfScreenNavigatedCallbacks!![it]
            list?.let {
                for (callback in it) {
                    callback.screenNavigated(screenName)
                }
            }
        }
    }

    override fun onCampaignClicked(
        actionId: String, deepLink: String, data: WECampaignData
    ): Boolean {
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_CLICKED, WEUtils.generateMap(actionId, deepLink, data)
        )
        return true
    }

    override fun onCampaignException(
        campaignId: String?, targetViewId: String, error: Exception
    ) {
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_EXCEPTION, WEUtils.generateMap(campaignId, targetViewId, error)
        )
    }

    override fun onCampaignPrepared(data: WECampaignData): WECampaignData? {
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_PREPARED, WEUtils.generateMap(data)
        )
        return data
    }

    override fun onCampaignShown(data: WECampaignData) {
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_SHOWN, WEUtils.generateMap(data)
        )
    }


}