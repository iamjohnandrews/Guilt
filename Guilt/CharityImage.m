//
//  CharityImage.m
//  Guilt
//
//  Created by John Andrews on 5/12/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "CharityImage.h"

@implementation CharityImage

static NSMutableSet *allInstances;

+ (NSArray *)allCharityDetails:(BOOL)randomized
{

    
    NSMutableArray *returnObject = [[allInstances allObjects] mutableCopy];
    if (randomized) {
        //randomize code here
        NSUInteger count = [returnObject count];
        for (NSUInteger i = 0; i < count; ++i) {
            NSInteger remainingCount = count - i;
            NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
            [returnObject exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        }
    }
    return [NSArray arrayWithArray:returnObject];

}

-(id)init
{
    NSLog(@"Init called!");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allInstances = [NSMutableSet set];
    });
    id instance = [super init];
    [allInstances addObject:instance];
    return instance;
}

@end
