//
//  WelcomeViewController.h
//  Guilt
//
//  Created by John Andrews on 3/8/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//
#import "BaseViewController.h"
#import <UIKit/UIKit.h>

@interface WelcomeViewController : BaseViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *introScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leaveIntroButtonOutlet;
- (IBAction)leaveIntroButtonPressed:(id)sender;

@end
