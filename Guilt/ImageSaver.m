//  ImageSaver.m
//  Magical_Record
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import "ImageSaver.h"

@interface ImageSaver ()
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSString *charityLogosPath;
@property (strong, nonatomic) NSString *memesPath;
@property (strong, nonatomic) NSString *documentsDirectory;

@end

@implementation ImageSaver

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
        self.documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        self.charityLogosPath = [self.documentsDirectory stringByAppendingPathComponent:@"charityLogos"];
        self.memesPath = [self.documentsDirectory stringByAppendingString:@"archiveImages"];
    }
    
    return self;
}

- (void)saveImageToDisk:(UIImage *)logo forCharity:(NSString *)name
{
    NSString *noWhiteSpaceCharityName = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSData *imageData = UIImagePNGRepresentation(logo);
    
    if (![self.fileManager fileExistsAtPath:self.charityLogosPath]) {
        BOOL directoryCreated = [self.fileManager createDirectoryAtPath:self.charityLogosPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"directory for Logo Created %d", directoryCreated);
    }
    
    NSString *savedImagePath = [self.charityLogosPath stringByAppendingPathComponent:noWhiteSpaceCharityName];
    BOOL isLogoSaved = [imageData writeToFile:savedImagePath atomically:NO];
    NSLog(@"isLogoSaved for charity%@ =%i", name, isLogoSaved);
}


- (UIImage *)fetchImageFromDiskWithName:(NSString *)imageTitle
{
    NSString *noWhiteSpaceCharityName = [imageTitle stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *getImagePath = [self.charityLogosPath stringByAppendingPathComponent:noWhiteSpaceCharityName];
    
    return [UIImage imageWithContentsOfFile:getImagePath];
}

- (BOOL)imageAlreadySavedToDiskWithName:(NSString *)imageTitle
{
    NSString *noWhiteSpaceCharityName = [imageTitle stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *specificCharityLogoPath = [self.charityLogosPath stringByAppendingPathComponent:noWhiteSpaceCharityName];
    
    return [self.fileManager fileExistsAtPath:specificCharityLogoPath];
}

- (NSArray *)getAllLogs;
{
    NSArray *contents = [self.fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:self.charityLogosPath]
                                        includingPropertiesForKeys:@[]
                                                           options:NSDirectoryEnumerationSkipsHiddenFiles
                                                             error:nil];
    return contents;
}

- (void)deleteImageAtPath:(NSString *)path {
	NSError *error;
	NSString *imgToRemove = [NSHomeDirectory() stringByAppendingPathComponent:path];
	[self.fileManager removeItemAtPath:imgToRemove error:&error];
}

#pragma mark Archive Specific Methods
- (void)saveMemeToArchiveDisk:(NSArray*)imagesArray forUser:(NSString *)userID withIdentifier:(NSArray *)imageIDsArray
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        for (int i =0; i < imagesArray.count; i++) {
            NSData *imageData = UIImagePNGRepresentation(imagesArray[i]);
            NSString *pathForCurrentUser = [self.memesPath stringByAppendingPathComponent:userID];
            
            if (![self.fileManager fileExistsAtPath:pathForCurrentUser]) {
                BOOL directoryCreated = [self.fileManager createDirectoryAtPath:pathForCurrentUser withIntermediateDirectories:YES attributes:nil error:nil];
                NSLog(@"Archive Directory Created %hhd", directoryCreated);
            }
            
            NSString *pathForImageBeingSaved = [pathForCurrentUser stringByAppendingPathComponent:imageIDsArray[i]];
            BOOL ableToSaveToUserFile = [imageData writeToFile:pathForImageBeingSaved atomically:NO];
            NSLog(@"ableToSaveToUserFile %hhd", ableToSaveToUserFile);
        }
    });
}

- (NSArray *)getAllArchiveImagesForUser:(NSString *)userID;
{
    NSURL *allUsersMemesURL = [NSURL URLWithString:[self.memesPath stringByAppendingPathComponent:userID]];
    NSArray *contents = [self.fileManager contentsOfDirectoryAtURL:allUsersMemesURL
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    return contents;
}

- (NSArray *)calculateAndGetFileCreationDate:(NSArray *)archiveImagesArray
{
    if (!archiveImagesArray) {
        return nil;
    }
    NSMutableArray *archiveDatesArray = [NSMutableArray array];

    for (NSURL *archiveImagesurl in archiveImagesArray) {
        NSDate *creationDate = nil;
    
        if ([self.fileManager fileExistsAtPath:archiveImagesurl.path]) {
            NSDictionary *attributes = [self.fileManager attributesOfItemAtPath:archiveImagesurl.path error:nil];
            creationDate = attributes[NSFileCreationDate];
        }
        [archiveDatesArray addObject:creationDate];
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject: descriptor];
    NSArray *descendingDateOrder = [archiveDatesArray sortedArrayUsingDescriptors:descriptors];
    
    return descendingDateOrder;
}

- (void)deleteFileForDirectory:(NSString *)userID withIdentifier:(NSString *)imageID
{
    NSString *memeFilePath = [[self.memesPath stringByAppendingPathComponent:userID] stringByAppendingPathComponent:imageID];
    NSError *error = nil;
    
    if (![self.fileManager removeItemAtPath:memeFilePath error:&error]) {
        NSLog(@"[Error] %@", error);
    }
}

@end
