//
//  GoogleAnalytics.m
//  Guilt
//
//  Created by John Andrews on 10/20/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "GoogleAnalytics.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation GoogleAnalytics

+ (void)trackAnalyticsForScreen:(NSString *)screenName
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

+ (void)trackAnalyticsForAction:(NSString *)action withLabel:(NSString *)labelIt onScreen:(NSString *)screenName
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:action
                                                           label:labelIt
                                                           value:nil] build]];
}

@end
