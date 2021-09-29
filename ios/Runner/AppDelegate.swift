import UIKit
import Flutter
import GoogleMaps
//import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
        }
    GMSServices.provideAPIKey("AIzaSyB1fGTkELSe_FGtwbzpTY8J7kKJZrio3fk")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}
