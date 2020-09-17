package com.maodouyuedu.youlianghuiplugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.qq.e.ads.splash.SplashAD;
import com.qq.e.ads.splash.SplashADListener;
import com.qq.e.comm.util.AdError;

public class YouLiangHuiSplashAD implements SplashADListener {
    private static String TAG = "YouLiangHuiSplashAD";
    private static YouLiangHuiSplashAD youLiangHuiSplashAD;
    private static byte[] bytes = {1};
    SplashAD splashAD;
    private Activity mActivity;

    public static YouLiangHuiSplashAD getInstance(Activity activity) {
        synchronized (bytes) {
            if (youLiangHuiSplashAD == null) {
                youLiangHuiSplashAD = new YouLiangHuiSplashAD(activity);
            }
            return youLiangHuiSplashAD;
        }
    }

    YouLiangHuiSplashAD(Activity activity) {
        mActivity = activity;
    }

    void loadSplashAD() {
        fetchSplashAD();
    }

    void showSplashAD() {
        if (splashAD != null) {
            Intent intent = new Intent();
            intent.setClass(mActivity,YouLiangHuiSplashActivity.class);
            mActivity.startActivity(intent);
            mActivity.overridePendingTransition(0, 0);
        }
    }

    private void fetchSplashAD() {
        splashAD = new SplashAD(mActivity, YouLiangHuiConfig.SPLASH_ID, this);
        splashAD.fetchAdOnly();
    }


    @Override
    public void onADClicked() {
        Log.d(TAG, "广告被点击时调用，不代表满足计费条件（如点击时网络异常）");
        YoulianghuipluginPlugin.basicMessageChannel.send(
                YouLiangHuiConfig.responseSucccessData(
                        YouLiangHuiConfig.showSplashADMethodName, YouLiangHuiConfig.AdStatus.Click));
    }

    @Override
    public void onADDismissed() {
        Log.d(TAG, "广告关闭时调用，可能是用户关闭或者展示时间到。此时一般需要跳过开屏的 Activity，进入应用内容页面");
        YoulianghuipluginPlugin.basicMessageChannel.send(
                YouLiangHuiConfig.responseSucccessData(
                        YouLiangHuiConfig.showSplashADMethodName, YouLiangHuiConfig.AdStatus.Close));
    }

    @Override
    public void onADExposure() {
        Log.d(TAG, "广告曝光时调用，此处的曝光不等于有效曝光（如展示时长未满足）");
        YoulianghuipluginPlugin.basicMessageChannel.send(
                YouLiangHuiConfig.responseSucccessData(
                        YouLiangHuiConfig.showSplashADMethodName, YouLiangHuiConfig.AdStatus.Expose));
    }

    @Override
    public void onADLoaded(long l) {
        Log.d(TAG, "广告加载成功的回调，在fetchAdOnly的情况下，表示广告拉取成功可以显示了。广告需要在SystemClock.elapsedRealtime <expireTimestamp前展示，否则在showAd时会返回广告超时错误。");
        YoulianghuipluginPlugin.basicMessageChannel.send(
                YouLiangHuiConfig.responseSucccessData(
                        YouLiangHuiConfig.loadSplashADMethodName, YouLiangHuiConfig.AdStatus.Load));
    }

    @Override
    public void onADPresent() {
        Log.d(TAG, "广告成功展示时调用，成功展示不等于有效展示（比如广告容器高度不够）");
        YoulianghuipluginPlugin.basicMessageChannel.send(
                YouLiangHuiConfig.responseSucccessData(
                        YouLiangHuiConfig.showSplashADMethodName, YouLiangHuiConfig.AdStatus.Show));
    }

    @Override
    public void onADTick(long l) {
        Log.d(TAG, l + "ms, 倒计时回调，返回广告还将被展示的剩余时间，单位是 ms");
    }

    @Override
    public void onNoAD(AdError adError) {
        Log.d(TAG, "广告加载失败，error 对象包含了错误码和错误信息，错误码的详细内容可以参考文档第5章");
        Log.e(TAG, "msg:" + adError.getErrorMsg() + " code:" + adError.getErrorCode());
        YoulianghuipluginPlugin.basicMessageChannel.send(
                YouLiangHuiConfig.responseSucccessData(
                        YouLiangHuiConfig.loadSplashADMethodName, YouLiangHuiConfig.AdStatus.Error));
    }
}
