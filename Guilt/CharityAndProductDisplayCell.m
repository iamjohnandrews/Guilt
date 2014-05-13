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
@synthesize charityConversionDetailsLabel, donationButton;


- (void)setCharity:(Charity *)charity
{
    _charity = charity;
//    [self updateUI];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.displayImageView.clipsToBounds = YES;    
    
}

- (void)setImage:(CharityImage *)image
{
    _image = image;
    [self updateUI];
}

- (void)updateUI
{
    [self.displayImageView setImageWithURL:self.image.imageUrl
                       placeholderImage:nil];
    
    self.charityConversionDetailsLabel.textColor = [UIColor whiteColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.layer.bounds;
    
    gradientLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor]];
    gradientLayer.locations = @[@0.4, @0.7, @1.0];
    [self.displayImageView.layer addSublayer:gradientLayer]; 
    
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = 10.0f;
    self.logoImageView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.logoImageView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    [self bringSubviewToFront:self.logoImageView];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
