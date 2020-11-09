//
//  CustomXMTrackModel.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/10/31.
//

import Foundation

func fromXMSubordinatedAlbum(xmSubordinatedAlbum self: XMSubordinatedAlbum) -> [String: Any?] {
    [
        "albumId": self.albumId,
        "albumTitle": self.albumTitle,
        "coverUrlLarge": self.coverUrlLarge,
        "coverUrlMiddle": self.coverUrlMiddle,
        "coverUrlSmall": self.coverUrlSmall
    ]
}

func xmSubordinatedAlbumFromDictionary(dictionary: [String: Any]?) -> XMSubordinatedAlbum? {
    if let obj = dictionary {
        let xmSubordinatedAlbum = XMSubordinatedAlbum()
        xmSubordinatedAlbum.albumId = obj["albumId"] as! Int
        xmSubordinatedAlbum.albumTitle = obj["albumTitle"] as? String
        xmSubordinatedAlbum.coverUrlLarge = obj["coverUrlLarge"] as? String
        xmSubordinatedAlbum.coverUrlMiddle = obj["coverUrlMiddle"] as? String
        xmSubordinatedAlbum.coverUrlSmall = obj["coverUrlSmall"] as? String
        return xmSubordinatedAlbum
    }
    return nil
}

func fromXMTrack(xmTrack self: XMTrack) -> [String: Any?] {
    [
        "id": self.trackId,
        "kind": self.kind,
        "trackTitle": self.trackTitle,
        "trackTags": self.trackTags,
        "trackIntro": self.trackIntro,
        "coverUrlLarge": self.coverUrlLarge,
        "coverUrlMiddle": self.coverUrlMiddle,
        "coverUrlSmall": self.coverUrlSmall,
        "announcer": fromXMAnnouncerDictionary(xmAnnouncer: self.announcer),
        "duration": self.duration,
        "playCount": self.playCount,
        "favoriteCount": self.favoriteCount,
        "commentCount": self.commentCount,
        "downloadCount": self.downloadCount,
        "playUrl32": self.playUrl32,
        "playSize32": self.playSize32,
        "playUrl64": self.playUrl64,
        "playSize64": self.playSize64,
        "playUrl24M4a": self.playUrl24M4a,
        "playSize24M4a": String(self.playSize24M4a),
        "playUrl64M4a": self.playUrl64M4a,
        "playSize64M4a": String(self.playSize64M4a),
        "downloadUrl": self.downloadUrl,
        "downloadSize": self.downloadSize,
        "orderNum": self.orderNum,
        "album": fromXMSubordinatedAlbum(xmSubordinatedAlbum: self.subordinatedAlbum),
        "source": self.source,
        "updatedAt": Int(self.updatedAt),
        "createdAt": Int(self.createdAt),
        "canDownload": self.canDownload,
        "playUrlAmr": self.playUrlAmr,
        "playSizeAmr": self.playSizeAmr
    ]
}

func xmTrackFromDictionary(dictionary: [String: Any]) -> XMTrack {
    let xmTrack = XMTrack()
    xmTrack.trackId = dictionary["id"] as! Int
    xmTrack.kind = dictionary["kind"] as? String
    xmTrack.trackTitle = dictionary["trackTitle"] as? String
    xmTrack.trackTags = dictionary["trackTags"] as? String
    xmTrack.trackIntro = dictionary["trackIntro"] as? String
    xmTrack.coverUrlLarge = dictionary["coverUrlLarge"] as? String
    xmTrack.coverUrlMiddle = dictionary["coverUrlMiddle"] as? String
    xmTrack.coverUrlSmall = dictionary["coverUrlSmall"] as? String
    xmTrack.announcer = xmAnnouncerFromDictionary(dictionary: dictionary["announcer"] as? [String : Any])
    xmTrack.duration = dictionary["duration"] as! Int
    xmTrack.playCount = dictionary["playCount"] as! Int
    xmTrack.favoriteCount = dictionary["favoriteCount"] as! Int
    xmTrack.commentCount = dictionary["commentCount"] as! Int
    xmTrack.downloadCount = dictionary["downloadCount"] as! Int
    xmTrack.playUrl32 = dictionary["playUrl32"] as? String
    xmTrack.playSize32 = dictionary["playSize32"] as! Int
    xmTrack.playUrl64 = dictionary["playUrl64"] as? String
    xmTrack.playSize64 = dictionary["playSize64"] as! Int
    xmTrack.playUrl24M4a = dictionary["playUrl24M4a"] as? String
    xmTrack.playSize24M4a = Int(dictionary["playSize24M4a"] as? String ?? "0")!
    xmTrack.playUrl64M4a = dictionary["playUrl64M4a"] as? String
    xmTrack.playSize64M4a = Int(dictionary["playSize64M4a"] as? String ?? "0")!
    xmTrack.downloadUrl = dictionary["downloadUrl"] as? String
    xmTrack.downloadSize = dictionary["downloadSize"] as! Int
    xmTrack.orderNum = dictionary["orderNum"] as! Int
    xmTrack.subordinatedAlbum = xmSubordinatedAlbumFromDictionary(dictionary: dictionary["album"] as? [String: Any])
    xmTrack.source = dictionary["source"] as! Int
    xmTrack.updatedAt = dictionary["updatedAt"] as! Double
    xmTrack.createdAt = dictionary["createdAt"] as! Double
    if let v = dictionary["isCanDownload"] as? Bool {
        xmTrack.canDownload = v
    } else {
        xmTrack.canDownload = false
    }
    xmTrack.playUrlAmr = dictionary["playUrlAmr"] as? String
    xmTrack.playSizeAmr = dictionary["playSizeAmr"] as! Int
    return xmTrack
}

class XMTracksList {
    var albumId: Int;
    var albumTitle: String?;
    var categoryId: Int;
    var albumIntro: String?;
    var coverUrlLarge: String?;
    var coverUrlMiddle: String?;
    var coverUrlSmall: String?;
    var currentPage: Int;
    var totalPage: Int;
    var totalCount: Int;
    var tracks: [XMTrack]?;
    
    init(dictionary: [String: Any?]) {
        self.albumId = dictionary["albumId"] as? Int ?? 0;
        self.albumTitle = dictionary["albumTitle"] as? String;
        self.categoryId = dictionary["categoryId"] as? Int ?? 0;
        self.albumIntro = dictionary["albumIntro"] as? String;
        self.coverUrlLarge = dictionary["coverUrlLarge"] as? String;
        self.coverUrlMiddle = dictionary["coverUrlMiddle"] as? String;
        self.coverUrlSmall = dictionary["coverUrlSmall"] as? String;
        self.currentPage = dictionary["currentPage"] as! Int;
        self.totalPage = dictionary["totalPage"] as! Int;
        self.totalCount = dictionary["totalCount"] as! Int;
        if let tracks = dictionary["tracks"] as? [[String : Any]] {
            self.tracks = tracks.map {
                xmTrackFromDictionary(dictionary: $0)
            }
        }
    }
}

func fromXMTracksList(xmTracksList: [String: Any]) -> [String: Any?] {
    [
        "albumId": xmTracksList["album_id"],
        "albumTitle": xmTracksList["album_title"],
        "categoryId": xmTracksList["category_id"],
        "albumIntro": xmTracksList["album_intro"],
        "coverUrlLarge": xmTracksList["cover_url_large"],
        "coverUrlMiddle": xmTracksList["cover_url_middle"],
        "coverUrlSmall": xmTracksList["cover_url_small"],
        "currentPage": xmTracksList["current_page"],
        "totalPage": xmTracksList["total_page"],
        "totalCount": xmTracksList["total_count"],
        "tracks": (xmTracksList["tracks"] as? Array<[AnyHashable: Any]>)?.map() {
            item in
            fromXMTrack(xmTrack: XMTrack.init(dictionary: item))
        },
    ]
}

//func xmTracksListFromDictionary(dictionary: [String: Any?]) -> XMTracksList {
//    let xmTracksList = XMTracksList(dictionary)
//
//}


//extension XMAnnouncer {
//    func toMap() -> [String: Any?] {
//        [
//            "announcerId": self.id,
//            "kind": self.kind,
//            "nickname": self.nickname,
//            "avatarUrl": self.avatarUrl,
//            "isVerified": self.isVerified,
//        ]
//    }
//}
//
//extension XMSubordinatedAlbum {
//    func toMap() -> [String: Any?] {
//        [
//            "albumId": self.albumId,
//            "albumTitle": self.albumTitle,
//            "coverUrlLarge": self.coverUrlLarge,
//            "coverUrlMiddle": self.coverUrlMiddle,
//            "coverUrlSmall": self.coverUrlSmall
//        ]
//    }
//}
//
//extension XMTrack {
//    func toMap() -> [String: Any?] {
//        [
//            "id": self.trackId,
//            "kind": self.kind,
//            "trackTitle": self.trackTitle,
//            "trackTags": self.trackTags,
//            "trackIntro": self.trackIntro,
//            "coverUrlLarge": self.coverUrlLarge,
//            "coverUrlMiddle": self.coverUrlMiddle,
//            "coverUrlSmall": self.coverUrlSmall,
//            "announcer": self.announcer?.toMap(),
//            "duration": self.duration,
//            "playCount": self.playCount,
//            "favoriteCount": self.favoriteCount,
//            "commentCount": self.commentCount,
//            "downloadCount": self.downloadCount,
//            "playUrl32": self.playUrl32,
//            "playSize32": self.playSize32,
//            "playUrl64": self.playUrl64,
//            "playSize64": self.playSize64,
//            "playUrl24M4a": self.playUrl24M4a,
//            "playSize24M4a": self.playSize24M4a,
//            "playUrl64M4a": self.playUrl64M4a,
//            "playSize64M4a": self.playSize64M4a,
//            "downloadUrl": self.downloadUrl,
//            "downloadSize": self.downloadSize,
//            "orderNum": self.orderNum,
//            "Album": self.subordinatedAlbum?.toMap(),
//            "source": self.source,
//            "updatedAt": self.updatedAt,
//            "createdAt": self.createdAt,
//            "canDownload": self.canDownload,
//            "playUrlAmr": self.playUrlAmr,
//            "playSizeAmr": self.playSizeAmr
//        ]
//    }
//}
