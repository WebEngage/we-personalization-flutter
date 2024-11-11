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
    var isScrollViewListnerAdded = false


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
    
    private func setupView() {
        if let map = map {
            
            if let width = map[WEConstants.PAYLOAD_VIEW_WIDTH] as? NSNumber,
               let height = map[WEConstants.PAYLOAD_VIEW_HEIGHT] as? NSNumber,
               let propertyId = map[WEConstants.PAYLOAD_IOS_PROPERTY_ID] as? NSNumber {
                
                // Convert to Int by rounding or truncating as needed
                let intWidth = Int(width.intValue) // Truncate to nearest Int
                let intHeight = Int(height.intValue)
                let intPropertyId = Int(propertyId.intValue)
                
                _inlineView = WEInlineView(frame: CGRect(x: 0, y: 0, width: intWidth, height: intHeight))
                _inlineView!.tag = intPropertyId
                _inlineView?.load(tag: intPropertyId, callbacks: self)
                print("InlineWidget: Load view called")
                addSubview(_inlineView!)
            } else {
                print("Error: Width, height, or propertyId is missing or has an unexpected type.")
            }
        }
    }

    
    public override func didMoveToWindow() {
        monitorVisibilityAndFireEvent()
    }
    
    func monitorVisibilityAndFireEvent(){
        if let data = self.campaignData{ // For Impression
            if self.isVisibleToUser{
                if WEPropertyRegistry.shared.isImpressionAlreadyTracked(forTag: data.targetViewTag, campaignId: data.campaignId!) == false {
                        self.campaignData?.trackImpression(attributes: nil)
                        WEPropertyRegistry.shared.setImpressionTrackedDetails(forTag: data.targetViewTag, campaignId: data.campaignId!)
                } //  dont add else because addScrollViewListener for impressiion is going to after rendered methond is called
            }
        }
        
        // for cg
        if(self.isVisibleToUser){
            fireCGEvent()
        }else{
            addScrollViewListener()
        }
    }
    
    func fireCGEvent(){
       WEPersonalization.shared.trackCGEvent(forPropertyId: _inlineView!.tag)
        WEPersonalization.shared.registerCampaignControlGroupCallback(tag: _inlineView!.tag, callback: self)
    }
    
    func addScrollViewListener(){
        if(!isScrollViewListnerAdded){
            if let scrollView = self.getScrollview(view: self) {
                isScrollViewListnerAdded = true
                scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new, .old], context: nil)
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
        WEPersonalization.shared.deRegisterCampaignControlGroupCallback(tag: _inlineView!.tag)
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

extension WEInlineViewWidget : WECampaignControlInternalCallback{
    public func onControlGroupTriggered(propertyID: Int) {
        self.monitorVisibilityAndFireEvent()
    }
}

extension WEInlineViewWidget : WEPlaceholderCallback{
    public func onRendered(data: WECampaignData) {
        WELogger.d("WEP I : \(data.targetViewTag) || \(self.screenName) || \(String(describing: weProperty?.id))")
        self.campaignData = data
        methodChannel?.sendCallbacks(methodName: WEConstants.METHOD_NAME_ON_RENDERED,
                                     message: WEUtils.generateMap(weginline: generateInlineView(),
                                                                campaignData: data))
        monitorVisibilityAndFireEvent()
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
            self.campaignData?.trackImpression(attributes: nil)
            fireCGEvent()
            if let scrollview = self.getScrollview(view: self){
                // remove observer added to scrollview
                scrollview.removeObserver(self, forKeyPath:  #keyPath(UIScrollView.contentOffset))
                isScrollViewListnerAdded = false
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
