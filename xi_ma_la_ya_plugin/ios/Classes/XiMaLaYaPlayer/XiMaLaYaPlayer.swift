//
//  XiMaLaYaPlayer.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/10/31.
//

import Foundation
import MediaPlayer

class XiMaLaYaPlayer: NSObject {
    static let player = XMSDKPlayer.shared()
    
    static func onPlayerMethodCallHandler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let obj = call.arguments as? [String: Any?] {
            let data = obj["data"]
            let method = obj["method"] as? String
            switch method {
            case "play":
                play()
            case "pause":
                pause()
            case "stop":
                stop()
            case "playPre":
                result(playPre())
            case "playNext":
                result(playNext())
            case "setPlayMode":
                setPlayMode(mode: data as? String)
            case "getPlayerStaus":
                result(getPlayerStaus())
            case "isPlaying":
                result(player?.isPlaying())
            case "getCurrentIndex":
                result(getCurrentIndex())
            case "hasPreSound":
                result(XMSDKPlayer.hasPrevTrack())
            case "hasNextSound":
                result(XMSDKPlayer.hasNextTrack())
            case "getDuration":
                result(player?.currentTrack()?.duration)
            case "getPlayCurrPositon":
                result(player?.currentTrack()?.listenedTime)
//            case "seekToByPercent":
//                player?.seek(toTime: CGFloat(data as! Double))
            case "seekTo":
                player?.seek(toTime: CGFloat(data as! Int))
//            case "setVolume":
//                player?.setVolume(<#T##volume: Float##Float#>)
            case "setPlayListAndPlay":
                setPlayListAndPlay(data: data as! [String : Any], result: result)
            case "setPlayCommonTrackListAndPlay":
                setPlayCommonTrackListAndPlay(data: data as! [String : Any], result: result)
            default:
                print("未匹配方法:", method ?? "")
            }
        }
    }
    
    static func play() {
        player?.resumeTrackPlay()
    }
    
    static func pause() {
        player?.pauseTrackPlay()
    }
    
    static func stop() {
        player?.stopTrackPlay()
    }
    
    @discardableResult
    static func playPre() -> Bool? {
        player?.playPrevTrack()
    }
    
    @discardableResult
    static func playNext() -> Bool? {
        player?.playNextTrack()
    }
    
    static func togglePlayPause() {
        if ((player?.isPlaying()) != nil) {
            stop()
        } else if ((player?.isPaused()) != nil) {
            play()
        }
    }
    
    static func setPlayMode(mode: String?) {
        player?.setTrackPlayMode(playModeFromString(mode: mode))
    }
    
    static func getCurrentIndex() -> Int? {
        return player?.playList()?.firstIndex {
            if let item = $0 as? XMTrack {
                return item.trackId == player?.currentTrack()?.trackId
            }
            return false
        }
    }
    
    static func getPlayerStaus() -> Int {
        var playerStateIndex = 0
        switch player?.playerState {
        case .paused:
            playerStateIndex = 5
        case .playing:
            playerStateIndex = 3
        case .stop:
            playerStateIndex = 4
        case .none, .some(_):
            playerStateIndex = 0
        }
        return playerStateIndex
    }
    
    static func setPlayListAndPlay(data: [String: Any], result: @escaping FlutterResult) {
        if let playList = data["playList"] as? Array<[String: Any]>, let index = data["index"] as? Int {
            let tracksList = playList.map() { xmTrackFromDictionary(dictionary: $0) }
            player?.play(with: tracksList[index], playlist: tracksList)
        } else {
            print("setPlayListAndPlay 参数验证失败")
        }
    }
    
    static func setPlayCommonTrackListAndPlay(data: [String: Any], result: @escaping FlutterResult) {
        if let commonTrackList = data["commonTrackList"] as? [String: Any], let index = data["index"] as? Int {
            let tracksList = XMTracksList(dictionary: commonTrackList)
            if let trackId = tracksList.tracks?[index].trackId {
                player?.continuePlay(fromAlbum: tracksList.albumId, track: trackId)
            } else {
                print("setPlayCommonTrackListAndPlay trackId 参数验证失败")
            }
        } else {
            print("setPlayCommonTrackListAndPlay 参数验证失败")
        }
    }
    
    static var dict: [String: Any] = [:]
    
    static func updateMPNowPlayingInfo(isChange: Bool = false) {
        if isChange {
            dict[MPMediaItemPropertyTitle] = player?.currentTrack()?.trackTitle
            dict[MPMediaItemPropertyArtist] = player?.currentTrack()?.announcer?.nickname
            dict[MPMediaItemPropertyAlbumTitle] = player?.currentTrack()?.subordinatedAlbum?.albumTitle
            dict[MPMediaItemPropertyPlaybackDuration] = player?.currentTrack()?.duration
            MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = XMSDKPlayer.hasNextTrack()
            MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = XMSDKPlayer.hasPrevTrack()
            if let imageName = player?.currentTrack()?.coverUrlMiddle, let image = loadNetworkUIImage(path: imageName) {
                dict[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
            }
        }
        dict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTrack()?.listenedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo = dict
    }
    
    enum PlayerEvent {
        case playNotifyProcess,
        playNotifyCacheProcess,
        playerDidPlaylistEnd,
        playerWillPlaying,
        playerDidPaused,
        playerDidStopped,
        playerDidEnd,
        playerDidChange,
        playerDidFailed
        
        var name: String {
            get {
                var name: String = "UNKNOWN"
                switch self {
                case .playNotifyProcess:
                    name = "PLAY_PROGRESS"
                case .playNotifyCacheProcess:
                    name = "BUFFER_PROGRESS"
                case .playerDidPlaylistEnd:
                    name = "SOUND_PLAY_COMPLETE"
                case .playerWillPlaying:
                    name = "PLAY_START"
                case .playerDidPaused:
                    name = "PLAY_PAUSE"
                case .playerDidStopped:
                    name = "PLAY_STOP"
                case .playerDidEnd:
                    name = "PLAY_END"
                case .playerDidFailed:
                    name = "ERROR"
                case .playerDidChange:
                    name = "SOUND_SWITCH"
                }
                return name
            }
        }
    }
    
    struct PlayerData {
        var type: PlayerEvent
        var data: Any?
        
        func toMap() -> [String: Any?] {
            ["type": type.name, "data": data]
        }
    }
    
    static func sendData(playerData: PlayerData) {
        XiMaLaYa.channel?.invokeMethod("playerController", arguments: playerData.toMap())
    }
}

func playModeFromString(mode: String?) -> XMSDKTrackPlayMode {
    var playMode: XMSDKTrackPlayMode = .XMTrackPlayerModeList
    switch mode {
    case "PLAY_MODEL_SINGLE":
        playMode = .XMTrackModeSingle
    case "PLAY_MODEL_SINGLE_LOOP":
        playMode = .XMTrackPlayerModeEnd
    case "PLAY_MODEL_LIST":
        playMode = .XMTrackPlayerModeList
    case "PLAY_MODEL_LIST_LOOP":
        playMode = .XMTrackModeCycle
    case "PLAY_MODEL_RANDOM":
        playMode = .XMTrackModeRandom
    default:
        playMode = .XMTrackPlayerModeList
    }
    return playMode
}
