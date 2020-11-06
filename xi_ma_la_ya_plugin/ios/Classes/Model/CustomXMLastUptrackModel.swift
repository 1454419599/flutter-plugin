//
//  CustomXMLastUptrackModel.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/11/3.
//

import Foundation

func fromXMLastUptrackDictionary(xmLastUptrack: XMLastUptrack?) -> [String: Any?]? {
    if let value = xmLastUptrack {
        return [
            "duration": value.duration,
            "trackId": value.trackId,
            "trackTitle": value.trackTitle,
            "updatedAt": value.updatedAt,
            "createdAt": value.createdAt,
            "canDownload": value.canDownload,
        ]
    }
    return nil;
}

func XMLastUptrackFromDictionary(dictionary: [String: Any]?) -> XMLastUptrack? {
    if let obj = dictionary {
        let xmLastUptrack = XMLastUptrack()
        xmLastUptrack.duration = obj["duration"] as! CGFloat
        xmLastUptrack.trackId = obj["trackId"] as! Int
        xmLastUptrack.trackTitle = obj["trackTitle"] as? String
        xmLastUptrack.updatedAt = obj["updatedAt"] as! Double
        xmLastUptrack.createdAt = obj["createdAt"] as! Double
        if let v = obj["canDownload"] as? Bool {
            xmLastUptrack.canDownload = v
        } else {
            xmLastUptrack.canDownload = true
        }
        return xmLastUptrack
    }
    return nil
}
