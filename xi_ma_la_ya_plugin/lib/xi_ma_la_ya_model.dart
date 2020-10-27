import 'package:flutter/cupertino.dart';

class XmAttributes {
  /// 用于请求/metadata/album接口的属性键
  String attrKey;

  /// 用于请求/metadata/album接口的属性值，类型是字符串
  String attrValue;

  /// 属性的显示名称
  String displayName;
  List<XmChildMetadata> childMetadatas;

  XmAttributes.fromMap(Map map) {
    attrKey = map["attrKey"];
    attrValue = map["attrValue"];
    displayName = map["displayName"];
    childMetadatas = (map["childMetadatas"] as List)
        ?.map((e) => XmChildMetadata.fromMap(e))
        ?.toList();
  }
}

class XmChildMetadata {
  /// 元数据显示名称
  String displayName;

  /// 固定值"metadata"
  String kind;
  List<XmAttributes> attributes;

  XmChildMetadata.fromMap(Map map) {
    kind = map["kind"];
    displayName = map["displayName"];
    attributes = (map["attributes"] as List)
        ?.map((e) => XmAttributes.fromMap(e))
        ?.toList();
  }
}

class XmMetaData extends XmChildMetadata {
  XmMetaData.fromMap(Map map) : super.fromMap(map);
}

class XmCategory {
  /// 分类ID
  int id;

  /// 固定值"category"
  String kind;

  /// 分类名
  String categoryName;

  /// 分类封面大图
  String coverUrlLarge;

  /// 分类封面中图
  String coverUrlMiddle;

  /// 分类封面小图
  String coverUrlSmall;

  XmCategory({
    this.id,
    this.kind,
    this.categoryName,
    this.coverUrlSmall,
    this.coverUrlMiddle,
    this.coverUrlLarge,
  });

  static XmCategory fromMap(Map map) {
    if (map == null) return null;
    return XmCategory(
      id: map["id"],
      kind: map["kind"],
      categoryName: map["categoryName"],
      coverUrlSmall: map["coverUrlSmall"],
      coverUrlMiddle: map["coverUrlMiddle"],
      coverUrlLarge: map["coverUrlLarge"],
    );
  }
}

class XmTag {
  /// 固定值"tag"
  String kind;

  /// 标签名
  String tagName;

  XmTag({this.kind = "tag", this.tagName});

  static XmTag fromMap(Map map) {
    if (map == null) return null;
    return XmTag(
      kind: map["kind"],
      tagName: map["tagName"],
    );
  }
}

/// 专辑所属主播信息
class XmAnnouncer {
  /// 主播用户ID
  int announcerId;

  /// 固定值"announcer"
  String kind;

  /// 主播分类ID
  int vCategoryId;

  /// 主播用户昵称
  String nickname;

  /// 主播简介
  String vDesc;

  /// 主播签名
  String vSignature;

  /// 主播头像
  String avatarUrl;

  /// 主播定位
  String announcerPosition;

  /// 主播粉丝数
  int followerCount;

  /// 主播关注数
  int followingCount;

  /// 主播发布的专辑数
  int releasedAlbumCount;

  /// 主播发布的声音数
  int releasedTrackCount;

  /// 主播是否加V
  bool isVerified;

  XmAnnouncer(
      {this.announcerId,
      this.kind,
      this.vCategoryId,
      this.nickname,
      this.vDesc,
      this.vSignature,
      this.avatarUrl,
      this.announcerPosition,
      this.followerCount,
      this.followingCount,
      this.releasedAlbumCount,
      this.releasedTrackCount,
      this.isVerified});

  static XmAnnouncer fromMap(Map map) {
    if (map == null) return null;
    return XmAnnouncer(
      announcerId: map["announcerId"],
      kind: map["kind"],
      vCategoryId: map["vCategoryId"],
      nickname: map["nickname"],
      vDesc: map["vDesc"],
      vSignature: map["vSignature"],
      avatarUrl: map["avatarUrl"],
      announcerPosition: map["announcerPosition"],
      followerCount: map["followerCount"],
      followingCount: map["followingCount"],
      releasedAlbumCount: map["releasedAlbumCount"],
      releasedTrackCount: map["releasedTrackCount"],
      isVerified: map["isVerified"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "announcerId": announcerId,
      "kind": kind,
      "vCategoryId": vCategoryId,
      "nickname": nickname,
      "vDesc": vDesc,
      "vSignature": vSignature,
      "avatarUrl": avatarUrl,
      "announcerPosition": announcerPosition,
      "followerCount": followerCount,
      "followingCount": followingCount,
      "releasedAlbumCount": releasedAlbumCount,
      "releasedTrackCount": releasedTrackCount,
      "isVerified": isVerified,
    };
  }
}

/// 专辑中最新上传的一条声音信息
class XmLastUpTrack {
  /// 创建时间，Unix毫秒数时间戳
  int createdAt;

  /// 声音时长，单位秒
  int duration;

  /// 声音ID
  int trackId;

  /// 最后更新时间，Unix毫秒数时间戳
  int updatedAt;

  /// 声音名称
  String trackTitle;

  XmLastUpTrack({
    this.createdAt,
    this.duration,
    this.trackId,
    this.updatedAt,
    this.trackTitle,
  });

  static XmLastUpTrack fromMap(Map map) {
    if (map == null) return null;
    return XmLastUpTrack(
      createdAt: map["createdAt"],
      duration: map["duration"],
      trackId: map["trackId"],
      updatedAt: map["updatedAt"],
      trackTitle: map["trackTitle"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "duration": duration,
      "trackId": trackId,
      "updatedAt": updatedAt,
      "trackTitle": trackTitle,
    };
  }
}

/// 支持的详细价格模型
class XmAlbumPriceTypeDetail {
  /// 折后价
  double discountedPrice;

  /// 原价
  double price;

  /// 1-分集购买，2-整张专辑购买
  int priceType;

  /// 价格单位
  String priceUnit;

  XmAlbumPriceTypeDetail({
    this.discountedPrice,
    this.price,
    this.priceType,
    this.priceUnit,
  });

  static XmAlbumPriceTypeDetail fromMap(Map map) {
    if (map == null) return null;
    return XmAlbumPriceTypeDetail(
      discountedPrice: map["discountedPrice"],
      price: map["price"],
      priceType: map["priceType"],
      priceUnit: map["priceUnit"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "discountedPrice": discountedPrice,
      "price": price,
      "priceType": priceType,
      "priceUnit": priceUnit,
    };
  }
}

/// 专辑
class XmAlbum {
  /// ID
  int id;

  /// 分类ID，为-1时表示分类未知
  int categoryId;

  /// 专辑名称
  String albumTitle;

  /// 专辑标签列表
  String albumTags;

  /// 专辑简介
  String albumIntro;

  /// 专辑封面小，无则返回空字符串””
  String coverUrlSmall;

  /// 专辑封面中，无则返回空字符串””
  String coverUrlMiddle;

  /// 专辑封面大，无则返回空字符串””
  String coverUrlLarge;

  /// 专辑所属主播信息
  XmAnnouncer announcer;

  /// 专辑播放次数
  int playCount;

  /// 专辑喜欢数
  int favoriteCount;

  /// 专辑包含声音数
  int includeTrackCount;

  /// 专辑中最新上传的一条声音信息
  XmLastUpTrack lastUpTrack;

  /// 是否完结，0-无此属性；1-未完结；2-完结
  int isFinished;

  /// 能否下载，true-可下载，false-不可下载
  bool isCanDownload;

  /// 专辑最后更新时间，Unix毫秒数时间戳
  int updatedAt;

  /// 专辑创建时间，Unix毫秒数时间戳
  int createdAt;

  /// 专辑订阅数
  int subscribeCount;

  /// 专辑内声音排序是否自然序，自然序是指先上传的声音在前面，晚上传的声音在后面
  bool isTracksNaturalOrdered;

  /// 是否付费
  bool isPaid;

  /// 预计更新多少集
  int estimatedTrackCount;

  /// 专辑富文本简介
  String albumRichIntro;

  /// 专辑内包含的整条免费听声音总数
  int freeTrackCount;

  /// 专辑内包含的整条免费声音ID列表，英文逗号分隔
  String freeTrackIds;

  /// 营销简介
  String saleIntro;

  /// 对应喜马拉雅APP上的“你将获得”，主要卖点，是由UGC主播提供的富文本
  String expectedRevenue;

  /// 购买须知，富文本
  String buyNotes;

  /// 主讲人自定义标题
  String speakerTitle;

  /// 主讲人自定义标题下的内容
  String speakerContent;

  /// 主讲人介绍
  String speakerIntro;

  /// 是否支持试
  bool isHasSample;

  /// 支持的购买类型，1-只支持分集购买，2-只支持整张专辑购买，3-同时支持分集购买和整张专辑购买
  int composedPriceType;

  /// 支持的详细价格模型列表
  List<XmAlbumPriceTypeDetail> priceTypeInfos;

  /// 付费专辑详情页焦点图，无则返回空字符串””
  String detailBannerUrl;

  /// 专辑评分
  String albumScore;

  /// 是否为会员畅听专辑
  bool isVipFree;

  /// 是否为会员优先听专辑
  bool isVipExclusive;

  static XmAlbum fromMap(Map map) {
    if (map == null) return null;
    return XmAlbum()
      ..id = map["id"]
      ..categoryId = map["categoryId"]
      ..albumTitle = map["albumTitle"]
      ..albumTags = map["albumTags"]
      ..albumIntro = map["albumIntro"]
      ..coverUrlSmall = map["coverUrlSmall"]
      ..coverUrlMiddle = map["coverUrlMiddle"]
      ..coverUrlLarge = map["coverUrlLarge"]
      ..announcer = XmAnnouncer.fromMap(map["announcer"])
      ..playCount = map["playCount"]
      ..favoriteCount = map["favoriteCount"]
      ..includeTrackCount = map["includeTrackCount"]
      ..lastUpTrack = XmLastUpTrack.fromMap(map["lastUpTrack"])
      ..isFinished = map["isFinished"]
      ..isCanDownload = map["isCanDownload"]
      ..updatedAt = map["updatedAt"]
      ..createdAt = map["createdAt"]
      ..subscribeCount = map["subscribeCount"]
      ..isTracksNaturalOrdered = map["isTracksNaturalOrdered"]
      ..isPaid = map["isPaid"]
      ..estimatedTrackCount = map["estimatedTrackCount"]
      ..albumRichIntro = map["albumRichIntro"]
      ..speakerIntro = map["speakerIntro"]
      ..freeTrackIds = map["freeTrackIds"]
      ..saleIntro = map["saleIntro"]
      ..expectedRevenue = map["expectedRevenue"]
      ..buyNotes = map["buyNotes"]
      ..speakerTitle = map["speakerTitle"]
      ..speakerContent = map["speakerContent"]
      ..isHasSample = map["isHasSample"]
      ..composedPriceType = map["composedPriceType"]
      ..priceTypeInfos = (map["priceTypeInfos"] as List)
          ?.map((e) => XmAlbumPriceTypeDetail.fromMap(e))
      ..detailBannerUrl = map["detailBannerUrl"]
      ..albumScore = map["albumScore"]
      ..isVipFree = map["isVipFree"]
      ..isVipExclusive = map["isVipExclusive"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "categoryId": categoryId,
      "albumTitle": albumTitle,
      "albumTags": albumTags,
      "albumIntro": albumIntro,
      "coverUrlSmall": coverUrlSmall,
      "coverUrlMiddle": coverUrlMiddle,
      "coverUrlLarge": coverUrlLarge,
      "announcer": announcer?.toMap(),
      "playCount": playCount,
      "favoriteCount": favoriteCount,
      "includeTrackCount": includeTrackCount,
      "lastUpTrack": lastUpTrack?.toMap(),
      "isFinished": isFinished,
      "isCanDownload": isCanDownload,
      "updatedAt": updatedAt,
      "createdAt": createdAt,
      "subscribeCount": subscribeCount,
      "isTracksNaturalOrdered": isTracksNaturalOrdered,
      "isPaid": isPaid,
      "estimatedTrackCount": estimatedTrackCount,
      "albumRichIntro": albumRichIntro,
      "speakerIntro": speakerIntro,
      "freeTrackIds": freeTrackIds,
      "saleIntro": saleIntro,
      "expectedRevenue": expectedRevenue,
      "buyNotes": buyNotes,
      "speakerTitle": speakerTitle,
      "speakerContent": speakerContent,
      "isHasSample": isHasSample,
      "composedPriceType": composedPriceType,
      "priceTypeInfos": priceTypeInfos?.map((e) => e?.toMap()),
      "detailBannerUrl": detailBannerUrl,
      "albumScore": albumScore,
      "isVipFree": isVipFree,
      "isVipExclusive": isVipExclusive,
    };
  }
}

class XmSubordinatedAlbum {
  int albumId;
  String albumTitle;
  String coverUrlLarge;
  String coverUrlMiddle;
  String coverUrlSmall;

  XmSubordinatedAlbum.fromMap(Map map)
      : albumId = map["albumId"],
        albumTitle = map["albumTitle"],
        coverUrlLarge = map["coverUrlLarge"],
        coverUrlMiddle = map["coverUrlMiddle"],
        coverUrlSmall = map["coverUrlSmall"];

  Map<String, dynamic> toMap() => {
        "albumId": albumId,
        "albumTitle": albumTitle,
        "coverUrlLarge": coverUrlLarge,
        "coverUrlMiddle": coverUrlMiddle,
        "coverUrlSmall": coverUrlSmall,
      };
}

class XmTrack {
  /// 声音ID
  int id;

  /// 固定值"track"
  String kind;

  /// 声音名称
  String trackTitle;

  /// 声音标签列表
  String trackTags;

  /// 声音简介
  String trackIntro;

  /// 声音封面小图
  String coverUrlSmall;

  /// 声音封面中图
  String coverUrlMiddle;

  /// 声音封面大图
  String coverUrlLarge;

  /// 专辑所属主播信息
  XmAnnouncer announcer;

  /// 声音时长，单位秒
  int duration;

  /// 播放数
  int playCount;

  /// 喜欢数
  int favoriteCount;

  /// 评论数
  int commentCount;

  /// 下载次数
  int downloadCount;

  /// 32位声音文件大小
  int playSize32;

  /// 64位声音文件大小
  int playSize64;

  /// 声音m4a格式24位大小
  String playSize24M4a;

  /// 声音m4a格式64位大小
  String playSize64m4a;

  /// 可否下载，true-可下载，false-不可下载
  bool isCanDownload;

  /// 声音下载大小
  int downloadSize;

  /// 一条声音在一个专辑中的位置
  int orderNum;

  /// 该声音所属专辑信息
  XmSubordinatedAlbum album;

  /// 声音来源，1-用户原创，2-用户转采
  int source;

  /// 声音更新时间，Unix毫秒数时间戳
  int updatedAt;

  /// 声音创建时间，Unix毫秒数时间戳
  int createdAt;

  /// 声音amr格式大小
  int playSizeAmr;

  /// 所属专辑的类型id
  int categoryId;

  /// 是否付费，固定值true
  bool isPaid;

  /// 声音是否整条免费听
  bool isFree;

  /// 是否片花，片花声音一定是整条免费听声音
  bool isTrailer;

  /// 是否支持试听
  bool isHasSample;

  /// 试听时长，如果不支持试听则这个试听时长为0
  int sampleDuration;

  /// 是否是部分试听声音
  bool isAudition;

  /// 是否已经购买
  bool isAuthorized;

  /// 判断声音抢先听的状态
  String vipFirstStatus;

  static XmTrack fromMap(Map map) {
    return XmTrack()
      ..id = map["id"]
      ..kind = map["kind"]
      ..trackTitle = map["trackTitle"]
      ..trackTags = map["trackTags"]
      ..trackIntro = map["trackIntro"]
      ..coverUrlSmall = map["coverUrlSmall"]
      ..coverUrlMiddle = map["coverUrlMiddle"]
      ..coverUrlLarge = map["coverUrlLarge"]
      ..announcer = XmAnnouncer.fromMap(map["announcer"])
      ..duration = map["duration"]
      ..playCount = map["playCount"]
      ..favoriteCount = map["favoriteCount"]
      ..commentCount = map["commentCount"]
      ..downloadCount = map["downloadCount"]
      ..playSize32 = map["playSize32"]
      ..playSize64 = map["playSize64"]
      ..playSize24M4a = map["playSize24M4a"]
      ..playSize64m4a = map["playSize64m4a"]
      ..isCanDownload = map["isCanDownload"]
      ..downloadSize = map["downloadSize"]
      ..orderNum = map["orderNum"]
      ..album = XmSubordinatedAlbum.fromMap(map["album"])
      ..source = map["source"]
      ..updatedAt = map["updatedAt"]
      ..createdAt = map["createdAt"]
      ..playSizeAmr = map["playSizeAmr"]
      ..categoryId = map["categoryId"]
      ..isPaid = map["isPaid"]
      ..isFree = map["isFree"]
      ..isTrailer = map["isTrailer"]
      ..isHasSample = map["isHasSample"]
      ..sampleDuration = map["sampleDuration"]
      ..isAudition = map["isAudition"]
      ..isAuthorized = map["isAuthorized"]
      ..vipFirstStatus = map["vipFirstStatus"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "kind": kind,
      "trackTitle": trackTitle,
      "trackTags": trackTags,
      "trackIntro": trackIntro,
      "coverUrlSmall": coverUrlSmall,
      "coverUrlMiddle": coverUrlMiddle,
      "coverUrlLarge": coverUrlLarge,
      "announcer": announcer?.toMap(),
      "duration": duration,
      "playCount": playCount,
      "favoriteCount": favoriteCount,
      "commentCount": commentCount,
      "downloadCount": downloadCount,
      "playSize32": playSize32,
      "playSize64": playSize64,
      "playSize24M4a": playSize24M4a,
      "playSize64m4a": playSize64m4a,
      "isCanDownload": isCanDownload,
      "downloadSize": downloadSize,
      "orderNum": orderNum,
      "album": album?.toMap(),
      "source": source,
      "updatedAt": updatedAt,
      "createdAt": createdAt,
      "playSizeAmr": playSizeAmr,
      "categoryId": categoryId,
      "isPaid": isPaid,
      "isFree": isFree,
      "isTrailer": isTrailer,
      "isHasSample": isHasSample,
      "sampleDuration": sampleDuration,
      "isAudition": isAudition,
      "isAuthorized": isAuthorized,
      "vipFirstStatus": vipFirstStatus,
    };
  }
}

class XmCommonTrackList {
  /// 声音总数
  int totalCount;

  /// 总页数
  int totalPage;

  /// 当前页数
  int currentPage;

  Map<dynamic, dynamic> params;

  /// 当前页声音列表
  List<XmTrack> tracks;

  XmCommonTrackList.fromMap(Map map)
      : totalCount = map["totalCount"],
        totalPage = map["totalPage"],
        currentPage = map["currentPage"],
        params = map["params"],
        tracks = (map["tracks"] as List)
            .map((e) => XmTrack.fromMap(e))
            .toList();

  Map<String, dynamic> toMap() => {
        "totalCount": totalCount,
        "totalPage": totalPage,
        "currentPage": currentPage,
        "params": params,
        "tracks": tracks.map((e) => e.toMap()).toList(),
      };
}

class XmTrackList extends XmCommonTrackList {
  /// 专辑ID
  int albumId;
  /// 专辑名
  String albumTitle;
  /// 分类ID
  int categoryId;
  /// 专辑简介
  String albumIntro;
  /// 大图
  String coverUrlLarge;
  /// 中图
  String coverUrlMiddle;
  /// 小图
  String coverUrlSmall;
  /// 当前页数
  int currentPage;

  XmTrackList.fromMap(Map map)
      : albumId = map["albumId"],
        albumTitle = map["albumTitle"],
        categoryId = map["categoryId"],
        albumIntro = map["albumIntro"],
        coverUrlLarge = map["coverUrlLarge"],
        coverUrlMiddle = map["coverUrlMiddle"],
        coverUrlSmall = map["coverUrlSmall"],
        currentPage = map["currentPage"],
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["albumId"] = albumId;
    map["albumTitle"] = albumTitle;
    map["categoryId"] = categoryId;
    map["albumIntro"] = albumIntro;
    map["coverUrlLarge"] = coverUrlLarge;
    map["coverUrlMiddle"] = coverUrlMiddle;
    map["coverUrlSmall"] = coverUrlSmall;
    map["currentPage"] = currentPage;
    return map;
  }
}

class XmLastPlayTrackList extends XmCommonTrackList {
  /// 分类ID
  int categoryId;
  String tagName;
  /// 当前页数
  int currentPage;

  XmLastPlayTrackList.fromMap(Map map) :
        categoryId = map["categoryId"],
        tagName = map["tagName"],
        currentPage = map["currentPage"],
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["categoryId"] = categoryId;
    map["tagName"] = tagName;
    map["currentPage"] = currentPage;
    return map;
  }
}

class XmPlayProgress {
  int currPos;
  int duration;

  XmPlayProgress({@required this.currPos, @required this.duration});

  XmPlayProgress.fromMap(Map map)
      : this(currPos: map["currPos"], duration: map["duration"]);

  @override
  String toString() {
    return "currPos: $currPos / duration: $duration = ${currPos / duration}";
  }

  @override
  bool operator ==(Object other) {
    return other is XmPlayProgress &&
        currPos == other.currPos &&
        duration == other.duration;
  }

  @override
  int get hashCode => hashValues(currPos, duration);
}

enum XmPlayableKind {
  track,
  paidTrack,
  radio,
  schedule,
  liveFlv,
  tts,
  assistedSleepTrack,
  unknown,
}

class XmSoundSwitchData<T> {
  /// 上一首 kind
  XmPlayableKind lastKind;
  /// 下一首 kind
  XmPlayableKind curKind;

  T last;
  T cur;

  XmSoundSwitchData.fromMap(Map map) {
    lastKind = _xmPlayableKindFromString(map["lastKind"]);
    curKind = _xmPlayableKindFromString(map["curKind"]);
    last = _valueFromMap(map["last"], lastKind);
    cur = _valueFromMap(map["cur"], curKind);
  }

  dynamic _valueFromMap(Map map, XmPlayableKind xmPlayableKind) {
    if (xmPlayableKind == XmPlayableKind.track) {
      return XmTrack.fromMap(map);
    } else {
      return map;
    }
  }

  XmPlayableKind _xmPlayableKindFromString(String value) {
    if (value == "track") {
      return XmPlayableKind.track;
    } else if (value == "paid_track") {
      return XmPlayableKind.paidTrack;
    } else if (value == "radio") {
      return XmPlayableKind.radio;
    } else if (value == "schedule") {
      return XmPlayableKind.schedule;
    } else if (value == "live_flv") {
      return XmPlayableKind.liveFlv;
    } else if (value == "tts") {
      return XmPlayableKind.tts;
    } else if (value == "assisted_sleep_track") {
      return XmPlayableKind.assistedSleepTrack;
    } else {
      return XmPlayableKind.unknown;
    }
  }
}

/// 播放器播放模式
enum XmPlayMode {
  /// 单曲播放
  single,

  /// 单曲循环播放
  singleLoop,

  /// 列表播放
  list,

  /// 列表循环
  listLoop,

  /// 随机播放
  random,
}

/// 播放器状态
enum XmPlayerStatus {
  ///未知状态
  unknown,

  ///播放器空闲状态
  idle,

  ///播放器已经初始化了
  initialized,

  ///播放器准备完成
  prepared,

  ///播放器准备中
  preparing,

  ///播放器开始播放
  started,

  ///播放器停止
  stopped,

  ///播放器暂停
  paused,

  ///播放器单曲播放完成
  completed,

  ///播放器错误
  error,

  ///播放器被释放
  end,
}

///play类型
enum XmPlayType {
  ///失败，出错，未匹配
  error,

  /// 当前没有声音
  none,

  /// 点播类型
  track,

  /// 直播类型
  radio,
}
