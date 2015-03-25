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
#import "CustimizeMessageForEmail2.h"
#import "ImageSaver.h"


@interface ShareImageViewController () <UIActivityItemSource, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) ImageSaver *imageSaver;
@end

@implementation ShareImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"ShareImageViewController";
    self.imageSaver = [[ImageSaver alloc] init];
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

//    [self.sharingImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self shareActionSheet];
}

 - (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.sharingImage.image = self.unfinishedMeme;
    [GoogleAnalytics trackAnalyticsForScreen:self.screenName];
}

#pragma mark Sharing & Action
- (void)shareActionSheet
{
    /*NSString *message =@"#KarmaScan is great!";
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:message, self.unfinishedMeme, nil] applicationActivities:nil];
    
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if (completed) {
            if ([PFUser currentUser]) {
                [self uploadImageToParse:self.sharingImage.image];
            }
        }
    }];
    
    [self presentViewController:activityViewController animated:YES completion:^{
    }];*/
    
    
    //---------------------------------------
   CustimizeMessageForEmail2 *ActivityProvider = [[CustimizeMessageForEmail2 alloc] init];
    NSArray *Items = @[self.unfinishedMeme, ActivityProvider];
    
    UIActivityViewController *ActivityView = [[UIActivityViewController alloc] initWithActivityItems:Items applicationActivities:nil];
        
    [self presentViewController:ActivityView animated:YES completion:nil];

    [ActivityView setCompletionHandler:^(NSString *act, BOOL done)
     {
         if ( done )
         {
             if ([PFUser currentUser]) {
                 [self uploadImageToParse:self.sharingImage.image];
             }
         }
     }];
    
}
//now irrelevant
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"KarmaScan is unable to access your email at this time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
    [GoogleAnalytics trackAnalyticsForAction:@"touch" withLabel:@"Share Button" onScreen:self.screenName];
    [self shareActionSheet];
}

- (IBAction)archiveButtonPressed:(id)sender 
{
    [GoogleAnalytics trackAnalyticsForAction:@"touch" withLabel:self.archiveButtonOutlet.titleLabel.text onScreen:self.screenName];
}


- (NSString *)convertNSDateToImageTitleString
{
    NSDate *creationDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee, MMMM dd, yyyy"];
    
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:creationDate]];
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
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self saveImageLocally:charityMeme withIdentifier:imageObject.objectId];
                    });
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

- (void)saveImageLocally:(UIImage *)meme withIdentifier:(NSString *)objectID
{
    NSArray *usersDiffLoginsArray = [[NSArray alloc] initWithArray:[UsersLoginInfo getUsersObjectID]];
    
    for (NSString *loginID in usersDiffLoginsArray) {
        [self.imageSaver saveMemeToArchiveDisk:@[meme] forUser:loginID  withIdentifier:@[objectID]];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShareToArchiveSegue"]) {
        ArchiveTableViewController * archiveVC = [segue destinationViewController];
        archiveVC.segueingFromUserProfileOrShareVC = YES;
    } 
}

@end
