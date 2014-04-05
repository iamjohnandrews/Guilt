//
//  UserHistoryCell.m
//  Guilt
//
//  Created by John Andrews on 3/31/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "UserHistoryCell.h"

@implementation UserHistoryCell


- (void)awakeFromNib
{
    self.textLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:14];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.clipsToBounds = YES;
}


@end
