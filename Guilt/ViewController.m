//
//  ViewController.m
//  Guilt
//
//  Created by John Andrews on 10/23/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "ViewController.h"
#import "CharityImpactViewCell.h"

@interface ViewController (){
    NSMutableDictionary* charityImpactGoodsSuingularDictionary;
    NSMutableDictionary* charityImpactGoodsPluralDictionary;
    
    NSArray* charitableDescriptionsSingularArray;
    NSArray* charitableDescriptionsPluralArray;
    NSMutableArray *convertedCharitableGoods;
    NSMutableArray* inputtedValueArray;
}

@end

@implementation ViewController
@synthesize userEnterDollarAmountTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CharityImpactViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CharityImpact" forIndexPath:indexPath];
    
    int randomCharityDisplay = arc4random() % 5;
    
    cell.charityImpactValueLabel.text = [NSString stringWithFormat:@"%@ %@", convertedCharitableGoods[randomCharityDisplay], charitableDescriptionsSingularArray[randomCharityDisplay]];
                                         
    return cell;
}

- (IBAction)conversionButton:(id)sender {
    [self calculateCharitableImpactValue];
}

- (void) calculateCharitableImpactValue {
    NSNumberFormatter * inputtedValue = [[NSNumberFormatter alloc] init];
    [inputtedValue setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * inputtedValueNumber = [inputtedValue numberFromString:userEnterDollarAmountTextField.text];
    
    float convertToFloat = [inputtedValueNumber floatValue];
    float lowestCommonDenominatorTARS = 1;
    float lowestCommonDenominatorSA = 50;
    float lowestCommonDenominatorFTC = 19;
    float lowestCommonDenominatorAWF = 500;
    float lowestCommonDenominatorU = 10;
    
    float numberOfAnimalMeals = convertToFloat / lowestCommonDenominatorTARS * 20;
    float numberOfCarePackages = convertToFloat / lowestCommonDenominatorSA;
    float numberOfMonthsToFeedChildren = convertToFloat / lowestCommonDenominatorFTC;
    float numberOfSpringCatchments = convertToFloat / lowestCommonDenominatorAWF;
    float numberOfMonthsHelpingChildren = convertToFloat / lowestCommonDenominatorU;

    [convertedCharitableGoods addObject:[NSString stringWithFormat:@"%.2f", numberOfAnimalMeals]];
    [convertedCharitableGoods addObject:[NSString stringWithFormat:@"%.2f", numberOfCarePackages]];
    [convertedCharitableGoods addObject:[NSString stringWithFormat:@"%.2f", numberOfMonthsToFeedChildren]];
    [convertedCharitableGoods addObject:[NSString stringWithFormat:@"%.2f", numberOfSpringCatchments]];
    [convertedCharitableGoods addObject:[NSString stringWithFormat:@"%.2f", numberOfMonthsHelpingChildren]];
    
    charitableDescriptionsSingularArray = @[@"animal meals through The Animal Rescue Site", @"military care package through Soildier's Angels", @"month of food, water, education, and medical supplies for a student through Feed The Children", @"natural spring catchment that serves 250 people per a catchment through Africa Well Fund", @"month of providing children with lifesaving vaccines, relief after natural disasters & schooling through Unicef"];

    
    [userEnterDollarAmountTextField resignFirstResponder];
    

}

@end
