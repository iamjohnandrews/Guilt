//
//  DonationHistory.h
//  Guilt
//
//  Created by John Andrews on 9/30/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DonationHistory : NSManagedObject
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * karmaPoints;
@property (nonatomic, retain) NSString * recipientCharity;
@property (nonatomic, retain) NSData * charityLogo;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic) float donationAmount;

@end
