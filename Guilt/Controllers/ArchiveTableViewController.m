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

@interface ArchiveTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *archiveMemesArray;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *dates;
@end

@implementation ArchiveTableViewController

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self imageLoader:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)getArhiveMemesFromParse
{
    [self.refreshControl beginRefreshing];
    //Prepare the query to get all the images in descending order
    //1
    PFQuery *query = [PFQuery queryWithClassName:@"charityMemeObject"];
    [query whereKey:@"User" equalTo:[PFUser currentUser]];
    //2
    [query orderByDescending:@"createdAt"];
    query.limit = 6;
    [query findObjectsInBackgroundWithBlock:^(NSArray *PFobjects, NSError *error) {
        //3 
        if (!error) {
            //Everything was correct, put the new objects and load the wall
            self.archiveMemesArray = nil;
            self.archiveMemesArray = [[NSArray alloc] initWithArray:PFobjects];
            [self parseThroughBackEndData];
            NSLog(@"successfully retrieved %d images from Parse createdAt=%@", self.archiveMemesArray.count, self.dates[0]);
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

- (void)parseThroughBackEndData
{
    self.dates = [NSMutableArray array];
    self.images = [NSMutableArray array];
    
    for (PFObject *dateAndImageObject in self.archiveMemesArray){
        
        PFFile *meme = (PFFile *)[dateAndImageObject objectForKey:@"image"];
        [self.images addObject:[UIImage imageWithData:meme.getData]];
        
        
        NSDate *creationDate = dateAndImageObject.createdAt;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm dd/MM yyyy"];
        [self.dates addObject:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:creationDate]]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.archiveMemesArray count];    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 235.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dateAndImage" forIndexPath:indexPath];
    
    cell.archiveImage.image = [self.images objectAtIndex:indexPath.row];
    
    cell.archiveDateLabel.text = [self.dates objectAtIndex:indexPath.section];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)imageLoader:(id)sender 
{
    [self getArhiveMemesFromParse];
}
@end
