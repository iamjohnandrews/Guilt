//
//  MyLoginViewController.h
//  Guilt
//
//  Created by Agnt86 on 11/4/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface MyLoginViewController :BaseViewController

@property (nonatomic) BOOL userIsLoggedIn;

@property (strong, nonatomic) PFLogInViewController *logInViewController;

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *loginButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *signupButtonOutlet;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *fogottenPWButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *twitterLoginButtonOutlet;

- (IBAction)didLogin:(id)sender;

- (IBAction)skipButtonPressed:(id)sender;

- (IBAction)forgottenPWButtonPressed:(id)sender;

- (IBAction)facebookLoginButtonPressed:(id)sender;

- (IBAction)twitterLoginButtonPressed:(id)sender;


@end
