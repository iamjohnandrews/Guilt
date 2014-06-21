//
//  CharityAndProductDisplayCell.h
//  Guilt
//
//  Created by John Andrews on 10/30/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CharityImage;

@interface CharityAndProductDisplayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *charityConversionDetailsLabel;

@property (strong, nonatomic) UIImageView *donationButton;

@property (weak, nonatomic) IBOutlet UILabel *dollarAmountConvertedLabel;

@end
