import Flutter
import UIKit
import WEPersonalization
public class WEPersonalizationPlugin: NSObject, FlutterPlugin {
    
    public static var methodChannel : FlutterMethodChannel? = nil
    public static var instance :WEPersonalizationPlugin? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        WELogger.d("register attach to engine")
        if(methodChannel == nil){
            methodChannel = FlutterMethodChannel(name: WEConstants.PERSONALIZATION_SDK, binaryMessenger: registrar.messenger())
            registrar.register(WEInlineWidgetFactory(messenger: registrar.messenger()), withId: WEConstants.CHANNEL_INLINE_VIEW)
            instance = WEPersonalizationPlugin()
            registrar.addMethodCallDelegate(instance!, channel: methodChannel!)
        }
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        WELogger.d("detachFromEngine")
        WEPersonalizationPlugin.methodChannel = nil;
        WEPersonalizationPlugin.instance = nil;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        WELogger.d("WEP I \(call.method) \(String(describing: call.arguments))")
        switch call.method {
        case WEConstants.METHOD_NAME_REGISTER:
            WEPropertyRegistry.shared.registerProperty(details: call.arguments as! [String:Any])
            result(true)
        case WEConstants.METHOD_NAME_DEREGISTER:
            let _result = WEPropertyRegistry.shared.deRegisterProperty(details: call.arguments as! [String:Any])
            result(_result)
        case WEConstants.METHOD_NAME_INIT:
            WELogger.initLogger()
            WELogger.d("WEP I \(call.method) \(String(describing: call.arguments))")
            UserDefaults.standard.set(false, forKey: WEPersonalization.Constants.KEY_SHOULD_AUTO_TRACK_IMPRESSIONS)
            WEPersonalization.shared.initialise()
            WEPersonalization.shared.registerWECampaignCallback(WEPluginCallbackHandler.shared)
            WEPersonalization.shared.registerPropertyRegistryCallbacks(WEPluginCallbackHandler.shared)
        case WEConstants.METHOD_NAME_SEND_CLICK:
            let map = call.arguments as! [String:Any]
            let id = map[WEConstants.PAYLOAD_ID] as! Int
            let data = map[WEConstants.PAYLOAD_DATA] as? [String:Any]
            WEPropertyRegistry.shared.trackClick(id: id, attributes: data)
            result(true)
        case WEConstants.METHOD_NAME_SEND_IMPRESSION:
            let map = call.arguments as! [String:Any]
            let id = map[WEConstants.PAYLOAD_ID] as! Int
            let data = map[WEConstants.PAYLOAD_DATA] as? [String:Any]
            WEPropertyRegistry.shared.trackImpression(id: id, attributes: data)
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
}
