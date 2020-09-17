package com.maodouyuedu.youlianghuiplugin.YouLiangHuiView;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewParent;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.maodouyuedu.youlianghuiplugin.YouLiangHuiNativeUnifiedAD;
import com.maodouyuedu.youlianghuiplugin.YoulianghuipluginPlugin;
import com.qq.e.ads.cfg.MultiProcessFlag;
import com.qq.e.ads.cfg.VideoOption;
import com.qq.e.ads.nativ.MediaView;
import com.qq.e.ads.nativ.NativeADEventListener;
import com.qq.e.ads.nativ.NativeADMediaListener;
import com.qq.e.ads.nativ.NativeADUnifiedListener;
import com.qq.e.ads.nativ.NativeUnifiedAD;
import com.qq.e.ads.nativ.NativeUnifiedADData;
import com.qq.e.ads.nativ.VideoPreloadListener;
import com.qq.e.ads.nativ.widget.NativeAdContainer;
import com.qq.e.comm.constants.AdPatternType;
import com.qq.e.comm.util.AdError;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;

import static android.view.View.VISIBLE;


public class YouLiangHuiNativeUnifiedView implements PlatformView, BasicMessageChannel.MessageHandler {
    private String TAG = "YouLiangHuiNativeUnifiedView";

    private final BasicMessageChannel<Object> basicMessageChannel;
    private final Context mContext;
    private NativeUnifiedADData nativeUnifiedADData;
    public Handler mHandler;

    private final FrameLayout nativeAdContainerBox;
    private final NativeAdContainer nativeAdContainer;
    private final MediaView mediaView;
    private final View clickableView;
    private final ImageView imagePoster;

    private int mediaViewWidth;
    private int mediaViewHeight;
    private int clickableViewWidth;
    private int clickableViewHeight;
    private int clickableViewTop;
    private int clickableViewLeft;
    private int clickableViewRight;
    private int clickableViewBottom;
    private String posId;


    enum AdDataType {
        AdData,
        AdButtonText,
        NoAd
    }

    YouLiangHuiNativeUnifiedView(Context context, BinaryMessenger messenger, final int id, Map<String, Object> params) {
        mContext = context;
//        Log.d(TAG, "Activity:" + (context));
//        Log.d(TAG, "Activity:" + (context.getApplicationContext()));
//        Log.d(TAG, "mApplication:" + YoulianghuipluginPlugin.mApplication);
//        Log.d(TAG, "Activity:" + ((FlutterApplication)mContext).getCurrentActivity());
//        ((FlutterApplication)mContext).getCurrentActivity().getWindow().setFlags(
////        ((Activity)mContext).getWindow().setFlags(
//                WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
//                WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED);
//        MultiProcessFlag.setMultiProcess(true);
        basicMessageChannel = new BasicMessageChannel<>(messenger, YoulianghuipluginPlugin.NativeUnifiedViewName + "_" + id, StandardMessageCodec.INSTANCE);
        basicMessageChannel.setMessageHandler(this);
        nativeAdContainerBox = new FrameLayout(mContext);
        nativeAdContainer = new NativeAdContainer(mContext);
        mediaView = new MediaView(mContext);
        imagePoster = new ImageView(mContext);
        clickableView = new View(mContext);
        setNativeAdContainerLayout();
        imagePoster.setScaleType(ImageView.ScaleType.FIT_CENTER);
        nativeAdContainer.addView(clickableView);
        nativeAdContainer.addView(imagePoster);
        nativeAdContainer.addView(mediaView);
//        nativeAdContainerBox.addView(nativeAdContainer);
//        nativeAdContainer.setVisibility(View.GONE);
        if (params != null) {
            if (params.containsKey("mediaViewWidth") && params.get("mediaViewWidth") != null) {
                mediaViewWidth = (int) params.get("mediaViewWidth");
            }
            if (params.containsKey("mediaViewHeight") && params.get("mediaViewHeight") != null) {
                mediaViewHeight = (int) params.get("mediaViewHeight");
            }
            if (params.containsKey("clickableViewWidth") && params.get("clickableViewWidth") != null) {
                clickableViewWidth = (int) params.get("clickableViewWidth");
            }
            if (params.containsKey("clickableViewHeight") && params.get("clickableViewHeight") != null) {
                clickableViewHeight = (int) params.get("clickableViewHeight");
            }
            if (params.containsKey("clickableViewTop") && params.get("clickableViewTop") != null) {
                clickableViewTop = (int) params.get("clickableViewTop");
            }
            if (params.containsKey("clickableViewLeft") && params.get("clickableViewLeft") != null) {
                clickableViewLeft = (int) params.get("clickableViewLeft");
            }
            if (params.containsKey("clickableViewRight") && params.get("clickableViewRight") != null) {
                clickableViewRight = (int) params.get("clickableViewRight");
            }
            if (params.containsKey("clickableViewBottom") && params.get("clickableViewBottom") != null) {
                clickableViewBottom = (int) params.get("clickableViewBottom");
            }
            if (params.containsKey("posId")) {
                posId = (String) params.get("posId");
                nativeUnifiedADData = YouLiangHuiNativeUnifiedAD.getInstance(mContext, posId).pollNativeUnifiedADData();
//                initAd();
                initHandler();

//                showAd();
            } else {
                nativeUnifiedADData = null;
            }
        } else {
            nativeUnifiedADData = null;
        }
    }

//    private void getAd() {
//        NativeUnifiedAD mAdManager = new NativeUnifiedAD(mContext, posId,this);
//        mAdManager.setMaxVideoDuration(60);
//        mAdManager.setVideoPlayPolicy(VideoOption.VideoPlayPolicy.AUTO); // 本次拉回的视频广告，从用户的角度看是自动播放的
//        mAdManager.setVideoADContainerRender(VideoOption.VideoADContainerRender.SDK); // 视频播放前，用户看到的广告容器是由SDK渲染的
//        mAdManager.loadData(3);
//    }

    @SuppressLint("HandlerLeak")
    private void initHandler() {
        mHandler = new Handler() {
            @Override
            public void handleMessage(@NonNull Message msg) {
                super.handleMessage(msg);
                Log.d(TAG, "handleMessage");
//                showAd();
                initAd();
            }
        };
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(2000);
                    mHandler.sendEmptyMessage(102);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private void showAd() {
        setNativeAdContainerLayout();
        nativeUnifiedADData.preloadVideo(new VideoPreloadListener() {
            @Override
            public void onVideoCached() {
//                nativeAdContainer.setVisibility(VISIBLE);
//                nativeAdContainerBox.addView(nativeAdContainer);
                Log.d(TAG, "onVideoCached");
                Log.d(TAG, "onVideoCached-VISIBLE:" + VISIBLE);
                Log.d(TAG, "onVideoCached-isShown:" + nativeAdContainer.isShown());
                Log.d(TAG, "onVideoCached-getVisibility:" + nativeAdContainer.getVisibility());
                Log.d(TAG, "onVideoCached-getGlobalVisibleRect:" + nativeAdContainer.getGlobalVisibleRect(new Rect()));
                Log.d(TAG, "onVideoCached-getLocalVisibleRect:" + nativeAdContainer.getLocalVisibleRect(new Rect()));
                View viewParent = nativeAdContainer;
                do {
                    Log.d(TAG, "viewParent-getVisibility:" + viewParent.getVisibility());
                    ViewParent parent = viewParent.getParent();
                    Log.d(TAG, "viewParent- (parent == null) false:" +  (parent == null));
                    Log.d(TAG, "viewParent- (!(parent instanceof View)) true:" +  (!(parent instanceof View)));
                    try {
                        viewParent = (View) parent;
                    } catch (Exception e) {
                        viewParent = null;
                        Log.e(TAG, String.valueOf(e));
                    }
                } while (viewParent != null);
                initAd();
//                mediaView.performClick();
            }

            @Override
            public void onVideoCacheFailed(int i, String s) {

            }
        });
    }

    private void initAd() {
        Log.d(TAG, "onVideoCached-isShown:" + nativeAdContainer.isShown());
        Log.d(TAG, "onVideoCached-getVisibility:" + nativeAdContainer.getVisibility());
        Log.d(TAG, "onVideoCached-getGlobalVisibleRect:" + nativeAdContainer.getGlobalVisibleRect(new Rect()));
        Log.d(TAG, "onVideoCached-getLocalVisibleRect:" + nativeAdContainer.getLocalVisibleRect(new Rect()));
        Log.d(TAG, "mediaView.isHardwareAccelerated----:" + mediaView.isHardwareAccelerated());
        Log.d(TAG, "imagePoster.isHardwareAccelerated----:" + imagePoster.isHardwareAccelerated());
        if (nativeUnifiedADData == null) {
            Log.d(TAG, "initAd: nativeUnifiedADData == null");
            sendAd2Dart(null, AdDataType.NoAd);
            return;
        }
        sendAd2Dart(nativeUnifiedADData, AdDataType.AdData);

        setClickableViewLayout();
        setMediaViewLayout();
        setImagePosterLayout();

        List<View> clickableViews = new ArrayList<>();
        clickableViews.add(clickableView);

        nativeUnifiedADData.bindAdToView(mContext, nativeAdContainer, null, clickableViews);

        int patternType = nativeUnifiedADData.getAdPatternType();
        Log.d(TAG, "initAd: " + patternType);
        if (patternType == AdPatternType.NATIVE_1IMAGE_2TEXT
//            || patternType == AdPatternType.NATIVE_VIDEO
            || patternType == AdPatternType.NATIVE_2IMAGE_2TEXT) {
            Log.d(TAG, "initAd: " + nativeUnifiedADData.getImgUrl());
            imagePoster.setVisibility(VISIBLE);
            clickableViews.add(imagePoster);
//            nativeAdContainer.addView(imagePoster);
            Picasso.with(mContext).load(nativeUnifiedADData.getImgUrl()).into(imagePoster);
        }

        if (patternType == AdPatternType.NATIVE_VIDEO) {
//            imagePoster.setVisibility(View.GONE);
//            mediaView.setVisibility(VISIBLE);
//            nativeAdContainer.addView(mediaView);

            // 视频广告需对MediaView进行绑定，MediaView必须为容器mContainer的子View
            nativeUnifiedADData.bindMediaView(mediaView, new VideoOption.Builder()
                            .setAutoPlayMuted(true)
                            .setAutoPlayPolicy(VideoOption.AutoPlayPolicy.WIFI)
                            .build(),
                    // 视频相关回调
                    new NativeADMediaListener() {
                        @Override
                        public void onVideoInit() {
                            Log.d(TAG, "onVideoInit: ");
                        }

                        @Override
                        public void onVideoLoading() {
                            Log.d(TAG, "onVideoLoading: ");
                        }

                        @Override
                        public void onVideoReady() {
                            Log.d(TAG, "onVideoReady: ");
                        }

                        @Override
                        public void onVideoLoaded(int videoDuration) {
                            Log.d(TAG, "onVideoLoaded: ");
                            Log.d(TAG, "nativeUnifiedADData.getAdPatternType-->:" + nativeUnifiedADData.getAdPatternType());
//                            nativeUnifiedADData.startVideo();
                            Log.d(TAG, "onVideoCached");
                            Log.d(TAG, "onVideoCached-VISIBLE:" + VISIBLE);
                            Log.d(TAG, "onVideoCached-isShown:" + nativeAdContainer.isShown());
                            Log.d(TAG, "onVideoCached-getVisibility:" + nativeAdContainer.getVisibility());
                            Log.d(TAG, "onVideoCached-getGlobalVisibleRect:" + nativeAdContainer.getGlobalVisibleRect(new Rect()));
                            Log.d(TAG, "onVideoCached-getLocalVisibleRect:" + nativeAdContainer.getLocalVisibleRect(new Rect()));
                            View viewParent = nativeAdContainer;
                            do {
                                Log.d(TAG, "viewParent-getVisibility:" + viewParent.getVisibility());
                                ViewParent parent = viewParent.getParent();
                                Log.d(TAG, "viewParent- (parent == null) false:" +  (parent == null));
                                Log.d(TAG, "viewParent- (!(parent instanceof View)) true:" +  (!(parent instanceof View)));
                                try {
                                    viewParent = (View) parent;
                                } catch (Exception e) {
                                    viewParent = null;
                                    Log.e(TAG, String.valueOf(e));
                                }
                            } while (viewParent != null);
//                            nativeAdContainerBox.addView(nativeAdContainer);
                        }

                        @Override
                        public void onVideoStart() {
                            Log.d(TAG, "onVideoStart: ");
                            Log.d(TAG, "mediaView.isHardwareAccelerated----:" + mediaView.isHardwareAccelerated());
                            Log.d(TAG, "imagePoster.isHardwareAccelerated----:" + imagePoster.isHardwareAccelerated());
                        }

                        @Override
                        public void onVideoPause() {
                            Log.d(TAG, "onVideoPause: ");
                        }

                        @Override
                        public void onVideoResume() {
                            Log.d(TAG, "onVideoResume: ");
                        }

                        @Override
                        public void onVideoCompleted() {
                            Log.d(TAG, "onVideoCompleted: ");
                        }

                        @Override
                        public void onVideoError(AdError error) {
                            Log.e(TAG, "onVideoError: " + error.getErrorMsg());
                        }

                        @Override
                        public void onVideoStop() {
                            Log.d(TAG, "onVideoStop: ");
                        }

                        @Override
                        public void onVideoClicked() {
                            Log.d(TAG, "onVideoClicked: ");
                        }
                    });
        }

        clickableView.setVisibility(VISIBLE);

        nativeUnifiedADData.setNativeAdEventListener(new NativeADEventListener() {
            @Override
            public void onADExposed() {
                Log.d(TAG, "广告曝光");
            }

            @Override
            public void onADClicked() {
                Log.d(TAG, "广告被点击");
            }

            @Override
            public void onADError(AdError error) {
                Log.d(TAG, "错误回调 error code :" + error.getErrorCode()
                        + "  error msg: " + error.getErrorMsg());
            }

            @Override
            public void onADStatusChanged() {
                Log.d(TAG, "广告状态变化");
                sendAd2Dart(nativeUnifiedADData, AdDataType.AdButtonText);
            }
        });
    }

//    private void setNativeAdContainerLayout() {
//        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(1080, -2);
//        nativeAdContainerBox.setLayoutParams(lp);
//        nativeAdContainerBox.setBackgroundColor(Color.BLUE);
//        nativeAdContainerBox.setVisibility(VISIBLE);
//    }

    private void setNativeAdContainerLayout() {
        int width = 1000, height = 1000;
        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(width, height);
        nativeAdContainer.setLayoutParams(lp);
    }

    private void setClickableViewLayout() {
        int width, height;
        if (clickableViewWidth != 0) {
            width = clickableViewWidth;
        } else {
            width = LinearLayout.LayoutParams.MATCH_PARENT;
        }
        if (clickableViewHeight != 0) {
            height = clickableViewHeight;
        } else {
            height = LinearLayout.LayoutParams.MATCH_PARENT;
        }
        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(width, height);
        lp.setMargins(clickableViewLeft, clickableViewTop, clickableViewRight, clickableViewBottom);
        clickableView.setLayoutParams(lp);
//        clickableView.setBackgroundColor(Color.RED);
    }

    private void setMediaViewLayout() {
        int width = -1, height = -2;
        if ( nativeUnifiedADData.getAdPatternType() == AdPatternType.NATIVE_VIDEO) {
            if (mediaViewWidth != 0) {
                width = mediaViewWidth;
            } else {
                width = LinearLayout.LayoutParams.MATCH_PARENT;
            }
            if (mediaViewHeight != 0) {
                height = mediaViewHeight;
            } else {
                height = LinearLayout.LayoutParams.WRAP_CONTENT;
            }
        }
        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(width, height);
        mediaView.setLayoutParams(lp);
    }

    private void setImagePosterLayout() {
        int width = -1, height = -2;
        int patternType = nativeUnifiedADData.getAdPatternType();
        if (patternType == AdPatternType.NATIVE_1IMAGE_2TEXT
            || patternType == AdPatternType.NATIVE_VIDEO
            || patternType == AdPatternType.NATIVE_2IMAGE_2TEXT) {
            if (mediaViewWidth != 0) {
                width = mediaViewWidth;
            } else {
                width = LinearLayout.LayoutParams.MATCH_PARENT;
            }
            if (mediaViewHeight != 0) {
                height = mediaViewHeight;
            } else {
                height = LinearLayout.LayoutParams.WRAP_CONTENT;
            }
        }
        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(width, height);
        imagePoster.setLayoutParams(lp);
    }

    private void sendAd2Dart(NativeUnifiedADData nativeUnifiedADData, AdDataType type) {
        if (basicMessageChannel != null) {
            Map<String, Object> result = new HashMap<>();
            result.put("type", type.name());
            if (type == AdDataType.AdData) {
                Map<String, Object> data = new HashMap<>();
                data.put("type", nativeUnifiedADData.getAdPatternType() + "");
                data.put("image", nativeUnifiedADData.getImgUrl());
                data.put("title", nativeUnifiedADData.getTitle());
                data.put("desc", nativeUnifiedADData.getDesc());
                data.put("icon", nativeUnifiedADData.getIconUrl());
                data.put("imgList", nativeUnifiedADData.getImgList());
                data.put("downloadCount", nativeUnifiedADData.getDownloadCount());
                data.put("appScore", nativeUnifiedADData.getAppScore());
                data.put("appPrice", nativeUnifiedADData.getAppPrice());
                data.put("pictureWidth", nativeUnifiedADData.getPictureWidth());
                data.put("pictureHeight", nativeUnifiedADData.getPictureHeight());
                result.put("data", data);
            }
            if (type != AdDataType.NoAd) {
                result.put("adButtonText", updateAdAction(nativeUnifiedADData));
            }
            basicMessageChannel.send(result);
        }
    }

    private static String updateAdAction(NativeUnifiedADData ad) {
        String text;
        if (!ad.isAppAd()) {
            text = "浏览";
            return text;
        }
        switch (ad.getAppStatus()) {
            case 0:
                text = "下载";
                break;
            case 1:
                text = "启动";
                break;
            case 2:
                text = "更新";
                break;
            case 4:
                text = ad.getProgress() + "%";
                break;
            case 8:
                text = "安装";
                break;
            case 16:
                text = "下载失败，重新下载";
                break;
            default:
                text = "浏览";
                break;
        }
        return text;

    }

    @Override
    public View getView() {
        return nativeAdContainerBox;
//        return nativeAdContainer;
    }

    @Override
    public void dispose() {
        if (basicMessageChannel != null) {
            basicMessageChannel.setMessageHandler(null);
        }
        if (nativeUnifiedADData != null) {
            nativeUnifiedADData.destroy();
        }
    }

    @Override
    public void onMessage(@Nullable Object o, @NonNull BasicMessageChannel.Reply reply) {
        if (o instanceof String) {
            switch ((String) o) {
                case "onResumed":
                    if (nativeUnifiedADData != null) {
                        nativeUnifiedADData.resume();
                    }
                    break;
                case "reLoad":
                    if (nativeUnifiedADData != null) {
                        nativeUnifiedADData.destroy();
                    }
                    if (posId != null) {
                        nativeUnifiedADData = YouLiangHuiNativeUnifiedAD.getInstance(mContext, posId).pollNativeUnifiedADData();
//                        nativeAdContainer.removeView(imagePoster);
//                        nativeAdContainer.removeView(mediaView);
//                        nativeAdContainer.removeView(clickableView);
                        initAd();
//                        showAd();
//                        initHandler();
                    }
                    break;
                case "play":
                    nativeUnifiedADData.startVideo();
                    break;
                case "stop":
                    nativeUnifiedADData.pauseVideo();
                    break;
            }
        }
    }
}
