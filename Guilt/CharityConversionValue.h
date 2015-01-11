//
//  CharityConversionValue.h
//  Guilt
//
//  Created by John Andrews on 11/5/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharityConversionValue : NSObject <NSCoding>
@property (nonatomic, nonatomic) NSNumber *conversionValue;
@property (strong, nonatomic) NSString *charityName;
@end
