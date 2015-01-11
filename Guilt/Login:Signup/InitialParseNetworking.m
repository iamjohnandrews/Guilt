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
#import "ImageSaver.h"
#import "ConversionSaver.h"
#import <AFNetworking/AFNetworking.h>


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
    int locallyStoredNonprofits = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allCharityNames"] count];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == locallyStoredNonprofits){
            NSLog(@"local storage = remote storage ann all is right with KarmaScan World");
        } else if (number > locallyStoredNonprofits) {
            NSLog(@"local storage < remote storage and need to retrieve nonprofits");
            [self retrieveNonProfitDataFromParse:query butSkipTheFirst:locallyStoredNonprofits];
        } else {
            NSLog(@"local storage > remote storage and need to push nonprofit info to remote storage");
        }
        NSLog(@"Parse Error =%@ %@ %@", error, [error localizedDescription], [error localizedFailureReason]);
    }];
}

- (void)retrieveNonProfitDataFromParse:(PFQuery *)query butSkipTheFirst:(int)skip
{
    [query orderByAscending:@"conversionValue"];
    query.skip = skip;
    [query findObjectsInBackgroundWithBlock:^(NSArray *PFobjects, NSError *error) {
        //3
        if (!error) {
            [self parseThroughNonProfitObjects:PFobjects];
        } else {
            //4 What to do if no internet connection
            [self ifNoInternetStillCreateCharityObjects];
            NSLog(@"Parse Error =%@ %@ %@", error, [error localizedDescription], [error localizedFailureReason]);
        }
    }];
}

- (void)parseThroughNonProfitObjects:(NSArray *)charityObjectsArray
{
    NSMutableArray *searhTerms = [NSMutableArray array];
    NSMutableArray *allCharityNamesArray = [NSMutableArray array];
    self.allCharitiesInfo = [[NSMutableSet alloc] init];

    for (PFObject *charityDetails in charityObjectsArray) {
        CharityImage *individualCharityInfo = [[CharityImage alloc] init];
        individualCharityInfo.charityName = [charityDetails objectForKey:@"name"];
        individualCharityInfo.singularDescription = [charityDetails objectForKey:@"singularDescription"];
        individualCharityInfo.pluralDescription = [charityDetails objectForKey:@"pluralDescription"];
        individualCharityInfo.flickrSearchTerm = [charityDetails objectForKey:@"flickrSearchTerm"];
        individualCharityInfo.donationURL = [charityDetails objectForKey:@"donationURL"];
        individualCharityInfo.conversionValue = [charityDetails objectForKey:@"conversionValue"];
        [allCharityNamesArray addObject:individualCharityInfo.charityName];
        
        BOOL isLogoSavedToDisk = [ImageSaver imageAlreadySavedToDiskWithName:individualCharityInfo.charityName];
        BOOL isCharityConversionInfoSavedToDisk = [ConversionSaver charityConversionInfoAlreadySavedToDisk:individualCharityInfo.charityName];
        
        [[charityDetails objectForKey:@"logo"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                individualCharityInfo.charityLogo = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if (!isLogoSavedToDisk) {
                        [ImageSaver saveImageToDisk:individualCharityInfo.charityLogo withName:individualCharityInfo.charityName];
                    }
                });
            }
        }];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!isCharityConversionInfoSavedToDisk) {
                [ConversionSaver saveSpecificCharityConversionInfo:individualCharityInfo];
            }
        });
        
        [searhTerms addObject:individualCharityInfo.flickrSearchTerm];
        [self.allCharitiesInfo addObject:individualCharityInfo];
    }
    [ConversionSaver saveCharityNamesToNSUserDefaults:allCharityNamesArray];
    [[FlickrNetworkManager sharedManager] requestCharityImagescompletion:nil withSearchTerms:searhTerms];
}

- (void)ifNoInternetStillCreateCharityObjects
{
    NSArray *charityNamesDescriptionsAndConversionValuesArray = [[NSArray alloc] initWithArray:[ConversionSaver getsAllCharityConversionInfo]];
    
    NSMutableArray *searchTerms = [NSMutableArray array];
    
    for (CharityImage *conversionInfoObject in charityNamesDescriptionsAndConversionValuesArray) {
        [searchTerms addObject:conversionInfoObject.flickrSearchTerm];
    }

    [[FlickrNetworkManager sharedManager] requestCharityImagescompletion:nil withSearchTerms:searchTerms];
}


@end
