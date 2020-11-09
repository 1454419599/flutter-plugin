import Flutter
import UIKit

public class SwiftXiMaLaYaPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "xi_ma_la_ya_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftXiMaLaYaPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    XiMaLaYa.channel = channel
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let method = call.method
    switch method {
    case "initXiMaLaYa":
        XiMaLaYa.sharedInstance.initXiMaLaYa(call, result: result)
    case "initPlayerManager":
        XiMaLaYa.sharedInstance.initPlayerManager()
    case "playerController":
        XiMaLaYaPlayer.onPlayerMethodCallHandler(call, result: result)
    case "getCategories":
        getCategories(result: result)
    case "getTags":
        getTags(call, result: result)
    case "getAlbumList":
        getAlbums(call, result: result)
    case "getTracks":
        getTracks(call, result: result)
    case "getLastPlayTracks":
        getLastPlayTracks(call, result: result)
    case "getMetadataList":
        getMetadata(call, result: result)
    case "getMetadataAlbumList":
        getMetadataAlbums(call, result: result)
    default:
        print("未匹配方法\(method)")
    }
  }
    
    func getTags(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arg = call.arguments as? Dictionary<String, String> {
            let categoryId = Int(arg["categoryId"]!)!
            let type = Int(arg["type"]!)!
            getTagsList(categoryId: categoryId, type: type, result: result)
        } else {
            result(FlutterError.init(code: "0", message: "getTags arguments as? Dictionary<String, String>", details: nil))
        }
    }
    
    func getAlbums(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arg = call.arguments as? Dictionary<String, String> {
            let categoryId = Int(arg["categoryId"]!)!
            let tagName = arg["tagName"]
            let calcDimension = Int(arg["calcDimension"]!)!
            let page = Int(arg["page"]!)!
            let count = Int(arg["count"]!)!
            getAlbumsList(categoryId: categoryId, tagName: tagName, calcDimension: calcDimension, page: page, count: count, result: result)
        } else {
            result(FlutterError.init(code: "0", message: "getAlbums arguments as? Dictionary<String, String>", details: nil))
        }
    }
    
    func getTracks(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arg = call.arguments as? Dictionary<String, String> {
            let albumId = Int(arg["albumId"]!)!
            let sort = arg["sort"]
            let page = Int(arg["page"]!)!
            let count = Int(arg["count"]!)!
            getTracksList(albumId: albumId, sort: sort, page: page, count: count, result: result)
        } else {
            result(FlutterError.init(code: "0", message: "getTracks arguments as? Dictionary<String, String>", details: nil))
        }
    }
    
    func getLastPlayTracks(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arg = call.arguments as? [String: Any] {
            let albumId = Int(arg["albumId"] as! String)!
            let trackId = Int(arg["trackId"] as! String)!
            let sort = arg["sort"] as! String
            let containsPaid = arg["containsPaid"] as! Bool
            let count = Int(arg["count"] as! String)!
            getLastPlayTracksList(albumId: albumId, trackId: trackId, count: count, sort: sort, containsPaid: containsPaid, result: result)
        } else {
            result(FlutterError.init(code: "0", message: "getLastPlayTracks arguments as? Dictionary<String, Any>", details: nil))
        }
    }
    
    func getMetadata(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arg = call.arguments as? [String: String] {
            let categoryId = Int(arg["categoryId"]!)!
            getMetadataList(categoryId: categoryId, result: result)
        } else {
            result(FlutterError.init(code: "0", message: "getMetadataList arguments as? Dictionary<String, Any>", details: nil))
        }
    }
    
    func getMetadataAlbums(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arg = call.arguments as? [String: String] {
            let categoryId = Int(arg["categoryId"]!)!
            let page = Int(arg["page"]!)!
            let count = Int(arg["count"]!)!
            let calcDimension = Int(arg["calcDimension"]!)!
            let metadataAttribute = arg["metadataAttributes"]
            getMetadataAlbumsList(categoryId: categoryId, page: page, count: count, calcDimension: calcDimension, metadataAttribute: metadataAttribute, result: result)
        } else {
            result(FlutterError.init(code: "0", message: "getMetadataAlbums arguments as? Dictionary<String, String>", details: nil))
        }
    }
}
