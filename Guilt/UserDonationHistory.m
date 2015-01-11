//
//  UserDonationHistory.m
//  Guilt
//
//  Created by John Andrews on 11/2/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "UserDonationHistory.h"

@implementation UserDonationHistory

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.userID = [decoder decodeObjectForKey:@"userID"];
    self.recipientCharity = [decoder decodeObjectForKey:@"recipientCharity"];
    self.date = [decoder decodeObjectForKey:@"date"];
    self.donationAmount = [decoder decodeObjectForKey:@"donationAmount"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.recipientCharity forKey:@"recipientCharity"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.donationAmount forKey:@"donationAmount"];
}

@end
