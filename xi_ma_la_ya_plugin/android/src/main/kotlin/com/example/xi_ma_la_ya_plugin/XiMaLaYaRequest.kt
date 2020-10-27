package com.example.xi_ma_la_ya_plugin

import com.example.xi_ma_la_ya_plugin.model.toMap
import com.ximalaya.ting.android.opensdk.constants.DTransferConstants
import com.ximalaya.ting.android.opensdk.datatrasfer.CommonRequest
import com.ximalaya.ting.android.opensdk.datatrasfer.IDataCallBack
import com.ximalaya.ting.android.opensdk.model.album.AlbumList
import com.ximalaya.ting.android.opensdk.model.album.BatchAlbumList
import com.ximalaya.ting.android.opensdk.model.album.UpdateBatchList
import com.ximalaya.ting.android.opensdk.model.category.CategoryList
import com.ximalaya.ting.android.opensdk.model.metadata.MetaDataList
import com.ximalaya.ting.android.opensdk.model.tag.TagList
import com.ximalaya.ting.android.opensdk.model.track.BatchTrackList
import com.ximalaya.ting.android.opensdk.model.track.LastPlayTrackList
import com.ximalaya.ting.android.opensdk.model.track.TrackHotList
import com.ximalaya.ting.android.opensdk.model.track.TrackList
import com.ximalaya.ting.android.opensdk.player.XmPlayerManager
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.collections.HashMap


object XiMaLaYaRequest {
    /**
     * 获取内容分类
     * @param result Flutter MethodChannel
     */
    fun categoriesList(result: Result) {
        val map: Map<String, String> = HashMap()
        CommonRequest.getCategories(map, object :IDataCallBack<CategoryList>{
            override fun onSuccess(p0: CategoryList?) {
                result.success(p0?.categories?.map { it.toMap() })
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

    /**
     * 获取专辑标签或者声音标签
     * @param categoryId 分类ID，指定分类 为0时表示热门分类
     * @param type 指定查询的是专辑标签还是声音标签，0-专辑标签，1-声音标签
     * @param result Flutter MethodChannel
     */
    fun getTags(categoryId: String = "3", type: String = "0", result: Result) {
        val map: MutableMap<String, String> = HashMap()
        map[DTransferConstants.CATEGORY_ID] = categoryId
        map[DTransferConstants.TYPE] = type
        CommonRequest.getTags(map, object :IDataCallBack<TagList> {
            override fun onSuccess(p0: TagList?) {
                result.success(p0?.tagList?.map { it.toMap() })
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

    /**
     * 根据分类和标签获取某个分类某个标签下的专辑列表（最火/最新/最多播放）
     * @param categoryId 分类ID，指定分类，为0时表示热门分类
     * @param calcDimension 计算维度，现支持最火（1），最新（2），经典或播放最多（3）
     * @param page 返回第几页，必须大于等于1，不填默认为1
     * @param count 每页多少条，默认20，最多不超过200
     * @param tagName 分类下对应的专辑标签，不填则为热门分类
     * @param result Flutter MethodChannel
     */
    fun getAlbumList(
            categoryId: String = "0",
            calcDimension: String = "1",
            tagName: String? = null,
            page: String = "1",
            count: String = "20",
            result: Result
    ) {
        val map: MutableMap<String, String> = HashMap()
        map[DTransferConstants.CATEGORY_ID] = categoryId
        map[DTransferConstants.CALC_DIMENSION] = calcDimension
        map[DTransferConstants.PAGE] = page
        map[DTransferConstants.PAGE_SIZE] = count
        if (tagName != null) map[DTransferConstants.TAG_NAME] = tagName
        CommonRequest.getAlbumList(map, object :IDataCallBack<AlbumList>{
            override fun onSuccess(p0: AlbumList?) {
                result.success(p0?.albums?.map { it.toMap() })
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

    /**
     * 专辑浏览，根据专辑ID获取专辑下的声音列表
     * @param albumId 专辑ID
     * @param sort "asc"表示喜马拉雅正序，"desc"表示喜马拉雅倒序，"time_asc"表示时间升序，"time_desc"表示时间降序，默认为"asc"
     * @param page 当前第几页，不填默认为1
     * @param count 每页多少条，默认20，最多不超过200
     * @param result Flutter MethodChannel
     */
    fun getTracks(
            albumId: String = "3475911",
            sort: String = "asc",
            page: String = "1",
            count: String = "20",
            result: Result
    ) {
        val map: MutableMap<String, String> = HashMap()
        map[DTransferConstants.ALBUM_ID] = albumId
        map[DTransferConstants.SORT] = sort
        map[DTransferConstants.PAGE] = page
        map[DTransferConstants.PAGE_SIZE] = count
        CommonRequest.getTracks(map, object :IDataCallBack<TrackList> {
            override fun onSuccess(p0: TrackList?) {
//                result.success(p0?.tracks?.map { it.toMap() })
                result.success(p0?.toMap())
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

    /**
     * 批量获取专辑列表
     * @param ids 专辑ID列表，用英文逗号分隔，比如"1000,1010" 最大ID数量为200个，超过200的ID将忽略
     * @param result Flutter MethodChannel
     */
    fun getBatch(ids: String, result: Result) {
        val map: MutableMap<String, String> = HashMap()
        map[DTransferConstants.ALBUM_IDS] = ids
        CommonRequest.getBatch(map, object :IDataCallBack<BatchAlbumList> {
            override fun onSuccess(p0: BatchAlbumList?) {
                result.success(p0?.albums?.map { it.toMap() })
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

    /**
     * 根据专辑ID列表批获取量专辑更新提醒信息列表
     * @param ids 专辑ID列表，用英文逗号分隔，比如"1000,1010" 最大ID数量为200个，超过200的ID将忽略
     * @param result Flutter MethodChannel
     */
    fun getUpdateBatch(ids: String, result: Result) {
        val map: MutableMap<String, String> = HashMap()
        map[DTransferConstants.ALBUM_IDS] = ids
        CommonRequest.getUpdateBatch(map, object :IDataCallBack<UpdateBatchList> {
            override fun onSuccess(p0: UpdateBatchList?) {
                result.success(p0?.list?.map { it.toMap() })
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

    /**
     * 根据分类和标签获取热门声音列表
     * @param categoryId 分类ID，指定分类
     * @param tagName 分类下对应声音标签，不填则为热门分类
     * @param page 返回第几页，必须大于等于1，不填默认为1
     * @param count 每页多少条，默认20，最多不超过200
     * @param result Flutter MethodChannel
     */
    fun getHotTracks(
            categoryId: String = "3475911",
            tagName: String? = null,
            page: String = "1",
            count: String = "20",
            result: Result
    ) {
        val map: MutableMap<String, String> = HashMap()
        map[DTransferConstants.CATEGORY_ID] = categoryId
        if (tagName != null) map[DTransferConstants.TAG_NAME] = tagName
        map[DTransferConstants.PAGE] = page
        map[DTransferConstants.PAGE_SIZE] = count
        CommonRequest.getHotTracks(map, object :IDataCallBack<TrackHotList> {
            override fun onSuccess(p0: TrackHotList?) {
                result.success(p0?.tracks?.map { it.toMap() })
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

    /**
     * 批量获取声音列表
     * @param ids 声音ID列表 最大ID数量为200个，超过200的ID将忽略
     * @param result Flutter MethodChannel
     */
    fun getBatchTracks(ids: String, result: Result) {
        val map: MutableMap<String, String> = HashMap()
        map[DTransferConstants.TRACK_IDS] = ids
        CommonRequest.getBatchTracks(map, object :IDataCallBack<BatchTrackList> {
            override fun onSuccess(p0: BatchTrackList?) {
                result.success(p0?.tracks?.map { it.toMap() })
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

    /**
     * 根据上一次所听声音的id，获取此声音所在那一页的声音
     * @param albumId 专辑id
     * @param trackId 声音id
     * @param count 每页大小，范围为[1,200]，默认为20
     * @param sort 返回结果排序方式： "asc" - 喜马拉雅正序，"desc" - 喜马拉雅倒序，默认为"asc"
     * @param containsPaid 是否是付费声音 (如果是付费相关的专辑调用此函数需要设置contain_paid 为true)
     * @param result Flutter MethodChannel
     */
    fun getLastPlayTracks(
            albumId: String,
            trackId: String,
            count: String = "20",
            sort: String = "asc",
            containsPaid: Boolean = false,
            result: Result
    ) {
        val map: MutableMap<String, String> = HashMap()
        map[DTransferConstants.ALBUM_ID] = albumId
        map[DTransferConstants.TRACK_ID] = trackId
        map[DTransferConstants.PAGE_SIZE] = count
        map[DTransferConstants.SORT] = sort
        map[DTransferConstants.CONTAINS_PAID] = containsPaid.toString()
        CommonRequest.getLastPlayTracks(map, object : IDataCallBack<LastPlayTrackList> {
            override fun onSuccess(p0: LastPlayTrackList?) {
                result.success(p0?.toMap())
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

    /**
     * 获取某个分类下的元数据列表。
     * @param categoryId 分类ID，指定分类
     * @param result Flutter MethodChannel
     */
    fun getMetadataList(categoryId: String, result: Result) {
        val map: MutableMap<String, String> = HashMap()
        map[DTransferConstants.CATEGORY_ID] = categoryId
        CommonRequest.getMetadataList(map, object : IDataCallBack<MetaDataList> {
            override fun onSuccess(p0: MetaDataList?) {
                result.success(p0?.metaDatas?.map { it.toMap() })
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

    /**
     * 获取某个分类的元数据属性键值组合下包含的热门专辑列表/最新专辑列表/最多播放专辑列表。
     * @param categoryId 分类ID，指定分类，为0时表示热门分类
     * @param metadataAttributes 元数据属性列表：在/metadata/list接口得到的结果中，取不同元数据属性的attr_key和atrr_value组成任意个数的key-value键值，格式如：attr_key1:attr_value1;attr_key2:attr_value2;attr_key3:attr_value3
     * @param calcDimension 计算维度，现支持最火（1），最新（2），经典或播放最多（3）
     * @param page 返回第几页，必须大于等于1，不填默认为1
     * @param count 每页多少条，默认20，最多不超过200
     * @param result Flutter MethodChannel
     */
    fun getMetadataAlbumList(
            categoryId: String,
            metadataAttributes: String = "",
            calcDimension: String,
            page: String = "1",
            count: String = "20",
            result: Result
    ) {
        val map: MutableMap<String, String> = HashMap()
        map[DTransferConstants.CATEGORY_ID] = categoryId
        map[DTransferConstants.METADATA_ATTRIBUTES] = metadataAttributes
        map[DTransferConstants.CALC_DIMENSION] = calcDimension
        map[DTransferConstants.PAGE] = page
        map[DTransferConstants.PAGE_SIZE] = count
        CommonRequest.getMetadataAlbumList(map, object : IDataCallBack<AlbumList> {
            override fun onSuccess(p0: AlbumList?) {
                result.success(p0?.albums?.map { it.toMap() })
            }

            override fun onError(p0: Int, p1: String?) {
                println(p0)
                println(p1)
                result.error(p0.toString(), p1, null)
            }
        })
    }

}