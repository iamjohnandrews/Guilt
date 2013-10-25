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
    NSArray* charitableDescriptionsArray;
    NSMutableArray *convertedCharitableGoods;
    CharityImpactViewCell* cell;
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
    
    charitableDescriptionsArray = @[@"animal meals through The Animal Rescue Site",
                                    @"military care package through Soildier's Angels",
                                    @"month of food, water, education, and medical supplies for a student through Feed The Children",
                                    @"natural spring catchment serving 250 people through African Well Fund",
                                    @"month of providing children with lifesaving vaccines, relief after natural disasters & schooling through Unicef"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return charitableDescriptionsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CharityImpact" forIndexPath:indexPath];
                                         
    return cell;
}

- (IBAction)conversionButton:(id)sender {
    
    [self calculateCharitableImpactValue];
    
}

- (void) calculateCharitableImpactValue {
    
    float convertToFloat = [userEnterDollarAmountTextField.text floatValue];
    
        if (convertToFloat >= 1) {
            float numberOfAnimalMeals = (convertToFloat / 1) * 20;
            [convertedCharitableGoods addObject:[NSString stringWithFormat:@"%.0f, ", numberOfAnimalMeals]];
            NSLog(@"Number of animal meals = %.2f", numberOfAnimalMeals);
        }
        if (convertToFloat >= 10) {
            float numberOfMonthsHelpingChildren = convertToFloat / 10;
            [convertedCharitableGoods addObject:[NSString stringWithFormat:@"%.2f", numberOfMonthsHelpingChildren]];
            NSLog(@"number of months = %f", numberOfMonthsHelpingChildren);
        }
        if (convertToFloat >= 19) {
            float numberOfMonthsToFeedChildren = convertToFloat / 19;
            [convertedCharitableGoods addObject:[NSString stringWithFormat:@"%.2f", numberOfMonthsToFeedChildren]];
            NSLog(@"Number of Months = %f", numberOfMonthsToFeedChildren);
        }
        if (convertToFloat >= 50) {
            float numberOfCarePackages = convertToFloat / 50;
            [convertedCharitableGoods addObject:[NSString stringWithFormat:@"%.0f", numberOfCarePackages]];
            NSLog(@"Number of care packages is %.2f", numberOfCarePackages);
        }
        if (convertToFloat >= 500) {
            float numberOfSpringCatchments = convertToFloat / 500;
            [convertedCharitableGoods addObject:[NSString stringWithFormat:@"%.2f", numberOfSpringCatchments]];
            NSLog(@"Number of Natiral Spring Cathcments %f", numberOfSpringCatchments);
        }
    
    
    NSLog(@"in the charitable good array %@", convertedCharitableGoods);
    cell.charityImpactValueLabel.text = [charityImpactGoodsDictionary objectForKey:userEnterDollarAmountTextField.text];

    [userEnterDollarAmountTextField resignFirstResponder];
}

@end
