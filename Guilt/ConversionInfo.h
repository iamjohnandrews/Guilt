//
//  ConversionInfo.h
//  Guilt
//
//  Created by John Andrews on 11/15/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversionInfo : NSObject <NSCoding>

@property (strong, nonatomic) NSString *charityName;
@property (strong, nonatomic) NSString *singularDescription;
@property (strong, nonatomic) NSString *pluralDescription;
@property (strong, nonatomic) NSNumber *conversionValue;

@end
