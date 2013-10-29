//
//  ImagesViewController.h
//  Guilt
//
//  Created by John Andrews on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *charityValueDisplayLabel;

@property NSMutableArray *resultOfCharitableConversionsArray;

@end
