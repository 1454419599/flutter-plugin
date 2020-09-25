import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youlianghuiplugin/you_liang_hui_native_unified_ad_view.dart';
import 'dart:async';
import 'dart:io';

import 'package:youlianghuiplugin/youlianghuiplugin.dart';

void main() {
  runApp(MyApp());
}

double adWidth = 160;
double adHeight = 90;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  bool showAd = false;
  bool showIosAd = false;
  // YouLiangHuiNativeAdData nativeAdData;
  String adButtonText;
  int number = 0;
  // GlobalKey<YouLiangHuiNativeUnifiedADViewState> _adKey;
  GlobalKey<YouLiangHuiNativeUnifiedADViewState> _adKey;

  @override
  void initState() {
    super.initState();
//    initPlatformState();
    // _adKey = GlobalKey<YouLiangHuiNativeExpressADViewState>();
    _adKey = GlobalKey<YouLiangHuiNativeUnifiedADViewState>();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await Youlianghuiplugin.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _initYouLiangHui() {
    if (Platform.isAndroid) {
      Youlianghuiplugin.initYouLiangHui(
        "1110153128",
        rewardVideoId: "6071407512248085",
        splashPosId: "2061723943842950",
        nativeExpress: [
          {
            "posId": "6051116957071653",
            "adWidth": adWidth,
            "adHeight": adHeight,
          }
        ],
//        nativeUnifiedIds: ["4091704614425969"]
      );
    } else if (Platform.isIOS) {
      Youlianghuiplugin.initYouLiangHui(
        "1110331335",
        rewardVideoId: "6011734329421185",
        splashPosId: "6041633319427131",
        // nativeExpress: [{
        //   "posId": "6051116957071653",
        //   "adWidth": adWidth,
        //   "adHeight": adHeight,
        // }],
        nativeUnifiedIds: [
          "3031938434285412",
          "4001630464480476",
        ],
      );
    }
  }

  void _showRewardVideoAD() {
    Youlianghuiplugin.showRewardVideoAD(adEventCallback: (event, data) {
      print(event);
      print(data);
    });
  }

  /// 显示开屏广告
  void showSplashAdYouLiangHui({Function closeFun}) {
    Youlianghuiplugin.loadSplashAD(adEventCallback: (event, data) {
      if (event == ADEvent.Load) {
        Youlianghuiplugin.showSplashAD(
          adEventCallback: (event, data) {
            print("aaaaaaaaaaaaaa $event - $data");
            print(event == ADEvent.Close);
            if (event == ADEvent.Close && closeFun != null) {
              print("开屏广告关闭");
              closeFun();
            } else {
              print("Youlianghuiplugin.showSplashAD $event - $data");
            }
          },
        );
      } else if (closeFun != null) {
        print("err开屏广告关闭");
        closeFun();
      }
    });
  }

  void _closeSplashView() {
    Youlianghuiplugin.closeSplashAD();
  }

  void _autoSplashAd() {
    Youlianghuiplugin.autoSplashAd(
      adEventCallback: (event, params) {
        print(event);
        print(params);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build----------");
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.deepOrange,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            RaisedButton(
              child: Text("初始化优量汇"),
              onPressed: _initYouLiangHui,
            ),
            RaisedButton(
              child: Text("显示开屏广告"),
              onPressed: () =>
                  showSplashAdYouLiangHui(closeFun: _closeSplashView),
            ),
            RaisedButton(
              child: Text("自动显示开屏广告"),
              onPressed: _autoSplashAd,
            ),
            RaisedButton(
              child: Text("显示激励视频"),
              onPressed: _showRewardVideoAD,
            ),
            RaisedButton(
              child: Text("显示广告"),
              onPressed: () {
                setState(() {
                  showAd = !showAd;
                });
              },
            ),
            RaisedButton(
              child: Text("刷新广告"),
              onPressed: () {
                _adKey.currentState.reLoad();
              },
            ),
            RaisedButton(
              child: Text("播放广告"),
              onPressed: () {
                _adKey.currentState.play();
              },
            ),
            RaisedButton(
              child: Text("暂停广告"),
              onPressed: () {
                _adKey.currentState.stop();
              },
            ),
            RaisedButton(
              child: Text("setState number: $number"),
              onPressed: () {
                setState(() {
                  number++;
                });
              },
            ),
            if (showAd)
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 10,
                    ),
                    child: SizedBox(
                      width: adWidth,
                      height: adHeight * 2,
                      child: YouLiangHuiNativeUnifiedADView(
                        key: _adKey,
                        posId: "3031938434285412",
                        // posId: "4001630464480476",
                        mediaViewWidth: adWidth,
                        mediaViewHeight: adHeight,
                        adEventCallback:
                            (nativeAdType, nativeAdData, adButtonText) {
                          print("nativeAdData回来了--------------------");
                          print(nativeAdType);
                          print(nativeAdData);
                          print(adButtonText);
                        },
                      ),
                    ),
                  ),
                  Text("data"),
                ],
              ),
//               SizedBox(
//                 width: adWidth,
//                 height: adHeight * 2,
//                 child: YouLiangHuiNativeExpressADView(
//                   key: _adKey,
// //                  posId: "1021618952336342",
//                   posId: "6051116957071653",
// //                  posId: "4031501690347059",
//                   adWidth: adWidth,
//                   adHeight: adHeight,
//                   adEventCallback: (nativeAdData) {
//                     print(nativeAdData);
//                   },
//                 ),
//               ),
          ],
        ),
      ),
    );
  }
}
