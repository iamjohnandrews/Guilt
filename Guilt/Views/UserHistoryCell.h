//
//  UserHistoryCell.h
//  Guilt
//
//  Created by John Andrews on 3/31/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Charity.h"
@interface UserHistoryCell : UITableViewCell
@property (strong, nonatomic) Charity *charity;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyDetailsLabel;

@end
