package com.maodouyuedu.youlianghuiplugin.YouLiangHuiView;

import android.content.Context;

import com.maodouyuedu.youlianghuiplugin.YoulianghuipluginPlugin;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class YouLiangHuiNativeExpressFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    public YouLiangHuiNativeExpressFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int i, Object o) {
        Map<String, Object> params = (Map<String, Object>) o;
//        return new YouLiangHuiNativeExpressView(context, messenger, i, params);
        return new YouLiangHuiNativeExpressView(YoulianghuipluginPlugin.mActivity, messenger, i, params);
    }
}
