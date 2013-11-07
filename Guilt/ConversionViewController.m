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
#import "ProductDisplayCell.h"

@interface ConversionViewController (){
    NSMutableArray* convertedCharitableGoodsArray;
    NSNumber* convertedProductPrice;
}

@end

@implementation ConversionViewController
@synthesize userEnterDollarAmountTextField, valueQuestionLabel, orLabel, backToIntroductionButtonOutlet;
@synthesize conversionButtonOutlet, scannerButtonOutlet;
@synthesize productName;
@synthesize productPrice;
@synthesize urlForProduct;

- (void)viewDidLoad
{
//code to change color of nav bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"KarnaScan_NavBar.png"] forBarMetrics:UIBarMetricsDefault];
    
//code to set background to png Image    
    /*
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarnaScan_Background.png"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage]; */

    valueQuestionLabel.font = [UIFont fontWithName:@"Quicksand-Bold" size:20];
    valueQuestionLabel.textColor = [UIColor colorWithRed:117/255 green:135/255 blue:146/255 alpha:1];
    valueQuestionLabel.text = @"Find the best price & discover your charitable impact";
    
    orLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:25];
    orLabel.textColor = [UIColor colorWithRed:215/255 green:231/255 blue:241/255 alpha:1];
    
    backToIntroductionButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:15];
    [backToIntroductionButtonOutlet setTitleColor:[UIColor colorWithRed:117/255 green:135/255 blue:146/255 alpha:1] forState:UIControlStateNormal];
    [backToIntroductionButtonOutlet setTitle:@"Back to Introduction" forState:UIControlStateNormal];    
    
    scannerButtonOutlet.layer.cornerRadius = 8;
    scannerButtonOutlet.layer.borderWidth = 1;
    scannerButtonOutlet.layer.borderColor = [UIColor whiteColor].CGColor;
    scannerButtonOutlet.backgroundColor = [UIColor colorWithRed:117/255 green:135/255 blue:146/255 alpha:1];
    scannerButtonOutlet.clipsToBounds = YES;
    [scannerButtonOutlet setTitle:@"Scan Item" forState:UIControlStateNormal];
    scannerButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
    
    [super viewDidLoad];
    
    //code to form the button
#warning deactivate button until something entered into textField
    conversionButtonOutlet.layer.cornerRadius = 8;
    conversionButtonOutlet.layer.borderWidth = 1;
    conversionButtonOutlet.layer.borderColor = [UIColor whiteColor].CGColor;
    conversionButtonOutlet.backgroundColor = [UIColor colorWithRed:117/255 green:135/255 blue:146/255 alpha:1];
    conversionButtonOutlet.clipsToBounds = YES;
    conversionButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
    //UIColor* orangeKindaColor = [UIColor colorWithRed:244.0/255 green:128.0/255 blue:0.0/255 alpha:1];
    [conversionButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [conversionButtonOutlet setTitle:@"Go Charity Value" forState:UIControlStateNormal];
    
    //code to dismiss keyboard when user taps around textField
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
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

- (IBAction)backToIntroductionButton:(id)sender {
}


- (void) calculateCharitableImpactValue:(NSNumber*)dollarAmount {
    NSNumberFormatter* addCommasFormatter = [[NSNumberFormatter alloc] init];
    [addCommasFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    float convertToFloat = [dollarAmount floatValue];
    
    convertedCharitableGoodsArray = [NSMutableArray new];

    //logic to compare scanner/user's entry to Charities' conversions
    if (convertToFloat >= 1) {
        float numberOfAnimalMeals = (convertToFloat / 1) * 20;
        NSLog(@"Number of animal meals = %.2f", numberOfAnimalMeals);
        int roundUp1 = ceilf(numberOfAnimalMeals);
        NSString* floatToAString1 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp1]];
        [convertedCharitableGoodsArray addObject:floatToAString1];
    }
    if (convertToFloat >= 10) {
        float numberOfMonthsHelpingChildren = convertToFloat / 10;
        NSLog(@"number of months = %.2f", numberOfMonthsHelpingChildren);
        int roundUp10 = ceilf(numberOfMonthsHelpingChildren);
        NSString* floatToAString10 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp10]];
        [convertedCharitableGoodsArray addObject:floatToAString10];
    }
    if (convertToFloat >= 19) {
        float numberOfMonthsToFeedChildren = convertToFloat / 19;
        NSLog(@"Number of Months = %.2f", numberOfMonthsToFeedChildren);
        int roundUp19 = ceilf(numberOfMonthsToFeedChildren);
        NSString* floatToAString19 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp19]];
        [convertedCharitableGoodsArray addObject:floatToAString19];
    }
    if (convertToFloat >= 20) {
        float flocksOfDucks = convertToFloat / 20;
        NSLog(@"Flock of Ducks = %.2f", flocksOfDucks);
        int roundUp20 = ceilf(flocksOfDucks);
        NSString* floatToAString20 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp20]];
        [convertedCharitableGoodsArray addObject:floatToAString20];
    }
    if (convertToFloat >= 30) {
        float honeyBees = convertToFloat / 30;
        NSLog(@"Gift of Honey Beees is %.2f", honeyBees);
        int roundUp30 = ceilf(honeyBees);
        NSString* floatToAString30 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp30]];        
        [convertedCharitableGoodsArray addObject:floatToAString30];
    }
    if (convertToFloat >= 50) {
        float numberOfCarePackages = convertToFloat / 50;
        NSLog(@"Number of care packages is %.2f", numberOfCarePackages);
        int roundUp50 = ceilf(numberOfCarePackages);
        NSString* floatToAString50 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp50]];        [convertedCharitableGoodsArray addObject:floatToAString50];
    }
    if (convertToFloat >= 500) {
        float numberOfSpringCatchments = convertToFloat / 500;
        NSLog(@"Number of Natiral Spring Cathcments %.2f", numberOfSpringCatchments);
        int roundUp500 = ceilf(numberOfSpringCatchments);
        NSString* floatToAString500 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp500]];        [convertedCharitableGoodsArray addObject:floatToAString500];
    }
    NSLog(@"conversion values = %@", convertedCharitableGoodsArray);
    
    [userEnterDollarAmountTextField resignFirstResponder];
     
    convertedProductPrice = [NSNumber numberWithFloat:convertToFloat];

    [self performSegueWithIdentifier:@"ConversionToImagesSegue" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ConversionToImagesSegue"]) {
        ImagesViewController* imagesVC = [segue destinationViewController];
        ProductDisplayCell* productsDC = [ProductDisplayCell new];
        
        imagesVC.resultOfCharitableConversionsArray = [convertedCharitableGoodsArray copy];
        
        imagesVC.productPrice = convertedProductPrice;
        
        NSLog(@"This product's price %@", imagesVC.productPrice);
        
        productsDC.urlDisplayLabel.text = urlForProduct;
        
        NSLog(@"This is URL %@ ", urlForProduct);
        
        productsDC.productNameDisplayLabel.text = productName;

        imagesVC.productCellTemp = productsDC;
        
        
        imagesVC.productName = productName;
       // imagesVC.productPrice = [NSNumber numberWithFloat:productPrice];
        imagesVC.productProductURL = urlForProduct;
        
        
        
    NSLog(@"contents passed along are %@", imagesVC.resultOfCharitableConversionsArray);
        
    } else if ([[segue identifier] isEqualToString:@"ScannerSegue"]){
        // Get reference to the destination view controller
        ScannerViewController *svc = [segue destinationViewController];
        productPrice = svc.productPrice;
        urlForProduct = svc.urlForProduct;
        productName = svc.productName;
        
        svc.delegate = self;
    }
}

-(void)productDatabaseReturnedNothing
{
    NSLog(@"the productDatabaseReturnedNothing method is firing!");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Scan Did Not Work" message:@"Please input price into text field. Sorry for the manual labor." delegate:self cancelButtonTitle:@"Got It" otherButtonTitles:nil];
    [alert show];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)productInfoReturned:(NSNumber*)returnedPrice urlS:(NSString*) urlForProductTemp productNameNow:(NSString*)productNameNow
{
    NSLog(@"Get Hype, Product name = %@, URL = %@, Product Price = %@", productNameNow, urlForProductTemp, returnedPrice);
    
    urlForProduct = urlForProductTemp;
    productName = productNameNow;
    
    
    //[self performSegueWithIdentifier:@"ConversionToImagesSegue" sender:self];
    
    [self calculateCharitableImpactValue:returnedPrice];
    
   // NSLog(@"the url passed through is %@", urlForProduct);
    
}

-(void)dismissKeyboard {
    [userEnterDollarAmountTextField resignFirstResponder];
}

@end
