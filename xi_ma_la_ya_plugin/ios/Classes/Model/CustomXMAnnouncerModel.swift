//
//  CustomXMAnnouncerModel.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/11/3.
//

import Foundation

func fromXMAnnouncerDictionary(xmAnnouncer: XMAnnouncer?) -> [String: Any?]? {
    if let value = xmAnnouncer {
        return [
            "announcerId": value.id,
            "kind": value.kind,
            "nickname": value.nickname,
            "avatarUrl": value.avatarUrl,
            "isVerified": value.isVerified,
        ]
    }
    return nil;
}

func xmAnnouncerFromDictionary(dictionary: [String: Any]?) -> XMAnnouncer? {
    if let obj = dictionary {
        let xmAnnouncer = XMAnnouncer()
        xmAnnouncer.id = obj["announcerId"] as! Int
        xmAnnouncer.kind = obj["kind"] as? String
        xmAnnouncer.nickname = obj["nickname"] as? String
        xmAnnouncer.avatarUrl = obj["avatarUrl"] as? String
        if let v = obj["isVerified"] as? Bool {
            xmAnnouncer.isVerified = v
        } else {
            xmAnnouncer.isVerified = true
        }
        return xmAnnouncer
    }
    return nil
}
