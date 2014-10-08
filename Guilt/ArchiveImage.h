//
//  ArchiveImage.h
//  Guilt
//
//  Created by John Andrews on 9/30/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ArchiveImage : NSManagedObject

@property (nonatomic, retain) NSData * meme;
@property (nonatomic, retain) NSDate * date;

@end
