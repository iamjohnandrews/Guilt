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

@implementation CharityAndProductDisplayCell
@synthesize charityConversionDetailsLabel, dollarAmountConvertedLabel;


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.displayImageView.clipsToBounds = YES;    
    
    [self updateUI];
}

- (void)updateUI
{
    self.charityConversionDetailsLabel.textColor = [UIColor whiteColor];
    
    CAGradientLayer *bottomGradientLayer = [CAGradientLayer layer];
    bottomGradientLayer.frame = self.layer.bounds;
    
    bottomGradientLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor]];
    bottomGradientLayer.locations = @[@0.4, @0.7, @1.0];
    [self.displayImageView.layer addSublayer:bottomGradientLayer]; 
    
    CAGradientLayer *topGradientLayer = [CAGradientLayer layer];
    topGradientLayer.frame = self.layer.bounds;
    
    topGradientLayer.colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor],
                                (id)[[UIColor clearColor] CGColor],
                                (id)[[UIColor clearColor] CGColor]];
    
    topGradientLayer.locations = @[@0.0, @0.075, @0.25];
    [self.displayImageView.layer addSublayer:topGradientLayer];
    
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = 10.0f;
    self.logoImageView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.logoImageView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    [self bringSubviewToFront:self.logoImageView];
        
}

@end
