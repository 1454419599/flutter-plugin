import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum YouLiangHuiNativeAdType {
  native2Image2Text,
  nativeVideo,
  native3Image,
  native1Image2Text,
}

class YouLiangHuiNativeAdData {
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

  YouLiangHuiNativeAdData({
    this.desc,
    this.title,
    this.icon,
    this.image,
    this.imgList,
    this.pictureHeight,
    this.pictureWidth,
    this.appPrice,
    this.appScore,
    this.downloadCount
  });

  static YouLiangHuiNativeAdData fromMap(Map map) {
    return YouLiangHuiNativeAdData(
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

typedef AdEventCallback = void Function(YouLiangHuiNativeAdType nativeAdType, YouLiangHuiNativeAdData nativeAdData, String adButtonText);
typedef AdButtonTextCallback = void Function(String adButtonText);

class YouLiangHuiNativeUnifiedADView extends StatefulWidget {
  final String posId;
  final int mediaViewWidth;
  final int mediaViewHeight;
  final int clickableViewWidth;
  final int clickableViewHeight;
  final int clickableViewTop;
  final int clickableViewLeft;
  final int clickableViewRight;
  final int clickableViewBottom;

  Widget child;
  AdEventCallback adEventCallback;
  AdButtonTextCallback adButtonTextCallback;

  YouLiangHuiNativeUnifiedADView({
    Key key,
    this.child,
    @required this.posId,
    this.mediaViewWidth,
    this.mediaViewHeight,
    this.clickableViewWidth,
    this.clickableViewHeight,
    this.clickableViewTop,
    this.clickableViewLeft,
    this.clickableViewRight,
    this.clickableViewBottom,
    this.adEventCallback,
    this.adButtonTextCallback
  }): super(key: key);

  @override
  YouLiangHuiNativeUnifiedADViewState createState() => YouLiangHuiNativeUnifiedADViewState();
}

class YouLiangHuiNativeUnifiedADViewState extends State<YouLiangHuiNativeUnifiedADView>
    with WidgetsBindingObserver {
  static String channelName = "com.maodouyuedu.youlianghuiplugin/NativeUnifiedAD";
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
    _channel = BasicMessageChannel("${channelName}_$id", StandardMessageCodec());
    _channel.setMessageHandler(_onMessage);
  }

  Future<void> reLoad() => _channel.send("reLoad");
  Future<void> play() => _channel.send("play");
  Future<void> stop() => _channel.send("stop");

  Future<void> _onMessage(dynamic message) {
    print("_onMessage $message");

    if (message["type"] == "AdData") {
      if (widget.adEventCallback != null && message["data"] is Map) {
        YouLiangHuiNativeAdData nativeAdData = YouLiangHuiNativeAdData.fromMap(message["data"]);
        widget.adEventCallback(YouLiangHuiNativeAdType.values[int.parse(message["data"]["type"]) - 1], nativeAdData, message["adButtonText"]);
      }
    } else if (message["type"] == "AdButtonText") {
      if (widget.adButtonTextCallback != null) {
        widget.adButtonTextCallback(message["adButtonText"]);
      }
    } else if (message["type"] == "NoAd") {

    }
  }

  double px2dp(int px) {
    if (px is int)
      return px / MediaQuery.of(context).devicePixelRatio;
    else
      return 0;
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Stack(
//      fit: StackFit.expand,
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
        AndroidView(
          viewType: channelName,
          creationParams: {
            "posId": widget.posId,
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
