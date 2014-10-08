//
//  AddCharityViewController.h
//  Guilt
//
//  Created by John Andrews on 8/24/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCharityViewController : BaseViewController  <UITextFieldDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *orgName;
@property (weak, nonatomic) IBOutlet UITextField *donationURL;
@property (weak, nonatomic) IBOutlet UITextField *conversionValue;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *backButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *topInstructionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *conversionValueInstructionsLabel;


- (IBAction)backButtonPressed:(id)sender;

- (IBAction)selectImageButtonPressed:(id)sender;
@end
