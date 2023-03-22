import WEPersonalization
class WEPluginCallbackHandler : WECampaignCallback{
    
    
    private init(){}
    
    static let shared = WEPluginCallbackHandler()
    
    func onCampaignPrepared(_ data: WECampaignData) -> WECampaignData {
        WELogger.d("WEP I : called for data \(data.targetViewTag)")
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: WEConstants.METHOD_NAME_ON_CAMPAIGN_PREPARED,
            message: WEUtils.generateMap(campaignData: data)
        )
        return data
    }
    
    func onCampaignShown(data: WECampaignData) {
        WELogger.d("WEP I : called for data \(data.targetViewTag)")
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: WEConstants.METHOD_NAME_ON_CAMPAIGN_SHOWN,
            message: WEUtils.generateMap(campaignData: data)
        )
    }
    
    func onCampaignException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        WELogger.d("WEP I : called for data \(String(describing: campaignId)) , error : \(exception.localizedDescription)")
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: WEConstants.METHOD_NAME_ON_CAMPAIGN_EXCEPTION,
            message: WEUtils.generateMap(campaignId: campaignId, targetViewId: targetViewId, error: exception)
        )
    }
    
    func onCampaignClicked(actionId: String, deepLink: String, data: WECampaignData) -> Bool {
        WELogger.d("WEP I : called for data actionID : \(actionId) deeplink :\(deepLink)")
        WEPersonalizationPlugin.methodChannel?.sendCallbacks(
            methodName: WEConstants.METHOD_NAME_ON_CAMPAIGN_CLICKED,
            message: WEUtils.generateMap(actionId: actionId, deepLink: deepLink, data: data)
        )
        return true
    }
    
}
    


extension WEPluginCallbackHandler:PropertyRegistryCallback{
    func onPropertyCacheCleared(for screenDetails: [AnyHashable : Any]) {
        WELogger.d("WEP I : \(screenDetails["screen_name"]!)")
        
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
