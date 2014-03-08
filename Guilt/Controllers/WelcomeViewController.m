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
    
    self.introScrollView.pagingEnabled = YES;
    self.introScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, self.view.frame.size.height);
    self.introScrollView.delegate = self;
    self.navigationItem.title = @"Introduction";
    
    //add background
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarnaScan_Background"]];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    
    [self updateUI];
}

- (void)updateUI
{
    UIView *page1 = [[UIView alloc] initWithFrame:self.view.bounds];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarmaScan logo-Fj"]];
    logo.center = CGPointMake(self.view.center.x, self.view.center.y - 250);
    [page1 addSubview:logo];
    
    UILabel *overallDescriptionlabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y - 150, 300, 100)];
    overallDescriptionlabel.text = @"KarmaScan is a thoughtful app that helps you find the best deals while giving back to those in need. With a built in scanner KarmaScan allows the user to shop smart while keeping humility in check.";
    overallDescriptionlabel.numberOfLines = 0;
    overallDescriptionlabel.textColor = [UIColor whiteColor];
    overallDescriptionlabel.center = CGPointMake(self.view.center.x, self.view.center.y - 150);
    [page1 addSubview:overallDescriptionlabel];
    
    UIImageView *soldierAndNunPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donation"]];
    soldierAndNunPic.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    [page1 addSubview:soldierAndNunPic];
    
    self.leaveIntroButtonOutlet.title = @"Skip";
        
    UIView *page2 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.bounds.size.height)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Scan and SAVE the World";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 210);
    [page2 addSubview:titleLabel];
    
    UILabel *instructionLabel = [[UILabel alloc]init];
    instructionLabel.text = @"Use our built in scanner to check for better prices online while being informed how easy it is to help others in need.  Keep tabs on your product scans and donations with the Karma Chart!" ;
    instructionLabel.textColor = [UIColor whiteColor];
    [instructionLabel sizeToFit];
    instructionLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 180);
    [page2 addSubview:instructionLabel];
    
    UIImageView *scannerPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karmaScan1"]];
    scannerPic.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    [page2 addSubview:scannerPic];
    
    [self.introScrollView addSubview:page1];
    [self.introScrollView addSubview:page2];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.leaveIntroButtonOutlet.title = @"Let's Go";
}

- (IBAction)leaveIntroButtonPressed:(id)sender 
{
    [self performSegueWithIdentifier:@"WelcomeToConversionSegue" sender:self];
}
@end
