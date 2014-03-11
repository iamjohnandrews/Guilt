//
//  ImagesViewController.m
//  Guilt
//
//  Created by John Andrews on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "ImagesViewController.h"
#import "ConversionViewController.h"
#import "CharityAndProductDisplayCell.h"
#import "ScannerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface ImagesViewController (){
    NSArray* charityImagesArray;
    NSArray* charityDiscriptionsArray;
    NSArray* charityDonationPage;
    NSArray* charityNames;
    NSNumber* currPoints;
}

@end

@implementation ImagesViewController
@synthesize resultOfCharitableConversionsArray, makeImagesLean;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.userIsLoggedIn == NO) {
        self.userProfileButtonOutlet.enabled = NO;
    } else {
        self.userProfileButtonOutlet.enabled = YES;
    }    
    charityImagesArray = @[@"homeless dogs.png", @"feedTheHungry.png", @"homelessFamily.png",@"ducklingsFlock.png", @"honeybee.png", @"Soldiers.png", @"waterPump.png"];
    
    charityDiscriptionsArray = @[@"animal meals through The Animal Rescue Site",
                                 @"month(s) of vaccines, schooling & natural disaster relief through Unicef",
                                 @"month(s) of food, water, and medical supplies through Feed The Children",
                                 @"flock(s) of ducklings for a family",
                                 @"gift(s) of honey bees",
                                 @"military care package(s) through Soildier's Angels",
                                 @"natural spring catchment(s) serving 250 people through African Well Fund"
                                 ];
    charityDonationPage = @[@"https://theanimalrescuesite.greatergood.com/store/ars/item/32249/contribute-to-animal-rescue?source=12-32132-3#productInfo",
                            @"http://www.supportunicef.org/site/c.dvKUI9OWInJ6H/b.7677883/k.2C8F/Donate_now.htm", 
                            @"https://secure2.convio.net/ftc/site/SPageServer?pagename=donate",
                            @"http://www.heifer.org/gift-catalog/animals-nutrition/flock-of-ducks-donation.html",
                            @"http://www.heifer.org/gift-catalog/animals-nutrition/honeybees-donation.html",
                            @"http://soldiersangels.org/donate.html", 
                            @"http://www.africanwellfund.org/donate.html"];
    charityNames = @[@"The Animal Rescue Site", @"Unicef", @"Feed The Children", @"Soilder's Angels", @"African Well Fund"];
    
    //Part of code to get images to animate when appear
    CGFloat rotationAngleDegrees = -15;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    makeImagesLean = transform;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setFontFamily:@"Quicksand-Regular" forView:self.view andSubViews:YES];
}

-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }     
} 

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return resultOfCharitableConversionsArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    
    UITextView *productNameTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 120 )];
    productNameTextView.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
    productNameTextView.text = [NSString stringWithFormat:@"%@\n $%@\n", _productName, _productPrice];
    productNameTextView.backgroundColor = [UIColor colorWithRed:247.0/255 green:150.0/255 blue:0.0/255 alpha:1];
    
    UIButton* urlLinkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    urlLinkButton.backgroundColor = [UIColor blackColor];
    urlLinkButton.frame = CGRectMake(210, 50, 100, 50);

    //headerView.backgroundColor = [UIColor blueColor];
    [urlLinkButton setTitle:@"Buy Now" forState:UIControlStateNormal];
    urlLinkButton.layer.cornerRadius = 8;
    urlLinkButton.layer.borderWidth = 1;
    urlLinkButton.layer.borderColor = [UIColor whiteColor].CGColor;
    urlLinkButton.clipsToBounds = YES;
    urlLinkButton.titleLabel.textColor = [UIColor whiteColor];

    [headerView addSubview:productNameTextView];
    [headerView addSubview:urlLinkButton];
    [headerView bringSubviewToFront:urlLinkButton];
    
    [urlLinkButton setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBuyNowButtonTapped)];
    [urlLinkButton addGestureRecognizer:recognizer];
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
    if (!_productProductURL) {
        return 0;
    } else {
        return 122;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    //Code to display Charities
    
    CharityAndProductDisplayCell *charityCell = [tableView dequeueReusableCellWithIdentifier:@"CharityDisplay"];
    
    //Lean with it, Rock with it
    charityCell.layer.transform = self.makeImagesLean;
    charityCell.layer.opacity = 0.2;
    [UIView animateWithDuration:0.4 animations:^{
        charityCell.layer.transform = CATransform3DIdentity;
        charityCell.layer.opacity = 1;
    }];
    
    charityCell.displayImageView.image = [UIImage imageNamed:[charityImagesArray objectAtIndex:indexPath.row]];
    
    charityCell.charityConversionDetailsLabel.font = [UIFont fontWithName:@"Quicksand-Bold" size:15];
    charityCell.charityConversionDetailsLabel.textColor = [UIColor whiteColor];    
    charityCell.charityConversionDetailsLabel.text = [NSString stringWithFormat:@"%@ %@",[resultOfCharitableConversionsArray objectAtIndex:indexPath.row], [charityDiscriptionsArray objectAtIndex:indexPath.row] ];
    NSLog(@"the First index.row = %li", (long)indexPath.row);
    
    [charityCell bringSubviewToFront:charityCell.charityConversionDetailsLabel];
    
    charityCell.donationButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donate.png"]];
    charityCell.accessoryView = charityCell.donationButton;
    
    [charityCell.donationButton setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDonationButtonTapped:)];
    [charityCell.donationButton addGestureRecognizer:recognizer];
    [self.view addSubview:charityCell.donationButton];
        
    return charityCell;
}

- (void)onDonationButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)gestureRecognizer.view.superview.superview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[charityDonationPage objectAtIndex:indexPath.row]]];
    NSLog(@"the Second index.row = %li", (long)indexPath.row);
    
    [self didUpdateKarmaPoints:YES charity:[charityNames objectAtIndex:indexPath.row]];
    
}

- (void)onBuyNowButtonTapped
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_productProductURL]];
    NSLog(@"sending user to purchase product at %@", _productProductURL);
    
    [self didUpdateKarmaPoints:YES charity:@"made a purchase"];
    
}

-(void)didUpdateKarmaPoints: (BOOL)flag charity:(NSString*)recipientCharity
{
    
    PFObject *donation = [PFObject objectWithClassName:@"Donation"];
    donation[@"donor"] = [PFUser currentUser];
    donation[@"recipientCharity"] = recipientCharity;
    
    donation[@"donationAmount"]= _productPrice;
    
    [donation saveInBackground]; //save the donation to Parse
    
    
    PFUser *user = [PFUser currentUser];
    
    currPoints = user[@"points"];
    
    if (!currPoints){
        
        currPoints=0;
    }
    if( flag ==YES ) {
        
        NSLog(@"Flag == YES");
        int tempPoints =  (10 + [currPoints integerValue]);
        
        user[@"points"] = [NSNumber numberWithInt:tempPoints];
        
        [user saveInBackground];
        
    }else if(flag==NO)
    {
        NSLog(@"Flag == no");
        int tempPoints =  (-10 + [currPoints integerValue]);
        
        user[@"points"] = [NSNumber numberWithInt:tempPoints];
        
    }
    
    [user saveInBackground]; //save user points to Parse

    
}

- (IBAction)userProfileButton:(id)sender {
}


@end
