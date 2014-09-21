//
//  UITextField+Cursor.m
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "UITextField+Cursor.h"

@implementation UITextField (Cursor)

- (void)offsetCursorBy:(int)n {
    UITextRange* selectedRange = self.selectedTextRange;

    UITextPosition *newPosition = [self positionFromPosition:selectedRange.start offset:n];
    UITextRange *newRange = [self textRangeFromPosition:newPosition toPosition:newPosition];
    [self setSelectedTextRange:newRange];
}

@end
