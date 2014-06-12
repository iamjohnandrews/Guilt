//
//  ArchiveCollectionViewCell.h
//  Guilt
//
//  Created by John Andrews on 6/11/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLadel;

@property (weak, nonatomic) IBOutlet UIImageView *archivedMemeImage;
@end
