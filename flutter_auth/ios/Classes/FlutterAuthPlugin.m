#import "FlutterAuthPlugin.h"
#if __has_include(<flutter_auth/flutter_auth-Swift.h>)
#import <flutter_auth/flutter_auth-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_auth-Swift.h"
#endif

@implementation FlutterAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAuthPlugin registerWithRegistrar:registrar];
}
@end
