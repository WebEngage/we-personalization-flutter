import WEPersonalization
class Utils{
    
    static func generateMap(weginline:WEGHInline,
                            campaignData:WEGCampaignData)->[String:Any]{
        var map = [String:Any]()
        map[Constants.PAYLOAD_ID] = weginline.id
        map[Constants.PAYLOAD_DATA] = campaignData.toJSONString()
        return map
    }
    
    static func generateMap(weginline:WEGHInline,
                            campaignId: String?,
                            targetViewId: String,
                            error: Error)->[String:Any]{
        var map = [String:Any]()
        map[Constants.PAYLOAD_ID] = weginline.id
        map[Constants.PAYLOAD_CAMPAIGN_ID] = campaignId
        map[Constants.PAYLOAD_TARGET_VIEW_ID] = targetViewId
        map[Constants.PAYLOAD_ERROR] = error.localizedDescription
        return map
    }
    
    static func generateMap(actionId: String,
                            deepLink: String,
                            data: WEGCampaignData)->[String:Any]{
        var map = [String:Any]()
        map[Constants.PAYLOAD_ACTION_ID] = actionId
        map[Constants.PAYLOAD_DEEPLINK] = deepLink
        map[Constants.PAYLOAD_DATA] = data.toJSONString()
        return map
    }
    
    static func generateMap(campaignData:WEGCampaignData)->[String:Any]{
        var map = [String:Any]()
        map[Constants.PAYLOAD_DATA] = campaignData.toJSONString()
        return map
    }
    
    static func generateMap(
                            campaignId: String?,
                            targetViewId: String,
                            error: Error)->[String:Any]{
        var map = [String:Any]()
        map[Constants.PAYLOAD_CAMPAIGN_ID] = campaignId
        map[Constants.PAYLOAD_TARGET_VIEW_ID] = targetViewId
        map[Constants.PAYLOAD_ERROR] = error.localizedDescription
        return map
    }
    
}

extension WEGCampaignData {

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
