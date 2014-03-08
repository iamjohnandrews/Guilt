//
//  AppDelegate.m
//  Guilt
//
//  Created by John Andrews on 10/23/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Parse
    
    
    
    [Parse setApplicationId:@"HMDmp3Y7ihXmaRXw5rfjSszBTwa7I0Uc3Rl7DNZu"
                  clientKey:@"BUHidRvb464SnFmDyh0qgZ6qrL15gKI1NSUP0LLk"];
    
    //Parse Analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    return YES;
}





@end
