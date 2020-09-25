//
//  YouLiangHuiUnifiedNative.h
//  youlianghuiplugin
//
//  Created by mac on 2020/9/23.
//

#import <Foundation/Foundation.h>
#import <GDTMobSDK/GDTUnifiedNativeAd.h>

@interface YouLiangHuiUnifiedNative : NSObject

+ (YouLiangHuiUnifiedNative *) getShareInstance: (NSString *) posId;
- (GDTUnifiedNativeAdDataObject *)pollUnifiedNativeADData;

@end
