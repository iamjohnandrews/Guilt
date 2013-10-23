//
//  ViewController.h
//  Guilt
//
//  Created by John Andrews on 10/23/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userEnterDollarAmountTextField;

@property (weak, nonatomic) IBOutlet UITextField *charityImpactValueTextField;

- (IBAction)conversionButton:(id)sender;

@end
