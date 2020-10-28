package com.example.xi_ma_la_ya_plugin

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class MyPlayerReceiverMain: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == "com.app.test.android.Action_Close") {
            XiMaLaYaPlayer.mPlayerManager.pause()
            if (context != null) {
                val i = Intent("com.app.player.android.Action_Close")
                i.setClass(context, MyPlayerReceiverPlayer::class.java)
                context.sendBroadcast(i)
            }
        }
    }
}
