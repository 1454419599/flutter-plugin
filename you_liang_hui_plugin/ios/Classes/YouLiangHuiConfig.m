//
//  YouLiangHuiConfig.m
//  youlianghuiplugin
//
//  Created by mac on 2020/9/21.
//


#import "YouLiangHuiConfig.h"



@implementation YouLiangHuiConfig

+ (NSString *) initYouLiangHuiMethodName {
    return @"initYouLiangHui";
}

+ (NSString *) showRewardVideoMethodName {
    return @"showRewardVideoAD";
}

+ (NSString *) autoSplashMethodName {
    return @"autoSplashAD";
}

+ (NSString *) nativeUnifiedViewName {
    return @"com.maodouyuedu.youlianghuiplugin/NativeUnifiedAD";
}

+ (NSString *) appId {
    return APP_ID;
}

+ (void) appId: (NSString *) value {
    APP_ID = value;
}

+ (NSString *) rewardVideoId {
    return REWARD_VIDEO_ID;
}

+ (void) rewardVideoId: (NSString *) value {
    REWARD_VIDEO_ID = value;
}

+ (NSString *) splashId {
    return SPLASH_ID;
}

+ (void) splashId: (NSString *) value {
    SPLASH_ID = value;
}

//+ (NSString *) bigViewId {
//    return BIG_VIEW_ID;
//}
//
//+ (void) bigViewId: (NSString *) value {
//    BIG_VIEW_ID = value;
//}
//
//+ (NSString *) bannerId {
//    return BANNER_ID;
//}
//
//+ (void) bannerId: (NSString *) value {
//    BANNER_ID = value;
//}

// 获取当前显示的 UIViewController
+ (UIViewController *)findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}
+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    // 递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) {
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }

    return currentShowingVC;
}

+ (NSArray *)adStatusStrArr {
    return [NSArray arrayWithObjects:@"Load", @"Show", @"Expose", @"Reward", @"Click", @"Complete", @"Close", @"Error", nil];
}

+ (NSString *)adStatus2String: (AdStatus) adStatus {
    return [YouLiangHuiConfig adStatusStrArr][adStatus];
}

+ (NSDictionary *) responseData: (NSString *) methodName type: (NSString *) type data: (NSObject *) data {
    return [NSDictionary dictionaryWithObjectsAndKeys:methodName, @"method", type, @"type", data, @"data", nil];
}

+ (NSDictionary *) responseSuccessData: (NSString *) methodName adStatus: (AdStatus) adStatus {
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:[YouLiangHuiConfig adStatus2String:adStatus], @"adStatus", nil];
    return [YouLiangHuiConfig responseData:methodName type:@"SUCCESS" data:data];
}

+ (NSDictionary *) responseErrorData: (NSString *) methodName code: (NSString *) code msg: (NSString *) msg {
    return [YouLiangHuiConfig responseErrorData:methodName code:code msg:msg detail:nil];
}

+ (NSDictionary *) responseErrorData: (NSString *) methodName code: (NSString *) code msg: (NSString *) msg detail: (NSObject *) detail {
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:code, @"code", msg, @"msg", detail, @"detail", nil];
    return [YouLiangHuiConfig responseErrorData:methodName data:data];
}

+ (NSDictionary *) responseErrorData: (NSString *) methodName data: (NSObject *) data {
    return [YouLiangHuiConfig responseData:methodName type:@"ERROR" data:data];
}

@end
