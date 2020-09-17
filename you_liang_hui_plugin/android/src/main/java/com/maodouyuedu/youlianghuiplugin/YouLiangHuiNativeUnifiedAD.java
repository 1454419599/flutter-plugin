package com.maodouyuedu.youlianghuiplugin;

import android.content.Context;
import android.util.Log;

import com.qq.e.ads.cfg.VideoOption;
import com.qq.e.ads.nativ.NativeADUnifiedListener;
import com.qq.e.ads.nativ.NativeUnifiedAD;
import com.qq.e.ads.nativ.NativeUnifiedADData;
import com.qq.e.comm.util.AdError;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class YouLiangHuiNativeUnifiedAD implements NativeADUnifiedListener {
    private String TAG = "NativeADContainer";
    private static final byte[] lock = new byte[0]; // 特殊的instance变量
    //    private static YouLiangHuiNativeUnifiedAD youLiangHuiRewardVideoAD;
    private static Map<String, YouLiangHuiNativeUnifiedAD> youLiangHuiRewardVideoADMap = new HashMap<>();
    private LinkedList<NativeUnifiedADData> adDataLinkedList = new LinkedList();
    private NativeUnifiedAD mAdManager;
    private int AD_COUNT = 3;

    public static YouLiangHuiNativeUnifiedAD getInstance(final Context context, String posId) {
        synchronized (lock) {
            if (youLiangHuiRewardVideoADMap.get(posId) == null) {
                YouLiangHuiNativeUnifiedAD youLiangHuiRewardVideoAD = new YouLiangHuiNativeUnifiedAD(context, posId);
                youLiangHuiRewardVideoAD.cacheAd();
                youLiangHuiRewardVideoADMap.put(posId, youLiangHuiRewardVideoAD);
            }
            return youLiangHuiRewardVideoADMap.get(posId);
        }
    }

    private YouLiangHuiNativeUnifiedAD(Context context, String posId) {
        mAdManager = new NativeUnifiedAD(context, posId,this);

        mAdManager.setMaxVideoDuration(60);
        mAdManager.setVideoPlayPolicy(VideoOption.VideoPlayPolicy.AUTO); // 本次拉回的视频广告，从用户的角度看是自动播放的
        mAdManager.setVideoADContainerRender(VideoOption.VideoADContainerRender.SDK); // 视频播放前，用户看到的广告容器是由SDK渲染的
    }

    private void cacheAd() {
        mAdManager.loadData(AD_COUNT);
    }

    private boolean offerNativeUnifiedADData(NativeUnifiedADData adData) {
        synchronized (adDataLinkedList) {
            return adDataLinkedList.offer(adData);
        }
    }

    public NativeUnifiedADData pollNativeUnifiedADData() {
        synchronized (adDataLinkedList) {
            Log.d(TAG, "pollNativeUnifiedADData" + adDataLinkedList.size());
            if (adDataLinkedList.size() < AD_COUNT) {
                cacheAd();
            }
            return adDataLinkedList.poll();
        }
    }

    @Override
    public void onADLoaded(List<NativeUnifiedADData> list) {
        for (NativeUnifiedADData adData : list) {
            offerNativeUnifiedADData(adData);
        }
    }

    @Override
    public void onNoAD(AdError adError) {
        Log.d(TAG, "onNoAd error code: " + adError.getErrorCode() + ", error msg: " + adError.getErrorMsg());
    }
}
