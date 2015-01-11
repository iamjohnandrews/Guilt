//
//  UserProfileViewController.m
//  Guilt
//
//  Created by Agnt86 on 11/5/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ArchiveTableViewController.h"
#import "UserDonationHistory.h"
#import "ImageSaver.h"
#import <AFNetworking/AFNetworking.h>
#import "UserProfileSaver.h"
#import "UsersLoginInfo.h"

@interface UserProfileViewController () {
    NSMutableArray *diskDonorInfo;
    int tempPoints;
    
}
@property (weak, nonatomic) IBOutlet UILabel *myKarmaPointsLabel;

@property (nonatomic, strong) NSMutableArray *parseDonorInfoArray;
@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"UserProfileViewController";
    diskDonorInfo = [NSMutableArray new];
    [self getUsersDonationHistoryFromArchive];
    
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        [self getParseData];
    } 
}

- (void)getUsersDonationHistoryFromArchive
{
    NSArray *tempArray = [[NSArray alloc] initWithArray:[UsersLoginInfo getUsersObjectID]];
    
    for (NSString *userID in tempArray) {
        NSArray *userdonationHistoryArray = [NSArray array];
        userdonationHistoryArray = [UserProfileSaver getUsersDonationHistory:userID];
        
        [diskDonorInfo addObjectsFromArray:userdonationHistoryArray];
    }
    if (!diskDonorInfo.count) {
        [self showEncourageToDonateMessage];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [self myKarmaPointsValueLabel:diskDonorInfo.count * 10];
}

- (void)getParseData
{
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
    
    [donationsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (objects.count != diskDonorInfo.count) {
                self.parseDonorInfoArray = [[NSMutableArray alloc] initWithArray:objects];
                if (self.parseDonorInfoArray.count < diskDonorInfo.count) {
                    [self updateRemoteDatabaseWithUserDonationInfo];
                } else {
                    [self updateLocalDiskWithUserDonationInfo];
                }
            }
        }
    }];
}

- (void)updateLocalDiskWithUserDonationInfo
{
    for (int i = diskDonorInfo.count; i < self.parseDonorInfoArray.count; i++) {
        PFObject *individualDonation = [self.parseDonorInfoArray objectAtIndex:i];
        [UserProfileSaver saveUserDonatoinHistory:[[PFUser currentUser] objectId]
                                       forCharity:[individualDonation objectForKey:@"recipientCharity"]
                                           onDate:individualDonation.createdAt
                                        forAmount:[individualDonation objectForKey:@"donationAmount"]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (void)updateRemoteDatabaseWithUserDonationInfo
{
    NSMutableArray *transferArray = [NSMutableArray array];
    
    for (int i = self.parseDonorInfoArray.count; i < diskDonorInfo.count; i++) {
        UserDonationHistory *individualDonation = diskDonorInfo[i];
        
        PFObject *donation = [PFObject objectWithClassName:@"Donation"];
        donation[@"donor"] = [PFUser currentUser];
        donation[@"recipientCharity"] = individualDonation.recipientCharity;
        donation[@"donationAmount"]= individualDonation.donationAmount;
        
        [transferArray addObject:donation];
    }
    
    [PFObject saveAllInBackground:transferArray];
}

- (void)myKarmaPointsValueLabel:(int)usersPoints
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formattedKarmaPoints;
    formattedKarmaPoints = [formatter stringFromNumber:[NSNumber numberWithInteger:usersPoints]];
    
    if (usersPoints >=0) {
        self.myKarmaPointsLabel.text = [NSString stringWithFormat:@"+%@",formattedKarmaPoints];
    }
    else {
        self.myKarmaPointsLabel.text = [NSString stringWithFormat:@"-%@",formattedKarmaPoints];
    }
}

- (void)showEncourageToDonateMessage
{
    UILabel *shareEncouragementMessage = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, self.tableView.frame.origin.y + 10.0f, self.view.frame.size.width - 40.0f, (44.0f * 3))];
    shareEncouragementMessage.font = [UIFont fontWithName:@"Quicksand-Regular" size:22];
    shareEncouragementMessage.backgroundColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    shareEncouragementMessage.numberOfLines = 0;
    shareEncouragementMessage.textAlignment = NSTextAlignmentCenter;
    shareEncouragementMessage.textColor = [UIColor whiteColor];
    shareEncouragementMessage.text = @"Whenever you make a donation, you earn KarmaPoints";
    [self.view addSubview:shareEncouragementMessage];
}

#pragma mark - Tableview Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return diskDonorInfo.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserHistoryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserHistory"];
    cell.userInteractionEnabled = NO;
    
    UserDonationHistory *donation = diskDonorInfo[indexPath.row];
    NSString *charityName = donation.recipientCharity;
    float moneyFormat = [donation.donationAmount floatValue];
    NSDate *donationTimeStamp = donation.date;

    UIImage *logoImage = [[UIImage alloc] init];
    logoImage = [ImageSaver fetchImageFromDiskWithName:charityName];
    CGSize shrinkLogoSize = CGSizeMake(81.0f, 44.0f);
    UIGraphicsBeginImageContext(shrinkLogoSize);
    [logoImage drawInRect:CGRectMake(0,0,shrinkLogoSize.width,shrinkLogoSize.height)];
    UIImage* shrunkLogoImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([charityName isEqualToString:@"made a purchase"]) {
        cell.moneyDetailsLabel.text = [NSString stringWithFormat:@"Purchase made $%.02f", moneyFormat];
        shrunkLogoImage = [UIImage imageNamed:@"dollarSign.jpg"];
    } else {
        cell.moneyDetailsLabel.text = [NSString stringWithFormat:@"Donation Amount $%.02f", moneyFormat];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee, MMMM dd, yyyy"];
    cell.donationTimeStamp.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:donationTimeStamp]];

    cell.logoImageView.image = shrunkLogoImage;

    return cell;    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserToArchiveSegue"]) {
        ArchiveTableViewController * archiveVC = [segue destinationViewController];
        archiveVC.segueingFromUserProfileOrShareVC = YES;
    } 
}

@end
