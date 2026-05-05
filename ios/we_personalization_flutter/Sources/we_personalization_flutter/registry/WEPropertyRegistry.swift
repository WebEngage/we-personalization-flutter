import WEPersonalization

class WEPropertyRegistry{
    private init(){}
    
    static let shared = WEPropertyRegistry()
    
    private var registryMap = [Int:WEProperty]()
    internal var impressionTrackedForTargetviews:[String] = []
    
    
    public func registerProperty(details:[String:Any]){
        WELogger.d("WEP I : register property for \(details)")
        let id = details[WEConstants.PAYLOAD_ID] as! Int
        let weghinline = WEProperty(id: id,
                                    screenName: details[WEConstants.PAYLOAD_SCREEN_NAME] as! String,
                                    propertyID: details[WEConstants.PAYLOAD_IOS_PROPERTY_ID] as! Int)
        
        registryMap[id] = weghinline
        WEPersonalization.shared.registerWEPlaceholderCallback(weghinline.propertyID, self)
        
    }
    
    public func deRegisterProperty(details:[String:Any])->Bool{
        WELogger.d("WEP I : deregister property for \(details)")
        let id = details[WEConstants.PAYLOAD_ID] as! Int
        return deRegisterProperty(forId: id)
    }
    
    private func deRegisterProperty(forId:Int)->Bool{
        let contains = registryMap[forId] != nil
        if(contains){
            WEPersonalization.shared.unregisterWEPlaceholderCallback(registryMap[forId]!.propertyID)
        }
        registryMap.removeValue(forKey: forId)
        return contains
        
    }
    
    private func getProperty(targetViewTag:Int)->WEProperty?{
        for(_,weginline) in registryMap{
            if(weginline.propertyID == targetViewTag){
                return weginline
            }
        }
        return nil
    }
    
    //MARK: - Impression tracking details helper
    internal func setImpressionTrackedDetails(forTag:Int,campaignId:String){
        let key = "\(forTag)_\(campaignId)"
        self.impressionTrackedForTargetviews.append(key)
    }
    
    internal func isImpressionAlreadyTracked(forTag:Int,campaignId:String)->Bool{
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
    
    //MARK: - Impression tracking helper
    func trackImpression(id:Int, attributes: [String : Any]?){
        
        if(registryMap[id] != nil){
            var data = registryMap[id]!;
            WELogger.d("WEP I : track Impression for ID : \(data.propertyID) \(String(describing: attributes))")
            data.campaignData?.trackImpression(attributes: attributes)
        }
    }
    
    //MARK: - Impression tracking helper
    func trackClick(id:Int, attributes: [String : Any]?){
        if(registryMap[id] != nil){
            var data = registryMap[id]!;
            WELogger.d("WEP I : track Click for ID : \(data.propertyID) \(String(describing: attributes))")
            data.campaignData?.trackClick(actionDetails: (nil,nil), attributes: attributes)
        }
    }
    
    
}

extension WEPropertyRegistry : WEPlaceholderCallback{
    internal func onDataReceived(_ data: WECampaignData) {
        var weProperty = getProperty(targetViewTag: data.targetViewTag)
        weProperty?.campaignData = data
        WELogger.d("WEP I : onDataReceived \(weProperty != nil) \(WEPersonalizationPlugin.methodChannel != nil)")
        if(weProperty != nil){
            WEPersonalizationPlugin.methodChannel?.sendCallbacks(methodName: WEConstants.METHOD_NAME_ON_DATA_RECEIVED,
                                                                 message: WEUtils.generateMap(weginline: weProperty!,
                                                                                            campaignData: data))
        }
    }
    
    internal func onRendered(data: WECampaignData) {
        WELogger.d("WEP I : onRendered \(data.targetViewTag)")
        var weProperty = getProperty(targetViewTag: data.targetViewTag)
        weProperty?.campaignData = data
        if(weProperty != nil){
            WEPersonalizationPlugin.methodChannel?.sendCallbacks(methodName: WEConstants.METHOD_NAME_ON_RENDERED,
                                                                 message: WEUtils.generateMap(weginline: weProperty!,
                                                                                            campaignData: data))
        }
    }
    
    internal func onPlaceholderException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        WELogger.d("WEP I : onPlaceholderException \(String(describing: campaignId)) pId : \(targetViewId) error \(exception.localizedDescription)")
        let weProperty = getProperty(targetViewTag: Int(targetViewId) ?? -1)
        if(weProperty != nil){
            WEPersonalizationPlugin.methodChannel?.sendCallbacks(methodName: WEConstants.METHOD_NAME_ON_PLACEHOLDER_EXCEPTION,
                                                                 message: WEUtils.generateMap(weginline: weProperty!,
                                                                                            campaignId: campaignId,
                                                                                            targetViewId: targetViewId,
                                                                                            error: exception))
        }
    }
}
