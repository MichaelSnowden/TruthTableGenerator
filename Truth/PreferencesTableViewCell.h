//
//  PreferencesTableViewCell.h
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PreferencesTableViewCell;
@protocol PreferencesTableViewCellDelegate <NSObject>

- (void)preferencesTableViewCell:(PreferencesTableViewCell *)cell didChangeSegmentTo:(NSInteger) segment;

@end

@interface PreferencesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property id<PreferencesTableViewCellDelegate> delegate;

@end
