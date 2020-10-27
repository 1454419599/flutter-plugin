import 'package:flutter/cupertino.dart';

import 'xi_ma_la_ya_model.dart';

class XmPageParam {
  /// 返回第几页，必须大于等于1，不填默认为1
  int get page => _page;
  set page(int value) {
    if (_page != value && page != null && page > 0) {
      _page = value;
    }
  }
  int _page;

  /// 每页多少条，默认20，最多不超过200
  int get count => _count;
  set count(int value) {
    if (_count != value && count != null && count > 0) {
      _count = value;
    }
  }
  int _count;

  XmPageParam({int page, int count}) {
    if (page != null && page > 0)
      _page = page;
    else
      _page = 1;
    if (count != null && count > 0)
      _count = count;
    else
      _count = 20;
  }
}

/// 请求参数 获取专辑标签或者声音标签
class XmTagParam {
  /// 分类ID，指定分类 为0时表示热门分类
  int categoryId;

  /// 指定查询的是专辑标签还是声音标签，0-专辑标签，1-声音标签
  int type;

  XmTagParam({@required this.categoryId, @required this.type});

  Map<String, String> toParam() {
    return {
      "categoryId": categoryId.toString(),
      "type": type.toString(),
    };
  }
}

/// 请求参数 根据分类和标签获取某个分类某个标签下的专辑列表（最火/最新/最多播放）
class XmAlbumListParam extends XmPageParam {
  /// 分类ID，指定分类，为0时表示热门分类
  int categoryId;

  /// 计算维度，现支持最火（1），最新（2），经典或播放最多（3）
  int calcDimension;

  /// 分类下对应的专辑标签，不填则为热门分类
  String tagName;

  XmAlbumListParam({
    @required this.categoryId,
    @required this.calcDimension,
    this.tagName,
    int page,
    int count,
  })  : assert(categoryId != null, "分类ID categoryId 不能为空"),
        super(page: page, count: count);

  Map<String, String> toParam() {
    return {
      "categoryId": categoryId.toString(),
      "calcDimension": calcDimension.toString(),
      if (tagName != null) "tagName": tagName,
      "page": page.toString(),
      "count": count.toString(),
    };
  }
}

/// 请求参数 专辑浏览，根据专辑ID获取专辑下的声音列表
class XmTracksParam extends XmPageParam {
  /// 专辑ID
  int albumId;

  /// "asc"表示喜马拉雅正序，"desc"表示喜马拉雅倒序，"time_asc"表示时间升序，"time_desc"表示时间降序，默认为"asc"
  String sort;

  XmTracksParam({
    @required this.albumId,
    this.sort = "asc",
    int page,
    int count,
  })  : assert(albumId != null, "专辑ID albumId 不能为空"),
        super(page: page, count: count);

  Map<String, String> toParam() {
    return {
      "albumId": albumId.toString(),
      "sort": sort,
      "page": page.toString(),
      "count": count.toString(),
    };
  }
}

/// 请求参数 专辑浏览，根据专辑ID获取专辑下的声音列表
class XmLastPlayTracksParam extends XmPageParam {
  /// 专辑ID
  int albumId;
  /// 声音ID
  int trackId;
  /// "asc"表示喜马拉雅正序，"desc"表示喜马拉雅倒序，默认为"asc"
  String sort;
  ///是否是付费声音 (如果是付费相关的专辑调用此函数需要设置contain_paid 为true)
  bool containsPaid;

  XmLastPlayTracksParam({
    @required this.albumId,
    @required this.trackId,
    @required int count,
    this.sort = "asc",
    this.containsPaid = false,
  })  : assert(albumId != null, "专辑ID albumId 不能为空"),
        assert(trackId != null, "声音ID trackId 不能为空"),
        assert(count != null, "count 不能为空"),
        super(count: count);

  Map<String, dynamic> toParam() {
    return {
      "albumId": albumId.toString(),
      "trackId": trackId.toString(),
      "sort": sort,
      "count": count.toString(),
      "containsPaid": containsPaid,
    };
  }
}

/// 请求参数 获取某个分类的元数据属性键值组合下包含的热门专辑列表/最新专辑列表/最多播放专辑列表。
class XmMetadataAlbumListParam extends XmPageParam {
  /// 分类ID，指定分类，为0时表示热门分类
  int categoryId;

  /// 计算维度，现支持最火（1），最新（2），经典或播放最多（3）
  int calcDimension;

  /// 元数据属性列表：在/metadata/list接口得到的结果中
  List<XmAttributes> metadataAttributes;

  XmMetadataAlbumListParam({
    @required this.categoryId,
    @required this.calcDimension,
    this.metadataAttributes = const [],
    int page,
    int count,
  }) : super(page: page, count: count);

  Map<String, String> toParam() {
    return {
      "categoryId": categoryId.toString(),
      "calcDimension": calcDimension.toString(),
      "metadataAttributes": metadataAttributes
          .map((e) => "${e.attrKey}:${e.attrValue}")
          .join(";"),
      "page": page.toString(),
      "count": count.toString(),
    };
  }
}

class XmPlayListAndPlayParam {
  /// 播放列表中位置
  int index;
  /// 播放列表
  List<XmTrack> playList;

  XmPlayListAndPlayParam({
    this.index = 0,
    @required this.playList,
  });

  Map<String, dynamic> toParam() {
    return {
      "index": index,
      "playList": playList.map((e) => e?.toMap()).toList(),
    };
  }
}

class XmPlayCommonTrackListAndPlayParam {
  /// 播放列表中位置
  int index;
  /// 播放列表
  XmCommonTrackList commonTrackList;

  XmPlayCommonTrackListAndPlayParam({
    this.index = 0,
    @required this.commonTrackList,
  });

  Map<String, dynamic> toParam() {
    return {
      "index": index,
      "commonTrackList": commonTrackList.toMap(),
    };
  }
}
