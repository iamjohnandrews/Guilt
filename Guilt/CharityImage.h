//
//  CharityImage.h
//  Guilt
//
//  Created by John Andrews on 5/12/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharityImage : NSObject

@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) NSArray *allCharityImageArray;
@property (strong, nonatomic) NSMutableArray *imageURLArray;


@end

