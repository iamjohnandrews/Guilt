//
//  ArchiveViewController.m
//  Guilt
//
//  Created by John Andrews on 6/11/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ArchiveViewController.h"
//#import "CSStickyHeaderFlowLayout.h"
#import <Parse/Parse.h>

@interface ArchiveViewController ()
@property (nonatomic, strong) NSArray *archiveMemesArray;

@end

@implementation ArchiveViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.archiveMemesArray) {
        [self getArhiveMemesFromParse];
    }
    
//    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
//    
//    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
//        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 200);
//    }
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
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //3 
        if (!error) {
            //Everything was correct, put the new objects and load the wall
            self.archiveMemesArray = nil;
            self.archiveMemesArray = [[NSArray alloc] initWithArray:objects];
            
            NSLog(@"successfully retrieved %d images from Parse =%@", self.archiveMemesArray.count, self.archiveMemesArray);
            
        } else {
            
            //4
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

#pragma mark UICollectionViewDataSource
/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView 
{
    return [self.archiveMemesArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section 
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *obj = self.sections[indexPath.section];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                             forIndexPath:indexPath];
    
    cell.textLabel.text = [[obj allValues] firstObject];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        NSDictionary *obj = self.sections[indexPath.section];
        
        CSCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"sectionHeader"
                                                                 forIndexPath:indexPath];
        
        cell.textLabel.text = [[obj allKeys] firstObject];
        
        return cell;
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];
        
        return cell;
    }
    return nil;
}
*/
@end
