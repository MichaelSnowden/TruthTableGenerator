//
//  TruthTableInputAccessoryView.m
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "TruthTableInputAccessoryView.h"

@interface TruthTableInputAccessoryView()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *notButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *andButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nandButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *orButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *norButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *xorButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ifButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iffButton;

@end

@implementation TruthTableInputAccessoryView

- (void)loadPreferences {
    
}

- (IBAction)buttonWasPressed:(UIBarButtonItem *)button {
    [_truthTableDelegate truthTableInputAccessoryView:self didType:button.title];
}


@end
