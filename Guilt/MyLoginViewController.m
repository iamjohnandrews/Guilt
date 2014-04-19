//
//  MyLoginViewController.m
//  Guilt
//
//  Created by Agnt86 on 11/4/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//
#import "ConversionViewController.h"
#import "MyLoginViewController.h"

@interface MyLoginViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *emailTextField;
@end

@implementation MyLoginViewController
@synthesize userName, password, loginButtonOutlet, signupButtonOutlet;


- (void)viewDidLoad
{  
    [super viewDidLoad];

    [self setupUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tap];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowMeSegue"]) {
        ConversionViewController *conversionVC = (ConversionViewController *)segue.destinationViewController;
        conversionVC.userIsLoggedIn = self.userIsLoggedIn;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"ShowMeSegue" sender:self];
    }
}

- (IBAction)didLogin:(id)sender {
    NSString *user = userName.text;
    NSString *passwd = password.text;
        
    if ([user length] < 2 || [passwd length] < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Make sure you fill out all of the information!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        [PFUser logInWithUsernameInBackground:user password:passwd block:^(PFUser *user, NSError *error) {
            if (user) {
                self.userIsLoggedIn = YES;
                [self performSegueWithIdentifier:@"ShowMeSegue" sender:self];
            } else {
                NSLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"Invalid Username and/or Password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (IBAction)skipButtonPressed:(id)sender 
{
    [self performSegueWithIdentifier:@"ShowMeSegue" sender:self];
}

- (IBAction)forgottenPWButtonPressed:(id)sender 
{
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 360, 300, 40)];
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.font = [UIFont systemFontOfSize:15];
    self.emailTextField.placeholder = @"enter email";
    self.emailTextField.keyboardType = UIKeyboardTypeDefault;
    self.emailTextField.returnKeyType = UIReturnKeyDone;
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTextField.delegate = self;
    [self.view addSubview:self.emailTextField];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
    self.fogottenPWButtonOutlet.hidden = YES;
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = -keyboardSize.height;
  
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame = newFrame;
                         }
                    completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    CGRect newFrame = self.view.frame;
    
    newFrame.origin.y = 0.0f;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame = newFrame;
                     } completion:nil];
    
    [self unregisterKeyboardNotification];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.emailTextField endEditing:YES];
    [PFUser requestPasswordResetForEmailInBackground:textField.text];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Password"
                                                    message:@"Check your email for a link to reset your password."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    return YES;
}

- (void)dismissAlertView:(UIAlertView *)alertView
{
    self.emailTextField.text = nil;
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)unregisterKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI
{
    //code to form the login button
    loginButtonOutlet.layer.cornerRadius = 8;
    loginButtonOutlet.layer.borderWidth = 1;
    loginButtonOutlet.layer.borderColor = [UIColor whiteColor].CGColor;
    loginButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    loginButtonOutlet.clipsToBounds = YES;
    loginButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:18];
    [loginButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButtonOutlet setTitle:@"login" forState:UIControlStateNormal];
    
    //code to form the signup login
    signupButtonOutlet.layer.cornerRadius = 8;
    signupButtonOutlet.layer.borderWidth = 1;
    signupButtonOutlet.layer.borderColor = [UIColor whiteColor].CGColor;
    signupButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    signupButtonOutlet.clipsToBounds = YES;
    signupButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:18];
    [signupButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signupButtonOutlet setTitle:@"signup" forState:UIControlStateNormal];
    
    [self.skipButtonOutlet setTitle:@"Skip"];
    
    [self.navigationItem setTitle:@"Login"];
}

@end
