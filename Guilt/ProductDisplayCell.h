//
//  ProductDisplayCell.h
//  Guilt
//
//  Created by John Andrews on 10/30/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDisplayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productNameDisplayLabel;

@property (weak, nonatomic) IBOutlet UILabel *onlinePriceDisplayLabel;

@property (weak, nonatomic) IBOutlet UILabel *urlDisplayLabel;

@end
