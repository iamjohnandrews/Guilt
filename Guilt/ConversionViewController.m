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
#import "FlickrNetworkManager.h"

@interface ConversionViewController (){
    NSNumber* convertedProductPrice;
}
@property (strong, nonatomic) NSMutableDictionary *convertedCharitableGoodsDict;
@property (nonatomic, strong) NSMutableArray *parseNonprofitInfoArray;
@property (nonatomic, strong) NSDictionary *oneToOneCharityURLCharityNameDict;

@end

@implementation ConversionViewController
@synthesize userEnterDollarAmountTextField, valueQuestionLabel, orLabel, backToIntroductionButtonOutlet;
@synthesize conversionButtonOutlet, scannerButtonOutlet, userProfileButtonOutlet;
@synthesize productName;
@synthesize productPrice;
@synthesize urlForProduct;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"ConversionViewController";
    [self setupUI];
    userEnterDollarAmountTextField.delegate = self;
    
    CGRect frameRect = userEnterDollarAmountTextField.frame;
    frameRect.size.height = 50;
    userEnterDollarAmountTextField.frame = frameRect;
    
    //code to dismiss keyboard when user taps around textField
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    //code to disable conversionButton until user inputs value into textField
    [self.conversionButtonOutlet setEnabled:NO];
    [userEnterDollarAmountTextField addTarget:self 
                                       action:@selector(textFieldDidChange)
                             forControlEvents:UIControlEventEditingChanged];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.convertedCharitableGoodsDict = [NSMutableDictionary dictionary];
}

- (void)setupUI
{
    [self.navigationItem setTitle:@"Convert"];
    if ([PFUser currentUser]) {
        self.userProfileButtonOutlet.enabled = YES;
        self.navigationItem.hidesBackButton = YES;
        
        UIBarButtonItem *logOutUserButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logOutUser)];
        [self.navigationItem setLeftBarButtonItem:logOutUserButton animated:YES];
    } else {
        self.userProfileButtonOutlet.enabled = NO;
    }
    
    valueQuestionLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
    valueQuestionLabel.textColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    valueQuestionLabel.text = @"Find the best price & discover your charitable impact";
    
    orLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:25];
    orLabel.textColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    
    backToIntroductionButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
    [backToIntroductionButtonOutlet setTitleColor:[UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1] forState:UIControlStateNormal];
    [backToIntroductionButtonOutlet setTitle:@"Back to Introduction" forState:UIControlStateNormal];    
    
    scannerButtonOutlet.layer.cornerRadius = 8;
    scannerButtonOutlet.layer.borderWidth = 1;
    scannerButtonOutlet.layer.borderColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1].CGColor;
    scannerButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    scannerButtonOutlet.clipsToBounds = YES;
    [scannerButtonOutlet setTitle:@"Scan Item" forState:UIControlStateNormal];
    scannerButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
    
    //code to form the button
    conversionButtonOutlet.layer.cornerRadius = 8;
    conversionButtonOutlet.layer.borderWidth = 1;
    conversionButtonOutlet.layer.borderColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1].CGColor;
    conversionButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    conversionButtonOutlet.clipsToBounds = YES;
    conversionButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
    //UIColor* orangeKindaColor = [UIColor colorWithRed:244.0/255 green:128.0/255 blue:0.0/255 alpha:1];
    [conversionButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [conversionButtonOutlet setTitle:@"Get Impact Value" forState:UIControlStateNormal];
}

- (void)logOutUser
{
    self.userIsLoggedIn = NO;
    [PFUser logOut];
    self.navigationItem.leftBarButtonItem = nil;
    [self createNavigationBackButton];
    [self setupUI];
}

- (void)createNavigationBackButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backPressed:)];
    self.navigationItem.leftBarButtonItem = backButton;
}    

- (void)backPressed: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)scannerButton:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"ConversionViewController"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:scannerButtonOutlet.titleLabel.text
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];

    [self performSegueWithIdentifier:@"ScannerSegue" sender:self];
}

- (IBAction)conversionButton:(id)sender 
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"ConversionViewController"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:conversionButtonOutlet.titleLabel.text
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
    
    NSString *removeDollarSignString;
    if ([userEnterDollarAmountTextField.text hasPrefix:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]] && [userEnterDollarAmountTextField.text length] > 1) {
        removeDollarSignString = [userEnterDollarAmountTextField.text substringFromIndex:1];
    }

    [self calculateCharitableImpactValue:[NSNumber numberWithFloat:[removeDollarSignString floatValue]]];
}

- (void)textFieldDidChange
{
    if (self.userEnterDollarAmountTextField.text.length == 0) {
        [self.conversionButtonOutlet setEnabled:NO];
    }
    else {
        [self.conversionButtonOutlet setEnabled:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length  == 0)
    {
        textField.text = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // Make sure that the currency symbol is always at the beginning of the string:
    if (![newText hasPrefix:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]])
    {
        return NO;
    }
    
    // Default:
    return YES;
}

- (IBAction)backToIntroductionButton:(id)sender 
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)userProfileButton:(id)sender 
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"ConversionViewController"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:userProfileButtonOutlet.title
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
    
}

- (void) calculateCharitableImpactValue:(NSNumber*)dollarAmount {
    NSNumberFormatter* addCommasFormatter = [[NSNumberFormatter alloc] init];
    [addCommasFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    float convertToFloat = [dollarAmount floatValue];
    
    if (convertToFloat >= 1) {
        float numberOfAnimalMeals = (convertToFloat / 1) * 20;
//        NSLog(@"Number of animal meals = %.2f", numberOfAnimalMeals);
        int roundUp1 = ceilf(numberOfAnimalMeals);
        NSString* floatToAString1 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp1]];
        [self.convertedCharitableGoodsDict setObject:floatToAString1 forKey:@"The Animal Rescue Site"];
    }
    if (convertToFloat >= 10) {
        float numberOfMonthsHelpingChildren = convertToFloat / 10;
//        NSLog(@"number of months = %.2f", numberOfMonthsHelpingChildren);
        int roundUp10 = ceilf(numberOfMonthsHelpingChildren);
        NSString* floatToAString10 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp10]];
        [self.convertedCharitableGoodsDict setObject:floatToAString10 forKey:@"Unicef"];
    }
    if (convertToFloat >= 19) {
        float numberOfMonthsToFeedChildren = convertToFloat / 19;
//        NSLog(@"Number of Months = %.2f", numberOfMonthsToFeedChildren);
        int roundUp19 = ceilf(numberOfMonthsToFeedChildren);
        NSString* floatToAString19 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp19]];
        [self.convertedCharitableGoodsDict setObject:floatToAString19 forKey:@"Feed The Children"];        
    }
    if (convertToFloat >= 20) {
        float flocksOfDucks = convertToFloat / 20;
//        NSLog(@"Flock of Ducks = %.2f", flocksOfDucks);
        int roundUp20 = ceilf(flocksOfDucks);
        NSString* floatToAString20 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp20]];
        [self.convertedCharitableGoodsDict setObject:floatToAString20 forKey:@"Heifer Internaitonal (ducks)"];
    }
    if (convertToFloat >= 30) {
        float honeyBees = convertToFloat / 30;
//        NSLog(@"Gift of Honey Bees is %.2f", honeyBees);
        int roundUp30 = ceilf(honeyBees);
        NSString* floatToAString30 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp30]];        
        [self.convertedCharitableGoodsDict setObject:floatToAString30 forKey:@"Heifer Internaitonal (bees)"];
    }
    if (convertToFloat >= 50) {
        float numberOfCarePackages = convertToFloat / 50;
//        NSLog(@"Number of care packages is %.2f", numberOfCarePackages);
        int roundUp50 = ceilf(numberOfCarePackages);
        NSString* floatToAString50 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp50]];    
        [self.convertedCharitableGoodsDict setObject:floatToAString50 forKey:@"Soilder's Angels"];
    }
    if (convertToFloat >= 500) {
        float numberOfSpringCatchments = convertToFloat / 500;
//        NSLog(@"Number of Natiral Spring Cathcments %.2f", numberOfSpringCatchments);
        int roundUp500 = ceilf(numberOfSpringCatchments);
        NSString* floatToAString500 = [addCommasFormatter stringFromNumber:[NSNumber numberWithInt:roundUp500]];       
        [self.convertedCharitableGoodsDict setObject:floatToAString500 forKey:@"African Well Fund"];
    }
    
    [userEnterDollarAmountTextField resignFirstResponder];
    convertedProductPrice = [NSNumber numberWithFloat:convertToFloat];
    userEnterDollarAmountTextField.text = nil;
    
    [self performSegueWithIdentifier:@"ConversionToImagesSegue" sender:self];   
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ConversionToImagesSegue"]) {
        ImagesViewController* imagesVC = [segue destinationViewController];
        imagesVC.resultOfCharitableConversionsDict = [self.convertedCharitableGoodsDict copy];
        imagesVC.productPrice = convertedProductPrice;
        imagesVC.oneCharityURLforOneCharityNameDict = [self.oneToOneCharityURLCharityNameDict copy];
        imagesVC.productName = productName;
        imagesVC.productProductURL = urlForProduct;
        imagesVC.userImputPrice = self.userEnterDollarAmountTextField.text;
        
    } else if ([[segue identifier] isEqualToString:@"ScannerSegue"]){
        // Get reference to the destination view controller
        ScannerViewController *svc = [segue destinationViewController];
        productPrice = svc.productPrice;
        urlForProduct = svc.urlForProduct;
        productName = svc.productName;
        
        svc.delegate = self;
    }
}

#pragma mark Scanner DB Delegate Methods
-(void)productDatabaseReturnedNothing
{
    NSLog(@"the productDatabaseReturnedNothing method is firing!");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Scan Did Not Work" message:@"Please input price into text field. Sorry for the manual labor." delegate:self cancelButtonTitle:@"Got It" otherButtonTitles:nil];
    [alert show];
//    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)productInfoReturned:(NSNumber*)returnedPrice urlS:(NSString*)urlForProductTemp productNameNow:(NSString*)productNameNow
{
    NSLog(@"Get Hype, Product name = %@, URL = %@, Product Price = %@", productNameNow, urlForProductTemp, returnedPrice);
    
    urlForProduct = urlForProductTemp;
    productName = productNameNow;
    
    [self calculateCharitableImpactValue:returnedPrice];
}

- (void)dismissKeyboard 
{
    [userEnterDollarAmountTextField resignFirstResponder];
}

@end
