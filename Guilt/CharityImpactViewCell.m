//
//  CharityImpactViewCell.m
//  Guilt
//
//  Created by John Andrews on 10/24/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "CharityImpactViewCell.h"

@implementation CharityImpactViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIView* charityBackgroundColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 315, 147)];
        self.backgroundView = charityBackgroundColor;
        self.backgroundView.backgroundColor = [UIColor lightGrayColor];
        
        UIView* selectedCharityBackgroundColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 315, 147)];
        self.selectedBackgroundView = selectedCharityBackgroundColor ;
        self.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    }
    return self;
}
//use nonprofit's logo as the .backgroundView of the CollectionViews


@end
