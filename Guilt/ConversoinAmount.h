//
//  ConversoinAmount.h
//  Guilt
//
//  Created by John Andrews on 10/25/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ConversoinAmount : NSManagedObject

@property (nonatomic, retain) NSNumber * conversionValue;
@property (nonatomic, retain) NSString * charityName;

@end
