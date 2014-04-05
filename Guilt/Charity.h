//
//  Charity.h
//  Guilt
//
//  Created by John Andrews on 3/16/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Charity : NSObject
@property (nonatomic, strong) NSArray *Images;
@property (nonatomic, strong) NSString *descriptionsPlural;
@property (nonatomic, strong) NSString *descriptionsSingular;
@property (strong, nonatomic) NSURL *logoImageUrl;

- (NSString *)charityDescriptionSingular:(NSUInteger)specificCharity;
- (NSString *)charityDescriptionPlural:(NSUInteger)specificCharity;
- (UIImage *)charityImageURLSForSpecifcCharity:(NSUInteger)specificCharity;
- (NSString *)charityNames:(NSUInteger)specificCharity;
- (NSString *)charityDonationPage:(NSUInteger)specificCharity;


@end
