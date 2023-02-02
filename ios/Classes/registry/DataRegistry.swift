import WEPersonalization

class DataRegistry{
    private init(){}
    
    static let instance = DataRegistry()
    
    private var registryMap = [Int:WEGHInline]()
    
    
    public func registerData(map:[String:Any]){
        var id = map[Constants.PAYLOAD_ID] as! Int
        let weghinline = WEGHInline(id: id,
            screenName: map[Constants.PAYLOAD_SCREEN_NAME] as! String,
            propertyID: map[Constants.PAYLOAD_IOS_PROPERTY_ID] as! Int)
        
        registryMap[id] = weghinline
        WEPersonalization.shared.registerWEPlaceholderCallback(weghinline.propertyID, self)
        
    }
    
   public func removeData(map:[String:Any])->Bool{
        let id = map[Constants.PAYLOAD_ID] as! Int
        return removeData(id: id)
    }
    
    private func removeData(id:Int)->Bool{
        let contains = registryMap[id] != nil
        registryMap.removeValue(forKey: id)
        return contains
        
    }
    
   private func getWEGHinline(targetViewTag:Int)->WEGHInline?{
        for(_,weginline) in registryMap{
            if(weginline.propertyID == targetViewTag){
                return weginline
            }
        }
        return nil
    }
    
}

extension DataRegistry : WEPlaceholderCallback{
    internal func onDataReceived(_ data: WEGCampaignData) {
        let wegInline = getWEGHinline(targetViewTag: data.targetViewTag)
        if(wegInline != nil){
            FlutterPersonalizationSdkPlugin.methodChannel?.sendCallbacks(methodName: Constants.METHOD_NAME_ON_RENDERED,
                                         message: Utils.generateMap(weginline: wegInline!,
                                                                    campaignData: data))
        }
    }
    
   internal func onRendered(data: WEGCampaignData) {
        let wegInline = getWEGHinline(targetViewTag: data.targetViewTag)
        if(wegInline != nil){
            FlutterPersonalizationSdkPlugin.methodChannel?.sendCallbacks(methodName: Constants.METHOD_NAME_ON_DATA_RECEIVED,
                                         message: Utils.generateMap(weginline: wegInline!,
                                                                    campaignData: data))
        }
    }
    
   internal func onPlaceholderException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        //TODO: change targetviewid to INT
        let wegInline = getWEGHinline(targetViewTag: Int(targetViewId) ?? -1)
        if(wegInline != nil){
            FlutterPersonalizationSdkPlugin.methodChannel?.sendCallbacks(methodName: Constants.METHOD_NAME_ON_PLACEHOLDER_EXCEPTION,
                                         message: Utils.generateMap(weginline: wegInline!,
                                                                    campaignId: campaignId,
                                                                    targetViewId: targetViewId,
                                                                    error: exception))
        }
    }
}
