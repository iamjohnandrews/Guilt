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
    NSDictionary* charityImpactGoodsDictionary;
    NSArray* charitableDescriptionsSingularArray;
    NSArray* charitableDescriptionsPluralArray;
    CharityImpactViewCell* cell;
    
    NSMutableArray *convertedCharitableGoodsArray;
}

@end

@implementation ViewController
@synthesize userEnterDollarAmountTextField, charityCollectionView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    charityImpactGoodsDictionary = @{@"1": @"animal meals through The Animal Rescue Site",
                                     @"50":@"military care package through Soildier's Angels",
                                     @"19":@"month of food, water, education, and medical supplies for a student through Feed The Children",
                                     @"500":@"natural spring catchment serving 250 people through African Well Fund",
                                     @"10":@"month of providing children with lifesaving vaccines, relief after natural disasters & schooling through Unicef"};
    
    charitableDescriptionsSingularArray = @[@"animal meals through The Animal Rescue Site",
                                            @"month of providing children with lifesaving vaccines, relief after natural disasters & schooling through Unicef",
                                            @"month of food, water, education, and medical supplies for a student through Feed The Children",
                                            @"military care package through Soildier's Angels",
                                            @"natural spring catchment serving 250 people through African Well Fund"];
    charitableDescriptionsPluralArray = @[@"animal meals through The Animal Rescue Site",
                                            @"months of providing children with lifesaving vaccines, relief after natural disasters & schooling through Unicef",
                                            @"months of food, water, education, and medical supplies for a student through Feed The Children",
                                            @"military care packages through Soildier's Angels",
                                            @"natural spring catchments serving 250 people through African Well Fund"];
}


- (IBAction)conversionButton:(id)sender {
    convertedCharitableGoodsArray = [NSMutableArray new];
    
    [self calculateCharitableImpactValue];
    
}

- (void) calculateCharitableImpactValue {
    
    float convertToFloat = [userEnterDollarAmountTextField.text floatValue];

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
/*    int pullFromArray = convertedCharitableGoodsArray.count-1;
    int randomCharityDisplay = arc4random() % pullFromArray;
    NSLog(@"in the charitable good array %@",convertedCharitableGoodsArray);
    
    //put in arcrandom function here in the if statement
    if (![[convertedCharitableGoodsArray objectAtIndex:pullFromArray] isEqualToString:@"1.00"]) {
        cell.charityImpactValueLabel.text = [NSString stringWithFormat:@"%@ %@", [convertedCharitableGoodsArray objectAtIndex:randomCharityDisplay], [charitableDescriptionsPluralArray objectAtIndex:randomCharityDisplay]];
    } else {
        cell.charityImpactValueLabel.text = [NSString stringWithFormat:@"One %@",[charitableDescriptionsSingularArray objectAtIndex:pullFromArray]];
        }*/
    [self placeCharitableConversionsInToViews:convertedCharitableGoodsArray];
    [userEnterDollarAmountTextField resignFirstResponder];
}

- (void) placeCharitableConversionsInToViews:(NSMutableArray*)valuesOfConvertedCharitableGoods
{
    int pullFromArray = valuesOfConvertedCharitableGoods.count-1;
//    int randomCharityDisplay = arc4random() % valuesOfConvertedCharitableGoods.count;
    NSLog(@"the different values of charitable goods = %@",valuesOfConvertedCharitableGoods);
    
    //cant use arcrandom function because it does repeats. Placeholder for now
    if (![[valuesOfConvertedCharitableGoods objectAtIndex:pullFromArray] isEqualToString:@"1.00"]) {
        NSLog(@"stuff in the array = %@", valuesOfConvertedCharitableGoods);
        cell.charityImpactValueLabel.text = [NSString stringWithFormat:@"%@ %@", valuesOfConvertedCharitableGoods [pullFromArray], charitableDescriptionsPluralArray [pullFromArray]];
        [self.charityCollectionView reloadData];
    } else {
        cell.charityImpactValueLabel.text = [NSString stringWithFormat:@"One %@",charitableDescriptionsSingularArray [pullFromArray]];
        [self.charityCollectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return charitableDescriptionsSingularArray.count;
    //how do I make views appear only when they are needed? Like they follow the count of the convertedCharitableGoodsArray
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CharityImpact" forIndexPath:indexPath];
    //I need this method to get called everytime the button is pressed and have the view's labels change
    //[self placeCharitableConversionsInToViews];
    // should I call the placeCharitableConversionsInToViews here because conertedCharitableGoodsArray is not filled with nything yet?
    
//    int random = arc4random() % 5;
//    NSLog(@"random's order is %d", random);
//    cell.charityImpactValueLabel.text = charitableDescriptionsSingularArray [random];
    
    return cell;
}


@end
