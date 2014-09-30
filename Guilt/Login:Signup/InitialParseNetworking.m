//
//  InitialParseNetworking.m
//  Guilt
//
//  Created by John Andrews on 9/10/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "InitialParseNetworking.h"
#import "CharityImage.h"
#import "FlickrNetworkManager.h"

@implementation InitialParseNetworking

+ (instancetype) sharedManager
{
    static InitialParseNetworking *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (void)getConversionNonprofitDataFromParse
{
    //Prepare the query to get all the images in descending order
    //1
    PFQuery *query = [PFQuery queryWithClassName:@"ConversionNonprofits"];
    
    //2
    [query orderByAscending:@"conversionValue"];

    query.limit = 7;
    [query findObjectsInBackgroundWithBlock:^(NSArray *PFobjects, NSError *error) {
        //3
        if (!error) {
            [self parseThroughNonProfitObjects:PFobjects];
        } else {
            //4 What to do if no internet connection

            NSLog(@"Parse Error =%@ %@ %@", error, [error localizedDescription], [error localizedFailureReason]);
        }
    }];
}

- (void)parseThroughNonProfitObjects:(NSArray *)charityObjectsArray
{
    
    NSMutableArray *searhTerms = [NSMutableArray array];
    self.allCharitiesInfo = [[NSMutableSet alloc] init];
    
    for (PFObject *charityDetails in charityObjectsArray) {
        CharityImage *individualCharityInfo = [[CharityImage alloc] init];
        individualCharityInfo.charityName = [charityDetails objectForKey:@"name"];
        individualCharityInfo.singularDescription = [charityDetails objectForKey:@"singularDescription"];
        individualCharityInfo.pluralDescription = [charityDetails objectForKey:@"pluralDescription"];
        individualCharityInfo.flickrSearchTerm = [charityDetails objectForKey:@"flickrSearchTerm"];
        individualCharityInfo.donationURL = [charityDetails objectForKey:@"donationURL"];
        individualCharityInfo.conversionValue = [charityDetails objectForKey:@"conversionValue"];
        
        [[charityDetails objectForKey:@"logo"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                individualCharityInfo.charityLogo = [UIImage imageWithData:data];
            }
        }];
        
        [searhTerms addObject:individualCharityInfo.flickrSearchTerm];
        [self.allCharitiesInfo addObject:individualCharityInfo];
    }
    [[FlickrNetworkManager sharedManager] requestCharityImagescompletion:nil withSearchTerms:searhTerms];

}

@end
