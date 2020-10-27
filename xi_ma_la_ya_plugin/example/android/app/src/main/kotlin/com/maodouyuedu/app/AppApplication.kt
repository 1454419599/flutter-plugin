package com.maodouyuedu.app

import io.flutter.app.FlutterApplication
import com.example.xi_ma_la_ya_plugin.XiMaLaYaApplication

class AppApplication: FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        XiMaLaYaApplication().onCreate(this)
    }
}