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
//#import <Parse/Parse.h>

@interface ConversionViewController (){
    NSMutableArray* convertedCharitableGoodsArray;
    ScannerViewController* scannerVC;
}


@end

@implementation ConversionViewController
@synthesize userEnterDollarAmountTextField, valueQuestionLabel;
@synthesize productName;
@synthesize productPrice;
@synthesize urlForProduct;

- (void)viewDidLoad
{
    valueQuestionLabel.font = [UIFont fontWithName:@"Vintage_fair" size:36];
    [super viewDidLoad];
    //code for alert message if scanner doesn't work
    scannerVC.delegate = self;
    
}

- (IBAction)scannerButton:(id)sender {
    
    
    [self performSegueWithIdentifier:@"ScannerSegue" sender:self];
    
    
    
}



- (IBAction)conversionButton:(id)sender {
    convertedCharitableGoodsArray = [NSMutableArray new];
    
    [self calculateCharitableImpactValue];
}

- (void) calculateCharitableImpactValue {
    
    float convertToFloat = [userEnterDollarAmountTextField.text floatValue];
    
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
    //NSLog(@"conversion values = %@", convertedCharitableGoodsArray);
    [userEnterDollarAmountTextField resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ConversionToImagesSegue"]) {
        ImagesViewController* imagesVC = [segue destinationViewController];
        
    imagesVC.resultOfCharitableConversionsArray = [convertedCharitableGoodsArray copy];
        
    NSLog(@"contents passed along are %@", imagesVC.resultOfCharitableConversionsArray);
    } else if ([[segue identifier] isEqualToString:@"ScannerSegue"]){
        // Get reference to the destination view controller
        ScannerViewController *svc = [segue destinationViewController];
        svc.productPrice = productPrice;
        svc.urlForProduct = urlForProduct;
        svc.productName = productName;
    }
}



@end
