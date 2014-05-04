//
//  ShareImageViewController.h
//  Guilt
//
//  Created by John Andrews on 5/3/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareImageViewController : BaseViewController
@property (strong, nonatomic) UIImage *unfinishedMeme;
@property (weak, nonatomic) IBOutlet UIImageView *sharingImage;
@property (weak,nonatomic) NSString* productPrice;
- (IBAction)shareButtonPressed:(id)sender;

@end
