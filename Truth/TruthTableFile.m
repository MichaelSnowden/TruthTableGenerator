//
//  TruthTableFile.m
//  Truth
//
//  Created by Michael Snowden on 9/21/14.
//  Copyright (c) 2014 MichaelSnowden. All rights reserved.
//

#import "TruthTableFile.h"
#import <UIKit/UIKit.h>

NSString *const kFilesKey               = @"Files";

NSString *const kFilePathKey            = @"FilePath";
NSString *const kFileDateKey            = @"Date";
NSString *const kFileExpressionKey      = @"Expression";
NSString *const kFileNumTruthsKey       = @"NumTruths";
NSString *const kFileNumPropositionsKey = @"NumPropositions";

@implementation TruthTableFile

- (id)initWithExpression:(NSString *)expression CSV:(NSString *)csv numTruths:(NSUInteger)numTruths numPropositions:(NSUInteger)numPropositions {
    if (self = [super init]) {
        _expression = expression;
        _csv = csv;
        _numTruths = numTruths;
        _numPropositions = numPropositions;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _expression = [aDecoder decodeObjectForKey:kFileExpressionKey];
        _filePath = [aDecoder decodeObjectForKey:kFilePathKey];
        _csv = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
        _numTruths = [[aDecoder decodeObjectForKey:kFileNumTruthsKey] integerValue];
        _numPropositions = [[aDecoder decodeObjectForKey:kFileNumPropositionsKey] integerValue];
        _date = [aDecoder decodeObjectForKey:kFileDateKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_expression forKey:kFileExpressionKey];
    [aCoder encodeObject:_filePath forKey:kFilePathKey];
    [aCoder encodeObject:@(_numTruths) forKey:kFileNumTruthsKey];
    [aCoder encodeObject:@(_numPropositions) forKey:kFileNumPropositionsKey];
    [aCoder encodeObject:_date forKey:kFileDateKey];
}

+ (void)saveFile:(TruthTableFile *)file {
    file.date = [NSDate date];
    
    NSArray *files = [TruthTableFile allFiles];
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"TruthTable-%i.csv", [files count] + 1]];
    
    NSError *error;
    [file.csv writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
    if (error != nil) {
        NSLog(@"Error: %@", error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error saving file" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    file.filePath = filePath;
    ;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (files == nil) {
        files = @[[NSKeyedArchiver archivedDataWithRootObject:file]];
    } else {
        files = [files arrayByAddingObject:[NSKeyedArchiver archivedDataWithRootObject:file]];
    }
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:files] forKey:kFilesKey];
}

+ (void)deleteFileAtIndex:(NSUInteger) index {
    NSMutableArray *files = [[TruthTableFile allFiles] mutableCopy];
    [files removeObjectAtIndex:index];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:files] forKey:kFilesKey];
}

+ (NSArray *)allFiles {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kFilesKey]];
}

- (NSString *)contingency {
    NSString *contingency;
    if (_numTruths == 0) {
        contingency = @"Contradiction";
    } else if (_numTruths == _numPropositions) {
        contingency = @"Tautology";
    } else {
        contingency = @"Contingency";
    }
    
    return [contingency stringByAppendingString:[NSString stringWithFormat:@" (%i/%i)", _numTruths, _numPropositions]];
}

@end
