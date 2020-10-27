package com.example.xi_ma_la_ya_plugin.model

import com.ximalaya.ting.android.opensdk.model.PlayableModel

fun PlayableModel.toMap(): Map<String, Any?> {
    return HashMap<String, Any?>().also {
        it["trackId"] = this.dataId
        it["kind"] = this.kind
        it["lastPlayedMills"] = this.lastPlayedMills
    }
}