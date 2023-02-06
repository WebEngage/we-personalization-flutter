import Foundation
import UIKit
import WEPersonalization
import WebEngage
import Flutter

public class InlineViewWidget:UIView,ScreenNavigatorCallback{
    var _inlineView:WEInlineView? = nil
    var map :Dictionary<String,Any?>? = nil
    var methodChannel:FlutterMethodChannel? = nil
    var wegInline:WEGHInline? = nil

    func setMap(map : Dictionary<String,Any?>) {
        self.map = map
        CallbackHandler.instance.setScreenNavigatorCallback(screenName: map[Constants.PAYLOAD_SCREEN_NAME] as! String, screenNavigatedCallback: self)
        setupView()
      }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(frame: CGRect,methodChannel:FlutterMethodChannel) {
        super.init(frame: frame)
        self.methodChannel = methodChannel
      }
      
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }
    
    private func setupView(){
        let width = map![Constants.PAYLOAD_VIEW_WIDTH] as! Int
        let height = map![Constants.PAYLOAD_VIEW_HEIGHT] as! Int
        let propertyId = map![Constants.PAYLOAD_IOS_PROPERTY_ID] as! Int
       
        _inlineView = WEInlineView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        _inlineView!.tag = propertyId
        _inlineView?.load(tag: propertyId, callbacks: self)
        addSubview(_inlineView!)    
    }
    
    func generateInlineView()->WEGHInline{
        if(wegInline == nil){
            wegInline = WEGHInline(id: map![Constants.PAYLOAD_ID] as! Int,
                                   screenName: map![Constants.PAYLOAD_SCREEN_NAME] as! String,
                                   propertyID: map![Constants.PAYLOAD_IOS_PROPERTY_ID] as! Int)
        }
        return wegInline!
    }
    
}

extension InlineViewWidget : WEPlaceholderCallback{
    public func onRendered(data: WEGCampaignData) {
        methodChannel?.sendCallbacks(methodName: Constants.METHOD_NAME_ON_RENDERED,
                                     message: Utils.generateMap(weginline: generateInlineView(),
                                                                campaignData: data))
    }
    public func onDataReceived(_ data: WEGCampaignData) {
        methodChannel?.sendCallbacks(methodName: Constants.METHOD_NAME_ON_DATA_RECEIVED,
                                     message: Utils.generateMap(weginline: generateInlineView(),
                                                                campaignData: data))
    }
    public func onPlaceholderException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        methodChannel?.sendCallbacks(methodName: Constants.METHOD_NAME_ON_PLACEHOLDER_EXCEPTION,
                                     message: Utils.generateMap(weginline: generateInlineView(),
                                                                campaignId: campaignId,
                                                                targetViewId: targetViewId,
                                                                error: exception))
    }
    
    func screenNavigated(screenName: String) {
        print("WEP H screenNavigated \(screenName)")
        if(_inlineView != nil){
            _inlineView?.load(tag: _inlineView!.tag, callbacks: self)
        }
    }
}

