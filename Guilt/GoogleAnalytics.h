//
//  GoogleAnalytics.h
//  Guilt
//
//  Created by John Andrews on 10/20/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleAnalytics : NSObject
+ (void)trackAnalyticsForScreen:(NSString *)screenName;
+ (void)trackAnalyticsForAction:(NSString *)action withLabel:(NSString *)labelIt onScreen:(NSString *)screenName;

@end
