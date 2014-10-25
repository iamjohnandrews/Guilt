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
            NSMutableArray *defaultSearchTerms = [[NSMutableArray alloc] initWithObjects:@"beekeeper", @"ducklings", @"child vaccination", @"happy pets", @"military care package", @"child eyes", @"child drink water africa", nil];
            [[FlickrNetworkManager sharedManager] requestCharityImagescompletion:nil withSearchTerms:defaultSearchTerms];
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
        
        BOOL isLogoSavedToDisk = [ImageSaver imageAlreadySavedToDiskWithName:individualCharityInfo.charityName];
        
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
        
        [searhTerms addObject:individualCharityInfo.flickrSearchTerm];
        [self.allCharitiesInfo addObject:individualCharityInfo];
    }
    [self saveContext];
    [[FlickrNetworkManager sharedManager] requestCharityImagescompletion:nil withSearchTerms:searhTerms];
}

- (void)saveContext {
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

@end
