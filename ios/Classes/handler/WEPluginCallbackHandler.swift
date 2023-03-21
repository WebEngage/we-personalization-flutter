import WEPersonalization
class WEPluginCallbackHandler : WECampaignCallback{
    
    
    private init(){}
    
    static let shared = WEPluginCallbackHandler()
    
    func onCampaignPrepared(_ data: WECampaignData) -> WECampaignData {
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: WEConstants.METHOD_NAME_ON_CAMPAIGN_PREPARED,
            message: WEUtils.generateMap(campaignData: data)
        )
        return data
    }
    
    func onCampaignShown(data: WECampaignData) {
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: WEConstants.METHOD_NAME_ON_CAMPAIGN_SHOWN,
            message: WEUtils.generateMap(campaignData: data)
        )
    }
    
    func onCampaignException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: WEConstants.METHOD_NAME_ON_CAMPAIGN_EXCEPTION,
            message: WEUtils.generateMap(campaignId: campaignId, targetViewId: targetViewId, error: exception)
        )
    }
    
    func onCampaignClicked(actionId: String, deepLink: String, data: WECampaignData) -> Bool {
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: WEConstants.METHOD_NAME_ON_CAMPAIGN_CLICKED,
            message: WEUtils.generateMap(actionId: actionId, deepLink: deepLink, data: data)
        )
        return true
    }
    
}
    


extension WEPluginCallbackHandler:PropertyRegistryCallback{
    func onPropertyCacheCleared(for screenDetails: [AnyHashable : Any]) {
        print("WEP InlineWidget \(screenDetails["screen_name"]!)")
        
        WEPropertyRegistry.shared.impressionTrackedForTargetviews.removeAll()
        if let screenName = screenDetails["screen_name"] as? String{
            WEPropertyRegistry.shared.screenNavigated(screenName: screenName)
            NotificationCenter.default.post(name: Notification.Name(screenName), object: nil)
        }
    }
}

protocol ScreenNavigatorCallback{
     func screenNavigated(screenName:String)
}

extension ScreenNavigatorCallback where Self: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return true
    }
}
