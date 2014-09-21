//
//  Preferences.h
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kNotOperatorKey;
extern NSString *const kAndOperatorKey;
extern NSString *const kNandOperatorKey;
extern NSString *const kOrOperatorKey;
extern NSString *const kNorOperatorKey;
extern NSString *const kXorOperatorKey;
extern NSString *const kIfOperatorKey;
extern NSString *const kIffOperatorKey;

@interface Preferences : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableDictionary *dictionary;

+ (NSDictionary *) allOperatorSymbols;
+ (Preferences *) sharedPreferences;
+ (void) savePreferences;

@end
