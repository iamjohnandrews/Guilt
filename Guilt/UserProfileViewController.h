//
//  UserProfileViewController.h
//  Guilt
//
//  Created by Agnt86 on 11/5/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UserHistoryCell.h"

@interface UserProfileViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *parseNonprofitInfoArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)saveButton:(id)sender;

@end
