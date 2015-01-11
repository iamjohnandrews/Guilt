//
//  UsersLoginInfo.h
//  Guilt
//
//  Created by John Andrews on 11/1/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsersLoginInfo : NSObject
+ (void)saveLoginInfoToNSUserDefaults:(NSString *)loginMethod and:(NSString*)objectID;
+ (BOOL)checkIfLoginInfoAlreadySaved:(NSString *)loginMethod;
+ (NSArray *)getUsersObjectID;
@end
