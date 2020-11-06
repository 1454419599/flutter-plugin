import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    application.beginReceivingRemoteControlEvents()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == .remoteControl {
            print(event?.subtype ?? "event.type")
            NotificationCenter.default.post(name: NSNotification.Name("playController"), object: nil, userInfo: [
                "subtype": event?.subtype ?? .none
            ])
        }
    }
}
