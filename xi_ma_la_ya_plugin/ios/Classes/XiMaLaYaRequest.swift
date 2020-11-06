//
//  XiMaLaYaRequest.swift
//  xi_ma_la_ya_plugin
//
//  Created by mac on 2020/11/2.
//

import Foundation

//获取喜⻢拉雅内容分类
func getCategories(result: @escaping FlutterResult) {
    XMReqMgr.sharedInstance()?.requestXMData(.categoriesList, params: nil) {
        res, error in
        if let err = error {
            print(err)
            result(FlutterError(code: String(err.error_no), message: err.error_code, details: err.error_desc))
        } else {
            var data: Array<[String : Any?]>? = nil;
            if let xmCategoryList = res as? Array<[AnyHashable : Any]> {
                data = xmCategoryList.map() {
                    xmCategoryDic in
                    fromXMCategoryDictionary(xmCategory: XMCategory.init(dictionary: xmCategoryDic))
                }
            }
            result(data)
        }
    }
}

// 获取喜⻢拉雅专辑标签或者声音标签
func getTagsList(categoryId: Int, type: Int, result: @escaping FlutterResult) {
    XMReqMgr.sharedInstance()?.requestXMData(.tagsList, params: [
        "category_id": categoryId,
        "type": type,
    ]) {
        res, error in
        if let err = error {
            print(err)
            result(FlutterError(code: String(err.error_no), message: err.error_code, details: err.error_desc))
        } else {
            var data: Array<[String : Any?]>? = nil;
            if let xmTagList = res as? Array<[AnyHashable : Any]> {
                data = xmTagList.map() {
                    xmTagDic in
                    fromXMTagDictionary(xmTag: XMTag.init(dictionary: xmTagDic))
                }
            }
            result(data)
        }
    }
}

// 获取喜⻢拉雅专辑列表
func getAlbumsList(categoryId: Int, tagName: String?, calcDimension: Int,
                   page: Int, count: Int, result: @escaping FlutterResult) {
    var params: [String: Any] = [
        "category_id": categoryId,
        "calc_dimension": calcDimension,
        "count": count,
        "page": page,
    ]
    if tagName != nil {
        params["tag_name"] = tagName
    }
    XMReqMgr.sharedInstance()?.requestXMData(.albumsList, params: params) {
        res, error in
        if let err = error {
            print(err)
            result(FlutterError(code: String(err.error_no), message: err.error_code, details: err.error_desc))
        } else {
            var data: Array<[String : Any?]>? = nil;
            if let albumsList = res as? [String: Any?], let xmAlbumsList = albumsList["albums"] as? Array<[AnyHashable : Any]> {
                data = xmAlbumsList.map() {
                    item in
                    fromXMAlbumDictionary(xmAlbum: XMAlbum.init(dictionary: item))
                }
            }
            result(data)
        }
    }
}

//根据专辑ID获取专辑下的声音列表，即专辑浏览
func getTracksList(albumId: Int, sort: String?, page: Int, count: Int, result: @escaping FlutterResult) {
    XMReqMgr.sharedInstance()?.requestXMData(.albumsBrowse, params: [
        "album_id": albumId,
        "sort": sort ?? "asc",
        "count": count,
        "page": page,
    ]) {
        res, error in
        if let err = error {
            print(err)
            result(FlutterError(code: String(err.error_no), message: err.error_code, details: err.error_desc))
        } else {
            var data: [String : Any?]? = nil;
            if let tracksList = res as? [String: Any] {
                data = fromXMTracksList(xmTracksList: tracksList)
            }
            result(data)
        }
    }
}

//获取声音在所属专辑的声音列表⻚
//此接口用于根据声音id，获取此声音在它所属专辑中的那一⻚声音。
func getLastPlayTracksList(albumId: Int, trackId: Int, count: Int, sort: String?, containsPaid: Bool = false, result: @escaping FlutterResult) {
    XMReqMgr.sharedInstance()?.requestXMData(.trackGetLastPlay, params: [
        "album_id": albumId,
        "track_id": trackId,
        "count": count,
        "sort": sort ?? "asc",
        "contains_paid": containsPaid,
    ]) {
        res, error in
        if let err = error {
            print(err)
            result(FlutterError(code: String(err.error_no), message: err.error_code, details: err.error_desc))
        } else {
            var data: [String : Any?]? = nil;
            if let tracksList = res as? [String: Any] {
                data = fromXMTracksList(xmTracksList: tracksList)
            }
            result(data)
        }
    }
}

//3.2.1.10 获取某个分类下的元数据列表
func getMetadataList(categoryId: Int, result: @escaping FlutterResult) {
    XMReqMgr.sharedInstance()?.requestXMData(.metadataList, params: [
        "category_id": categoryId
    ]) {
        res, error in
        if let err = error {
            print(err)
            result(FlutterError(code: String(err.error_no), message: err.error_code, details: err.error_desc))
        } else {
            var data: [[String: Any?]?] = [];
            if let metadata = res as? [[String: Any]] {
                data = metadata.map { fromXMMetadataDictionary(xmMetadata: XMMetadata(dictionary: $0)) }
            }
            result(data)
        }
    }
}

//3.2.1.11 获取元数据下的专辑列表
func getMetadataAlbumsList(categoryId: Int, page: Int, count: Int, calcDimension: Int, metadataAttribute: String?, result: @escaping FlutterResult) {
    XMReqMgr.sharedInstance()?.requestXMData(.metadataAlbums, params: [
        "category_id": categoryId,
        "calc_dimension": calcDimension,
        "metadata_attributes": metadataAttribute ?? "",
        "page": page,
        "count": count,
    ]) {
        res, error in
        if let err = error {
            print(err)
            result(FlutterError(code: String(err.error_no), message: err.error_code, details: err.error_desc))
        } else {
            var data: Array<[String : Any?]>? = nil;
            if let albumsList = res as? [String: Any?], let xmAlbumsList = albumsList["albums"] as? Array<[AnyHashable : Any]> {
                data = xmAlbumsList.map() {
                    item in
                    fromXMAlbumDictionary(xmAlbum: XMAlbum.init(dictionary: item))
                }
            }
            result(data)
        }
    }
}
