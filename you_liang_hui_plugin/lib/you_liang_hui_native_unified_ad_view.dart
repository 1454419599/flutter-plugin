import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

enum YouLiangHuiNativeUnifiedAdType {
  native2Image2Text,
  nativeVideo,
  native3Image,
  native1Image2Text,
}

class YouLiangHuiNativeUnifiedAdData {
  String desc;
  String title;
  String icon;
  String image;
  List<dynamic> imgList;
  int pictureHeight;
  int pictureWidth;
  int appScore;
  int downloadCount;
  dynamic appPrice;

  YouLiangHuiNativeUnifiedAdData({
    this.desc,
    this.title,
    this.icon,
    this.image,
    this.imgList,
    this.pictureHeight,
    this.pictureWidth,
    this.appPrice,
    this.appScore,
    this.downloadCount,
  });

  static YouLiangHuiNativeUnifiedAdData fromMap(Map map) {
    return YouLiangHuiNativeUnifiedAdData(
      desc: map["desc"],
      title: map["title"],
      icon: map["icon"],
      image: map["image"],
      imgList: map["imgList"],
      pictureHeight: map["pictureHeight"],
      pictureWidth: map["pictureWidth"],
      appPrice: map["appPrice"],
      appScore: map["appScore"],
      downloadCount: map["downloadCount"],
    );
  }
}

typedef NativeUnifiedAdEventCallback = void Function(
    YouLiangHuiNativeUnifiedAdType nativeAdType,
    YouLiangHuiNativeUnifiedAdData nativeAdData,
    String adButtonText);
typedef AdButtonTextCallback = void Function(String adButtonText);

class YouLiangHuiNativeUnifiedADView extends StatefulWidget {
  final String posId;
  final double mediaViewTop;
  final double mediaViewLeft;
  final double mediaViewWidth;
  final double mediaViewHeight;
  final double clickableViewWidth;
  final double clickableViewHeight;
  final double clickableViewTop;
  final double clickableViewLeft;
  final double clickableViewRight;
  final double clickableViewBottom;

  final Widget child;
  final NativeUnifiedAdEventCallback adEventCallback;
  final AdButtonTextCallback adButtonTextCallback;

  YouLiangHuiNativeUnifiedADView({
    Key key,
    this.child,
    @required this.posId,
    this.mediaViewTop,
    this.mediaViewLeft,
    this.mediaViewWidth,
    this.mediaViewHeight,
    this.clickableViewWidth,
    this.clickableViewHeight,
    this.clickableViewTop,
    this.clickableViewLeft,
    this.clickableViewRight,
    this.clickableViewBottom,
    this.adEventCallback,
    this.adButtonTextCallback,
  }) : super(key: key);

  @override
  YouLiangHuiNativeUnifiedADViewState createState() =>
      YouLiangHuiNativeUnifiedADViewState();
}

class YouLiangHuiNativeUnifiedADViewState
    extends State<YouLiangHuiNativeUnifiedADView> with WidgetsBindingObserver {
  static String channelName =
      "com.maodouyuedu.youlianghuiplugin/NativeUnifiedAD";
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
  Future<void> disposeAd() => _channel.send("disposeAd");

  Future<dynamic> _onMessage(dynamic message) async {
    print("_onMessage $message");

    if (message["type"] == "AdData") {
      if (widget.adEventCallback != null && message["data"] is Map) {
        YouLiangHuiNativeUnifiedAdData nativeAdData =
            YouLiangHuiNativeUnifiedAdData.fromMap(message["data"]);
        widget.adEventCallback(
            YouLiangHuiNativeUnifiedAdType
                .values[int.parse(message["data"]["type"]) - 1],
            nativeAdData,
            message["adButtonText"]);
      }
    } else if (message["type"] == "AdButtonText") {
      if (widget.adButtonTextCallback != null) {
        widget.adButtonTextCallback(message["adButtonText"]);
      }
    } else if (message["type"] == "NoAd") {
      print("没有广告");
    }
  }

  double px2dp(num px) {
    if (px is int)
      return px / MediaQuery.of(context).devicePixelRatio;
    else
      return 0;
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.clip,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
            px2dp(widget.clickableViewLeft),
            px2dp(widget.clickableViewTop),
            px2dp(widget.clickableViewRight),
            px2dp(widget.clickableViewBottom),
          ),
          child: widget.child,
        ),
        if (Platform.isAndroid)
          AndroidView(
            viewType: channelName,
            creationParams: {
              "posId": widget.posId,
              "mediaViewTop": widget.mediaViewTop.toInt(),
              "mediaViewLeft": widget.mediaViewLeft.toInt(),
              "mediaViewWidth": widget.mediaViewWidth.toInt(),
              "mediaViewHeight": widget.mediaViewHeight.toInt(),
              "clickableViewWidth": widget.clickableViewWidth.toInt(),
              "clickableViewHeight": widget.clickableViewHeight.toInt(),
              "clickableViewTop": widget.clickableViewTop.toInt(),
              "clickableViewLeft": widget.clickableViewLeft.toInt(),
              "clickableViewRight": widget.clickableViewRight.toInt(),
              "clickableViewBottom": widget.clickableViewBottom.toInt(),
            },
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          ),
        if (Platform.isIOS)
          UiKitView(
            viewType: channelName,
            creationParams: {
              "posId": widget.posId,
              "mediaViewTop": widget.mediaViewTop,
              "mediaViewLeft": widget.mediaViewLeft,
              "mediaViewWidth": widget.mediaViewWidth,
              "mediaViewHeight": widget.mediaViewHeight,
              "clickableViewWidth": widget.clickableViewWidth,
              "clickableViewHeight": widget.clickableViewHeight,
              "clickableViewTop": widget.clickableViewTop,
              "clickableViewLeft": widget.clickableViewLeft,
              "clickableViewRight": widget.clickableViewRight,
              "clickableViewBottom": widget.clickableViewBottom,
            },
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          ),
      ],
    );
  }
}
