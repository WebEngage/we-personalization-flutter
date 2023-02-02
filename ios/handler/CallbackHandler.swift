//
//  CallbackHandler.swift
//  flutter_personalization_sdk
//
//  Created by Milind Keni on 03/02/23.
//

import Foundation
import WEPersonalization

class CallbackHandler : WECampaignCallback{

    private init(){}
    
    static let instance = CallbackHandler()
    
    var autoHandleClick = true
    
    func onCampaignPrepared(_ data: WEGCampaignData) -> WEGCampaignData {
        return data
    }
    
    func onCampaignShown(data: WEGCampaignData) {
        
    }
    
    func onCampaignException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        
    }
    
    func onCampaignClicked(actionId: String, deepLink: String, data: WEGCampaignData) -> Bool {
        return autoHandleClick
    }
    
}
