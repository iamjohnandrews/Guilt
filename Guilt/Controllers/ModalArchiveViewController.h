//
//  ModalArchiveViewController.h
//  Guilt
//
//  Created by John Andrews on 6/14/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "BaseViewController.h"

@interface ModalArchiveViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *archiveImageToShare;
@property (strong, nonatomic) UIImage *sharingArchiveMeme;

@property (nonatomic) BOOL activitySheetEnabled;

@property (weak, nonatomic) IBOutlet UIButton *backToArchiveButtonOutlet;
- (IBAction)backToArchiveButtonPressed:(id)sender;

@end
