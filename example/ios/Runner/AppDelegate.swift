import UIKit
import Flutter
import WebEngage
import webengage_flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var bridge:WebEngagePlugin? = nil
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    WebEngage.sharedInstance().pushNotificationDelegate = self.bridge
    WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions, notificationDelegate: self.bridge)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
