package com.example.xi_ma_la_ya_plugin.model

import com.ximalaya.ting.android.opensdk.model.metadata.Attributes
import com.ximalaya.ting.android.opensdk.model.metadata.ChildMetadata
import com.ximalaya.ting.android.opensdk.model.metadata.MetaData

fun ChildMetadata.toMap(): HashMap<String, Any?> {
    return HashMap<String, Any?>().also {
        it["displayName"] = this.displayName
        it["kind"] = this.kind
        it["attributes"] = this.attributes?.map { item: Attributes -> item.toMap() }
    }
}

fun Attributes.toMap(): HashMap<String, Any?> {
    return HashMap<String, Any?>().also {
        it["attrKey"] = this.attrKey
        it["attrValue"] = this.attrValue
        it["displayName"] = this.displayName
        it["childMetadatas"] = this.childMetadatas?.map { item: ChildMetadata -> item.toMap() }
    }
}

fun MetaData.toMap(): HashMap<String, Any?> {
    return HashMap<String, Any?>().also {
        it["displayName"] = this.displayName
        it["kind"] = this.kind
        it["attributes"] = this.attributes.map { item: Attributes -> item.toMap() }
    }
}