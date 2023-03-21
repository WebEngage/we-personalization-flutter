import WEPersonalization
class WEUtils{
    
    static func generateMap(weginline:WEProperty,
                            campaignData:WECampaignData)->[String:Any]{
        var map = [String:Any]()
        map[WEConstants.PAYLOAD_ID] = weginline.id
        map[WEConstants.PAYLOAD_DATA] = campaignData.toJSONString()
        return map
    }
    
    static func generateMap(weginline:WEProperty,
                            campaignId: String?,
                            targetViewId: String,
                            error: Error)->[String:Any]{
        var map = [String:Any]()
        map[WEConstants.PAYLOAD_ID] = weginline.id
        map[WEConstants.PAYLOAD_CAMPAIGN_ID] = campaignId
        map[WEConstants.PAYLOAD_TARGET_VIEW_ID] = targetViewId
        map[WEConstants.PAYLOAD_ERROR] = error.localizedDescription
        return map
    }
    
    static func generateMap(actionId: String,
                            deepLink: String,
                            data: WECampaignData)->[String:Any]{
        var map = [String:Any]()
        map[WEConstants.PAYLOAD_ACTION_ID] = actionId
        map[WEConstants.PAYLOAD_DEEPLINK] = deepLink
        map[WEConstants.PAYLOAD_DATA] = data.toJSONString()
        return map
    }
    
    static func generateMap(campaignData:WECampaignData)->[String:Any]{
        var map = [String:Any]()
        map[WEConstants.PAYLOAD_DATA] = campaignData.toJSONString()
        return map
    }
    
    static func generateMap(
                            campaignId: String?,
                            targetViewId: String,
                            error: Error)->[String:Any]{
        var map = [String:Any]()
        map[WEConstants.PAYLOAD_CAMPAIGN_ID] = campaignId
        map[WEConstants.PAYLOAD_TARGET_VIEW_ID] = targetViewId
        map[WEConstants.PAYLOAD_ERROR] = error.localizedDescription
        return map
    }
    
}

extension WECampaignData {

    func toMap()->[String:Any]{
        var map = [String:Any]()
        map["campaignId"] = campaignId
        map["targetViewId"] = "\(targetViewTag)"
        map["content"] = content?.custom
        return map
    }
    
    func toString()->String?{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: toMap(),
            options: []) {
            let theJSONText = String(data: theJSONData,
                                       encoding: .ascii)
            return theJSONText
        }
        return nil
    }

}
