package com.example.xi_ma_la_ya_plugin

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.ximalaya.ting.android.opensdk.player.XmPlayerManager
import com.ximalaya.ting.android.opensdk.player.service.XmPlayerService

class MyPlayerReceiver: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == "com.app.test.android.Action_Close") {
            XmPlayerManager.getInstance(context)?.pause()
            XmPlayerService.getPlayerSrvice()?.closeNotification()
        }
    }
}