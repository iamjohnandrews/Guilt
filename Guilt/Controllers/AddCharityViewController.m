//
//  AddCharityViewController.m
//  Guilt
//
//  Created by John Andrews on 8/24/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "AddCharityViewController.h"

@interface AddCharityViewController ()

@end

@implementation AddCharityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray * items;
    NSMutableString * bulletList = [NSMutableString stringWithCapacity:items.count*30];
    for (NSString * s in items)
    {
        [bulletList appendFormat:@"\u2022 %@\n", s];
    }
    self.instructionsTextView.text = bulletList;
}



@end
