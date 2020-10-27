package com.example.xi_ma_la_ya_plugin

import android.app.Activity
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.xi_ma_la_ya_plugin.model.toMap
import com.ximalaya.ting.android.opensdk.constants.ConstantsOpenSdk
import com.ximalaya.ting.android.opensdk.datatrasfer.CommonRequest
import com.ximalaya.ting.android.opensdk.model.PlayableModel
import com.ximalaya.ting.android.opensdk.model.advertis.Advertis
import com.ximalaya.ting.android.opensdk.model.advertis.AdvertisList
import com.ximalaya.ting.android.opensdk.model.track.Track
import com.ximalaya.ting.android.opensdk.player.XmPlayerManager
import com.ximalaya.ting.android.opensdk.player.advertis.IXmAdsStatusListener
import com.ximalaya.ting.android.opensdk.player.appnotification.NotificationColorUtils
import com.ximalaya.ting.android.opensdk.player.appnotification.XmNotificationCreater
import com.ximalaya.ting.android.opensdk.player.service.*
import com.ximalaya.ting.android.player.XMediaPlayerConstants
import com.ximalaya.ting.android.sdkdownloader.XmDownloadManager
import io.flutter.plugin.common.MethodChannel


object XiMaLaYa {
    lateinit var mContext: Context
    lateinit var mActivity: Activity
    lateinit var channel: MethodChannel

    fun init(appKey: String, packId: String, appSecret: String) {
//        ConstantsOpenSdk.isDebug = true
//        XMediaPlayerConstants.isDebug = true
        with(CommonRequest.getInstanse()) {
            setAppkey(appKey)
            setPackid(packId)
            useHttps = true
            mNoSupportHttps.add("http://adse.ximalaya.com")
            init(mContext, appSecret)
        }
        XiMaLaYaPlayer.mPlayerManager = XmPlayerManager.getInstance(mContext)
    }

    fun initPlayerManager(callback: (() -> Unit)?) {
        if (XiMaLaYaPlayer.mPlayerManager.isConnected) {
            callback?.invoke()
            return
        }

        with(XmPlayerManager.getInstance(mContext)) {
            NotificationColorUtils.isTargerSDKVersion24More = true
            val mNotification = XmNotificationCreater.getInstanse(mContext).initNotification(mContext.applicationContext, mActivity.javaClass)
            init(System.currentTimeMillis().toInt(), mNotification)

            addPlayerStatusListener(object : IXmPlayerStatusListener {
                override fun onPlayStart() {
                    println("开始播放 addPlayerStatusListener onPlayStart")
                    sendData(PlayerData(PlayerEvent.PLAY_START, null))
                }

                override fun onSoundSwitch(p0: PlayableModel?, p1: PlayableModel?) {
                    println("切歌 addPlayerStatusListener onSoundSwitch $p0 - $p1")
                    var last: Map<String, Any?>? = null
                    var cur: Map<String, Any?>? = null

                    if (p0?.kind == PlayableModel.KIND_TRACK) {
                        last = (p0 as Track).toMap()
                    }
                    if (p1?.kind == PlayableModel.KIND_TRACK) {
                        cur = (p1 as Track).toMap()
                    }

                    sendData(PlayerData(PlayerEvent.SOUND_SWITCH, HashMap<String, Any?>().also {
                        it["lastKind"] = p0?.kind
                        it["curKind"] = p1?.kind
                        it["last"] = last
                        it["cur"] = cur
                    }))
                }

                override fun onPlayProgress(p0: Int, p1: Int) {
//                    println("播放进度回调 addPlayerStatusListener onPlayProgress $p0 - $p1")
                    sendData(PlayerData(PlayerEvent.PLAY_PROGRESS, HashMap<String, Int>().also {
                        it["currPos"] = p0
                        it["duration"] = p1
                    }))
                }

                override fun onPlayPause() {
                    println("暂停播放 addPlayerStatusListener onPlayPause")
                    sendData(PlayerData(PlayerEvent.PLAY_PAUSE, null))
                }

                override fun onBufferProgress(p0: Int) {
//                    println("缓冲进度回调 addPlayerStatusListener onBufferProgress $p0")
                    sendData(PlayerData(PlayerEvent.BUFFER_PROGRESS, p0))
                }

                override fun onPlayStop() {
                    println("停止播放 addPlayerStatusListener onPlayStop")
                    sendData(PlayerData(PlayerEvent.PLAY_STOP, null))
                }

                override fun onBufferingStart() {
                    println("开始缓冲 addPlayerStatusListener onBufferingStart")
                    sendData(PlayerData(PlayerEvent.BUFFERING_START, null))
                }

                override fun onSoundPlayComplete() {
                    println("播放完成 addPlayerStatusListener onSoundPlayComplete")
                    sendData(PlayerData(PlayerEvent.SOUND_PLAY_COMPLETE, null))
                }

                override fun onError(p0: XmPlayerException?): Boolean {
                    println("播放器错误 addPlayerStatusListener onError :")
                    p0?.printStackTrace()
                    sendData(PlayerData(PlayerEvent.ERROR, p0.toString()))
                    return false
                }

                override fun onSoundPrepared() {
                    println("播放器准备完毕 addPlayerStatusListener onSoundPrepared")
                    sendData(PlayerData(PlayerEvent.SOUND_PREPARED, null))
                }

                override fun onBufferingStop() {
                    println("结束缓冲 addPlayerStatusListener onBufferingStop")
                    sendData(PlayerData(PlayerEvent.BUFFERING_STOP, null))
                }

            })

            addAdsStatusListener(object : IXmAdsStatusListener {
                override fun onAdsStartBuffering() {
                    println("addAdsStatusListener onAdsStartBuffering")
                }

                override fun onAdsStopBuffering() {
                    println("addAdsStatusListener onAdsStopBuffering")
                }

                override fun onStartPlayAds(p0: Advertis?, p1: Int) {
                    println("addAdsStatusListener onStartPlayAds $p0 - $p1")
                }

                override fun onStartGetAdsInfo() {
                    println("addAdsStatusListener onStartGetAdsInfo")
                }

                override fun onGetAdsInfo(p0: AdvertisList?) {
                    println("addAdsStatusListener onGetAdsInfo $p0")
                }

                override fun onCompletePlayAds() {
                    println("addAdsStatusListener onCompletePlayAds")
                }

                override fun onError(p0: Int, p1: Int) {
                    println("addAdsStatusListener onError $p0 - $p1")
                }
            })

            addOnConnectedListerner(object : XmPlayerManager.IConnectListener {
                override fun onConnected() {
                    removeOnConnectedListerner(this)
                    playMode = XmPlayListControl.PlayMode.PLAY_MODEL_LIST
                    println("播放器初始化成功")
                    callback?.invoke()
                }
            })

            // 此代码表示播放时会去监测下是否已经下载
            setCommonBusinessHandle(XmDownloadManager.getInstance())
        }
    }

    fun sendData(playerData: PlayerData) {
        channel.invokeMethod("playerController", playerData.toMap())
    }

    enum class PlayerEvent {
        PLAY_START,
        PLAY_PAUSE,
        PLAY_STOP,
        SOUND_PLAY_COMPLETE,
        SOUND_PREPARED,
        SOUND_SWITCH,
        BUFFERING_START,
        BUFFERING_STOP,
        BUFFER_PROGRESS,
        PLAY_PROGRESS,
        ERROR,
    }

    data class PlayerData(private val type: PlayerEvent, private val data: Any?) {
        fun toMap(): Map<String, *> {
            return HashMap<String, Any?>().also {
                it["type"] = type.name
                it["data"] = data
            }
        }
    }
}
