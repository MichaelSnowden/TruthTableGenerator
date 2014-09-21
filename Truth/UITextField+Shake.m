//
//  UITextField+Shake.m
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "UITextField+Shake.h"

@implementation UITextField (Shake)
- (void)shake: (int) n {
    static int direction = 1;
    [UIView animateWithDuration:0.03 animations:^{
         self.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished) {
         if(n < 0) {
             self.transform = CGAffineTransformIdentity;
             return;
         }
         direction *= -1;
        [self shake: n - 1];
     }];
}

@end
