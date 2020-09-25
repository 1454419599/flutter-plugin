import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YouLiangHuiNativeExpressAdData {
  String desc;
  String title;

  YouLiangHuiNativeExpressAdData({this.desc, this.title});

  static YouLiangHuiNativeExpressAdData fromMap(Map map) {
    return YouLiangHuiNativeExpressAdData(
        desc: map["desc"], title: map["title"]);
  }
}

typedef NativeExpressAdEventCallback = void Function(
    YouLiangHuiNativeExpressAdData nativeAdData);

class YouLiangHuiNativeExpressADView extends StatefulWidget {
  ///模板1.0广告位Id
  final String posId;

  ///广告宽dp
  final double adWidth;

  ///广告高dp
  final double adHeight;

//  Widget child;
  final NativeExpressAdEventCallback adEventCallback;

  YouLiangHuiNativeExpressADView({
    Key key,
//    this.child,
    @required this.posId,
    this.adWidth,
    this.adHeight,
    this.adEventCallback,
  }) : super(key: key);

  @override
  YouLiangHuiNativeExpressADViewState createState() =>
      YouLiangHuiNativeExpressADViewState();
}

class YouLiangHuiNativeExpressADViewState
    extends State<YouLiangHuiNativeExpressADView> with WidgetsBindingObserver {
  static String channelName =
      "com.maodouyuedu.youlianghuiplugin/NativeExpressAD";
  BasicMessageChannel _channel;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _channel?.send("onResumed");
    }
    super.didChangeAppLifecycleState(state);
  }

  void _onPlatformViewCreated(int id) {
    _channel =
        BasicMessageChannel("${channelName}_$id", StandardMessageCodec());
    _channel.setMessageHandler(_onMessage);
  }

  Future<void> reLoad() => _channel.send("reLoad");
  Future<void> play() => _channel.send("play");
  Future<void> stop() => _channel.send("stop");

  Future<void> _onMessage(dynamic message) {
    print("_onMessage $message");

    if (message["type"] == "AdData") {
      if (widget.adEventCallback != null && message["data"] is Map) {
        YouLiangHuiNativeExpressAdData nativeAdData =
            YouLiangHuiNativeExpressAdData.fromMap(message["data"]);
        widget.adEventCallback(nativeAdData);
      }
    } else if (message["type"] == "NoAd") {}
  }

  double px2dp(num px) {
    if (px is num)
      return px / MediaQuery.of(context).devicePixelRatio;
    else
      return 0;
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return SizedBox(
      width: widget.adWidth,
      height: widget.adHeight,
      child: AndroidView(
        viewType: channelName,
        creationParams: {
          "posId": widget.posId,
          "adWidth": widget.adWidth,
          "adHeight": widget.adHeight,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      ),
    );
  }
}
