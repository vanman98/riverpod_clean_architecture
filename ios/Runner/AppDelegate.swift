import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "app.config", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { call, result in
      let info = Bundle.main.infoDictionary
      if call.method == "appEnv" {
        result(info?["APP_ENV"] as? String ?? "dev")
      } else if call.method == "baseUrl" {
        result(info?["API_BASE_URL"] as? String ?? "")
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
