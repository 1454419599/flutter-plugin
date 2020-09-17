package com.maodouyuedu.youlianghuiplugin;

import android.content.Context;
import android.util.Log;

import com.qq.e.ads.cfg.VideoOption;
import com.qq.e.ads.nativ.ADSize;
import com.qq.e.ads.nativ.NativeExpressAD;
import com.qq.e.ads.nativ.NativeExpressADView;
import com.qq.e.comm.constants.AdPatternType;
import com.qq.e.comm.util.AdError;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class YouLiangHuiNativeExpressAD implements NativeExpressAD.NativeExpressADListener {
    private String TAG = "YouLiangHuiNativeExpressAD";
    private static final byte[] lock = new byte[0]; // 特殊的instance变量
    private static Map<String, YouLiangHuiNativeExpressAD> youLiangHuiNativeExpressADMap = new HashMap<>();
    private LinkedList<NativeExpressADView> adDataLinkedList = new LinkedList();
    private NativeExpressAD mNativeExpressAD;
    private int AD_COUNT = 2;

    public static YouLiangHuiNativeExpressAD getInstance(final Context context, String posId, double width, double height) {
        synchronized (lock) {
            String key = posId + "-" + width + "-" + height;
            if (youLiangHuiNativeExpressADMap.get(key) == null) {
                YouLiangHuiNativeExpressAD youLiangHuiNativeExpressAD = new YouLiangHuiNativeExpressAD(context, posId, width, height);
                youLiangHuiNativeExpressAD.cacheAd();
                youLiangHuiNativeExpressADMap.put(key, youLiangHuiNativeExpressAD);
            }
            return youLiangHuiNativeExpressADMap.get(key);
        }
    }

    private YouLiangHuiNativeExpressAD(Context context, String posId, double width, double height) {
        int adWidth, adHeight;
        if (width == -2) {
            adWidth = ADSize.AUTO_HEIGHT;
        } else if (width > 0) {
            adWidth = (int) width;
        } else {
            adWidth = ADSize.FULL_WIDTH;
        }
        if (height == -1) {
            adHeight = ADSize.FULL_WIDTH;
        } else if (height > 0) {
            adHeight = (int) height;
        } else {
            adHeight = ADSize.AUTO_HEIGHT;
        }
        mNativeExpressAD = new NativeExpressAD(context, new ADSize(adWidth, adHeight),posId,this);
        VideoOption option = new VideoOption.Builder()
                .setAutoPlayMuted(true)
                .setAutoPlayPolicy(VideoOption.AutoPlayPolicy.WIFI) // WIFI 环境下可以自动播放视频
                .build();
        mNativeExpressAD.setVideoOption(option);
        // 如果您在平台上新建原生模板广告位时，选择了支持视频，那么可以进行个性化设置（可选）
        mNativeExpressAD.setVideoPlayPolicy(VideoOption.VideoPlayPolicy.AUTO); // 本次拉回的视频广告，从用户的角度看是自动播放的

    }

    private void cacheAd() {
        mNativeExpressAD.loadAD(AD_COUNT);
    }

    private boolean offerNativeUnifiedADData(NativeExpressADView adData) {
        synchronized (adDataLinkedList) {
            return adDataLinkedList.offer(adData);
        }
    }

    public NativeExpressADView pollNativeUnifiedADData() {
        synchronized (adDataLinkedList) {
            Log.d(TAG, "pollNativeUnifiedADData" + adDataLinkedList.size());
            if (adDataLinkedList.size() < AD_COUNT) {
                cacheAd();
            }
            return adDataLinkedList.poll();
        }
    }


    @Override
    public void onNoAD(AdError adError) {
        Log.e(TAG, adError.getErrorMsg());
    }

    @Override
    public void onADLoaded(List<NativeExpressADView> list) {
        for (NativeExpressADView nativeExpressADView: list) {
            if (nativeExpressADView.getBoundData().getAdPatternType() == AdPatternType.NATIVE_VIDEO) {
                nativeExpressADView.preloadVideo();
            }
            offerNativeUnifiedADData(nativeExpressADView);
        }
    }

    @Override
    public void onRenderFail(NativeExpressADView nativeExpressADView) {
        Log.d(TAG, "NativeExpressADView 渲染广告失败");
    }

    @Override
    public void onRenderSuccess(NativeExpressADView nativeExpressADView) {
        Log.d(TAG, "NativeExpressADView 渲染广告成功");
    }

    @Override
    public void onADExposure(NativeExpressADView nativeExpressADView) {
        Log.d(TAG, "NativeExpressADView 广告曝光");
    }

    @Override
    public void onADClicked(NativeExpressADView nativeExpressADView) {
        Log.d(TAG, "NativeExpressADView 广告点击");
    }

    @Override
    public void onADClosed(NativeExpressADView nativeExpressADView) {
        Log.d(TAG, "NativeExpressADView 广告被关闭，将不再显示广告，此时广告对象已经释放资源，不可以再次用来展示了");
    }

    @Override
    public void onADLeftApplication(NativeExpressADView nativeExpressADView) {
        Log.d(TAG, "NativeExpressADView 因为广告点击等原因离开当前 app 时调用");
    }

    @Override
    public void onADOpenOverlay(NativeExpressADView nativeExpressADView) {
        Log.d(TAG, "NativeExpressADView 广告展开遮盖时调用");
    }

    @Override
    public void onADCloseOverlay(NativeExpressADView nativeExpressADView) {
        Log.d(TAG, "NativeExpressADView 广告关闭遮盖时调用");
    }
}
