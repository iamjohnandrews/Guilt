//  ImageSaver.h
//  Magical_Record
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import <Foundation/Foundation.h>

@interface ImageSaver : NSObject

+ (void)saveImageToDisk:(UIImage*)image withName:(NSString *)imageTitle;
+ (UIImage *)fetchImageFromDiskWithName:(NSString *)imageTitle;
+ (BOOL)imageAlreadySavedToDiskWithName:(NSString *)imageTitle;
+ (void)deleteImageAtPath:(NSString*)path;
@end
