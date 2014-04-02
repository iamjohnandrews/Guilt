//
//  UserProfileViewController.m
//  Guilt
//
//  Created by Agnt86 on 11/5/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController () {
  //  DonationsTableViewController *donationsTable;
    NSMutableArray *donorInfo;
    int tempPoints;
    
}
@property (weak, nonatomic) IBOutlet UILabel *myKarmaPointsLabel;

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@property (weak, nonatomic) IBOutlet UILabel *passwordTextField;

- (IBAction)didSaveUserUpdates:(id)sender;

@property (strong, nonatomic) NSDictionary *charityLogos;
@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.charityLogos = [NSDictionary dictionary];
    self.charityLogos = @{@"African Well Fund": @"http://www.africare.org/images/galleries/awf.jpg", 
                          @"Feed The Children": @"https://secure2.convio.net/ftc/images/lp/lpftc/FTC_Logo_white_2012-v1.png", 
                          @"Soilder's Angels": @"http://cdn2-b.examiner.com/sites/default/files/styles/image_content_width/hash/59/bc/59bc9a519241654dacf1ca0f5ac1fa22.jpg?itok=DGti-1TU",
                          @"The Animal Rescue Site": @"http://www.purrwv.org/assets/images/theanimalrescuesite.jpg",
                          @"Unicef": @"http://g3ict.org/design/js/tinymce/filemanager/userfiles/Image/G3ict%20Company%20Profiles/unicef-logo.jpeg",
                          @"Heifer International": @"http://www.heifer.org/resources/images/logo.png",
                          @"made a purchase": @"http://www.american-apartment-owners-association.org/wp-content/uploads/2009/06/dollar-20sign-small1.jpg"};
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (donorInfo.count == 0) {
        return 0;
    }
    return donorInfo.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserHistoryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserHistory"];
    
    NSString *charityName = [[donorInfo objectAtIndex:indexPath.row] objectForKey:@"recipientCharity"];    
    NSNumber *donationAmount = [[donorInfo objectAtIndex:indexPath.row] objectForKey:@"donationAmount"];
    float moneyFormat = [donationAmount floatValue];
    NSLog(@"Getting %@", charityName);
    if ([charityName isEqualToString:@"made a purchase"]) {
        cell.moneyDetailsLabel.text = [NSString stringWithFormat:@"Purchase made $%.02f", moneyFormat];
    } else {
        cell.moneyDetailsLabel.text = [NSString stringWithFormat:@"Donation Amount $%.02f", moneyFormat];
    }
    cell.logoImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.charityLogos objectForKey:charityName]]]];
    
    return cell;    
}

#pragma mark - Table view delegate

- (IBAction)didSaveUserUpdates:(id)sender {
    PFUser *user = [PFUser currentUser];
    
    user[@"email"] = _emailAddressTextField.text;
    user[@"password"] = _passwordTextField.text;
    
    [user saveInBackground];
}

- (IBAction)saveButton:(id)sender {
}

@end
