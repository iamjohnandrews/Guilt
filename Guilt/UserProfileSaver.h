//
//  UserProfileSaver.h
//  Guilt
//
//  Created by John Andrews on 11/2/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDonationHistory.h"

@interface UserProfileSaver : NSObject 
+ (void)saveUserDonatoinHistory:(UserDonationHistory *)userDonationHistory;

+ (NSArray *)getUsersDonationHistory:(NSString *)userID;

@property (nonatomic, retain) NSString * karmaPoints;

@end
