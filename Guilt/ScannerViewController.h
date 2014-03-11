//
//  ScannerViewController.h
//  Guilt
//
//  Created by Agnt86 on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScannerDidNotWorkDelegate.h"

@interface ScannerViewController : BaseViewController 
@property   (weak,nonatomic)NSString* productName;
@property   (nonatomic)float productPrice;
@property   (weak,nonatomic)NSString* urlForProduct;
@property   (nonatomic, weak) id <ScannerDidNotWorkDelegate> delegate;

@end
