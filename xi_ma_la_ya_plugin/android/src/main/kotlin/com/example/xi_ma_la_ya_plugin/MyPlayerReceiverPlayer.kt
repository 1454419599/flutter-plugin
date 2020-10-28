package com.example.xi_ma_la_ya_plugin

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.ximalaya.ting.android.opensdk.player.service.XmPlayerService

class MyPlayerReceiverPlayer: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == "com.app.player.android.Action_Close") {
            XmPlayerService.getPlayerSrvice()?.closeNotification()
        }
    }
}