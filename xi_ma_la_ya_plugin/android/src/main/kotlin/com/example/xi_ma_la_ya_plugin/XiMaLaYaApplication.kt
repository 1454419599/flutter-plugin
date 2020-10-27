package com.example.xi_ma_la_ya_plugin

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import com.ximalaya.ting.android.opensdk.player.appnotification.XmNotificationCreater
import com.ximalaya.ting.android.opensdk.util.BaseUtil

open class XiMaLaYaApplication {
    fun onCreate(context: Context) {
        if (BaseUtil.isPlayerProcess(context)) {
            with(XmNotificationCreater.getInstanse(context)) {
                val intent = Intent("com.app.test.android.Action_Close")
                intent.setClass(context, MyPlayerReceiver::class.java)
                val broadcast = PendingIntent.getBroadcast(context, 0, intent, 0)
                setClosePendingIntent(broadcast)
            }
        }
    }
}