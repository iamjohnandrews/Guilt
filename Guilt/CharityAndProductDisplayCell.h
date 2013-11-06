//
//  CharityAndProductDisplayCell.h
//  Guilt
//
//  Created by John Andrews on 10/30/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharityAndProductDisplayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;

@property (weak, nonatomic) IBOutlet UILabel *charityConversionDetailsLabel;

@property (nonatomic) UIImageView *donationButton;

@property (weak, nonatomic) IBOutlet UIView *mainView;

- (void)charityDisplay:(NSMutableArray*)arrayOfCharities andIndexPath:(NSIndexPath*)indexPath;

@end
