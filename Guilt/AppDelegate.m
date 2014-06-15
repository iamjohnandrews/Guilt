//
//  AppDelegate.m
//  Guilt
//
//  Created by John Andrews on 10/23/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "FlickrNetworkManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 
                                             (unsigned long)NULL), ^(void) {
        NSLog(@"call FLickr API");
        [[FlickrNetworkManager sharedManager] requestCharityImagescompletion:nil];
    });
    
    //Google Analytics Tracking ID
//    UA-51918496-1
    
    //Parse
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_KEY];
    
    // Initialize Parse's Facebook Utilities singleton. This uses the FacebookAppID we specified in our App bundle's plist.
    [PFFacebookUtils initializeFacebook];
    
    //Parse Analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Twitter Login
    [PFTwitterUtils initializeWithConsumerKey:TWITTER_CONSUMER_KEY
                               consumerSecret:TWITTER_CONSUMER_SECRET];
        
    return YES;
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}



@end
