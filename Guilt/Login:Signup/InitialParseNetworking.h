//
//  InitialParseNetworking.h
//  Guilt
//
//  Created by John Andrews on 9/10/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface InitialParseNetworking : NSObject
+ (instancetype) sharedManager;
- (void)getConversionNonprofitDataFromParse;

@property (strong, nonatomic) NSMutableSet *allCharitiesInfo;

@end
