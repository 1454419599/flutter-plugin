//
//  CustomXMMetadataModel.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/11/5.
//

import Foundation

func fromXMMetadataDictionary(xmMetadata: Any?) -> [String: Any?]? {
    var xmMd = xmMetadata
    if let xmMdd = xmMd as? [String: Any] {
        xmMd = XMMetadata(dictionary: xmMdd)
    }
    if let value = xmMd as? XMMetadata {
        return [
            "displayName": value.displayName,
            "kind": value.kind,
            "attributes": value.attributes?.map {fromXMAttributeDictionary(xmAttribute: $0 as? XMAttribute)}
        ]
    }
    return nil;
}
