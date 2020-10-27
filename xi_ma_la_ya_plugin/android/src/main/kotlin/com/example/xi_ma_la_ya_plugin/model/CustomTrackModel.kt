package com.example.xi_ma_la_ya_plugin.model

import com.example.xi_ma_la_ya_plugin.value2Int
import com.example.xi_ma_la_ya_plugin.value2Long
import com.ximalaya.ting.android.opensdk.model.album.SubordinatedAlbum
import com.ximalaya.ting.android.opensdk.model.track.Track

fun SubordinatedAlbum.toMap(): HashMap<String, Any?> {
    return HashMap<String, Any?>().also {
        it["albumId"] = this.albumId
        it["albumTitle"] = this.albumTitle
        it["coverUrlLarge"] = this.coverUrlLarge
        it["coverUrlMiddle"] = this.coverUrlMiddle
        it["coverUrlSmall"] = this.coverUrlSmall
    }
}

fun subordinatedAlbumFromMap(map: HashMap<String, Any?>): SubordinatedAlbum {
    return SubordinatedAlbum().apply {
        albumId = value2Long(map["albumId"])
        albumTitle = map["albumTitle"] as String?
        coverUrlLarge = map["coverUrlLarge"] as String?
        coverUrlMiddle = map["coverUrlMiddle"] as String?
        coverUrlSmall = map["coverUrlSmall"] as String?
    }
}

fun Track.toMap(): HashMap<String, Any?> {
    return HashMap<String, Any?>().also {
        it["id"] = this.dataId
        it["kind"] = this.kind
        it["trackTitle"] = this.trackTitle
        it["trackTags"] = this.trackTags
        it["trackIntro"] = this.trackIntro
        it["coverUrlLarge"] = this.coverUrlLarge
        it["coverUrlMiddle"] = this.coverUrlMiddle
        it["coverUrlSmall"] = this.coverUrlSmall
        it["announcer"] = this.announcer?.toMap()
        it["duration"] = this.duration
        it["playCount"] = this.playCount
        it["favoriteCount"] = this.favoriteCount
        it["commentCount"] = this.commentCount
        it["downloadCount"] = this.downloadCount
        it["playSize32"] = this.playSize32
        it["playSize64"] = this.playSize64
        it["playSize24M4a"] = this.playSize24M4a
        it["playSize64m4a"] = this.playSize64m4a
        it["isCanDownload"] = this.isCanDownload
        it["downloadSize"] = this.downloadSize
        it["orderNum"] = this.orderNum
        it["album"] = this.album?.toMap()
        it["source"] = this.source
        it["updatedAt"] = this.updatedAt
        it["createdAt"] = this.createdAt
        it["playSizeAmr"] = this.playSizeAmr
        it["categoryId"] = this.categoryId
        it["isPaid"] = this.isPaid
        it["isFree"] = this.isFree
        it["isTrailer"] = this.isTrailer
        it["isHasSample"] = this.isHasSample
        it["sampleDuration"] = this.sampleDuration
        it["isAudition"] = this.isAudition
        it["isAuthorized"] = this.isAuthorized
        it["vipFirstStatus"] = this.vipFirstStatus
    }
}

@Suppress("UNCHECKED_CAST")
fun trackFromMap(map: Map<String, Any?>): Track {
    return Track().apply {
        dataId = value2Long(map["id"])
        kind = map["kind"] as String?
        trackTitle = map["trackTitle"] as String?
        trackIntro = map["trackIntro"] as String?
        coverUrlLarge = map["coverUrlLarge"] as String?
        coverUrlMiddle = map["coverUrlMiddle"] as String?
        coverUrlSmall = map["coverUrlSmall"] as String?
        announcer = announcerFromMap(map["announcer"] as Map<String, Any?>)
        duration = value2Int(map["duration"])
        playCount = value2Int(map["playCount"])
        favoriteCount = value2Int(map["favoriteCount"])
        commentCount = value2Int(map["commentCount"])
        downloadCount = value2Int(map["downloadCount"])
        playSize32 = value2Int(map["playSize32"])
        playSize64 = value2Int(map["playSize64"])
        playSize24M4a = map["playSize24M4a"] as String?
        playSize64m4a = map["playSize64m4a"] as String?
        isCanDownload = map["isCanDownload"] as Boolean
        downloadSize = value2Long(map["downloadSize"])
        orderNum = value2Int(map["orderNum"])
        album = subordinatedAlbumFromMap(map["album"] as HashMap<String, Any?>)
        source = value2Int(map["source"])
        updatedAt = value2Long(map["updatedAt"])
        createdAt = value2Long(map["createdAt"])
        playSizeAmr = value2Int(map["playSizeAmr"])
        categoryId = value2Int(map["categoryId"])
        isPaid = map["isPaid"] as Boolean
        isFree = map["isFree"] as Boolean
        isTrailer = map["isTrailer"] as Boolean
        isHasSample = map["isHasSample"] as Boolean
        isAuthorized = map["isAuthorized"] as Boolean
        vipFirstStatus = map["vipFirstStatus"] as String?
    }
}