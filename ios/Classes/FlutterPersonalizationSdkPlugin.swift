import Flutter
import UIKit
import WEPersonalization
public class FlutterPersonalizationSdkPlugin: NSObject, FlutterPlugin {
    
   public static var methodChannel : FlutterMethodChannel? = nil
    public static var instance :FlutterPersonalizationSdkPlugin? = nil
    
  public static func register(with registrar: FlutterPluginRegistrar) {
      if(methodChannel == nil){
          methodChannel = FlutterMethodChannel(name: Constants.PERSONALIZATION_SDK, binaryMessenger: registrar.messenger())
          registrar.register(InlineWidgetFactory(messenger: registrar.messenger()), withId: Constants.CHANNEL_INLINE_VIEW)
          instance = FlutterPersonalizationSdkPlugin()
          registrar.addMethodCallDelegate(instance!, channel: methodChannel!)
      }
   
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case Constants.METHOD_NAME_REGISTER:
        DataRegistry.instance.registerData(map: call.arguments as! [String:Any])
        result(true)
    case Constants.METHOD_NAME_DEREGISTER:
        let _result = DataRegistry.instance.removeData(map: call.arguments as! [String:Any])
        result(_result)
    case Constants.METHOD_NAME_INIT:
        UserDefaults.standard.set(false, forKey: WEPersonalization.Constants.KEY_SHOULD_AUTO_TRACK_IMPRESSIONS)
        WEPersonalization.shared.registerWECampaignCallback(CallbackHandler.instance)
        WEPersonalization.shared.registerPropertyRegistryCallbacks(CallbackHandler.instance)
        WEPersonalization.shared.initialise()
    case Constants.METHOD_NAME_AUTO_HANDLE_CLICK:
        CallbackHandler.instance.autoHandleClick = call.arguments as! Bool
        result(true)
    case Constants.METHOD_NAME_SEND_CLICK:
        let map = call.arguments as! [String:Any]
        let id = map[Constants.PAYLOAD_ID] as! Int
        let data = map[Constants.PAYLOAD_DATA] as? [String:Any]
        DataRegistry.instance.trackClick(id: id, attributes: data)
        result(true)
    case Constants.METHOD_NAME_SEND_IMPRESSION:
        let map = call.arguments as! [String:Any]
        let id = map[Constants.PAYLOAD_ID] as! Int
        let data = map[Constants.PAYLOAD_DATA] as? [String:Any]
        DataRegistry.instance.trackImpression(id: id, attributes: data)
        result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

}
