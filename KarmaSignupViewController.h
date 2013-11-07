//
//  KarmaSignupViewController.h
//  Guilt
//
//  Created by Agnt86 on 11/4/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface KarmaSignupViewController :UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *emailAddress;

@property (weak, nonatomic) IBOutlet UIButton *addUserButtonOutlet;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)addUser:(id)sender;

@end
