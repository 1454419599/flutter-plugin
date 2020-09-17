package com.maodouyuedu.youlianghuiplugin;

import android.content.Context;
import android.os.SystemClock;
import android.util.Log;

import com.qq.e.ads.rewardvideo.RewardVideoAD;
import com.qq.e.ads.rewardvideo.RewardVideoADListener;
import com.qq.e.comm.util.AdError;

import java.util.Locale;

public class YouLiangHuiRewardVideoAD implements RewardVideoADListener {
    private String TAG = "YouLiangHuiRewardVideoAD";
    private static final byte[] lock = new byte[0]; // 特殊的instance变量
    private static YouLiangHuiRewardVideoAD youLiangHuiRewardVideoAD;

    private boolean adLoaded = false;
    private RewardVideoAD rewardVideoAD;
    private boolean autoShow = false;

    static YouLiangHuiRewardVideoAD getInstance(final Context context, final String posID, final boolean volumeOn) {
        synchronized (lock) {
            if (youLiangHuiRewardVideoAD == null) {
                youLiangHuiRewardVideoAD = new YouLiangHuiRewardVideoAD(context, posID, volumeOn);
            }
            return youLiangHuiRewardVideoAD;
        }
    }

    private YouLiangHuiRewardVideoAD(final Context context, final String posID, final boolean volumeOn) {
        rewardVideoAD = new RewardVideoAD(context, posID, this, volumeOn);
        rewardVideoAD.loadAD();
    }

    public void showAd() {
        // 展示广告
        if (adLoaded) {//广告展示检查1：广告成功加载，此处也可以使用videoCached来实现视频预加载完成后再展示激励视频广告的逻辑
            if (!rewardVideoAD.hasShown()) {//广告展示检查2：当前广告数据还没有展示过
                long delta = 1000;//建议给广告过期时间加个buffer，单位ms，这里demo采用1000ms的buffer
                //广告展示检查3：展示广告前判断广告数据未过期
                if (SystemClock.elapsedRealtime() < (rewardVideoAD.getExpireTimestamp() - delta)) {
                    rewardVideoAD.showAD();
                } else {
                    autoShow = true;
                    rewardVideoAD.loadAD();
                    Log.d(TAG, "激励视频广告已过期，请再次请求广告后进行广告展示！");
                }
            } else {
                autoShow = true;
                rewardVideoAD.loadAD();
                Log.d(TAG, "此条广告已经展示过，请再次请求广告后进行广告展示！");
            }
        } else {
            autoShow = true;
            rewardVideoAD.loadAD();
            Log.d(TAG, "成功加载广告后再进行广告展示！");
        }
    }

    @Override
    public void onADLoad() {
        adLoaded = true;
        if (autoShow) {
            showAd();
        }
        Log.d(TAG, "广告加载成功，可在此回调后进行广告展示");
        YoulianghuipluginPlugin.basicMessageChannel.send(YouLiangHuiConfig.responseSucccessData(
                YouLiangHuiConfig.showRewardVideoADMethodName, YouLiangHuiConfig.AdStatus.Load
        ));
    }

    @Override
    public void onVideoCached() {

    }

    @Override
    public void onADShow() {
        Log.i(TAG, "激励视频广告页面展示");
        autoShow = false;
        YoulianghuipluginPlugin.basicMessageChannel.send(YouLiangHuiConfig.responseSucccessData(
                YouLiangHuiConfig.showRewardVideoADMethodName, YouLiangHuiConfig.AdStatus.Show
        ));
    }

    @Override
    public void onADExpose() {
        YoulianghuipluginPlugin.basicMessageChannel.send(YouLiangHuiConfig.responseSucccessData(
                YouLiangHuiConfig.showRewardVideoADMethodName, YouLiangHuiConfig.AdStatus.Expose
        ));
    }

    @Override
    public void onReward() {
        YoulianghuipluginPlugin.basicMessageChannel.send(YouLiangHuiConfig.responseSucccessData(
                YouLiangHuiConfig.showRewardVideoADMethodName, YouLiangHuiConfig.AdStatus.Reward
        ));
    }

    @Override
    public void onADClick() {
        YoulianghuipluginPlugin.basicMessageChannel.send(YouLiangHuiConfig.responseSucccessData(
                YouLiangHuiConfig.showRewardVideoADMethodName, YouLiangHuiConfig.AdStatus.Click
        ));
    }

    @Override
    public void onVideoComplete() {
        rewardVideoAD.loadAD();
        YoulianghuipluginPlugin.basicMessageChannel.send(YouLiangHuiConfig.responseSucccessData(
                YouLiangHuiConfig.showRewardVideoADMethodName, YouLiangHuiConfig.AdStatus.Complete
        ));
        Log.i(TAG, "激励视频播放完毕");
    }

    @Override
    public void onADClose() {
        Log.i(TAG, "激励视频广告被关闭");
        YoulianghuipluginPlugin.basicMessageChannel.send(YouLiangHuiConfig.responseSucccessData(
                YouLiangHuiConfig.showRewardVideoADMethodName, YouLiangHuiConfig.AdStatus.Close
        ));
    }

    @Override
    public void onError(AdError adError) {
        String msg = String.format(Locale.getDefault(), "onError, error code: %d, error msg: %s",
                adError.getErrorCode(), adError.getErrorMsg());
        Log.e(TAG, msg);
        YoulianghuipluginPlugin.basicMessageChannel.send(YouLiangHuiConfig.responseErrorData(
                YouLiangHuiConfig.showRewardVideoADMethodName, adError.getErrorCode() + "", adError.getErrorMsg()));
    }
}
