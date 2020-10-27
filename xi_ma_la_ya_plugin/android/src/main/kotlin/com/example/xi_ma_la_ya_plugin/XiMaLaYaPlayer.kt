package com.example.xi_ma_la_ya_plugin
import androidx.annotation.NonNull
import com.example.xi_ma_la_ya_plugin.model.trackFromMap
import com.example.xi_ma_la_ya_plugin.model.trackListFromMap
import com.ximalaya.ting.android.opensdk.model.track.CommonTrackList
import com.ximalaya.ting.android.opensdk.model.track.Track
import com.ximalaya.ting.android.opensdk.player.XmPlayerManager
import com.ximalaya.ting.android.opensdk.player.service.XmPlayListControl
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object XiMaLaYaPlayer {
    lateinit var mPlayerManager: XmPlayerManager
    private var mPlayList: MutableList<Track>? = null
    
    fun onPlayerMethodCallHandler(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        try {
            val obj = call.arguments
            if (obj is Map<*, *>) {
                val data = obj["data"]
                when(obj["method"]) {
                    "play" -> result.success(play(data as Int?))
                    "pause" -> mPlayerManager.pause()
                    "playPre" -> mPlayerManager.playPre()
                    "playNext" -> mPlayerManager.playNext()
                    "setPlayMode" -> setPlayMode(data as String)
                    "getPlayerStatus" -> result.success(mPlayerManager.playerStatus)
                    "isPlaying" -> result.success(mPlayerManager.isPlaying)
                    "getCurrentIndex" -> result.success(mPlayerManager.currentIndex)
                    "hasPreSound" -> result.success(mPlayerManager.hasPreSound())
                    "hasNextSound" -> result.success(mPlayerManager.hasNextSound())
                    "getDuration" -> result.success(mPlayerManager.duration)
                    "getPlayCurrPositon" -> result.success(mPlayerManager.playCurrPositon)
                    "seekToByPercent" -> mPlayerManager.seekToByPercent((data as Double).toFloat())
                    "seekTo" -> mPlayerManager.seekTo(data as Int)
                    "setVolume" -> setVolume(data as Map<*, *>)
                    "getCurrSound" -> {}//TODO 未实现 获取当前的播放model
                    "getCurrPlayType" -> result.success(mPlayerManager.currPlayType)
                    "clearPlayCache" -> mPlayerManager.clearPlayCache()
                    "isOnlineSource" -> result.success(mPlayerManager.isOnlineSource)
                    "isAdsActive" -> result.success(mPlayerManager.isAdsActive)
                    "getCurPlayUrl" -> result.success(mPlayerManager.curPlayUrl)
                    "resetPlayList" -> mPlayerManager.resetPlayList()
                    "removeListByIndex" -> mPlayerManager.removeListByIndex(data as Int)
                    "resetPlayer" -> mPlayerManager.resetPlayer()
                    "getTempo" -> result.success(mPlayerManager.tempo)
                    "setPlayList" -> setPlayList(data, result)
                    "addPlayList" -> addPlayList(data, result)
                    "setPlayListAndPlay" -> setPlayListAndPlay(data, result)
                    "setPlayCommonTrackListAndPlay" -> setPlayCommonTrackListAndPlay(data, result)
                    "setPlayCommonTrackList" -> setPlayCommonTrackList(data, result)
//                    "addPlayCommonTrackList" -> addPlayCommonTrackList(data, result)
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            result.error("0", e.message, e)
        }

    }

    private fun setPlayList(playList: Any?): Boolean {
        return try {
            if (playList is List<*>) {
                val list = mutableListOf<Track>()
                for (item in playList) {
                    list.add(trackFromMap(item as Map<String, Any?>))
                }
                mPlayList = list
//                XiMaLaYa.initPlayerManager{
//                    mPlayerManager.setPlayList(mPlayList, mPlayerManager.currentIndex)
//                }
//                mPlayerManager.setPlayList(mPlayList, mPlayerManager.currentIndex)
                true
            } else false
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun addPlayList(playList: Any?): Boolean {
        if (mPlayList == null) {
            mPlayList = mutableListOf()
        }
        return if (playList is List<*>) {
            val list = mutableListOf<Track>()
            for (item in playList) {
                list.add(trackFromMap(item as Map<String, Any?>))
            }
            return mPlayList?.addAll(list) == true
//            return if (mPlayList?.addAll(list) == true) {
//                XiMaLaYa.initPlayerManager{
//                    mPlayerManager.setPlayList(mPlayList, mPlayerManager.currentIndex)
//                }
//                true
//            } else false
        } else false
    }

    private fun playListIndex(startIndex: Int) {
        playList(mPlayList, startIndex)
    }

    private fun playList(list: MutableList<Track>?, startIndex: Int) {
        XiMaLaYa.initPlayerManager { mPlayerManager.playList(list, startIndex) }
    }

    private fun playList(list: CommonTrackList<Track>, startIndex: Int) {
        XiMaLaYa.initPlayerManager { mPlayerManager.playList(list, startIndex) }
    }

    /**
     * 尝试恢复播放器的播放状态，如果恢复失败，则播放列表的第一条声音
     * 播放指定索引处的声音
     */
    private fun play(index: Int?): Int {
        if (index == null) mPlayerManager.play() else mPlayerManager.play(index)
        return mPlayerManager.currentIndex
    }

    /**
     * 设置播放器模式
     */
    private fun setPlayMode(playModeString: String) {
        try {
            val playMode = XmPlayListControl.PlayMode.valueOf(playModeString)
            mPlayerManager.playMode = playMode
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    /**
     * 此方法调用的是AudioTrack的音量 调节音量 ,left表示左声道 ,值的范围为 0 - 1 表示AudioTrack最大音量的百分比
     */
    private fun setVolume(map: Map<*, *>) {
        val leftVolume: Float = (map["leftVolume"] as Double).toFloat()
        val rightVolume: Float = (map["rightVolume"] as Double).toFloat()
        mPlayerManager.setVolume(leftVolume, rightVolume)
    }

    private fun setPlayListAndPlay(data: Any?, @NonNull result: MethodChannel.Result) {
        try {
            println("setPlayListAndPlay")
            var index: Int
            val r = data.let {
                if (it !is Map<*, *>) return
                index = it["index"] as Int
                setPlayList(it["playList"])
            }
            if (r) playListIndex(index)
            result.success(r)
        } catch (e: Exception) {
            e.printStackTrace()
            result.error(e.message, null, e)
        }
    }

    private fun setPlayCommonTrackListAndPlay(data: Any?, @NonNull result: MethodChannel.Result) {
        try {
            val r = if (data is Map<*, *>) {
                val list = trackListFromMap(data["commonTrackList"] as Map<String, Any?>)
                val index = data["index"] as Int
//                mPlayerManager.playList(list, index)
                playList(list, index)
                true
            } else false
            result.success(r)
        } catch (e: Exception) {
            e.printStackTrace()
            result.error(e.message, null, e)
        }
    }

    private fun setPlayCommonTrackList(data: Any?, @NonNull result: MethodChannel.Result) {
        try {
            val r = if (data is Map<*, *>) {
                val list = trackListFromMap(data["commonTrackList"] as Map<String, Any?>)
                val index = data["index"] as Int
                playList(list, index)
//                mPlayerManager.setPlayList(list, index)
                true
            } else false
            result.success(r)
        } catch (e: Exception) {
            e.printStackTrace()
            result.error(e.message, null, e)
        }
    }

//    private fun addPlayCommonTrackList(data: Any?, @NonNull result: MethodChannel.Result) {
//        try {
//            println("addPlayCommonTrackList---")
//            val obj = trackListFromMap(data as Map<String, Any?>)
//            println(obj is CommonTrackList<*>)
//            if (obj is CommonTrackList<*>) {
//                val currentPlayList = mPlayerManager.playList
//                val addPlayList = obj.tracks as List<Track>?
//                if (addPlayList?.isEmpty() != false) {
//                    print("addPlayCommonTrackList tracks 长度为0")
//                    result.success(true)
//                    return
//                }
//                if (currentPlayList == null || currentPlayList.isEmpty()) {
//                    mPlayerManager.setPlayList(obj, 0)
//                } else {
//                    val currentFirst = currentPlayList.first()
//                    val currentLast = currentPlayList.last()
//
//                    val addFirst = addPlayList.first()
//                    val addLast = addPlayList.last()
//
//                    if (currentLast.orderNum < addFirst.orderNum) {
//                        currentPlayList.addAll(addPlayList)
//                    } else if (addLast.orderNum < currentFirst.orderNum) {
//                        currentPlayList.addAll(0, addPlayList)
//                    } else if (addFirst.orderNum < currentFirst.orderNum && addLast.orderNum >= currentFirst.orderNum){
//                        var currentIndex = 0
//                        for (i in addPlayList.indices) {
//                            if (currentFirst.orderNum >= addPlayList[i].orderNum) {
//                                currentIndex = i
//                            } else {
//                                break
//                            }
//                        }
//                        currentPlayList.addAll(0, addPlayList.subList(0, currentIndex))
//                    } else if (addFirst.orderNum < currentLast.orderNum && addLast.orderNum >= currentLast.orderNum){
//                        var currentIndex = currentPlayList.size - 1
//                        for (i in addPlayList.size - 1 downTo 0) {
//                            if (addPlayList[i].orderNum > currentLast.orderNum) {
//                                currentIndex = i
//                            } else {
//                                break
//                            }
//                        }
//                        currentPlayList.addAll(addPlayList.subList(currentIndex, currentPlayList.size))
//                    }
//                }
//                print("currentPlayList size ${currentPlayList.size}")
//                result.success(true)
//            } else {
//                result.success(false)
//            }
//        } catch (e: Exception) {
//            e.printStackTrace()
//            result.error(e.message, null, e)
//        }
//    }

    private fun setPlayList(data: Any?, @NonNull result: MethodChannel.Result) {
        try {
            println("setPlayList")
            val r = setPlayList(data)
            result.success(r)
        } catch (e: Exception) {
            e.printStackTrace()
            result.error(e.message, null, e)
        }
    }

    private fun addPlayList(data: Any?, @NonNull result: MethodChannel.Result) {
        try {
            println("addPlayList")
            val r = addPlayList(data)
            result.success(r)
        } catch (e: Exception) {
            e.printStackTrace()
            result.error(e.message, null, e)
        }
    }
}