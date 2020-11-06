//
//  CustomXMCategoryModel.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/11/3.
//

import Foundation

func fromXMCategoryDictionary(xmCategory: XMCategory) -> [String: Any?] {
    [
        
        "id": xmCategory.categoryId,
        "kind": xmCategory.kind,
        "categoryName": xmCategory.categoryName,
        "coverUrlLarge": xmCategory.coverUrlLarge,
        "coverUrlMiddle": xmCategory.coverUrlMiddle,
        "coverUrlSmall": xmCategory.coverUrlSmall,
    ]
}
