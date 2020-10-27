package com.example.xi_ma_la_ya_plugin.model

import com.example.xi_ma_la_ya_plugin.value2Long
import com.ximalaya.ting.android.opensdk.model.category.Category

/**
 * 将Category转换为Map
 */
fun Category.toMap(): MutableMap<String, Any?> {
    return HashMap<String, Any?>().also {
        it["id"] = this.id
        it["kind"] = this.kind
        it["categoryName"] = this.categoryName
        it["coverUrlLarge"] = this.coverUrlLarge
        it["coverUrlMiddle"] = this.coverUrlMiddle
        it["coverUrlSmall"] = this.coverUrlSmall
    }
}

/**
 * 通过Map生成Category
 * @param map Category的Map新式
 */
fun categoryFromMap(map: Map<String, Any>): Category {
    return Category().apply {
        id = value2Long(map["id"])
        kind = map["kind"] as String?
        categoryName = map["categoryName"] as String?
        coverUrlLarge = map["coverUrlLarge"] as String?
        coverUrlMiddle = map["coverUrlMiddle"] as String?
        coverUrlSmall = map["coverUrlSmall"] as String?
    }
}
