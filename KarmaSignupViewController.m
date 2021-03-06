//
//  KarmaSignupViewController.m
//  Guilt
//
//  Created by Agnt86 on 11/4/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "KarmaSignupViewController.h"

@interface KarmaSignupViewController ()

@end

@implementation KarmaSignupViewController
@synthesize userName,emailAddress,password, addUserButtonOutlet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //code to form the addUser button
    addUserButtonOutlet.layer.cornerRadius = 8;
    addUserButtonOutlet.layer.borderWidth = 1;
    addUserButtonOutlet.layer.borderColor = [UIColor whiteColor].CGColor;
    addUserButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    addUserButtonOutlet.clipsToBounds = YES;
    addUserButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:14];
    [addUserButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addUserButtonOutlet setTitle:@"Save" forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{

    [password resignFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addUser:(id)sender {
    PFUser *user = [PFUser user];
    user.username = userName.text;
    user.password = password.text;
    user.email = emailAddress.text;
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"ShowMe2Segue" sender:self];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
        }
    }];
    

}
@end
