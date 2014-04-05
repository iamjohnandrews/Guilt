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
    NSArray* charityDonationPage;
    NSArray* charityNames;
    NSNumber* currPoints;
}

@end

@implementation ImagesViewController
@synthesize resultOfCharitableConversionsArray, makeImagesLean;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.userIsLoggedIn == NO) {
        self.userProfileButtonOutlet.enabled = NO;
    } else {
        self.userProfileButtonOutlet.enabled = YES;
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
    
    charityDonationPage = @[@"https://theanimalrescuesite.greatergood.com/store/ars/item/32249/contribute-to-animal-rescue?source=12-32132-3#productInfo",
                            @"http://www.supportunicef.org/site/c.dvKUI9OWInJ6H/b.7677883/k.2C8F/Donate_now.htm", 
                            @"https://secure2.convio.net/ftc/site/SPageServer?pagename=donate",
                            @"http://www.heifer.org/gift-catalog/animals-nutrition/flock-of-ducks-donation.html",
                            @"http://www.heifer.org/gift-catalog/animals-nutrition/honeybees-donation.html",
                            @"http://soldiersangels.org/donate.html", 
                            @"http://www.africanwellfund.org/donate.html"];
     charityNames = @[@"The Animal Rescue Site", @"Unicef", @"Feed The Children", @"Heifer Internaitonal", @"Heifer Internaitonal", @"Soilder's Angels", @"African Well Fund"];
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

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    Charity *charityData = [[Charity alloc] init];
    CharityAndProductDisplayCell *charityCell = [tableView dequeueReusableCellWithIdentifier:@"CharityDisplay"];
    charityCell.charity = [self.parseNonprofitInfoArray objectAtIndex:indexPath.row];

    charityCell.layer.transform = self.makeImagesLean;
    charityCell.layer.opacity = 0.2;
    [UIView animateWithDuration:0.4 animations:^{
        charityCell.layer.transform = CATransform3DIdentity;
        charityCell.layer.opacity = 1;
    }];   
    
    if (!charityCell.displayImageView.image) {
        charityCell.displayImageView.image = [charityData charityImageURLSForSpecifcCharity:indexPath.row];
    }
    
    NSString *charityDescription = [[NSString alloc] init];
    if ([[resultOfCharitableConversionsArray objectAtIndex:indexPath.row] integerValue] == 1) {
        charityDescription = [charityData charityDescriptionSingular:indexPath.row];
    } else {
        charityDescription = [charityData charityDescriptionPlural:indexPath.row];
    }
    charityCell.charityConversionDetailsLabel.text = [NSString stringWithFormat:@"%@ %@",[resultOfCharitableConversionsArray objectAtIndex:indexPath.row], charityDescription];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDonationButtonTapped:)];
    [charityCell.donationButton addGestureRecognizer:recognizer];
    [charityCell addSubview:charityCell.donationButton];
        
    return charityCell;
}

- (void)onDonationButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    NSIndexPath *indexPath = [self.imagesTableView indexPathForCell:(UITableViewCell *)gestureRecognizer.view.superview.superview];
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

- (IBAction)userProfileButton:(id)sender {
}


@end
