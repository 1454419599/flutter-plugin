//
//  YouLiangHuiUnifiedNativeFactory.h
//  youlianghuiplugin
//
//  Created by mac on 2020/9/23.
//

//#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface YouLiangHuiUnifiedNativeFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithBinaryMessenger: (NSObject<FlutterBinaryMessenger>*) flutterBinaryMessenger;
@end
