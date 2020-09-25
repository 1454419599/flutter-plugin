//
//  YouLiangHuiUnifiedNative.m
//  youlianghuiplugin
//
//  Created by mac on 2020/9/23.
//

#import "YouLiangHuiUnifiedNative.h"
#import "YouLiangHuiConfig.h"

static NSMutableDictionary<NSString *, YouLiangHuiUnifiedNative *> *youLiangHuiUnifiedNativeDictionary = nil;

@interface YouLiangHuiUnifiedNative()<GDTUnifiedNativeAdDelegate>

@property (nonatomic, strong) NSMutableArray<GDTUnifiedNativeAdDataObject *>* unifiedNativeAdDataObjectArr;
@property (nonatomic, strong) GDTUnifiedNativeAd *unifiedNativeAd;
//@property (nonatomic, strong) NSString *posId;

@end

@implementation YouLiangHuiUnifiedNative

int cacheAdCount = 3;

+ (YouLiangHuiUnifiedNative *)getShareInstance: (NSString *)posId {
    @synchronized (self) {
        if (youLiangHuiUnifiedNativeDictionary == nil) {
            youLiangHuiUnifiedNativeDictionary = [[NSMutableDictionary alloc] init];
        }
        if (youLiangHuiUnifiedNativeDictionary[posId] == nil) {
            YouLiangHuiUnifiedNative *youLiangHuiUnifiedNative= [[YouLiangHuiUnifiedNative alloc] init];
            youLiangHuiUnifiedNative.unifiedNativeAdDataObjectArr = [[NSMutableArray alloc] init];
            [youLiangHuiUnifiedNative initAd:posId];
            youLiangHuiUnifiedNativeDictionary[posId] = youLiangHuiUnifiedNative;
        }
        return youLiangHuiUnifiedNativeDictionary[posId];
    }
}

- (void)initAd: (NSString *) posId {
    self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithPlacementId: posId];
    self.unifiedNativeAd.delegate = self;
    [self cacheAd];
}

- (void)cacheAd {
    if (self.unifiedNativeAd != nil) {
        [self.unifiedNativeAd loadAdWithAdCount:cacheAdCount];
    }
}

- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error {
    NSLog(@"自渲染加载广告：%s",__FUNCTION__);
    NSLog(@"%@", error);
    [self.unifiedNativeAdDataObjectArr addObjectsFromArray:unifiedNativeAdDataObjects];
}

- (GDTUnifiedNativeAdDataObject *)pollUnifiedNativeADData {
    @synchronized (self.unifiedNativeAdDataObjectArr) {
        if ([self.unifiedNativeAdDataObjectArr count] < cacheAdCount) {
            [self cacheAd];
        }
        if ([self.unifiedNativeAdDataObjectArr count] > 0) {
            GDTUnifiedNativeAdDataObject * adData = self.unifiedNativeAdDataObjectArr[0];
            [self.unifiedNativeAdDataObjectArr removeObjectAtIndex:0];
            return adData;
        }
        return nil;
    }
}

@end
