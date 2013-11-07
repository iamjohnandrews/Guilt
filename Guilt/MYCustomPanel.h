//
//  MYCustomPanel.h
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/17/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYIntroductionPanel.h"
#import "SwitchToLoginDelegate.h"

@interface MYCustomPanel : MYIntroductionPanel <UITextViewDelegate, SwitchToLoginDelegate> {
    
    __weak IBOutlet UIView *CongratulationsView;
}


@property (weak,nonatomic) id <SwitchToLoginDelegate> delegate;

- (IBAction)didPressEnable:(id)sender;


@end
