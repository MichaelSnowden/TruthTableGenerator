//
//  Preferences.m
//  Truth
//
//  Created by Michael Snowden on 9/20/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "Preferences.h"

NSString *const kPreferencesKey  = @"Preferences";

NSString *const kNotOperatorKey  = @"NOT";
NSString *const kAndOperatorKey  = @"AND";
NSString *const kNandOperatorKey = @"NAND";
NSString *const kOrOperatorKey   = @"OR";
NSString *const kNorOperatorKey  = @"NOR";
NSString *const kXorOperatorKey  = @"XOR";
NSString *const kIfOperatorKey   = @"IF";
NSString *const kIffOperatorKey  = @"IFF";

NSString *const kDictionaryKey   = @"dictionary";

@implementation Preferences

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.dictionary = [[aDecoder decodeObjectForKey:kDictionaryKey] mutableCopy];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dictionary forKey:kDictionaryKey];
}

+ (NSDictionary *)allOperatorSymbols {
    static NSDictionary *allOperatorSymbols = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        allOperatorSymbols = @{kNotOperatorKey : @[@"¬", @"!", @"~", @"'"],
                               kAndOperatorKey : @[@"^", @"∧", @"&", @"*"],
                               kNandOperatorKey : @[@"|", @"⊼"],
                               kOrOperatorKey : @[@"+", @"∨"],
                               kNorOperatorKey : @[@"-", @"↓", @"⊽"],
                               kXorOperatorKey : @[@"⊕", @"⊻"],
                               kIfOperatorKey : @[@"⇒", @"→", @"⊃"],
                               kIffOperatorKey : @[@"⇔", @"≡", @"="]
                               };
    });
    
    return allOperatorSymbols;
}

+ (Preferences *)sharedPreferences {
    static Preferences *preferences = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [standardDefaults objectForKey:kPreferencesKey];
        if (data == nil) {
            preferences = [Preferences new];
            preferences.dictionary = [@{kNotOperatorKey  : @"¬",
                                       kAndOperatorKey  : @"∧",
                                       kNandOperatorKey : @"⊼",
                                       kOrOperatorKey   : @"∨",
                                       kNorOperatorKey  : @"⊽",
                                       kXorOperatorKey  : @"⊻",
                                       kIfOperatorKey   : @"⇒",
                                       kIffOperatorKey  : @"⇔"
                                       } mutableCopy];
            data = [NSKeyedArchiver archivedDataWithRootObject:preferences];
            [standardDefaults setObject:data forKey:kPreferencesKey];
        } else {
            preferences = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    });
    
    return preferences;
}

+ (void)savePreferences {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[Preferences sharedPreferences]] forKey:kPreferencesKey];
}

@end
