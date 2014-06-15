//
//  ModalArchiveViewController.m
//  Guilt
//
//  Created by John Andrews on 6/14/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ModalArchiveViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface ModalArchiveViewController () <UIActivityItemSource, MFMessageComposeViewControllerDelegate>

@end

@implementation ModalArchiveViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Archive Share Meme";
    self.archiveImageToShare.image = self.sharingArchiveMeme;
    
    self.backToArchiveButtonOutlet.layer.cornerRadius = 8;
    self.backToArchiveButtonOutlet.layer.borderWidth = 1;
//    self.backToArchiveButtonOutlet.layer.borderColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1].CGColor;
    self.backToArchiveButtonOutlet.backgroundColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1];
    self.backToArchiveButtonOutlet.clipsToBounds = YES;
    [self.backToArchiveButtonOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backToArchiveButtonOutlet setTitle:@"Back to Archive" forState:UIControlStateNormal];
    self.backToArchiveButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.activitySheetEnabled) {
        [self shareActionSheet];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark Sharing & Action
- (void)shareActionSheet
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:@"#KarmaScanFact", self.sharingArchiveMeme, nil] applicationActivities:nil];
    
//    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
//        if (completed) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }];
        
    [self presentViewController:activityViewController animated:YES completion:^{
    }];
    self.activitySheetEnabled = NO;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"Placeholder";
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        [self postToFacebook];
        return @"facebook";
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        [self postToTwitter];
        return @"twiiter";
    } else if ([activityType isEqualToString:UIActivityTypeMail]) {
        [self composeEmailMessage];
        return @"email";
    } else if ([activityType isEqualToString:UIActivityTypeMessage]) {
        [self composeText];
        return @"text message";
    }
    
    return @"non sharing action";
}

#pragma mark Email & Texting
- (void)composeText
{
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    [self presentViewController:messageComposeViewController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"text sent");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)composeEmailMessage
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"KarmaScan is unable to access your email at this time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error) {
        NSLog(@"Error occured %@", error.description);
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"email cancellded");       
            break;
        case MFMailComposeResultSent:
            NSLog(@"email sent");
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Social Media
- (void)postToTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [twitterViewController setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             if (result == SLComposeViewControllerResultCancelled) {
                 NSLog(@"Twitter Result Cancelled");
             } 
         }];
        
        [self presentViewController:twitterViewController animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Currently, Twitter is not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)postToFacebook
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebookViewController setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             if (result == SLComposeViewControllerResultCancelled) {
                 NSLog(@"Facebook Result Cancelled");
             } 
         }];
        
        [self presentViewController:facebookViewController animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Currently, Facebook is not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (IBAction)backToArchiveButtonPressed:(id)sender 
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
