import WEPersonalization

class DataRegistry{
    private init(){}
    
    static let instance = DataRegistry()
    
    private var registryMap = [Int:WEGHInline]()
    internal var impressionTrackedForTargetviews:[String] = []
    
    
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
        if(contains){
            WEPersonalization.shared.unregisterWEPlaceholderCallback(registryMap[id]!.propertyID)
        }
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
    
    internal func setImpressionTrackedDetails(forTag:Int,campaignId:String){
        let key = "\(forTag)_\(campaignId)"
        self.impressionTrackedForTargetviews.append(key)
    }
    
    func isImpressionAlreadyTracked(forTag:Int,campaignId:String)->Bool{
        var shouldReturn = false
//        self.serialQueue.sync {
            let key = "\(forTag)_\(campaignId)"
            if self.impressionTrackedForTargetviews.first(where: {$0 == key}) != nil{
                shouldReturn = true
            }else if let trackedCampaign = self.impressionTrackedForTargetviews.first(where: { $0.hasPrefix("\(forTag)_") }) {
                // Over here we can find same property has the impression tracked for another campaign
                // so remove that tracked entry and return as false as we haven't tracked the new campaign
                // new campaign is diff to track
                self.impressionTrackedForTargetviews.removeAll(where: {$0 == trackedCampaign})
                shouldReturn = false
            }
//        }
        return shouldReturn
    }
    
    func screenNavigated(screenName:String){
        for(_,weginline) in registryMap{
            if(weginline.screenName == screenName){
                WEPersonalization.shared.registerWEPlaceholderCallback(weginline.propertyID, self)
            }
        }
    }
    
    public func trackImpression(id:Int, attributes: [String : Any]?){
        if(registryMap[id] != nil){
            var data = registryMap[id]!;
            data.campaignData?.trackImpression(attributes: attributes)
        }
    }

    public func trackClick(id:Int, attributes: [String : Any]?){
        if(registryMap[id] != nil){
            var data = registryMap[id]!;
            data.campaignData?.trackClick(actionDetails: (nil,nil), attributes: attributes)
        }
    }
    
    
}

extension DataRegistry : WEPlaceholderCallback{
    internal func onDataReceived(_ data: WEGCampaignData) {
        var wegInline = getWEGHinline(targetViewTag: data.targetViewTag)
        wegInline?.campaignData = data
        print("_platformCallHandler onDataReceived iOS \(wegInline != nil) \(FlutterPersonalizationSdkPlugin.methodChannel != nil)")
        if(wegInline != nil){
            FlutterPersonalizationSdkPlugin.methodChannel?.sendCallbacks(methodName: Constants.METHOD_NAME_ON_DATA_RECEIVED,
                                         message: Utils.generateMap(weginline: wegInline!,
                                                                    campaignData: data))
        }
    }
    
   internal func onRendered(data: WEGCampaignData) {
       print("_platformCallHandler onRendered iOS \(data.targetViewTag)")
        var wegInline = getWEGHinline(targetViewTag: data.targetViewTag)
        wegInline?.campaignData = data
        if(wegInline != nil){
            FlutterPersonalizationSdkPlugin.methodChannel?.sendCallbacks(methodName: Constants.METHOD_NAME_ON_RENDERED,
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
