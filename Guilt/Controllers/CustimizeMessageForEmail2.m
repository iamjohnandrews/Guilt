//
//  CustimizeMessageForEmail2.m
//  Guilt
//
//  Created by John Andrews on 8/24/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import "CustimizeMessageForEmail2.h"

@implementation CustimizeMessageForEmail2

- (id) activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
        return @"This is a #twitter post!";
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return @"This is a facebook post!";
    if ( [activityType isEqualToString:UIActivityTypeMessage] )
        return @"SMS message text";
    if ( [activityType isEqualToString:UIActivityTypeMail] )
        return @"Email text here!";
    if ( [activityType isEqualToString:@"it.albertopasca.myApp"] )
        return @"OpenMyapp custom text";
    return nil;
}
- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController { return @""; }
@end
