import WEPersonalization
class WEPluginCallbackHandler : WECampaignCallback{
    
    
    private init(){}
    
    static let shared = WEPluginCallbackHandler()
    
    func onCampaignPrepared(_ data: WEGCampaignData) -> WEGCampaignData {
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: Constants.METHOD_NAME_ON_CAMPAIGN_PREPARED,
            message: Utils.generateMap(campaignData: data)
        )
        return data
    }
    
    func onCampaignShown(data: WEGCampaignData) {
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: Constants.METHOD_NAME_ON_CAMPAIGN_SHOWN,
            message: Utils.generateMap(campaignData: data)
        )
    }
    
    func onCampaignException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: Constants.METHOD_NAME_ON_CAMPAIGN_EXCEPTION,
            message: Utils.generateMap(campaignId: campaignId, targetViewId: targetViewId, error: exception)
        )
    }
    
    func onCampaignClicked(actionId: String, deepLink: String, data: WEGCampaignData) -> Bool {
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: Constants.METHOD_NAME_ON_CAMPAIGN_CLICKED,
            message: Utils.generateMap(actionId: actionId, deepLink: deepLink, data: data)
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
