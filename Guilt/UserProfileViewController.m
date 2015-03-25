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
@property (nonatomic, strong) ImageSaver *imageFetch;
@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"UserProfileViewController";
    diskDonorInfo = [NSMutableArray new];
    [self getUsersDonationHistoryFromArchive];
    self.imageFetch = [[ImageSaver alloc] init];

    if (!diskDonorInfo.count && ![AFNetworkReachabilityManager sharedManager].reachable) {
        [self showEncourageToDonateMessage];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    if ([AFNetworkReachabilityManager sharedManager].reachable && !diskDonorInfo.count) {
        [self getParseData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [GoogleAnalytics trackAnalyticsForScreen:self.screenName];
}

- (void)getUsersDonationHistoryFromArchive
{
    NSArray *tempArray = [[NSArray alloc] initWithArray:[UsersLoginInfo getUsersObjectID]];
    
    for (NSString *userID in tempArray) {
        [diskDonorInfo addObjectsFromArray:[UserProfileSaver getUsersDonationHistory:userID]];
    }
    [self myKarmaPointsValueLabel:(int)diskDonorInfo.count * 10];
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
            diskDonorInfo = [self convertPFObjects:objects];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self myKarmaPointsValueLabel:(int)diskDonorInfo.count * 10];
            });
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                [self updateLocalDiskWithUserDonationInfo];
            });
        }
    }];
}

- (void)updateLocalDiskWithUserDonationInfo
{
    for (int i = 0; i < diskDonorInfo.count; i++) {
        [UserProfileSaver saveUserDonatoinHistory:diskDonorInfo[i]];
    }
}

- (NSMutableArray *)convertPFObjects:(NSArray *)donationsArray
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (PFObject *individualDonation in donationsArray) {
        UserDonationHistory *userDonationHistory = [[UserDonationHistory alloc] init];
        userDonationHistory.date = individualDonation.createdAt;
        userDonationHistory.donationAmount = [individualDonation objectForKey:@"donationAmount"];
        userDonationHistory.recipientCharity = [individualDonation objectForKey:@"recipientCharity"];
        userDonationHistory.userID = [[PFUser currentUser] objectId];

        [tempArray addObject:userDonationHistory];
    }
    
    return tempArray;
}

//will probably delete below method and property parseDonorInfoArray
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

    UIImage *logoImage = [[UIImage alloc] init];
    logoImage = [self.imageFetch fetchImageFromDiskWithName:donation.recipientCharity];
    
    CGSize shrinkLogoSize = CGSizeMake(81.0f, 44.0f);
    UIGraphicsBeginImageContext(shrinkLogoSize);
    [logoImage drawInRect:CGRectMake(0,0,shrinkLogoSize.width,shrinkLogoSize.height)];
    UIImage* shrunkLogoImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([donation.recipientCharity isEqualToString:@"made a purchase"]) {
        cell.moneyDetailsLabel.text = [NSString stringWithFormat:@"Purchase made $%.02f", [donation.donationAmount floatValue]];
        shrunkLogoImage = [UIImage imageNamed:@"dollarSign.jpg"];
    } else {
        cell.moneyDetailsLabel.text = [NSString stringWithFormat:@"Donation Amount $%.02f", [donation.donationAmount floatValue]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee, MMMM dd, yyyy"];
    cell.donationTimeStamp.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:donation.date]];

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
