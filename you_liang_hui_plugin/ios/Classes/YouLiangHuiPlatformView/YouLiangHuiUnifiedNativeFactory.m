//
//  YouLiangHuiUnifiedNativeFactory.m
//  youlianghuiplugin
//
//  Created by mac on 2020/9/23.
//

#import "YouLiangHuiUnifiedNativeFactory.h"
#import "YouLiangHuiUnifiedNativeView.h"

@interface YouLiangHuiUnifiedNativeFactory ()

@end

@implementation YouLiangHuiUnifiedNativeFactory

NSObject<FlutterBinaryMessenger>* _flutterBinaryMessenger;

- (instancetype)initWithBinaryMessenger: (NSObject<FlutterBinaryMessenger>*) flutterBinaryMessenger
{
    _flutterBinaryMessenger = flutterBinaryMessenger;
    self = [super init];
    return self;
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    return [[YouLiangHuiUnifiedNativeView alloc] initWithBinaryMessenger:_flutterBinaryMessenger viewIdentifier:viewId arguments:args];
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end
