//
//  PreferencesTableViewCell.m
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "PreferencesTableViewCell.h"

@implementation PreferencesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    [_delegate preferencesTableViewCell:self didChangeSegmentTo:sender.selectedSegmentIndex];
}

@end
