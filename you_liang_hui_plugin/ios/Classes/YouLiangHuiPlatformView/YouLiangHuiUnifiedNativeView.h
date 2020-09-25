//
//  YouLiangHuiUnifiedNativeView.h
//  youlianghuiplugin
//
//  Created by mac on 2020/9/23.
//

//#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
//#import <UIKit/UIKit.h>
#import <GDTMobSDK/GDTUnifiedNativeAd.h>

@interface YouLiangHuiUnifiedNativeView : GDTUnifiedNativeAdView<FlutterPlatformView>

- (instancetype _Nullable )initWithBinaryMessenger: (NSObject<FlutterBinaryMessenger>*_Nullable) flutterBinaryMessenger viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args;

@end
