package com.example.xi_ma_la_ya_plugin.model

import com.ximalaya.ting.android.opensdk.model.album.UpdateBatch

fun UpdateBatch.toMap(): HashMap<String, Any?> {
    return HashMap<String, Any?>().also {
        it["albumId"] = this.albumId
        it["trackId"] = this.trackId
        it["trackTitle"] = this.trackTitle
        it["coverUrl"] = this.coverUrl
        it["updateAt"] = this.updateAt
    }
}