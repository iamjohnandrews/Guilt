//  ImageSaver.h
//  Magical_Record
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import <Foundation/Foundation.h>

@interface ImageSaver : NSObject

+ (void)saveImageToDisk:(UIImage*)image withName:(NSString *)imageTitle;
+ (UIImage *)fetchImageFromDiskWithName:(NSString *)imageTitle;
+ (void)deleteImageAtPath:(NSString*)path;
+ (BOOL)imageAlreadySavedToDiskWithName:(NSString *)imageTitle;

+ (void)saveMemeToArchiveDisk:(UIImage*)image forUser:(NSString *)userID withIdentifier:(NSString *)imageID;
+ (NSMutableArray *)getAllArchiveImagesForUser:(NSString *)userID;
+ (NSMutableArray *)calculateAndGetFileCreationDate:(NSArray *)archiveImagesArray;
+ (void)deleteFileForDirectory:(NSString *)userID;

@end
