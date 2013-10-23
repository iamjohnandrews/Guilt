//
//  ViewController.m
//  Guilt
//
//  Created by John Andrews on 10/23/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize charityImpactValueLabel, userEnterDollarAmountTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (IBAction)conversionButton:(id)sender {
    [self calculateCharitableImpactValue];
    
}

- (void) calculateCharitableImpactValue {
    float inputValue = [userEnterDollarAmountTextField.text floatValue];
    
    float lowestCommonDenominatorTARS = 1;
    float lowestCommonDenominatorSA = 50;
    float lowestCommonDenominatorFTC = 19;
    float lowestCommonDenominatorAWF = 500;
    float lowestCommonDenominatorU = 10;
    
    NSString* tars = @"20 animal meals with The Animal Rescue Site";
    NSString* sa = @"A military care package through Soildier's Angels";
    NSString* ftc = @"Food, water, education, and medical supplies for a student for a month through Feed the Children";
    NSString* awf = @"Natural Spring catchment and serving 250 people through Africa Well Fund";
    NSString* u = @"providing children with lifesaving vaccines, relief after natural disasters & schooling for a month through Unicef";
    
    if (inputValue == lowestCommonDenominatorTARS) {
        charityImpactValueLabel.text = tars;
    } else if (inputValue == lowestCommonDenominatorSA){
        charityImpactValueLabel.text = sa;
    } else if (inputValue == lowestCommonDenominatorFTC){
        charityImpactValueLabel.text = ftc;
    } else if (inputValue == lowestCommonDenominatorAWF){
        charityImpactValueLabel.text = awf;
    } else if (inputValue == lowestCommonDenominatorU) {
        charityImpactValueLabel.text = u;
    }
    
    [userEnterDollarAmountTextField resignFirstResponder];
    
    /* Charity Conversions:
     (TARS) The Animal Rescue Site, $1 = 20 animal meals
     (SA) Soildier's Angels, $50 = Care Package
     (FTC) Feed the Children, $19-$30 = Food, Water, Education, and Medical Supplies for a student for a month
     (AWF) Africa Well Fund, $500 = Natural Spring catchment serving 250 people
     (U) Unicef, $10-$20 = lifesaving vaccines, relief after natural disasters & schooling for a month
     */
}

@end
