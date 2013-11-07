//
//  MYViewController.m
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYViewController.h"
#import "SwitchToLoginDelegate.h"
#import "MYCustomPanel.h"
#import <Parse/Parse.h>

@interface MYViewController ()<SwitchToLoginDelegate>

@end

@implementation MYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    

    
    
}

-(void)viewDidAppear:(BOOL)animated{
    //Calling this methods builds the intro and adds it to the screen. See below.
    [self buildIntro];
    
    if ([PFUser currentUser])
    {
        [self performSegueWithIdentifier:@"ShowMeSegue2" sender:self];
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Build MYBlurIntroductionView

-(void)buildIntro{
    //Create Stock Panel with header
    UIView *headerView = [[NSBundle mainBundle] loadNibNamed:@"TestHeader" owner:nil options:nil][0];
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"      Welcome to KarmaScan!" description:@"KarmaScan is a thoughtful app that helps you find the best deals while giving back to those in need. With a built in scanner KarmaScan allows the user to shop smart while keeping humility in check." image:[UIImage imageNamed:@"donation.png"] header:headerView];
    
   // [panel1 setFont:[UIFont fontWithName:@"Times New Roman" size:22]];
    
    //Create Stock Panel With Image
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"     Scan and SAVE the World" description:@"Use our built in scanner to check for better prices online while being informed how easy it is to help others in need.  Keep tabs on your product scans and donations with the Karma Chart!" image:[UIImage imageNamed:@"karmaScan1.png"]];
    
    //Create custom panel with events
    MYCustomPanel *panel4 = [[MYCustomPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"MYCustomPanel"];
    
    panel4.delegate= self; //create delegate to go to start
    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel4];
    
    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    introductionView.delegate2 = self;
    introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
    [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:0.65]];
    
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
    
    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];
    
    //Add the introduction to your view
    [self.view addSubview:introductionView];
    
    
    
}

#pragma mark - MYIntroduction Delegate 

-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"Introduction did change to panel %d", panelIndex);
    
    //You can edit introduction view properties right from the delegate method!
    //If it is the first panel, change the color to green!
    if (panelIndex == 0) {
        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:0.65]];
    }
    //If it is the second panel, change the color to blue!
    else if (panelIndex == 1){
        [introductionView setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:0.65]];
    }
    
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    NSLog(@"Introduction did finish");
}

-(void)didGoToSignIn
{
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];

}
@end
