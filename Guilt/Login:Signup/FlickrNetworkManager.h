//
//  FlickrNetworkManager.h
//  Trending Tunes
//
//  Created by Christopher Constable on 2/3/14.
//
//

typedef void (^FlickrImageRequestCompletion)(NSArray *images);

@interface FlickrNetworkManager : NSObject

+ (instancetype)sharedManager;

- (void)requestCharityImagescompletion:(FlickrImageRequestCompletion)completion;
@property (strong,nonatomic) NSMutableDictionary *flickrCharityUrlDictionary;
@property (strong,nonatomic) NSDictionary *charitySearchTerms;
@end
