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



@end

@implementation UserProfileViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; //Required to run Apple's code for viewWillAppear
    
  //  [self.tableView reloadData]; //reloads data into a table
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//donationsTable = [[DonationsTableViewController alloc]init];
    
  //  [self.view addSubview:donationsTable.view]; //adding the TableViewController's view
    
    donorInfo = [NSMutableArray new];
    
    //find screen dimensions
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    

    
    PFQuery *donationsQuery = [PFQuery queryWithClassName:@"Donation"];
    [donationsQuery whereKey:@"donor" equalTo: [PFUser currentUser] ];
    [donationsQuery includeKey:@"donor"];

    PFUser *user = [PFUser currentUser];
    
    NSNumber *currPoints =user[@"points"];
    
    if (!currPoints) {
        
        tempPoints=0;
        
    }
    else{
        
        tempPoints = [currPoints integerValue];
        
        
    }
    
    if (tempPoints >=0) {
        
        _myKarmaPointsLabel.text = [NSString stringWithFormat:@"+%i",tempPoints];
    }
    else{
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
   // NSLog(@"%lul", (unsigned long)[donorInfo count]);
    if (donorInfo.count == 0) {
        return 0;
    }
    return donorInfo.count;
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSDate *donationDate;
   // PFObject *charity;
    NSString *charityName;
    NSNumber *donationAmount;
    
    NSString* identifier =@"abc";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identifier];
    }
    
    //Person *personTemp =self.people[indexPath.row];
    
    charityName = [[donorInfo objectAtIndex:indexPath.row] objectForKey:@"recipientCharity"];
    NSLog(@"charity: %@", charityName);
    
    donationAmount = [[donorInfo objectAtIndex:indexPath.row] objectForKey:@"donationAmount"];
    
    cell.textLabel.text = [NSString stringWithFormat:@" Charity: %@ Donation Amount $%@", charityName, donationAmount];
    
    cell.textLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:10];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"   Donation Amount: $%@", donationAmount];
    
    
    return cell;
    
}






















- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
