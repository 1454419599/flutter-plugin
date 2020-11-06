//
//  CustomXmTagModel.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/11/3.
//

import Foundation

func fromXMTagDictionary(xmTag: XMTag) -> [String: Any?] {
    [
        "kind": xmTag.kind,
        "tagName": xmTag.tagName,
        "coverUrlLarge": xmTag.coverUrlLarge,
        "coverUrlMiddle": xmTag.coverUrlMiddle,
        "coverUrlSmall": xmTag.coverUrlSmall,
    ]
}
