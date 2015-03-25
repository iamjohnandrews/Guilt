//
//  ConversionSaver.h
//  Guilt
//
//  Created by John Andrews on 10/25/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CharityImage.h"

@interface ConversionSaver : NSObject 
- (void)saveCharityNamesToNSUserDefaults:(NSMutableArray *)names;

- (void)saveSpecificCharityConversionInfo:(NSArray *)charitysDetailsArray;

- (NSArray *)getsAllCharityConversionInfo;

- (BOOL)charityConversionInfoAlreadySavedToDisk:(NSString *)charityName;

@end
