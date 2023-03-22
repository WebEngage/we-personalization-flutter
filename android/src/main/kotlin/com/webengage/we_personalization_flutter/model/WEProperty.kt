package com.webengage.we_personalization_flutter.model

import com.webengage.personalization.data.WECampaignData

data class WEProperty(
    val id: Int,
    val screenName: String,
    val propertyID: String
) {
    var weCampaignData: WECampaignData? = null
}