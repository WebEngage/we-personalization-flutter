package com.example.flutter_personalization_sdk.handler

import com.example.flutter_personalization_sdk.FlutterPersonalizationSdkPlugin
import com.example.flutter_personalization_sdk.registry.DataRegistry
import com.example.flutter_personalization_sdk.utils.*
import com.webengage.personalization.callbacks.WECampaignCallback
import com.webengage.personalization.callbacks.WEPropertyRegistryCallback
import com.webengage.personalization.data.WECampaignData


public interface ScreenNavigatorCallback {
    fun screenNavigated(screenName: String);
}

class CallbackHandler : WEPropertyRegistryCallback, WECampaignCallback {

    private var flutterPersonalizationSdkPlugin: FlutterPersonalizationSdkPlugin? = null
    private var mapOfScreenNavigatedCallbacks: HashMap<String, ArrayList<ScreenNavigatorCallback>>? =
        null

    companion object {
        val instance: CallbackHandler by lazy { CallbackHandler() }
    }

    init {
        if (mapOfScreenNavigatedCallbacks == null)
            mapOfScreenNavigatedCallbacks = hashMapOf()
    }

    public fun setFlutterPersonalizationSdkPlugin(flutterPersonalizationSdkPlugin: FlutterPersonalizationSdkPlugin?){
        this.flutterPersonalizationSdkPlugin = flutterPersonalizationSdkPlugin
    }


    public fun setScreenNavigatorCallback(
        screenName: String,
        screenNavigatorCallback: ScreenNavigatorCallback
    ) {
        if (!mapOfScreenNavigatedCallbacks!!.contains(screenName)) {
            mapOfScreenNavigatedCallbacks!![screenName] = ArrayList()
        }
        mapOfScreenNavigatedCallbacks!![screenName]!!.add(screenNavigatorCallback)
    }


    public fun removeScreenNavigatorCallback(
        screenName: String,
        screenNavigatorCallback: ScreenNavigatorCallback
    ) {
        if (mapOfScreenNavigatedCallbacks!!.contains(screenName)) {
            mapOfScreenNavigatedCallbacks!![screenName]?.remove(screenNavigatorCallback)
        }
    }

    override fun onPropertyCacheCleared(screenName: String) {
        Logger.e("onPropertyCacheCleared",screenName)
        DataRegistry.instance.clearCacheData()
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
        actionId: String,
        deepLink: String,
        data: WECampaignData
    ): Boolean {
        Logger.e("onCampaignClicked","${data.targetViewId}")
        flutterPersonalizationSdkPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_CLICKED,
            Utils.generateMap(actionId, deepLink, data)
        )
        return false
    }

    override fun onCampaignException(
        campaignId: String?,
        targetViewId: String,
        error: Exception
    ) {
        Logger.e("onCampaignException","${targetViewId}")
        flutterPersonalizationSdkPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_EXCEPTION,
            Utils.generateMap(campaignId, targetViewId, error)
        )
    }

    override fun onCampaignPrepared(data: WECampaignData): WECampaignData? {
        Logger.e("onCampaignPrepared","${data.targetViewId}")
        flutterPersonalizationSdkPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_PREPARED,
            Utils.generateMap(data)
        )
        return data
    }

    override fun onCampaignShown(data: WECampaignData) {
        Logger.e("onCampaignShown","${data.targetViewId}")
        flutterPersonalizationSdkPlugin?.sendCallback(
            METHOD_NAME_ON_CAMPAIGN_SHOWN,
            Utils.generateMap(data)
        )
    }


}