//
//  TruthTableInputAccessoryView.h
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TruthTableInputAccessoryView;

@protocol TruthTableInputAccessoryViewDelegate <NSObject>

- (void)truthTableInputAccessoryView:(TruthTableInputAccessoryView *) inputView didType:(NSString *)string;

@end

@interface TruthTableInputAccessoryView : UIToolbar

@property (nonatomic, strong) id<TruthTableInputAccessoryViewDelegate> truthTableDelegate;

- (void) loadPreferences;

@end
