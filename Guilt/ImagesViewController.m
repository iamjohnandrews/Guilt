//
//  ImagesViewController.m
//  Guilt
//
//  Created by John Andrews on 10/29/13.
//  Copyright (c) 2013 John Andrews. All rights reserved.
//

#import "ImagesViewController.h"
#import "ConversionViewController.h"
#import "Cell.h"

@interface ImagesViewController (){
    NSArray* charityImagesArray;
    NSArray* charityDiscriptionsArray;

}

@end

@implementation ImagesViewController
@synthesize charityValueDisplayLabel, resultOfCharitableConversionsArray;

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
    NSLog(@"content of the resultOfCharitableConversionsArray %@", resultOfCharitableConversionsArray);
    
    charityImagesArray = @[@"africanWellFund.jpg", @"feedTheChildren2.jpg", @"soldiers.jpg", @"TheAnimalRescueSite.jpg", @"Unicef.jpeg"];
    
    charityDiscriptionsArray = @[@"animal meals through The Animal Rescue Site",
                                 @"military care package through Soildier's Angels",
                                 @"month of food, water, education, and medical supplies for a student through Feed The Children",
                                 @"natural spring catchment serving 250 people through African Well Fund",
                                 @"month of providing children with lifesaving vaccines, relief after natural disasters & schooling through Unicef"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CharityDisplay";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.imageView.image = [UIImage imageNamed:[charityImagesArray objectAtIndex:indexPath.row]];
    
    cell.cellLabel.text = [NSString stringWithFormat:@"%@ %@", [resultOfCharitableConversionsArray objectAtIndex:indexPath.row], [charityDiscriptionsArray objectAtIndex:indexPath.row] ];
    
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
