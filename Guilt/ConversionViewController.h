//
//  ConversionViewController.h
//  Guilt
//
//  Created by John Andrews on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScannerDidNotWorkDelegate.h"
#import "ScannerViewController.h"

@interface ConversionViewController : UIViewController <ScannerDidNotWorkDelegate>

@property (weak, nonatomic) IBOutlet UILabel *valueQuestionLabel;

@property (weak, nonatomic) IBOutlet UITextField *userEnterDollarAmountTextField;

@property   (weak,nonatomic)NSString* productName;

@property   (nonatomic)float productPrice;

@property   (weak,nonatomic)NSString* urlForProduct;


- (IBAction)scannerButton:(id)sender;

- (IBAction)conversionButton:(id)sender;

@end
