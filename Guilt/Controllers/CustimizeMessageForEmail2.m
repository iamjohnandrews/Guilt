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
    NSString *emailWithLink = @"<html><body><ul><b>#KarmaScanFact</b></ul> <ul>You can download the app <a href='https://itunes.apple.com/us/app/karmascan/id739951142?mt=8'>here</a></ul></body></html>";

    
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
        return @"#KarmaScanFact";
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return @"#KarmaScanFact";
    if ( [activityType isEqualToString:UIActivityTypeMessage] )
        return @"#KarmaScanFact";
    if ( [activityType isEqualToString:UIActivityTypeMail] )
        return emailWithLink;

    return @"#KarmaScanFact";
}

- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType
{
    NSArray *subjectLines = @[@"Go figure...", @"Who knew...", @"Did you know...", @"The more you know...", @"I'm trying to help you!", @"Step up!", @"It's time..."];
    
    NSInteger randomNumber = arc4random() % subjectLines.count;
    
    return subjectLines[randomNumber];
}

@end
