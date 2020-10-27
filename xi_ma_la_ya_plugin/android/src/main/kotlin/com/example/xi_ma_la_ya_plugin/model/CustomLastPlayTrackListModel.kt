package com.example.xi_ma_la_ya_plugin.model

import com.example.xi_ma_la_ya_plugin.value2Int
import com.ximalaya.ting.android.opensdk.model.track.CommonTrackList
import com.ximalaya.ting.android.opensdk.model.track.LastPlayTrackList
import com.ximalaya.ting.android.opensdk.model.track.Track

fun LastPlayTrackList.toMap(): Map<String, Any?> {
    return (this as CommonTrackList<Track>).toMap().also {
        it["categoryId"] = this.categoryId
        it["tagName"] = this.tagname
        it["currentPage"] = this.pageid
    }
}

fun lastPlayTrackListFromMap(map: Map<String, *>): LastPlayTrackList {
    return LastPlayTrackList().also {
        commonTrackListFromMap(it, map)
        it.categoryId = value2Int(map["categoryId"])
        it.tagname = map["tagName"] as String?
        it.pageid = value2Int(map["currentPage"])
    }
}

