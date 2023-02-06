import WEPersonalization
class CallbackHandler : WECampaignCallback{
    
    var mapOfScreenNavigatedCallback = [String:[ScreenNavigatorCallback]]()
    
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
            message: Utils.generateMap(campaignId: campaignId, targetViewId: targetViewId, error: exception.localizedDescription as! Error)
                )
    }
    
    func onCampaignClicked(actionId: String, deepLink: String, data: WEGCampaignData) -> Bool {
        FlutterPersonalizationSdkPlugin.methodChannel?.sendCallbacks(
            methodName: Constants.METHOD_NAME_ON_CAMPAIGN_CLICKED,
                    message: Utils.generateMap(actionId: actionId, deepLink: deepLink, data: data)
        )
        return autoHandleClick
    }
    
    func setScreenNavigatorCallback(screenName:String,screenNavigatedCallback:ScreenNavigatorCallback){
        if(mapOfScreenNavigatedCallback.contains(where: {$0.key == screenName})){
            var list = mapOfScreenNavigatedCallback[screenName]
            list?.append(screenNavigatedCallback)
        }else{
            mapOfScreenNavigatedCallback[screenName] = []
            var list = mapOfScreenNavigatedCallback[screenName]
            list?.append(screenNavigatedCallback)
        }
    }
    
    func removeScreenNavigatorCallback(screenName:String,screenNavigatedCallback:ScreenNavigatorCallback){
//        if(mapOfScreenNavigatedCallback.contains(where: {$0.key == screenName})){
//            var array = mapOfScreenNavigatedCallback[screenName]
//            if let index = array?.firstIndex(of: screenNavigatedCallback) {
//                array.remove(at: index)
//            }
        }
    }
    


extension CallbackHandler:PropertyRegistryCallback{
    func onPropertyCacheCleared(for screenDetails: [AnyHashable : Any]) {
        print("WEP H \(screenDetails["screen_name"]!)")
        DataRegistry.instance.impressionTrackedForTargetviews.removeAll()
        if let screenName = screenDetails["screen_name"] as? String{
            let list = mapOfScreenNavigatedCallback[screenName]
            if(list != nil){
                for callback in list!{
                    callback.screenNavigated(screenName: screenName)
                }
            }
           
        }
    }
}

protocol ScreenNavigatorCallback{
     func screenNavigated(screenName:String)
}
