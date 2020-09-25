//
//  YouLiangHuiUnifiedNativeView.m
//  youlianghuiplugin
//
//  Created by mac on 2020/9/23.
//

#import "YouLiangHuiUnifiedNativeView.h"
#import "YouLiangHuiConfig.h"
#import "YouLiangHuiUnifiedNative.h"
#import "GDTUnifiedNativeAd.h"

typedef enum {
    adDataType_AdData,
    adDataType_AdButtonText,
    adDataType_NoAd
} AdDataType;

@interface YouLiangHuiUnifiedNativeView ()<GDTUnifiedNativeAdViewDelegate, GDTMediaViewDelegate>

//@property (nonatomic, strong) GDTUnifiedNativeAdView *unifiedNativeview;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *clickableView;
@property (nonatomic, strong) FlutterBasicMessageChannel *messageChannel;
@property (nonatomic, strong) GDTUnifiedNativeAdDataObject *adDataObject;

@property (nonatomic, strong) NSString *posId;
@property (assign, nonatomic) NSNumber *mediaViewTop;
@property (assign, nonatomic) NSNumber *mediaViewLeft;
@property (assign, nonatomic) NSNumber *mediaViewWidth;
@property (assign, nonatomic) NSNumber *mediaViewHeight;
@property (assign, nonatomic) NSNumber *clickableViewWidth;
@property (assign, nonatomic) NSNumber *clickableViewHeight;
@property (assign, nonatomic) NSNumber *clickableViewTop;
@property (assign, nonatomic) NSNumber *clickableViewLeft;
@property (assign, nonatomic) NSNumber *clickableViewRight;
@property (assign, nonatomic) NSNumber *clickableViewBottom;

@end

@implementation YouLiangHuiUnifiedNativeView

- (instancetype)initWithBinaryMessenger: (NSObject<FlutterBinaryMessenger>*) flutterBinaryMessenger viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args
{
    self = [super init];
    if (self) {
        @try {
            [self parseParam:args];
            self.messageChannel = [FlutterBasicMessageChannel messageChannelWithName:[NSString stringWithFormat:@"%@_%lld", [YouLiangHuiConfig nativeUnifiedViewName], viewId] binaryMessenger:flutterBinaryMessenger];
            __block YouLiangHuiUnifiedNativeView *strongBlock = self;
            [self.messageChannel setMessageHandler:^(id message, FlutterReply callback) {
                @try {
                    NSLog(@"%@", message);
                    if ([@"reLoad" isEqualToString:message]) {
                        [strongBlock unregisterDataObject];
                        [strongBlock initAd];
                    } else if ([@"dispose" isEqualToString:message]) {
                        [strongBlock unregisterDataObject];
                        strongBlock.messageChannel = nil;
                        strongBlock.adDataObject = nil;
                        strongBlock = nil;
                    }
                } @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
                
            }];
            [self createView];
            [self initAd];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        
    }
    return self;
}

- (void)didMoveToWindow {
    [self unifiedNativeViewLayout];
}

- (void)dealloc
{
    self.messageChannel = nil;
    self.adDataObject = nil;
    NSLog(@"------------dealloc-%@", @"dealloc");
}

- (nonnull UIView *)view {
    return self;
}

- (void)parseParam: (id _Nullable)args {
    @try {
        if (args == nil) {
            NSLog(@"%@", @"YouLiangHuiUnifiedNativeView 参数为nil");
        } else if ([args isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@", args);
            self.posId = args[@"posId"];
            if (![args[@"mediaViewTop"] isKindOfClass:[NSNull class]]) {
                self.mediaViewTop = args[@"mediaViewTop"];
            }
            if (![args[@"mediaViewLeft"] isKindOfClass:[NSNull class]]) {
                self.mediaViewLeft = args[@"mediaViewLeft"];
            }
            if (![args[@"mediaViewWidth"] isKindOfClass:[NSNull class]]) {
                self.mediaViewWidth = args[@"mediaViewWidth"];
            }
            if (![args[@"mediaViewHeight"] isKindOfClass:[NSNull class]]) {
                self.mediaViewHeight = args[@"mediaViewHeight"];
            }
            if (![args[@"clickableViewWidth"] isKindOfClass:[NSNull class]]) {
                self.clickableViewWidth = args[@"clickableViewWidth"];
            }
            if (![args[@"clickableViewHeight"] isKindOfClass:[NSNull class]]) {
                self.clickableViewHeight = args[@"clickableViewHeight"];
            }
            if (![args[@"clickableViewTop"] isKindOfClass:[NSNull class]]) {
                self.clickableViewTop = args[@"clickableViewTop"];
            }
            if (![args[@"clickableViewLeft"] isKindOfClass:[NSNull class]]) {
                self.clickableViewLeft = args[@"clickableViewLeft"];
            }
            if (![args[@"clickableViewLeft"] isKindOfClass:[NSNull class]]) {
                self.clickableViewRight = args[@"clickableViewRight"];
            }
            if (![args[@"clickableViewLeft"] isKindOfClass:[NSNull class]]) {
                self.clickableViewBottom = args[@"clickableViewBottom"];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
}

- (void)createView {
    self.imageView = [[UIImageView alloc] init];
    self.clickableView = [[UIView alloc] init];
    [self addSubview:self.imageView];
    [self addSubview:self.clickableView];
}

- (void)initAd {
    @try {
        self.adDataObject = [[YouLiangHuiUnifiedNative getShareInstance:self.posId] pollUnifiedNativeADData];
        NSLog(@"adDataObject: %@", self.adDataObject);
        if (self.adDataObject == nil) {
            NSLog(@"%@", @"YouLiangHuiUnifiedNativeView 获取广告为nil");
            [self sendAdMessage:adDataType_NoAd];
            return;
        }
        [self sendAdMessage:adDataType_AdData];
        //是否启动自动续播功能，当在 tableView 等场景播放器被销毁时，广告展示时继续从上次播放位置续播，默认 NO
        self.adDataObject.videoConfig.autoResumeEnable = YES;
        //广告发生点击行为时，是否展示视频详情页 设为 NO 时，用户点击 clickableViews 会直接打开 App Store 或者广告落地页
        self.adDataObject.videoConfig.detailPageEnable = YES;
        //是否支持用户点击 MediaView 改变视频播放暂停状态，默认 NO 设为 YES 时，用户点击会切换播放器播放、暂停状态
        self.adDataObject.videoConfig.userControlEnable = NO;
        
//        self.unifiedNativeview = [[GDTUnifiedNativeAdView alloc] init];
        
//        self.backgroundColor = UIColor.blueColor;
//        self.clickableView.backgroundColor = UIColor.yellowColor;
        if (self.adDataObject.isVideoAd || self.adDataObject.isVastAd) {
            self.mediaView.hidden = NO;
            self.imageView.hidden = YES;
        } else {
            self.mediaView.hidden = YES;
            self.imageView.hidden = NO;
            [self loadImage];
        }
        self.delegate = self;
        self.mediaView.delegate = self;
        self.viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        
        
//        [self unifiedNativeViewLayout];
        [self registerDataObject:self.adDataObject clickableViews:@[self.imageView, self.clickableView]];
    } @catch (NSException *exception) {
        NSLog(@"adDataObject exception: %@", exception);
    }
}

- (void)unifiedNativeViewLayout {
    @try {
        if (self.mediaViewTop == nil) {
            self.mediaViewTop = @(0);
        }
        if (self.mediaViewLeft == nil) {
            self.mediaViewLeft = @(0);
        }
        if (self.mediaViewWidth == nil) {
            self.mediaViewWidth = @(self.bounds.size.width);
        }
        if (self.mediaViewHeight == nil) {
            self.mediaViewHeight = @(self.bounds.size.height);
        }
        if (self.clickableViewWidth == nil) {
            self.clickableViewWidth = @(self.bounds.size.width);
        }
        if (self.clickableViewHeight == nil) {
            self.clickableViewHeight = @(self.bounds.size.height);
        }
        if (self.clickableViewTop == nil) {
            self.clickableViewTop = @(0);
        }
        if (self.clickableViewLeft == nil) {
            self.clickableViewLeft = @(0);
        }
        NSLog(@"%@ - %@ - %@ - %@", self.mediaViewWidth, self.mediaViewHeight, self.clickableViewWidth, self.clickableViewHeight);
        NSLog(@"%@ - %@ - %@ - %@", self.mediaViewTop, self.mediaViewLeft, self.clickableViewTop, self.clickableViewLeft);
        CGRect frame = CGRectMake(self.mediaViewLeft.boolValue, self.mediaViewTop.doubleValue, self.mediaViewWidth.doubleValue, self.mediaViewHeight.doubleValue);
        [self.imageView setFrame:frame];
        [self.mediaView setFrame:frame];
        [self.clickableView setFrame:CGRectMake(self.clickableViewLeft.doubleValue, self.clickableViewTop.doubleValue, self.clickableViewWidth.doubleValue, self.clickableViewHeight.doubleValue)];
//        self.clickableView.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (void)loadImage {
    NSURL *imageURL = [NSURL URLWithString:self.adDataObject.imageUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:imageData];
        });
    });
}

+ (NSString *)adDataType2Str: (AdDataType) type {
    NSString *typeStr;
    switch (type) {
        case adDataType_AdData:
            typeStr = @"AdData";
            break;
        case adDataType_AdButtonText:
            typeStr = @"AdButtonText";
            break;
        case adDataType_NoAd:
            typeStr = @"NoAd";
            break;
        default:
            break;
    }
    return typeStr;
}

- (int)adDataObject2TypeIndex {
    int typeIndex;
    if (self.adDataObject.isVastAd || self.adDataObject.isVideoAd) {
        typeIndex = 2;
    } else if (self.adDataObject.isThreeImgsAd) {
        typeIndex = 3;
    } else {
        typeIndex = 1;
    }
    
    return typeIndex;
}

- (void)sendAdMessage: (AdDataType) type {
    @try {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        result[@"type"] = [YouLiangHuiUnifiedNativeView adDataType2Str:type];
        if (type == adDataType_AdData) {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            data[@"type"] = [NSString stringWithFormat:@"%d", [self adDataObject2TypeIndex]];
            data[@"image"] = self.adDataObject.imageUrl;
            data[@"title"] = self.adDataObject.title;
            data[@"desc"] = self.adDataObject.desc;
            data[@"icon"] = self.adDataObject.iconUrl;
            data[@"imgList"] = self.adDataObject.mediaUrlList;
            data[@"pictureWidth"] = @(self.adDataObject.imageWidth);
            data[@"pictureHeight"] = @(self.adDataObject.imageHeight);
            result[@"data"] = data;
        }
        if (type != adDataType_NoAd) {
            result[@"adButtonText"] = self.adDataObject.callToAction;
        }
        [self.messageChannel sendMessage:result];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
}

void (^youLiangHuiUnifiedNativeViewmessageHandler)(id, FlutterReply) = ^(id message, FlutterReply callback) {
    @try {
        NSLog(@"%@", message);
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
};

#pragma mark - GDTUnifiedNativeAdViewDelegate

/**
 广告曝光回调
 */
- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",@"广告曝光回调");
}


/**
 广告点击回调
 */
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",@"广告点击回调");
}


/**
 广告详情页关闭回调
 */
- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",@"广告详情页关闭回调");
//    if (self.adDataObject.isVideoAd || self.adDataObject.isVastAd) {
//        [self.unifiedNativeview.mediaView play];
//    }
}


/**
 当点击应用下载或者广告调用系统程序打开时调用

 */
- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",@"当点击应用下载或者广告调用系统程序打开时调用");
}


/**
 广告详情页面即将展示回调
 */
- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",@"广告详情页面即将展示回调");
}


/**
 视频广告播放状态更改回调
 */
- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",@"视频广告播放状态更改回调");
    NSLog(@"%lu", (unsigned long)status);
    NSLog(@"%@", userInfo);
}

#pragma mark - GDTMediaViewDelegate

/**
 用户点击 MediaView 回调，当 GDTVideoConfig userControlEnable 设为 YES，用户点击 mediaView 会回调。
 */
- (void)gdt_mediaViewDidTapped:(GDTMediaView *)mediaView {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",@"用户点击 MediaView 回调");
}

/**
 播放完成回调
 */
- (void)gdt_mediaViewDidPlayFinished:(GDTMediaView *)mediaView {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",@"播放完成回调");
}
@end

