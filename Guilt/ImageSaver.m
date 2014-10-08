//  ImageSaver.m
//  Magical_Record
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import "ImageSaver.h"


@implementation ImageSaver

+ (void)saveImageToDisk:(UIImage*)image withName:(NSString *)imageTitle
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageTitle];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];

}

+ (UIImage *)fetchImageFromDiskWithName:(NSString *)imageTitle
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageTitle];
    
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

@end
