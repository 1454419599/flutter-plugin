//
//  CustomXMAttributeModel.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/11/6.
//

import Foundation

func fromXMAttributeDictionary(xmAttribute: Any?) -> [String: Any?]? {
    var xmAtt = xmAttribute
    if let xmAt = xmAtt as? [String: Any] {
        xmAtt = XMAttribute(dictionary: xmAt)
    }
    if let value = xmAtt as? XMAttribute {
        return [
            "attrKey": String(value.attrKey),
            "attrValue": value.attrValue,
            "displayName": value.displayName,
            "childMetadatas": fromXMMetadataDictionary(xmMetadata: value.childMetadata)
        ]
    }
    return nil
}
