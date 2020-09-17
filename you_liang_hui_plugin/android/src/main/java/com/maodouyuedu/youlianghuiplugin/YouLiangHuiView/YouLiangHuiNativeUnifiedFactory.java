package com.maodouyuedu.youlianghuiplugin.YouLiangHuiView;

import android.content.Context;

import com.maodouyuedu.youlianghuiplugin.YoulianghuipluginPlugin;

import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class YouLiangHuiNativeUnifiedFactory extends PlatformViewFactory {

    private final String TAG = "YouLiangHuiNativeUnifiedFactory";
    private final BinaryMessenger messenger;

    public YouLiangHuiNativeUnifiedFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int i, Object o) {
        Map<String, Object> params = (Map<String, Object>) o;
        Log.d(TAG, "create:" + context);
//        return new YouLiangHuiNativeUnifiedView(context, messenger, i, params);
        return new YouLiangHuiNativeUnifiedView(YoulianghuipluginPlugin.mActivity, messenger, i, params);
    }
}
