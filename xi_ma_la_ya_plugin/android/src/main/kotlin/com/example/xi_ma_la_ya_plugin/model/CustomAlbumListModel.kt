package com.example.xi_ma_la_ya_plugin.model

import com.example.xi_ma_la_ya_plugin.value2Long
import com.ximalaya.ting.android.opensdk.model.album.Album
import com.ximalaya.ting.android.opensdk.model.album.AlbumList
import com.ximalaya.ting.android.opensdk.model.album.Announcer
import com.ximalaya.ting.android.opensdk.model.album.LastUpTrack
import com.ximalaya.ting.android.opensdk.model.pay.AlbumPriceTypeDetail

fun Announcer.toMap(): Map<String, Any?> {
    return HashMap<String, Any?>().also {
        it["announcerId"] = this.announcerId
        it["kind"] = this.kind
        it["vCategoryId"] = this.getvCategoryId()
        it["nickname"] = this.nickname
        it["vDesc"] = this.vdesc
        it["vSignature"] = this.vsignature
        it["avatarUrl"] = this.avatarUrl
        it["announcerPosition"] = this.announcerPosition
        it["followerCount"] = this.followerCount
        it["followingCount"] = this.followingCount
        it["releasedAlbumCount"] = this.releasedAlbumCount
        it["releasedTrackCount"] = this.releasedTrackCount
        it["isVerified"] = this.isVerified
    }
}

fun announcerFromMap(map: Map<String, Any?>): Announcer{
    return Announcer().apply {
        announcerId = value2Long(map["announcerId"])
        kind = map["kind"] as String?
        setvCategoryId(value2Long(map["vCategoryId"]))
        nickname = map["nickname"] as String?
        vdesc = map["vDesc"] as String?
        vsignature = map["vSignature"] as String?
        avatarUrl = map["avatarUrl"] as String?
        announcerPosition = map["announcerPosition"] as String?
        followerCount = value2Long(map["followerCount"])
        followingCount = value2Long(map["followingCount"])
        releasedAlbumCount = value2Long(map["releasedAlbumCount"])
        releasedTrackCount = value2Long(map["releasedTrackCount"])
        isVerified = map["isVerified"] as Boolean
    }
}

fun LastUpTrack.toMap(): Map<String, Any?> {
    return HashMap<String, Any?>().also {
        it["createdAt"] = this.createdAt
        it["duration"] = this.duration
        it["trackId"] = this.trackId
        it["trackTitle"] = this.trackTitle
        it["updatedAt"] = this.updatedAt
    }
}

fun AlbumPriceTypeDetail.toMap(): Map<String, Any?> {
    return HashMap<String, Any?>().also {
        it["discountedPrice"] = this.discountedPrice
        it["price"] = this.price
        it["priceType"] = this.priceType
        it["priceUnit"] = this.priceUnit
    }
}

fun Album.toMap(): Map<String, Any?> {
    return HashMap<String, Any?>().also {
        it["id"] = this.id
        it["categoryId"] = this.categoryId
        it["albumTitle"] = this.albumTitle
        it["albumTags"] = this.albumTags
        it["albumIntro"] = this.albumIntro
        it["coverUrlLarge"] = this.coverUrlLarge
        it["coverUrlMiddle"] = this.coverUrlMiddle
        it["coverUrlSmall"] = this.coverUrlSmall
        it["announcer"] = this.announcer?.toMap()
        it["playCount"] = this.playCount
        it["favoriteCount"] = this.favoriteCount
        it["includeTrackCount"] = this.includeTrackCount
        it["lastUpTrack"] = this.lastUptrack?.toMap()
        it["isFinished"] = this.isFinished
        it["isCanDownload"] = this.isCanDownload
        it["updatedAt"] = this.updatedAt
        it["createdAt"] = this.createdAt
        it["subscribeCount"] = this.subscribeCount
        it["isTracksNaturalOrdered"] = this.isTracksNaturalOrdered
        it["isPaid"] = this.isPaid
        it["estimatedTrackCount"] = this.estimatedTrackCount
        it["albumRichIntro"] = this.albumRichIntro
        it["freeTrackCount"] = this.freeTrackCount
        it["freeTrackIds"] = this.freeTrackIds
        it["saleIntro"] = this.saleIntro
        it["expectedRevenue"] = this.expectedRevenue
        it["buyNotes"] = this.buyNotes
        it["speakerTitle"] = this.speakerTitle
        it["speakerContent"] = this.speakerContent
        it["speakerIntro"] = this.speakerIntro
        it["isHasSample"] = this.isHasSample
        it["composedPriceType"] = this.composedPriceType
        it["priceTypeInfos"] = this.priceTypeInfos?.map { item: AlbumPriceTypeDetail -> item.toMap() }
        it["detailBannerUrl"] = this.detailBannerUrl
        it["albumScore"] = this.albumScore
        it["isVipFree"] = this.isVipFree
        it["isVipExclusive"] = this.isVipExclusive
    }
}

fun AlbumList.toMap(): HashMap<String, Any?> {
    return HashMap<String, Any?>().also {
        it["categoryId"] = this.categoryId
        it["currentPage"] = this.currentPage
        it["tagName"] = this.tagName
        it["totalCount"] = this.totalCount
        it["totalPage"] = this.totalPage
        it["albums"] = this.albums?.map { item: Album -> item.toMap() }
    }
}