//
//  ConversionViewController.m
//  Guilt
//
//  Created by John Andrews on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "ConversionViewController.h"

@interface ConversionViewController ()

@end

@implementation ConversionViewController
@synthesize userEnterDollarAmountTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [userEnterDollarAmountTextField setFont:[UIFont fontWithName:@"Vintage_fair" size:36]];
    
    [super viewDidLoad];

}

@end
