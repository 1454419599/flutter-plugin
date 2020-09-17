//import 'package:flutter/rendering.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter/widgets.dart';
//import 'package:youlianghuiplugin_example/ad_render_object.dart';
//import 'package:youlianghuiplugin_example/read.dart';
//
//
//class AdView extends LeafRenderObjectWidget {
//  AndroidViewController _viewController;
//  final String viewType;
//  final MyPoint touchPoint;
//
//  AdView({
//    @required this.viewType,
//    @required this.touchPoint,
//  }) {
//    int _id = platformViewsRegistry.getNextPlatformViewId();
//    print(_id);
//    _viewController = PlatformViewsService.initAndroidView(
//        id: _id,
//        viewType: viewType,
//        layoutDirection: TextDirection.ltr
//    );
//  }
//
//  @override
//  RenderObject createRenderObject(BuildContext context) {
//    print(touchPoint);
//    return AdRenderObject(
//        viewController: _viewController,
//        touchPoint: touchPoint,
//    );
//  }
//
//  @override
//  void updateRenderObject(BuildContext context, AdRenderObject adRenderObject) {
//    adRenderObject.viewController = _viewController;
//    adRenderObject.touchPoint = touchPoint;
//  }
//
//  @override
//  void didUnmountRenderObject(RenderObject renderObject) {
//    _viewController.dispose();
//    super.didUnmountRenderObject(renderObject);
//  }
//
//}