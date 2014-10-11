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
#import "ShareImageViewController.h"
#import "FlickrNetworkManager.h"
#import "UIImageView+WebCache.h"
#import "CharityImage.h"

@interface ImagesViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSNumber* currPoints;
}
@property (strong, nonatomic) FlickrNetworkManager *selectedImage;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@property (strong, nonatomic) NSMutableDictionary *flickrImageUrlDictionary;
@property (strong, nonatomic) NSDictionary *specificTypeOfFlickrImageUrlDictionary;

@property (nonatomic) int charityCellUpdateUICalled;

@property (strong, nonatomic) NSMutableDictionary *alreadyUsedFlikrURLDictionary;

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

    self.alreadyUsedFlikrURLDictionary = [NSMutableDictionary dictionary];
    
    //Part of code to get images to animate when appear
    CGFloat rotationAngleDegrees = -15;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    makeImagesLean = transform;
    
    [self.navigationItem setTitle:@"Impact"];
    
    self.flickrImageUrlDictionary = [[NSMutableDictionary alloc] initWithDictionary:[FlickrNetworkManager sharedManager].flickrCharityUrlDictionary];

    if (self.flickrImageUrlDictionary.count) {
        [self getFlickrImageUrl];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (int i = 0; i < self.alreadyUsedFlikrURLDictionary.count; i++) {
        NSString *searchTerm = [self.alreadyUsedFlikrURLDictionary allKeys][i];
        NSURL *alreadyUsedURL = [self.alreadyUsedFlikrURLDictionary allValues][i];

        [self removeAlreadyUsedImage:alreadyUsedURL fromInitialFlickrAPICall:searchTerm];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ImageSelectionSegue"]) {
        ShareImageViewController *shareImageVC = [segue destinationViewController];
        shareImageVC.unfinishedMeme = [self imageFromCellAtIndex:((UIView *)sender).tag];
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

#pragma mark - Image Methods
- (void)getFlickrImageUrl
{
    NSMutableDictionary *dictOfManyImageUrls = [NSMutableDictionary dictionary];
    

    for (int i = 0; i < self.flickrImageUrlDictionary.count; i++) {

        NSURL *flickrImageUrl = [[self.flickrImageUrlDictionary objectForKey:[self.flickrImageUrlDictionary allKeys][i]] firstObject];

        [dictOfManyImageUrls setObject:flickrImageUrl forKey: [self.flickrImageUrlDictionary allKeys][i]];
    }
    
    self.specificTypeOfFlickrImageUrlDictionary = [[NSDictionary alloc] initWithDictionary:dictOfManyImageUrls];
}

- (void)removeAlreadyUsedImage:(NSURL *)flickrURL fromInitialFlickrAPICall:(NSString *)searchTerm
{
    int indexOfUsedURL;
    BOOL removeFromFlickrSingleton = NO;
    
    NSMutableArray *flickrImagesInCharityVerticalArray = [[FlickrNetworkManager sharedManager].flickrCharityUrlDictionary objectForKey:searchTerm];
    for (NSURL *originalURL in flickrImagesInCharityVerticalArray) {
        if ([[originalURL absoluteString] isEqualToString:[flickrURL absoluteString]] ) {
            indexOfUsedURL = [flickrImagesInCharityVerticalArray indexOfObject:flickrURL];
            removeFromFlickrSingleton = YES;
        }
    }
    if (removeFromFlickrSingleton) {
        [[[FlickrNetworkManager sharedManager].flickrCharityUrlDictionary objectForKey:searchTerm] removeObjectAtIndex:indexOfUsedURL];
    }
}

- (int)getRandomNumber:(int)numberOfFlickrImagesInCharityVerticalArray
{
    int top7thFlickrResults;
    
    if (numberOfFlickrImagesInCharityVerticalArray > 7) {
        top7thFlickrResults =  roundf(numberOfFlickrImagesInCharityVerticalArray / 7);
    } else {
        top7thFlickrResults =  roundf(numberOfFlickrImagesInCharityVerticalArray / 2);
    }
    
    int randomNumber = arc4random() % top7thFlickrResults;
    
    return randomNumber;
}

- (UIImage *)imageFromCellAtIndex:(NSInteger)index
{
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell  = [self.imagesTableView cellForRowAtIndexPath:selectedIndexPath];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 240), NO, 0.0);
    
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
    CGFloat tableHeight = [self tableView:tableView heightForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,tableHeight)];
        
    UITextView *productNameTextView = [[UITextView alloc] initWithFrame:headerView.frame];
    productNameTextView.font = [UIFont fontWithName:@"Quicksand-Regular" size:17];
    productNameTextView.text = [NSString stringWithFormat:@"%@\n $%@\n", _productName, _productPrice];
    productNameTextView.backgroundColor = [UIColor colorWithRed:247.0/255 green:150.0/255 blue:0.0/255 alpha:1];
    [headerView addSubview:productNameTextView];
    
    if (self.productProductURL.length) {
        UIButton* urlLinkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        urlLinkButton.backgroundColor = [UIColor blackColor];
        urlLinkButton.frame = CGRectMake(tableView.frame.size.width - 110.0f, tableHeight - 60.0f, 100, 50);
        [urlLinkButton setTitle:@"Buy Now" forState:UIControlStateNormal];
        urlLinkButton.layer.cornerRadius = 8;
        urlLinkButton.layer.borderWidth = 1;
        urlLinkButton.layer.borderColor = [UIColor whiteColor].CGColor;
        urlLinkButton.clipsToBounds = YES;
        urlLinkButton.titleLabel.textColor = [UIColor whiteColor];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"ImagesViewController"];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                              action:@"touch"
                                                               label:urlLinkButton.titleLabel.text
                                                               value:nil] build]];
        [tracker set:kGAIScreenName value:nil];
        
        [headerView addSubview:urlLinkButton];
        [headerView bringSubviewToFront:urlLinkButton];
        
        [urlLinkButton setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBuyNowButtonTapped)];
        [urlLinkButton addGestureRecognizer:recognizer];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
    if (!self.productName.length) {
        return 0;
    } else {
        if (self.productName.length > 120) {
            return 185;
        } else if (self.productName.length > 90){
        return 160;
        } else if (self.productName.length > 60){
            return 135;
        }
        return 110;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CharityImage *individualCharity = [self.resultOfCharitableConversionsDict objectForKey:[self.resultOfCharitableConversionsDict allKeys][indexPath.row]];
    
    CharityAndProductDisplayCell *charityCell = [tableView dequeueReusableCellWithIdentifier:@"CharityDisplay"];
    charityCell.displayImageView.image = individualCharity.charityLogo;
    charityCell.shareButtonOutlet.tag = indexPath.row;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.color = [UIColor orangeColor];
    indicator.center = charityCell.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    
    self.charityCellUpdateUICalled ++;
    
    NSURL *flikrImageURL = [self.specificTypeOfFlickrImageUrlDictionary objectForKey:individualCharity.flickrSearchTerm];
    UIImageView *flickrImage = [[UIImageView alloc] init];
    [flickrImage sd_setImageWithURL:flikrImageURL
                   placeholderImage:nil
                            options:SDWebImageLowPriority
                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                               [indicator startAnimating];
//                               NSLog(@"percentage until complete =%f", (float)receivedSize/(float)expectedSize);
                               
                           } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               [indicator stopAnimating];
                               if (!error) {
                                   [self.alreadyUsedFlikrURLDictionary setObject:flikrImageURL forKey:individualCharity.flickrSearchTerm];
                                   if (self.flickrImageUrlDictionary.count) {
                                       charityCell.layer.transform = self.makeImagesLean;
                                       charityCell.layer.opacity = 0.2;
                                       [UIView animateWithDuration:0.4 animations:^{
                                           charityCell.layer.transform = CATransform3DIdentity;
                                           charityCell.layer.opacity = 1;
                                       }];
                                       
                                       CGSize shrinkLogoSize = CGSizeMake(60.0f, 40.0f);
                                       UIGraphicsBeginImageContext(shrinkLogoSize);
                                       [individualCharity.charityLogo drawInRect:CGRectMake(0,0,shrinkLogoSize.width,shrinkLogoSize.height)];
                                       UIImage* shrunkLogoImage = UIGraphicsGetImageFromCurrentImageContext();
                                       UIGraphicsEndImageContext();
                                       charityCell.logoImageView.image = shrunkLogoImage;
                                       
                                       CGSize shrinkflickrImage = CGSizeMake(320.0f, 240.0f);
                                       UIGraphicsBeginImageContext(shrinkflickrImage);
                                       [flickrImage.image drawInRect:CGRectMake(0,0,shrinkflickrImage.width,shrinkflickrImage.height)];
                                       UIImage* shrunkflickrImage = UIGraphicsGetImageFromCurrentImageContext();
                                       UIGraphicsEndImageContext();
                                       
                                       //need a method to clear displayImageView.image? Currently, I think I'm showing an image on top of an image
                                       charityCell.displayImageView.image = shrunkflickrImage;
                                       charityCell.displayImageView.contentMode = UIViewContentModeScaleAspectFit;
                                       if (self.charityCellUpdateUICalled < self.flickrImageUrlDictionary.count) {
                                           [charityCell updateUI];
                                       }
                                   } else {
                   
                                       [charityCell updateUI];
                                   }
                                   
                                   NSString *charityDescription = [[NSString alloc] init];
                                   if ([[self.resultOfCharitableConversionsDict objectForKey:individualCharity.charityName] integerValue] == 1) {
                                       charityDescription = individualCharity.singularDescription;
                                   } else {
                                       charityDescription = individualCharity.pluralDescription;
                                   }
                                   NSAttributedString *charityDescriptionText = [[NSAttributedString alloc] initWithString:[[NSString stringWithFormat:@"%@ %@",[self.resultOfCharitableConversionsDict allKeys][indexPath.row], charityDescription] uppercaseString] attributes:@{NSStrokeWidthAttributeName: @-2, NSStrokeColorAttributeName: [UIColor blackColor]}];
                                   charityCell.charityConversionDetailsLabel.attributedText = charityDescriptionText;
                                   charityCell.charityConversionDetailsLabel.tag = 4;
                                   
                                   NSAttributedString *dollarConversionDescriptionText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@ IS EQUIVALENT TO", self.productPrice] attributes:@{NSStrokeWidthAttributeName: @-2, NSStrokeColorAttributeName: [UIColor blackColor]}];
                                   charityCell.dollarAmountConvertedLabel.attributedText = dollarConversionDescriptionText;
                                   
                                   charityCell.donateButtonOutlet.tag = indexPath.row;
                                   [charityCell.donateButtonOutlet addTarget:self action:@selector(onDonationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                                   
                                   [charityCell.shareButtonOutlet addTarget:self action:@selector(onShareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

                               } else {
                                   NSLog(@"error =%@", [error localizedDescription]);
                                   [charityCell updateUI];
                               }
                           }];

    return charityCell;
}


- (void)onShareButtonTapped:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"ImageSelectionSegue" sender:sender];
}

- (void)onDonationButtonTapped:(UIButton *)sender
{
    CharityImage *selectedCharity = [CharityImage allCharityDetails:YES][sender.tag];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedCharity.donationURL]];
    
    [self didUpdateKarmaPoints:YES charity:selectedCharity.donationURL];
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
