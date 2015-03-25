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

@interface InitialParseNetworking ()
@property (strong, nonatomic) ImageSaver *imageSaver;
@property (strong, nonatomic) ConversionSaver *conversionSaver;

@end

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
    self.imageSaver = [[ImageSaver alloc] init];
    self.conversionSaver = [[ConversionSaver alloc] init];
    //Prepare the query to get all the images in descending order
    //1
    PFQuery *query = [PFQuery queryWithClassName:@"ConversionNonprofits"];
    int locallyStoredNonprofits = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allCharityNames"] count];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == locallyStoredNonprofits){
            NSLog(@"local storage(%d) = remote storage(%d) ann all is right with KarmaScan World", locallyStoredNonprofits, number);
        } else if (number > locallyStoredNonprofits) {
            NSLog(@"local storage < remote storage and need to retrieve nonprofits");
        } else {
            NSLog(@"local storage > remote storage and need to push nonprofit info to remote storage");
        }
        NSLog(@"Parse Error =%@ %@ %@", error, [error localizedDescription], [error localizedFailureReason]);
        [self retrieveNonProfitDataFromParse:query butSkipTheFirst:locallyStoredNonprofits];

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
    NSMutableDictionary *imageAndTitleDict = [NSMutableDictionary dictionary];
    self.allCharitiesInfo = [[NSMutableSet alloc] init];

    for (PFObject *charityDetails in charityObjectsArray) {
        CharityImage *individualCharityInfo = [[CharityImage alloc] init];
        individualCharityInfo.charityName = [charityDetails objectForKey:@"name"];
        individualCharityInfo.singularDescription = [charityDetails objectForKey:@"singularDescription"];
        individualCharityInfo.pluralDescription = [charityDetails objectForKey:@"pluralDescription"];
        individualCharityInfo.flickrSearchTerm = [charityDetails objectForKey:@"flickrSearchTerm"];
        individualCharityInfo.donationURL = [charityDetails objectForKey:@"donationURL"];
        individualCharityInfo.conversionValue = [charityDetails objectForKey:@"conversionValue"];
        
        [imageAndTitleDict setObject:[charityDetails objectForKey:@"logo"] forKey:individualCharityInfo.charityName];
        [allCharityNamesArray addObject:individualCharityInfo.charityName];
        [searhTerms addObject:individualCharityInfo.flickrSearchTerm];
        [self.allCharitiesInfo addObject:individualCharityInfo];
    }
    [self.conversionSaver saveCharityNamesToNSUserDefaults:allCharityNamesArray];
    [[FlickrNetworkManager sharedManager] requestCharityImagescompletion:nil withSearchTerms:searhTerms];
    [self saveCharityInfoIfNeedTo];
    [self saveLogoIfNeedBe:imageAndTitleDict];
}

- (void)saveLogoIfNeedBe:(NSMutableDictionary *)logosOnParse
{
    NSMutableDictionary *imageAndTitleCheckDict = [NSMutableDictionary dictionary];
    NSInteger logosOnDisk = [[self.imageSaver getAllLogs] count];
    NSLog(@"logosOnDisk =%ld, logosOnParse =%lu", (long)logosOnDisk, (unsigned long)logosOnParse.count);
    
    if (logosOnParse.count == logosOnDisk) {
        return;
    }
    
    for (NSString *charityName in logosOnParse) {
        BOOL isLogoSavedToDisk = [self.imageSaver imageAlreadySavedToDiskWithName:charityName];
        if (!isLogoSavedToDisk) {
            [imageAndTitleCheckDict setObject:[logosOnParse objectForKey:charityName]  forKey:charityName];
        }
    }
    
    if (imageAndTitleCheckDict.count) {
        [self convertPFObjectIntoimage:imageAndTitleCheckDict];
    }
}

- (void)convertPFObjectIntoimage:(NSMutableDictionary *)parseObjects
{
    for (NSString *charityName in parseObjects) {
        PFFile *image = [parseObjects objectForKey:charityName];
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            [self.imageSaver saveImageToDisk:[UIImage imageWithData:data] forCharity:charityName];
        } progressBlock:^(int percentDone) {
            
        }];
    }
}

- (void)saveCharityInfoIfNeedTo
{
    [self.conversionSaver saveSpecificCharityConversionInfo:[self.allCharitiesInfo allObjects]];
}

- (void)ifNoInternetStillCreateCharityObjects
{
    NSArray *charityNamesDescriptionsAndConversionValuesArray = [[NSArray alloc] initWithArray:[self.conversionSaver getsAllCharityConversionInfo]];
    
    NSMutableArray *searchTerms = [NSMutableArray array];
    
    for (NSDictionary *conversionInfoObject in charityNamesDescriptionsAndConversionValuesArray) {
        [searchTerms addObject:[conversionInfoObject objectForKey:@"flickrSearchTerm"]];
    }

    [[FlickrNetworkManager sharedManager] requestCharityImagescompletion:nil withSearchTerms:searchTerms];
}


@end
