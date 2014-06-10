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
#import "Comms.h"

@interface ShareImageViewController () <UIActivityItemSource, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, CommsDelegate>
@end

@implementation ShareImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarnaScan_Background"]];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationItem setTitle:@"Let 'em Know"];
    
    self.sharingImage.image = self.unfinishedMeme;
    
    [self replaceDonateButtonWithKarmaScnaLogo];
    
    [self shareActionSheet];
}

#pragma mark Create Meme
- (void)replaceDonateButtonWithKarmaScnaLogo
{
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = self.sharingImage.layer.bounds;
//    
//    gradientLayer.colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor],
//                             (id)[[UIColor clearColor] CGColor],
//                             (id)[[UIColor clearColor] CGColor]];
//    gradientLayer.locations = @[@0.0, @0.05, @0.15];
//    [self.sharingImage.layer addSublayer:gradientLayer];  
//    
//    UILabel *converstionAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 0, CGRectGetWidth(self.view.bounds) - 60.0f, 20.0f)];
//    NSAttributedString *charityEquivalentText = [[NSAttributedString alloc] initWithString:[[NSString stringWithFormat:@"$%@ is equivalent to", self.productPrice] uppercaseString] attributes:@{NSStrokeWidthAttributeName: @-2, NSStrokeColorAttributeName: [UIColor blackColor]}];
//    converstionAmountLabel.attributedText = charityEquivalentText;
//    converstionAmountLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:14];
//    converstionAmountLabel.textColor = [UIColor whiteColor];
//    converstionAmountLabel.textAlignment = NSTextAlignmentCenter;
//    [self.sharingImage addSubview:converstionAmountLabel];
    
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
    UIImage * finialImage = [self convertIntoFinalMemeToShare];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:@"#KarmaScanFact", finialImage, nil] applicationActivities:nil];
    
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if (completed) {
            [self uploadImageToParse:finialImage];
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

- (void)uploadImageToParse:(UIImage *)charityMeme
{
    NSData *imageData = UIImagePNGRepresentation(charityMeme);

    //Upload a new picture
    //1
    PFFile *file = [PFFile fileWithName:@"img" data:imageData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            //2
            
            PFObject *imageObject = [PFObject objectWithClassName:@"charityMemeObject"];
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
@end
