package com.maodouyuedu.youlianghuiplugin;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.maodouyuedu.youlianghuiplugin.YouLiangHuiView.YouLiangHuiNativeExpressFactory;
import com.maodouyuedu.youlianghuiplugin.YouLiangHuiView.YouLiangHuiNativeUnifiedFactory;
import com.qq.e.ads.nativ.NativeExpressAD;
import com.qq.e.comm.managers.GDTADManager;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMessageCodec;



/** YoulianghuipluginPlugin */
public class YoulianghuipluginPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler, BasicMessageChannel.MessageHandler<Object> {
  private final String TAG = "YoulianghuipluginPlugin";
  public static final String CHANNEL = "youlianghuiplugin";
  public static final String BASIC_MESSAGE_CHANNEL = "YouLiangHuiBasicMessageChannelPlugin";
  public static final String NativeUnifiedViewName = "com.maodouyuedu.youlianghuiplugin/NativeUnifiedAD";
  public static final String NativeExpressViewName = "com.maodouyuedu.youlianghuiplugin/NativeExpressAD";
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  public static BasicMessageChannel<Object> basicMessageChannel;

  public static Application mApplication;
  public static Activity mActivity;
  public static Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    mApplication = (Application) flutterPluginBinding.getApplicationContext();
    BinaryMessenger binaryMessenger = flutterPluginBinding.getBinaryMessenger();
    channel = new MethodChannel(binaryMessenger, CHANNEL);
    channel.setMethodCallHandler(this);
    //初始化BasicMessageChannel
    basicMessageChannel = new BasicMessageChannel<>(binaryMessenger, BASIC_MESSAGE_CHANNEL, StandardMessageCodec.INSTANCE);
    basicMessageChannel.setMessageHandler(this);

//    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(NativeUnifiedViewName,
//            new YouLiangHuiNativeUnifiedFactory(binaryMessenger));
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(NativeExpressViewName,
            new YouLiangHuiNativeExpressFactory(binaryMessenger));
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    context = registrar.context();
    BinaryMessenger binaryMessenger = registrar.messenger();
    YoulianghuipluginPlugin youlianghuipluginPlugin = new YoulianghuipluginPlugin();

    final MethodChannel channel = new MethodChannel(binaryMessenger, CHANNEL);
    channel.setMethodCallHandler(youlianghuipluginPlugin);
    youlianghuipluginPlugin.mApplication = (Application) registrar.context().getApplicationContext();
    youlianghuipluginPlugin.mActivity = registrar.activity();

    basicMessageChannel = new BasicMessageChannel(binaryMessenger, BASIC_MESSAGE_CHANNEL, StandardMessageCodec.INSTANCE);
    basicMessageChannel.setMessageHandler(youlianghuipluginPlugin);

//    registrar.platformViewRegistry().registerViewFactory(NativeUnifiedViewName,
//            new YouLiangHuiNativeUnifiedFactory(binaryMessenger));
      registrar.platformViewRegistry().registerViewFactory(NativeExpressViewName,
          new YouLiangHuiNativeExpressFactory(binaryMessenger));
  }


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Log.d(TAG, "onMethodCall: " + call.method);
    Log.d(TAG, "call.arguments: " + call.arguments);
    Log.d(TAG, "call.arguments: " + ((HashMap)call.arguments).get("nativeExpress"));
    if (call.method.equals("initYouLiangHui")) {
      if (call.arguments instanceof HashMap) {
        try {
          HashMap arguments = (HashMap) call.arguments;

          if (arguments.get("appId") != null) {
            if (arguments.get("appId") instanceof String) {
              YouLiangHuiConfig.APP_ID = (String) arguments.get("appId");
              GDTADManager.getInstance().initWith(context, YouLiangHuiConfig.APP_ID);
              Map<String, Object> resultMsg = new HashMap<>();
              resultMsg.put("msg", "优量汇初始完成");
              result.success(resultMsg);
            } else {
              result.error("-10002", "arguments[appId] 应为 String", call.arguments);
            }
          } else {
            result.error("-10001", "arguments 缺少 appId", call.arguments);
          }

          if (arguments.get("rewardVideoId") != null) {
            if (arguments.get("rewardVideoId") instanceof String) {
              YouLiangHuiConfig.REWARD_VIDEO_ID = (String) arguments.get("rewardVideoId");
            } else {
              result.error("-10004", "arguments[rewardVideoId] 应为 String", call.arguments);
            }
          }

          if (arguments.get("nativeExpress") != null) {
            Log.d(TAG, "nativeExpress: nativeExpress:" + (arguments.get("nativeExpress") instanceof ArrayList));
            if (arguments.get("nativeExpress") instanceof ArrayList) {
              ArrayList<HashMap<String, Object>> arrayList = (ArrayList<HashMap<String, Object>>) arguments.get("nativeExpress");
              for (HashMap<String, Object> map : arrayList) {
                initYouLiangHuiNativeExpressView(map);
              }
            } else {
              result.error("-10005", "arguments[nativeExpress] 应为 List<ArrayList>", call.arguments);
            }
          }

          if (arguments.get("splash") != null) {
            if (arguments.get("splash") instanceof HashMap) {
              HashMap splash = (HashMap) arguments.get("splash");
              YouLiangHuiConfig.SPLASH_ID = (String) splash.get("posId");
            } else {
              result.error("-10006", "arguments[splash] 应为 Map", call.arguments);
            }
          }

//          if (arguments.get("nativeUnifiedIds") != null) {
//            if (arguments.get("nativeUnifiedIds") instanceof ArrayList) {
//              ArrayList<String> arrayList = (ArrayList<String>) arguments.get("nativeUnifiedIds");
//              for (String posId : arrayList) {
//                YouLiangHuiNativeUnifiedAD.getInstance(context, posId);
//              }
//            } else {
//              result.error("-10003", "arguments[nativeUnifiedIds] 应为 List<String>", call.arguments);
//            }
//          }
        } catch (Exception e) {
          result.error("-40000", e.getMessage(), e);
        }
      }
    } else {
      result.notImplemented();
    }
  }

  private void initYouLiangHuiNativeExpressView(HashMap<String, Object> params) {
    double adWidth = 0,adHeight = 0;
    if (params.containsKey("adWidth") && params.get("adWidth") != null) {
      adWidth = (double) params.get("adWidth");
    }
    if (params.containsKey("adHeight") && params.get("adHeight") != null) {
      adHeight = (double) params.get("adHeight");
    }
    Log.d(TAG, "adWidth:" + adWidth);
    Log.d(TAG, "adHeight:" + adHeight);

    if (params.containsKey("posId")) {
      String posId = (String) params.get("posId");
      YouLiangHuiNativeExpressAD.getInstance(mActivity, posId, adWidth, adHeight);
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    basicMessageChannel.setMessageHandler(null);
  }

  @Override
  public void onMessage(@Nullable Object object, @NonNull BasicMessageChannel.Reply<Object> reply) {
    Map map = (Map) object;
    if (map == null) {
      return;
    }
    String method = (String) map.get("method");
    if (method == null) {
      return;
    }
    if (method.equals(YouLiangHuiConfig.showRewardVideoADMethodName)) {
      try {
        String posID = (String) map.get("posId");
        boolean volumeOn = (boolean) map.get("volumeOn");
        posID = posID == null ? YouLiangHuiConfig.REWARD_VIDEO_ID : posID;
        YouLiangHuiRewardVideoAD youLiangHuiRewardVideoAD = YouLiangHuiRewardVideoAD.getInstance(context, posID, volumeOn);
        youLiangHuiRewardVideoAD.showAd();
      } catch (Exception e) {
        basicMessageChannel.send(YouLiangHuiConfig.responseErrorData(YouLiangHuiConfig.showRewardVideoADMethodName, "-40010", e.getMessage(), e));
      }
    } else if (method.equals(YouLiangHuiConfig.loadSplashADMethodName)) {
      try {
        YouLiangHuiSplashAD youLiangHuiSplashAD = YouLiangHuiSplashAD.getInstance(mActivity);
        youLiangHuiSplashAD.loadSplashAD();
      } catch (Exception e) {
        e.printStackTrace();
        basicMessageChannel.send(YouLiangHuiConfig.responseErrorData(YouLiangHuiConfig.loadSplashADMethodName, "-40020", e.getMessage(), e));
      }
    } else if (method.equals(YouLiangHuiConfig.showSplashADMethodName)) {
      try {
        YouLiangHuiSplashAD youLiangHuiSplashAD = YouLiangHuiSplashAD.getInstance(mActivity);
        youLiangHuiSplashAD.showSplashAD();
      } catch (Exception e) {
        e.printStackTrace();
        basicMessageChannel.send(YouLiangHuiConfig.responseErrorData(YouLiangHuiConfig.showSplashADMethodName, "-40021", e.getMessage(), e));
      }
    } else if (method.equals(YouLiangHuiConfig.closeSplashADMethodName)) {
      try {
        if (YouLiangHuiSplashActivity.instance != null) {
          YouLiangHuiSplashActivity.instance.overridePendingTransition(0, 0);
          YouLiangHuiSplashActivity.instance.finish();
        }
      } catch (Exception e) {
        e.printStackTrace();
        basicMessageChannel.send(YouLiangHuiConfig.responseErrorData(YouLiangHuiConfig.closeSplashADMethodName, "-40022", e.getMessage(), e));
      }
    } else if (method.equals(YouLiangHuiConfig.autoSplashADMethodName)) {
      try {
        Log.d(TAG, "autoSplashADMethodName------");
        Intent intent = new Intent();
        intent.setClass(mActivity,YouLiangHuiAutoSplashActivity.class);
        mActivity.startActivity(intent);
        mActivity.overridePendingTransition(0, 0);
      } catch (Exception e) {
        e.printStackTrace();
        basicMessageChannel.send(YouLiangHuiConfig.responseErrorData(YouLiangHuiConfig.autoSplashADMethodName, "-40023", e.getMessage(), e));
      }
    }
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
    mActivity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {

  }

  @Override
  public void onDetachedFromActivity() {
    mActivity = null;
  }
}
