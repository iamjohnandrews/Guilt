//
//  ImagesViewController.h
//  Guilt
//
//  Created by John Andrews on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Charity.h"

@interface ImagesViewController : BaseViewController

@property NSMutableArray *resultOfCharitableConversionsArray;

@property (weak, nonatomic) IBOutlet UITableView *imagesTableView;
@property (strong,nonatomic) NSString* productName;

@property (strong,nonatomic) NSString* productProductURL;

@property  (weak,nonatomic) NSNumber* productPrice;

@property (assign, nonatomic) CATransform3D makeImagesLean;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *userProfileButtonOutlet;

@property (nonatomic) BOOL userIsLoggedIn;

@property (strong, nonatomic) NSMutableArray *parseNonprofitInfoArray;

-(void)didUpdateKarmaPoints: (BOOL)flag charity:(NSString*)recipientCharity;

- (IBAction)userProfileButton:(id)sender;

@end
