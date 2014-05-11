//
//  Comms.h
//  Guilt
//
//  Created by John Andrews on 5/10/14.
//  Copyright (c) 2014 John Andrews. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommsDelegate <NSObject>
@optional
- (void) commsDidLogin:(BOOL)loggedIn;
- (void) commsUploadImageProgress:(short)progress;
- (void) commsUploadImageComplete:(BOOL)success;

@end

@interface Comms : NSObject
+ (void) login:(id<CommsDelegate>)delegate;

+ (void) uploadImage:(UIImage *)image forDelegate:(id<CommsDelegate>)delegate;
@end

