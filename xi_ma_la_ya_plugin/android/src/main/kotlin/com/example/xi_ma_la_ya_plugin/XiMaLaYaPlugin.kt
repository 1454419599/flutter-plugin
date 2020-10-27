package com.example.xi_ma_la_ya_plugin

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

const val initXiMaLaYaMethodName = "initXiMaLaYa"
const val initPlayerManagerMethodName = "initPlayerManager"
const val getCategoriesMethodName = "getCategories"
const val getTagsMethodName = "getTags"
const val getAlbumListMethodName = "getAlbumList"
const val getTracksMethodName = "getTracks"
const val getHotTracksMethodName = "getHotTracks"
const val getBatchTracksMethodName = "getBatchTracks"
const val getMetadataListMethodName = "getMetadataList"
const val getMetadataAlbumListMethodName = "getMetadataAlbumList"
const val getLastPlayTracksMethodName = "getLastPlayTracks"
const val getBatchMethodName = "getBatch"
//const val setPlayListMethodName = "setPlayList"
//const val addPlayListMethodName = "addPlayList"
//const val setPlayListAndPlayMethodName = "setPlayListAndPlay"
const val playerControllerMethodName = "playerController"

/** XiMaLaYaPlugin */
public class XiMaLaYaPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "xi_ma_la_ya_plugin")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "xi_ma_la_ya_plugin")
        channel.setMethodCallHandler(this)
        XiMaLaYa.mContext = flutterPluginBinding.applicationContext
        XiMaLaYa.channel = channel
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "xi_ma_la_ya_plugin")
            channel.setMethodCallHandler(XiMaLaYaPlugin())
            XiMaLaYa.mContext = registrar.activeContext()
            XiMaLaYa.mActivity = registrar.activity()
            XiMaLaYa.channel = channel
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            initXiMaLaYaMethodName -> initXiMaLaYa(call, result)
            initPlayerManagerMethodName -> XiMaLaYa.initPlayerManager(null)
            playerControllerMethodName -> XiMaLaYaPlayer.onPlayerMethodCallHandler(call, result)
            getCategoriesMethodName -> XiMaLaYaRequest.categoriesList(result)
            getTagsMethodName -> getTags(call, result)
            getAlbumListMethodName -> getAlbumList(call, result)
            getTracksMethodName -> getTracks(call, result)
            getHotTracksMethodName -> {
                println("getTracksMethodName")
                XiMaLaYaRequest.getHotTracks(result = result)
            }
            getBatchTracksMethodName -> {
                println("getBatchTracksMethodName")
                XiMaLaYaRequest.getBatchTracks(ids = "", result = result)
            }
            getMetadataListMethodName -> getMetadataList(call, result)
            getMetadataAlbumListMethodName -> getMetadataAlbumList(call, result)
            getLastPlayTracksMethodName -> getLastPlayTracks(call, result)
            getBatchMethodName -> getBatch(call, result)
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getTracks(@NonNull call: MethodCall, @NonNull result: Result) {
        println("getTracks")
        call.arguments.let {
            if (it !is Map<*, *>) return
            val albumId = it["albumId"] as String
            val sort = it["sort"] as String
            val page = it["page"] as String
            val count = it["count"] as String
            XiMaLaYaRequest.getTracks(albumId, sort, page, count, result)
        }
    }

    private fun getAlbumList(@NonNull call: MethodCall, @NonNull result: Result) {
        println("getAlbumListMethodName")
        call.arguments.let {
            if (it !is Map<*, *>) return
            val categoryId = it["categoryId"] as String
            val calcDimension = it["calcDimension"] as String
            val tagName = it["tagName"] as? String
            val page = it["page"] as String
            val count = it["count"] as String
            XiMaLaYaRequest.getAlbumList(categoryId, calcDimension, tagName, page, count, result = result)
        }
    }

    private fun getTags(@NonNull call: MethodCall, @NonNull result: Result) {
        println("getTags")
        call.arguments.let {
            if (it !is Map<*, *>) return
            val categoryId = it["categoryId"] as String
            val type = it["type"] as String
            XiMaLaYaRequest.getTags(categoryId, type, result = result)
        }
    }

    private fun initXiMaLaYa(@NonNull call: MethodCall, @NonNull result: Result) {
        call.arguments.let {
            if (it !is Map<*, *>) return
            val appKey = it["appKey"] as String
            val packId = it["packId"] as String
            val appSecret = it["appSecret"] as String
            println("$appKey - $packId - $appSecret")
            XiMaLaYa.init(appKey, packId, appSecret)
        }
    }
    /**
     * 获取某个分类下的元数据列表。
     */
    private fun getMetadataList(@NonNull call: MethodCall, @NonNull result: Result) {
        println("getMetadataListMethodName")
        call.arguments.let {
            if (it !is Map<*, *>) return
            val categoryId = it["categoryId"] as String?
            if (categoryId?.isEmpty() != false) {
                println("categoryId 不能为空")
                result.error("categoryId 不能为空", null, null)
                return
            }
            XiMaLaYaRequest.getMetadataList(categoryId = categoryId, result = result)
        }
    }

    /**
     * 获取某个分类的元数据属性键值组合下包含的热门专辑列表/最新专辑列表/最多播放专辑列表。
     */
    private fun getMetadataAlbumList(@NonNull call: MethodCall, @NonNull result: Result) {
        println("getMetadataAlbumListMethodName")
        call.arguments.let {
            if (it !is Map<*, *>) return
            val categoryId = it["categoryId"] as String?
            if (categoryId?.isEmpty() != false) {
                result.error("categoryId 不能为空", null, null)
                return
            }
            val calcDimension = it["calcDimension"]?.toString()
            if (calcDimension?.isEmpty() != false) {
                result.error("calcDimension 不能为空", null, null)
                return
            }
            val page = it["page"]?.toString() ?: "1"
            val count = it["count"]?.toString() ?: "20"
            val metadataAttributes = it["metadataAttributes"] as String
            XiMaLaYaRequest.getMetadataAlbumList(categoryId, metadataAttributes, calcDimension, page, count, result = result)
        }
    }

    /**
     * 根据上一次所听声音的id，获取此声音所在那一页的声音
     */
    private fun getLastPlayTracks(@NonNull call: MethodCall, @NonNull result: Result) {
        println("getLastPlayTracks")
        call.arguments.let {
            if (it !is Map<*, *>) return
            val albumId = it["albumId"] as String?
            if (albumId?.isEmpty() != false) {
                result.error("albumId 不能为空", null, null)
                return
            }
            val trackId = it["trackId"] as String?
            if (trackId?.isEmpty() != false) {
                result.error("trackId 不能为空", null, null)
                return
            }
            val sort = it["sort"]?.toString() ?: "asc"
            val count = it["count"]?.toString() ?: "20"
            val containsPaid = it["containsPaid"] as Boolean? ?: false
            XiMaLaYaRequest.getLastPlayTracks(albumId, trackId, count, sort, containsPaid, result = result)
        }
    }

    /**
     * 批量获取专辑列表
     */
    private fun getBatch(@NonNull call: MethodCall, @NonNull result: Result) {
        call.arguments.let {
            if (it !is Map<*, *>) return
            val ids = it["ids"] as String?
            if (ids?.isEmpty() != false) {
                result.error("ids 不能为空", null, null)
                return
            }
            XiMaLaYaRequest.getBatch(ids, result = result)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {

    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {

    }

    override fun onAttachedToActivity(p0: ActivityPluginBinding) {
        XiMaLaYa.mActivity = p0.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }
}
