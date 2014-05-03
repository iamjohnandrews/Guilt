//
//  ShareImageViewController.m
//  Guilt
//
//  Created by John Andrews on 5/3/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ShareImageViewController.h"
#import <Accounts/Accounts.h>

@interface ShareImageViewController ()

@end

@implementation ShareImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarnaScan_Background"]];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationItem setTitle:@"Let 'em Know"];
    [self setFontFamily:@"Quicksand-Regular" forView:self.view andSubViews:YES];
    
    self.sharingImage.image = self.unfinishedMeme;
    
    [self prepareImageToBecomeMeme];
}

- (void)prepareImageToBecomeMeme
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.sharingImage.layer.bounds;
    
    gradientLayer.colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor],
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor clearColor] CGColor]];
    gradientLayer.locations = @[@0.0, @0.1, @0.2];
    [self.sharingImage.layer addSublayer:gradientLayer];  
    
    UILabel *converstionAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 0, CGRectGetWidth(self.view.bounds) - 60.0f, 20.0f)];
    converstionAmountLabel.text = [NSString stringWithFormat:@"$%@ is equivalent to", self.productPrice];
    converstionAmountLabel.textColor = [UIColor whiteColor];
    converstionAmountLabel.textAlignment = NSTextAlignmentCenter;
    [self.sharingImage addSubview:converstionAmountLabel];
    
    UIImageView * karmaScanK = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarmaSan_K_small.png"]];
    karmaScanK.frame = CGRectMake(self.sharingImage.bounds.size.width - 44, self.sharingImage.bounds.size.height - 46, 44, 44);
    [self.sharingImage addSubview:karmaScanK];
    
    
}

- (UIImage *)convertIntoFinalMemeToShare
{
    UIGraphicsBeginImageContextWithOptions(self.sharingImage.bounds.size, self.sharingImage.opaque, 0.0);
    [self.sharingImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *charityMeme = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return charityMeme;
}


- (void)shareSetup
{
    
}

-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }     
} 

@end
