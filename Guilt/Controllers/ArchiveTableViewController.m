//
//  ArchiveTableViewController.m
//  Guilt
//
//  Created by John Andrews on 6/12/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ArchiveTableViewController.h"
#import <Parse/Parse.h>
#import "ArchiveTableViewCell.h"
#import "ModalArchiveViewController.h"
#import "GAIDictionaryBuilder.h"
#import <AFNetworking/AFNetworking.h>
#import "ImageSaver.h"
#import "UIImageView+WebCache.h"


@interface ArchiveTableViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *archiveMemesArray;
@property (nonatomic, strong) NSMutableArray *archiveDatesArray;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *dates;
@property (assign, nonatomic) CATransform3D makeImagesLean;
@property (nonatomic) int totalNumberArchiveMemes;
@end

@implementation ArchiveTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self cellVisualEffect];
    NSArray *loginsArray = [[NSArray alloc] initWithArray:[UsersLoginInfo getUsersObjectID]];
    self.archiveMemesArray = [NSMutableArray array];
    self.archiveDatesArray = [NSMutableArray array];
    
    for (NSString *loginMethod in loginsArray) {
        self.archiveMemesArray = [ImageSaver getAllArchiveImagesForUser:loginMethod];
        self.archiveDatesArray = [ImageSaver calculateAndGetFileCreationDate:self.archiveMemesArray];
    }
    
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        [self findOutHowManyMemesUserHasinDatabase];
    }
    if (!self.archiveMemesArray.count) {
        [self showEncourageToShareAndArchiveMessage];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Google Analytics
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"ArchiveTableViewController"];
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
}

#pragma mark - Table View Visual Effects

- (void)cellVisualEffect
{
    //Part of code to get images to animate when appear
    CGFloat rotationAngleDegrees = -15;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    
    self.makeImagesLean = transform;
}

#pragma mark - Parse Methods

- (void)getArhiveMemesFromParse:(NSInteger)pullNumber
{
    [self.refreshControl beginRefreshing];
    //Prepare the query to get all the images in descending order
    //1
    PFQuery *query = [PFQuery queryWithClassName:@"CharityMemes"];
    [query whereKey:@"User" equalTo:[PFUser currentUser]];
    
    //2
    [query orderByDescending:@"createdAt"];
    if (pullNumber > 1) {
        [query addDescendingOrder:@"User"];
        query.skip = pullNumber;
    }
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *PFobjects, NSError *error) {
        //3
        if (!error) {
            //Everything was correct, put the new objects and load the wall
            [self.archiveMemesArray addObjectsFromArray:PFobjects];
            [self parseThroughBackEndData];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            
            //4
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

- (void)findOutHowManyMemesUserHasinDatabase
{
    //Cloud Code needed here
    PFQuery *query = [PFQuery queryWithClassName:@"CharityMemes"];
    [query whereKey:@"User" equalTo:[PFUser currentUser]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            self.totalNumberArchiveMemes = number;
            NSLog(@"self.totalNumberArchiveMemes =%d", self.totalNumberArchiveMemes);
        }
    }];
}

- (void)showEncourageToShareAndArchiveMessage
{
    UILabel *shareEncouragementMessage = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, self.navigationController.navigationBar.frame.size.height + 10.0f, self.view.frame.size.width - 40.0f, (44.0f * 3))];
    shareEncouragementMessage.font = [UIFont fontWithName:@"Quicksand-Regular" size:22];
    shareEncouragementMessage.backgroundColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    shareEncouragementMessage.numberOfLines = 0;
    shareEncouragementMessage.textAlignment = NSTextAlignmentCenter;
    shareEncouragementMessage.textColor = [UIColor whiteColor];
    shareEncouragementMessage.text = @"Whenever you share a #KarmaScanFact meme, it is saved to your personal archive";
    [self.view addSubview:shareEncouragementMessage];
}

- (void)parseThroughBackEndData
{
    self.dates = [NSMutableArray array];
    self.images = [NSMutableArray array];
    
    for (PFObject *dateAndImageObject in self.archiveMemesArray){
        
        PFFile *meme = (PFFile *)[dateAndImageObject objectForKey:@"image"];
        [self.images addObject:[UIImage imageWithData:meme.getData]];
        [self.dates addObject:[self formateDates:dateAndImageObject.createdAt]];
    }
}

- (NSString *)formateDates:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee, MMMM dd, yyyy"];
    
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.archiveMemesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dateAndImage" forIndexPath:indexPath];
//    if (self.imageTransformEnabled) {
//        cell.layer.transform = self.makeImagesLean;
//        cell.layer.opacity = 0.2;
//        [UIView animateWithDuration:0.4 animations:^{
//            cell.layer.transform = CATransform3DIdentity;
//            cell.layer.opacity = 1;
//        }]; 
//        self.imageTransformEnabled = NO;
//    }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    UIImageView *archiveImageView = [[UIImageView alloc] init];
    [archiveImageView sd_setImageWithPreviousCachedImageWithURL:self.archiveMemesArray[indexPath.row]
                                            andPlaceholderImage:nil
                                                        options:SDWebImageHighPriority
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [indicator startAnimating];
    }
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [indicator stopAnimating];
        cell.archiveImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.archiveImage.image = image;
    }];
    
    cell.archiveDateLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:18];
    cell.archiveDateLabel.textColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    cell.archiveDateLabel.text = [self formateDates:self.archiveDatesArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"ArchiveTableViewController"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:@"share archive meme"
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
    
    [self performSegueWithIdentifier:@"ArchiveToModalShareSegue" sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ArchiveToModalShareSegue"]) {
        ModalArchiveViewController* modalArchiveVC = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        modalArchiveVC.sharingArchiveMeme = [self.images objectAtIndex:selectedIndexPath.row];
        modalArchiveVC.activitySheetEnabled = YES;
    } 
}


- (IBAction)imageLoader:(id)sender 
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 
                                             (unsigned long)NULL), ^(void) {
        [self getArhiveMemesFromParse:2];
    });
}
@end
