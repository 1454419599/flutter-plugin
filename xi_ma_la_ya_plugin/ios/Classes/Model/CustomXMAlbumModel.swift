//
//  CustomXMAlbumModel.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/11/3.
//

import Foundation

func fromXMAlbumDictionary(xmAlbum: XMAlbum) -> [String: Any?] {
    [
        "id": xmAlbum.albumId,
        "kind": xmAlbum.kind,
        "albumTitle": xmAlbum.albumTitle,
        "albumTags": xmAlbum.albumTags,
        "albumIntro": xmAlbum.albumIntro,
        "coverUrlSmall": xmAlbum.coverUrlSmall,
        "coverUrlMiddle": xmAlbum.coverUrlMiddle,
        "coverUrlLarge": xmAlbum.coverUrlLarge,
        "announcer": fromXMAnnouncerDictionary(xmAnnouncer: xmAlbum.announcer),
        "playCount": xmAlbum.playCount,
        "favoriteCount": xmAlbum.favoriteCount,
        "includeTrackCount": xmAlbum.includeTrackCount,
        "lastUpTrack": fromXMLastUptrackDictionary(xmLastUptrack: xmAlbum.lastUptrack),
        "isFinished": xmAlbum.isFinished,
        "updatedAt": Int(xmAlbum.updatedAt),
        "createdAt": Int(xmAlbum.createdAt),
        "isCanDownload": xmAlbum.canDownload,
        "subscribeCount": xmAlbum.subscribeCount,
    ]
}

func xmAlbumFromDictionary(dictionary: [String: Any]?) -> XMAlbum? {
    if let obj = dictionary {
        let xmAlbum = XMAlbum()
        xmAlbum.albumId = obj["id"] as! Int
        xmAlbum.kind = obj["kind"] as? String
        xmAlbum.albumTitle = obj["albumTitle"] as? String
        xmAlbum.albumTags = obj["albumTags"] as? String
        xmAlbum.albumIntro = obj["albumIntro"] as? String
        xmAlbum.coverUrlSmall = obj["coverUrlSmall"] as? String
        xmAlbum.coverUrlMiddle = obj["coverUrlMiddle"] as? String
        xmAlbum.coverUrlLarge = obj["coverUrlLarge"] as? String
        xmAlbum.announcer = xmAnnouncerFromDictionary(dictionary: obj["announcer"] as? [String : Any])
        xmAlbum.playCount = obj["playCount"] as! Int
        xmAlbum.favoriteCount = obj["favoriteCount"] as! Int
        xmAlbum.includeTrackCount = obj["includeTrackCount"] as! Int
        xmAlbum.lastUptrack = XMLastUptrackFromDictionary(dictionary: obj["lastUpTrack"] as? [String : Any])
        xmAlbum.isFinished = obj["isFinished"] as! Int
        xmAlbum.updatedAt = obj["updatedAt"] as! Double
        xmAlbum.createdAt = obj["createdAt"] as! Double
        if let v = obj["isCanDownload"] as? Bool {
            xmAlbum.canDownload = v
        } else {
            xmAlbum.canDownload = true
        }
        xmAlbum.subscribeCount = obj["subscribeCount"] as! Int
        return xmAlbum
    }
    return nil
}
