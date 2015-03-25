//  ImageSaver.h
//  Magical_Record
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import <Foundation/Foundation.h>

@interface ImageSaver : NSObject

- (void)saveImageToDisk:(UIImage *)logo forCharity:(NSString *)name;
- (UIImage *)fetchImageFromDiskWithName:(NSString *)imageTitle;
- (void)deleteImageAtPath:(NSString*)path;
- (BOOL)imageAlreadySavedToDiskWithName:(NSString *)imageTitle;
- (NSArray *)getAllLogs;

- (void)saveMemeToArchiveDisk:(NSArray*)imagesArray forUser:(NSString *)userID withIdentifier:(NSArray *)imageIDsArray;
- (NSArray *)getAllArchiveImagesForUser:(NSString *)userID;
- (NSArray *)calculateAndGetFileCreationDate:(NSArray *)archiveImagesArray;
- (void)deleteFileForDirectory:(NSString *)userID withIdentifier:(NSString *)imageID;

@end
