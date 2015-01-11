//
//  UserDonationHistory.h
//  Guilt
//
//  Created by John Andrews on 11/2/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDonationHistory : NSObject <NSCoding>

@property (strong, nonatomic) NSDate *date;
@property (nonatomic, nonatomic) NSNumber *donationAmount;
@property (strong, nonatomic) NSString *recipientCharity;
@property (strong, nonatomic) NSString *userID;

@end
