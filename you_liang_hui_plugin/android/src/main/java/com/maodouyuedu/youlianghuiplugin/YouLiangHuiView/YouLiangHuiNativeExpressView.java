package com.maodouyuedu.youlianghuiplugin.YouLiangHuiView;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.maodouyuedu.youlianghuiplugin.YouLiangHuiNativeExpressAD;
import com.maodouyuedu.youlianghuiplugin.YoulianghuipluginPlugin;
import com.qq.e.ads.nativ.NativeExpressADView;
import com.qq.e.ads.nativ.NativeExpressMediaListener;
import com.qq.e.comm.constants.AdPatternType;
import com.qq.e.comm.pi.AdData;
import com.qq.e.comm.util.AdError;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;

public class YouLiangHuiNativeExpressView implements PlatformView, BasicMessageChannel.MessageHandler {
    private String TAG = "YouLiangHuiNativeExpressView";

    private Context mContext;
    private final BasicMessageChannel<Object> basicMessageChannel;

    private final FrameLayout mAdContainer; // 展示广告的广告位
    private NativeExpressADView nativeExpressADView;

    private double adWidth;
    private double adHeight;
    private String posId;

    YouLiangHuiNativeExpressView(Context context, BinaryMessenger messenger, final int id, Map<String, Object> params) {
        mContext = context;
        mAdContainer = new FrameLayout(mContext);
        basicMessageChannel = new BasicMessageChannel<>(messenger, YoulianghuipluginPlugin.NativeExpressViewName + "_" + id, StandardMessageCodec.INSTANCE);
        basicMessageChannel.setMessageHandler(this);

        if (params.containsKey("adWidth") && params.get("adWidth") != null) {
            adWidth = (double) params.get("adWidth");
        }
        if (params.containsKey("adHeight") && params.get("adHeight") != null) {
            adHeight = (double) params.get("adHeight");
        }
        Log.d(TAG, "adWidth:" + adWidth);
        Log.d(TAG, "adHeight:" + adHeight);

        if (params.containsKey("posId")) {
            posId = (String) params.get("posId");
            nativeExpressADView = YouLiangHuiNativeExpressAD.getInstance(mContext, posId, adWidth, adHeight).pollNativeUnifiedADData();
            initAd();
        }
    }

    @Override
    public View getView() {
        return mAdContainer;
    }

    @Override
    public void dispose() {
        if (nativeExpressADView != null) {
            Log.d(TAG, "nativeExpressADView destroyAD");
            nativeExpressADView.destroy();
        }
    }

    private void initAd() {
        if (nativeExpressADView == null) {
            return;
        }
        if (nativeExpressADView.getBoundData().getAdPatternType() == AdPatternType.NATIVE_VIDEO) {
            nativeExpressADView.setMediaListener(mediaListener);
        }
        nativeExpressADView.render();
        sendAd2Dart(nativeExpressADView.getBoundData(), YouLiangHuiNativeUnifiedView.AdDataType.AdData);
        if (mAdContainer.getChildCount() > 0) {
            mAdContainer.removeAllViews();
        }
        // 需要保证 View 被绘制的时候是可见的，否则将无法产生曝光和收益。
        mAdContainer.addView(nativeExpressADView);
    }

    private NativeExpressMediaListener mediaListener = new NativeExpressMediaListener() {
        @Override
        public void onVideoInit(NativeExpressADView nativeExpressADView) {
            Log.d(TAG, "onVideoInit: ");
        }

        @Override
        public void onVideoLoading(NativeExpressADView nativeExpressADView) {
            Log.d(TAG, "onVideoLoading");
        }

        @Override
        public void onVideoCached(NativeExpressADView nativeExpressADView) {
            Log.d(TAG, "onVideoCached");
        }

        @Override
        public void onVideoReady(NativeExpressADView nativeExpressADView, long l) {
            Log.d(TAG, "onVideoReady");
        }

        @Override
        public void onVideoStart(NativeExpressADView nativeExpressADView) {
            Log.d(TAG, "onVideoStart: ");
        }

        @Override
        public void onVideoPause(NativeExpressADView nativeExpressADView) {
            Log.d(TAG, "onVideoPause: ");
        }

        @Override
        public void onVideoComplete(NativeExpressADView nativeExpressADView) {
            Log.d(TAG, "onVideoComplete: ");
        }

        @Override
        public void onVideoError(NativeExpressADView nativeExpressADView, AdError adError) {
            Log.d(TAG, "onVideoError");
        }

        @Override
        public void onVideoPageOpen(NativeExpressADView nativeExpressADView) {
            Log.d(TAG, "onVideoPageOpen");
        }

        @Override
        public void onVideoPageClose(NativeExpressADView nativeExpressADView) {
            Log.d(TAG, "onVideoPageClose");
        }
    };

    private void sendAd2Dart(AdData adData, YouLiangHuiNativeUnifiedView.AdDataType type) {
        if (basicMessageChannel != null) {
            Map<String, Object> result = new HashMap<>();
            result.put("type", type.name());
            if (type == YouLiangHuiNativeUnifiedView.AdDataType.AdData) {
                Map<String, Object> data = new HashMap<>();
                data.put("title", adData.getTitle());
                data.put("desc", adData.getDesc());
                result.put("data", data);
            }
            basicMessageChannel.send(result);
        }
    }

    @Override
    public void onMessage(@Nullable Object o, @NonNull BasicMessageChannel.Reply reply) {
        if (o instanceof String) {
            switch ((String) o) {
                case "reLoad":
                    if (nativeExpressADView != null) {
                        nativeExpressADView.destroy();
                    }
                    if (posId != null) {
                        nativeExpressADView = YouLiangHuiNativeExpressAD.getInstance(mContext, posId, adWidth, adHeight).pollNativeUnifiedADData();
                        initAd();
                    }
                    break;
            }
        }
    }
}
