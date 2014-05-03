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
    //Parse
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [Parse setApplicationId:@"HMDmp3Y7ihXmaRXw5rfjSszBTwa7I0Uc3Rl7DNZu"
                  clientKey:@"BUHidRvb464SnFmDyh0qgZ6qrL15gKI1NSUP0LLk"];
    
    //Parse Analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Twitter Login
    [PFTwitterUtils initializeWithConsumerKey:@"6HGYzIN6t2qJILEN0BlAwB0XQ"
                               consumerSecret:@"eqip3xLUZI2Th1kZpji9Uv8MmAH7LI012aMvwjlWLZOZ6a3F7Q"];
    
    return YES;
}





@end
