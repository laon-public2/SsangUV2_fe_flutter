import UIKit
import Flutter
import GoogleMaps
import Firebase
//import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
// 네이티브 코드
//    UNUserNotificationCenter.current().delegate = self
//    Messaging.messaging().delegate = self
//
//    let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
//    UNUserNotificationCenter
//        .current()
//        .requestAuthorization(options: authOption, completionHandler: {(_, _) in })
//    application.registerForRemoteNotifications()
    GMSServices.provideAPIKey("AIzaSyB1fGTkELSe_FGtwbzpTY8J7kKJZrio3fk")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
