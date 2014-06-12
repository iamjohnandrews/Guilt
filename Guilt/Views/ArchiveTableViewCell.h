//
//  ArchiveTableViewCell.h
//  Guilt
//
//  Created by John Andrews on 6/12/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *archiveDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *archiveImage;
@end
