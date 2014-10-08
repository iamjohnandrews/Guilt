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
#import "DonationHistory.h"
#import "ImageSaver.h"
#import "CoreData+MagicalRecord.h"

@interface UserProfileViewController () {
    NSMutableArray *donorInfo;
    int tempPoints;
    
}
@property (weak, nonatomic) IBOutlet UILabel *myKarmaPointsLabel;

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@property (weak, nonatomic) IBOutlet UILabel *passwordTextField;

@property (nonatomic) DonationHistory *donationHistory;

@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"UserProfileViewController";
    donorInfo = [NSMutableArray new];

    // Setup CoreData with MagicalRecord
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Model"];
    
    if ([self checkInternetConnection]) {
        [self getParseData];
    } else {
        [ self getCoreData];
    }
}

- (BOOL)checkInternetConnection
{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data) {
        return YES;
    } else {
        return NO;
    }
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
    
    [self myKarmaPointsValueLabel:tempPoints];
    
    [donationsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (PFObject *object in objects) {
                [donorInfo addObject:object];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (![self charityAlreadyExistsInCoreData:[[objects firstObject]objectForKey:@"recipientCharity"] forUser:user.objectId]) {
                    [self updateAndSaveToCoreData:user.objectId];
                }
            });
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [_tableView reloadData];
    }];
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

#pragma mark - Sync Parse and Core Data
- (void)getCoreData
{
    donorInfo = [[DonationHistory findAllSortedBy:self.donationHistory.recipientCharity ascending:YES] mutableCopy];
    DonationHistory *tempObject = [donorInfo firstObject];
    self.myKarmaPointsLabel.text = tempObject.karmaPoints;
}

- (BOOL)charityAlreadyExistsInCoreData:(NSString *)charityName forUser:(NSString *)user
{
    BOOL itsInThere = NO;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[DonationHistory findAllSortedBy:self.donationHistory.recipientCharity ascending:YES] mutableCopy]];
    
    for (DonationHistory *tempObject in tempArray) {
        if ([tempObject.userID isEqualToString:user]) {
            if ([charityName isEqualToString:tempObject.recipientCharity]) {
                itsInThere = YES;
            }
        }
    }
    
    return itsInThere;
}

- (void)updateAndSaveToCoreData:(NSString *)forUser
{
    for (PFObject *singleDonation in donorInfo) {
        self.donationHistory = [DonationHistory createEntity];
        self.donationHistory.date = singleDonation.createdAt;
        self.donationHistory.donationAmount = [[singleDonation objectForKey:@"donationAmount"] floatValue];
        self.donationHistory.recipientCharity = [singleDonation objectForKey:@"recipientCharity"];
        self.donationHistory.userID = forUser;
        self.donationHistory.karmaPoints = self.myKarmaPointsLabel.text;
    }
    [self saveContext];
}

- (void)saveContext {
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
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
    
    NSString *charityName;
    float moneyFormat;
    NSDate *donationTimeStamp;
    UIImage *logoImage = [[UIImage alloc] init];
    
    if ([[donorInfo firstObject] isKindOfClass:[DonationHistory class]]) {
        DonationHistory *donation = donorInfo[indexPath.row];
        charityName = donation.recipientCharity;
        moneyFormat = donation.donationAmount;
        donationTimeStamp = donation.date;
        logoImage = [ImageSaver fetchImageFromDiskWithName:charityName];
    } else {
        charityName = [[donorInfo objectAtIndex:indexPath.row] objectForKey:@"recipientCharity"];
        NSNumber *donationAmount = [[donorInfo objectAtIndex:indexPath.row] objectForKey:@"donationAmount"];
        moneyFormat = [donationAmount floatValue];
        PFObject *object = [donorInfo objectAtIndex:indexPath.row];
        donationTimeStamp = object.createdAt;
        
        for (CharityImage *charity in [CharityImage allCharityDetails:NO]) {
            if ([charity.charityName isEqualToString:charityName]) {
                logoImage = charity.charityLogo;
            }
        }
    }
    
    if ([charityName isEqualToString:@"made a purchase"]) {
        cell.moneyDetailsLabel.text = [NSString stringWithFormat:@"Purchase made $%.02f", moneyFormat];
    } else {
        cell.moneyDetailsLabel.text = [NSString stringWithFormat:@"Donation Amount $%.02f", moneyFormat];
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee, MMMM dd, yyyy"];
    cell.donationTimeStamp.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:donationTimeStamp]];
    
    CGSize shrinkLogoSize = CGSizeMake(81.0f, 44.0f);
    UIGraphicsBeginImageContext(shrinkLogoSize);
    [logoImage drawInRect:CGRectMake(0,0,shrinkLogoSize.width,shrinkLogoSize.height)];
    UIImage* shrunkLogoImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([charityName isEqualToString:@"made a purchase"]) {
        shrunkLogoImage = [UIImage imageNamed:@"dollarSign.jpg"];
    }
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
