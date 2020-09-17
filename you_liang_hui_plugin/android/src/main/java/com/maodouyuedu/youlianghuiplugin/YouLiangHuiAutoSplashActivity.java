package com.maodouyuedu.youlianghuiplugin;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.KeyEvent;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;

import com.example.youlianghuiplugin.R;
import com.qq.e.ads.splash.SplashAD;
import com.qq.e.ads.splash.SplashADListener;
import com.qq.e.comm.util.AdError;

public class YouLiangHuiAutoSplashActivity extends Activity implements SplashADListener {
    private static String TAG = "YouLiangHuiAutoSplashActivity";
    private FrameLayout splashContainer;
    private ImageView appLogo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
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
        SplashAD splashAD = new SplashAD(this, YouLiangHuiConfig.SPLASH_ID, this);
        splashAD.fetchAndShowIn(splashContainer);
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

    void close() {
        try {
            YoulianghuipluginPlugin.basicMessageChannel.send(
                    YouLiangHuiConfig.responseSucccessData(
                            YouLiangHuiConfig.autoSplashADMethodName, YouLiangHuiConfig.AdStatus.Close));
        } catch (Exception e) {
            e.printStackTrace();
        }
        overridePendingTransition(0, 0);
        finish();
    }

    @Override
    public void onADClicked() {
        Log.d(TAG, "onADClicked");
    }

    @Override
    public void onADDismissed() {
        close();
    }

    @Override
    public void onADExposure() {

    }

    @Override
    public void onADLoaded(long l) {

    }

    @Override
    public void onADPresent() {

    }

    @Override
    public void onADTick(long l) {

    }

    @Override
    public void onNoAD(AdError adError) {
        close();
    }
}
