//
//  TruthTableInputAccessoryView.m
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "TruthTableInputAccessoryView.h"
#import "Preferences.h"

@interface TruthTableInputAccessoryView() <PreferencesDelegate>

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

- (IBAction)buttonWasPressed:(UIBarButtonItem *)button {
    [[UIDevice currentDevice] playInputClick];
    [_truthTableDelegate truthTableInputAccessoryView:self didType:button.title];
}

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[Preferences sharedPreferences] setDelegate:self];
    [self loadPreferences];
}

- (void)preferencesDidSave {
    [self loadPreferences];
}

- (void)loadPreferences {
    Preferences *preferences = [Preferences sharedPreferences];
    _notButton.title  = [[preferences dictionary] objectForKey:kNotOperatorKey];
    _andButton.title  = [[preferences dictionary] objectForKey:kAndOperatorKey];
    _nandButton.title = [[preferences dictionary] objectForKey:kNandOperatorKey];
    _orButton.title   = [[preferences dictionary] objectForKey:kOrOperatorKey];
    _norButton.title  = [[preferences dictionary] objectForKey:kNotOperatorKey];
    _xorButton.title  = [[preferences dictionary] objectForKey:kXorOperatorKey];
    _ifButton.title   = [[preferences dictionary] objectForKey:kIfOperatorKey];
    _iffButton.title  = [[preferences dictionary] objectForKey:kIffOperatorKey];
}

@end
