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
#import "ShareImageViewController.h"
#import "FlickrNetworkManager.h"
#import "CharityImage.h"


@interface ImagesViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSNumber* currPoints;
}
@property (strong, nonatomic) Charity *charityData;
@property (strong, nonatomic) FlickrNetworkManager *selectedImage;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@property (strong, nonatomic) NSDictionary *flickrCharitySearchTerms;
@property (strong, nonatomic) NSMutableDictionary *flickrImageUrlDictionary;
@property (strong, nonatomic) NSArray *specificTypeOfFlickrImageUrlArray;

@end

@implementation ImagesViewController
@synthesize makeImagesLean, userProfileButtonOutlet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"ImagesViewController";
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
    
//    [self setFontFamily:@"Quicksand-Bold" forView:self.view andSubViews:YES];
    [self.navigationItem setTitle:@"Impact"];
    self.charityData = [[Charity alloc] init];
    
    self.flickrImageUrlDictionary = [NSMutableDictionary dictionary];
    self.flickrCharitySearchTerms = [[NSDictionary alloc] initWithDictionary:[FlickrNetworkManager sharedManager].charitySearchTerms];
    self.flickrImageUrlDictionary = [FlickrNetworkManager sharedManager].flickrCharityUrlDictionary;

    if (self.flickrImageUrlDictionary.count) {
        [self getFlickrImageUrl];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ImageSelectionSegue"]) {
        ShareImageViewController *shareImageVC = [segue destinationViewController];
        shareImageVC.unfinishedMeme = [self convertCellIntoImage];
        if (self.productPrice) {
            shareImageVC.productPrice = [self.productPrice stringValue];
        } else {
            shareImageVC.productPrice = self.userImputPrice;
        }
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"ImagesViewController"];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                              action:@"touch"
                                                               label:@"share specific meme"
                                                               value:nil] build]];
        [tracker set:kGAIScreenName value:nil];
    }
}


- (void)getFlickrImageUrl
{
    NSMutableArray *arrayOfManyImageUrls = [NSMutableArray array];
    int top6thFlickrResults;
    for (int i = 0; i < self.flickrImageUrlDictionary.count; i++) {
        
        int numberOfFlickrImagesInCharityVerticalArray = [[self.flickrImageUrlDictionary objectForKey:[self.flickrCharitySearchTerms objectForKey:[NSNumber numberWithInt:i]]] count];
        
        if (numberOfFlickrImagesInCharityVerticalArray > 5) {
            top6thFlickrResults =  roundf(numberOfFlickrImagesInCharityVerticalArray / 6);
        } else {
            top6thFlickrResults =  roundf(numberOfFlickrImagesInCharityVerticalArray / 2);
        }
        
        int randomNumber = arc4random() % top6thFlickrResults;

        [arrayOfManyImageUrls addObject:[[self.flickrImageUrlDictionary objectForKey:[self.flickrCharitySearchTerms objectForKey:[NSNumber numberWithInt:i]]] objectAtIndex:randomNumber]];
    }
    self.specificTypeOfFlickrImageUrlArray = [[NSArray alloc] initWithArray:arrayOfManyImageUrls];
}

/*Original
- (UIImage *)convertCellIntoImage
{
    NSIndexPath *selectedIndexPath = [self.imagesTableView indexPathForSelectedRow];
    UITableViewCell *cell  = [self.imagesTableView cellForRowAtIndexPath:selectedIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    //take snapshot of the cell
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.opaque, 0.0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGContextRestoreGState(context);
    
    return cellImage;
}
/* Logan
- (UIImage *)convertCellIntoImage
{    
    NSIndexPath *selectedIndexPath = [self.imagesTableView indexPathForSelectedRow];
    UITableViewCell *cell  = [self.imagesTableView cellForRowAtIndexPath:selectedIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;

    UIGraphicsBeginImageContextWithOptions(cell.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-cell.frame.origin.x, -cell.frame.origin.y - self.navigationController.navigationBar.frame.size.height));
    [[[[UIApplication sharedApplication] keyWindow] layer] renderInContext:context];
        
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}
*/
#pragma mark - Image Manipulation
- (UIImage *)convertCellIntoImage
{
    NSIndexPath *selectedIndexPath = [self.imagesTableView indexPathForSelectedRow];
    UITableViewCell *cell  = [self.imagesTableView cellForRowAtIndexPath:selectedIndexPath];
    
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0.0);
    
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return cellImage;
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
    

    if (self.flickrImageUrlDictionary.count) {
        UIImage *logoImage = [[UIImage alloc] init];
        logoImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.charityData charityLogos:charityName]]];
        
        CGSize shrinkLogoSize = CGSizeMake(60.0f, 40.0f);
        UIGraphicsBeginImageContext(shrinkLogoSize);
        [logoImage drawInRect:CGRectMake(0,0,shrinkLogoSize.width,shrinkLogoSize.height)];
        UIImage* shrunkLogoImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        charityCell.logoImageView.image = shrunkLogoImage;
        
        
        UIImage *flickrImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[self.specificTypeOfFlickrImageUrlArray objectAtIndex:indexPath.row]]];
        
        CGSize shrinkflickrImage = CGSizeMake(320.0f, 211.0f);
        UIGraphicsBeginImageContext(shrinkflickrImage);
        [flickrImage drawInRect:CGRectMake(0,0,shrinkflickrImage.width,shrinkflickrImage.height)];
        UIImage* shrunkflickrImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        charityCell.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        charityCell.displayImageView.image = shrunkflickrImage;
        [self.view bringSubviewToFront:charityCell.displayImageView];
    } else {
        charityCell.displayImageView.image = [UIImage imageNamed:
                                           [NSString stringWithFormat:@"%@",
                                            [self.charityData charityLogos:charityName]]];
    }
    
    charityCell.donationButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donate.png"]];
    charityCell.donationButton.frame = CGRectMake(charityCell.bounds.size.width - 44, charityCell.bounds.size.height - 46, 44, 44);
    [charityCell.donationButton setUserInteractionEnabled:YES];
    charityCell.donationButton.tag = 2;
    
    NSString *charityDescription = [[NSString alloc] init];
    if ([[self.resultOfCharitableConversionsDict objectForKey:charityName] integerValue] == 1) {
        charityDescription = [self.charityData charityDescriptionSingular:indexPath.row];
    } else {
        charityDescription = [self.charityData charityDescriptionPlural:indexPath.row];
    }
    NSAttributedString *charityDescriptionText = [[NSAttributedString alloc] initWithString:[[NSString stringWithFormat:@"%@ %@",[self.resultOfCharitableConversionsDict objectForKey:charityName], charityDescription] uppercaseString] attributes:@{NSStrokeWidthAttributeName: @-2, NSStrokeColorAttributeName: [UIColor blackColor]}];
    charityCell.charityConversionDetailsLabel.attributedText = charityDescriptionText;
    
    NSAttributedString *dollarConversionDescriptionText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@ IS EQUIVALENT TO", self.productPrice] attributes:@{NSStrokeWidthAttributeName: @-2, NSStrokeColorAttributeName: [UIColor blackColor]}];
    charityCell.dollarAmountConvertedLabel.attributedText = dollarConversionDescriptionText;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDonationButtonTapped:)];
    [charityCell.donationButton addGestureRecognizer:recognizer];
    [charityCell addSubview:charityCell.donationButton];
            
    return charityCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    uita *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"number of cell subviews BEFORE %d", selectedCell.subviews.count);
    for (id subview in selectedCell.subviews) {
        if (subview.tag == 2){
            [subview removeFromSuperview];
        }
    }

    selectedCell.charityConversionDetailsLabel.frame = CGRectMake(2,162,316,50);
    NSLog(@"number of cell subviews After %d", selectedCell.subviews.count); 
    [self performSegueWithIdentifier:@"ImageSelectionSegue" sender:self];
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
    
    donation[@"donationAmount"]= self.productPrice;
    
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
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"ImagesViewController"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:userProfileButtonOutlet.title
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
}


@end
