//
//  UserProfileSaver.m
//  Guilt
//
//  Created by John Andrews on 11/2/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "UserProfileSaver.h"

@implementation UserProfileSaver

#pragma mark Archive Specific Methods
+ (void)saveUserDonatoinHistory:(NSString *)userID
                     forCharity:(NSString *)recipientCharity
                         onDate:(NSDate *)date
                      forAmount:(NSNumber *)donationAmount
{
    UserDonationHistory* userDonationHistory = [[UserDonationHistory alloc] init];

    userDonationHistory.userID = userID;
    userDonationHistory.recipientCharity = recipientCharity;
    userDonationHistory.date = date;
    userDonationHistory.donationAmount = donationAmount;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pathForUser = [[documentsPath stringByAppendingPathComponent:userID] stringByAppendingPathComponent:@"donationHistory"];
    
    if (![fileManager fileExistsAtPath:pathForUser]) {
        BOOL directoryCreated = [fileManager createDirectoryAtPath:pathForUser withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"directoryCreated %hhd", directoryCreated);
    }
    
    NSString *pathForUsersDonations = [pathForUser stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", date]];
    BOOL archived = [NSKeyedArchiver archiveRootObject:userDonationHistory toFile:pathForUsersDonations];
    
    NSLog(@"%@ donationHistory Archived %hhd", userID, archived);
}

+ (NSArray *)getUsersDonationHistory:(NSString *)userID
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [[documentsPath stringByAppendingPathComponent:userID] stringByAppendingPathComponent:@"donationHistory"];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:[[NSBundle bundleWithPath:filePath] bundleURL]
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    
    NSMutableArray *unarchiveCustomObjectsArray = [NSMutableArray array];
    
    for (NSURL *customObjectPath in contents) {
        UserDonationHistory *userDonationHistory = [NSKeyedUnarchiver unarchiveObjectWithFile:customObjectPath.path];
        [unarchiveCustomObjectsArray addObject:userDonationHistory];
    }

    return [unarchiveCustomObjectsArray copy];
}


@end
