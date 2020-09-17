package com.maodouyuedu.youlianghuiplugin;


import android.app.Activity;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;

import com.example.youlianghuiplugin.R;

public class YouLiangHuiSplashActivity extends Activity {
    private static String TAG = "YouLiangHuiSplashActivity";
    public static Activity instance;
    private FrameLayout splashContainer;
    private ImageView appLogo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        instance = this;
        bindView();
        showAppLogo();
        showAd();
    }

    private void bindView() {
        splashContainer = findViewById(R.id.splash_container);
        appLogo = findViewById(R.id.app_logo);
    }

    private void showAppLogo() {
        try {
            if (appLogo == null) return;
            String packageName = getPackageName(this);
            if (packageName == null) return;
            int id = getResources().getIdentifier("splash_logo", "drawable", packageName);
            appLogo.setImageResource(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static synchronized String getPackageName(Context context) {
        try {
            PackageManager packageManager = context.getPackageManager();
            PackageInfo packageInfo = packageManager.getPackageInfo(
                    context.getPackageName(), 0);
            return packageInfo.packageName;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private void showAd() {
        YouLiangHuiSplashAD youLiangHuiSplashAD = YouLiangHuiSplashAD.getInstance(this);
        YoulianghuipluginPlugin.mActivity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN);
        YoulianghuipluginPlugin.mActivity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        youLiangHuiSplashAD.splashAD.showAd(splashContainer);
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getKeyCode() == KeyEvent.KEYCODE_BACK ) {
            //do something.
            return true;
        } else {
            return super.dispatchKeyEvent(event);
        }
    }

    @Override
    protected void onDestroy() {
        Log.d(TAG, "onDestroy");
        instance = null;
        super.onDestroy();
    }
}
