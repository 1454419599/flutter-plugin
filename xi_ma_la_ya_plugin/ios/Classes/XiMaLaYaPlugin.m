#import "XiMaLaYaPlugin.h"
#if __has_include(<xi_ma_la_ya_plugin/xi_ma_la_ya_plugin-Swift.h>)
#import <xi_ma_la_ya_plugin/xi_ma_la_ya_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "xi_ma_la_ya_plugin-Swift.h"
#endif

@implementation XiMaLaYaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftXiMaLaYaPlugin registerWithRegistrar:registrar];
}
@end
