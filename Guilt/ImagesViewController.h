//
//  ImagesViewController.h
//  Guilt
//
//  Created by John Andrews on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDisplayCell.h"
#import "Charity.h"

@interface ImagesViewController : UITableViewController

@property NSMutableArray *resultOfCharitableConversionsArray;

@property (strong,nonatomic) ProductDisplayCell* productCellTemp;

@property (strong,nonatomic) NSString* productName;

@property (strong,nonatomic) NSString* productProductURL;

@property  (weak,nonatomic) NSNumber* productPrice;

@property (assign, nonatomic) CATransform3D makeImagesLean;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *userProfileButtonOutlet;

@property (nonatomic) BOOL userIsLoggedIn;

-(void)didUpdateKarmaPoints: (BOOL)flag charity:(NSString*)recipientCharity;

- (IBAction)userProfileButton:(id)sender;

@end
