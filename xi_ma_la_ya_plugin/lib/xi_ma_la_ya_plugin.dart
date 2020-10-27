import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:xi_ma_la_ya_plugin/xi_ma_la_ya_player_controller.dart';
import 'xi_ma_la_ya_model.dart';
import 'xi_ma_la_ya_plugin_request_param.dart';

export 'xi_ma_la_ya_plugin_request_param.dart';
export 'xi_ma_la_ya_model.dart';
export 'xi_ma_la_ya_player_controller.dart';

class XiMaLaYaPlugin {
  static const String _initXiMaLaYaMethodName = "initXiMaLaYa";
  static const String _initPlayerManagerMethodName = "initPlayerManager";
  static const String _getCategoriesMethodName = "getCategories";
  static const String _getTagsMethodName = "getTags";
  static const String _getAlbumListMethodName = "getAlbumList";
  static const String _getTracksMethodName = "getTracks";
  static const String _getHotTracksMethodName = "getHotTracks";
  static const String _getBatchTracksMethodName = "getBatchTracks";
  static const String _getMetadataListMethodName = "getMetadataList";
  static const String _getMetadataAlbumListMethodName = "getMetadataAlbumList";
  static const String _getLastPlayTracksMethodName = "getLastPlayTracks";
  static const String _getBatchMethodName = "getBatch";

//  static const String _setPlayListMethodName = "setPlayList";
//  static const String _addPlayListMethodName = "addPlayList";
//  static const String _setPlayListAndPlayMethodName = "setPlayListAndPlay";

  static const MethodChannel _channel =
      const MethodChannel('xi_ma_la_ya_plugin');

  static MethodChannel get channel => _channel;

  /// 初始化喜马拉雅
  static Future initXiMaLaYa({
    @required String appKey,
    @required String packId,
    @required String appSecret,
  }) {
    _channel.setMethodCallHandler(onMethodCall);
    return _channel.invokeMethod(_initXiMaLaYaMethodName, {
      "appKey": appKey,
      "packId": packId,
      "appSecret": appSecret,
    });
  }

  static Future<dynamic> onMethodCall(MethodCall call) async {
    switch (call.method) {
      case "playerController":
        XmPlayerController().onPlayerMethodCallHandler(call.arguments);
        break;
    }
  }

  /// 初始化喜马拉雅播放器
  static Future initPlayerManager() {
    return _channel.invokeMethod(_initPlayerManagerMethodName);
  }

  /// 获取内容分类
  static Future<List<XmCategory>> getCategories() async {
    try {
      var result = await _channel.invokeMethod<List>(_getCategoriesMethodName);
      return result?.map((e) => XmCategory.fromMap(e))?.toList();
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// 获取专辑标签或者声音标签
  static Future<List<XmTag>> getTags(XmTagParam param) async {
    try {
      var result = await _channel.invokeMethod<List>(
          _getTagsMethodName, param.toParam());
      return result?.map((e) => XmTag.fromMap(e))?.toList();
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// 根据分类和标签获取某个分类某个标签下的专辑列表（最火/最新/最多播放）
  static Future<List<XmAlbum>> getAlbumList(XmAlbumListParam param) async {
    try {
      var result = await _channel.invokeMethod<List>(
          _getAlbumListMethodName, param.toParam());
      return result?.map((e) => XmAlbum.fromMap(e))?.toList();
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// 专辑浏览，根据专辑ID获取专辑下的声音列表
  static Future<XmTrackList> getTracks(XmTracksParam param) async {
    try {
      var result = await _channel.invokeMethod(
        _getTracksMethodName,
        param.toParam(),
      );
//      return result?.map((e) => XmTrack.fromMap(e))?.toList();
      return XmTrackList.fromMap(result);
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// 批量获取专辑列表
  /// [ids] 专辑ID列表，比如[1000,1010] 最大ID数量为200个，超过200的ID将忽略
  static Future<List<XmAlbum>> getBatch(List<int> ids) async {
    try {
      var result = await _channel.invokeMethod(
        _getBatchMethodName,
        {"ids": ids?.join(",")},
      );
      return (result as List)?.map((e) => XmAlbum.fromMap(e))?.toList();
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// 根据上一次所听声音的id，获取此声音所在那一页的声音
  static Future<XmLastPlayTrackList> getLastPlayTracks(
      XmLastPlayTracksParam param) async {
    try {
      var result = await _channel.invokeMethod(
        _getLastPlayTracksMethodName,
        param.toParam(),
      );
      return XmLastPlayTrackList.fromMap(result);
    } on PlatformException catch (e) {
      throw XiMaLaYaPluginException.platformException(e);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future getHotTracks() {
    return _channel.invokeMethod(_getHotTracksMethodName);
  }

  static Future getBatchTracks() {
    return _channel.invokeMethod(_getBatchTracksMethodName);
  }

  /// 获取某个分类下的元数据列表。
  static Future<List<XmMetaData>> getMetadataList(int categoryId) async {
    try {
      var result =
          await _channel.invokeMethod<List>(_getMetadataListMethodName, {
        "categoryId": categoryId.toString(),
      });
      return result?.map((e) => XmMetaData.fromMap(e))?.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// 获取某个分类的元数据属性键值组合下包含的热门专辑列表/最新专辑列表/最多播放专辑列表。
  static Future<List<XmAlbum>> getMetadataAlbumList(
      XmMetadataAlbumListParam param) async {
    try {
      var result = await _channel.invokeMethod<List>(
          _getMetadataAlbumListMethodName, param.toParam());
      return result?.map((e) => XmAlbum.fromMap(e))?.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class XiMaLaYaPluginException implements Exception {
  XiMaLaYaPluginException(this.code, this.description);

  XiMaLaYaPluginException.platformException(PlatformException e)
      : code = e.code,
        description = e.message;

  String code;
  String description;

  @override
  String toString() => '$runtimeType($code, $description)';
}
