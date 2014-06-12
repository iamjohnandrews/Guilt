//
//  ArchiveViewController.m
//  Guilt
//
//  Created by John Andrews on 6/11/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ArchiveViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import <Parse/Parse.h>
#import "ArchiveCollectionViewCell.h"

@interface ArchiveViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *archiveMemesArray;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, strong) ArchiveCollectionViewCell *archiveCell;
@end

@implementation ArchiveViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    if (!self.archiveMemesArray) {
        [self getArhiveMemesFromParse];
    }
    
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 44);
        
        // Setting the minimum size equal to the reference size results
        // in disabled parallax effect and pushes up while scrolls
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(320, 44);
    }
    
    self.archiveCell = [[ArchiveCollectionViewCell alloc] init];
    
}

- (void)getArhiveMemesFromParse
{
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
            NSLog(@"successfully retrieved %d images from Parse =%@", self.archiveMemesArray.count, self.archiveMemesArray);
            
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

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView 
{
//    return [self.archiveMemesArray count];
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section 
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    self.archiveCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
//    self.archiveCell.archivedMemeImage = [self.images objectAtIndex:indexPath.row];
//    
//    return self.archiveCell;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    self.archiveCell.archivedMemeImage = [self.images objectAtIndex:indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *dateCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"sectionHeader"
                                                                                   forIndexPath:indexPath];
    
    self.archiveCell.dateLadel.text = [self.dates objectAtIndex:indexPath.section];
    
    return dateCell;
}

@end
