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
#import <AFNetworking/AFNetworking.h>
#import "ImageSaver.h"

@interface ArchiveTableViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *archiveMemesArray;
@property (nonatomic, strong) NSMutableArray *archiveDatesArray;
@property (nonatomic, strong) ImageSaver *imageSaver;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, strong) NSMutableArray *objectIDs;
@property (assign, nonatomic) CATransform3D makeImagesLean;
@property (nonatomic) int totalNumberArchiveMemes;
@property BOOL hadToGetImagesFromParse;
@end

@implementation ArchiveTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.hadToGetImagesFromParse = NO;
    [self cellVisualEffect];
    self.objectIDs = [NSMutableArray array];
    self.archiveMemesArray = [NSMutableArray array];
    self.archiveDatesArray = [NSMutableArray array];
    self.images = [NSMutableArray array];
    NSArray *loginsArray = [[NSArray alloc] initWithArray:[UsersLoginInfo getUsersObjectID]];
    self.imageSaver = [[ImageSaver alloc] init];
    
    for (NSString *loginMethod in loginsArray) {
        //need to check if imageSaver method is nil -->cannot add nil to array
        if ([[self.imageSaver getAllArchiveImagesForUser:loginMethod] count] > 0) {
            self.archiveMemesArray = (NSMutableArray *)[self.imageSaver getAllArchiveImagesForUser:loginMethod];
        }
        if ([[self.imageSaver calculateAndGetFileCreationDate:self.archiveMemesArray] count]) {
            self.archiveDatesArray = (NSMutableArray *)[self.imageSaver calculateAndGetFileCreationDate:self.archiveMemesArray];
        }
    }
    
    if (!self.archiveMemesArray.count && [AFNetworkReachabilityManager sharedManager].reachable) {
        [self getArhiveMemesFromParse:1];
    } else {
        [self findOutHowManyMemesUserHasinDatabase];
    }
    
    if (![AFNetworkReachabilityManager sharedManager].reachable && !self.archiveMemesArray.count) {
        [self showEncourageToShareAndArchiveMessage];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [GoogleAnalytics trackAnalyticsForScreen:@"ArchiveTableViewController"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.hadToGetImagesFromParse) {
        [self.imageSaver saveMemeToArchiveDisk:self.images forUser:[[PFUser currentUser] objectId] withIdentifier:self.objectIDs];
    }
    [super viewDidDisappear:animated];
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
    self.refreshControl.tintColor = [UIColor orangeColor];
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
    query.cachePolicy = kPFCachePolicyIgnoreCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *PFobjects, NSError *error) {
        //3
        if (!error) {
            [self addToArrayImageURLsFromParseObjects:PFobjects];
            [self.refreshControl endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            self.hadToGetImagesFromParse = YES;
        } else {
            
            //4
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

- (void)addToArrayImageURLsFromParseObjects:(NSArray *)parseObjects
{
    NSMutableArray *cachedURLsArray = [NSMutableArray array];
    for (PFObject *object in parseObjects) {
        [self.archiveDatesArray addObject:object.createdAt];
        [self.archiveMemesArray addObject:[object objectForKey:@"image"]];
        [self.objectIDs addObject:object.objectId];
        
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingFormat:@"/Caches/Parse/PFFileCache/%@", [[object objectForKey:@"image"] name]];
//        [cachedURLsArray addObject:path];
    }
}

- (void)findOutHowManyMemesUserHasinDatabase
{
    //Cloud Code needed here
    PFQuery *query = [PFQuery queryWithClassName:@"CharityMemes"];
    [query whereKey:@"User" equalTo:[PFUser currentUser]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if (self.totalNumberArchiveMemes == number) {
                NSLog(@"local archive memes(%d) = remote memes(%d)", self.totalNumberArchiveMemes, number);
            } else if (self.totalNumberArchiveMemes > number) {
                NSLog(@"theres more local archive memes(%d) and need to push to remote(%d)", self.totalNumberArchiveMemes, number);
            } else {
                NSLog(@"less local archive memes(%d) and need to get from remote memes(%d)", self.totalNumberArchiveMemes, number);
            }
        }
    }];
}

- (void)uploadMemeToParse:(UIImage *)charityMeme
{
    NSData *imageData = UIImagePNGRepresentation(charityMeme);
    
    //Upload a new picture
    //1
    PFFile *file = [PFFile fileWithName:@"img" data:imageData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            //2
            
            PFObject *imageObject = [PFObject objectWithClassName:@"CharityMemes"];
            [imageObject setObject:[PFUser currentUser] forKey:@"User"];
            [imageObject setObject:file forKey:@"image"];
            
            //3
            [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //4
                if (succeeded){
                    NSLog(@"successful image upload to Parse");
                }
                else{
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
            }];
        }
        else{
            //5
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    } progressBlock:^(int percentDone) {
        NSLog(@"Uploaded: %d %%", percentDone);
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
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.tintColor = [UIColor orangeColor];
    [indicator startAnimating];
    
    if (self.hadToGetImagesFromParse) {
        PFFile *image = (PFFile *)self.archiveMemesArray[indexPath.row];
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            [indicator stopAnimating];
            cell.archiveImage.image =  [UIImage imageWithData:data];
            [self.images addObject:cell.archiveImage.image];
        } progressBlock:^(int percentDone) {
            
        }];
    } else {
        NSURL *localImageStorage = self.archiveMemesArray[indexPath.row];
        cell.archiveImage.image = [UIImage imageWithContentsOfFile:localImageStorage.path];
    }
    cell.archiveDateLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:18];
    cell.archiveDateLabel.textColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    cell.archiveDateLabel.text = [self formateDates:self.archiveDatesArray[indexPath.row]];
    
    cell.layer.transform = self.makeImagesLean;
    cell.layer.opacity = 0.2;
    [UIView animateWithDuration:0.4 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [GoogleAnalytics trackAnalyticsForAction:@"touch" withLabel:@"share archive meme" onScreen:@"ArchiveTableViewController"];
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
