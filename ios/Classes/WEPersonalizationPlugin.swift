import Flutter
import UIKit
import WEPersonalization
public class WEPersonalizationPlugin: NSObject, FlutterPlugin {
    
    public static var methodChannel : FlutterMethodChannel? = nil
    public static var instance :WEPersonalizationPlugin? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        if(methodChannel == nil){
            methodChannel = FlutterMethodChannel(name: Constants.PERSONALIZATION_SDK, binaryMessenger: registrar.messenger())
            registrar.register(InlineWidgetFactory(messenger: registrar.messenger()), withId: Constants.CHANNEL_INLINE_VIEW)
            instance = WEPersonalizationPlugin()
            registrar.addMethodCallDelegate(instance!, channel: methodChannel!)
        }
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        WEPersonalizationPlugin.methodChannel = nil;
        WEPersonalizationPlugin.instance = nil;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case Constants.METHOD_NAME_REGISTER:
            WEPropertyRegistry.shared.registerProperty(details: call.arguments as! [String:Any])
            result(true)
        case Constants.METHOD_NAME_DEREGISTER:
            let _result = WEPropertyRegistry.shared.deRegisterProperty(details: call.arguments as! [String:Any])
            result(_result)
        case Constants.METHOD_NAME_INIT:
            UserDefaults.standard.set(false, forKey: WEPersonalization.Constants.KEY_SHOULD_AUTO_TRACK_IMPRESSIONS)
            WEPersonalization.shared.initialise()
            WEPersonalization.shared.registerWECampaignCallback(WEPluginCallbackHandler.shared)
            WEPersonalization.shared.registerPropertyRegistryCallbacks(WEPluginCallbackHandler.shared)
        case Constants.METHOD_NAME_SEND_CLICK:
            let map = call.arguments as! [String:Any]
            let id = map[Constants.PAYLOAD_ID] as! Int
            let data = map[Constants.PAYLOAD_DATA] as? [String:Any]
            WEPropertyRegistry.shared.trackClick(id: id, attributes: data)
            result(true)
        case Constants.METHOD_NAME_SEND_IMPRESSION:
            let map = call.arguments as! [String:Any]
            let id = map[Constants.PAYLOAD_ID] as! Int
            let data = map[Constants.PAYLOAD_DATA] as? [String:Any]
            WEPropertyRegistry.shared.trackImpression(id: id, attributes: data)
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
}
