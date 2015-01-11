//
//  UsersLoginInfo.m
//  Guilt
//
//  Created by John Andrews on 11/1/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "UsersLoginInfo.h"

@implementation UsersLoginInfo

#pragma mark - Save User to NSUserDefaults
+ (void)saveLoginInfoToNSUserDefaults:(NSString *)loginMethod and:(NSString*)objectID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:objectID forKey:loginMethod];
}

+ (BOOL)checkIfLoginInfoAlreadySaved:(NSString *)loginMethod
{
    BOOL loginInfoDoesExist;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedObjectID = [defaults objectForKey:loginMethod];
    
    if (savedObjectID.length) {
        loginInfoDoesExist = YES;
    } else {
        loginInfoDoesExist = NO;
    }
    
    return loginInfoDoesExist;
}

+ (NSArray *)getUsersObjectID
{
    NSArray *tempArray = [[NSArray alloc] initWithObjects:@"facebook", @"twitter", @"email", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *logins = [NSMutableArray array];
    
    for (NSString *loginMethod in tempArray) {
        NSString *tempString = [defaults objectForKey:loginMethod];
        if (tempString.length) {
            [logins addObject:tempString];
        }
    }
    return logins;
}

@end
