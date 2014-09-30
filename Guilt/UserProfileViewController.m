//
//  UserProfileViewController.m
//  Guilt
//
//  Created by Agnt86 on 11/5/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "UserProfileViewController.h"
#import "CharityImage.h"
#import "ArchiveTableViewController.h"

@interface UserProfileViewController () {
    NSMutableArray *donorInfo;
    int tempPoints;
    
}
@property (weak, nonatomic) IBOutlet UILabel *myKarmaPointsLabel;

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@property (weak, nonatomic) IBOutlet UILabel *passwordTextField;

@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"UserProfileViewController";
    donorInfo = [NSMutableArray new];
    
    PFQuery *donationsQuery = [PFQuery queryWithClassName:@"Donation"];
    [donationsQuery whereKey:@"donor" equalTo: [PFUser currentUser] ];
    [donationsQuery includeKey:@"donor"];

    PFUser *user = [PFUser currentUser];
    
    NSNumber *currPoints =user[@"points"];
    if (!currPoints) {
        tempPoints=0;
    }
    else {
        tempPoints = [currPoints integerValue];
    }
    
    if (tempPoints >=0) {
        _myKarmaPointsLabel.text = [NSString stringWithFormat:@"+%i",tempPoints];
    }
    else {
        _myKarmaPointsLabel.text = [NSString stringWithFormat:@"-%i",tempPoints];
    }
    
    [donationsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (PFObject *object in objects) {
                [donorInfo addObject:object];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [_tableView reloadData];
    }];
}

#pragma mark - Tableview Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (donorInfo.count == 0) {
        return 0;
    }
    return donorInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserHistoryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserHistory"];
    cell.userInteractionEnabled = NO;
    
    NSString *charityName = [[donorInfo objectAtIndex:indexPath.row] objectForKey:@"recipientCharity"];
    NSNumber *donationAmount = [[donorInfo objectAtIndex:indexPath.row] objectForKey:@"donationAmount"];
    float moneyFormat = [donationAmount floatValue];

    if ([charityName isEqualToString:@"made a purchase"]) {
        cell.moneyDetailsLabel.text = [NSString stringWithFormat:@"Purchase made $%.02f", moneyFormat];
    } else {
        cell.moneyDetailsLabel.text = [NSString stringWithFormat:@"Donation Amount $%.02f", moneyFormat];
    }
    
    PFObject *object = [donorInfo objectAtIndex:indexPath.row];
    NSDate *donationTimeStamp = object.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee, MMMM dd, yyyy"];
    cell.donationTimeStamp.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:donationTimeStamp]];
    
    UIImage *logoImage = [[UIImage alloc] init];
    for (CharityImage *charity in [CharityImage allCharityDetails:NO]) {
        if ([charity.charityName isEqualToString:charityName]) {
            logoImage = charity.charityLogo;
        }
    }
    
    CGSize shrinkLogoSize = CGSizeMake(81.0f, 44.0f);
    UIGraphicsBeginImageContext(shrinkLogoSize);
    [logoImage drawInRect:CGRectMake(0,0,shrinkLogoSize.width,shrinkLogoSize.height)];
    UIImage* shrunkLogoImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.logoImageView.image = shrunkLogoImage;

    return cell;    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserToArchiveSegue"]) {
        ArchiveTableViewController * archiveVC = [segue destinationViewController];
        archiveVC.imageTransformEnabled = YES;
        archiveVC.segueingFromUserProfileOrShareVC = YES;
    } 
}

@end
