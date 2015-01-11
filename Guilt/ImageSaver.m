//  ImageSaver.m
//  Magical_Record
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import "ImageSaver.h"


@implementation ImageSaver

+ (void)saveImageToDisk:(UIImage*)image withName:(NSString *)imageTitle
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *charityLogosPath = [documentsDirectory stringByAppendingPathComponent:@"charityLogos"];
    
    if (![fileManager fileExistsAtPath:charityLogosPath]) {
        BOOL directoryCreated = [fileManager createDirectoryAtPath:charityLogosPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"directoryCreated %hhd", directoryCreated);
    }
    
    NSString *savedImagePath = [charityLogosPath stringByAppendingPathComponent:imageTitle];
    if (![fileManager fileExistsAtPath:savedImagePath]) {
        [imageData writeToFile:savedImagePath atomically:NO];
    }
}


+ (UIImage *)fetchImageFromDiskWithName:(NSString *)imageTitle
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [[documentsDirectory stringByAppendingPathComponent:@"charityLogos"] stringByAppendingPathComponent:imageTitle];
    
    return [UIImage imageWithContentsOfFile:getImagePath];
}

//gotta be a better way
+ (BOOL)imageAlreadySavedToDiskWithName:(NSString *)imageTitle
{
    UIImage *returnedImage = [self fetchImageFromDiskWithName:imageTitle];
    
    if (returnedImage) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)deleteImageAtPath:(NSString *)path {
	NSError *error;
	NSString *imgToRemove = [NSHomeDirectory() stringByAppendingPathComponent:path];
	[[NSFileManager defaultManager] removeItemAtPath:imgToRemove error:&error];
}

#pragma mark Archive Specific Methods
+ (void)saveMemeToArchiveDisk:(UIImage*)image forUser:(NSString *)userID withIdentifier:(NSString *)imageID
{ 
    NSData *imageData = UIImagePNGRepresentation(image);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pathForCurrentUser = [[documentsPath stringByAppendingPathComponent:userID] stringByAppendingPathComponent:@"archiveImages"];
    
    if (![fileManager fileExistsAtPath:pathForCurrentUser]) {
       BOOL directoryCreated = [fileManager createDirectoryAtPath:pathForCurrentUser withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"directoryCreated %hhd", directoryCreated);
    }
    
    NSString *pathForImageBeingSaved = [pathForCurrentUser stringByAppendingPathComponent:imageID];
    BOOL ableToSaveToUserFile = [imageData writeToFile:pathForImageBeingSaved atomically:NO];
    NSLog(@"ableToSaveToUserFile %hhd", ableToSaveToUserFile);

}

+ (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL directoryExists = NO;
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (exists) {
        /* file exists */
        if (isDir) {
            /* file is a directory */
            directoryExists = YES;
        }
    }
    
    return directoryExists;
}

+ (NSMutableArray *)getAllArchiveImagesForUser:(NSString *)userID;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:userID];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:[[NSBundle bundleWithPath:filePath] bundleURL]
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    NSMutableArray *iHateiOSTypeArray = [[NSMutableArray alloc] initWithArray:contents];
    
    return iHateiOSTypeArray;
}

+ (NSMutableArray *)calculateAndGetFileCreationDate:(NSArray *)archiveImagesArray
{
    NSMutableArray *archiveDatesArray = [NSMutableArray array];

    for (NSURL *archiveImagesurl in archiveImagesArray) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDate *creationDate = nil;
        
        if ([fileManager fileExistsAtPath:archiveImagesurl.path]) {
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:archiveImagesurl.path error:nil];
            creationDate = attributes[NSFileCreationDate];
        }
        [archiveDatesArray addObject:creationDate];
    }
    
    if (!archiveImagesArray) {
        return nil;
    } else {
        return archiveDatesArray;
    }
}

+ (void)deleteFileForDirectory:(NSString *)userID
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:userID];
    NSError *error = nil;
    
    if (![fileManager removeItemAtPath:filePath error:&error]) {
        NSLog(@"[Error] %@ (%@)", error, filePath);
    }
}

@end
