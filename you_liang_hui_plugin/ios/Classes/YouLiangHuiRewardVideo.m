//
//  YouLiangHuiRewardVideo.m
//  youlianghuiplugin
//
//  Created by mac on 2020/9/21.
//

#import "YouLiangHuiRewardVideo.h"
#import "YouLiangHuiConfig.h"
#import "GDTRewardVideoAd.h"
#import "YoulianghuipluginPlugin.h"

@interface YouLiangHuiRewardVideo ()<GDTRewardedVideoAdDelegate>

@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;

@end

@implementation YouLiangHuiRewardVideo {
    BOOL isAutoPlay;
    BOOL isLoad;
    int maxRequestNum;
    int currentRequestNum;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isAutoPlay = NO;
        isLoad = NO;
        maxRequestNum = 30;
        currentRequestNum = 0;
        [self initAd];
        [self mLoadAd];
    }
    return self;
}

- (void)initAd {
    self.rewardVideoAd = [[[GDTRewardVideoAd alloc] init] initWithAppId:[YouLiangHuiConfig appId] placementId:[YouLiangHuiConfig rewardVideoId]] ;
    self.rewardVideoAd.delegate = self;
}

- (void)mLoadAd {
    currentRequestNum++;
    [self.rewardVideoAd loadAd];
}

- (void)showAd {
    NSLog(@"isLoad: %d, isAutoPlay: %d, currentRequestNum: %d", isLoad, isAutoPlay, currentRequestNum);
    if (isLoad) {
        [self.rewardVideoAd showAdFromRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    } else {
        isAutoPlay = YES;
        [self mLoadAd];
    }
}

#pragma mark - GDTRewardVideoAdDelegate
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",@"激励视频广告加载广告数据成功回调");
    NSLog(@"%@",[NSString stringWithFormat:@"%@ 广告数据加载成功", rewardedVideoAd.adNetworkName]);
    NSLog(@"eCPM:%ld eCPMLevel:%@", [rewardedVideoAd eCPM], [rewardedVideoAd eCPMLevel]);
    isLoad = YES;
    currentRequestNum = 1;
    if (isAutoPlay) {
        [self showAd];
    }
    [[YoulianghuipluginPlugin messageChannel] sendMessage: [YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig showRewardVideoMethodName] adStatus: Load]];
}


- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",@"激励视频数据下载成功回调，已经下载过的视频会直接回调");
    NSLog(@"%@",[NSString stringWithFormat:@"%@ 视频文件加载成功", rewardedVideoAd.adNetworkName]);
}


- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频播放页即将打开");
    [[YoulianghuipluginPlugin messageChannel] sendMessage: [YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig showRewardVideoMethodName] adStatus: Show]];
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告已曝光");
    [[YoulianghuipluginPlugin messageChannel] sendMessage: [YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig showRewardVideoMethodName] adStatus: Expose]];
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
//    广告关闭后释放ad对象
//    self.rewardVideoAd = nil;
    NSLog(@"广告已关闭");
    isAutoPlay = NO;
    isLoad = NO;
    [self mLoadAd];
    [[YoulianghuipluginPlugin messageChannel] sendMessage: [YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig showRewardVideoMethodName] adStatus: Close]];
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告已点击");
    [[YoulianghuipluginPlugin messageChannel] sendMessage: [YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig showRewardVideoMethodName] adStatus: Click]];
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    if (error.code == 4014) {
        NSLog(@"请拉取到广告后再调用展示接口");
    } else if (error.code == 4016) {
        NSLog(@"应用方向与广告位支持方向不一致");
    } else if (error.code == 5012) {
        NSLog(@"广告已过期");
    } else if (error.code == 4015) {
        NSLog(@"广告已经播放过，请重新拉取");
    } else if (error.code == 5002) {
        NSLog(@"视频下载失败");
    } else if (error.code == 5003) {
        NSLog(@"视频播放失败");
    } else if (error.code == 5004) {
        NSLog(@"没有合适的广告");
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
    } else if (error.code == 3002) {
        NSLog(@"网络连接超时");
    } else if (error.code == 5027){
        NSLog(@"页面加载失败");
    }
    if (currentRequestNum < maxRequestNum) {
        [self mLoadAd];
    } else {
        [[YoulianghuipluginPlugin messageChannel] sendMessage:[YouLiangHuiConfig responseErrorData:[YouLiangHuiConfig showRewardVideoMethodName] code:[NSString stringWithFormat:@"%ld", (long)error.code] msg:[error domain] detail:error.localizedDescription]];
    }
    NSLog(@"ERROR: %@", error);
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"播放达到激励条件");
    [[YoulianghuipluginPlugin messageChannel] sendMessage: [YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig showRewardVideoMethodName] adStatus: Reward]];
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频播放结束");
    [[YoulianghuipluginPlugin messageChannel] sendMessage: [YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig showRewardVideoMethodName] adStatus: Complete]];
//    if (self.audioSessionSwitch.on) {
//        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
//    }
}

@end
