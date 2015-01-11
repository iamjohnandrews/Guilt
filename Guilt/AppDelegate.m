//
//  AppDelegate.m
//  Guilt
//
//  Created by John Andrews on 10/23/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "InitialParseNetworking.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <AFNetworking/AFNetworking.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Parse
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_KEY];
    
    // Initialize Parse's Facebook Utilities singleton. This uses the FacebookAppID we specified in our App bundle's plist.
    [PFFacebookUtils initializeFacebook];
    
    //Parse Analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [[InitialParseNetworking sharedManager] getConversionNonprofitDataFromParse];
    

    //Google Analytics Tracking ID
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].dispatchInterval = 20;
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-51918496-1"];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    [tracker set:kGAIAppVersion value:version];
    [tracker set:kGAISampleRate value:@"50.0"];
    
    //Twitter Login
    [PFTwitterUtils initializeWithConsumerKey:TWITTER_CONSUMER_KEY
                               consumerSecret:TWITTER_CONSUMER_SECRET];
    
    return YES;
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
//    return [FBAppCall handleOpenURL:<#(NSURL *)#> sourceApplication:<#(NSString *)#> withSession:<#(FBSession *)#>];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)setupReachabilityListener {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            
            // We can receive several notifications per second. Let's avoid notification spam.
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
//                [UIAlertView showAlert:LS(@"Sorry!") withMessage:LS(@"No network access available.")];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                onceToken = 0;
            });
        }
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
