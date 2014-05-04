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

@interface ShareImageViewController () <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) ACAccount *accountStore;
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
    [self setFontFamily:@"Quicksand-Regular" forView:self.view andSubViews:YES];
    
    self.sharingImage.image = self.unfinishedMeme;
    
    [self prepareImageToBecomeMeme];
}

- (void)prepareImageToBecomeMeme
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.sharingImage.layer.bounds;
    
    gradientLayer.colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor],
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor clearColor] CGColor]];
    gradientLayer.locations = @[@0.0, @0.1, @0.2];
    [self.sharingImage.layer addSublayer:gradientLayer];  
    
    UILabel *converstionAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 0, CGRectGetWidth(self.view.bounds) - 60.0f, 20.0f)];
    converstionAmountLabel.text = [NSString stringWithFormat:@"$%@ is equivalent to", self.productPrice];
    converstionAmountLabel.textColor = [UIColor whiteColor];
    converstionAmountLabel.textAlignment = NSTextAlignmentCenter;
    [self.sharingImage addSubview:converstionAmountLabel];
    
    UIImageView * karmaScanK = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KarmaSan_K_small.png"]];
    karmaScanK.frame = CGRectMake(self.sharingImage.bounds.size.width - 44, self.sharingImage.bounds.size.height - 46, 44, 44);
    [self.sharingImage addSubview:karmaScanK];
    
    
}

- (UIImage *)convertIntoFinalMemeToShare
{
    UIGraphicsBeginImageContextWithOptions(self.sharingImage.bounds.size, self.sharingImage.opaque, 0.0);
    [self.sharingImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *charityMeme = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return charityMeme;
}

- (void)composeEmailMessage
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *emailViewController = [[MFMailComposeViewController alloc] init];
        emailViewController.mailComposeDelegate = self;
        [emailViewController setToRecipients:[[NSArray alloc] initWithObjects:@"johnnydrews@gmail.com", nil]];
        [emailViewController setTitle:@"Did you know"];
        
        NSData *charityImageData = UIImagePNGRepresentation(self.sharingImage.image);
        [emailViewController addAttachmentData:charityImageData mimeType:@"KarmaScan" fileName:nil];
        
        [self presentViewController:emailViewController animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Currently, Twitter is not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
            NSLog(@"messaged cancelded");       
            break;
        case MFMailComposeResultSent:
            NSLog(@"message sent");
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postToTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [twitterViewController addImage:self.sharingImage.image];
        
        [twitterViewController setInitialText:@"Did you know"];
        
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
        
        //add image
        [facebookViewController addImage:self.sharingImage.image];
        
        //write message
        [facebookViewController setInitialText:@"Did you know"];
        
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
    
    /*
    //get FB account
    self.accountStore = [[ACAccount alloc] init];
    ACAccountType *facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    self.accountStore 

    //accces FB users account
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    SLRequest * request = [SLRequest requestForServiceType:SLServiceTypeFacebook 
                                             requestMethod:SLRequestMethodGET
                                                       URL:requestURL
                                                parameters:nil];
    request.account = self.facebookAccount;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        <#code#>
    }];
*/
}

-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }     
} 

@end
