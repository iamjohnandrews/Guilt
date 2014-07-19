//
//  MyLoginViewController.m
//  Guilt
//
//  Created by Agnt86 on 11/4/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//
#import "ConversionViewController.h"
#import "MyLoginViewController.h"
#import "Comms.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PFTwitterUtils+NativeTwitter.h"
#import "TwitterClient.h"
#import "FHSTwitterEngine.h"

@interface MyLoginViewController () <UITextFieldDelegate, CommsDelegate, UIActionSheetDelegate, TwitterDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *twitterAccounts;

@end

@implementation MyLoginViewController
@synthesize userName, password, loginButtonOutlet, signupButtonOutlet;


- (void)viewDidLoad
{  
    [super viewDidLoad];

    [self setupUI];    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tap];
    NSLog(@"twitterLoginButtonOutlet measurements =%@", NSStringFromCGRect(self.twitterLoginButtonOutlet.frame));
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
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 300, 300, 40)];
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.font = [UIFont systemFontOfSize:15];
    self.emailTextField.placeholder = @"Enter email. CASE matters";
    self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailTextField.keyboardType = UIKeyboardTypeDefault;
    self.emailTextField.returnKeyType = UIReturnKeyDone;
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTextField.delegate = self;
    [self.view addSubview:self.emailTextField];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
}

#pragma mark - Facebook Login
- (IBAction)facebookLoginButtonPressed:(id)sender 
{
    [self.facebookLoginButtonOutlet setEnabled:NO];
    
    [self displayUIActivityIndicatorView];
    
    [Comms login:self];
}

- (void) commsDidLogin:(BOOL)loggedIn
{
	[self.facebookLoginButtonOutlet setEnabled:YES];
    
	// Stop the activity indicator
	[self.activityIndicator stopAnimating];
    
	// Did we login successfully ?
	if (loggedIn) {
		self.userIsLoggedIn = YES;
		[self performSegueWithIdentifier:@"ShowMeSegue" sender:self];
	} else {
		// Show error alert
		[[[UIAlertView alloc] initWithTitle:@"Facebook Login Failed"
                                    message:@"Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
	}
}

#pragma mark - Twitter Login methods

- (IBAction)twitterLoginButtonPressed:(id)sender 
{
    [self.twitterLoginButtonOutlet setEnabled:NO];
    [self displayUIActivityIndicatorView];

    __weak MyLoginViewController *weakSelf = self;
    [PFTwitterUtils getTwitterAccounts:^(BOOL accountsWereFound, NSArray *twitterAccounts) {
        [weakSelf handleTwitterAccounts:twitterAccounts];
    }];
}

- (void)userDidLogIntoTwitter:(BOOL)loggedIn 
{
	[self.twitterLoginButtonOutlet setEnabled:YES];
    
	[self.activityIndicator stopAnimating];
    
	if (loggedIn) {
		self.userIsLoggedIn = YES;
		[self performSegueWithIdentifier:@"ShowMeSegue" sender:self];
	} else {
		[[[UIAlertView alloc] initWithTitle:@"Twitter Login Failed"
                                    message:@"Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
	}
}

- (void)handleTwitterAccounts:(NSArray *)twitterAccounts
{
    switch ([twitterAccounts count]) {
        case 0:
        {
            [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:TWITTER_CONSUMER_KEY andSecret:TWITTER_CONSUMER_SECRET];
            UIViewController *loginController = [[FHSTwitterEngine sharedEngine] loginControllerWithCompletionHandler:^(BOOL success) {
                if (success) {
                    [TwitterClient loginUserWithTwitterEngine:self];
                }
            }];
            [self presentViewController:loginController animated:YES completion:nil];
            
        }
            break;
        case 1:
            [self onUserTwitterAccountSelection:twitterAccounts[0]];
            break;
        default:
            self.twitterAccounts = twitterAccounts;
            [self displayTwitterAccounts:twitterAccounts];
            break;
    }
    
}

- (void)displayTwitterAccounts:(NSArray *)twitterAccounts
{
    __block UIActionSheet *selectTwitterAccountsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Twitter Account"
                                                                                          delegate:self
                                                                                 cancelButtonTitle:nil
                                                                            destructiveButtonTitle:nil
                                                                                 otherButtonTitles:nil];
    
    [twitterAccounts enumerateObjectsUsingBlock:^(id twitterAccount, NSUInteger idx, BOOL *stop) {
        [selectTwitterAccountsActionSheet addButtonWithTitle:[twitterAccount username]];
    }];
    selectTwitterAccountsActionSheet.cancelButtonIndex = [selectTwitterAccountsActionSheet addButtonWithTitle:@"Cancel"];
    
    [selectTwitterAccountsActionSheet showInView:self.view];
}

- (void)onUserTwitterAccountSelection:(ACAccount *)twitterAccount
{
    [TwitterClient loginUserWithAccount:twitterAccount shit:self];
}

#pragma mark - UIActionSheet & UIActivityIndicatorView

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self onUserTwitterAccountSelection:self.twitterAccounts[buttonIndex]];
    }
}

- (void)displayUIActivityIndicatorView
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x - 15.0f, self.view.bounds.origin.y + self.navigationController.navigationBar.frame.size.height + 2, 50, 50)];
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator]; 
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
    
    if (self.emailTextField.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Password"
                                                        message:@"Check your email for a link to reset your password."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You forget something?"
                                                        message:@"You must input an email address"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"My Bad", nil];
        [alert show];
    }
    
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    [self.emailTextField removeFromSuperview];
    self.fogottenPWButtonOutlet.hidden = NO;
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
