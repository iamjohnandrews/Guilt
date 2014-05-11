//
//  NTRTwitterClient.h
//  TwitterLoginWithParseExample
//
//  Created by Natasha Murashev on 4/6/14.
//  Copyright (c) 2014 NatashaTheRobot. All rights reserved.
//

@class ACAccount;

@protocol TwitterDelegate <NSObject>
@optional
- (void)userDidLogIntoTwitter:(BOOL)loggedIn;
@end

@interface TwitterClient : NSObject

+ (void)loginUserWithAccount:(ACAccount *)twitterAccount shit:(id<TwitterDelegate>)twitterDelegate;
+ (void)loginUserWithTwitterEngine:(id<TwitterDelegate>)twitterDelegate;

@end
