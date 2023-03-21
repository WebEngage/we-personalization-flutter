package com.example.flutter_personalization_sdk.utils

import com.example.flutter_personalization_sdk.model.WEProperty
import com.webengage.personalization.data.WECampaignData

class WEUtils {

    companion object {
        fun generateMap(
            weProperty: WEProperty,
            campaignData: WECampaignData
        ): HashMap<String, Any> {
            val map: HashMap<String, Any> = hashMapOf()
            map[PAYLOAD_ID] = weProperty.id
            map[PAYLOAD_DATA] = convertWECampaignDataToString(campaignData)
            return map
        }

        fun generateMap(
            weProperty: WEProperty,
            campaignData: WECampaignData,
            shadowData: HashMap<String, Any>
        ): HashMap<String, Any> {
            val map: HashMap<String, Any> = hashMapOf()
            map[PAYLOAD_ID] = weProperty.id
            map[PAYLOAD_DATA] = convertWECampaignDataToString(campaignData)
            map[PAYLOAD_SHADOW_DATA] = shadowData
            return map
        }

        fun generateMap(
            weProperty: WEProperty,
            campaignId: String?,
            targetViewId: String,
            error: java.lang.Exception
        ): HashMap<String, Any> {
            val map: HashMap<String, Any> = hashMapOf()
            map[PAYLOAD_ID] = weProperty.id
            map[PAYLOAD_CAMPAIGN_ID] = "$campaignId"
            map[PAYLOAD_TARGET_VIEW_ID] = targetViewId
            map[PAYLOAD_ERROR] = "${error.message}"
            return map
        }

        fun generateMap(
            actionId: String,
            deepLink: String,
            data: WECampaignData
        ): HashMap<String, Any> {
            val map: HashMap<String, Any> = hashMapOf()
            map[PAYLOAD_ACTION_ID] = actionId
            map[PAYLOAD_DEEPLINK] = deepLink
            map[PAYLOAD_DATA] = convertWECampaignDataToString(data)
            return map
        }

        fun generateMap(
            data: WECampaignData
        ): HashMap<String, Any> {
            val map: HashMap<String, Any> = hashMapOf()
            map[PAYLOAD_DATA] = convertWECampaignDataToString(data)
            return map
        }

        fun generateMap(
            campaignId: String?,
            targetViewId: String,
            error: java.lang.Exception
        ): HashMap<String, Any> {
            val map: HashMap<String, Any> = hashMapOf()
            map[PAYLOAD_CAMPAIGN_ID] = "$campaignId"
            map[PAYLOAD_TARGET_VIEW_ID] = targetViewId
            map[PAYLOAD_ERROR] = "${error.message}"
            return map
        }

        private fun convertWECampaignDataToString(weCampaignData: WECampaignData): String {
            return weCampaignData.toJSONString()
        }

    }

}