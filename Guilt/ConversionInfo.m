//
//  ConversionInfo.m
//  Guilt
//
//  Created by John Andrews on 11/15/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ConversionInfo.h"

@implementation ConversionInfo

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.charityName = [decoder decodeObjectForKey:@"charityName"];
    self.singularDescription = [decoder decodeObjectForKey:@"singularDescription"];
    self.pluralDescription = [decoder decodeObjectForKey:@"pluralDescription"];
    self.conversionValue = [decoder decodeObjectForKey:@"conversionValue"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.charityName forKey:@"charityName"];
    [encoder encodeObject:self.singularDescription forKey:@"singularDescription"];
    [encoder encodeObject:self.pluralDescription forKey:@"pluralDescription"];
    [encoder encodeObject:self.conversionValue forKey:@"conversionValue"];
}

@end
