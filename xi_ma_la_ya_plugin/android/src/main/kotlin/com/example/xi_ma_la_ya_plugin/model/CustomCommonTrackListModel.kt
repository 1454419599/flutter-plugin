package com.example.xi_ma_la_ya_plugin.model

import com.example.xi_ma_la_ya_plugin.value2Int
import com.ximalaya.ting.android.opensdk.model.PlayableModel
import com.ximalaya.ting.android.opensdk.model.track.CommonTrackList
import com.ximalaya.ting.android.opensdk.model.track.Track

fun CommonTrackList<Track>.toMap(): HashMap<String, Any?> {
    return HashMap<String, Any?>().also {
        it["totalCount"] = this.totalCount
        it["totalPage"] = this.totalPage
        it["params"] = this.params
        it["tracks"] = this.tracks.map<Track, Map<String, Any?>> { item -> item.toMap() }
    }
}

fun commonTrackListFromMap(obj: CommonTrackList<out PlayableModel>, map: Map<String, Any?>)  {
    obj.apply {
        totalCount = value2Int(map["totalCount"])
        totalPage = value2Int(map["totalPage"])
        params = map["params"] as MutableMap<String, String>?
        tracks = (map["tracks"] as List<Map<String, Any?>>).map { trackFromMap(it) }
    }
}

fun commonTrackListFromMap(map: Map<String, Any?>): CommonTrackList<Track> {
    return CommonTrackList<Track>().apply {
        totalCount = value2Int(map["totalCount"])
        totalPage = value2Int(map["totalPage"])
        params = map["params"] as MutableMap<String, String>?
        tracks = (map["tracks"] as List<Map<String, Any?>>).map { trackFromMap(it) }
    }
}