import Flutter
public class InlineWidget:NSObject, FlutterPlatformView {
    private var _inlineView: InlineViewWidget
    private var _methodChannel: FlutterMethodChannel
    
    public func view() -> UIView {
        return _inlineView
    }
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
    
        _methodChannel = FlutterMethodChannel(name: "\(Constants.CHANNEL_INLINE_VIEW)_\(viewId)", binaryMessenger: messenger)
        _inlineView = InlineViewWidget(frame: frame,methodChannel: _methodChannel)
        _inlineView.setMap(map: args as! Dictionary<String,Any?>)
        super.init()
        _methodChannel.setMethodCallHandler(onMethodCall)
    }


    func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        switch(call.method){
        case Constants.METHOD_NAME_SEND_CLICK:
            let map = call.arguments as! [String:Any]
            let data = map[Constants.PAYLOAD_DATA] as? [String:Any]
            _inlineView.weProperty?.campaignData?.trackClick(attributes: data)
            result(true)
        case Constants.METHOD_NAME_SEND_IMPRESSION:
            let map = call.arguments as! [String:Any]
            let data = map[Constants.PAYLOAD_DATA] as? [String:Any]
            _inlineView.weProperty?.campaignData?.trackImpression(attributes: data)
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    

    
}
extension FlutterMethodChannel{
    func sendCallbacks(methodName:String,message:[String:Any]){
        var messagePayload = [String:Any]()
        messagePayload[Constants.PAYLOAD] = message
        invokeMethod(methodName, arguments: messagePayload)
    }
}
