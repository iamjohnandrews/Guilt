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

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *charityConversionDetailsLabel;

@property (weak, nonatomic) IBOutlet UILabel *dollarAmountConvertedLabel;
@property (weak, nonatomic) IBOutlet UIButton *donateButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *shareButtonOutlet;

- (void)updateUI;

@end
