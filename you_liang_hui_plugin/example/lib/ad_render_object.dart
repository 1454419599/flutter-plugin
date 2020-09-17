//import 'dart:math';
//
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/services.dart';
//import 'package:youlianghuiplugin_example/read.dart';
//
//enum _PlatformViewState {
//  uninitialized,
//  resizing,
//  ready,
//}
//
//MyPoint initPoint = MyPoint(-1, -1);
//
//class AdRenderObject extends RenderBox {
//  AndroidViewController _viewController;
//  _PlatformViewState _state = _PlatformViewState.uninitialized;
//  MyPoint _touchPoint;
//  MyPoint a, f, g, e, h, c, j, b, k, d, i;
//
//  Path pathA;
//  Path pathB;
//  Path pathC;
//  Path defaultPathA;
//
//
//  double _viewHeight;
//  double _viewWidth;
//  double _lPathAShadowDis;
//  double _rPathAShadowDis;
//
//  AdRenderObject({
//    @required AndroidViewController viewController,
//    MyPoint touchPoint,
//  }): _viewController = viewController {
//    _touchPoint = touchPoint;
//    a = touchPoint ?? initPoint;
//    init();
//  }
//
//  void init() {
//    _initPoint();
//    if (a != initPoint) {
//      f = _getPointf();
//
//      _calcPointsXY(a, f);
//      _calcPathAShadowDis();
//    }
//
//    pathA = Path();
//    pathB = Path();
//    pathC = Path();
//  }
//
//  MyPoint _getPointf() {
//    MyPoint point;
//    if (a != null && a.y != _viewHeight) {
//      a.y = _viewHeight - 1;
//    }
//    point = MyPoint(_viewWidth, _viewHeight);
//    return point;
//  }
//
//  double _hypot(double w, double h) {
//    return pow(pow(w, 2) + pow(h, 2), 0.5);
//  }
//
//  // 初始关键点
//  void _initPoint() {
//    g = MyPoint();
//    e = MyPoint();
//    h = MyPoint();
//    c = MyPoint();
//    j = MyPoint();
//    b = MyPoint();
//    k = MyPoint();
//    d = MyPoint();
//    i = MyPoint();
//  }
//
//  // 计算各点坐标
//  void _calcPointsXY(MyPoint a, MyPoint f) {
//    if (a == f) {
//      g = f;
//      e = f;
//      h = f;
//      c = f;
//      j = f;
//      b = f;
//      k = f;
//      d = f;
//      i = f;
//      return;
//    }
//    if (a is MyPoint) {
//      if (a.y == 0) {
//        a.y = 1;
//      }
//    }
//
//    g.x = (a.x + f.x) / 2;
//    g.y = (a.y + f.y) / 2;
//
//    e.x = g.x - (f.y - g.y) * (f.y - g.y) / (f.x - g.x);
//    e.y = f.y;
//
//    h.x = f.x;
//    h.y = g.y - (f.x - g.x) * (f.x - g.x) / (f.y - g.y);
//
//    c.x = e.x - (f.x - e.x) / 2;
//    c.y = f.y;
//
//    j.x = f.x;
//    j.y = h.y - (f.y - h.y) / 2;
//
//    b = _getIntersectionPoint(a, e, c, j);
//    k = _getIntersectionPoint(a, h, c, j);
//
//    d.x = (c.x + 2 * e.x + b.x) / 4;
//    d.y = (2 * e.y + c.y + b.y) / 4;
//
//    i.x = (j.x + 2 * h.x + k.x) / 4;
//    i.y = (2 * h.y + j.y + k.y) / 4;
//  }
//
//  void _calcPathAShadowDis() {
//    if (a == e || a == h) {
//      _lPathAShadowDis = 0;
//      _rPathAShadowDis = 0;
//      return;
//    }
//    double lA = a.y-e.y;
//    double lB = e.x-a.x;
//    double lC = a.x*e.y-e.x*a.y;
//    _lPathAShadowDis = ((lA*d.x+lB*d.y+lC) / _hypot(lA, lB)).abs();
//    double rA = a.y-h.y;
//    double rB = h.x-a.x;
//    double rC = a.x*h.y-h.x*a.y;
//    _rPathAShadowDis = ((rA * i.x + rB * i.y + rC) / _hypot(rA, rB)).abs();
//  }
//
//  //得到交点
//  MyPoint _getIntersectionPoint(MyPoint lineOneMypointOne, MyPoint lineOneMyPointTwo, MyPoint lineTwoMyPointOne, MyPoint lineTwoMyPointTwo){
//    double x1,y1,x2,y2,x3,y3,x4,y4;
//    x1 = lineOneMypointOne.x;
//    y1 = lineOneMypointOne.y;
//    x2 = lineOneMyPointTwo.x;
//    y2 = lineOneMyPointTwo.y;
//    x3 = lineTwoMyPointOne.x;
//    y3 = lineTwoMyPointOne.y;
//    x4 = lineTwoMyPointTwo.x;
//    y4 = lineTwoMyPointTwo.y;
//
//    double pointX =((x1 - x2) * (x3 * y4 - x4 * y3) - (x3 - x4) * (x1 * y2 - x2 * y1))
//        / ((x3 - x4) * (y1 - y2) - (x1 - x2) * (y3 - y4));
//    double pointY =((y1 - y2) * (x3 * y4 - x4 * y3) - (x1 * y2 - x2 * y1) * (y3 - y4))
//        / ((y1 - y2) * (x3 - x4) - (x1 - x2) * (y3 - y4));
//
//    return MyPoint(pointX,pointY);
//  }
//
//  //设置触摸点
//  void setTouchPoint(MyPoint currentTouchPoint) {
//    //如果大于0则设置a点坐标重新计算各标识点位置，否则a点坐标不变
//    if(f.x != g.x && _calcPointCX(currentTouchPoint, f) < 0){
//      _calcPointAByTouchPoint();
//      _calcPointsXY(a, f);
//    }
//  }
//
//  //计算C点的X值
//  double _calcPointCX(MyPoint a, MyPoint f) {
//    MyPoint g,e;
//    g = MyPoint();
//    e = MyPoint();
//    g.x = (a.x + f.x) / 2;
//    g.y = (a.y + f.y) / 2;
//
//    e.x = g.x - (f.y - g.y) * (f.y - g.y) / (f.x - g.x);
//    e.y = f.y;
//    return e.x - (f.x - e.x) / 2;
//  }
//
//  // 如果c点x坐标小于0,根据触摸点重新测量a点坐标
//  void _calcPointAByTouchPoint() {
//    double w0 = _viewWidth - c.x;
//
//    double w1 = (f.x - a.x).abs();
//    double w2 = _viewWidth * w1 / w0;
//    a.x = (f.x - w2).abs();
//
//    double h1 = (f.y - a.y).abs();
//    double h2 = w2 * h1 / w1;
//    a.y = (f.y - h2).abs();
//  }
//
//  /// The identity of the backend texture.
//  AndroidViewController get viewController => _viewController;
//  set viewController(AndroidViewController value) {
//    assert(value != null);
//    if (value != _viewController) {
//      _viewController = value;
//      markNeedsPaint();
//      _sizePlatformView();
//    }
//  }
//
//  MyPoint get touchPoint => _touchPoint;
//  set touchPoint(MyPoint value) {
//    assert(value != null);
//    if (value != _touchPoint) {
//      _touchPoint = value;
//      markNeedsPaint();
////      _sizePlatformView();
//    }
//  }
//
//  @override
//  bool get sizedByParent => true;
//
//  @override
//  bool get alwaysNeedsCompositing => false;
//
//  @override
//  bool get isRepaintBoundary => true;
//
//  @override
//  void performResize() {
//    size = constraints.biggest;
//    _sizePlatformView();
//  }
//
//  Size _currentAndroidViewSize;
//
//  Future<void> _sizePlatformView() async {
//    // Android virtual displays cannot have a zero size.
//    // Trying to size it to 0 crashes the app, which was happening when starting the app
//    // with a locked screen (see: https://github.com/flutter/flutter/issues/20456).
//    if (_state == _PlatformViewState.resizing || size.isEmpty) {
//      return;
//    }
//
//    _state = _PlatformViewState.resizing;
//    markNeedsPaint();
//
//    Size targetSize;
//    do {
//      targetSize = size;
//      await _viewController.setSize(targetSize);
//      _currentAndroidViewSize = targetSize;
//      _viewWidth = targetSize.width;
//      _viewHeight = targetSize.height;
//      // We've resized the platform view to targetSize, but it is possible that
//      // while we were resizing the render object's size was changed again.
//      // In that case we will resize the platform view again.
//    } while (size != targetSize);
//
//    _state = _PlatformViewState.ready;
//    markNeedsPaint();
//  }
//
//  @override
//  bool hitTestSelf(Offset position) => true;
//
//  @override
//  void paint(PaintingContext context, Offset offset) {
//    if (_viewController.textureId == null)
//      return;
//    print("------------------- $offset");
//    print("-------------------- $size");
////    context.pushClipRect(true, offset, offset & size, _paintTexture);
//    Path clipPath = Path()
//      ..reset()
//      ..lineTo(size.width / 2, 0)
//      ..lineTo(0, size.height)
//      ..close();
//    print(touchPoint);
//    print(_viewWidth);
//    print(_viewHeight);
//    pathA..reset()
//      ..lineTo(0, _viewHeight)//移动到左下角
//      ..lineTo(c.x,c.y)//移动到c点
//      ..quadraticBezierTo(e.x,e.y,b.x,b.y)//从c到b画贝塞尔曲线，控制点为e
//      ..lineTo(a.x,a.y)//移动到a点
//      ..lineTo(k.x,k.y)//移动到k点
//      ..quadraticBezierTo(h.x,h.y,j.x,j.y)//从k到j画贝塞尔曲线，控制点为h
//      ..lineTo(_viewWidth,0)//移动到右上角
//      ..close();//闭合区域
//    if (touchPoint == initPoint) {
//      context.pushClipPath(true, offset, offset & size, _getDefaultPath(), _paintTexture);
//    } else {
//      context.pushClipPath(true, offset, offset & size, pathA, _paintTexture);
//    }
//
////    _paintTexture(context, offset);
//  }
//
//  void _paintTexture(PaintingContext context, Offset offset) {
//    Paint paint = Paint()..color = Colors.blue..style = PaintingStyle.fill;
//    context.canvas.drawPaint(paint);
////    context.canvas.save();
////    context.canvas.save();
////    context.canvas.clipRect(Rect.fromLTWH(offset.dx, offset.dy, size.width / 3, size.height / 2));
//    context.addLayer(TextureLayer(
//      rect: Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
////      rect: Rect.fromLTWH(offset.dx, offset.dy, 200, 50),
//      textureId: _viewController.textureId,
//    ));
////    context.canvas.clipRect(Rect.fromLTWH(offset.dx, offset.dy, size.width / 3, size.height / 2));
////      context.pushLayer(childLayer, _pushLayer, offset);
////    paint.color = Colors.orangeAccent;
////    context.canvas.drawPaint(paint);
////    context.canvas.restore();
////    context.canvas.restore();
//  }
//
//  //右下角
//  Path getPathAFromLowerRight(){
//    pathA..reset()
//      ..lineTo(0, _viewHeight)//移动到左下角
//      ..lineTo(c.x,c.y)//移动到c点
//      ..quadraticBezierTo(e.x,e.y,b.x,b.y)//从c到b画贝塞尔曲线，控制点为e
//      ..lineTo(a.x,a.y)//移动到a点
//      ..lineTo(k.x,k.y)//移动到k点
//      ..quadraticBezierTo(h.x,h.y,j.x,j.y)//从k到j画贝塞尔曲线，控制点为h
//      ..lineTo(_viewWidth,0)//移动到右上角
//      ..close();//闭合区域
//    return pathA;
//  }
//
//  //左下角
//  Path getPathAFromTopRight(){
//    pathA..reset()
//      ..lineTo(c.x,c.y)//移动到c点
//      ..quadraticBezierTo(e.x,e.y,b.x,b.y)//从c到b画贝塞尔曲线，控制点为e
//      ..lineTo(a.x,a.y)//移动到a点
//      ..lineTo(k.x,k.y)//移动到k点
//      ..quadraticBezierTo(h.x,h.y,j.x,j.y)//从k到j画贝塞尔曲线，控制点为h
//      ..lineTo(_viewWidth, _viewHeight)//移动到右下角
//      ..lineTo(0, _viewHeight)//移动到左下角
//      ..close();
//    return pathA;
//  }
//
//  Path getPathC() {
//    pathC..reset()
//      ..moveTo(i.x,i.y)//移动到i点
//      ..lineTo(d.x,d.y)//移动到d点
//      ..lineTo(b.x,b.y)//移动到b点
//      ..lineTo(a.x,a.y)//移动到a点
//      ..lineTo(k.x,k.y)//移动到k点
//      ..close();//闭合区域
//    return pathC;
//  }
//
//  Path getPathB() {
//    pathB..reset()
//      ..lineTo(0, _viewHeight)
//      ..lineTo(_viewWidth, _viewHeight)
//      ..lineTo(_viewWidth, 0)
//      ..close();
//    return pathB;
//  }
//
//  Path _getDefaultPath() {
//    if (defaultPathA == null) {
//      defaultPathA = Path();
//      defaultPathA..reset()
//        ..lineTo(0, _viewHeight)
//        ..lineTo(_viewWidth, _viewHeight)
//        ..lineTo(_viewWidth, 0)
//        ..close();
//    }
//    return defaultPathA;
//  }
//
//}