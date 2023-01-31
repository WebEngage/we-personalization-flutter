package com.example.flutter_personalization_sdk.utils

import com.example.flutter_personalization_sdk.model.WEGInline
import com.google.gson.Gson
import com.webengage.personalization.data.WECampaignContent
import com.webengage.personalization.data.WECampaignData

class Utils {

    companion object {
        fun generateMap(
            wegInline: WEGInline,
            campaignData: WECampaignData
        ): HashMap<String, Any> {
            val map: HashMap<String, Any> = hashMapOf()
            map[PAYLOAD_ID] = wegInline.id
            map[PAYLOAD_DATA] = "$PAYLOAD_DATA : ${_convertWECampaignDataToString(campaignData)}"
            return map
        }

        fun generateMap(
            wegInline: WEGInline,
            campaignId: String?,
            targetViewId: String,
            error: java.lang.Exception
        ): HashMap<String, Any> {
            val map: HashMap<String, Any> = hashMapOf()
            map[PAYLOAD_ID] = wegInline.id
            map[PAYLOAD_CAMPAIGN_ID] = "$campaignId"
            map[PAYLOAD_TARGET_VIEW_ID] = targetViewId
            map[PAYLOAD_ERROR] = "${error.message}"
            return map
        }



        private fun _convertWECampaignDataToString(weCampaignData: WECampaignData): String {
            val gson = Gson()
            val data = gson.toJson(weCampaignData);
            return data;
        }

    }

}