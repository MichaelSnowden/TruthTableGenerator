//
//  Preferences.h
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kDictionaryKey;

extern NSString *const kNotOperatorKey;
extern NSString *const kAndOperatorKey;
extern NSString *const kNandOperatorKey;
extern NSString *const kOrOperatorKey;
extern NSString *const kNorOperatorKey;
extern NSString *const kXorOperatorKey;
extern NSString *const kIfOperatorKey;
extern NSString *const kIffOperatorKey;

@class Preferences;
@protocol PreferencesDelegate

- (void)preferencesDidSave;

@end

@interface Preferences : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property id<PreferencesDelegate> delegate;

+ (NSDictionary *) allOperatorSymbols;
+ (Preferences *) sharedPreferences;
+ (void) savePreferences;

@end
