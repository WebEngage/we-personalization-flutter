import Foundation
import UIKit
import WEPersonalization
import WebEngage
import Flutter


public class WEInlineViewWidget:UIView{

    var _inlineView:WEInlineView? = nil
    var map :Dictionary<String,Any?>? = nil
    var methodChannel:FlutterMethodChannel? = nil
    var campaignData:WECampaignData? = nil
    var weProperty:WEProperty? = nil
    var screenName = ""


    func setMap(map : Dictionary<String,Any?>) {
        self.map = map
        weProperty = generateInlineView()
        screenName = map[WEConstants.PAYLOAD_SCREEN_NAME] as! String;
        NotificationCenter.default.addObserver(self, selector: #selector(self.screenNavigate(notification:)), name: Notification.Name(screenName), object: nil)
        WELogger.d("InlineWidget added observer \(screenName)")
        setupView()
      }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc func screenNavigate(notification: Notification) {
        if(_inlineView != nil){
            print("InlineWidget: \(screenName)")
            _inlineView?.load(tag: _inlineView!.tag, callbacks: self)
        }
    }
    
    deinit{
        WELogger.d("InlineWidget dinit \(screenName)")
        removeData()
    }
    
    public init(frame: CGRect,methodChannel:FlutterMethodChannel) {
        super.init(frame: frame)
        self.methodChannel = methodChannel
      }
      
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }
    
    private func setupView(){
        if let map = map{
            let width = map[WEConstants.PAYLOAD_VIEW_WIDTH] as! Int
            let height = map[WEConstants.PAYLOAD_VIEW_HEIGHT] as! Int
            let propertyId = map[WEConstants.PAYLOAD_IOS_PROPERTY_ID] as! Int
            
            _inlineView = WEInlineView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            _inlineView!.tag = propertyId
            _inlineView?.load(tag: propertyId, callbacks: self)
            print("InlineWidget: Load view called")
            addSubview(_inlineView!)
        }
    }
    
    public override func didMoveToWindow() {
        if let data = self.campaignData{
            if self.isVisibleToUser{
                if WEPropertyRegistry.shared.isImpressionAlreadyTracked(forTag: data.targetViewTag, campaignId: data.campaignId!) == false{
                    self.campaignData?.trackImpression(attributes: nil)
                    WEPropertyRegistry.shared.setImpressionTrackedDetails(forTag: data.targetViewTag, campaignId: data.campaignId!)
                }
            }
        }
    }
    
    func generateInlineView()->WEProperty{
        return WEProperty(id: map![WEConstants.PAYLOAD_ID] as! Int,
                                   screenName: map![WEConstants.PAYLOAD_SCREEN_NAME] as! String,
                                   propertyID: map![WEConstants.PAYLOAD_IOS_PROPERTY_ID] as! Int)
        
    }
    
    func removeData(){
        WELogger.d("WEP I : removed \(screenName) | \(String(describing: weProperty?.id))")
        NotificationCenter.default.removeObserver(self)
        if let map = map,
           let propertyID = map[WEConstants.PAYLOAD_IOS_PROPERTY_ID] as? Int {
            WEPersonalization.shared.unregisterWEPlaceholderCallback(propertyID)
        }
        _inlineView = nil
        map = nil
        methodChannel = nil
        campaignData = nil
        weProperty = nil
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            removeData()
        }
    }
    
}

extension WEInlineViewWidget : WEPlaceholderCallback{
    public func onRendered(data: WECampaignData) {
        WELogger.d("WEP I : \(data.targetViewTag) || \(self.screenName) || \(String(describing: weProperty?.id))")
        self.campaignData = data
        methodChannel?.sendCallbacks(methodName: WEConstants.METHOD_NAME_ON_RENDERED,
                                     message: WEUtils.generateMap(weginline: generateInlineView(),
                                                                campaignData: data))
        if self.isVisibleToUser{
            if WEPropertyRegistry.shared.isImpressionAlreadyTracked(forTag: data.targetViewTag, campaignId: data.campaignId!) == false{
                self.campaignData?.trackImpression(attributes: nil)
                WEPropertyRegistry.shared.setImpressionTrackedDetails(forTag: data.targetViewTag, campaignId: data.campaignId!)
            }
        }
    }

    public func onDataReceived(_ data: WECampaignData) {
        WELogger.d("WEP I : \(data.targetViewTag)")
        methodChannel?.sendCallbacks(methodName: WEConstants.METHOD_NAME_ON_DATA_RECEIVED,
                                     message: WEUtils.generateMap(weginline: generateInlineView(),
                                                                campaignData: data))
    }

    public func onPlaceholderException(_ campaignId: String?, _ targetViewId: String, _ exception: Error) {
        WELogger.d("WEP I : \(targetViewId) error : \(exception.localizedDescription)")
        methodChannel?.sendCallbacks(methodName: WEConstants.METHOD_NAME_ON_PLACEHOLDER_EXCEPTION,
                                     message: WEUtils.generateMap(weginline: generateInlineView(),
                                                                campaignId: campaignId,
                                                                targetViewId: targetViewId,
                                                                error: exception))
    }
            
    func getScrollview(view:UIView)->UIScrollView?{
        if let superview = view.superview, superview is UIScrollView{
            return view.superview as? UIScrollView
        }else if let scrollview = view.subviews.first(where: {$0 is UIScrollView}) as? UIScrollView{
            return scrollview
        }
        return view.superview == nil ? nil : getScrollview(view: view.superview!)
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.isVisibleToUser == true{
            if let scrollview = self.getScrollview(view: self){
                // remove observer added to scrollview
                scrollview.removeObserver(self, forKeyPath:  #keyPath(UIScrollView.contentOffset))
                self.campaignData?.trackImpression(attributes: nil)
            }
        }
    }
}


extension UIView{
    var isVisibleToUser: Bool {
        
        if isHidden || alpha == 0 || superview == nil || window == nil {
            return false
        }
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return false
        }
        
        let viewFrame = convert(bounds, to: rootViewController.view)
        
        let topSafeArea: CGFloat
        
        if #available(iOS 11.0, *) {
            topSafeArea = rootViewController.view.safeAreaInsets.top
//            bottomSafeArea = rootViewController.view.safeAreaInsets.bottom
        } else {
            topSafeArea = rootViewController.topLayoutGuide.length
//            bottomSafeArea = rootViewController.bottomLayoutGuide.length
        }
        
        return viewFrame.maxX >= 0 &&
               viewFrame.minX <= rootViewController.view.bounds.width &&
                         viewFrame.maxY >= topSafeArea &&
               viewFrame.minY <= rootViewController.view.bounds.height
    }
}
