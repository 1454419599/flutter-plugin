import Flutter
import UIKit

public class SwiftXiMaLaYaPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "xi_ma_la_ya_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftXiMaLaYaPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
