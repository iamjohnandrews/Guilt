//
//  UserHistoryCell.h
//  Guilt
//
//  Created by John Andrews on 3/31/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *donationTimeStamp;

@end
