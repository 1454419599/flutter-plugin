//
//  XiMaLaYaTrackPlay.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/10/31.
//

import Foundation

class XiMaLaYaTrackPlay: NSObject, XMTrackPlayerDelegate {

    static let sharedInstance = XiMaLaYaTrackPlay()
    
    //播放时被调用，频率为1s，告知当前播放进度和播放时间
    func xmTrackPlayNotifyProcess(_ percent: CGFloat, currentSecond: UInt) {
//        print("播放时被调用，频率为1s，告知当前播放进度和播放时间 \(percent) / \(currentSecond)")
        XiMaLaYaPlayer.updateMPNowPlayingInfo()
        XiMaLaYaPlayer.sendData(playerData: XiMaLaYaPlayer.PlayerData(type: .playNotifyProcess, data: ["currPos": currentSecond, "percent": percent]))
    }
    //播放时被调用，告知当前播放器的缓冲进度
    func xmTrackPlayNotifyCacheProcess(_ percent: CGFloat) {
//        print("播放时被调用，告知当前播放器的缓冲进度 \(percent)")
        XiMaLaYaPlayer.sendData(playerData: XiMaLaYaPlayer.PlayerData(type: .playNotifyCacheProcess, data: ["percent": percent]))
    }
    //播放列表结束时被调用
    func xmTrackPlayerDidPlaylistEnd() {
        print("播放列表结束时被调用")
        XiMaLaYaPlayer.sendData(playerData: XiMaLaYaPlayer.PlayerData(type: .playerDidPlaylistEnd, data: nil))
    }
    //将要播放时被调用
    func xmTrackPlayerWillPlaying() {
        print("将要播放时被调用")
        XiMaLaYaPlayer.sendData(playerData: XiMaLaYaPlayer.PlayerData(type: .playerWillPlaying, data: nil))
    }
    //已经播放时被调用
    func xmTrackPlayerDidPlaying() {
        print("已经播放时被调用")
//        XiMaLaYaPlayer.sendData(playerData: XiMaLaYaPlayer.PlayerData(type: .pl, data: nil))
    }
    //暂停时调用
    func xmTrackPlayerDidPaused() {
        print("暂停时调用")
        XiMaLaYaPlayer.sendData(playerData: XiMaLaYaPlayer.PlayerData(type: .playerDidPaused, data: nil))
    }
    //停止时调用
    func xmTrackPlayerDidStopped() {
        print("停止时调用")
        XiMaLaYaPlayer.sendData(playerData: XiMaLaYaPlayer.PlayerData(type: .playerDidStopped, data: nil))
    }
    //结束播放时调用
    func xmTrackPlayerDidEnd() {
        print("结束播放时调用")
        XiMaLaYaPlayer.sendData(playerData: XiMaLaYaPlayer.PlayerData(type: .playerDidEnd, data: nil))
    }
    //切换声音时调用
    func xmTrackPlayerDidChange(to track: XMTrack!) {
        print("切换声音时调用")
        XiMaLaYaPlayer.updateMPNowPlayingInfo(isChange: true)
//        XiMaLaYaPlayer.sendData(playerData: XiMaLaYaPlayer.PlayerData(type: .playerDidChange, data: [
//            "lastKind": track?.kind ?? "",
//            "last": track.toMap()
//        ]))
    }
    //播放失败时调用
    func xmTrackPlayerDidFailed(toPlay track: XMTrack!, withError error: Error!) {
        print("播放失败时调用")
        XiMaLaYaPlayer.sendData(playerData: XiMaLaYaPlayer.PlayerData(type: .playerDidFailed, data: error.debugDescription))
    }
    //播放失败时是否继续播放下一首
    func xmTrackPlayerShouldContinueNextTrack(whenFailed track: XMTrack!) -> Bool {
        true
    }
}
