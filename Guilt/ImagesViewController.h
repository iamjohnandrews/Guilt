//
//  ImagesViewController.h
//  Guilt
//
//  Created by John Andrews on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDisplayCell.h"

@interface ImagesViewController : UITableViewController

@property NSMutableArray *resultOfCharitableConversionsArray;

@property (strong,nonatomic) ProductDisplayCell* productCellTemp;

@property (strong,nonatomic) NSString* productName;

@property (strong,nonatomic) NSString* productProductURL;

@property  (weak,nonatomic) NSNumber* productPrice;

@property (assign, nonatomic) CATransform3D makeImagesLean;

-(void)didUpdateKarmaPoints: (BOOL)flag charity:(NSString*)recipientCharity;

- (IBAction)userProfileButton:(id)sender;

- (IBAction)logoutButton:(id)sender;

@end
