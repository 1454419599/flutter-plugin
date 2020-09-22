//
//  YouLiangHuiConfig.h
//  youlianghuiplugin
//
//  Created by mac on 2020/9/21.
//
#import <Foundation/Foundation.h>

static NSString *APP_ID = @"";
static NSString *REWARD_VIDEO_ID = @"";
static NSString *SPLASH_ID = @"";
//static NSString *BIG_VIEW_ID = @"";
//static NSString *BANNER_ID = @"";

typedef enum  {
    Load = 0,
    Show,
    Expose,
    Reward,
    Click,
    Complete,
    Close,
    Error,
} AdStatus;

@interface YouLiangHuiConfig : NSObject

+ (NSString *) initYouLiangHuiMethodName;
+ (NSString *) showRewardVideoMethodName;
    
+ (NSString *) appId;
+ (void) appId: (NSString *) value;

+ (NSString *) rewardVideoId;
+ (void) rewardVideoId: (NSString *) value;

+ (NSString *) splashId;
+ (void) splashId: (NSString *) value;

//+ (NSString *) bigViewId;
//+ (void) bigViewId: (NSString *) value;
//
//+ (NSString *) bannerId;
//+ (void) bannerId: (NSString *) value;

+ (NSDictionary *) responseSuccessData: (NSString *) methodName adStatus: (AdStatus) adStatus;

+ (NSDictionary *) responseErrorData: (NSString *) methodName code: (NSString *) code msg: (NSString *) msg;

+ (NSDictionary *) responseErrorData: (NSString *) methodName code: (NSString *) code msg: (NSString *) msg detail: (NSObject *) detail;
@end
