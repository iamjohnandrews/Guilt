//
//  NTRTwitterClient.m
//  TwitterLoginWithParseExample
//
//  Created by Natasha Murashev on 4/6/14.
//  Copyright (c) 2014 NatashaTheRobot. All rights reserved.
//

#import "TwitterClient.h"
#import "PFTwitterUtils+NativeTwitter.h"
#import <Accounts/Accounts.h>
#import "FHSTwitterEngine.h"
@class UsersLoginInfo;

@implementation TwitterClient

+ (void)loginUserWithAccount:(ACAccount *)twitterAccount shit:(id<TwitterDelegate>)twitterDelegate
{
    [PFTwitterUtils initializeWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    
    [PFTwitterUtils setNativeLogInSuccessBlock:^(PFUser *parseUser, NSString *userTwitterId, NSError *error) {
        NSLog(@"Twitter Login Success for parseUser,%@", parseUser);
        [self keepIt:twitterDelegate MovingAlong:parseUser];
        if (![UsersLoginInfo checkIfLoginInfoAlreadySaved:@"twitter"]) {
            [UsersLoginInfo saveLoginInfoToNSUserDefaults:@"twitter" and:[[PFUser currentUser] objectId]];
        }
    }];
    
    [PFTwitterUtils setNativeLogInErrorBlock:^(TwitterLogInError logInError) {
        NSError *error = [[NSError alloc] initWithDomain:nil code:logInError userInfo:@{@"logInErrorCode" : @(logInError)}];
        NSLog(@"Twitter Login Failure, error:%@", error);
        [twitterDelegate userDidLogIntoTwitter:NO];
    }];
    
    [PFTwitterUtils logInWithAccount:twitterAccount];
}

+ (void)loginUserWithTwitterEngine:(id<TwitterDelegate>)twitterDelegate
{
    [PFTwitterUtils initializeWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    
    FHSTwitterEngine *twitterEngine = [FHSTwitterEngine sharedEngine];
    FHSToken *token = [FHSTwitterEngine sharedEngine].accessToken;
    
    [PFTwitterUtils logInWithTwitterId:twitterEngine.authenticatedID
                            screenName:twitterEngine.authenticatedUsername
                             authToken:token.key
                       authTokenSecret:token.secret
                                 block:^(PFUser *user, NSError *error) {
                                     [self keepIt:twitterDelegate MovingAlong:user];                                
                                 }];
}

+ (void)keepIt:(id<TwitterDelegate>)twitterDelegate MovingAlong:(PFUser *)user
{
    if (user) {
        if (user.isNew) {
            NSLog(@"New User signed up and logged in through Twitter!");
            [twitterDelegate userDidLogIntoTwitter:YES];
        } else {
            NSLog(@"User logged in through Twitter!");
            [twitterDelegate userDidLogIntoTwitter:YES];
        }
        
    } else {
        NSLog(@"Twitter Login Failure");
        [twitterDelegate userDidLogIntoTwitter:NO];
    }
}

+ (void)fetchDataForUser:(PFUser *)user username:(NSString *)twitterUsername
{
    NSString * requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", twitterUsername];
    
    NSURL *verify = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            user.username = result[@"screen_name"];
            user[@"name"]= result[@"name"];
            user[@"profileDescription"] = result[@"description"];
            user[@"imageURL"] = [result[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
            [user saveEventually];
        }
    }];
    
}

@end
