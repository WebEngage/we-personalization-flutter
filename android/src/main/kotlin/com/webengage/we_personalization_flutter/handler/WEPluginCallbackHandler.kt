package com.webengage.we_personalization_flutter.handler

import com.webengage.we_personalization_flutter.WEPersonalizationPlugin
import com.webengage.we_personalization_flutter.registry.WEPropertyRegistry
import com.webengage.we_personalization_flutter.utils.*
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
        WELogger.v("WEPluginCallbackHandler","onPropertyCacheCleared for screen = $screenName")
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
        WELogger.v("WEPluginCallbackHandler","onCampaignClicked for actionID = $actionId deeplink = $deepLink data = ${data.toJSONString()}")
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_CLICKED, WEUtils.generateMap(actionId, deepLink, data)
        )
        return true
    }

    override fun onCampaignException(
        campaignId: String?, targetViewId: String, error: Exception
    ) {
        WELogger.v("WEPluginCallbackHandler","onCampaignException for campaignId = $campaignId targetViewId = $targetViewId error = ${error.message}")
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_EXCEPTION, WEUtils.generateMap(campaignId, targetViewId, error)
        )
    }

    override fun onCampaignPrepared(data: WECampaignData): WECampaignData? {
        WELogger.v("WEPluginCallbackHandler","onCampaignPrepared ${data.campaignId} ${data.targetViewId}")
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_PREPARED, WEUtils.generateMap(data)
        )
        return data
    }

    override fun onCampaignShown(data: WECampaignData) {
        WELogger.v("WEPluginCallbackHandler","onCampaignShown ${data.campaignId} ${data.targetViewId}")
        WEPersonalizationPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_SHOWN, WEUtils.generateMap(data)
        )
    }


}