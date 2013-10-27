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
@synthesize userEnterDollarAmountTextField;

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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return charitableDescriptionsSingularArray.count;
    //how do I make views appear only when they are needed? Like they follow the count of the convertedCharitableGoodsArray
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CharityImpact" forIndexPath:indexPath];
    //I need this method to get called everytime the button is pressed and have the view's labels change
    return cell;
}

- (IBAction)conversionButton:(id)sender {
    convertedCharitableGoodsArray = [NSMutableArray new];
    
    [self calculateCharitableImpactValue];
    
}

- (void) calculateCharitableImpactValue {
    
    float convertToFloat = [userEnterDollarAmountTextField.text floatValue];
//put below logic in a method
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
    
    int pullFromArray = convertedCharitableGoodsArray.count-1;
    NSLog(@"in the charitable good array %@",convertedCharitableGoodsArray);
    
    if (![[convertedCharitableGoodsArray objectAtIndex:pullFromArray] isEqualToString:@"1.00"]) {
        cell.charityImpactValueLabel.text = [NSString stringWithFormat:@"%@ %@", [convertedCharitableGoodsArray objectAtIndex:pullFromArray], [charitableDescriptionsPluralArray objectAtIndex:pullFromArray]];
    } else {
        cell.charityImpactValueLabel.text = [NSString stringWithFormat:@"One %@",[charitableDescriptionsSingularArray objectAtIndex:pullFromArray]];
        }

    [userEnterDollarAmountTextField resignFirstResponder];
}

- (void) placeCharitableConversionsInToViews{
    
    
}

@end
