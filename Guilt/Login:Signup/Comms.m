//
//  Comms.m
//  Guilt
//
//  Created by John Andrews on 5/10/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "Comms.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
@class UsersLoginInfo;

@implementation Comms

+ (void) login:(id<CommsDelegate>)delegate
{
	// Basic User information and your friends are part of the standard permissions
	// so there is no reason to ask for additional permissions
	[PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
		// Was login successful ?
		if (!user) {
			if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                NSLog(@"An error occurred: %@", error.localizedDescription);
            }
            
			// Callback - login failed
			if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
				[delegate commsDidLogin:NO];
			}
		} else {
			if (user.isNew) {
				NSLog(@"User signed up and logged in through Facebook!");
			} else {
				NSLog(@"User logged in through Facebook!");
			}
            
			// Callback - login successful
			if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
				[delegate commsDidLogin:YES];
                if (![UsersLoginInfo checkIfLoginInfoAlreadySaved:@"facebook"]) {
                    [UsersLoginInfo saveLoginInfoToNSUserDefaults:@"facebook" and:[[PFUser currentUser] objectId]];
                }
			}
		}
	}];
}

#pragma mark Upload Image to Parse
+ (void) uploadImage:(UIImage *)image forDelegate:(id<CommsDelegate>)delegate
{
    NSData *imageData = UIImagePNGRepresentation(image);

    PFFile *imageFile = [PFFile fileWithName:@"img" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *charityMeme = [PFObject objectWithClassName:@"charityMeme"];
            charityMeme[@"image"] = imageFile;
            charityMeme[@"user"] = [PFUser currentUser].username;
        }
    } progressBlock:^(int percentDone) {

    }];
}

@end
