//
//  UISegmentedControl+SetNumberOfSegments.m
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "UISegmentedControl+SetSegments.h"

@implementation UISegmentedControl (SetSegments)

- (void)setSegments: (NSArray *)segments {
    while ([self numberOfSegments] > 0) {
        [self removeSegmentAtIndex:0 animated:NO];
    }
    
    for (NSString *segment in segments) {
        [self insertSegmentWithTitle:segment atIndex:[self numberOfSegments] animated:NO];
    }
}

@end
