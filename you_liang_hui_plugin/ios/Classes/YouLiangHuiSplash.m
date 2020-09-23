//
//  YouLiangHuiSplash.m
//  youlianghuiplugin
//
//  Created by mac on 2020/9/22.
//

#import "YouLiangHuiSplash.h"
#import "GDTSplashAd.h"
#import "YouLiangHuiConfig.h"
#import "YoulianghuipluginPlugin.h"


@interface YouLiangHuiSplash ()<UIApplicationDelegate, GDTSplashAdDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) GDTSplashAd *splash;
@property (nonatomic, assign) BOOL isAutoShow;

@end

@implementation YouLiangHuiSplash

- (void) initSplashAd {
    self.isAutoShow = NO;
    [self createBottomLogo];
    [self initAd];
    [self preloadAd];
}

- (void) createBottomLogo {
    @try {
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchImage"]];
        double logoHeight =logo.bounds.size.height;
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, logoHeight + 40)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        logo.accessibilityIdentifier = @"splash_logo";
        logo.center = [self bottomView].center;
        [[self bottomView] addSubview:logo];
    } @catch (NSException *exception) {
        NSLog(@"%s",__FUNCTION__);
        NSLog(@"createBottomLogo: %@", @"创建失败");
        NSLog(@"ERROR: %@", exception);
    }
}

- (void) initAd {
    @try {
        self.splash = [[GDTSplashAd alloc] initWithPlacementId:[YouLiangHuiConfig splashId]];
        self.splash.delegate = self; //设置代理
        self.splash.fetchDelay = 3; //开发者可以设置开屏拉取时间，超时则放弃展示
    } @catch (NSException *exception) {
        NSLog(@"%s",__FUNCTION__);
        NSLog(@"initAd: %@", @"初始化失败");
        NSLog(@"ERROR: %@", exception);
    }
}

- (void)showAd {
    if (self.splash != nil) {
        if (self.splash.isAdValid) {
            [self.splash showAdInWindow:[[UIApplication sharedApplication] keyWindow] withBottomView:self.bottomView skipView:nil];
        } else {
            self.isAutoShow = YES;
            [self preloadAd];
        }
    } else {
        [self sendAdCloseMessage];
    }
}

- (void)preloadAd {
    if (self.splash != nil) {
        [self.splash loadAd];
    }
}

- (void)sendAdCloseMessage {
    [[YoulianghuipluginPlugin messageChannel] sendMessage:[YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig autoSplashMethodName] adStatus:Close]];
}

#pragma mark - GDTSplashAdDelegate

- (void)splashAdDidLoad:(GDTSplashAd *)splashAd {
    NSLog(@"splashAdDidLoad:%@", @"广告拉取成功");
    NSLog(@"%s", __FUNCTION__);
    if (self.isAutoShow) {
        [self showAd];
    }
    [[YoulianghuipluginPlugin messageChannel] sendMessage:[YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig autoSplashMethodName] adStatus:Load]];
}

- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd {
    NSLog(@"splashAdSuccessPresentScreen:%@", @"广告展示成功");
    NSLog(@"%s",__FUNCTION__);
    [[YoulianghuipluginPlugin messageChannel] sendMessage:[YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig autoSplashMethodName] adStatus:Show]];
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    
    NSLog(@"splashAdFailToPresent:%@", @"广告展示失败");
    NSLog(@"%s%@",__FUNCTION__,error);
    self.isAutoShow = NO;
    [[YoulianghuipluginPlugin messageChannel] sendMessage:[YouLiangHuiConfig responseErrorData:[YouLiangHuiConfig autoSplashMethodName] code:[NSString stringWithFormat:@"%ld", (long)error.code] msg:error.domain detail:error.localizedDescription]];
//    if (self.isParallelLoad) {
//    }
//    else {
//        NSLog(@"splashAdFailToPresent:%@", @"广告拉取失败");
//    }
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdExposured:%@", @"开屏广告曝光回调");
    NSLog(@"%s",__FUNCTION__);
    [[YoulianghuipluginPlugin messageChannel] sendMessage:[YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig autoSplashMethodName] adStatus:Expose]];
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdClicked:%@", @"开屏广告点击回调");
    NSLog(@"%s",__FUNCTION__);
    [[YoulianghuipluginPlugin messageChannel] sendMessage:[YouLiangHuiConfig responseSuccessData:[YouLiangHuiConfig autoSplashMethodName] adStatus:Click]];
}

- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdApplicationWillEnterBackground:%@", @"当点击下载应用时会调用系统程序打开，应用切换到后台");
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdWillClosed:%@", @"开屏广告将要关闭回调");
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdClosed:%@", @"开屏广告关闭回调");
    NSLog(@"%s",__FUNCTION__);
//    self.splash = nil;
    [self preloadAd];
    self.isAutoShow = NO;
    [self sendAdCloseMessage];
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"splashAdWillPresentFullScreenModal:%@", @"开屏广告点击以后即将弹出全屏广告页");
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

@end
