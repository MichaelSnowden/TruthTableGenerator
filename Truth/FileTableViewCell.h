//
//  FileTableViewCell.h
//  Truth
//
//  Created by Michael Snowden on 9/21/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TruthTableFile;

@interface FileTableViewCell : UITableViewCell

- (void)loadFile:(TruthTableFile *)file;

@end
