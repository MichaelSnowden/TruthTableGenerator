//
//  FileTableViewCell.m
//  Truth
//
//  Created by Michael Snowden on 9/21/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "FileTableViewCell.h"
#import "TruthTableFile.h"

@interface FileTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contingencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation FileTableViewCell

- (void)loadFile:(TruthTableFile *)file {
    _expressionLabel.text = file.expression;
    _contingencyLabel.text = file.contingency;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];

    _dateLabel.text = [[theDate stringByAppendingString:@" "] stringByAppendingString:theTime];
}

@end
