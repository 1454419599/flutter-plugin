import 'package:flutter/material.dart';
import 'package:xi_ma_la_ya_plugin/xi_ma_la_ya_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<XmCategory> xmCategory;
  XmCategory selectCategory;

  List<XmTag> xmTags;
  XmTag selectTag;

  List<XmAlbum> xmAlbum;
  XmAlbum selectAlbum;

  List<XmTrack> xmTrack;
  XmTrack selectTrack;

  XmPlayerController xmPlayerController;

//  ValueNotifier<XmPlayerController> xmPlayerController;

  @override
  void initState() {
    xmPlayerController = XmPlayerController();
//    xmPlayerController.addPlayerStatusListener(listener);
//    xmPlayerController = ValueNotifier(XmPlayerController());
    super.initState();
  }

  @override
  void dispose() {
//    xmPlayerController.removePlayerStatusListener(listener);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
//    print(xmPlayerController.value.isPlay);
    print(xmPlayerController.isPlay);
  }

  void _initXiMaLaYa() {
    XiMaLaYaPlugin.initXiMaLaYa(
      packId: "com.maodouyuedu.app",
      appKey: "f3d67d1f7152d4feaa88deee4f2de6bf",
      appSecret: "9f57f699d356523baf85753c688ddc97",
    );
  }

  void listener(XmPlayerEventParam param) {
    print(param);
  }

  void _initPlayerManager() {
    XiMaLaYaPlugin.initPlayerManager();
  }

  void _getCategories() async {
    var result = await XiMaLaYaPlugin.getCategories();
    print(result);
    if ((result?.length ?? 0) > 0) {
      setState(() {
        selectCategory = result[0];
        xmCategory = result;
      });
    }
  }

  void _getTags() async {
    var result = await XiMaLaYaPlugin.getTags(
      XmTagParam(
        categoryId: selectCategory.id,
        type: 0,
      ),
    );
    print(result);
    if ((result?.length ?? 0) > 0) {
      setState(() {
        selectTag = result[0];
        xmTags = result;
      });
    }
  }

  void _getAlbumList() async {
    var result = await XiMaLaYaPlugin.getAlbumList(
      XmAlbumListParam(
        categoryId: selectCategory.id,
        calcDimension: 1,
        tagName: selectTag.tagName,
      ),
    );
    print(result);
    if ((result?.length ?? 0) > 0) {
      setState(() {
        selectAlbum = result[0];
        xmAlbum = result;
      });
    }
  }

  void _getTracks() async {
    var result =
        await XiMaLaYaPlugin.getTracks(XmTracksParam(albumId: selectAlbum.id));
    print(result);
    if ((result?.tracks?.length ?? 0) > 0) {
      setState(() {
        selectTrack = result.tracks[0];
        xmTrack = result.tracks;
      });
    }
  }

  void _getHotTracks() async {
    var result = await XiMaLaYaPlugin.getHotTracks();
    print(result);
  }

  void _getBatchTracks() async {
    var result = await XiMaLaYaPlugin.getBatchTracks();
    print(result);
  }

  void _getMetadataList() async {
    var result = await XiMaLaYaPlugin.getMetadataList(selectCategory.id);
    print(result);
  }

  void _getMetadataAlbumList() async {
    var result = await XiMaLaYaPlugin.getMetadataAlbumList(
        XmMetadataAlbumListParam(categoryId: selectCategory.id, calcDimension: 1));
    print(result);
  }

  void _setPlayListAndPlay() async {
    var result = await xmPlayerController.setPlayListAndPlay(
        XmPlayListAndPlayParam(playList: xmTrack));
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return XmPlayerControllerContainer(
      builder: (context, selector, child) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
//          title: Text(xmPlayerController.isPlay.toString()),
            title: Text(
                XmPlayerControllerModel.of(context)
                    .isPlay
                    .toString()),
          ),
          body: ListView(
            children: [
              Text(XmPlayerControllerModel.of(context).playProgress.toString()),
              RaisedButton(
                onPressed: () {
                  print(XmPlayerControllerModel.of(
                      context)
                      .isPlay);
//                        XmPlayerControllerInheritedStateContainer.of(context).data = XmPlayerControllerInheritedStateContainer.of(context).data+1;
                },
                child: Text("更改"),
              ),
              RaisedButton(
                onPressed: _initXiMaLaYa,
                child: Text("初始化喜马拉雅"),
              ),
              RaisedButton(
                onPressed: _initPlayerManager,
                child: Text("初始化播放器"),
              ),
              RaisedButton(
                onPressed: _getCategories,
                child: Text("获取内容分类"),
              ),
              if (xmCategory != null)
                Wrap(
                  children: [
                    for (var it in xmCategory)
                      ChoiceChip(
                        label: Text(it.categoryName),
                        selected: selectCategory == it,
                        onSelected: (i) => {
                          setState(() {
                            selectCategory = it;
                          })
                        },
                      ),
                  ],
                ),
              RaisedButton(
                onPressed: _getTags,
                child: Text("获取专辑标签或者声音标签"),
              ),
              if (xmTags != null)
                Wrap(
                  children: [
                    for (var it in xmTags)
                      ChoiceChip(
                        label: Text(it.tagName),
                        selected: selectTag == it,
                        onSelected: (i) => {
                          setState(() {
                            selectTag = it;
                          })
                        },
                      ),
                  ],
                ),
              RaisedButton(
                onPressed: _getAlbumList,
                child: Text("获取某个分类某个标签下的专辑列表"),
              ),
              if (xmAlbum != null)
                for (var it in xmAlbum)
                  ListTile(
                    leading: Image.network(it.coverUrlSmall),
                    title: Text(it.albumTitle),
                    subtitle: Text(it.albumTags),
                    selected: selectAlbum == it,
                    onTap: () {
                      setState(() {
                        selectAlbum = it;
                      });
                    },
                  ),
              RaisedButton(
                onPressed: _getTracks,
                child: Text("专辑浏览，根据专辑ID获取专辑下的声音列表"),
              ),
              if (xmTrack != null)
                for (var it in xmTrack)
                  ListTile(
                    leading: Image.network(it.coverUrlSmall),
                    title: Text(it.trackTitle),
                    subtitle: Text(it.trackIntro),
                    selected: selectTrack == it,
                    onTap: () {
                      setState(() {
                        selectTrack = it;
                      });
                      _setPlayListAndPlay();
                    },
                  ),
              RaisedButton(
                onPressed: _getHotTracks,
                child: Text("根据分类和标签获取热门声音列表"),
              ),
              RaisedButton(
                onPressed: _getBatchTracks,
                child: Text("批量获取声音列表"),
              ),
              RaisedButton(
                onPressed: _getMetadataList,
                child: Text("获取某个分类下的元数据列表。"),
              ),
              RaisedButton(
                onPressed: _getMetadataAlbumList,
                child: Text("获取元数据属性键值组合"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
