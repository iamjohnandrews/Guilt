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


@interface FlickrNetworkManager ()
@property (strong, nonatomic) AFHTTPSessionManager *session;
@property (strong, nonatomic) NSMutableArray *charityPhotos;
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

//- (void)requestCharityImagescompletion:(FlickrImageRequestCompletion)completion;
- (void)requestImagesForQuery:(NSString *)query
                   completion:(FlickrImageRequestCompletion)completion
{
    NSDictionary *charities = @{@0 : @"sad pets",
                                @1 : @"child eyes",
                                @2 : @"children ducklings",
                                @3 : @"apiculturists bee",
                                @4 : @"military care package",
                                @5 : @"children drinking water africa"};
    self.charityPhotos = [NSMutableArray array];

    
    for (int flickrCall = 0; flickrCall < charities.count; flickrCall++) {
        NSURLSessionDataTask *dataTask = [self.session GET:@""
                                                parameters:@{@"method": FLICKR_METHOD_PHOTO_SEARCH,
                                                             @"api_key": FLICKR_API_KEY,
                                                             @"text": [charities objectForKey:[NSNumber numberWithInt:flickrCall]],
                                                             @"safe_search": @"1",
                                                             @"format": @"rest",
                                                             @"extras": @"url_l"}
                                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                                       NSArray *photos = [self parseImagesXMLRequest:responseObject];
                                                       if (completion) {
                                                           completion(photos);
                                                       }
                                                   }
                                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                       NSLog(@"%@ %@ %@", error, [error localizedDescription], [error localizedFailureReason]);
                                                   }];
        [dataTask resume];
    }
    
     CharityImage *newImage = [[CharityImage alloc] init];
    [newImage.imageURLArray arrayByAddingObject:self.charityPhotos];
    
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
                               NSURL *imageUrl = [[NSURL alloc] init];
                               imageUrl = [NSURL URLWithString:urlString];

                               [self.charityPhotos addObject:imageUrl];
                               [photos addObject:imageUrl];
                           }
                       }];
    
    return photos;
}

@end
