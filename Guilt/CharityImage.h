//
//  CharityImage.h
//  Guilt
//
//  Created by John Andrews on 5/12/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharityImage : NSObject <NSCoding>

@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) NSMutableDictionary *flickrImageURLDict;
@property (strong, nonatomic) NSMutableDictionary *flickrSearchTermsDict;


@property (strong, nonatomic) NSString *charityName;
@property (strong, nonatomic) NSString *singularDescription;
@property (strong, nonatomic) NSString *pluralDescription;
@property (strong, nonatomic) NSString *flickrSearchTerm;
@property (strong, nonatomic) NSString *donationURL;
@property (strong, nonatomic) UIImage *charityLogo;
@property (strong, nonatomic) NSNumber *conversionValue;

+ (NSArray *)allCharityDetails:(BOOL)randomized;
@end

