//
//  ConversionViewController.m
//  Guilt
//
//  Created by John Andrews on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "ConversionViewController.h"
#import "ImagesViewController.h"
#import "ScannerViewController.h"
#import <Parse/Parse.h>

@interface ConversionViewController (){
    NSMutableArray* convertedCharitableGoodsArray;
}


@end

@implementation ConversionViewController
@synthesize userEnterDollarAmountTextField, valueQuestionLabel, progressActivityIndicatorSpinner;
@synthesize productName;
@synthesize productPrice;
@synthesize urlForProduct;

- (void)viewDidLoad
{
    valueQuestionLabel.font = [UIFont fontWithName:@"Vintage_fair" size:36];
    [super viewDidLoad];
        
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.hidesBackButton = YES;

}

- (IBAction)scannerButton:(id)sender {
    
    
    [self performSegueWithIdentifier:@"ScannerSegue" sender:self];
    
    
    
}



- (IBAction)conversionButton:(id)sender {
    
    [self calculateCharitableImpactValue:[NSNumber numberWithFloat:[userEnterDollarAmountTextField.text floatValue]]];
}

- (void) calculateCharitableImpactValue:(NSNumber*)dollarAmount {
    
    float convertToFloat = [dollarAmount floatValue];
    
    convertedCharitableGoodsArray = [NSMutableArray new];

    //logic to compare scanner/user's entry to Charities' conversions
    if (convertToFloat >= 1) {
        float numberOfAnimalMeals = (convertToFloat / 1) * 20;
        NSLog(@"Number of animal meals = %.2f", numberOfAnimalMeals);
        NSString* floatToAString1 = [NSString stringWithFormat:@"%.2f", numberOfAnimalMeals];
        [convertedCharitableGoodsArray addObject:floatToAString1];
    }
    if (convertToFloat >= 10) {
        float numberOfMonthsHelpingChildren = convertToFloat / 10;
        NSLog(@"number of months = %.2f", numberOfMonthsHelpingChildren);
        NSString* floatToAString10 = [NSString stringWithFormat:@"%.2f",numberOfMonthsHelpingChildren];
        [convertedCharitableGoodsArray addObject:floatToAString10];
    }
    if (convertToFloat >= 19) {
        float numberOfMonthsToFeedChildren = convertToFloat / 19;
        NSLog(@"Number of Months = %.2f", numberOfMonthsToFeedChildren);
        NSString* floatToAString19 = [NSString stringWithFormat:@"%.2f",numberOfMonthsToFeedChildren];
        [convertedCharitableGoodsArray addObject:floatToAString19];
    }
    if (convertToFloat >= 50) {
        float numberOfCarePackages = convertToFloat / 50;
        NSLog(@"Number of care packages is %.2f", numberOfCarePackages);
        NSString* floatToAString50 = [NSString stringWithFormat:@"%.2f",numberOfCarePackages];
        [convertedCharitableGoodsArray addObject:floatToAString50];
    }
    if (convertToFloat >= 500) {
        float numberOfSpringCatchments = convertToFloat / 500;
        NSLog(@"Number of Natiral Spring Cathcments %.2f", numberOfSpringCatchments);
        NSString* floatToAString500 = [NSString stringWithFormat:@"%.2f",numberOfSpringCatchments];
        [convertedCharitableGoodsArray addObject:floatToAString500];
    }
    NSLog(@"conversion values = %@", convertedCharitableGoodsArray);
    [userEnterDollarAmountTextField resignFirstResponder];
    
    [self performSegueWithIdentifier:@"ConversionToImagesSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ConversionToImagesSegue"]) {
        ImagesViewController* imagesVC = [segue destinationViewController];
        imagesVC.resultOfCharitableConversionsArray = [convertedCharitableGoodsArray copy];

        ScannerViewController *svc = [segue destinationViewController];
        productPrice = svc.productPrice;
        urlForProduct = svc.urlForProduct;
        productName = svc.productName;
    NSLog(@"contents passed along are %@", imagesVC.resultOfCharitableConversionsArray);
    } else if ([[segue identifier] isEqualToString:@"ScannerSegue"]){
        // Get reference to the destination view controller
        ScannerViewController *svc = [segue destinationViewController];
        productPrice = svc.productPrice;
        urlForProduct = svc.urlForProduct;
        productName = svc.productName;
        
        svc.delegate = self;
        //@JR how did you envision this segue working? It looks like you want it to "work" both ways?
    }
}

-(void)productDatabaseReturnedNothing
{
    NSLog(@"the productDatabaseReturnedNothing method is firing!");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Scan Did Not Work" message:@"Please input price into text field. Sorry for the manual labor." delegate:self cancelButtonTitle:@"Got It" otherButtonTitles:nil];
    [alert show];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)productInfoReturned:(NSNumber*)returnedPrice 
{
    NSLog(@"Get Hype, Product name = %@, URL = %@, Product Price = %@", productName, urlForProduct, returnedPrice);
    
    [self calculateCharitableImpactValue:returnedPrice];
    
   // NSLog(@"the url passed through is %@", urlForProduct);
    
}



@end
