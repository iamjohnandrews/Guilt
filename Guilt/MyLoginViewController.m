//
//  MyLoginViewController.m
//  Guilt
//
//  Created by Agnt86 on 11/4/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//
#import "ConversionViewController.h"
#import "MyLoginViewController.h"

@interface MyLoginViewController ()

@end

@implementation MyLoginViewController
@synthesize userName, password, loginButtonOutlet, signupButtonOutlet;


- (void)viewDidLoad
{
    NSLog(@"In viewdidload");
    
    [super viewDidLoad];
    //code to form the login button
    loginButtonOutlet.layer.cornerRadius = 8;
    loginButtonOutlet.layer.borderWidth = 1;
    loginButtonOutlet.layer.borderColor = [UIColor whiteColor].CGColor;
    loginButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    loginButtonOutlet.clipsToBounds = YES;
    loginButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:14];
    [loginButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButtonOutlet setTitle:@"login" forState:UIControlStateNormal];
    
    //code to form the signup login
    signupButtonOutlet.layer.cornerRadius = 8;
    signupButtonOutlet.layer.borderWidth = 1;
    signupButtonOutlet.layer.borderColor = [UIColor whiteColor].CGColor;
    signupButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    signupButtonOutlet.clipsToBounds = YES;
    signupButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:14];
    [signupButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signupButtonOutlet setTitle:@"signup" forState:UIControlStateNormal];
    
    [self.skipButtonOutlet setTitle:@"Skip"];
    
    [self.navigationItem setTitle:@"Login"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowMeSegue"]) {
        ConversionViewController *conversionVC = (ConversionViewController *)segue.destinationViewController;
        conversionVC.userIsLoggedIn = self.userIsLoggedIn;
    }
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    if ([PFUser currentUser])
//    {
//        self.userIsLoggedIn = YES;        
//        [self performSegueWithIdentifier:@"ShowMeSegue" sender:self];
//    }
//}


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

@end
