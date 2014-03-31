//
//  CharityAndProductDisplayCell.m
//  Guilt
//
//  Created by John Andrews on 10/30/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "CharityAndProductDisplayCell.h"
#import "ImagesViewController.h"

@implementation CharityAndProductDisplayCell
@synthesize charityConversionDetailsLabel, donationButton;


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setCharity:(Charity *)charity
{
    _charity = charity;
    [self updateUI];
}

- (void)updateUI
{
    self.charityConversionDetailsLabel.font = [UIFont fontWithName:@"Quicksand-Bold" size:15];
    self.charityConversionDetailsLabel.textColor = [UIColor whiteColor];
    self.charityConversionDetailsLabel.layer.cornerRadius = 9;
    self.charityConversionDetailsLabel.shadowColor = [UIColor blackColor];
    self.charityConversionDetailsLabel.shadowOffset = CGSizeMake(1, 1);
    
    int randomNumber = arc4random() % self.charity.Images.count - 1;
    self.displayImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.charity.Images objectAtIndex:randomNumber]]]];
        
    self.donationButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donate.png"]];
    self.accessoryView = self.donationButton;
    
    [self.donationButton setUserInteractionEnabled:YES];
    
}

@end
