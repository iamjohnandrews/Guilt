//
//  ArchiveTableViewCell.m
//  Guilt
//
//  Created by John Andrews on 6/12/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ArchiveTableViewCell.h"

@implementation ArchiveTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.archiveImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}


@end
