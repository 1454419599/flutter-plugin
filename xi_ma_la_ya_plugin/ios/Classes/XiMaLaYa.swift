//
//  XiMaLaYa.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/10/30.
//

import Foundation

class XiMaLaYa: NSObject, XMReqDelegate {

    static var channel: FlutterMethodChannel? = nil
    static let sharedInstance = XiMaLaYa()
    
    var isInit: Bool = false;

    func initXiMaLaYa(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arg = call.arguments as? Dictionary<String, String> {
            let appKey: String? = arg["appKey"]
            let appSecret: String? = arg["appSecret"]
            XMReqMgr.sharedInstance().delegate = self
            XMReqMgr.sharedInstance().registerXMReqInfo(withKey: appKey, appSecret: appSecret)
        }
    }

    func initPlayerManager() {
        if isInit {
            return
        }
        isInit = true
        XiMaLaYaPlayer.player?.setAutoNexTrack(true)
        XiMaLaYaPlayer.player?.setPlayMode(.track)
        XiMaLaYaPlayer.player?.setTrackPlayMode(.XMTrackPlayerModeList)
        XiMaLaYaPlayer.player?.trackPlayDelegate = XiMaLaYaTrackPlay.sharedInstance
        addPlayControllerObserver()
    }
    
    func addPlayControllerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playControllerSelector), name: NSNotification.Name("playController"), object: nil)
    }

    public func didXMInitReqOK(_ result: Bool) {
        print("喜马拉雅初始化结果：\(result)")
    }

    public func didXMInitReqFail(_ respModel: XMErrorModel!) {
        print("喜马拉雅初始化失败：\(String(describing: respModel.error_code)) ; \(respModel.error_desc ?? "")")
    }
    
    @objc func playControllerSelector(notification: Notification) {
        if let userInfo = notification.userInfo {
            print(userInfo)
            let subtype = userInfo["subtype"] as? UIEvent.EventSubtype
            switch subtype {
            case .remoteControlPlay:
                XiMaLaYaPlayer.play()
            case .remoteControlPause:
                XiMaLaYaPlayer.pause()
            case .remoteControlStop:
                XiMaLaYaPlayer.stop()
            case .remoteControlPreviousTrack:
                XiMaLaYaPlayer.playPre()
            case .remoteControlNextTrack:
                XiMaLaYaPlayer.playNext()
            case .remoteControlTogglePlayPause:
                XiMaLaYaPlayer.togglePlayPause()
            default:
                print("未匹配 UIEvent.EventSubtype: ", subtype as Any)
            }
        }
    }
}
