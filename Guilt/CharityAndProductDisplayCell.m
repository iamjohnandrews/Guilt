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


- (void)setCharity:(Charity *)charity
{
    _charity = charity;
    [self updateUI];
}

- (void)updateUI
{
    self.charityConversionDetailsLabel.font = [UIFont fontWithName:@"Quicksand-Bold" size:15];
    self.charityConversionDetailsLabel.textColor = [UIColor whiteColor];
    
    self.donationButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donate.png"]];
    self.donationButton.frame = CGRectMake(self.bounds.size.width - 44, self.bounds.size.height - 46, 44, 44);
    [self.donationButton setUserInteractionEnabled:YES];
        
//    if (!self.displayImageView.image) {
//        int randomNumber = arc4random() % (self.charity.Images.count - 1);
//        self.displayImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.charity.Images objectAtIndex:randomNumber]]]];
//        self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.displayImageView.clipsToBounds = YES;
//    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.layer.bounds;
    
    gradientLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor]];
    gradientLayer.locations = @[@0.3, @0.6, @1.0];
    [self.displayImageView.layer addSublayer:gradientLayer];  
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.displayImageView.clipsToBounds = YES;    
    
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = 10.0f;
    self.logoImageView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.logoImageView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    [self bringSubviewToFront:self.logoImageView];
}

@end
