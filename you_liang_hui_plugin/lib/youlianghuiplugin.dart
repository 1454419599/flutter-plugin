import 'dart:async';

import 'package:flutter/services.dart';

//export './you_liang_hui_native_unified_ad_view.dart';
export './you_liang_hui_native_express_ad_view.dart';

enum ADEvent {
  ///广告加载成功
  Load,

  ///广告页面展示
  Show,

  ///广告曝光
  Expose,

  ///激励视频广告激励发放
  Reward,

  ///广告被点击
  Click,

  ///广告视频素材播放完毕
  Complete,

  ///广告被关闭
  Close,

  ///广告流程出错，AdError中包含错误码和错误描述
  Error,

  ///未知数据
  Unknown
}

typedef AdEventCallback = void Function(ADEvent event, Map params);

class Youlianghuiplugin {
  static const basicMessageChannelName = "YouLiangHuiBasicMessageChannelPlugin";
  static const MethodChannel _channel =
      const MethodChannel('youlianghuiplugin');
  static const BasicMessageChannel _basicMessageChannel =
      const BasicMessageChannel(
          basicMessageChannelName, StandardMessageCodec());
  static const String _showRewardVideoADMethodName = "showRewardVideoAD";
  static const String _loadSplashADMethodName = "loadSplashAD";
  static const String _showSplashADMethodName = "showSplashAD";
  static const String _closeSplashADMethodName = "closeSplashAD";
  static const String _autoSplashADMethodName = "autoSplashAD";
  static AdEventCallback _rewardVideoADEventCallback;
  static AdEventCallback _loadSplashADEventCallback;
  static AdEventCallback _showSplashADEventCallback;
  static AdEventCallback _autoSplashADEventCallback;
  static void initYouLiangHui(
    String appId, {
    String rewardVideoId,
    String splashPosId,
//      List<String> nativeUnifiedIds,
    List<Map<String, dynamic>> nativeExpress,
  }) {
    _channel.invokeMethod("initYouLiangHui", {
      "appId": appId,
      "rewardVideoId": rewardVideoId,
//      "nativeUnifiedIds": nativeUnifiedIds,
      "nativeExpress": nativeExpress,
      "splash": {"posId": splashPosId}
    });
    _basicMessageChannel.setMessageHandler(messageHandler);
  }

  static void showRewardVideoAD(
      {String posId, bool volumeOn = true, AdEventCallback adEventCallback}) {
    _rewardVideoADEventCallback = adEventCallback;
    _basicMessageChannel.send({
      "method": _showRewardVideoADMethodName,
      "posId": posId,
      "volumeOn": volumeOn
    });
  }

  static void loadSplashAD({AdEventCallback adEventCallback}) {
    _loadSplashADEventCallback = adEventCallback;
    _basicMessageChannel.send({
      "method": _loadSplashADMethodName,
    });
  }

  static void showSplashAD({AdEventCallback adEventCallback}) {
    _showSplashADEventCallback = adEventCallback;
    _basicMessageChannel.send({
      "method": _showSplashADMethodName,
    });
  }

  static void closeSplashAD() {
    print("flutter closeSplashAD");
    _basicMessageChannel.send({
      "method": _closeSplashADMethodName,
    });
  }

  static void autoSplashAd({AdEventCallback adEventCallback}) {
    _autoSplashADEventCallback = adEventCallback;
    _basicMessageChannel.send({
      "method": _autoSplashADMethodName,
    });
  }

  static Future<void> messageHandler(dynamic message) async {
    String methodName = message["method"];
    String type = message["type"];
    dynamic data = message["data"];
    if (methodName == _showRewardVideoADMethodName &&
        _rewardVideoADEventCallback != null) {
      if (type == "SUCCESS") {
        ADEvent rewardADEvent = ADEvent.Unknown;
        if (data is Map) {
          String adStatus = data["adStatus"];
          switch (adStatus) {
            case "Load":
              rewardADEvent = ADEvent.Load;
              break;
            case "Show":
              rewardADEvent = ADEvent.Show;
              break;
            case "Expose":
              rewardADEvent = ADEvent.Expose;
              break;
            case "Reward":
              rewardADEvent = ADEvent.Reward;
              break;
            case "Click":
              rewardADEvent = ADEvent.Click;
              break;
            case "Complete":
              rewardADEvent = ADEvent.Complete;
              break;
            case "Close":
              rewardADEvent = ADEvent.Close;
              break;
          }
        }
        _rewardVideoADEventCallback(rewardADEvent, data);
      } else if (type == "ERROR") {
        _rewardVideoADEventCallback(ADEvent.Error, data);
      }
    } else if (methodName == _loadSplashADMethodName &&
        _loadSplashADEventCallback != null) {
      if (data is Map) {
        ADEvent adEvent = ADEvent.Unknown;
        String adStatus = data["adStatus"];
        switch (adStatus) {
          case "Load":
            adEvent = ADEvent.Load;
            break;
          case "Error":
            adEvent = ADEvent.Show;
            break;
          default:
            break;
        }
        _loadSplashADEventCallback(adEvent, data);
      }
    } else if (methodName == _showSplashADMethodName &&
        _showSplashADEventCallback != null) {
      if (data is Map) {
        ADEvent adEvent = ADEvent.Unknown;
        String adStatus = data["adStatus"];
        switch (adStatus) {
          case "Click":
            adEvent = ADEvent.Click;
            break;
          case "Close":
            adEvent = ADEvent.Close;
            break;
          case "Expose":
            adEvent = ADEvent.Expose;
            break;
          case "Show":
            adEvent = ADEvent.Show;
            break;
          default:
            break;
        }
        _showSplashADEventCallback(adEvent, data);
      }
    }else if (methodName == _autoSplashADMethodName &&
        _autoSplashADEventCallback != null) {
      if (data is Map) {
        ADEvent adEvent = ADEvent.Unknown;
        String adStatus = data["adStatus"];
        switch (adStatus) {
          case "Close":
            adEvent = ADEvent.Close;
            break;
          default:
            break;
        }
        _autoSplashADEventCallback(adEvent, data);
      }
    }
  }
}
