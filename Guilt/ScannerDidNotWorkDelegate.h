//
//  ScannerDidNotWorkDelegate.h
//  Guilt
//
//  Created by John Andrews on 10/31/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScannerDidNotWorkDelegate <NSObject>

- (void) productDatabaseReturnedNothing;
- (void)productInfoReturned:(NSNumber*)returnedPrice name:(NSString*)returnedProductName url:(NSString*)returnedProductURL;
@end
