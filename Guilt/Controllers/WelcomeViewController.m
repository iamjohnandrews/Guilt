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
	
    [self createIntroPageOne];
    
    self.introScrollView.pagingEnabled = YES;
    self.introScrollView.contentSize = CGSizeMake(640.0, 400.0);
    self.introScrollView.delegate = self;
}

- (void)createIntroPageOne
{
    UIView *page1 = [[UIView alloc] initWithFrame:self.view.bounds];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageWithContentsOfFile:@"KarmaScan logo-Fj"];
    logo.center = CGPointMake(self.view.center.x, self.view.center.y - 250);
    [page1 addSubview:logo];
    
    UILabel *overallDescriptionlabel = [[UILabel alloc] init];
    overallDescriptionlabel.text = @"KarmaScan is a thoughtful app that helps you find the best deals while giving back to those in need. With a built in scanner KarmaScan allows the user to shop smart while keeping humility in check.";
    overallDescriptionlabel.numberOfLines = 0;
    overallDescriptionlabel.textColor = [UIColor redColor];
    [overallDescriptionlabel sizeToFit];
    overallDescriptionlabel.center = CGPointMake(self.view.center.x, self.view.center.y - 150);
    [page1 addSubview:overallDescriptionlabel];
    
    UIImageView *soldierAndNunPic = [[UIImageView alloc] init];
    soldierAndNunPic.image = [UIImage imageWithContentsOfFile:@"donation"];
    soldierAndNunPic.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    [page1 addSubview:soldierAndNunPic];
    
    [self.introScrollView addSubview:page1];
    [self createIntroPageTwo];
}

- (void)createIntroPageTwo
{
    UIView *page2 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.bounds.size.height)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Scan and SAVE the World";
    titleLabel.textColor = [UIColor redColor];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 210);
    [page2 addSubview:titleLabel];

    UILabel *instructionLabel = [[UILabel alloc]init];
    instructionLabel.text = @"Use our built in scanner to check for better prices online while being informed how easy it is to help others in need.  Keep tabs on your product scans and donations with the Karma Chart!" ;
    instructionLabel.textColor = [UIColor redColor];
    [instructionLabel sizeToFit];
    instructionLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 180);
    [page2 addSubview:instructionLabel];
    
    UIImageView *scannerPic = [[UIImageView alloc] init];
    scannerPic.image = [UIImage imageWithContentsOfFile:@"karmaScan1"];
    scannerPic.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    [page2 addSubview:scannerPic];
    
    [self.introScrollView addSubview:page2];
}

@end
