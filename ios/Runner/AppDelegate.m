#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"
#import <Firebase.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      if (@available(iOS 10.0, *)) {
      [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
    }
    [FIRApp configure];
      [GMSServices provideAPIKey:@"AIzaSyBNmTLkfCwy_iGDZIpBbz6G8kcnGCE1Dec"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
