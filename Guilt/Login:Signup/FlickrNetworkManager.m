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

- (void)requestImagesForQuery:(NSString *)query
                   completion:(FlickrImageRequestCompletion)completion
{
    NSURLSessionDataTask *dataTask = [self.session GET:@""
                                            parameters:@{@"method": FLICKR_METHOD_PHOTO_SEARCH,
                                                         @"api_key": FLICKR_API_KEY,
                                                         @"text": query,
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

#pragma mark - XML Parsing

- (NSArray *)parseImagesXMLRequest:(NSData *)imageData
{
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:imageData];
    
    NSMutableArray *photos = [NSMutableArray array];
    [rootXML iterateWithRootXPath:@"//photo"
                       usingBlock:^(RXMLElement *photo) {
                           NSString *urlString = [photo attribute:@"url_l"];
                           if (urlString.length) {
                               CharityImage *newImage = [[CharityImage alloc] init];
                               newImage.imageUrl = [NSURL URLWithString:urlString];
                               [photos addObject:newImage];
                           }
                       }];
    
    return photos;
}

@end
