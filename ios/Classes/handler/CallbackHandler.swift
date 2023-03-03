import WEPersonalization
class CallbackHandler : WECampaignCallback{
    
    
    private init(){}
    
    static let instance = CallbackHandler()
    var autoHandleClick = true
    
    func onCampaignPrepared(_ data: WEGCampaignData) -> WEGCampaignData {
        FlutterPersonalizationSdkPlugin.methodChannel?.sendCallbacks(
            methodName: Constants.METHOD_NAME_ON_CAMPAIGN_PREPARED,
            message: Utils.generateMap(campaignData: data)
        )
        return data
    }
    
    func onCampaignShown(data: WEGCampaignData) {
        FlutterPersonalizationSdkPlugin.methodChannel?.sendCallbacks(
            methodName: Constants.METHOD_NAME_ON_CAMPAIGN_SHOWN,
            message: Utils.generateMap(campaignData: data)
        )
    }
    
    func onCampaignException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        FlutterPersonalizationSdkPlugin.methodChannel?.sendCallbacks(
            methodName: Constants.METHOD_NAME_ON_CAMPAIGN_EXCEPTION,
            message: Utils.generateMap(campaignId: campaignId, targetViewId: targetViewId, error: exception)
        )
    }
    
    func onCampaignClicked(actionId: String, deepLink: String, data: WEGCampaignData) -> Bool {
        FlutterPersonalizationSdkPlugin.methodChannel?.sendCallbacks(
            methodName: Constants.METHOD_NAME_ON_CAMPAIGN_CLICKED,
            message: Utils.generateMap(actionId: actionId, deepLink: deepLink, data: data)
        )
        return !autoHandleClick
    }
    
}
    


extension CallbackHandler:PropertyRegistryCallback{
    func onPropertyCacheCleared(for screenDetails: [AnyHashable : Any]) {
        print("WEP InlineWidget \(screenDetails["screen_name"]!)")
        
        DataRegistry.instance.impressionTrackedForTargetviews.removeAll()
        if let screenName = screenDetails["screen_name"] as? String{
            DataRegistry.instance.screenNavigated(screenName: screenName)
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
