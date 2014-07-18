//
//  Charity.m
//  Guilt
//
//  Created by John Andrews on 3/16/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "Charity.h"

@implementation Charity

- (NSString *)charityLogos:(NSString *)specificCharity
{
    NSDictionary *charityLogosDict = [NSDictionary dictionary];
    charityLogosDict = @{@"African Well Fund": @"AfricanWellFund.jpg", 
                          @"Feed The Children": @"feed-children-logo.jpg", 
                          @"Soilder's Angels": @"SoldiersAngels.jpg",
                          @"The Animal Rescue Site": @"AnimalRescueSite.jpeg",
                          @"Unicef": @"unicef.jpg",
                         @"Heifer Internaitonal": @"Heifer.jpg",
                         @"Heifer Internaitonal (ducks)": @"Heifer.jpg",
                         @"Heifer Internaitonal (bees)": @"Heifer.jpg",
                          @"made a purchase": @"dollarSign.jpg"};
    return [charityLogosDict objectForKey:specificCharity];
}

- (NSString *)charityDonationPage:(NSUInteger)specificCharity
{
    NSArray *charityDonationPageArray = [NSArray array];
    charityDonationPageArray = @[@"https://theanimalrescuesite.greatergood.com/store/ars/item/32249/contribute-to-animal-rescue?source=12-32132-3#productInfo",
                            @"http://www.supportunicef.org/site/c.dvKUI9OWInJ6H/b.7677883/k.2C8F/Donate_now.htm", 
                            @"https://secure2.convio.net/ftc/site/SPageServer?pagename=donate",
                            @"http://www.heifer.org/gift-catalog/animals-nutrition/flock-of-ducks-donation.html",
                            @"http://www.heifer.org/gift-catalog/animals-nutrition/honeybees-donation.html",
                            @"http://soldiersangels.org/donate.html", 
                            @"http://www.africanwellfund.org/donate.html"];
    return [charityDonationPageArray objectAtIndex:specificCharity];
}

- (NSString *)charityNames:(NSUInteger)specificCharity
{
    NSArray *charityNamesArray = [NSArray array];
    charityNamesArray = @[@"The Animal Rescue Site", @"Unicef", @"Feed The Children", @"Heifer Internaitonal (ducks)", @"Heifer Internaitonal (bees)", @"Soilder's Angels", @"African Well Fund"];
    
    return [charityNamesArray objectAtIndex:specificCharity];
}

- (NSString *)charityDescriptionPlural:(NSUInteger)specificCharity
{
    NSArray *charityDescriptionPluralArray = [NSArray array];
    charityDescriptionPluralArray = @[@"animal meals from The Animal Rescue Site",
                                      @"months of disaster relief, vaccines & school from Unicef",
                                      @"months of food, water, & medical supplies from FTC",
                                      @"flocks of ducks per family in developing world from Heifer",
                                      @"gifts of bees for developing world families from Heifer",
                                      @"military care packages from Soildier's Angels",
                                      @"spring catchments for 250 people from African Well Fund"];
    return [charityDescriptionPluralArray objectAtIndex:specificCharity];
}

- (NSString *)charityDescriptionSingular:(NSUInteger)specificCharity
{
    NSArray *charityDescriptionSingularArray = [NSArray array];
    charityDescriptionSingularArray = @[@"animal meals from The Animal Rescue Site",
                                        @"month of disaster relief, vaccines & school from Unicef",
                                        @"month of food, water, & medical supplies from FTC",
                                        @"flock of ducks per family in developing world from Heifer",
                                        @"gift of bees per a developing world family from Heifer",
                                        @"military care package from Soildier's Angels",
                                        @"spring catchment for 250 people from African Well Fund"];
    return [charityDescriptionSingularArray objectAtIndex:specificCharity];
}


@end
