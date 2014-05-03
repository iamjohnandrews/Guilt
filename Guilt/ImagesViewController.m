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
#import "Charity.h"

@interface ImagesViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSNumber* currPoints;
}
@property (strong, nonatomic) Charity *charityData;

@end

@implementation ImagesViewController
@synthesize makeImagesLean;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([PFUser currentUser]) {
        self.userProfileButtonOutlet.enabled = YES;
    } else {
        self.userProfileButtonOutlet.enabled = NO;
    }
    self.imagesTableView.dataSource = self;
    self.imagesTableView.delegate = self;
    
    //Part of code to get images to animate when appear
    CGFloat rotationAngleDegrees = -15;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    makeImagesLean = transform;
    
    [self setFontFamily:@"Quicksand-Regular" forView:self.view andSubViews:YES];
    [self.navigationItem setTitle:@"Impact"];
    self.charityData = [[Charity alloc] init];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ImageSelectionSegue"]) {
        ImagesViewController* imagesVC = [segue destinationViewController];
        
    }
    
}

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultOfCharitableConversionsDict.count;
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
    NSString *charityName = [self.charityData charityNames:indexPath.row]; 
    CharityAndProductDisplayCell *charityCell = [tableView dequeueReusableCellWithIdentifier:@"CharityDisplay"];

    charityCell.layer.transform = self.makeImagesLean;
    charityCell.layer.opacity = 0.2;
    [UIView animateWithDuration:0.4 animations:^{
        charityCell.layer.transform = CATransform3DIdentity;
        charityCell.layer.opacity = 1;
    }];   
    charityCell.logoImageView.image = [UIImage imageNamed:
                                       [NSString stringWithFormat:@"%@",
                                        [self.charityData charityLogos:charityName]]];
    
    charityCell.displayImageView.image = [self.oneCharityURLforOneCharityNameDict objectForKey:charityName];
    
    charityCell.donationButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donate.png"]];
    charityCell.donationButton.frame = CGRectMake(charityCell.bounds.size.width - 44, charityCell.bounds.size.height - 46, 44, 44);
    [charityCell.donationButton setUserInteractionEnabled:YES];
//    [charityCell.donationButton bringSubviewToFront:self.imagesTableView];
    
    NSString *charityDescription = [[NSString alloc] init];
    if ([[self.resultOfCharitableConversionsDict objectForKey:charityName] integerValue] == 1) {
        charityDescription = [self.charityData charityDescriptionSingular:indexPath.row];
    } else {
        charityDescription = [self.charityData charityDescriptionPlural:indexPath.row];
    }
    charityCell.charityConversionDetailsLabel.text = [NSString stringWithFormat:@"%@ %@",[self.resultOfCharitableConversionsDict objectForKey:charityName], charityDescription];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDonationButtonTapped:)];
    [charityCell.donationButton addGestureRecognizer:recognizer];
    [charityCell addSubview:charityCell.donationButton];
            
    return charityCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor greenColor];
}

- (void)onDonationButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    NSIndexPath *indexPath = [self.imagesTableView indexPathForCell:(UITableViewCell *)gestureRecognizer.view.superview.superview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.charityData charityDonationPage:indexPath.row]]];
//    NSLog(@"the Second index.row = %li", (long)indexPath.row);
    
    [self didUpdateKarmaPoints:YES charity:[self.charityData charityNames:indexPath.row]];
    
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
        
        int tempPoints =  (10 + [currPoints integerValue]);
        
        user[@"points"] = [NSNumber numberWithInt:tempPoints];
        
        [user saveInBackground];
        
    }else if(flag==NO)
    {
        int tempPoints =  (-10 + [currPoints integerValue]);
        
        user[@"points"] = [NSNumber numberWithInt:tempPoints];
    }
    [user saveInBackground]; //save user points to Parse
}

- (IBAction)userProfileButton:(id)sender 
{
    
}


@end
