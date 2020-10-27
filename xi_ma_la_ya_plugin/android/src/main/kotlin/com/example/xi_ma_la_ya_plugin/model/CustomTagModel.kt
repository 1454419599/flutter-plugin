package com.example.xi_ma_la_ya_plugin.model

import com.ximalaya.ting.android.opensdk.model.tag.Tag

fun Tag.toMap(): HashMap<String, String?> {
    return HashMap<String, String?>().also {
        it["kind"] = this.kind
        it["tagName"] = this.tagName
    }
}

fun TagFromMap(map: Map<String, String>): Tag {
    return Tag().apply {
        this.kind = map["kind"]
        this.tagName = map["tagName"]
    }
}