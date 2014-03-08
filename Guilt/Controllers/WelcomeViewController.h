//
//  WelcomeViewController.h
//  Guilt
//
//  Created by John Andrews on 3/8/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *introScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
