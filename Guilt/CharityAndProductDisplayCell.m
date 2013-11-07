//
//  CharityAndProductDisplayCell.m
//  Guilt
//
//  Created by John Andrews on 10/30/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "CharityAndProductDisplayCell.h"
#import "ImagesViewController.h"

@implementation CharityAndProductDisplayCell
@synthesize charityConversionDetailsLabel, donationButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Puts outline around white font in picture
    charityConversionDetailsLabel.shadowColor = [UIColor blackColor];
    charityConversionDetailsLabel.shadowOffset = CGSizeMake(2, 1);
}

- (void)charityDisplay:(NSMutableArray*)arrayOfCharities andIndexPath:(NSIndexPath*)indexPath
{
//    self.charityConversionDetailsLabel.text = [NSString stringWithFormat:@"%@ %@",[arrayOfCharities objectAtIndex:indexPath.row], [charityDiscriptionsArray objectAtIndex:indexPath.row] ];
//    NSLog(@"the First index.row = %li", (long)indexPath.row);
//    
//    [charityCell bringSubviewToFront:charityCell.charityConversionDetailsLabel];
//    
//    self.donationButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donate.png"]];
//    self.accessoryView = charityCell.donationButton;
//    
//    [self.donationButton setUserInteractionEnabled:YES];
//    
//    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDonationButtonTapped:)];
//    [charityCell.donationButton addGestureRecognizer:recognizer];
//    [self.view addSubview:charityCell.donationButton];
}

@end
