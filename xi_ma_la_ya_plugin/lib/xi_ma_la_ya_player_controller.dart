import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:xi_ma_la_ya_plugin/xi_ma_la_ya_model.dart';
import 'package:xi_ma_la_ya_plugin/xi_ma_la_ya_plugin.dart';

enum XmPlayerEvent {
  /// 开始播放
  playStart,

  /// 暂停播放
  playPause,

  /// 停止播放
  playStop,

  /// 播放完成
  soundPlayComplete,

  /// 播放器准备完毕
  soundPrepared,

  /// 切歌
  soundSwitch,

  /// 开始缓冲
  bufferingStart,

  /// 结束缓冲
  bufferingStop,

  /// 缓冲进度回调
  bufferProgress,

  /// 播放进度回调
  playProgress,

  /// 播放器错误
  error,
}

XmPlayerEvent _xmPlayerEventFromString(String string) {
  XmPlayerEvent playerEvent;
  switch (string) {
    case "PLAY_START":
      playerEvent = XmPlayerEvent.playStart;
      break;
    case "PLAY_PAUSE":
      playerEvent = XmPlayerEvent.playPause;
      break;
    case "PLAY_STOP":
      playerEvent = XmPlayerEvent.playStop;
      break;
    case "SOUND_PLAY_COMPLETE":
      playerEvent = XmPlayerEvent.soundPlayComplete;
      break;
    case "SOUND_PREPARED":
      playerEvent = XmPlayerEvent.soundPrepared;
      break;
    case "SOUND_SWITCH":
      playerEvent = XmPlayerEvent.soundSwitch;
      break;
    case "BUFFERING_START":
      playerEvent = XmPlayerEvent.bufferingStart;
      break;
    case "BUFFERING_STOP":
      playerEvent = XmPlayerEvent.bufferingStop;
      break;
    case "BUFFER_PROGRESS":
      playerEvent = XmPlayerEvent.bufferProgress;
      break;
    case "PLAY_PROGRESS":
      playerEvent = XmPlayerEvent.playProgress;
      break;
    case "ERROR":
      playerEvent = XmPlayerEvent.error;
      break;
  }
  return playerEvent;
}

XmPlayerStatus _xmPlayerStatusFromInt(int playStatusIndex) {
  var playStatus = XmPlayerStatus.unknown;
  switch (playStatusIndex) {
    case 0:
      playStatus = XmPlayerStatus.idle;
      break;
    case 1:
      playStatus = XmPlayerStatus.initialized;
      break;
    case 9:
      playStatus = XmPlayerStatus.preparing;
      break;
    case 2:
      playStatus = XmPlayerStatus.prepared;
      break;
    case 3:
      playStatus = XmPlayerStatus.started;
      break;
    case 4:
      playStatus = XmPlayerStatus.stopped;
      break;
    case 5:
      playStatus = XmPlayerStatus.paused;
      break;
    case 6:
      playStatus = XmPlayerStatus.completed;
      break;
    case 7:
      playStatus = XmPlayerStatus.error;
      break;
    case 8:
      playStatus = XmPlayerStatus.end;
      break;
  }
  return playStatus;
}

XmPlayType _xmPlayTypeFromInt(int index) {
  XmPlayType playType = XmPlayType.error;
  switch (index) {
    case 1:
      playType = XmPlayType.none;
      break;
    case 2:
      playType = XmPlayType.track;
      break;
    case 3:
      playType = XmPlayType.radio;
      break;
  }
  return playType;
}

String _fromXmPlayMode(XmPlayMode playMode) {
  var playModeString = "PLAY_MODEL_LIST";
  switch (playMode) {
    case XmPlayMode.single:
      playModeString = "PLAY_MODEL_SINGLE";
      break;
    case XmPlayMode.singleLoop:
      playModeString = "PLAY_MODEL_SINGLE_LOOP";
      break;
    case XmPlayMode.list:
      playModeString = "PLAY_MODEL_LIST";
      break;
    case XmPlayMode.listLoop:
      playModeString = "PLAY_MODEL_LIST_LOOP";
      break;
    case XmPlayMode.random:
      playModeString = "PLAY_MODEL_RANDOM";
      break;
  }
  return playModeString;
}

class XmPlayerEventParam<T> {
  XmPlayerEvent type;
  T data;

  XmPlayerEventParam({
    @required this.type,
    @required this.data,
  });

  XmPlayerEventParam.fromMap(Map map) {
    type = _xmPlayerEventFromString(map["type"]);
    if (type == XmPlayerEvent.playProgress) {
      data = XmPlayProgress.fromMap(map["data"] as Map) as T;
    } else if (type == XmPlayerEvent.soundSwitch) {
      data = XmSoundSwitchData.fromMap(map["data"] as Map) as T;
    } else {
      data = map["data"];
    }
  }

  @override
  String toString() {
    return "type: $type; data: $data";
  }
}

class _XmPlayerNativeMethodParam {
  String method;
  dynamic data;

  _XmPlayerNativeMethodParam(
    this.method, {
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      "method": method,
      if (data != null) "data": data,
    };
  }
}

typedef XmPlayerStatusListener<T> = void Function(XmPlayerEventParam<T> param);

/// 喜马拉雅播放器控制器
class XmPlayerController extends ChangeNotifier {
  static XmPlayerController _controller;

  factory XmPlayerController() {
    if (_controller == null) {
      _controller = XmPlayerController._();
    }
    return _controller;
  }

  XmPlayerController._();

  MethodChannel get _channel => XiMaLaYaPlugin.channel;

  ObserverList<XmPlayerStatusListener> _xmPlayerStatusListeners =
      ObserverList();

  /// 添加播放器状态变化监听
  void addPlayerStatusListener(XmPlayerStatusListener listener) {
    _xmPlayerStatusListeners.add(listener);
  }

  /// 删除播放器状态变化监听
  bool removePlayerStatusListener(XmPlayerStatusListener listener) {
    return _xmPlayerStatusListeners.remove(listener);
  }

  void _notifyPlayerStatusListeners(XmPlayerEventParam param) {
    for (var listener in _xmPlayerStatusListeners)
      try {
        listener(param);
      } catch (e) {
        print(e);
      }
  }

  void onPlayerMethodCallHandler(dynamic arguments) {
    var param = XmPlayerEventParam.fromMap(arguments);
    switch (param.type) {
      case XmPlayerEvent.playStart:
        _setIsPlay(true);
        break;
      case XmPlayerEvent.playStop:
      case XmPlayerEvent.playPause:
        _setIsPlay(false);
        break;
      case XmPlayerEvent.bufferProgress:
        _setBufferProgress(param.data);
        break;
      case XmPlayerEvent.playProgress:
        _setPlayProgress(param.data);
        break;
      case XmPlayerEvent.soundSwitch:
        _setSoundSwitch(param.data);
        break;
      case XmPlayerEvent.soundPlayComplete:
        _listPlayEnd();
        break;
      default:
    }
    _notifyPlayerStatusListeners(param);
  }

  /// 是否正在播放，true 播放 ，false 暂停
  bool get isPlay => _isPlay ?? false;

  void _setIsPlay(bool value) {
    if (_isPlay != value) {
      print("set isPlay 是否正在播放: $value");
      _isPlay = value;
      notifyListeners();
    }
  }

  bool _isPlay;

  /// 缓冲进度
  int get bufferProgress => _bufferProgress ?? 0;

  void _setBufferProgress(int value) {
    if (_bufferProgress != value) {
      _bufferProgress = value;
      notifyListeners();
    }
  }

  int _bufferProgress;

  /// 播放进度
  XmPlayProgress get playProgress => _playProgress;

  void _setPlayProgress(XmPlayProgress value) {
    if (_playProgress != value) {
      _playProgress = value;
      notifyListeners();
    }
  }

  XmPlayProgress _playProgress;
  XmPlayProgress _initialPlayProgress = XmPlayProgress(currPos: 0, duration: 0);

  void _setInitialPlayProgress({bool isNotify = true}) {
    if (_playProgress != _initialPlayProgress) {
      _playProgress = _initialPlayProgress;
      if (isNotify) notifyListeners();
    }
  }

  /// 播放器模式
  XmPlayMode get playMode => _playMode ?? XmPlayMode.list;
  XmPlayMode _playMode;

  /// 当前播放位置
  int get currentPlayIndex => _currentPlayIndex ?? 0;
  int _currentPlayIndex;

  /// 当前播放声音在专辑中的所在位置
  int get currentPlayOrderNum => _currentPlayOrderNum ?? 0;
  int _currentPlayOrderNum;

  /// 当前播放对象数据
  dynamic get currentPlayData => _currentPlayData;
  dynamic _currentPlayData;

  /// 自动播放缓冲回调
  VoidCallback cacheNextXmCommonTrackListCallback;

  void _setSoundSwitch(XmSoundSwitchData data) {
    if (data.curKind == XmPlayableKind.track) {
      var obj = data;
      if (_currentPlayOrderNum != obj.cur.orderNum) {
        _currentPlayOrderNum = obj.cur.orderNum;
        var index = currentPlayList
            .indexWhere((element) => element.orderNum == _currentPlayOrderNum);
        _currentPlayIndex = index < 0 ? 0 : index;
        print("_setSoundSwitch 当前播放声音在专辑中的所在位置: $_currentPlayOrderNum");
        print("_setSoundSwitch 当前播放位置: $_currentPlayIndex");
        _currentPlayData = obj.cur;
        notifyListeners();
        if (currentPlayIndex >= currentPlayList.length - 2)
          cacheNextXmCommonTrackListCallback?.call();
      }
    }
  }

  /// iOS 列表播放完成
  void _listPlayEnd() {
    if (Platform.isIOS) {
      var trackListListIndex = (currentPlayIndex + 1) ~/ pageCount;
      setPlayCommonTrackListAndPlay(
        XmPlayCommonTrackListAndPlayParam(
            commonTrackList: currentXmCommonTrackListList[trackListListIndex]),
      );
    }
  }

  /// 请求声音列表单页条数默认40
  int get pageCount => _pageCount ?? 40;
  set pageCount(int value) {
    if (_pageCount != value && value > 0) {
      _pageCount = value;
      notifyListeners();
    }
  }

  int _pageCount;

  /// 当前播放列表
  List<XmTrack> get currentPlayList => _currentPlayList ?? [];
  List<XmTrack> _currentPlayList;

  /// 当前播放列表对象可能为null
  XmCommonTrackList get currentXmCommonTrackList => _currentXmCommonTrackList;
  XmCommonTrackList _currentXmCommonTrackList;

  /// 当前播放列表对象列表
  List<XmCommonTrackList> get currentXmCommonTrackListList =>
      _currentXmCommonTrackListList ?? [];
  List<XmCommonTrackList> _currentXmCommonTrackListList;

  /// 清除当前播放列表对象列表，一般用在播放新专辑
  void clearCurrentXmCommonTrackListList() {
    _currentXmCommonTrackListList?.clear();
    _currentPlayList?.clear();
  }

  /// 添加播放列表对象至播放列表对象列表
  void addCurrentXmCommonTrackListList(XmCommonTrackList value) {
    if (_currentXmCommonTrackListList == null) {
      _currentXmCommonTrackListList = [];
    }
    int index = 0;
    for (var i = _currentXmCommonTrackListList.length - 1; i >= 0; i--) {
      var cur = _currentXmCommonTrackListList[i].currentPage;
      if (value.currentPage > cur) {
        index = i + 1;
        break;
      } else if (cur == value.currentPage) {
        return;
      }
    }
    _currentXmCommonTrackListList.insert(index, value);
    if (_currentPlayList == null) {
      _currentPlayList = [];
    }
    var ii = index * pageCount;
    ii = ii >= _currentPlayList.length ? _currentPlayList.length : ii;
    _currentPlayList.insertAll(ii, value.tracks);
    notifyListeners();
  }

  /// 设置播放列表对象列表(一般用于目录跳转播放)
  void setCurrentXmCommonTrackListList(List<XmCommonTrackList> list) async {
    if (list == null) return;
    _currentXmCommonTrackListList = list;
    _currentPlayList = [];
    for (var item in list) {
      _currentPlayList.addAll(item.tracks);
    }
    _setInitialPlayProgress(isNotify: false);
    // notifyListeners();
  }

  /// 调用 native 方法--------------------------

  /// 播放
  void play({int index}) {
    _setIsPlay(true);
    _invokeMethod(_XmPlayerNativeMethodParam("play", data: index));
  }

  /// 暂停播放器(如果暂停的时候正在缓冲状态,是暂停不掉的,需要在缓冲结束后(比如开始播放时)才能暂停)
  void pause() {
    _setIsPlay(false);
    _invokeMethod(_XmPlayerNativeMethodParam("pause"));
  }

  ///上一首
  void playPre() {
    _setInitialPlayProgress();
    _invokeMethod(_XmPlayerNativeMethodParam("playPre"));
  }

  ///下一首
  void playNext() {
    _setInitialPlayProgress();
    _invokeMethod(_XmPlayerNativeMethodParam("playNext"));
  }

  /// 设置播放器模式
  void setPlayMode(XmPlayMode value) {
    if (_playMode != value) {
      _playMode = value;
      notifyListeners();
      _invokeMethod(_XmPlayerNativeMethodParam("setPlayMode",
          data: _fromXmPlayMode(value)));
    }
  }

  ///获取播放器状态
  Future<XmPlayerStatus> getPlayerStatus() async {
    var result =
        await _invokeMethod(_XmPlayerNativeMethodParam("getPlayerStatus"));
    return _xmPlayerStatusFromInt(result);
  }

  ///播放器是否正在播放（注意，播放器在缓冲时，虽然没有声音输出，此方法仍然认为播放器正在播放）
  Future<bool> isPlaying() {
    return _invokeMethod(_XmPlayerNativeMethodParam("isPlaying"));
  }

  ///获取正在播放的声音在列表中的位置
  Future<int> getCurrentIndex() {
    return _invokeMethod(_XmPlayerNativeMethodParam("getCurrentIndex"));
  }

  ///是否有上一首
  Future<bool> hasPreSound() {
    return _invokeMethod(_XmPlayerNativeMethodParam("hasPreSound"));
  }

  ///是否有下一首
  Future<bool> hasNextSound() {
    return _invokeMethod(_XmPlayerNativeMethodParam("hasNextSound"));
  }

  ///获取音频时长
  Future<int> getDuration() {
    return _invokeMethod(_XmPlayerNativeMethodParam("getDuration"));
  }

  ///获取当前的播放进度
  Future<int> getPlayCurrPositon() {
    return _invokeMethod(_XmPlayerNativeMethodParam("getPlayCurrPositon"));
  }

  ///按音频时长的比例来拖动
  void seekToByPercent(double percent) {
    _invokeMethod(_XmPlayerNativeMethodParam("seekToByPercent", data: percent));
  }

  ///拖动
  void seekTo(int pos) {
    _invokeMethod(_XmPlayerNativeMethodParam("seekTo", data: pos));
  }

  ///此方法调用的是AudioTrack的音量 调节音量 ,left表示左声道 ,值的范围为 0 - 1 表示AudioTrack最大音量的百分比
  void setVolume(double leftVolume, double rightVolume) {
    _invokeMethod(
      _XmPlayerNativeMethodParam("setVolume", data: {
        "leftVolume": leftVolume,
        "rightVolume": rightVolume,
      }),
    );
  }

  ///获取当前的播放model，可能是track、radio或者schedule中的节目,
  Future getCurrSound() {
    //TODO 未实现 获取当前的播放model
    return _invokeMethod(_XmPlayerNativeMethodParam("getCurrSound"));
  }

  ///获取当前的play类型，分为直播和点播, 点播分为 track以及schedule中的回听 ,
  ///直播分为radio以及schedule中的直播 区分当前的播放进度条是否可以拖动
  Future<XmPlayType> getCurrPlayType() async {
    var result =
        await _invokeMethod(_XmPlayerNativeMethodParam("getCurrPlayType"));
    return _xmPlayTypeFromInt(result);
  }

  ///清除播放器缓存 ,只是清除音频缓存
  void clearPlayCache() {
    _invokeMethod(_XmPlayerNativeMethodParam("clearPlayCache"));
  }

  ///是否正在播放在线资源
  Future<bool> isOnlineSource() {
    return _invokeMethod(_XmPlayerNativeMethodParam("isOnlineSource"));
  }

  ///是否正在播放广告
  Future<bool> isAdsActive() {
    return _invokeMethod(_XmPlayerNativeMethodParam("isAdsActive"));
  }

//  ///更新Track到播放列表,前提是这个track在当前的播放列表中
//  void updateTrackInPlayList() {
//  }

  ///获得当前播放的地址
  Future<String> getCurPlayUrl() {
    return _invokeMethod(_XmPlayerNativeMethodParam("getCurPlayUrl"));
  }

  ///删除某一个音频在当前的播放列表
  void removeListByIndex(int index) {
    _invokeMethod(_XmPlayerNativeMethodParam("removeListByIndex", data: index));
  }

  ///重置播放器(在不需要播放器,并且不是退出应用的情况下使用此函数)
  void resetPlayer() {
    _invokeMethod(_XmPlayerNativeMethodParam("resetPlayer"));
  }

  ///获取播放速率 (setTempo()设置播放速率见 4.18 倍速播放)
  Future<double> getTempo() {
    return _invokeMethod(_XmPlayerNativeMethodParam("getTempo"));
  }

  ///设置播放列表和播放声音的index,并自动播放
  Future<bool> setPlayListAndPlay(XmPlayListAndPlayParam param) async {
    try {
      _setInitialPlayProgress();
      _currentPlayList = param.playList;
      return _invokeMethod(_XmPlayerNativeMethodParam("setPlayListAndPlay",
          data: param.toParam()));
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// 设置播放列表和播放声音的index,并自动播放（可自动加载下一页）
  Future<bool> setPlayCommonTrackListAndPlay(
      XmPlayCommonTrackListAndPlayParam param) async {
    try {
//      _currentPlayList = param.commonTrackList.tracks;
      _currentXmCommonTrackList = param.commonTrackList;
      return _invokeMethod(_XmPlayerNativeMethodParam(
          "setPlayCommonTrackListAndPlay",
          data: param.toParam()));
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// 设置播放列表和播放声音的index
  Future<bool> setPlayCommonTrackList(
      XmPlayCommonTrackListAndPlayParam param) async {
    try {
//      _currentPlayList = param.commonTrackList.tracks;
      _currentXmCommonTrackList = param.commonTrackList;
      return _invokeMethod(_XmPlayerNativeMethodParam("setPlayCommonTrackList",
          data: param.toParam()));
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return false;
    }
  }

//  /// 添加播放列表对象
//  Future<bool> addPlayCommonTrackList(XmCommonTrackList commonTrackList) async {
//    try {
//      print("addPlayCommonTrackList");
//      // _currentPlayList.addAll(commonTrackList.tracks);
//      return _invokeMethod(_XmPlayerNativeMethodParam("addPlayCommonTrackList",
//          data: commonTrackList.toMap()));
//    } on PlatformException catch (e) {
//      throw XiMaLaYaPluginException.platformException(e);
//    } catch (e) {
//      print(e);
//      return false;
//    }
//  }

  /// 添加播放列表到当前播放列表
  Future<bool> addPlayList(List<XmTrack> playList) async {
    try {
      if (_currentPlayList == null) _currentPlayList = [];
      _currentPlayList.addAll(playList);
      return _invokeMethod(_XmPlayerNativeMethodParam("addPlayList",
          data: playList.map((e) => e.toMap()).toList()));
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// 设置播放列表(未自动播放，后续自行调用play播放)
  Future<bool> setPlayList(List<XmTrack> playList) async {
    try {
      _currentPlayList = playList;
      return _invokeMethod(_XmPlayerNativeMethodParam("setPlayList",
          data: playList.map((e) => e.toMap()).toList()));
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// 调用 Native 方法
  Future<R> _invokeMethod<R>(_XmPlayerNativeMethodParam param) {
    return _channel.invokeMethod<R>("playerController", param.toMap());
  }

  @override
  bool operator ==(Object other) {
    return other is XmPlayerController &&
        isPlay == other.isPlay &&
        bufferProgress == other.bufferProgress &&
        playProgress == other.playProgress;
  }

  @override
  int get hashCode => hashValues(isPlay, bufferProgress, playProgress);
}

class XmPlayerControllerModel extends InheritedWidget {
  final XmPlayerController data;

  XmPlayerControllerModel({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  static XmPlayerController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<XmPlayerControllerModel>()
        ?.data;
  }

  //参考MediaQuery,这个方法通常都是这样实现的。如果新的值和旧的值不相等，就需要notify
  @override
  bool updateShouldNotify(XmPlayerControllerModel oldWidget) {
    print("updateShouldNotify ${data != oldWidget.data}");
//    return data != oldWidget.data;
    return true;
  }
}

typedef XmBuilder<T> = Widget Function(
    BuildContext context, T selected, Widget child);
typedef XmSelector<T> = T Function(BuildContext context);

class XmPlayerControllerContainer<T> extends StatefulWidget {
  final XmBuilder<T> builder;
  final XmSelector<T> selector;
  final Widget child;

  XmPlayerControllerContainer({
    Key key,
    this.builder,
    this.selector,
    this.child,
  }) : super(key: key);

  @override
  _XmPlayerControllerContainerState createState() =>
      _XmPlayerControllerContainerState();
}

class _XmPlayerControllerContainerState
    extends State<XmPlayerControllerContainer> {
  XmPlayerController _xmPlayerController;

  @override
  void initState() {
    _xmPlayerController = XmPlayerController();
    _xmPlayerController.addListener(_mSetState);
    super.initState();
  }

  @override
  void dispose() {
    _xmPlayerController.removeListener(_mSetState);
    super.dispose();
  }

  void _mSetState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final selected = widget.selector?.call(context);
    return XmPlayerControllerModel(
      child: Builder(
          builder: (context) =>
              widget.builder?.call(context, selected, widget.child) ??
              widget.child),
      data: XmPlayerController(),
    );
  }
}
