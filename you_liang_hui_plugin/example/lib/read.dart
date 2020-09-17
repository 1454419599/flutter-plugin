//import 'dart:isolate';
//import 'dart:math';
//import 'dart:ui' as ui;
//
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter/material.dart';
//import 'package:youlianghuiplugin_example/ad_view.dart';
//
//class MyPoint {
//  double x;
//  double y;
//
//  MyPoint([this.x = 0, this.y = 0]);
//
//  Offset get point => Offset(x, y);
//
//  @override
//  String toString() {
//    return 'x: $x, y:$y';
//  }
//
//  @override
//  bool operator ==(Object other) =>
//      other is MyPoint &&
//          x == other.x &&
//          y == other.y;
//
//  @override
//  bool operator <(Object other) =>
//      other is MyPoint &&
//          x < other.x &&
//          y < other.y;
//
//
//  @override
//  int get hashCode => hashValues(
//    x,
//    y,
//  );
//}
//
//class Read extends StatefulWidget {
//  @override
//  _ReadState createState() => _ReadState();
//}
//
//class _ReadState extends State<Read> {
//  Isolate isolate;
//
//  Animation<Offset> animation;
//  AnimationController animationController;
//
////  PageLayoutAttribute pageLayoutAttribute;
////  ReadPageTheme _readPageTheme;
////  PagingAttribute _pagingAttribute;
//
//  // Offset startOffset;
//  // Offset updateOffset;
//
//  MyPoint initPoint;
//  Offset tapOffset;
//  MyPoint touchStartPoint;
//  Velocity _velocity;
//
//  Duration forwardDuration;
//  Duration backwardDuration;
//
////  TouchLocation touchLocation;
////  AutoFlipOverStatus _autoFlipOverStatus;
////  FlipOverType _flipOverType;
//  bool _isCalcTouchPoint = true;
//
//  int bookId = 13577;
//  int chapterIndex = 2;
//  int currentPage = 1;
////  List<PageAttribute> cachePage = [];
////  List<PageAttribute> showPageData;
////  CacheBookStatus _preCacheBookStatus;
////  CacheBookStatus _nextCacheBookStatus;
////  CacheBookStatus _preCacheChapterStatus;
////  CacheBookStatus _nextCacheChapterStatus;
//
////  BookCatalog bookCatalog;
//  SendPort cacheSendPort;
//
////  final double _bottomHeight = 0;
////  final double _viewWidth = ScreenUtil.screenWidthDp;//默认宽度
////  double _viewHeight = ScreenUtil.screenHeightDp;//默认高度
//
//  var bgImage;
//  Color bgColor;
//
//  _ReadState() {
//    touchStartPoint = initPoint = MyPoint(-1, -1);
//  }
//
//  void _updateTouchPoint(Offset point) {
//    setState(() {
////      double dy = point.dy >= _viewHeight ? _viewHeight - 1 : point.dy;
//      double dy = point.dy;
//      touchStartPoint = MyPoint(point.dx, dy);
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: () {
//        touchStartPoint = MyPoint(tapOffset.dx, tapOffset.dy);
//      },
//      onPanStart: (details) {
//        print(details);
//        _updateTouchPoint(details.globalPosition);
//      },
//      onPanUpdate: (details) {
//        _updateTouchPoint(details.globalPosition);
//      },
//      onPanDown: (details) {
//        print(details);
//        tapOffset = details.globalPosition;
//        touchStartPoint = MyPoint(details.globalPosition.dx, details.globalPosition.dy);
//      },
//      onPanEnd: (details) {
//        print(details);
//      },
//      onPanCancel: () {
//        print("onPanCancel");
//      },
//      child: Stack(
//        children: <Widget>[
//          Container(
//            color: Colors.deepOrange,
//            width: double.infinity,
//            height: double.infinity,
//          ),
//          AdView(
//            viewType: "com.maodouyuedu.youlianghuiplugin/NativeUnifiedAD",
//            touchPoint: touchStartPoint,
//          ),
//        ],
//      ),
//    );
//  }
//}
