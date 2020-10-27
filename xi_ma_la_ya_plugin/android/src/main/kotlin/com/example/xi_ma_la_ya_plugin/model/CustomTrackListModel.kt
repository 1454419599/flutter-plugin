package com.example.xi_ma_la_ya_plugin.model

import com.example.xi_ma_la_ya_plugin.value2Int
import com.ximalaya.ting.android.opensdk.model.track.CommonTrackList
import com.ximalaya.ting.android.opensdk.model.track.Track
import com.ximalaya.ting.android.opensdk.model.track.TrackList

fun TrackList.toMap(): Map<String, Any?> {
    return (this as CommonTrackList<Track>).toMap().also {
        it["albumId"] = this.albumId
        it["albumTitle"] = this.albumTitle
        it["categoryId"] = this.categoryId
        it["albumIntro"] = this.albumIntro
        it["coverUrlLarge"] = this.coverUrlLarge
        it["coverUrlMiddle"] = this.coverUrlMiddle
        it["coverUrlSmall"] = this.coverUrlSmall
        it["currentPage"] = this.currentPage
    }
}

fun trackListFromMap(map: Map<String, Any?>): TrackList {
    return TrackList().also {
        commonTrackListFromMap(it, map)
        it.albumId = value2Int(map["albumId"])
        it.albumTitle = map["albumTitle"] as String?
        it.categoryId = value2Int(map["categoryId"])
        it.albumIntro = map["albumIntro"] as String?
        it.coverUrlLarge = map["coverUrlLarge"] as String?
        it.coverUrlMiddle = map["coverUrlMiddle"] as String?
        it.coverUrlSmall = map["coverUrlSmall"] as String?
        it.currentPage = value2Int(map["currentPage"])
    }
}