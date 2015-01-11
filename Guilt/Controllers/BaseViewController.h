//
//  BaseViewController.h
//  Guilt
//
//  Created by John Andrews on 3/8/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GAITrackedViewController.h"
#import "UsersLoginInfo.h"

@interface BaseViewController : GAITrackedViewController 
@property (nonatomic) BOOL userIsLoggedIn;

@end
