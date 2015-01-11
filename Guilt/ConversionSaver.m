//
//  ConversionSaver.m
//  Guilt
//
//  Created by John Andrews on 10/25/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ConversionSaver.h"


@implementation ConversionSaver


+ (void)saveCharityNamesToNSUserDefaults:(NSMutableArray *)names
{    
    [[NSUserDefaults standardUserDefaults] setObject:names forKey:@"allCharityNames"];
}

+ (void)saveSpecificCharityConversionInfo:(CharityImage *)charitysDetails
{
    NSString *noWhiteSpaceCharityName = [charitysDetails.charityName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pathForCharityConversion = [[documentsPath stringByAppendingPathComponent:noWhiteSpaceCharityName] stringByAppendingPathComponent:@"conversionInfo"];
    
    if (![fileManager fileExistsAtPath:pathForCharityConversion]) {
        BOOL directoryCreated = [fileManager createDirectoryAtPath:pathForCharityConversion withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"directoryCreated %hhd", directoryCreated);
    }
    
//    NSString *pathForConversionBeingSaved = [pathForCharityConversion stringByAppendingPathComponent:@"number"];
    
    BOOL archived = [NSKeyedArchiver archiveRootObject:charitysDetails toFile:pathForCharityConversion];
    NSLog(@"conversionInfo Archived %hhd", archived);
}

+ (CharityImage *)getspecificCharityConversionInfo:(NSString *)charityName
{
    NSString *noWhiteSpaceCharityName = [charityName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [[documentsPath stringByAppendingPathComponent:noWhiteSpaceCharityName] stringByAppendingPathComponent:@"conversionInfo"];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:filePath]
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    NSURL *customObjectpath = [contents firstObject];
    CharityImage *specificCharityConversionInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:customObjectpath.path];
    
    return specificCharityConversionInfo;
}

+ (NSArray *)getsAllCharityConversionInfo
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


+ (BOOL)charityConversionInfoAlreadySavedToDisk:(NSString *)charityName
{
    CharityImage *test = [self getspecificCharityConversionInfo:charityName];
    
    if (test) {
        return YES;
    } else {
        return NO;
    }
}



@end
