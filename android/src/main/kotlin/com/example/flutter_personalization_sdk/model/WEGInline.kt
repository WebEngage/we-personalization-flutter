package com.example.flutter_personalization_sdk.model

import com.webengage.personalization.data.WECampaignData

data class WEGInline(
    val id: Int,
    val screenName: String,
    val propertyID: String
) {
    var weCampaignData: WECampaignData? = null
}