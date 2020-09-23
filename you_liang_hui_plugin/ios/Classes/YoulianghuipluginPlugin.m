#import "YoulianghuipluginPlugin.h"
#import "YouLiangHuiConfig.h"
#import "YouLiangHuiRewardVideo.h"
#import "YouLiangHuiSplash.h"
#import "GDTSDKConfig.h"

@interface YoulianghuipluginPlugin ()
@end

static NSString* _basicMessageChannelName = @"YouLiangHuiBasicMessageChannelPlugin";

static FlutterBasicMessageChannel* _messageChannel;
static UIViewController* _controller;
static YouLiangHuiRewardVideo* _youLiangHuiRewardVideo;
static YouLiangHuiSplash *_youLiangHuiSplash;

@implementation YoulianghuipluginPlugin

+ (FlutterBasicMessageChannel *) messageChannel {
    return _messageChannel;
}

//+ (FlutterViewController *) controller {
//    return _controller;
//}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"youlianghuiplugin"
            binaryMessenger:[registrar messenger]];
    
  YoulianghuipluginPlugin* instance = [[YoulianghuipluginPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    _messageChannel = [FlutterBasicMessageChannel messageChannelWithName:_basicMessageChannelName binaryMessenger:[registrar messenger]];
    [_messageChannel setMessageHandler:messageHandler];
    _controller = [UIApplication sharedApplication].delegate.window.rootViewController;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([[YouLiangHuiConfig initYouLiangHuiMethodName] isEqualToString:call.method]) {
      if ([call.arguments isKindOfClass:[NSDictionary class]]) {
          @try {
              NSDictionary *arguments = call.arguments;
              
              if (arguments[@"appId"] != nil) {
                  if ([arguments[@"appId"] isKindOfClass:[NSString class]]) {
                      NSString *appId = arguments[@"appId"];
                      [YouLiangHuiConfig appId:appId];
                      [GDTSDKConfig registerAppId:[YouLiangHuiConfig appId]];
                  } else {
                      result([FlutterError errorWithCode:@"-10002" message:@"arguments[appId] 应为 String" details:arguments]);
                  }
              } else {
                  result([FlutterError errorWithCode:@"-10001" message:@"arguments 缺少 appId" details:arguments]);
              }
              
              if (arguments[@"rewardVideoId"] != nil) {
                  if ([arguments[@"rewardVideoId"] isKindOfClass:[NSString class]]) {
                      NSString *rewardVideoId = arguments[@"rewardVideoId"];
                      [YouLiangHuiConfig rewardVideoId:rewardVideoId];
                      _youLiangHuiRewardVideo = [[YouLiangHuiRewardVideo alloc] init];
                  } else {
                      result([FlutterError errorWithCode:@"-10004" message:@"arguments[rewardVideoId] 应为 String" details:arguments]);
                  }
              }
              
              if (arguments[@"splash"] != nil) {
                  if ([arguments[@"splash"] isKindOfClass:[NSDictionary class]]) {
                      NSDictionary *splash = arguments[@"splash"];
                      if ([splash[@"posId"] isKindOfClass:[NSString class] ]) {
                          NSString *posId = splash[@"posId"];
                          [YouLiangHuiConfig splashId:posId];
                          _youLiangHuiSplash = [[YouLiangHuiSplash alloc] init];
                          [_youLiangHuiSplash initSplashAd];
                      } else {
                          result([FlutterError errorWithCode:@"-10007" message:@"arguments[splash][posId] 应为 String" details:splash]);
                      }
                  } else {
                      result([FlutterError errorWithCode:@"-10006" message:@"arguments[splash] 应为 Map" details:arguments]);
                  }
              }
              
              
              if (arguments[@"nativeExpress"] != nil) {
                  if ([arguments[@"nativeExpress"] isKindOfClass:[NSArray class]]) {
//                      NSArray *nativeExpress = arguments[@"nativeExpress"];
//                      [YouLiangHuiConfig rewardVideoId:rewardVideoId];
                  } else {
                      result([FlutterError errorWithCode:@"-10005" message:@"arguments[nativeExpress] 应为 List<Array>" details:arguments]);
                  }
              }
              
          } @catch (NSException *exception) {
              NSLog(@"%@", exception.name);
              result([FlutterError errorWithCode:@"-40000" message:exception.reason details:exception]);
          }
      }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

void (^messageHandler)(id, FlutterReply) = ^(id message, FlutterReply callback) {
    NSString* methodName = message[@"method"];
    if ([[YouLiangHuiConfig showRewardVideoMethodName] isEqualToString:methodName]) {
//        NSString* posId = message[@"posId"];
//        NSNumber* volume = [NSNumber numberWithBool:message[@"volumeOn"]];
//        BOOL volumeOn = [volume isEqual: @1];
//        if (posId == nil) {
//            posId = [YouLiangHuiConfig rewardVideoId];
//        }
        if (_youLiangHuiRewardVideo != nil) {
            [_youLiangHuiRewardVideo showAd];
        }
    } else if ([[YouLiangHuiConfig autoSplashMethodName] isEqualToString:methodName]) {
        [_youLiangHuiSplash showAd];
    }
};

@end
