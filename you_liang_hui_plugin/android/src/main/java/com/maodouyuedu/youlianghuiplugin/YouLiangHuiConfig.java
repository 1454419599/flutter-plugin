package com.maodouyuedu.youlianghuiplugin;

import android.renderscript.Sampler;

import java.util.HashMap;
import java.util.Map;

class YouLiangHuiConfig {
    static String APP_ID;
    static String REWARD_VIDEO_ID;
    static String SPLASH_ID;

    final static String showRewardVideoADMethodName = "showRewardVideoAD";
    final static String loadSplashADMethodName = "loadSplashAD";
    final static String showSplashADMethodName = "showSplashAD";
    final static String closeSplashADMethodName = "closeSplashAD";
    final static String autoSplashADMethodName = "autoSplashAD";

    public enum ResponseType {
        SUCCESS,
        ERROR,
    }

    public enum AdStatus {
        Load,    //广告加载成功
        Show,    //激励视频广告页面展示
        Expose, //激励视频广告曝光
        Reward,  //激励视频广告激励发放
        Click,  //激励视频广告被点击
        Complete,   //广告视频素材播放完毕
        Close,  //激励视频广告被关闭
        Error,  //广告流程出错，AdError中包含错误码和错误描述
    }

    static Map responseErrorData(String methodName, String code, String msg, Object detail) {
        Map<String, Object> data = new HashMap<>();
        data.put("code", code);
        data.put("msg", msg);
        data.put("detail", detail);
        return responseData(methodName, ResponseType.ERROR, data);
    }

    static Map responseErrorData(String methodName, int code, String msg, Object detail) {
        return responseErrorData(methodName, String.valueOf(code), msg, detail);
    }

    static Map responseErrorData(String methodName, String code, String msg) {
        return responseErrorData(methodName, code, msg, null);
    }

    static Map responseErrorData(String methodName, int code, String msg) {
        return responseErrorData(methodName, String.valueOf(code), msg, null);
    }

    static Map responseSucccessData(String methodName, Map data) {
        return responseData(methodName, ResponseType.SUCCESS, data);
    }

    static Map responseSucccessData(String methodName, Map<String, Object> data, AdStatus adStatus) {
        if (data == null) {
            data = new HashMap<>();
        }
        data.put("adStatus", adStatus.name());
        return responseData(methodName, ResponseType.SUCCESS, data);
    }

    static Map responseSucccessData(String methodName, AdStatus adStatus) {
        Map<String, Object> data = new HashMap<>();
        data.put("adStatus", adStatus.name());
        return responseData(methodName, ResponseType.SUCCESS, data);
    }

    static Map responseData(String methodName, ResponseType responseType, Object data) {
        Map<String, Object> resultMsg = new HashMap<>();
        resultMsg.put("method", methodName);
        resultMsg.put("type", responseType.name());
        resultMsg.put("data", data);
        return resultMsg;
    }

}
