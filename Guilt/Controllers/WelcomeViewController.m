//
//  WelcomeViewController.m
//  Guilt
//
//  Created by John Andrews on 3/8/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"WelcomeToConversionSegue" sender:self];
    }
    
    self.introScrollView.pagingEnabled = YES;
    self.introScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, self.view.frame.size.height);
    self.introScrollView.delegate = self;
    self.navigationItem.title = @"Introduction";
    [self.leaveIntroButtonOutlet setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(141.0f, self.view.bounds.size.height - 35.0f, 40.0f, 35.0f)];  
    self.pageControl.numberOfPages = 2; 
    self.pageControl.currentPage = 0; 
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.pageControl];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarnaScan_Background"]];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    
    [self updateUI];
}

- (void)updateUI
{    
    UIView *page1 = [[UIView alloc] initWithFrame:self.view.bounds];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarmaScan logo-FJ"]];
    logo.frame = CGRectMake(self.view.bounds.origin.x + 30, self.view.bounds.origin.y, self.view.bounds.size.width - 60, 220);
    [logo clipsToBounds];
    [page1 addSubview:logo];
    
    UILabel *overallDescriptionlabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x + 15, self.view.bounds.origin.y + 105, 300, 200)];
    overallDescriptionlabel.text = @"KarmaScan helps you find the best prices while giving back to those in need. Use your iPhone's camera to scan products and shop smarter while keeping humility in check.";
    overallDescriptionlabel.font  = [overallDescriptionlabel.font fontWithSize:14.0f];
    overallDescriptionlabel.numberOfLines = 0;
    overallDescriptionlabel.textColor = [UIColor whiteColor];
    [page1 addSubview:overallDescriptionlabel];
    
    UIImageView *soldierAndNunPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donation"]];
    soldierAndNunPic.center = CGPointMake(self.view.center.x, self.view.center.y + 110);
    
    UIGraphicsBeginImageContextWithOptions(soldierAndNunPic.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:soldierAndNunPic.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(25, 25)] addClip];
    [soldierAndNunPic.image drawInRect:soldierAndNunPic.bounds];
    soldierAndNunPic.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [page1 addSubview:soldierAndNunPic];
    
    self.leaveIntroButtonOutlet.title = @"Skip";
        
    UIView *page2 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.bounds.size.height)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Scan and SAVE the World";
    titleLabel.textColor = [UIColor whiteColor];
    [page2 addSubview:titleLabel];
    
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x + 15, self.view.bounds.origin.y + 60, 300, 200)];
    instructionLabel.numberOfLines = 0;
    instructionLabel.text = @"Use your camera to scan and we'll check for better prices online, then be informed how easy it is to help others in need.  Keep tabs on your product scans and donations with the Karma Chart!" ;
    instructionLabel.textColor = [UIColor whiteColor];
    instructionLabel.font = [instructionLabel.font fontWithSize:14.0f];
    [instructionLabel sizeToFit];
    [page2 addSubview:instructionLabel];
    
    UIImageView *scannerPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karmaScan1"]];
    scannerPic.frame = CGRectMake(self.view.bounds.origin.x + 10, self.view.bounds.origin.y + 180, self.view.bounds.size.width - 20, 240);
    
    UIGraphicsBeginImageContextWithOptions(scannerPic.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:scannerPic.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(25, 25)] addClip];
    [scannerPic.image drawInRect:scannerPic.bounds];
    scannerPic.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [page2 addSubview:scannerPic];
    
    [self.introScrollView addSubview:page1];
    [self.introScrollView addSubview:page2];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.introScrollView.contentOffset.x == 320.0f) {
        self.leaveIntroButtonOutlet.title = @"Let's Go";
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageNumber = (NSInteger)round(scrollView.contentOffset.x / 320.0f);
    self.pageControl.currentPage = pageNumber;
}

- (IBAction)leaveIntroButtonPressed:(id)sender 
{
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"WelcomeToConversionSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
