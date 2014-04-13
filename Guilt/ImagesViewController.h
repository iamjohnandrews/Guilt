//
//  ImagesViewController.h
//  Guilt
//
//  Created by John Andrews on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewController : BaseViewController

@property NSMutableArray *resultOfCharitableConversionsArray;
@property (strong, nonatomic) NSDictionary *resultOfCharitableConversionsDict;

@property (weak, nonatomic) IBOutlet UITableView *imagesTableView;
@property (strong,nonatomic) NSString* productName;

@property (strong,nonatomic) NSString* productProductURL;

@property  (weak,nonatomic) NSNumber* productPrice;

@property (assign, nonatomic) CATransform3D makeImagesLean;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *userProfileButtonOutlet;

@property (strong, nonatomic) NSMutableArray *parseNonprofitInfoArray;

-(void)didUpdateKarmaPoints: (BOOL)flag charity:(NSString*)recipientCharity;

- (IBAction)userProfileButton:(id)sender;

@end
