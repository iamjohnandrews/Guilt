//
//  ArchiveTableViewController.h
//  Guilt
//
//  Created by John Andrews on 6/12/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveTableViewController : UITableViewController
- (IBAction)imageLoader:(id)sender;
@property (nonatomic) BOOL imageTransformEnabled;
@property (nonatomic) BOOL segueingFromUserProfileOrShareVC;

@end
