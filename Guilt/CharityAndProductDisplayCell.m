//
//  CharityAndProductDisplayCell.m
//  Guilt
//
//  Created by John Andrews on 10/30/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "CharityAndProductDisplayCell.h"
#import "CharityImage.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface CharityAndProductDisplayCell ()

@end

@implementation CharityAndProductDisplayCell
@synthesize charityConversionDetailsLabel, dollarAmountConvertedLabel;

- (void)updateUI
{
    self.displayImageView.userInteractionEnabled = NO;
    self.charityConversionDetailsLabel.textColor = [UIColor whiteColor];
    
    CAGradientLayer *bottomGradientLayer = [CAGradientLayer layer];
    bottomGradientLayer.frame = self.displayImageView.layer.bounds;
    
    bottomGradientLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor]];
    bottomGradientLayer.locations = @[@0.45, @0.8, @1.0];
    [self.displayImageView.layer addSublayer:bottomGradientLayer]; 
    
    CAGradientLayer *topGradientLayer = [CAGradientLayer layer];
    topGradientLayer.frame = self.displayImageView.layer.bounds;
    
    topGradientLayer.colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor],
                                (id)[[UIColor clearColor] CGColor],
                                (id)[[UIColor clearColor] CGColor]];
    
    topGradientLayer.locations = @[@0.0, @0.075, @0.3];
    [self.displayImageView.layer addSublayer:topGradientLayer];
    
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = 10.0f;
    self.logoImageView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.logoImageView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.logoImageView.userInteractionEnabled = NO;
    [self bringSubviewToFront:self.logoImageView];
    

    //Button setup
    self.shareButtonOutlet.layer.cornerRadius = 8;
    self.shareButtonOutlet.layer.borderWidth = 1;
    self.shareButtonOutlet.layer.borderColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1].CGColor;
    self.shareButtonOutlet.backgroundColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    self.shareButtonOutlet.clipsToBounds = YES;
    [self.shareButtonOutlet setTitle:@"SHARE" forState:UIControlStateNormal];
    self.shareButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
    
    self.donateButtonOutlet.layer.cornerRadius = 8;
    self.donateButtonOutlet.layer.borderWidth = 1;
    self.donateButtonOutlet.layer.borderColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1].CGColor;
    self.donateButtonOutlet.backgroundColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    self.donateButtonOutlet.clipsToBounds = YES;
    [self.donateButtonOutlet setTitle:@"DONATE" forState:UIControlStateNormal];
    self.donateButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
}


@end
