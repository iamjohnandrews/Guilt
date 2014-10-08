//
//  AddCharityViewController.m
//  Guilt
//
//  Created by John Andrews on 8/24/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "AddCharityViewController.h"

@implementation AddCharityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self setUpButtonsAndFonts];
    self.orgName.delegate = self;
    self.donationURL.delegate = self;
    self.conversionValue.delegate = self;
    
    //code to dismiss keyboard when user taps around textField
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark Validation Methods
- (BOOL)checkIfAnyTextFieldIsEmpty
{
    BOOL result;
    if (self.orgName.text.length == 0 || self.donationURL.text.length == 0 || self.conversionValue.text.length == 0 || self.selectedImage == nil) {
        result = YES;
        
    } else {
        if ([self checkIfValidURL]) {
            
            result = NO;
        } else {
            result = YES;
        }
    }
    return result;
}

- (BOOL)checkIfValidURL
{
    BOOL result;
    NSString *trimmedString = [self.donationURL.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange whiteSpaceRange = [trimmedString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        NSLog(@"Found whitespace");
        result = NO;
    } else {
        result = YES;
    }
    return result;
}

- (void)switchBackButtonToDoneButton
{
    [self.backButtonOutlet setTitle:@"Done" forState:UIControlStateNormal];
}

- (void)showAlerts
{
    
//    UIAlertView* alert1 = [[UIAlertView alloc] initWithTitle:@"Not Enough Information" message:@"Please complete all the text fields and add your organization's logo." delegate:self cancelButtonTitle:@"Got It" otherButtonTitles:nil];
//    [alert1 show];
    
    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:@"Invalid URL address" message:@"Please double check your orgnaization's donation page URL." delegate:self cancelButtonTitle:@"Will do" otherButtonTitles:nil];
    [alert2 show];
}

- (void)uploadCharityToParseWaitingList
{
    NSData *imageData = UIImagePNGRepresentation(self.selectedImage.image);
    
    //Upload a new picture
    //1
    PFFile *file = [PFFile fileWithName:@"img" data:imageData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            //2
            
            PFObject *potentialNewCharityObject = [PFObject objectWithClassName:@"WaitingList"];
            [potentialNewCharityObject setObject:file forKey:@"logo"];
            [potentialNewCharityObject setObject:self.orgName.text forKey:@"orgName"];
            [potentialNewCharityObject setObject:self.donationURL.text forKey:@"donationURL"];
            [potentialNewCharityObject setObject:self.conversionValue.text forKey:@"conversionValue"];
            
            //3
            [potentialNewCharityObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //4
                if (succeeded){
                    NSLog(@"successfully uploaded Charity Info to Parse");
                }
            }];
        }
        else{
            //5
            NSLog(@"Parse uplaed did not work. Error: %@", [[error userInfo] objectForKey:@"error"]);
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"For some reason we did not get your organization's information. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    } progressBlock:^(int percentDone) {
        NSLog(@"Uploaded: %d %%", percentDone);
    }];
}

- (IBAction)backButtonPressed:(id)sender
{
    if ([[(UIButton *)sender currentTitle] isEqualToString:@"Done"]) {
        [self uploadCharityToParseWaitingList];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectImageButtonPressed:(id)sender
{
    if ([[(UIButton *)sender currentTitle] isEqualToString:self.selectImageButtonOutlet.titleLabel.text]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"UIImagePickerController returns %@", info);
    self.selectedImage.image = [self resizeImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    self.selectImageButtonOutlet.hidden = YES;

    if (![self checkIfAnyTextFieldIsEmpty]) {
        [self switchBackButtonToDoneButton];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)usersLibraryImage
{
    CGSize newSize = CGSizeMake(320.0f, 240.0f);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [usersLibraryImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark TextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.conversionValue && textField.text.length  == 0)
    {
        textField.text = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    }
    
    self.backButtonOutlet.frame = CGRectMake(16.0f, 10.0f, 288.0f, 30.0f);
    [self.backButtonOutlet setTitle:@"Please complete all fields and add logo" forState:UIControlStateNormal];
    self.backButtonOutlet.userInteractionEnabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.backButtonOutlet.frame = CGRectMake(16.0f, 10.0f, 60.0f, 30.0f);
    [self.backButtonOutlet setTitle:@"Back" forState:UIControlStateNormal];
    self.backButtonOutlet.userInteractionEnabled = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.conversionValue) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        // Make sure that the currency symbol is always at the beginning of the string:
        if (![newText hasPrefix:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]])
        {
            return NO;
        }
    }
    
    // Default:
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.donationURL) {
        if ([self checkIfValidURL]) {
            [self showAlerts];
            return YES;
        }
    }
    if (![self checkIfAnyTextFieldIsEmpty]) {
        [self switchBackButtonToDoneButton];
    }
    
    return YES;
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)setUpButtonsAndFonts
{
    self.topInstructionsLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:15];
    self.topInstructionsLabel.textColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    self.topInstructionsLabel.text = @"Enter your charity's information in order to be added to search results.";
    self.topInstructionsLabel.numberOfLines = 0;
    
    self.conversionValueInstructionsLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:14];
    self.conversionValueInstructionsLabel.textColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    self.conversionValueInstructionsLabel.text = @"What dollar amount provides one unit of your charity's good or service?";
    self.conversionValueInstructionsLabel.numberOfLines = 0;
    
    self.backButtonOutlet.layer.cornerRadius = 8;
    self.backButtonOutlet.layer.borderWidth = 1;
    self.backButtonOutlet.layer.borderColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1].CGColor;
    self.backButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    self.backButtonOutlet.clipsToBounds = YES;
    [self.backButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButtonOutlet setTitle:@"Back" forState:UIControlStateNormal];
    self.backButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:14];
    
    self.selectImageButtonOutlet.layer.cornerRadius = 8;
    self.selectImageButtonOutlet.layer.borderWidth = 1;
    self.selectImageButtonOutlet.layer.borderColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1].CGColor;
    self.selectImageButtonOutlet.backgroundColor = [UIColor colorWithRed:117.0/255 green:135.0/255 blue:146.0/255 alpha:1];
    self.selectImageButtonOutlet.clipsToBounds = YES;
    [self.selectImageButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectImageButtonOutlet setTitle:@"Add Organization's Logo" forState:UIControlStateNormal];
    self.selectImageButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
}

@end
