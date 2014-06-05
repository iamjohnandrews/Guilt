//
//  FlickrNetworkManager.m
//  Trending Tunes
//
//  Created by Christopher Constable on 2/3/14.
//
//

#import "FlickrNetworkManager.h"

// Frameworks / Libraries
#import <AFNetworking/AFNetworking.h>
#import <RaptureXML/RXMLElement.h>

// Models
#import "CharityImage.h"

//Chris Constables Flickr
NSString * const FlickrAPIKey = @"ba09703c363c9c64279b1a1f4a2d196a";


@interface FlickrNetworkManager ()
@property (strong, nonatomic) AFHTTPSessionManager *session;
@end

@implementation FlickrNetworkManager

+ (instancetype) sharedManager
{
    static FlickrNetworkManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedManager = [[self alloc] init];
        sharedManager.session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:FLICKR_BASE_API_URL]];
        sharedManager.session.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return sharedManager;
}

- (void)requestCharityImagescompletion:(FlickrImageRequestCompletion)completion;
//- (void)requestImagesForQuery:(NSString *)query completion:(FlickrImageRequestCompletion)completion
{
    CharityImage *imageModel = [[CharityImage alloc] init];
    self.flickrCharityUrlArray = [NSMutableArray array];
    NSDictionary *charities = @{@0 : @"sad pets",
                                @1 : @"child eyes",
                                @2 : @"children vaccination",
                                @3 : @"children ducklings",
                                @4 : @"apiculturists bee",
                                @5 : @"military care package",
                                @6 : @"children drinking water africa"};
    
    for (int flickrCall = 0; flickrCall < charities.count; flickrCall++) {
        NSURLSessionDataTask *dataTask = [self.session GET:@""
                                                parameters:@{@"method": FLICKR_METHOD_PHOTO_SEARCH,
                                                             @"api_key": FlickrAPIKey,
                                                             @"text": [charities objectForKey:[NSNumber numberWithInt:flickrCall]],
                                                             @"safe_search": @"1",
                                                             @"format": @"rest",
                                                             @"extras": @"url_l"}
                                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                                       NSArray *photos = [self parseImagesXMLRequest:responseObject];
                                                       NSLog(@"Number photos returned from Flickr =%d", photos.count);
                                                       
                                                       [imageModel.imageURLArray addObject:photos];
                                                       [self.flickrCharityUrlArray addObject:photos];
                                                       
                                                       if (completion) {
                                                           completion(photos);
                                                       }
                                                   }
                                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                       NSLog(@"%@ %@ %@", error, [error localizedDescription], [error localizedFailureReason]);
                                                   }];
        [dataTask resume];
    }
    
//    [newImage.imageURLArray arrayByAddingObject:self.charityPhotos];
//    NSLog(@"Number of Photos in MODEL = %d", newImage.imageURLArray.count);
//    NSLog(@"@Total amount of Photos from Flickr = %d", self.charityPhotos.count);

//    NSURLSessionDataTask *dataTask = [self.session GET:@""
//                                            parameters:@{@"method": FLICKR_METHOD_PHOTO_SEARCH,
//                                                         @"api_key": FLICKR_API_KEY,
//                                                         @"text": query,
//                                                         @"safe_search": @"1",
//                                                         @"format": @"rest",
//                                                         @"extras": @"url_l"}
//                                               success:^(NSURLSessionDataTask *task, id responseObject) {
//                                                   NSArray *photos = [self parseImagesXMLRequest:responseObject];
//                                                   if (completion) {
//                                                       completion(photos);
//                                                   }
//                                               }
//                                               failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                                   NSLog(@"%@ %@ %@", error, [error localizedDescription], [error localizedFailureReason]);
//                                               }];
//    [dataTask resume];
}

#pragma mark - XML Parsing

- (NSArray *)parseImagesXMLRequest:(NSData *)imageData
{
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:imageData];
    NSMutableArray *photos = [NSMutableArray array];
    [rootXML iterateWithRootXPath:@"//photo"
                       usingBlock:^(RXMLElement *photo) {
                           NSString *urlString = [photo attribute:@"url_l"];
                           if (urlString.length) {
//                               NSURL *imageUrl = [[NSURL alloc] init];
                               CharityImage *newImage = [[CharityImage alloc] init];
                               newImage.imageUrl = [NSURL URLWithString:urlString];
                               [photos addObject:newImage.imageUrl];
                           }
                       }];
    
    return photos;
}

@end
