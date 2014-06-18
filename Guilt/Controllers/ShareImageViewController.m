//
//  ShareImageViewController.m
//  Guilt
//
//  Created by John Andrews on 5/3/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "ShareImageViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "ArchiveTableViewController.h"


@interface ShareImageViewController () <UIActivityItemSource, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>
@end

@implementation ShareImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"ShareImageViewController";
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarnaScan_Background"]];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([PFUser currentUser]) {
        self.archiveButtonOutlet.layer.cornerRadius = 8;
        self.archiveButtonOutlet.layer.borderWidth = 1;
        self.archiveButtonOutlet.layer.borderColor = [UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1].CGColor;
        self.archiveButtonOutlet.backgroundColor = [UIColor whiteColor];
        self.archiveButtonOutlet.clipsToBounds = YES;
        [self.archiveButtonOutlet setTitleColor:[UIColor colorWithRed:0.0/255 green:68.0/255 blue:94.0/255 alpha:1] forState:UIControlStateNormal];
        [self.archiveButtonOutlet setTitle:@"Your Archive" forState:UIControlStateNormal];
        self.archiveButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:20];
    } else {
        self.archiveButtonOutlet.hidden = YES;
    }
        
    
    [self.navigationItem setTitle:@"Let 'em Know"];

    self.sharingImage.image = self.unfinishedMeme;
    
//    [self replaceDonateButtonWithKarmaScnaLogo];
    
    [self shareActionSheet];
}

#pragma mark Create Meme
- (void)replaceDonateButtonWithKarmaScnaLogo
{   
    UIImageView * karmaScanK = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarmaSan_K_small.png"]];
    karmaScanK.frame = CGRectMake(self.sharingImage.bounds.size.width - 45, self.sharingImage.bounds.size.height - 46, 44, 44);
    [self.sharingImage addSubview:karmaScanK];
    
}

- (UIImage *)convertIntoFinalMemeToShare
{    
    UIGraphicsBeginImageContextWithOptions(self.sharingImage.bounds.size, NO, 0.0);
    
    [self.sharingImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *charityMeme = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return charityMeme;
}

#pragma mark Sharing & Action
- (void)shareActionSheet
{

//    UIImage *finialImage = [self convertIntoFinalMemeToShare];
    CGSize newSize = CGSizeMake(320.0f, 211.0f);

    UIGraphicsBeginImageContext(newSize);
    [[self convertIntoFinalMemeToShare] drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:@"#KarmaScanFact", newImage, nil] applicationActivities:nil];
    
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if (completed) {
            if ([PFUser currentUser]) {
                [self uploadImageToParse:newImage];
            }
        }
    }];
    
    [self presentViewController:activityViewController animated:YES completion:^{
    }];
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

- (IBAction)shareButtonPressed:(id)sender 
{
    [self shareActionSheet];
}

- (IBAction)archiveButtonPressed:(id)sender 
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"ShareImageViewController"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:self.archiveButtonOutlet.titleLabel.text
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
}

- (void)uploadImageToParse:(UIImage *)charityMeme
{
    NSData *imageData = UIImagePNGRepresentation(charityMeme);

    //Upload a new picture
    //1
    PFFile *file = [PFFile fileWithName:@"img" data:imageData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            //2
            
            PFObject *imageObject = [PFObject objectWithClassName:@"CharityMemes"];
            [imageObject setObject:[PFUser currentUser] forKey:@"User"];
            [imageObject setObject:file forKey:@"image"];
            
            //3
            [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //4
                if (succeeded){
                    NSLog(@"successful image upload to Parse");
                }
                else{
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
            }];
        }
        else{
            //5
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }        
    } progressBlock:^(int percentDone) {
        NSLog(@"Uploaded: %d %%", percentDone);
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShareToArchiveSegue"]) {
        ArchiveTableViewController * archiveVC = [segue destinationViewController];
        archiveVC.imageTransformEnabled = YES;
    } 
}

@end
