//
//  ConversionSaver.m
//  Guilt
//
//  Created by John Andrews on 10/25/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ConversionSaver.h"

@interface ConversionSaver ()
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSString *documentsPath;

@end

@implementation ConversionSaver

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
        self.documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    
    return self;
}

- (void)saveCharityNamesToNSUserDefaults:(NSMutableArray *)names
{    
    [[NSUserDefaults standardUserDefaults] setObject:names forKey:@"allCharityNames"];
}

- (void)saveSpecificCharityConversionInfo:(NSArray *)charitysDetailsArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (CharityImage *charitysDetails in charitysDetailsArray) {
            NSDictionary *tempDict = @{@"charityName" : charitysDetails.charityName,
                                       @"singularDescription" : charitysDetails.singularDescription,
                                       @"pluralDescription" : charitysDetails.pluralDescription,
                                       @"flickrSearchTerm" : charitysDetails.flickrSearchTerm,
                                       @"donationURL" : charitysDetails.donationURL,
                                       @"conversionValue" : charitysDetails.conversionValue};
            
            NSString *noWhiteSpaceCharityName = [charitysDetails.charityName stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSString *pathForCharityConversion = [self.documentsPath stringByAppendingPathComponent:noWhiteSpaceCharityName];
            
            if (![self.fileManager fileExistsAtPath:pathForCharityConversion]) {
                BOOL directoryCreated = [self.fileManager createDirectoryAtPath:pathForCharityConversion withIntermediateDirectories:YES attributes:nil error:nil];
                NSLog(@"directoryCreated %d", directoryCreated);
                
                BOOL archived = [NSKeyedArchiver archiveRootObject:tempDict toFile:[pathForCharityConversion stringByAppendingPathComponent:@"conversionInfo"]];
                NSLog(@"conversionInfo Archived %d", archived);
            }

        }
    });
}

- (CharityImage *)getspecificCharityConversionInfo:(NSString *)charityName
{
    NSString *noWhiteSpaceCharityName = [charityName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *filePath = [[self.documentsPath stringByAppendingPathComponent:noWhiteSpaceCharityName] stringByAppendingPathComponent:@"conversionInfo"];
    NSArray *contents = [self.fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:filePath]
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    NSURL *customObjectpath = [contents firstObject];
    CharityImage *specificCharityConversionInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:customObjectpath.path];
    
    return specificCharityConversionInfo;
}

- (NSArray *)getsAllCharityConversionInfo
{
    NSMutableArray *converionInfoObjectsArray = [NSMutableArray array];
    
    NSArray *allCharityNamesArray = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"allCharityNames"]];
    
    for (NSString *charity in allCharityNamesArray) {
        CharityImage* specificCharityConversionInfo = [[CharityImage alloc] init];
        specificCharityConversionInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"/%@/conversionInfo", charity]];
        [converionInfoObjectsArray addObject:specificCharityConversionInfo];
    }
    
    return (NSArray *)converionInfoObjectsArray;
}


- (BOOL)charityConversionInfoAlreadySavedToDisk:(NSString *)charityName
{
    CharityImage *test = [self getspecificCharityConversionInfo:charityName];
    
    if (test) {
        return YES;
    } else {
        return NO;
    }
}



@end
