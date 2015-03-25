//
//  KarmaSignupViewController.m
//  Guilt
//
//  Created by Agnt86 on 11/4/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "KarmaSignupViewController.h"

@interface KarmaSignupViewController () <UITextFieldDelegate>

@end

@implementation KarmaSignupViewController
@synthesize userName,emailAddress,password, addUserButtonOutlet;


-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (userName.text.length && emailAddress.text.length && password.text.length) {
        addUserButtonOutlet.hidden = NO;
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    userName.delegate = self;
    emailAddress.delegate = self;
    password.delegate = self;
    self.screenName = @"SignupViewController";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [GoogleAnalytics trackAnalyticsForScreen:self.screenName];
}

- (IBAction)addUser:(id)sender 
{
    UIButton *saveNewUser = sender;
    if ([saveNewUser.titleLabel.text isEqualToString:@"Save"]) {
        PFUser *user = [PFUser user];
        user.username = userName.text;
        user.password = password.text;
        user.email = emailAddress.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [UsersLoginInfo saveLoginInfoToNSUserDefaults:@"email" and:[[PFUser currentUser] objectId]];

                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"This is what went wrong, %@", errorString);
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"SignUp did not work"
                                                                message:@"Please try again. Sorry for the manual labor." 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Got It" 
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
    [GoogleAnalytics trackAnalyticsForAction:@"touch" withLabel:self.addUserButtonOutlet.titleLabel.text onScreen:self.screenName];
}

- (void)setupUI
{
    password.secureTextEntry = YES;
    
    //code to form the addUser button
    addUserButtonOutlet.layer.cornerRadius = 8;
    addUserButtonOutlet.layer.borderWidth = 1;
    addUserButtonOutlet.layer.borderColor = [UIColor whiteColor].CGColor;
    addUserButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    addUserButtonOutlet.clipsToBounds = YES;
    addUserButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:14];
    [addUserButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addUserButtonOutlet setTitle:@"Save" forState:UIControlStateNormal];
    addUserButtonOutlet.hidden = YES;
    
    self.cancelSignupButtonOutlet.layer.cornerRadius = 8;
    self.cancelSignupButtonOutlet.layer.borderWidth = 1;
    self.cancelSignupButtonOutlet.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cancelSignupButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    self.cancelSignupButtonOutlet.clipsToBounds = YES;
    self.cancelSignupButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:14];
    [self.cancelSignupButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelSignupButtonOutlet setTitle:@"Cancel" forState:UIControlStateNormal];
    
    userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (IBAction)cancelSignupButtonPressed:(id)sender 
{
    [GoogleAnalytics trackAnalyticsForAction:@"touch" withLabel:self.cancelSignupButtonOutlet.titleLabel.text onScreen:self.screenName];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
